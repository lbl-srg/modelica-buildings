within Buildings.Controls.OBC.CDL.Psychrometrics;
block TDewPoi_TDryBulPhi
  "Block to compute the dew point temperature based on relative humidity"

  Interfaces.RealInput TDryBul(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final min=100) "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));

  Interfaces.RealInput phi(final min=0, final max=1, unit="1")
    "Relative air humidity"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  Interfaces.RealInput p(final quantity="Pressure",
                         final unit="Pa",
                         final min = 0) "Pressure"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));

  Interfaces.RealOutput TDewPoi(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final min=100) "Dew point temperature"    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  Modelica.SIunits.Pressure p_w(displayUnit="Pa") "Water vapor pressure";
  constant Real C14=6.54;
  constant Real C15=14.526;
  constant Real C16=0.7389;
  constant Real C17=0.09486;
  constant Real C18=0.4569;
  Real alpha;


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
<i>0</i>&deg;C and <i>93</i>&deg;C. It is the correlation from 2005
ASHRAE Handbook Fundamentals, p. 6.9.
</p>
</html>", revisions="<html>
<ul>
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
          extent={{-92,14},{-72,-12}},
          lineColor={0,0,127},
          textString="phi"),
        Text(
          extent={{-92,100},{-62,56}},
          lineColor={0,0,127},
          textString="TDryBul"),
        Text(
          extent={{-90,-72},{-72,-90}},
          lineColor={0,0,127},
          textString="p"),
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
end TDewPoi_TDryBulPhi;
