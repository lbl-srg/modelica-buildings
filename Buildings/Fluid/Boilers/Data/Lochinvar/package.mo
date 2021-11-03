within Buildings.Fluid.Boilers.Data;
package Lochinvar "Package containing data for Lochinvar boilers"
  extends Modelica.Icons.Package;

  annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains performance data for Lochinvar boilers.
Source of the data are cited in the documentation of each package.
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
<p>
See the
<a href=\"modelica://Buildings.Fluid.Boilers.UsersGuide\">
User's Guide</a> for more information.
</p>
</html>"));
end Lochinvar;
