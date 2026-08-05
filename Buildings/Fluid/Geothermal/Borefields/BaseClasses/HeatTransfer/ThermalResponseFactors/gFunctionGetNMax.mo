within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors;
function gFunctionGetNMax
  "Return the maximum number of unique pairwise distances across all cluster pairs"
  extends Modelica.Icons.Function;

  input Integer nBor "Number of boreholes";
  input Modelica.Units.SI.Position cooBor[nBor, 2] "Coordinates of boreholes";
  input Modelica.Units.SI.Radius rLin
    "Radius used as the self-interaction distance for a borehole";
  input Integer nClu "Number of clusters";
  input Integer labels[nBor] "Cluster label (1-indexed) associated with each borehole";
  input Real relTol "Relative tolerance on distance between boreholes";

  output Integer n_max "Maximum number of unique distances for any cluster pair";

  external "C" n_max = gFunctionGetNMax(nBor, cooBor, rLin, nClu, labels, relTol)
    annotation (
      Include="#include <gFunctionGetNMax.c>",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources");

annotation (Documentation(info="<html>
<p>
This function computes the maximum number of unique pairwise distances
that appear in any cluster pair <code>(i, j)</code> of the bore field,
using dynamic memory allocation in C.
The result is used to size the third dimension of the arrays
<code>dis</code> and <code>wDis</code> in
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.gFunction\">
gFunction</a>.
</p>
<p>
Two distances are considered identical when their relative difference
is less than <code>relTol</code>, which is the same criterion applied
in
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.gFunctionGetDis\">
gFunctionGetDis</a>.
Both functions share the comparison code in
<code>gFunctionDisShared.h</code> to guarantee that the distance
binning is numerically identical.
</p>
</html>", revisions="<html>
<ul>
<li>
2025, by Michael Wetter:<br/>
First implementation as part of the refactoring to reduce memory usage
of the g-function calculation.
</li>
</ul>
</html>"));
end gFunctionGetNMax;
