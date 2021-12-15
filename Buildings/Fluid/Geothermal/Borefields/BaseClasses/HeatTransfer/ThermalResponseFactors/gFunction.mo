within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors;
function gFunction "Evaluate the g-function of a bore field"
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
  Modelica.Units.SI.Distance dis "Separation distance between boreholes";
  Modelica.Units.SI.Distance dis_mn "Separation distance for comparison";
  Modelica.Units.SI.Radius rLin=0.0005*hBor
    "Radius for evaluation of same-borehole line source solutions";
  Real hSegRea[nSeg] "Real part of the FLS solution";
  Real hSegMir[2*nSeg-1] "Mirror part of the FLS solution";
  Modelica.Units.SI.Height dSeg "Buried depth of borehole segment";
  Integer Done[nBor, nBor] "Matrix for tracking of FLS evaluations";
  Real A[nSeg*nBor+1, nSeg*nBor+1] "Coefficient matrix for system of equations";
  Real B[nSeg*nBor+1] "Coefficient vector for system of equations";
  Real X[nSeg*nBor+1] "Solution vector for system of equations";
  Real FLS "Finite line source solution";
  Real ILS "Infinite line source solution";
  Real CHS "Cylindrical heat source solution";

algorithm
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
  for m in 1:nBor loop
    for u in 1:nSeg loop
      // Tb coefficient in spatial superposition equations
      A[(m-1)*nSeg+u,nBor*nSeg+1] := -1;
      // Q coefficient in heat balance equation
      A[nBor*nSeg+1,(m-1)*nSeg+u] := 1;
    end for;
  end for;
  // Initialize coefficient vector B
  // The total heat extraction rate is constant
  B[nBor*nSeg+1] := nBor*nSeg;

  // Evaluate thermal response matrix at all times
  for k in 1:nTimLon-1 loop
    for i in 1:nBor loop
      for j in i:nBor loop
        // Distance between boreholes
        if i == j then
          // If same borehole, distance is the radius
          dis := rLin;
        else
          dis := sqrt((cooBor[i,1] - cooBor[j,1])^2 + (cooBor[i,2] - cooBor[j,2])^2);
        end if;
        // Only evaluate the thermal response factors if not already evaluated
        if Done[i,j] < k then
          // Evaluate Real and Mirror parts of FLS solution
          // Real part
          for m in 1:nSeg loop
            hSegRea[m] :=
              Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource(
              tLon[k + 1],
              aSoi,
              dis,
              hBor/nSeg,
              dBor,
              hBor/nSeg,
              dBor + (m - 1)*hBor/nSeg,
              includeMirrorSource=false);
          end for;
        // Mirror part
          for m in 1:(2*nSeg-1) loop
            hSegMir[m] :=
              Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource(
              tLon[k + 1],
              aSoi,
              dis,
              hBor/nSeg,
              dBor,
              hBor/nSeg,
              dBor + (m - 1)*hBor/nSeg,
              includeRealSource=false);
          end for;
        // Apply to all pairs that have the same separation distance
          for m in 1:nBor loop
            for n in m:nBor loop
              if m == n then
                dis_mn := rLin;
              else
                dis_mn := sqrt((cooBor[m,1] - cooBor[n,1])^2 + (cooBor[m,2] - cooBor[n,2])^2);
              end if;
              if abs(dis_mn - dis) < relTol*dis then
                // Add thermal response factor to coefficient matrix A
                for u in 1:nSeg loop
                  for v in 1:nSeg loop
                    A[(m-1)*nSeg+u,(n-1)*nSeg+v] := hSegRea[abs(u-v)+1] + hSegMir[u+v-1];
                    A[(n-1)*nSeg+v,(m-1)*nSeg+u] := hSegRea[abs(u-v)+1] + hSegMir[u+v-1];
                  end for;
                end for;
                // Mark current pair as evaluated
                Done[m,n] := k;
                Done[n,m] := k;
              end if;
            end for;
          end for;
        end if;
      end for;
    end for;
    // Solve the system of equations
    X := Modelica.Math.Matrices.solve(A,B);
    // The g-function is equal to the borehole wall temperature
    g[nTimSho+k+1] := X[nBor*nSeg+1];
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
Cimmino and Bernier (see: Cimmino and Bernier (2014), and Cimmino (2018)) based
on the <i>g</i>-function function concept first introduced by Eskilson (1987).
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
To obtain the <i>g</i>-function of a bore field, each borehole is divided into a
series of <code>nSeg</code> segments of equal length, each modeled as a line
source of finite length. The finite line source solution is superimposed in
space to obtain a system of equations that gives the relation between the heat
injection rate at each of the segments and the borehole wall temperature at each
of the segments. The system is solved to obtain the uniform borehole wall
temperature required at any time to maintain a constant total heat injection
rate (<i>Q<sub>tot</sub> = 2&pi;k<sub>s</sub>H<sub>tot</sub>)</i> into the bore
field. The uniform borehole wall temperature is then equal to the finite line
source based <i>g</i>-function.
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
solution</i>. Journal of Building Performance Simulation. DOI:
10.1080/19401493.2017.1423390.
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
</html>", revisions="<html>
<ul>
<li>
March 22, 2018 by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end gFunction;
