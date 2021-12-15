within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block CheckDewPointTemperature
  "Check the validity of the dew point temperature data"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput TIn(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Input Temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput TDewPoi(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Dew point temperature"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  parameter Modelica.Units.SI.Temperature TMin(displayUnit="degC") = 203.15
    "Minimum allowed temperature";
  parameter Modelica.Units.SI.Temperature TMax(displayUnit="degC") = 343.15
    "Maximum allowed temperature";

equation
  TDewPoi = TIn;
  assert(noEvent(TIn > TMin and TIn < TMax), "In " + getInstanceName() +
     ": Weather data dew point temperature out of bounds.\n" + "   TIn = " + String(
    TIn));
  annotation (
    defaultComponentName="cheTem",
    Documentation(info="<html>
<p>
This component checks the value of temperature.
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
          extent={{-22,-74},{18,-36}},
          lineColor={0,0,127},
          lineThickness=0.5,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Line(points={{-42,44},{-14,44}}),
        Line(points={{-42,14},{-14,14}}),
        Line(points={{-42,-16},{-14,-16}}),
        Rectangle(
          extent={{-14,44},{10,-40}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-14,44},{-14,64},{-12,70},{-8,72},{-2,74},{4,72},{8,70},{10,64},
              {10,44},{-14,44}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-14,44},{-14,-41}},
          thickness=0.5)}));
end CheckDewPointTemperature;
