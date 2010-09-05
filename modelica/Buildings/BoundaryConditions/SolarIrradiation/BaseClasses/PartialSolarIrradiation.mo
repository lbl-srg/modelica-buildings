within Buildings.BoundaryConditions.SolarIrradiation.BaseClasses;
partial block PartialSolarIrradiation
  "Partial model that is used to compute the direct and diffuse solar irradiation"
  extends Modelica.Blocks.Interfaces.SO(y(final quantity=
        "RadiantEnergyFluenceRate", final unit="W/m2"));
  parameter Modelica.SIunits.Angle tilAng(displayUnit="deg") "Surface tilt";

  WeatherData.WeatherBus weaBus "Bus with weather data"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  annotation (
    Documentation(info="<HTML>
<p>
This is a partial model that is used to implement the direct and diffuse irradiation.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
Sep. 4, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255})}));
end PartialSolarIrradiation;
