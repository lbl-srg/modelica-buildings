within Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible;
model BypassDampers
  "Sensible heat recovery wheel with bypass dampers"
  extends
    Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible.BaseClasses.PartialWheel;
  parameter Modelica.Units.SI.PressureDifference dpDamper_nominal(displayUnit="Pa") = 20
    "Nominal pressure drop of dampers"
    annotation (Dialog(group="Nominal condition"));
  parameter Real P_nominal(final unit="W")
    "Power consumption at the design condition"
    annotation (Dialog(group="Nominal condition"));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uBypDamPos(
    final unit="1",
    final min=0,
    final max=1)
    "Bypass damper position"
    annotation (Placement(transformation(extent={{-222,120},{-182,160}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRot
    "True when the wheel is operating"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
        iconTransformation(extent={{-140,-62},{-100,-22}})));
  Buildings.Fluid.Actuators.Dampers.Exponential bypDamSup(
    redeclare package Medium = Medium,
    final m_flow_nominal=mSup_flow_nominal,
    final dpDamper_nominal=dpDamper_nominal)
    "Supply air bypass damper"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Fluid.Actuators.Dampers.Exponential damSup(
    redeclare package Medium = Medium,
    final m_flow_nominal=mSup_flow_nominal,
    final dpDamper_nominal=dpDamper_nominal)
    "Supply air damper"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},rotation=0,origin={-48,20})));
  Buildings.Fluid.Actuators.Dampers.Exponential damExh(
    redeclare package Medium = Medium,
    final m_flow_nominal=mExh_flow_nominal,
    final dpDamper_nominal=dpDamper_nominal)
    "Exhaust air damper"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},rotation=-90,origin={50,-40})));
  Buildings.Fluid.Actuators.Dampers.Exponential bypDamExh(
    redeclare package Medium = Medium,
    final m_flow_nominal=mExh_flow_nominal,
    final dpDamper_nominal=dpDamper_nominal)
    "Exhaust air bypass damper"
    annotation (Placement(transformation(extent={{0,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiepsSen
    "Switch the heat exchanger effectiveness based on the wheel operation status"
    annotation (Placement(transformation(extent={{-60,180},{-40,200}})));
protected
  Modelica.Blocks.Sources.Constant uni(final k=1)
    "Unity signal"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    "Difference of the two inputs"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Modelica.Blocks.Math.BooleanToReal PEle(
    final realTrue=P_nominal,
    final realFalse=0)
    "Electric power consumption for motor"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));
protected
  Modelica.Blocks.Sources.Constant zero(final k=0) "Zero signal"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
equation
  connect(bypDamSup.port_a, port_a1)
    annotation (Line(points={{-60,80},{-180,80}}, color={0,127,255}));
  connect(bypDamSup.port_b, port_b1)
    annotation (Line(points={{-40,80},{100,80}}, color={0,127,255}));
  connect(bypDamExh.port_a, port_a2)
    annotation (Line(points={{0,-80},{100,-80}},  color={0,127,255}));
  connect(damExh.port_a, port_a2)
    annotation (Line(points={{50,-50},{50,-80},{100,-80}}, color={0,127,255}));
  connect(sub.y, damSup.y)
    annotation (Line(points={{-78,100},{20,100},{20,60},{-48,60},{-48,32}}, color={0,0,127}));
  connect(damExh.y,sub. y)
    annotation (Line(points={{38,-40},{20,-40},{20,100},{-78,100}}, color={0,0,127}));
  connect(bypDamSup.y, uBypDamPos)
    annotation (Line(points={{-50,92},{-50,140},{-202,140}}, color={0,0,127}));
  connect(damSup.port_b, hex.port_a1)
    annotation (Line(points={{-38,20},{-16,20},{-16,6},{-10,6}},
    color={0,127,255}));
  connect(bypDamExh.y, uBypDamPos)
    annotation (Line(points={{-10,-68},{-10,-60},{-20,-60},{-20,140},{-202,140}},
    color={0,0,127}));
  connect(hex.port_a2, damExh.port_b)
    annotation (Line(points={{10,-6},{16,-6},{16,-16},{50,-16},{50,-30}},
    color={0,127,255}));
  connect(sub.u2, uBypDamPos)
    annotation (Line(points={{-102,94},{-160,94},{-160,140},{-202,140}},
    color={0,0,127}));
  connect(uni.y, sub.u1)
    annotation (Line(points={{-119,120},{-110,120},{-110,106},{-102,106}},
    color={0,0,127}));
  connect(damSup.port_a, port_a1)
    annotation (Line(points={{-58,20},{-166,20},{-166,80},{-180,80}},
    color={0,127,255}));
  connect(PEle.y, P) annotation (Line(points={{-39,160},{70,160},{70,-40},{120,-40}},
    color={0,0,127}));
  connect(bypDamExh.port_b, port_b2)
    annotation (Line(points={{-20,-80},{-180,-80}}, color={0,127,255}));
  connect(zero.y, swiepsSen.u3) annotation (Line(points={{-139,-30},{-116,-30},{
          -116,82},{-68,82},{-68,182},{-62,182}},
                           color={0,0,127}));
  connect(effCal.eps, swiepsSen.u1) annotation (Line(points={{-78,0},{-74,0},{-74,
          198},{-62,198}},
                         color={0,0,127}));
  connect(swiepsSen.y, hex.eps) annotation (Line(points={{-38,190},{-32,190},{-32,
          0},{-12,0}}, color={0,0,127}));
  connect(swiepsSen.y, eps) annotation (Line(points={{-38,190},{80,190},{80,40},
          {120,40}},                color={0,0,127}));
  connect(uRot, swiepsSen.u2) annotation (Line(points={{-200,0},{-170,0},{-170,190},
          {-62,190}}, color={255,0,255}));
  connect(PEle.u, uRot) annotation (Line(points={{-62,160},{-120,160},{-120,190},
          {-170,190},{-170,0},{-200,0}}, color={255,0,255}));
annotation (
        defaultComponentName="whe",
        Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
        graphics={
        Polygon(
          points={{0,100},{0,100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.None),
        Rectangle(
          extent={{-64,96},{58,92}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10.5,3.5},{10.5,-3.5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-60.5,84.5},
          rotation=90),
        Rectangle(
          extent={{-9,3},{9,-3}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={55,85},
          rotation=90),
        Rectangle(
          extent={{-8,3},{8,-3}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={55,-84},
          rotation=90),
        Rectangle(
          extent={{-9,3},{9,-3}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-61,-83},
          rotation=90),
        Rectangle(
          extent={{-64,-92},{58,-96}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
          Diagram(
        coordinateSystem(preserveAspectRatio=true, extent={{-180,-120},{100,220}})),
Documentation(info="<html>
<p>
Model of a sensible heat recovery wheel, which consists of
a heat exchanger and two dampers to bypass the supply and exhaust airflow.
</p>
<p>
This model does not require geometric data. The performance is defined by specifying the
part load (75% of the nominal supply flow rate) and nominal sensible heat exchanger effectiveness in both heating and cooling conditions.
This operation of the wheel is configured as follows.
</p>
<ul>
<li>
If the operating signal <code>uRot=true</code>,
<ul>
<li>
The wheel power consumption is constant and equal to the nominal value.
</li>
<li>
The heat exchange in the heat recovery wheel is adjustable via bypassing supply/exhaust air
through the heat exchanger.
Accordingly, the sensible heat exchanger effectiveness is calculated with
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible.BaseClasses.Effectiveness\">
Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible.BaseClasses.Effectiveness</a>.
</li>
</ul>
</li>
<li>
Otherwise,
<ul>
<li>
The wheel power consumption is 0.
</li>
<li>
In addition, there is no heat transfer, i.e., the sensible
heat exchanger effectiveness of the heat recovery wheel is 0.
</li>
</ul>
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
January 8, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end BypassDampers;
