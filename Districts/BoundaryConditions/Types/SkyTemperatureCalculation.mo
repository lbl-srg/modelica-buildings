within Districts.BoundaryConditions.Types;
type SkyTemperatureCalculation = enumeration(
    HorizontalRadiation "Use horizontal irradiation",
    TemperaturesAndSkyCover
      "Use dry-bulb and dew-point temperatures and sky cover")
  "Enumeration for computation of sky temperature" annotation (Documentation(
      info =                "<html>
<p>
Enumeration to define the method used to compute the sky temperature.
</p>
</html>",
        revisions=
        "<html>
<ul>
<li>
October 3, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
