within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors;
pure function gFunctionCountMaxDis
  "Return the maximum number of unique separation distances across all cluster pairs"
  extends Modelica.Icons.Function;

  input Integer nBor "Number of boreholes";
  input Modelica.Units.SI.Position cooBor[nBor, 2] "Coordinates of boreholes";
  input Integer nClu "Number of clusters";
  input Integer labels[nBor] "Cluster label (1-based) associated with each borehole";
  input Integer cluSiz[nClu] "Size of each cluster";
  input Modelica.Units.SI.Radius rLin
    "Radius used as the self-distance for same-borehole pairs";
  input Real relTol "Relative tolerance for grouping distances";

  output Integer n_dis_max
    "Maximum number of unique distances across all nClu x nClu cluster pairs";

  external "C" n_dis_max = Buildings_gFunctionCountMaxDis(
    nBor, cooBor, nClu, labels, cluSiz, rLin, relTol)
    annotation (
      Include="#include <gFunctionComputeDisWDis.c>",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources");

annotation (
Documentation(info="<html>
<p>
This function returns the maximum number of unique borehole separation
distances found across all <code>nClu &times; nClu</code> cluster pairs.
The result is used to size the arrays
<code>dis[nClu,nClu,n_dis_max]</code> and
<code>wDis[nClu,nClu,n_dis_max]</code> in
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.gFunction\">
gFunction</a>
without the memory overhead of the worst-case bound
<code>max(cluSiz.*cluSiz)</code>.
</p>
<p>
The computation mirrors the distance-grouping loop in
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.gFunction\">
gFunction</a>:
borehole pairs are iterated in the same upper-triangular order, distances
within <code>relTol</code> of an already-seen value are merged into one
entry, and the transposed cluster pair <i>(j,i)</i> is updated symmetrically.
The C implementation uses per-pair dynamically growing arrays (initial
capacity 16, doubling on overflow) so no worst-case allocation is needed.
</p>
<h4>References</h4>
<p>
See
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4597\">
Buildings issue 4597</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 3, 2026, by Michael Wetter:<br/>
First implementation.
See <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4597\">#4597</a>.
</li>
</ul>
</html>"));
end gFunctionCountMaxDis;
