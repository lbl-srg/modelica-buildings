within Buildings.Utilities.IO.BCVTB;
block To_degC "Converts Kelvin to Celsius"
  extends Modelica.Blocks.Icons.Block;

  Modelica.Blocks.Interfaces.RealInput Kelvin(final quantity="ThermodynamicTemperature",
                                              final unit = "K", displayUnit = "degC", min=0)
    "Temperature in Kelvin"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput Celsius(final quantity="ThermodynamicTemperature",
                                                final unit = "degC", displayUnit = "degC", min=-273.15)
    "Temperature in Celsius"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
equation
  Kelvin =Modelica.Units.Conversions.from_degC(Celsius);
annotation (
defaultComponentName="toDegC",
Documentation(info="<html>
<p>
Converts the input from degree Celsius to Kelvin.
Note that inside Modelica, it is strongly recommended to use
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
          extent={{-26,96},{-106,16}},
          textColor={0,0,0},
          textString="K"),
        Polygon(
          points={{84,-4},{24,16},{24,-24},{84,-4}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
                           Text(
          extent={{94,-24},{14,-104}},
          textColor={0,0,0},
          textString="degC"),
        Line(points={{-96,-4},{24,-4}},
                                      color={191,0,0})}));
end To_degC;
