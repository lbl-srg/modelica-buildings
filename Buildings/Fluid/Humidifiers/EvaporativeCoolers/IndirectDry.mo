within Buildings.Fluid.Humidifiers.EvaporativeCoolers;
model IndirectDry "Indirect dry evaporative cooler"
  extends Buildings.Fluid.Interfaces.PartialFourPortParallel(
    redeclare package Medium1=Medium,
    redeclare package Medium2=Medium);
  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Direct dirEvaCoo(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    padAre=padAre,
    dep=dep)
    "Direct evaporative cooler for representing effect on primary air"
    annotation (Placement(visible=true, transformation(
        origin={-4,-58},
        extent={{-10,-10},{10,10}},
        rotation=0)));

  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,                                                                                                                      dp1_nominal = dp_nom, dp2_nominal = dp_nom, eps = eps, m1_flow_nominal = mflownom1, m2_flow_nominal = mflownom2) annotation (
    Placement(visible = true, transformation(origin = {64, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter Real eps(final unit = "1") = 0.67;
  parameter Real dp_nom(final unit = "1") = 10;

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    annotation (__Dymola_choicesAllMatching=true);
  parameter Real mAirPri_flow_nominal "Primary air nominal mass flow rate";
  parameter Real mAirSec_flow_nominal "Secondary air nominal mass flow rate";

  parameter Modelica.Units.SI.Area padAre
    "Area of the rigid media evaporative pad";
  parameter Modelica.Units.SI.Length dep
    "Depth of the rigid media evaporative pad";
equation
  connect(port_a2, dirEvaCoo.port_a)
    annotation (Line(points={{-100,-60},{-14,-60},{-14,-58}}));
  connect(dirEvaCoo.port_b, hex.port_a2)
    annotation (Line(points={{6,-58},{74,-58},{74,32}}, color={0,127,255}));
  connect(hex.port_b2, port_b2) annotation (
    Line(points = {{54, 32}, {54, -19}, {100, -19}, {100, -60}}, color = {0, 127, 255}));
  connect(port_a1, hex.port_a1) annotation (
    Line(points = {{-100, 60}, {-12, 60}, {-12, 44}, {54, 44}}));
  connect(hex.port_b1, port_b1) annotation (
    Line(points = {{74, 44}, {74, 48}, {100, 48}, {100, 60}}, color = {0, 127, 255}));
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
