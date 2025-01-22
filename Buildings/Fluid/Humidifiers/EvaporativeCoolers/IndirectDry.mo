within Buildings.Fluid.Humidifiers.EvaporativeCoolers;
model IndirectDry
  "Indirect dry evaporative cooler"

  extends Buildings.Fluid.Interfaces.PartialFourPortParallel;

  replaceable package Medium1 =
    Modelica.Media.Interfaces.PartialMedium
    "Medium to be cooled"
    annotation (choices(
      choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
      choice(redeclare package Medium = Buildings.Media.Water "Water"),
      choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
        property_T=293.15,
        X_a=0.40)
        "Propylene glycol water, 40% mass fraction")));

  replaceable package Medium2 =
    Modelica.Media.Interfaces.PartialMedium
    "Medium rejected to outdoor air"
    annotation (choices(
      choice(redeclare package Medium = Buildings.Media.Air "Moist air")));

  parameter Real eps(
    final unit = "1")=0.8
    "Heat exchanger effectiveness";

  parameter Modelica.Units.SI.Pressure dp1_nominal
    "Nominal pressure drop of medium flow to be cooled";

  parameter Modelica.Units.SI.Pressure dp2_nominal
    "Nominal pressure drop of medium rejected to outdoor air";

  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal
    "Nominal mass flow rate of medium to be cooled";

  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal
    "Nominal mass flow rate of medium rejected to outdoor air";

  parameter Modelica.Units.SI.Area padAre
    "Area of the rigid media evaporative pad";

  parameter Modelica.Units.SI.Length dep
    "Depth of the rigid media evaporative pad";

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dmWat_flow(
    final unit="kg/s",
    final quantity="MassFlowRate")
    "Water vapor mass flow rate difference between inlet and outlet of secondary air"
    annotation (Placement(transformation(origin={120,90},extent={{-20,-20},{20,20}}),
      iconTransformation(origin={90,0}, extent={{-20,-20},{20,20}})));

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Direct dirEvaCoo(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final dp_nominal=dp2_nominal,
    final padAre=padAre,
    final dep=dep)
    "Direct evaporative cooler for representing effect on secondary air"
    annotation (Placement(transformation(origin={0,-60},extent={{-10,-10},{10,10}})));

  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final dp1_nominal=dp1_nominal,
    final dp2_nominal=dp2_nominal,
    final eps = eps,
    final m1_flow_nominal = m1_flow_nominal,
    final m2_flow_nominal = m2_flow_nominal)
    "Heat exchanger for heat transfer between primary and secondary air"
    annotation (Placement(transformation(origin={0,10},extent = {{-10, -10}, {10, 10}})));

equation
  connect(port_a2, dirEvaCoo.port_a)
    annotation (Line(points={{-100,-60},{-10,-60}}));
  connect(dirEvaCoo.port_b, hex.port_a2)
    annotation (Line(points={{10,-60},{10,4}}, color={0,127,255}));
  connect(hex.port_b2, port_b2) annotation (
    Line(points={{-10,4},{-10,-21},{100,-21},{100,-60}}, color = {0, 127, 255}));
  connect(port_a1, hex.port_a1) annotation (
    Line(points={{-100,60},{-10,60},{-10,16}}));
  connect(hex.port_b1, port_b1) annotation (
    Line(points={{10,16},{10,60},{100,60}}, color = {0, 127, 255}));
  connect(dirEvaCoo.dmWat_flow, dmWat_flow) annotation (Line(points={{9,-56},{60,
          -56},{60,90},{120,90}}, color={0,0,127}));

annotation (defaultComponentName="indDryEva",
Documentation(info="<html>
<p>
Model for a indirect dry evaporative cooler.
</p>
<p>
This model contains two components, a direct evaporative cooler 
(<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativeCoolers.Direct\">
Buildings.Fluid.Humidifiers.EvaporativeCoolers.Direct</a>) 
and an air-to-air heat exchanger with constant effectiveness
(<a href=\"modelica://Buildings.Fluid.HeatExchangers.ConstantEffectiveness\">
Buildings.Fluid.HeatExchangers.ConstantEffectiveness</a>). 
The secondary air travels through the rigid media pad of the direct evaporative
cooler and enters the air-to-air heat exchanger where it cools the primary air
flowing through the heat exchanger tubes.
</p>
<p>
Note: The model works correctly only when the ports a1 and a2 are used as inlet ports, 
and ports b1 and b2 are used as outlet ports, for the primary and secondary flow
respectively.
</p>
</html>", revisions="<html>
<ul>
<li>
September 20, 2023 by Cerrina Mouchref, Karthikeya Devaprasad, Lingzhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(graphics={Rectangle(lineColor = {0, 0, 255}, fillColor = {95, 95, 95}, pattern = LinePattern.None,
            fillPattern = FillPattern.Solid, extent={{-70,60},{70,-60}}),
  Text(textColor = {0, 0, 127}, extent={{-52,-60},{58,-120}}, textString = "m=%m_flow_nominal"),
  Rectangle(lineColor = {0, 0, 255}, pattern = LinePattern.None,
            fillPattern = FillPattern.Solid, extent={{-102,65},{98,56}}),
  Polygon(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
          fillPattern = FillPattern.Solid,
          points={{42,42},{54,34},{54,34},{42,28},{42,30},{50,34},{50,34},{42,40},{42,42}}),
  Rectangle(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
            fillPattern = FillPattern.Solid, extent={{58,-54},{54,52}}),
  Polygon(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
          fillPattern = FillPattern.Solid,
          points={{42,10},{54,2},{54,2},{42,-4},{42,-2},{50,2},{50,2},{42,8},{42,10}}),
  Polygon(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
          fillPattern = FillPattern.Solid,
          points={{42,-26},{54,-34},{54,-34},{42,-40},{42,-38},{50,-34},{50,-34},{42,-28},{42,-26}}),
  Rectangle(lineColor = {0, 0, 255}, pattern = LinePattern.None,
            fillPattern = FillPattern.Solid, extent={{-100,-55},{100,-64}}),
  Rectangle(lineColor = {0, 0, 255}, fillColor = {0, 62, 0}, pattern = LinePattern.None,
            fillPattern = FillPattern.Solid, extent={{-70,68},{70,-66}})}));
end IndirectDry;
