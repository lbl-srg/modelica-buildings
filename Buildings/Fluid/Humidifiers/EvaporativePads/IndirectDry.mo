within Buildings.Fluid.Humidifiers.EvaporativePads;
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
    "Nominal heat exchanger pressure drop of medium flow to be cooled";
  parameter Modelica.Units.SI.Pressure dp2_nominal
    "Nominal heat exchanger pressure drop of medium rejected to outdoor air";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal
    "Nominal heat exchanger mass flow rate of medium to be cooled";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal
    "Nominal heat exchanger mass flow rate of medium rejected to outdoor air";
  parameter Modelica.Units.SI.Area padAre
    "Area of the rigid media evaporative pad";
  replaceable parameter Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic per
    constrainedby Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic
    "Record with performance data for evaporative pads"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dmWat_flow(
    final unit="kg/s",
    final quantity="MassFlowRate")
    "Water vapor mass flow rate difference between inlet and outlet of secondary air"
    annotation (Placement(transformation(origin={120,90},extent={{-20,-20},{20,20}}),
      iconTransformation(origin={90,0}, extent={{-20,-20},{20,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput evaCooAct
    "True: the evaporative cooling is active"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-110,-20},{-70,20}})));
protected
  Buildings.Fluid.Humidifiers.EvaporativePads.Direct dirEvaPad(
    redeclare final package Medium = Medium2,
    final padAre=padAre,
    per(final efficiency=per.efficiency,
      final v_nominal=per.v_nominal,
      final dp_nominal=per.dp_nominal,
      final n=per.n))
    "Direct evaporative pad for representing the cooling effect on the secondary air"
    annotation (Placement(transformation(origin={0,-60}, extent={{-10,-10},{10,10}})));
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
  connect(port_a2,dirEvaPad. port_a)
    annotation (Line(points={{-100,-60},{-10,-60}}));
  connect(hex.port_b2, port_b2) annotation (
    Line(points={{-10,4},{-20,4},{-20,-20},{80,-20},{80,-60},{100,-60}}, color = {0, 127, 255}));
  connect(port_a1, hex.port_a1) annotation (
    Line(points={{-100,60},{-20,60},{-20,16},{-10,16}}));
  connect(hex.port_b1, port_b1) annotation (
    Line(points={{10,16},{20,16},{20,60},{100,60}}, color = {0, 127, 255}));
  connect(dirEvaPad.dmWat_flow, dmWat_flow) annotation (Line(points={{9,-56},{60,
          -56},{60,90},{120,90}}, color={0,0,127}));
  connect(dirEvaPad.port_b, hex.port_a2) annotation (Line(points={{10,-60},{20,-60},
          {20,4},{10,4}}, color={0,127,255}));
  connect(evaCooAct, dirEvaPad.evaCooAct) annotation (Line(points={{-120,0},{-60,
          0},{-60,-64},{-9,-64}}, color={255,0,255}));
annotation (defaultComponentName="indDryEva",
Documentation(info="<html>
<p>
Model for an indirect dry evaporative cooler.
</p>
<p>
This model contains two components, a direct evaporative pad 
(<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativePads.Direct\">
Buildings.Fluid.Humidifiers.EvaporativePads.Direct</a>) 
and an air-to-air heat exchanger with constant effectiveness
(<a href=\"modelica://Buildings.Fluid.HeatExchangers.ConstantEffectiveness\">
Buildings.Fluid.HeatExchangers.ConstantEffectiveness</a>). 
The secondary air travels through the evaporative pad and enters the air-to-air heat
exchanger where it cools the primary air flowing through the heat exchanger tubes.
</p>
<p>
The input variable <code>evaCooAct</code> determines whether the evaporative cooling
is active (such that the evaporative pad is wet). When evaporative cooling is not
active (the evaporative pad is dry), no water vapor is added to the air.
</p>
<p>
<b>Note:</b> The model works correctly only when the ports a1 and a2 are used as inlet ports, 
and ports b1 and b2 are used as outlet ports, for the primary and secondary flow
respectively.
</p>
</html>", revisions="<html>
<ul>
<li>
July 21, 2026, by Weiping Huang:<br/>
Added a Modelica data record to calculate saturation efficiency and pressure drop,
as well as added a flag to turn on and off the evaporative cooling for the
evaporative pad.
</li>
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
