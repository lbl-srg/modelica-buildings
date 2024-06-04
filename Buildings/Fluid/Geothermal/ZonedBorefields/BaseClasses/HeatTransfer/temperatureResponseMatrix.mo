within Buildings.Fluid.Geothermal.ZonedBorefields.BaseClasses.HeatTransfer;
impure function temperatureResponseMatrix
  "Evaluate the thermal response factors of a zoned thermal storage"
  extends Modelica.Icons.Function;

  input Integer nBor "Number of boreholes";
  input Modelica.Units.SI.Position cooBor[nBor,2] "Coordinates of boreholes";
  input Modelica.Units.SI.Height hBor "Borehole length";
  input Modelica.Units.SI.Height dBor "Borehole buried depth";
  input Modelica.Units.SI.Radius rBor "Borehole radius";
  input Modelica.Units.SI.ThermalDiffusivity aSoi
    "Ground thermal diffusivity used in g-function evaluation";
  input Modelica.Units.SI.ThermalConductivity kSoi
    "Thermal conductivity of soil";
  input Integer nSeg "Number of line source segments per borehole";
  input Integer nZon "Total number of independent bore field zones";
  input Integer[nBor] iZon "Index of the zone corresponding to each borehole";
  input Integer[nZon] nBorPerZon "Number of boreholes per borefield zone";
  input Modelica.Units.SI.Time nu[nTim] "Time vector for the calculation of thermal response factors";
  input Integer nTim "Length of the time vector";
  input Real relTol = 0.02 "Relative tolerance on distance between boreholes";
  input String sha "SHA-1 encryption of the arguments of this function";

  output Modelica.Units.SI.ThermalResistance kappa[nZon*nSeg,nZon*nSeg,nTim] "Thermal response factor matrix";

protected
  String pathSave "Path of the folder used to save the temperature response matrix";
  Modelica.Units.SI.Time ts=hBor^2/(9*aSoi) "Characteristic time";
  Integer n_max = max(nBorPerZon.*nBorPerZon);
  Modelica.Units.SI.Distance dis[nZon,nZon,n_max] "Separation distance between boreholes";
  Modelica.Units.SI.Distance dis_ij "Separation distance between boreholes";
  Integer wDis[nZon,nZon,n_max] "Number of occurence of separation distances";
  Integer n_dis[nZon,nZon];
  Modelica.Units.SI.Radius rLin=0.0005*hBor
    "Radius for evaluation of same-borehole line source solutions";
  Real hSegRea[nSeg] "Real part of the FLS solution";
  Real hSegMir[2*nSeg-1] "Mirror part of the FLS solution";
  Modelica.Units.SI.Height dSeg "Buried depth of borehole segment";
  Real FLS "Finite line source solution";
  Real ILS "Infinite line source solution";
  Real CHS "Cylindrical heat source solution";
  Boolean found "Flag, true if a cluster has been found";

