within Buildings.BoundaryConditions.WeatherData.BaseClasses;
expandable connector SolarSubBus "Data bus that stores solar position"
  extends Modelica.Icons.SignalSubBus;

  annotation (
    defaultComponentName="solBus",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-20,2},{22,-2}},
          lineColor={255,204,51},
          lineThickness=0.5)}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    Documentation(info="<html>
<p>
This component is an expandable connector that is used to implement a bus that contains the solar position.
</p>
</html>
", revisions="<html>
<ul>
<li>
February 25, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SolarSubBus;
