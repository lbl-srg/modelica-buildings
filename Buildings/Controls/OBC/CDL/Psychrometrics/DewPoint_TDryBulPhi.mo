within Buildings.Controls.OBC.CDL.Psychrometrics;
block DewPoint_TDryBulPhi
  "Block to compute the dew point temperature based on relative humidity"

  Interfaces.RealInput TDryBul(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final min=100) "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

  Interfaces.RealInput phi(final min=0, final max=1, unit="1")
    "Relative air humidity"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));

  Interfaces.RealOutput TDewPoi(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final min=100) "Dew point temperature"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  Modelica.SIunits.Pressure p_w(displayUnit="Pa") "Water vapor pressure";
  constant Real C14=6.54 "Constant used in the equation";
  constant Real C15=14.526 "Constant used in the equation";
  constant Real C16=0.7389 "Constant used in the equation";
  constant Real C17=0.09486 "Constant used in the equation";
  constant Real C18=0.4569 "Constant used in the equation";
  Real alpha "Variable used in the equation";

equation
  p_w = phi * Buildings.Utilities.Psychrometrics.Functions.saturationPressure(TDryBul);
  alpha = Modelica.Math.log(p_w/1000.0);

  TDewPoi = (C14 + C15*alpha + C16*alpha^2 + C17*alpha^3 + C18*(p_w/1000.0)^0.1984)+273.15;

annotation (
    defaultComponentName="dewPoi",
    Documentation(info="<html>
<p>
Dew point temperature calculation for moist air above freezing temperature.
</p>
<p>
The correlation used in this model is valid for dew point temperatures between
<i>0</i>&deg;C and <i>93</i>&deg;C. It is the correlation from 2009
ASHRAE Handbook Fundamentals, p. 1.9, equation 39.
</p>
</html>", revisions="<html>
<ul>
<li>
September 29, 2020, by Michael Wetter:<br/>
Removed unused input <code>p</code> and renamed block.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2139\">issue 2139</a>
</li>
<li>
April 7, 2017 by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={  Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-44,82},{-22,64}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="X"),
        Polygon(
          points={{-48,88},{-46,74},{-50,74},{-48,88}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-90,-46},{-70,-72}},
          lineColor={0,0,127},
          textString="phi"),
        Text(
          extent={{-92,82},{-62,38}},
          lineColor={0,0,127},
          textString="TDryBul"),
        Polygon(
          points={{86,-74},{76,-72},{76,-76},{86,-74}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{76,-78},{86,-94}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="T"),
        Line(points={{-48,84},{-48,-74}}),
        Text(
          extent={{60,14},{98,-12}},
          lineColor={0,0,127},
          textString="TDewPoi"),
        Line(points={{82,-72},{-66,-72}}),
        Line(points={{-48,-40},{-38,-36},{-24,-30},{8,-2},{20,22},{28,54},{32,
              74}}),
        Line(
          points={{68,-12},{-2,-12}},
          color={255,0,0},
          thickness=0.5),
        Polygon(
          points={{-2,-12},{12,-10},{12,-14},{-2,-12}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{66,-44},{-48,-44}}, color={175,175,175}),
        Line(points={{68,-18},{-10,-18}}, color={175,175,175}),
        Line(points={{70,6},{12,6}}, color={175,175,175}),
        Line(points={{68,32},{22,32}}, color={175,175,175})}));
end DewPoint_TDryBulPhi;
