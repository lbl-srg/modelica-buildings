within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block CheckTemperature "Check the validity of temperature data"
  extends Modelica.Blocks.Icons.Block;
public
  Modelica.Blocks.Interfaces.RealInput TIn(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Input Temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput TOut(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Output temperature"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  parameter Modelica.SIunits.Temperature TMin(displayUnit="degC") = 203.15
    "Minimum allowed temperature";
  parameter Modelica.SIunits.Temperature TMax(displayUnit="degC") = 343.15
    "Maximum allowed temperature";

equation
  TOut = TIn;
  assert(TOut > TMin, "Temperature out of bounds.\n" + "   TOut = " + String(
    TOut));
  assert(TOut < TMax, "Temperature out of bounds.\n" + "   TOut = " + String(
    TOut));

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
October 27, 2011, by Wangda Zuo:<br/>
Delete the unit convertion part and name it from ConvertTemperature to CheckTemperature.
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
            100}}), graphics={Text(
          extent={{42,44},{-38,-36}},
          lineColor={0,0,0},
          textString="T")}));
end CheckTemperature;
