within Buildings.Fluid.Boilers.Data.Lochinvar;
package Crest "Package with performance data for Lochinvar Crest boilers"
  extends Modelica.Icons.Package;

    annotation (
    defaultComponentPrefixes = "parameter",
    Documentation(info="<html>
<p>
This package contains performance data from
<a href=\"https://www.lochinvar.com/products/commercial-boilers/crest-condensing-boiler/\">
https://www.lochinvar.com/products/commercial-boilers/crest-condensing-boiler/</a>.
All models use the same set of efficiency curves 
(from <a href=\"https://www.lochinvar.com/lit/595403Crest_Efficiency_Curve.pdf\">
https://www.lochinvar.com/lit/595403Crest_Efficiency_Curve.pdf</a>) 
which is implemented in
<a href=\"modelica://Buildings.Fluid.Boilers.Data.Lochinvar.Crest.Curves\">
Buildings.Fluid.Boilers.Data.Lochinvar.Crest.Curves</a>.
Specifications of each model (from 
<a href=\"https://www.lochinvar.com/lit/961107FBN-PS-17%20(2501-6001).pdf\">
https://www.lochinvar.com/lit/961107FBN-PS-17%20(2501-6001).pdf</a>
) are implemented individually in the rest of the records. 
</p>
<p>
The original document uses the IP units and conversions are made 
in this implementation. Values corresponding to temperature rise of 20&deg;F 
are used as nominal. The table below explains how the variables 
in this implementation correspond to items on the files from the website. 
</p>
<table summary=\"Specification correspondence\" 
cellspacing=\"0\" cellpadding=\"2\" border=\"1\"><tr><td>
<p align=\"center\">
<b>Variable in Modelica</b>
</p>
</td>
<td>
<p align=\"center\"><b>Item from the website</b>
</p>
</td></tr>
<tr>
<td>
<p>
<code>Q_flow_nominal</code>
</p>
</td>
<td>
<p>
GAS - BTU/HR OUTPUT (HIGH FIRE)
</p>
</td></tr>
<tr><td>
<p>
<code>VWat</code>
</p>
</td>
<td>
<p>
WATER - GALLON CAPACITY
</p>
</td></tr>
<tr><td>
<p>
<code>mDry</code>
</p>
</td><td>
<p>
DIMENSIONS - SHIPPING WEIGHT
</p>
</td></tr>
<tr><td>
<p>
<code>m_flow_nominal</code>
</p>
</td><td>
<p>
20&deg;F &Delta;T WATER FLOW
</p>
</td></tr>
<tr><td>
<p>
<code>dp_nominal</code>
</p>
</td><td>
<p>
HEAD LOSS
</p>
</td></tr>
</table>

</html>",   revisions="<html>
<ul>
<li>
November 1, 2021 by Hongxiang Fu:<br/>
First implementation. 
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2651\">#2651</a>.
</li>
</ul>
</html>"));
end Crest;
