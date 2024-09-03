within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block CheckBlackBodySkyTemperature
  "Check the validity of the black-body sky temperature data"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.SI.Temperature TMin(displayUnit="degC") = 203.15
    "Minimum allowed temperature";
  parameter Modelica.Units.SI.Temperature TMax(displayUnit="degC") = 343.15
    "Maximum allowed temperature";

  Modelica.Blocks.Interfaces.RealInput TIn(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Black-body sky temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.RealOutput TBlaSky(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Black-body sky temperature"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  TBlaSky = TIn;
  assert(noEvent(TIn > TMin and TIn < TMax),
    "In " + getInstanceName() + ": Weather data black-body sky temperature out of bounds.\n" + "   TIn = " +
     String(TIn));

  annotation (
    defaultComponentName="cheSkyBlaBodTem",
    Documentation(info="<html>
<p>
This component checks the value of the black-body sky temperature.
If the temperature is outside <code>TMin</code> and <code>TMax</code>,
the simulation will stop with an error.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14, 2020, by Michael Wetter:<br/>
Added <code>noEvent</code> and removed output connector.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1340\">#1340</a>.
</li>
<li>
January 31, 2020 by Filip Jorissen:<br/>
Improved error message.
</li>
<li>
January 5, 2015 by Michael Wetter:<br/>
First implementation, based on
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.BaseClasses.CheckTemperature\">
Buildings.BoundaryConditions.WeatherData.BaseClasses.CheckTemperature</a>.
This was implemented to get the corrected documentation string in the weather bus connector.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Ellipse(
          extent={{-20,-78},{20,-40}},
          lineColor={99,17,20},
          lineThickness=0.5,
          fillColor={99,17,20},
          fillPattern=FillPattern.Solid),
        Line(points={{-40,40},{-12,40}}),
        Line(points={{-40,10},{-12,10}}),
        Line(points={{-40,-20},{-12,-20}}),
        Rectangle(
          extent={{-12,40},{12,-44}},
          lineColor={99,17,20},
          fillColor={99,17,20},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-12,40},{-12,60},{-10,66},{-6,68},{0,70},{6,68},{10,66},{12,
              60},{12,40},{-12,40}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-12,40},{-12,-45}},
          thickness=0.5)}));
end CheckBlackBodySkyTemperature;
