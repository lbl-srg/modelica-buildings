within Buildings.Utilities.IO.BCVTB;
block From_degC "Converts Celsius to Kelvin"
  extends Modelica.Blocks.Icons.Block;

  Modelica.Blocks.Interfaces.RealInput Celsius(final quantity="ThermodynamicTemperature",
                                               final unit = "degC", displayUnit = "degC", min=-273.15)
    "Temperature in Celsius"
    annotation (Placement(transformation(extent={{-140,-24},{-100,16}}),
        iconTransformation(extent={{-140,-24},{-100,16}})));
  Modelica.Blocks.Interfaces.RealOutput Kelvin(final quantity="ThermodynamicTemperature",
                                               final unit = "K", displayUnit = "degC", min=0)
    "Temperature in Kelvin"
    annotation (Placement(transformation(extent={{100,-12},{120,8}}),
        iconTransformation(extent={{100,-12},{120,8}})));
equation
  Celsius =Modelica.Units.Conversions.to_degC(Kelvin);
annotation (
defaultComponentName="froDegC",
Documentation(info="<html>
<p>
Converts the input from Kelvin to degree Celsius.
Note that inside Modelica, by convention, all models use
Kelvin. This block is provided for convenience since the BCVTB
interface may couple Modelica to programs that use Celsius
as the unit for temperature.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 14, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={               Text(
          extent={{94,-22},{14,-102}},
          textColor={0,0,0},
          textString="K"),
        Polygon(
          points={{84,-4},{24,16},{24,-24},{84,-4}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
                           Text(
          extent={{-16,94},{-96,14}},
          textColor={0,0,0},
          textString="degC"),
        Line(points={{-96,-4},{24,-4}},
                                      color={191,0,0})}));
end From_degC;
