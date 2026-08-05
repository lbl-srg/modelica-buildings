within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.Validation;
model GFunction_nMax
  "Validate the tight n_max computation and g-function values for a 10 by 10 bore field"
  extends Modelica.Icons.Example;

  parameter Integer nBor = 100 "Number of boreholes";
  parameter Modelica.Units.SI.Position cooBor[nBor, 2] = {
    {7.5*mod(i - 1, 10), 7.5*floor((i - 1)/10)} for i in 1:nBor}
    "Coordinates of boreholes";
  parameter Modelica.Units.SI.Height hBor = 150 "Borehole length";
  parameter Modelica.Units.SI.Height dBor = 4   "Borehole buried depth";
  parameter Modelica.Units.SI.Radius rBor = 0.075 "Borehole radius";
  parameter Modelica.Units.SI.ThermalDiffusivity aSoi = 1e-6
    "Ground thermal diffusivity used in g-function evaluation";
  parameter Integer nSeg    = 12    "Number of line source segments per borehole";
  parameter Integer nTimSho = 26    "Number of time steps in short time region";
  parameter Integer nTimLon = 50    "Number of time steps in long time region";
  parameter Real ttsMax     = exp(5)
    "Maximum non-dimensional time for g-function calculation";
  parameter Real relTol     = 0.02
    "Relative tolerance on distance between boreholes";
  parameter Modelica.Units.SI.Radius rLin = 0.0005*hBor
    "Radius for same-borehole line source solutions";

  parameter Integer nClu = 5 "Number of clusters";
  parameter Integer labels[nBor](each fixed=false)
    "Cluster label associated with each borehole";
  parameter Integer cluSiz[nClu](each fixed=false)
    "Size of each cluster";

  final parameter Integer nTimTot = nTimSho + nTimLon;
  final parameter Real[nTimTot] gFun(each fixed=false)
    "g-function values";
  final parameter Modelica.Units.SI.Time[nTimTot] tGFun(each fixed=false)
    "Time of g-function evaluation";

  // Tight n_max from the C function (same as used inside gFunction)
  parameter Integer n_max(fixed=false)
    "Maximum number of unique distances for any cluster pair (tight value)";

  // Conservative upper bound from the pre-refactoring formula
  parameter Integer n_max_old(fixed=false)
    "Conservative upper bound max(cluSiz.*cluSiz) used before refactoring";

  // Comparison: tight n_max must not exceed the conservative bound
  Boolean nMaxIsTight "True when n_max is strictly smaller than n_max_old";

initial equation
  // Cluster the bore field
  (labels, cluSiz) =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.clusterBoreholes(
      nBor = nBor,
      cooBor = cooBor,
      hBor = hBor,
      dBor = dBor,
      rBor = rBor,
      nClu = nClu);

  // Tight n_max via the new C function
  n_max =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.gFunctionGetNMax(
      nBor   = nBor,
      cooBor = cooBor,
      rLin   = rLin,
      nClu   = nClu,
      labels = labels,
      relTol = relTol);

  // Conservative upper bound (pre-refactoring formula)
  n_max_old = max(cluSiz .* cluSiz);

  // g-function evaluation (uses the same n_max internally)
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
      cluSiz  = cluSiz,
      relTol  = relTol);

equation
  // The tight n_max must be strictly smaller than the conservative bound
  nMaxIsTight = n_max < n_max_old;
  assert(nMaxIsTight,
    "n_max=" + String(n_max) + " is not smaller than n_max_old=" + String(n_max_old));

  // g-function reference values (tolerance 0.1 %)
  assert(abs(gFun[1]) < 1e-6,
    "gFun[1]=" + String(gFun[1]) + " should be 0");
  assert(abs(gFun[13]  - 0.120897) < 1.21e-4,
    "gFun[13]="  + String(gFun[13])  + " deviates from 0.120897");
  assert(abs(gFun[26]  - 0.604785) < 6.05e-4,
    "gFun[26]="  + String(gFun[26])  + " deviates from 0.604785");
  assert(abs(gFun[51]  - 8.42742)  < 8.43e-3,
    "gFun[51]="  + String(gFun[51])  + " deviates from 8.42742");
  assert(abs(gFun[76]  - 62.2063)  < 0.0623,
    "gFun[76]="  + String(gFun[76])  + " deviates from 62.2063");

  annotation (
    experiment(Tolerance=1e-6, StopTime=1.0),
    __Dymola_Commands(file=
      "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/ThermalResponseFactors/Validation/GFunction_nMax.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
This model validates that the refactored
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.gFunction\">
gFunction</a> computes a tight upper bound for the third-dimension size
of the distance arrays.
</p>
<p>
The parameter <code>n_max</code> is the exact maximum number of unique
pairwise distances across all cluster pairs, returned by
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.gFunctionGetNMax\">
gFunctionGetNMax</a>.
The parameter <code>n_max_old</code> is the conservative upper bound
<code>max(cluSiz .* cluSiz)</code> used before the refactoring.
The Boolean <code>nMaxIsTight</code> is <code>true</code> when
<code>n_max &lt; n_max_old</code>, confirming that the refactoring
reduces memory use.
</p>
<p>
In addition, the following g-function values are exposed for comparison
across a range of time scales:
</p>
<ul>
<li><code>gFun[1]</code>: initial value at <i>t</i> = 0;</li>
<li><code>gFun[13]</code>: mid short-time region;</li>
<li><code>gFun[26]</code>: end of short-time region;</li>
<li><code>gFun[51]</code>: mid long-time region;</li>
<li><code>gFun[76]</code>: end of long-time region.</li>
</ul>
</html>",
    revisions="<html>
<ul>
<li>
August 4, 2025, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end GFunction_nMax;
