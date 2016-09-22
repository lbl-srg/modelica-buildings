within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block CheckBlackBodySkyTemperature
  "Check the validity of the black-body sky temperature data"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput TIn(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Black-body sky temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput TOut(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Black-body sky temperature"
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
January 5, 2015 by Michael Wetter:<br/>
First implementation, based on
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.BaseClasses.CheckTemperature\">
Buildings.BoundaryConditions.WeatherData.BaseClasses.CheckTemperature</a>.
This was implemented to get the corrected documentation string in the weather bus connector.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{56,12},{-68,-16}},
          lineColor={0,0,0},
          textString="TSkyBlaBod")}));
end CheckBlackBodySkyTemperature;
