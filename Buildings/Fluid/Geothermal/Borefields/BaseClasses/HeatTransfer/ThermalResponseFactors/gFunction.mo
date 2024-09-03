within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors;
function gFunction
  "Evaluate the g-function of a bore field"
  extends Modelica.Icons.Function;

  input Integer nBor "Number of boreholes";
  input Modelica.Units.SI.Position cooBor[nBor,2] "Coordinates of boreholes";
  input Modelica.Units.SI.Height hBor "Borehole length";
  input Modelica.Units.SI.Height dBor "Borehole buried depth";
  input Modelica.Units.SI.Radius rBor "Borehole radius";
  input Modelica.Units.SI.ThermalDiffusivity aSoi
    "Ground thermal diffusivity used in g-function evaluation";
  input Integer nSeg "Number of line source segments per borehole";
  input Integer nTimSho "Number of time steps in short time region";
  input Integer nTimLon "Number of time steps in long time region";
  input Real ttsMax "Maximum adimensional time for gfunc calculation";
  input Integer nClu "Number of clusters";
  input Integer labels[nBor] "Cluster label associated with each data point";
  input Integer cluSiz[nClu] "Size of the clusters";
  input Real relTol = 0.02 "Relative tolerance on distance between boreholes";

  output Modelica.Units.SI.Time tGFun[nTimSho + nTimLon]
    "Time of g-function evaluation";
  output Real g[nTimSho+nTimLon] "g-function";

protected
  Modelica.Units.SI.Time ts=hBor^2/(9*aSoi) "Characteristic time";
  Modelica.Units.SI.Time tSho_min=1 "Minimum time for short time calculations";
  Modelica.Units.SI.Time tSho_max=3600
    "Maximum time for short time calculations";
  Modelica.Units.SI.Time tLon_min=tSho_max
    "Minimum time for long time calculations";
  Modelica.Units.SI.Time tLon_max=ts*ttsMax
    "Maximum time for long time calculations";
  Modelica.Units.SI.Time tSho[nTimSho]
    "Time vector for short time calculations";
  Modelica.Units.SI.Time tLon[nTimLon] "Time vector for long time calculations";
  Integer n_max = max(cluSiz.*cluSiz);
  Modelica.Units.SI.Distance dis[nClu,nClu,n_max] "Separation distance between boreholes";
  Modelica.Units.SI.Distance dis_ij "Separation distance between boreholes";
  Integer wDis[nClu,nClu,n_max] "Number of occurence of separation distances";
  Integer n_dis[nClu,nClu];
  Modelica.Units.SI.Radius rLin=0.0005*hBor
    "Radius for evaluation of same-borehole line source solutions";
  Real hSegRea[nSeg] "Real part of the FLS solution";
  Real hSegMir[2*nSeg-1] "Mirror part of the FLS solution";
  Modelica.Units.SI.Height dSeg "Buried depth of borehole segment";
  Real A[nSeg*nClu+1, nSeg*nClu+1] "Coefficient matrix for system of equations";
  Real B[nSeg*nClu+1] "Coefficient vector for system of equations";
  Real X[nSeg*nClu+1] "Solution vector for system of equations";
  Real FLS "Finite line source solution";
  Real ILS "Infinite line source solution";
  Real CHS "Cylindrical heat source solution";
  Boolean found "Flag, true if a cluster has been found";

