within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.Validation;
model GFunction_LargeField
  "g-function calculation for a field of 41 by 61 boreholes (xBorFie=200 m, yBorFie=300 m)"
  extends Modelica.Icons.Example;

  parameter Integer nXBorFie = 41
    "Number of boreholes in x-direction (xBorFie=200 m, dBorHol=5 m)";
  parameter Integer nYBorFie = 61
    "Number of boreholes in y-direction (yBorFie=300 m, dBorHol=5 m)";
  parameter Integer nBor = nXBorFie * nYBorFie "Number of boreholes (2501)";
  parameter Modelica.Units.SI.Position cooBor[nBor, 2] = {
    {5.0*mod(i - 1, nXBorFie), 5.0*floor((i - 1)/nXBorFie)} for i in 1:nBor}
    "Borehole coordinates on a 5 m rectangular grid";
  parameter Modelica.Units.SI.Height hBor = 150 "Borehole length";
  parameter Modelica.Units.SI.Height dBor = 4 "Borehole buried depth";
  parameter Modelica.Units.SI.Radius rBor = 0.075 "Borehole radius";
  parameter Modelica.Units.SI.ThermalDiffusivity aSoi = 1e-6
    "Ground thermal diffusivity used in g-function evaluation";
  parameter Integer nSeg = 12 "Number of line source segments per borehole";
  parameter Integer nTimSho = 26 "Number of time steps in short time region";
  parameter Integer nTimLon = 50 "Number of time steps in long time region";
  parameter Real ttsMax = exp(5) "Maximum non-dimensional time for g-function calculation";
  parameter Integer nClu = 5 "Number of clusters to be generated";

  final parameter Integer nTimTot = nTimSho + nTimLon;
  final parameter Real[nTimTot] gFun(each fixed=false);
  final parameter Modelica.Units.SI.Time[nTimTot] tGFun(each fixed=false);
  final parameter Integer labels[nBor](each fixed=false)
    "Cluster label associated with each borehole";
  final parameter Integer cluSiz[nClu](each fixed=false) "Size of each cluster";
  final parameter Integer n_dis_max(fixed=false)
    "Actual maximum number of unique distances across all cluster pairs";

  parameter Modelica.Units.SI.Time ts = hBor^2/(9*aSoi)
    "Bore field characteristic time";

initial equation
  (labels, cluSiz) =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.clusterBoreholes(
      nBor   = nBor,
      cooBor = cooBor,
      hBor   = hBor,
      dBor   = dBor,
      rBor   = rBor,
      nClu   = nClu);

  n_dis_max =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.gFunctionCountMaxDis(
      nBor   = nBor,
      cooBor = cooBor,
      nClu   = nClu,
      labels = labels,
      cluSiz = cluSiz,
      rLin   = 0.0005*hBor,
      relTol = 0.02);

  (tGFun, gFun) =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.gFunction(
      nBor    = nBor,
      cooBor  = cooBor,
      hBor    = hBor,
      dBor    = dBor,
      rBor    = rBor,
      aSoi    = aSoi,
      nSeg    = nSeg,
      nTimSho = nTimSho,
      nTimLon = nTimLon,
      ttsMax  = ttsMax,
      nClu    = nClu,
      labels  = labels,
      cluSiz  = cluSiz);

equation

  annotation (
    experiment(Tolerance=1e-6, StopTime=1),
    __OpenModelica_simulationFlags(lv = "LOG_STATS"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/ThermalResponseFactors/Validation/GFunction_LargeField.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example verifies that the g-function can be evaluated for a large
rectangular borefield of 41 &times; 61 = 2,501 boreholes on a 5 m grid
(corresponding to <code>xBorFie = 200 m</code>, <code>yBorFie = 300 m</code>
with 5 m borehole spacing).
</p>
<p>
This configuration previously caused an out-of-memory error during
translation because the local arrays
<code>dis[nClu,nClu,n_max]</code> and <code>wDis[nClu,nClu,n_max]</code>
in
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.gFunction\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.gFunction</a>
were sized with <code>n_max = max(cluSiz.*cluSiz)</code>.
For 5 clusters of approximately 500 boreholes each,
<code>n_max &approx; 368,000</code>, giving array sizes on the order of
590 MB as a stack allocation in generated C code.
</p>
<p>
After the fix, <code>n_max</code> is computed by
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.gFunctionCountMaxDis\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.gFunctionCountMaxDis</a>,
which uses dynamic memory allocation in C to find the actual number of
unique distances.
For a regular rectangular grid, this is typically two to three orders of
magnitude smaller than <code>max(cluSiz.*cluSiz)</code>.
The parameter <code>n_dis_max</code> stores the value returned by that
function so it can be inspected after initialization.
</p>
<p>
Translate this model with OpenModelica to confirm:
</p>
<ul>
<li>
Translation succeeds without an out-of-memory error.
</li>
<li>
The value of <code>n_dis_max</code> is much smaller than the old bound
<code>max(cluSiz.*cluSiz) &approx; 368,000</code>.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
August 3, 2026, by Michael Wetter:<br/>
First implementation.
See <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4597\">#4597</a>.
</li>
</ul>
</html>"));
end GFunction_LargeField;