algorithm
  pathSave := "tmp/temperatureResponseMatrix/" + sha + "kappa.mat";

  if not Modelica.Utilities.Files.exist(pathSave) then
    // ---------------------------------------------
    // Distances between borehole in different zones
    // ---------------------------------------------
    n_dis := zeros(nZon,nZon);
    wDis := zeros(nZon,nZon,n_max);
    for i in 1:nBor loop
      for j in i:nBor loop
        // Distance between boreholes
        if i <> j then
          dis_ij := sqrt((cooBor[i,1] - cooBor[j,1])^2 + (cooBor[i,2] - cooBor[j,2])^2);
        else
          dis_ij := rLin;
        end if;
        found := false;
        for n in 1:n_dis[iZon[i],iZon[j]] loop
          if abs(dis_ij - dis[iZon[i],iZon[j],n]) / dis[iZon[i],iZon[j],n] < relTol then
            wDis[iZon[i],iZon[j],n] := wDis[iZon[i],iZon[j],n] + 1;
            found := true;
            if i <> j then
              wDis[iZon[j],iZon[i],n] := wDis[iZon[j],iZon[i],n] + 1;
            end if;
            break;
          end if;
        end for;
        if not found then
          n_dis[iZon[i],iZon[j]] := n_dis[iZon[i],iZon[j]] + 1;
          wDis[iZon[i],iZon[j],n_dis[iZon[i],iZon[j]]] := wDis[iZon[i],iZon[j],n_dis[iZon[i],iZon[j]]] + 1;
          dis[iZon[i],iZon[j],n_dis[iZon[i],iZon[j]]] := dis_ij;
          if i <> j then
            n_dis[iZon[j],iZon[i]] := n_dis[iZon[j],iZon[i]] + 1;
            wDis[iZon[j],iZon[i],n_dis[iZon[j],iZon[i]]] := wDis[iZon[j],iZon[i],n_dis[iZon[j],iZon[i]]] + 1;
            dis[iZon[j],iZon[i],n_dis[iZon[j],iZon[i]]] := dis_ij;
          end if;
        end if;
      end for;
    end for;

    // ----------------------------------
    // Matrix of thermal response factors
    // ----------------------------------
    // Evaluate thermal response matrix at all times
    for k in 1:nTim loop
      for i in 1:nZon loop
        for j in i:nZon loop
          // Evaluate Real and Mirror parts of FLS solution
          // Real part
          for m in 1:nSeg loop
            hSegRea[m] :=
              Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Equivalent(
                nu[k],
                aSoi,
                dis[i,j,1:n_dis[i,j]],
                wDis[i,j,1:n_dis[i,j]],
                hBor/nSeg,
                dBor,
                hBor/nSeg,
                dBor + (m - 1)*hBor/nSeg,
                nBorPerZon[i],
                n_dis[i,j],
                includeMirrorSource=false);
          end for;
          // Mirror part
          for m in 1:(2*nSeg-1) loop
            hSegMir[m] :=
              Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Equivalent(
                nu[k],
                aSoi,
                dis[i,j,1:n_dis[i,j]],
                wDis[i,j,1:n_dis[i,j]],
                hBor/nSeg,
                dBor,
                hBor/nSeg,
                dBor + (m - 1)*hBor/nSeg,
                nBorPerZon[i],
                n_dis[i,j],
                includeRealSource=false);
          end for;
          // Add thermal response factor to coefficient matrix A
          for u in 1:nSeg loop
            for v in 1:nSeg loop
              kappa[(i-1)*nSeg+u,(j-1)*nSeg+v,k] := hSegRea[abs(u-v)+1] + hSegMir[u+v-1];
              kappa[(j-1)*nSeg+v,(i-1)*nSeg+u,k] := (hSegRea[abs(u-v)+1] + hSegMir[u+v-1]) * nBorPerZon[i] / nBorPerZon[j];
            end for;
          end for;
        end for;
      end for;
    end for;

    // -----------------------------------
    // Correction for cylindrical geometry
    // -----------------------------------
    for k in 1:nTim loop
      // Infinite line source
      ILS := 0.5*
        Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.infiniteLineSource(
          nu[k],
          aSoi,
          rLin);
      // Cylindrical heat source
      CHS := 2*Modelica.Constants.pi*
        Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.cylindricalHeatSource(
          nu[k],
          aSoi,
          rBor,
          rBor);
      // Apply to all terms along the diagonal (i.e. the impact on the segments
      // on themselves)
      for i in 1:nZon loop
        for u in 1:nSeg loop
          kappa[(i-1)*nSeg+u,(i-1)*nSeg+u,k] := kappa[(i-1)*nSeg+u,(i-1)*nSeg+u,k] + (CHS - ILS);
        end for;
      end for;
    end for;

    // -----------------------------------------------------
    // Incremental (dimensional) temperature response factor
    // -----------------------------------------------------
    for k in 1:nTim-1 loop
      kappa[:,:,nTim-k+1] := (kappa[:,:,nTim-k+1] - kappa[:,:,nTim-k]) / (2*Modelica.Constants.pi*hBor/nSeg*kSoi);
    end for;
    kappa[:,:,1] := kappa[:,:,1] / (2*Modelica.Constants.pi*hBor/nSeg*kSoi);

    //creation of a temporary folder in the simulation folder
    Modelica.Utilities.Files.createDirectory("tmp");
    Modelica.Utilities.Files.createDirectory("tmp/temperatureResponseMatrix");

    for i in 1:nZon*nSeg loop
      assert(Modelica.Utilities.Streams.writeRealMatrix(
        fileName=pathSave,
        matrixName="kappa_" + String(i),
        matrix=kappa[i, :, :],
        append=true),
        "In " + getInstanceName() +": Writing kappa.mat failed.");
    end for;
  end if;

  for i in 1:nZon*nSeg loop
    kappa[i,:,:] := Modelica.Utilities.Streams.readRealMatrix(
      fileName=pathSave,
      matrixName="kappa_" + String(i),
      nrow=nZon*nSeg,
      ncol=nTim,
      verboseRead=false);
  end for;

annotation (
Documentation(info="<html>
<p>
This function evaluates the array of segment-to-segment thermal response factors
using the analytical finite line source method of and Prieto and Cimmino (2021).
The finite line source solution gives the relation between heat extraction at
a segment of an equivalent borehole representing a group of boreholes (or in
this model, a borefield zone) and the temperature variation at the wall of
another segment of another (or the same) equivalent borehole representing
another group of boreholes. The total temperature varition at a borehole segment
is given by the temporal and spatial superpositions of the thermal reponse
factors:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/ZonedBorefields/TemperatureResponse_01.png\" />
</p>
<p>
where <i>T<sub>b,I,u</sub></i> is the borehole wall temperature of segment
<i>u</i> of borehole <i>I</i>, <i>T<sub>g,I,u</sub></i> is the undisturbed ground
temperature of segment <i>u</i> of borehole <i>I</i>, <i>Q'<sub>J,v</sub></i> is
the heat injection rate into the ground through the borehole wall per unit
length of segment <i>v</i> of borehole <i>J</i>, <i>k<sub>s</sub></i> is the
soil thermal conductivity and <i>h<sub>IJ,uv</sub></i> is the thermal response
factor of segment <i>v</i> of borehole <i>J</i> onto segment <i>u</i> of
borehole <i>I</i>.
</p>
<p>
The thermal response factor is constructed from the combination of the finite
line source (FLS) solution (see
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Equivalent\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Equivalent</a>),
the cylindrical heat source (CHS) solution (see
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.cylindricalHeatSource\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.cylindricalHeatSource</a>),
and the infinite line source (ILS) solution (see
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.infiniteLineSource\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.infiniteLineSource</a>).

To obtain the thermal response factors of a bore field, the bore field is first
divided into <code>nZon</code> zones of parallel-connected boreholes. Each sone
is represented by a single <i>equivalent</i> borehole. Each equivalent borehole
is then divided into a series of <code>nSeg</code> segments of equal length,
each modeled as a line source of finite length. The finite line source solution
is superimposed in space to obtain a system of equations that gives the relation
between the heat injection rate at each of the segments and the borehole wall
temperature at each of the segments.
</p>
<p>
Since the finite line source solution is based on line sources of heat, rather
than cylinders, the thermal response factors are corrected to consider the
cylindrical geometry. The correction factor is then the difference between the
cylindrical heat source solution and the infinite line source solution, as
proposed by Li et al. (2014) :
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/ZonedBorefields/TemperatureResponse_02.png\" />
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
February 2024, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end temperatureResponseMatrix;
