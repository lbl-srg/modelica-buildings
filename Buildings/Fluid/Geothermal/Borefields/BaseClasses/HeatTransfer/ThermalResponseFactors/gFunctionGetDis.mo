within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors;
function gFunctionGetDis
  "Fill the pairwise-distance arrays for all cluster pairs of a bore field"
  extends Modelica.Icons.Function;

  input Integer nBor "Number of boreholes";
  input Modelica.Units.SI.Position cooBor[nBor, 2] "Coordinates of boreholes";
  input Modelica.Units.SI.Radius rLin
    "Radius used as the self-interaction distance for a borehole";
  input Integer nClu "Number of clusters";
  input Integer labels[nBor] "Cluster label (1-indexed) associated with each borehole";
  input Real relTol "Relative tolerance on distance between boreholes";
  input Integer n_max
    "Maximum number of unique distances for any cluster pair (from gFunctionGetNMax)";

  output Modelica.Units.SI.Distance dis[nClu, nClu, n_max]
    "Unique separation distances for each cluster pair";
  output Integer wDis[nClu, nClu, n_max]
    "Number of occurrences of each unique separation distance";
  output Integer n_dis[nClu, nClu]
    "Number of unique distances for each cluster pair";

  external "C" gFunctionGetDis(nBor, cooBor, rLin, nClu, labels, relTol, n_max, dis, wDis, n_dis)
    annotation (
      Include="#include <gFunctionGetDis.c>",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources");

annotation (Documentation(info="<html>
<p>
This function fills the arrays <code>dis</code>, <code>wDis</code>, and
<code>n_dis</code> that describe the pairwise distances between boreholes
grouped by cluster pair.
It applies the same distance-accumulation loop and the same
distance-comparison criterion as
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.gFunctionGetNMax\">
gFunctionGetNMax</a>; both functions share the helper
<code>gFunctionFindDis</code> in <code>gFunctionDisShared.h</code> to
guarantee identical distance binning.
</p>
<p>
The input <code>n_max</code> must be obtained by calling
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.gFunctionGetNMax\">
gFunctionGetNMax</a> first; it sizes the third dimension of
<code>dis</code> and <code>wDis</code>.
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
end gFunctionGetDis;
