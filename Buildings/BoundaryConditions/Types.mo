within Buildings.BoundaryConditions;
package Types "Package with type definitions"
 extends Modelica.Icons.TypesPackage;
  type DataSource = enumeration(
      File "Use data from file",
      Parameter "Use parameter",
      Input "Use input connector") "Enumeration to define data source"
        annotation(Documentation(info="<html>
<p>
Enumeration to define the data source used in the weather data reader.
</p>
</html>", revisions="<html>
<ul>
<li>
July 20, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

  type RadiationDataSource = enumeration(
      File "Use data from file",
      Input_HGloHor_HDifHor
        "Global horizontal and diffuse horizontal radiation from connector",
      Input_HDirNor_HDifHor
        "Direct normal and diffuse horizontal radiation from connector",
      Input_HDirNor_HGloHor
        "Direct normal and global horizontal radiation from connector")
    "Enumeration to define solar radiation data source"
        annotation(Documentation(info="<html>
<p>
Enumeration to define the data source used in the weather data reader.
</p>
</html>", revisions="<html>
<ul>
<li>
August 13, 2012, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
  type SkyTemperatureCalculation = enumeration(
      HorizontalRadiation
        "Use horizontal irradiation",
      TemperaturesAndSkyCover
        "Use dry-bulb and dew-point temperatures and sky cover")
    "Enumeration for computation of sky temperature" annotation (Documentation(
        info =                 "<html>
<p>
Enumeration to define the method used to compute the sky temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
October 3, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

annotation (preferredView="info", Documentation(info="<html>
This package contains type definitions.
</html>"));
end Types;
