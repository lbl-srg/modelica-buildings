within Buildings.Fluid.Humidifiers.EvaporativeCoolers;
model IndirectDry "Indirect dry evaporative cooler"

  extends Buildings.Fluid.Interfaces.PartialFourPortParallel(
    redeclare final package Medium1=MediumPri,
    redeclare final package Medium2=MediumSec);

  replaceable package MediumPri =
    Modelica.Media.Interfaces.PartialMedium
    "Medium 1 in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));
  replaceable package MediumSec =
    Modelica.Media.Interfaces.PartialMedium
    "Medium 2 in the component"
    annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air")));

  parameter Real eps(final unit = "1")=0.8
    "Heat exchanger effectiveness";
  parameter Modelica.Units.SI.Pressure dp_nom
    "Nominal pressure drop";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal_AirPri
    "Primary air nominal mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal_AirSec
    "Secondary air nominal mass flow rate";
  parameter Modelica.Units.SI.Area padAre
    "Area of the rigid media evaporative pad";
  parameter Modelica.Units.SI.Length dep
    "Depth of the rigid media evaporative pad";

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Direct dirEvaCoo(
    redeclare package Medium = MediumSec,
    m_flow_nominal=m_flow_nominal_AirSec,
    padAre=padAre,
    dep=dep)
    "Direct evaporative cooler for representing effect on primary air"
    annotation (Placement(visible=true, transformation(
        origin={0,-60},
        extent={{-10,-10},{10,10}},
        rotation=0)));

  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = MediumPri,
    redeclare package Medium2 = MediumSec,
    dp1_nominal = dp_nom,
    dp2_nominal = dp_nom,
    eps = eps,
    m1_flow_nominal=m_flow_nominal_AirPri,
    m2_flow_nominal=m_flow_nominal_AirSec)
    "Heat exchanger for heat transfer between primary and secondary air"
    annotation (Placement(visible = true, transformation(origin={0,8},extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(port_a2, dirEvaCoo.port_a)
    annotation (Line(points={{-100,-60},{-10,-60}}));
  connect(dirEvaCoo.port_b, hex.port_a2)
    annotation (Line(points={{10,-60},{10,2}},          color={0,127,255}));
  connect(hex.port_b2, port_b2) annotation (
    Line(points={{-10,2},{-10,-19},{100,-19},{100,-60}},         color = {0, 127, 255}));
  connect(port_a1, hex.port_a1) annotation (
    Line(points={{-100,60},{-12,60},{-12,14},{-10,14}}));
  connect(hex.port_b1, port_b1) annotation (
    Line(points={{10,14},{10,48},{100,48},{100,60}},          color = {0, 127, 255}));
  annotation (
    Documentation, Icon(graphics={
                     Rectangle(lineColor = {0, 0, 255}, fillColor = {95, 95, 95}, pattern = LinePattern.None,
            fillPattern =                                                                                                   FillPattern.Solid, extent={{
              -70,60},{70,-60}}),                                                                                                                                                                                                        Text(textColor = {0, 0, 127}, extent={{
              -52,-60},{58,-120}},                                                                                                                                                                                                        textString = "m=%m_flow_nominal"), Rectangle(lineColor = {0, 0, 255}, pattern = LinePattern.None,
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, extent={{
              -102,65},{98,56}}),                                                                                                                                                                                                        Polygon(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, points={{
              42,42},{54,34},{54,34},{42,28},{42,30},{50,34},{50,34},{42,40},{42,
              42}}),                                                                                                                                                                                                        Rectangle(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, extent={{
              58,-54},{54,52}}),                                                                                                                                                                                                        Polygon(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, points={{
              42,10},{54,2},{54,2},{42,-4},{42,-2},{50,2},{50,2},{42,8},{42,10}}),                                                                                                                                                                                                        Polygon(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, points={{
              42,-26},{54,-34},{54,-34},{42,-40},{42,-38},{50,-34},{50,-34},{42,
              -28},{42,-26}}),                                                                                                                                                                                                        Rectangle(lineColor = {0, 0, 255}, pattern = LinePattern.None,
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, extent={{
              -100,-55},{100,-64}}),                                                                                                                                                                                                        Rectangle(lineColor = {0, 0, 255}, fillColor = {0, 62, 0}, pattern = LinePattern.None,
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, extent={{
              -70,68},{70,-66}})}));
end IndirectDry;