algorithm
  // Distances between borehole clusters
  n_dis := zeros(nClu,nClu);
  wDis := zeros(nClu,nClu,n_max);
  for i in 1:nBor loop
    for j in i:nBor loop
      // Distance between boreholes
      if i <> j then
        dis_ij := sqrt((cooBor[i,1] - cooBor[j,1])^2 + (cooBor[i,2] - cooBor[j,2])^2);
      else
        dis_ij := rLin;
      end if;
      found := false;
      for n in 1:n_dis[labels[i],labels[j]] loop
        if abs(dis_ij - dis[labels[i],labels[j],n]) / dis[labels[i],labels[j],n] < relTol then
          wDis[labels[i],labels[j],n] := wDis[labels[i],labels[j],n] + 1;
          found := true;
          if i <> j then
            wDis[labels[j],labels[i],n] := wDis[labels[j],labels[i],n] + 1;
          end if;
          break;
        end if;
      end for;
      if not found then
        n_dis[labels[i],labels[j]] := n_dis[labels[i],labels[j]] + 1;
        wDis[labels[i],labels[j],n_dis[labels[i],labels[j]]] := wDis[labels[i],labels[j],n_dis[labels[i],labels[j]]] + 1;
        dis[labels[i],labels[j],n_dis[labels[i],labels[j]]] := dis_ij;
        if i <> j then
          n_dis[labels[j],labels[i]] := n_dis[labels[j],labels[i]] + 1;
          wDis[labels[j],labels[i],n_dis[labels[j],labels[i]]] := wDis[labels[j],labels[i],n_dis[labels[j],labels[i]]] + 1;
          dis[labels[j],labels[i],n_dis[labels[j],labels[i]]] := dis_ij;
        end if;
      end if;
    end for;
  end for;

  // Generate geometrically expanding time vectors
  tSho :=
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.timeGeometric(
      tSho_min, tSho_max, nTimSho);
  tLon :=
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.timeGeometric(
      tLon_min, tLon_max, nTimLon);
  // Concatenate the short- and long-term parts
  tGFun := cat(1, {0}, tSho[1:nTimSho - 1], tLon);

  // -----------------------
  // Short time calculations
  // -----------------------
  g[1] := 0.;
  for k in 1:nTimSho loop
    // Finite line source solution
    FLS :=
      Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource(
      tSho[k],
      aSoi,
      rLin,
      hBor,
      dBor,
      hBor,
      dBor);
    // Infinite line source solution
    ILS := 0.5*
      Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.infiniteLineSource(
      tSho[k],
      aSoi,
      rLin);
    // Cylindrical heat source solution
    CHS := 2*Modelica.Constants.pi*
      Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.cylindricalHeatSource(
      tSho[k],
      aSoi,
      rBor,
      rBor);
    // Correct finite line source solution for cylindrical geometry
    g[k+1] := FLS + (CHS - ILS);
  end for;

  // ----------------------
  // Long time calculations
  // ----------------------
  // Initialize coefficient matrix A
  for m in 1:nClu loop
    for u in 1:nSeg loop
      // Tb coefficient in spatial superposition equations
      A[(m-1)*nSeg+u,nClu*nSeg+1] := -1;
      // Q coefficient in heat balance equation
      A[nClu*nSeg+1,(m-1)*nSeg+u] := cluSiz[m];
    end for;
  end for;
  // Initialize coefficient vector B
  // The total heat extraction rate is constant
  B[nClu*nSeg+1] := nBor*nSeg;

  // Evaluate thermal response matrix at all times
  for k in 1:nTimLon-1 loop
    for i in 1:nClu loop
      for j in i:nClu loop
        // Evaluate Real and Mirror parts of FLS solution
        // Real part
        for m in 1:nSeg loop
          hSegRea[m] :=
            Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Equivalent(
              tLon[k + 1],
              aSoi,
              dis[i,j,1:n_dis[i,j]],
              wDis[i,j,1:n_dis[i,j]],
              hBor/nSeg,
              dBor,
              hBor/nSeg,
              dBor + (m - 1)*hBor/nSeg,
              cluSiz[i],
              n_dis[i,j],
              includeMirrorSource=false);
        end for;
        // Mirror part
        for m in 1:(2*nSeg-1) loop
          hSegMir[m] :=
            Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Equivalent(
              tLon[k + 1],
              aSoi,
              dis[i,j,1:n_dis[i,j]],
              wDis[i,j,1:n_dis[i,j]],
              hBor/nSeg,
              dBor,
              hBor/nSeg,
              dBor + (m - 1)*hBor/nSeg,
              cluSiz[i],
              n_dis[i,j],
              includeRealSource=false);
        end for;
        // Add thermal response factor to coefficient matrix A
        for u in 1:nSeg loop
          for v in 1:nSeg loop
            A[(i-1)*nSeg+u,(j-1)*nSeg+v] := hSegRea[abs(u-v)+1] + hSegMir[u+v-1];
            A[(j-1)*nSeg+v,(i-1)*nSeg+u] := (hSegRea[abs(u-v)+1] + hSegMir[u+v-1]) * cluSiz[i] / cluSiz[j];
          end for;
        end for;
      end for;
    end for;
    // Solve the system of equations
    X := Modelica.Math.Matrices.solve(A,B);
    // The g-function is equal to the borehole wall temperature
    g[nTimSho+k+1] := X[nClu*nSeg+1];
  end for;
  // Correct finite line source solution for cylindrical geometry
  for k in 2:nTimLon loop
    // Infinite line source
    ILS := 0.5*
      Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.infiniteLineSource(
      tLon[k],
      aSoi,
      rLin);
    // Cylindrical heat source
    CHS := 2*Modelica.Constants.pi*
      Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.cylindricalHeatSource(
      tLon[k],
      aSoi,
      rBor,
      rBor);
    g[nTimSho+k] := g[nTimSho+k] + (CHS - ILS);
  end for;

