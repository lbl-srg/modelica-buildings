within Buildings.Experimental.OpenBuildingControl.CDL.Psychrometrics;
block h_TDryBulPhi
  "Block to compute the specific enthalpy based on relative humidity"

  Interfaces.RealInput TDryBul(
    start=Buildings.Media.Air.T_default,
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min=0) "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Interfaces.RealInput phi(min=0, max=1)
    "Relative air humidity"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Interfaces.RealInput p(
    final quantity="Pressure",
    final unit="Pa",
    min = 0) "Pressure"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));

  Interfaces.RealOutput h(
    final quantity="SpecificEnergy",
    final unit="J/kg") "Specific enthalpy"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TDryBul_degC
    "Dry bulb temperature in degree Celsius";
  Modelica.SIunits.Pressure p_w(displayUnit="Pa") "Water vapor pressure";
  Modelica.SIunits.MassFraction XiDryBul(nominal=0.01)
    "Water vapor mass fraction at dry bulb state";

  // Modelica.SIunits.Temperature T_ref = 273.15
  //     "Reference temperature for psychrometric calculations"
  // constant Modelica.SIunits.SpecificHeatCapacity cpAir=1006
  //   "Specific heat capacity of air";
  // constant Modelica.SIunits.SpecificHeatCapacity cpSte=1860
  //   "Specific heat capacity of water vapor";
  // constant Modelica.SIunits.SpecificHeatCapacity cpWatLiq = 4184
  //   "Specific heat capacity of liquid water";
  // constant Modelica.SIunits.SpecificEnthalpy h_fg = 2501014.5
  //   "Enthalpy of evaporation of water at the reference temperature";
  // constant Real k_mair = 0.6219647130774989 "Ratio of molar weights";

equation
  TDryBul_degC = TDryBul - 273.15;
  p_w = phi * Buildings.Experimental.OpenBuildingControl.CDL.Psychrometrics.Functions.saturationPressure(TDryBul);
  XiDryBul = 0.6219647130774989*p_w/(p-p_w);
  h = 1006*TDryBul_degC + XiDryBul*(2501014.5+1860*TDryBul_degC);


    annotation (
    defaultComponentName="dewPoi",
    Documentation(info="<html>
<p>
The correlation used in this model is from 2005
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
end h_TDryBulPhi;
