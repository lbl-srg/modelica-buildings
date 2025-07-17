within Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible;
model BypassDampers
  "Sensible heat recovery wheel with bypass dampers"
  extends Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible.BaseClasses.PartialWheel(
  from_dp1=true,
  from_dp2=true,
  hex(final dp1_nominal=0,
      final dp2_nominal=0) "Hex dp is lumped in damper");

  parameter Modelica.Units.SI.PressureDifference dpDamper_nominal(
    displayUnit="Pa") = 20
    "Nominal pressure drop of dampers";
  parameter Boolean use_strokeTime=true
    "Set to true to continuously open and close damper using strokeTime"
    annotation (Dialog(tab="Dynamics", group="Actuator position"));
  parameter Modelica.Units.SI.Time strokeTime=120
    "Time needed to fully open or close actuator"
    annotation (Dialog(tab="Dynamics", group="Actuator position", enable=use_strokeTime));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization of dampers (no init/steady state/initial state/initial output)"
    annotation (Dialog(tab="Dynamics", group="Actuator position", enable=use_strokeTime));
  parameter Real yByp_start=0
    "Initial position of bypass actuators"
    annotation (Dialog(tab="Dynamics", group="Actuator position", enable=use_strokeTime));
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
    final allowFlowReversal=allowFlowReversal1,
    final m_flow_nominal=per.mSup_flow_nominal,
    final from_dp=from_dp1,
    final linearized=linearizeFlowResistance1,
    final use_strokeTime=use_strokeTime,
    final strokeTime=strokeTime,
    final init=init,
    final y_start=yByp_start,
    final dpDamper_nominal=dpDamper_nominal)
    "Supply air bypass damper"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Fluid.Actuators.Dampers.Exponential damSup(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal1,
    final m_flow_nominal=per.mSup_flow_nominal,
    final from_dp=from_dp1,
    final linearized=linearizeFlowResistance1,
    final use_strokeTime=use_strokeTime,
    final strokeTime=strokeTime,
    final init=init,
    y_start=1-yByp_start,
    final dpDamper_nominal=dpDamper_nominal,
    final dpFixed_nominal=per.dpSup_nominal)
    "Supply air damper"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,origin={-50,6})));
  Buildings.Fluid.Actuators.Dampers.Exponential damExh(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal2,
    final m_flow_nominal=per.mExh_flow_nominal,
    final from_dp=from_dp2,
    final linearized=linearizeFlowResistance2,
    final use_strokeTime=use_strokeTime,
    final strokeTime=strokeTime,
    final init=init,
    y_start=1-yByp_start,
    final dpDamper_nominal=dpDamper_nominal,
    final dpFixed_nominal=per.dpExh_nominal)
    "Exhaust air damper"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=-90,origin={40,-40})));
  Buildings.Fluid.Actuators.Dampers.Exponential bypDamExh(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal2,
    final m_flow_nominal=per.mExh_flow_nominal,
    final from_dp=from_dp2,
    final linearized=linearizeFlowResistance2,
    final use_strokeTime=use_strokeTime,
    final strokeTime=strokeTime,
    final init=init,
    final y_start=yByp_start,
    final dpDamper_nominal=dpDamper_nominal)
    "Exhaust air bypass damper"
    annotation (Placement(transformation(extent={{-18,-90},{-38,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiEpsSen
    "Switch the heat exchanger effectiveness based on the wheel operation status"
    annotation (Placement(transformation(extent={{-60,190},{-40,210}})));

protected
  Modelica.Blocks.Sources.Constant uni(final k=1)
    "Unity signal"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    "Difference of the two inputs"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Modelica.Blocks.Math.BooleanToReal PEle(
    final realTrue=per.P_nominal,
    final realFalse=0)
    "Electric power consumption for motor"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));
  Modelica.Blocks.Sources.Constant zero(final k=0)
    "Zero signal"
    annotation (Placement(transformation(extent={{-140,170},{-120,190}})));

initial equation
  assert(not per.have_varSpe,
         "In " + getInstanceName() + ": The performance data record
         is wrong, the variable speed flag must be false",
         level=AssertionLevel.error)
         "Check if the performance data record is correct";

equation
  connect(bypDamSup.port_a, port_a1)
    annotation (Line(points={{-60,80},{-180,80}}, color={0,127,255}));
  connect(bypDamSup.port_b, port_b1)
    annotation (Line(points={{-40,80},{100,80}}, color={0,127,255}));
  connect(bypDamExh.port_a, port_a2)
    annotation (Line(points={{-18,-80},{100,-80}},
                                                 color={0,127,255}));
  connect(damExh.port_a, port_a2)
    annotation (Line(points={{40,-50},{40,-80},{100,-80}}, color={0,127,255}));
  connect(sub.y, damSup.y)
    annotation (Line(points={{-78,100},{14,100},{14,60},{-50,60},{-50,18}}, color={0,0,127}));
  connect(damExh.y,sub. y)
    annotation (Line(points={{28,-40},{14,-40},{14,100},{-78,100}}, color={0,0,127}));
  connect(bypDamSup.y, uBypDamPos)
    annotation (Line(points={{-50,92},{-50,140},{-202,140}}, color={0,0,127}));
  connect(damSup.port_b, hex.port_a1)
    annotation (Line(points={{-40,6},{-10,6}},
      color={0,127,255}));
  connect(bypDamExh.y, uBypDamPos)
    annotation (Line(points={{-28,-68},{-28,140},{-202,140}},
    color={0,0,127}));
  connect(hex.port_a2, damExh.port_b)
    annotation (Line(points={{10,-6},{40,-6},{40,-30}},
    color={0,127,255}));
  connect(sub.u2, uBypDamPos)
    annotation (Line(points={{-102,94},{-160,94},{-160,140},{-202,140}},
      color={0,0,127}));
  connect(uni.y, sub.u1)
    annotation (Line(points={{-119,120},{-110,120},{-110,106},{-102,106}},
      color={0,0,127}));
  connect(damSup.port_a, port_a1)
    annotation (Line(points={{-60,6},{-66,6},{-66,80},{-180,80}},
      color={0,127,255}));
  connect(PEle.y, P) annotation (Line(points={{-39,160},{70,160},{70,-40},{120,-40}},
      color={0,0,127}));
  connect(bypDamExh.port_b, port_b2)
    annotation (Line(points={{-38,-80},{-180,-80}}, color={0,127,255}));
  connect(zero.y,swiEpsSen. u3) annotation (Line(points={{-119,180},{-100,180},
          {-100,192},{-62,192}}, color={0,0,127}));
  connect(effCal.eps,swiEpsSen. u1) annotation (Line(points={{-78,0},{-70,0},{-70,
          208},{-62,208}}, color={0,0,127}));
  connect(swiEpsSen.y, hex.eps) annotation (Line(points={{-38,200},{-20,200},{
          -20,0},{-12,0}}, color={0,0,127}));
  connect(swiEpsSen.y, eps) annotation (Line(points={{-38,200},{80,200},{80,40},
          {120,40}}, color={0,0,127}));
  connect(uRot,swiEpsSen. u2) annotation (Line(points={{-200,0},{-170,0},{-170,
          200},{-62,200}}, color={255,0,255}));
  connect(PEle.u, uRot) annotation (Line(points={{-62,160},{-170,160},{-170,0},
          {-200,0}}, color={255,0,255}));
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
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-90,52},{-46,28}},
          textColor={0,0,127},
          textString="uBypDamPos"),
        Text(
          extent={{-92,-28},{-62,-50}},
          textColor={0,0,127},
          textString="uRot")}),
          Diagram(
        coordinateSystem(preserveAspectRatio=true, extent={{-180,-120},{100,220}})),
Documentation(info="<html>
<p>
Model of a sensible heat recovery wheel, which consists of
a heat exchanger and two dampers to bypass the supply and exhaust airflow, respectively.
</p>
<p>
This model does not require geometric data. The performance is defined by specifying the
part load (75% of the nominal supply flow rate) and nominal sensible heat exchanger effectiveness.
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