annotation (
Documentation(info="<html>
<p>
This function implements the <i>g</i>-function evaluation method introduced by
Cimmino and Bernier (see: Cimmino and Bernier (2014), Cimmino (2018), and Prieto
and Cimmino (2021)) based on the <i>g</i>-function function concept first
introduced by Eskilson (1987).
The <i>g</i>-function gives the relation between the variation of the borehole
wall temperature at a time <i>t</i> and the heat extraction and injection rates
at all times preceding time <i>t</i> as
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/GFunction_01.png\" />
</p>
<p>
where <i>T<sub>b</sub></i> is the borehole wall temperature,
<i>T<sub>g</sub></i> is the undisturbed ground temperature, <i>Q</i> is the
heat injection rate into the ground through the borehole wall per unit borehole
length, <i>k<sub>s</sub></i> is the soil thermal conductivity and <i>g</i> is
the <i>g</i>-function.
</p>
<p>
The <i>g</i>-function is constructed from the combination of the combination of
the finite line source (FLS) solution (see
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource</a>),
the cylindrical heat source (CHS) solution (see
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.cylindricalHeatSource\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.cylindricalHeatSource</a>),
and the infinite line source (ILS) solution (see
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.infiniteLineSource\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.infiniteLineSource</a>).
To obtain the <i>g</i>-function of a bore field, the bore field is first divided
into <code>nClu</code> groups of similarly behaving boreholes. Each group
is represented by a single <i>equivalent</i> borehole. Each equivalent borehole
is then divided into a series of <code>nSeg</code> segments of equal length,
each modeled as a line source of finite length. The finite line source solution
is superimposed in space to obtain a system of equations that gives the relation
between the heat injection rate at each of the segments and the borehole wall
temperature at each of the segments. The system is solved to obtain the uniform
borehole wall temperature required at any time to maintain a constant total heat
injection rate (<i>Q<sub>tot</sub> = 2&pi;k<sub>s</sub>H<sub>tot</sub>)</i> into
the bore field. The uniform borehole wall temperature is then equal to the
finite line source based <i>g</i>-function.
</p>
<p>
Since this <i>g</i>-function is based on line sources of heat, rather than
cylinders, the <i>g</i>-function is corrected to consider the cylindrical
geometry. The correction factor is then the difference between the cylindrical
heat source solution and the infinite line source solution, as proposed by
Li et al. (2014) as
</p>
<p align=\"center\">
<i>g(t) = g<sub>FLS</sub> + (g<sub>CHS</sub> - g<sub>ILS</sub>)</i>
</p>
<h4>Implementation</h4>
<p>
The calculation of the <i>g</i>-function is separated into two regions: the
short-time region and the long-time region. In the short-time region,
corresponding to times <i>t</i> &lt; 1 hour, heat interaction between boreholes
and axial variations of heat injection rate are not considered. The
<i>g</i>-function is calculated using only one borehole and one segment. In the
long-time region, corresponding to times <i>t</i> &gt; 1 hour, all boreholes
are represented as series of <code>nSeg</code> line segments and the
<i>g</i>-function is evaluated as described above.
</p>
<h4>References</h4>
<p>
Cimmino, M. and Bernier, M. 2014. <i>A semi-analytical method to generate
g-functions for geothermal bore fields</i>. International Journal of Heat and
Mass Transfer 70: 641-650.
</p>
<p>
Cimmino, M. 2018. <i>Fast calculation of the g-functions of geothermal borehole
fields using similarities in the evaluation of the finite line source
solution</i>. Journal of Building Performance Simulation 11(6): 655-668.
</p>
<p>
Eskilson, P. 1987. <i>Thermal analysis of heat extraction boreholes</i>. Ph.D.
Thesis. Department of Mathematical Physics. University of Lund. Sweden.
</p>
<p>
Li, M., Li, P., Chan, V. and Lai, A.C.K. 2014. <i>Full-scale temperature
response function (G-function) for heat transfer by borehole heat exchangers
(GHEs) from sub-hour to decades</i>. Applied Energy 136: 197-205.
</p>
<p>
Prieto, C. and Cimmino, M. 2021. <i>Thermal interactions in large irregular
fields of geothermal boreholes: the method of equivalent boreholes</i>. Journal
of Building Performance Simulation 14(4): 446-460.
<a href=\"https://doi.org/10.1080/19401493.2021.1968953\">
doi:10.1080/19401493.2021.1968953</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 9, 2022 by Massimo Cimmino:<br/>
Updated the function to use the more efficient method of Prieto and Cimmino
(2021).
</li>
<li>
November 16, 2022, by Michael Wetter:<br/>
Initialized variable <code>Done</code>.<br/>
See
<a href=\"https://github.com/OpenModelica/OpenModelica/issues/9707#issuecomment-1317631281\">
OpenModelica, #9707</a>.
</li>
<li>
March 22, 2018 by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end gFunction;
