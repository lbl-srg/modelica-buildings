within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block CheckDryBulbTemperature
  "Check the validity of the dry bulb temperature data"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput TIn(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Input Temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput TDryBul(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Dry bulb temperature"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  parameter Modelica.Units.SI.Temperature TMin(displayUnit="degC") = 203.15
    "Minimum allowed temperature";
  parameter Modelica.Units.SI.Temperature TMax(displayUnit="degC") = 343.15
    "Maximum allowed temperature";

equation
  TDryBul = TIn;
  assert(noEvent(TIn > TMin and TIn < TMax), "In " + getInstanceName() +
     ": Weather data dry bulb temperature out of bounds.\n" + "   TIn = " + String(
    TIn));
  annotation (
    defaultComponentName="cheTem",
    Documentation(info="<html>
<p>
This component checks the value of the dry bulb temperature.
If the temperature is outside <code>TMin</code> and <code>TMax</code>,
the simulation will stop with an error.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14, 2020, by Michael Wetter:<br/>
Added <code>noEvent</code>.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1340\">#1340</a>.
</li>
<li>
January 31, 2020 by Filip Jorissen:<br/>
Improved error message.
</li>
<li>
October 27, 2011, by Wangda Zuo:<br/>
Delete the unit conversion part and name it from ConvertTemperature to CheckTemperature.
</li>
<li>
March 23, 2011, by Michael Wetter:<br/>
Set <code>displayUnit</code> argument for temperature output signal.
</li>
<li>
July 08, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Ellipse(
          extent={{-18,-72},{22,-34}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-38,46},{-10,46}}),
        Line(points={{-38,16},{-10,16}}),
        Line(points={{-38,-14},{-10,-14}}),
        Rectangle(
          extent={{-10,46},{14,-38}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-10,46},{-10,66},{-8,72},{-4,74},{2,76},{8,74},{12,72},{14,66},
              {14,46},{-10,46}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-10,46},{-10,-39}},
          thickness=0.5)}));
end CheckDryBulbTemperature;
