within Buildings.BoundaryConditions.SolarIrradiation.BaseClasses;
partial block PartialSolarIrradiation
  "Partial model that is used to compute the direct and diffuse solar irradiation"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.Angle til(displayUnit="deg") "Surface tilt";
  Modelica.Blocks.Interfaces.RealOutput H(
     final quantity="RadiantEnergyFluenceRate",
     final unit="W/m2") "Radiation per unit area"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  WeatherData.Bus weaBus "Bus with weather data"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  annotation (
    Documentation(info="<html>
<p>
This is a partial model that is used to implement the direct and diffuse irradiation.
</p>
</html>", revisions="<html>
<ul>
<li>
Dec. 12, 2010, by Michael Wetter:<br/>
Changed output signal to avoid ambiguity in blocks that output also other
quantities such as the incidence angle.
</li>
<li>
Sep. 4, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          textColor={0,0,255})}));
end PartialSolarIrradiation;
