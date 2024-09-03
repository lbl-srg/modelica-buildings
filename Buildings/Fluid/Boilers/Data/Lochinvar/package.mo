within Buildings.Fluid.Boilers.Data;
package Lochinvar "Package containing data for Lochinvar boilers"
  extends Modelica.Icons.Package;

  annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains performance data for Lochinvar boilers.
See sources of the data in the table below.
</p>
<table summary=\"data source\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td colspan=\"2\"><b>Crest Boilers</b>
    </td>
</tr>
<tr><td valign=\"top\">Main webpage
    </td>
    <td valign=\"top\">
        <a href=\"https://www.lochinvar.com/products/commercial-boilers/crest-condensing-boiler/\">
        https://www.lochinvar.com/products/commercial-boilers/crest-condensing-boiler/</a>
    </td>
</tr>
<tr><td valign=\"top\">Efficiency curves
    </td>
    <td valign=\"top\">
        <a href=\"https://www.lochinvar.com/lit/595403Crest_Efficiency_Curve.pdf\">
        https://www.lochinvar.com/lit/595403Crest_Efficiency_Curve.pdf</a>
    </td>
</tr>
<tr><td valign=\"top\">Other specifications
    </td>
    <td valign=\"top\">
        <a href=\"https://www.lochinvar.com/lit/961107FBN-PS-17%20(2501-6001).pdf\">
        https://www.lochinvar.com/lit/961107FBN-PS-17%20(2501-6001).pdf</a>
    </td>
</tr>
<tr><td colspan=\"2\"><b>FTXL™ Fire Tube Boilers</b>
    </td>
</tr>
<tr><td valign=\"top\">Main webpage
    </td>
    <td valign=\"top\">
        <a href=\"https://www.lochinvar.com/products/commercial-boilers/ftxl-fire-tube-boiler/\">
        https://www.lochinvar.com/products/commercial-boilers/ftxl-fire-tube-boiler/</a>
    </td>
</tr>
<tr><td valign=\"top\">Efficiency curves
    </td>
    <td valign=\"top\">
        <a href=\"https://www.lochinvar.com/lit/FTXL%20Efficiency%20Curve.pdf\">
        https://www.lochinvar.com/lit/FTXL%20Efficiency%20Curve.pdf</a>
    </td>
</tr>
<tr><td valign=\"top\">Other specifications
    </td>
    <td valign=\"top\">
        <a href=\"https://www.lochinvar.com/lit/FTX-PS-02.pdf\">
        https://www.lochinvar.com/lit/FTX-PS-02.pdf</a>
    </td>
</tr>
<tr><td colspan=\"2\"><b>Knight™ XL Boilers</b>
    </td>
</tr>
<tr><td valign=\"top\">Main webpage
    </td>
    <td valign=\"top\">
        <a href=\"https://www.lochinvar.com/products/commercial-boilers/knight-xl/\">
        https://www.lochinvar.com/products/commercial-boilers/knight-xl/</a>
    </td>
</tr>
<tr><td valign=\"top\">Efficiency curves
    </td>
    <td valign=\"top\">
        <a href=\"https://www.lochinvar.com/lit/643565KNIGHT%20XL%20Curve.pdf\">
        https://www.lochinvar.com/lit/643565KNIGHT%20XL%20Curve.pdf</a>
    </td>
</tr>
<tr><td valign=\"top\">Other specifications
    </td>
    <td valign=\"top\">
        <a href=\"https://www.lochinvar.com/lit/277063KBX-PS-01_2021.pdf\">
        https://www.lochinvar.com/lit/277063KBX-PS-01_2021.pdf</a>
    </td>
</tr>
</table>
<p>
Boilers with the same brand name use the same set of efficiency curves
(e.g. all records in
<a href=\"modelica://Buildings.Fluid.Boilers.Data.Lochinvar.Crest\">
Buildings.Fluid.Boilers.Data.Lochinvar.Crest</a>
have the same curves).
The original documents use the IP units and conversions are made
in this implementation. Values corresponding to temperature rise of
20&deg;F (11.1&deg;C) are used as nominal (except for
<a href=\"modelica://Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash4001\">
Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash4001</a>
whose data are based on 22&deg;F [12.2&deg;C]).
The table below explains how the variables
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
Gas - BTU/hr output (high fire)
</p>
</td></tr>
<tr><td>
<p>
<code>VWat</code>
</p>
</td>
<td>
<p>
Water - Gallon capacity
</p>
</td></tr>
<tr><td>
<p>
<code>mDry</code>
</p>
</td><td>
<p>
Dimensions - shipping weight
</p>
</td></tr>
<tr><td>
<p>
<code>m_flow_nominal</code>
</p>
</td><td>
<p>
Water flow rate at 20&deg;F &Delta;T (11.1&deg;C)
</p>
</td></tr>
<tr><td>
<p>
<code>dp_nominal</code>
</p>
</td><td>
<p>
Pressure drop
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
