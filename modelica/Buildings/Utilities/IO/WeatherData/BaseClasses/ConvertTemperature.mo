within Buildings.Utilities.IO.WeatherData.BaseClasses;
block ConvertTemperature
  "Converts the temperature unit from Celsius to Kelvin and checks the validity of data"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  Modelica.Blocks.Interfaces.RealInput TemC(final quantity="Temperature",
      final unit="degC") "Temperature in Celsius"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput TemK(final quantity="Temperature",
      final unit="K") "Temperature in Kelvin"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

 constant Modelica.SIunits.Temperature TMin=273.15-70
    "Minimum allowed temperature";
 constant Modelica.SIunits.Temperature TMax=273.15+70
    "Maximum allowed temperature";
equation
  TemK = TemC - Modelica.Constants.T_zero;
  assert(TemK > TMin, "Temperature out of bounds.\n" +
     "   TemK = " + realString(TemK));
  assert(TemK < TMax, "Temperature out of bounds.\n" +
     "   TemK = " + realString(TemK));

  annotation (
    defaultComponentName="conTem",
    Documentation(info="<HTML>
<p>
This component converts the temperature from Celsius to Kelvin.
If the temperature is outside <code>TMin</code> and <code>TMax</code>, the simulation will stop with an error.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
July 08, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={           Text(
          extent={{-24,100},{-104,20}},
          lineColor={0,0,0},
          textString="K"),
        Polygon(
          points={{86,0},{26,20},{26,-20},{86,0}},
          lineColor={0,0,255},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Line(points={{-94,0},{26,0}}, color={0,0,255}),
                           Text(
          extent={{96,-20},{16,-100}},
          lineColor={0,0,0},
          textString="°C")}));
end ConvertTemperature;
