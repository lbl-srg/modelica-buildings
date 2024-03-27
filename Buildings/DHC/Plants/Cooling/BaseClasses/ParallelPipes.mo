within Buildings.DHC.Plants.Cooling.BaseClasses;
model ParallelPipes "CHW supply and return pipes in parallel"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    final m1_flow_nominal = m_flow_nominal,
    final m2_flow_nominal = m_flow_nominal);

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium package";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal(
    final displayUnit="Pa")
    "Nominal pressure drop"
    annotation(Dialog(group="Nominal condition"));

  Buildings.Fluid.FixedResistances.PressureDrop preDro1(
    redeclare package Medium = Medium1,
    final allowFlowReversal=true,
    final dp_nominal=dp_nominal,
    final m_flow_nominal=m1_flow_nominal) "Flow resistance"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDro2(
    redeclare package Medium = Medium2,
    final allowFlowReversal=true,
    final dp_nominal=dp_nominal,
    final m_flow_nominal=m2_flow_nominal) "Flow resistance"
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
equation
  connect(preDro1.port_a, port_a1)
    annotation (Line(points={{-10,60},{-100,60}}, color={0,127,255}));
  connect(preDro1.port_b, port_b1)
    annotation (Line(points={{10,60},{100,60}}, color={0,127,255}));
  connect(preDro2.port_a, port_a2)
    annotation (Line(points={{10,-60},{100,-60}}, color={0,127,255}));
  connect(preDro2.port_b, port_b2)
    annotation (Line(points={{-10,-60},{-100,-60}}, color={0,127,255}));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-28,72},{28,48}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-100,62},{100,58}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-100,-58},{100,-62}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-30,-48},{26,-72}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0})}),
defaultComponentName="parPip",
Documentation(info="<html>
<p>
This model contains two pipes in parallel that represent the supply and return
pipes of a district CHW network.
Only pressure drop is considered. This model does not consider heat loss.
</p>
</html>", revisions="<html>
<ul>
<li>
July 27, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end ParallelPipes;
