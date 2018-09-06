within Buildings.Fluid.Geothermal.Borefields;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

  type BoreholeConfiguration = enumeration(
      SingleUTube
    "Single U-tube configuration",
      DoubleUTubeParallel
    "Double U-tube configuration with pipes connected in parallel",
      DoubleUTubeSeries
    "Double U-tube configuration with pipes connected in series")
  "Enumaration to define the borehole configurations"
  annotation (Documentation(info="<html>
<p>
Enumeration that defines the pipe configuration in the borehole.
</p>
<p>
The following pipe configurations are available in this enumeration:
</p>
<table summary=\"summary\" border=\"1\">
<tr><th>Enumeration</th><th>Description</th></tr>
<tr><td>SingleUTube</td><td>Single U-tube configuration</td></tr>

<tr><td>DoubleUTubeParallel</td><td>Double U-tube configuration with pipes connected in parallel</td></tr>
<tr><td>DoubleUTubeSeries</td><td>Double U-tube configuration with pipes connected in series</td></tr>
</table>
</html>",
  revisions="<html>
<ul>
<li>
July 15, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  annotation (preferredView="info", Documentation(info="<html>
 <p>
 This package contains type definitions.
 </p>
 </html>"));
end Types;
