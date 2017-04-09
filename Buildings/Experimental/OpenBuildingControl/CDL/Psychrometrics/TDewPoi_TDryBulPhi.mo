within Buildings.Experimental.OpenBuildingControl.CDL.Psychrometrics;
block TDewPoi_TDryBulPhi
  "Block to compute the dew point temperature based on relative humidity"
  final package Medium =
      Buildings.Experimental.OpenBuildingControl.CDL.Psychrometrics.Media.Air   "Medium model";

  Interfaces.RealInput TDryBul(
    start=Medium.T_default,
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min=100) "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));

  Interfaces.RealInput phi(min=0, max=1)
    "Relative air humidity"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  Interfaces.RealInput p(final quantity="Pressure",
                         final unit="Pa",
                         min = 0) "Pressure"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));

  Interfaces.RealOutput TDewPoi(
    start=Medium.T_default-2,
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min=0) "Dew point temperature"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  Modelica.SIunits.Pressure p_w(displayUnit="Pa") "Water vapor pressure";
  constant Real C14=6.54;
  constant Real C15=14.526;
  constant Real C16=0.7389;
  constant Real C17=0.09486;
  constant Real C18=0.4569;
  Real alpha;


equation
  p_w = phi * Buildings.Experimental.OpenBuildingControl.CDL.Psychrometrics.Functions.saturationPressure(TDryBul);
  alpha = Modelica.Math.log(p_w/1000.0);

  TDewPoi = (C14 + C15*alpha + C16*alpha^2 + C17*alpha^3 + C18*(p_w/1000.0)^0.1984)+273.15;

//   TDewPoi = Buildings.Experimental.OpenBuildingControl.CDL.Psychrometrics.Functions.TDewPoi_pW(p_w);

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
            100}}), graphics={
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-124,50},{-86,4}},
          lineColor={0,0,255},
          textString="p_w"),
        Text(
          extent={{102,46},{140,0}},
          lineColor={0,0,255},
          textString="TDP"),
        Line(points={{-68,86},{-68,-72}}),
        Line(points={{82,-72},{-66,-72}}),
        Line(points={{-68,-46},{-54,-42},{-24,-30},{8,-2},{20,22},{28,54},{32,
              74}}),
        Line(
          points={{42,-32},{-28,-32}},
          color={255,0,0},
          thickness=0.5),
        Polygon(
          points={{-28,-32},{-14,-30},{-14,-34},{-28,-32}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{84,-72},{74,-70},{74,-74},{84,-72}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-68,88},{-66,74},{-70,74},{-68,88}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-64,84},{-42,66}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="X"),
        Text(
          extent={{82,-80},{92,-96}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="T"),
        Line(points={{68,-44},{-62,-44}}, color={175,175,175}),
        Line(points={{68,-18},{-10,-18}}, color={175,175,175}),
        Line(points={{70,6},{12,6}}, color={175,175,175}),
        Line(points={{68,32},{22,32}}, color={175,175,175})}));
end TDewPoi_TDryBulPhi;
