within Buildings.Fluid.HeatExchangers.ThermalWheels.Latent;
model BypassDampers
  "Enthalpy recovery wheel with bypass dampers"
  extends
    Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.BaseClasses.PartialWheel;
  parameter Modelica.Units.SI.PressureDifference
    dpDamper_nominal(displayUnit="Pa") = 20
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
    annotation (Placement(transformation(extent={{-220,120},{-180,160}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRot
    "True when the wheel is operating"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Fluid.Actuators.Dampers.Exponential bypDamSup(
    redeclare package Medium = Medium,
    final m_flow_nominal=mSup_flow_nominal,
    final dpDamper_nominal=dpDamper_nominal)
    "Supply air bypass damper"
    annotation (Placement(transformation(extent={{-48,70},{-28,90}})));
  Buildings.Fluid.Actuators.Dampers.Exponential damSup(
    redeclare package Medium = Medium,
    final m_flow_nominal=mSup_flow_nominal,
    final dpDamper_nominal=dpDamper_nominal)
    "Supply air damper"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},rotation=0,origin={-90,36})));
  Buildings.Fluid.Actuators.Dampers.Exponential damExh(
    redeclare package Medium = Medium,
    final m_flow_nominal=mExh_flow_nominal,
    final dpDamper_nominal=dpDamper_nominal)
    "Exhaust air damper"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},rotation=-90,origin={40,-44})));
  Buildings.Fluid.Actuators.Dampers.Exponential bypDamExh(
    redeclare package Medium = Medium,
    final m_flow_nominal=mExh_flow_nominal,
    final dpDamper_nominal=dpDamper_nominal)
    "Exhaust air bypass damper"
    annotation (Placement(transformation(extent={{0,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiepsSen
    "Switch the sensible heat exchanger effectiveness 
    based the wheel operation status"
    annotation (Placement(transformation(extent={{-40,150},{-20,170}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiLat
    "Switch the latent heat exchanger effectiveness 
    based the wheel operation status"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));
protected
  Modelica.Blocks.Sources.Constant uni(final k=1)
    "Unity signal"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    "Difference of the two inputs"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Modelica.Blocks.Math.BooleanToReal PEle(
    final realTrue=P_nominal,
    final realFalse=0) "Electric power consumption for motor"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));
protected
  Modelica.Blocks.Sources.Constant zero(final k=0) "Zero signal"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
equation
  connect(sub.y, damSup.y)
    annotation (Line(points={{-78,100},{0,100},{0,54},{-90,54},{-90,48}},
    color={0,0,127}));
  connect(damExh.y,sub. y)
    annotation (Line(points={{28,-44},{0,-44},{0,100},{-78,100}},   color={0,0,127}));
  connect(bypDamSup.y, uBypDamPos)
    annotation (Line(points={{-38,92},{-38,98},{-72,98},{-72,84},{-160,84},{-160,
          140},{-200,140}},                                  color={0,0,127}));
  connect(damSup.port_b, hex.port_a1)
    annotation (Line(points={{-80,36},{-30,36},{-30,6},{10,6}},
    color={0,127,255}));
  connect(bypDamExh.y, uBypDamPos)
    annotation (Line(points={{-10,-48},{-10,-40},{-94,-40},{-94,-24},{-114,-24},
          {-114,84},{-160,84},{-160,140},{-200,140}},
    color={0,0,127}));
  connect(sub.u2, uBypDamPos)
    annotation (Line(points={{-102,94},{-160,94},{-160,140},{-200,140}},
    color={0,0,127}));
  connect(uni.y, sub.u1)
    annotation (Line(points={{-119,120},{-110,120},{-110,106},{-102,106}},
    color={0,0,127}));
  connect(PEle.y, P) annotation (Line(points={{-139,-80},{80,-80},{80,-90},{120,-90}},
    color={0,0,127}));
  connect(damSup.port_a, port_a1) annotation (Line(points={{-100,36},{-130,36},{-130,80},{-180,80}},
    color={0,127,255}));
  connect(damExh.port_b, hex.port_a2)
    annotation (Line(points={{40,-34},{40,-6},{30,-6}}, color={0,127,255}));
  connect(bypDamExh.port_b, port_b2)
    annotation (Line(points={{-20,-60},{-180,-60}}, color={0,127,255}));
  connect(damExh.port_a, port_a2)
    annotation (Line(points={{40,-54},{40,-60},{100,-60}}, color={0,127,255}));
  connect(bypDamExh.port_a, port_a2)
    annotation (Line(points={{0,-60},{100,-60}}, color={0,127,255}));
  connect(bypDamSup.port_b, port_b1)
    annotation (Line(points={{-28,80},{100,80}}, color={0,127,255}));
  connect(bypDamSup.port_a, port_a1)
    annotation (Line(points={{-48,80},{-180,80}}, color={0,127,255}));
  connect(PEle.u, uRot) annotation (Line(points={{-162,-80},{-168,-80},{-168,0},
          {-200,0}}, color={255,0,255}));
  connect(zero.y, swiepsSen.u3) annotation (Line(points={{-119,160},{-60,160},{-60,
          152},{-42,152}}, color={0,0,127}));
  connect(swiLat.u3, zero.y) annotation (Line(points={{-42,122},{-60,122},{-60,160},
          {-119,160}}, color={0,0,127}));
  connect(effCal.epsSen, swiepsSen.u1) annotation (Line(points={{-78,5},{-68,5},
          {-68,168},{-42,168}}, color={0,0,127}));
  connect(effCal.epsLat, swiLat.u1) annotation (Line(points={{-78,-5},{-64,-5},{
          -64,138},{-42,138}}, color={0,0,127}));
  connect(swiepsSen.u2, uRot) annotation (Line(points={{-42,160},{-52,160},{-52,
          176},{-168,176},{-168,0},{-200,0}}, color={255,0,255}));
  connect(swiLat.u2, uRot) annotation (Line(points={{-42,130},{-52,130},{-52,176},
          {-168,176},{-168,0},{-200,0}}, color={255,0,255}));
  connect(swiepsSen.y, hex.epsSen) annotation (Line(points={{-18,160},{-6,160},{
          -6,3},{8,3}}, color={0,0,127}));
  connect(swiLat.y, hex.epsLat) annotation (Line(points={{-18,130},{-10,130},{-10,
          -3},{8,-3}}, color={0,0,127}));
  connect(swiepsSen.y, epsSen) annotation (Line(points={{-18,160},{38,160},{38,30},
          {120,30}}, color={0,0,127}));
  connect(swiLat.y, epsLat) annotation (Line(points={{-18,130},{88,130},{88,-30},
          {120,-30}}, color={0,0,127}));
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
          extent={{-58,94},{64,86}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,4},{18,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={60,76},
          rotation=90),
        Rectangle(
          extent={{-18.5,3.5},{18.5,-3.5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-54.5,74.5},
          rotation=90),
        Rectangle(
          extent={{-16.5,3.5},{16.5,-3.5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-54.5,-73.5},
          rotation=90),
        Rectangle(
          extent={{-58,-84},{64,-92}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,4},{18,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={60,-74},
          rotation=90)}),
          Diagram(
        coordinateSystem(preserveAspectRatio=true, extent={{-180,-100},{100,180}})),
Documentation(info="<html>
<p>
Model of an enthalpy recovery wheel, which consists of
a heat exchanger and two dampers to bypass the supply and exhaust airflow.
</p>
<p>
This model does not require geometric data. The performance is defined by specifying
the part load (75% of the nominal supply flow rate) and nominal sensible and latent
heat exchanger effectiveness in both heating and cooling conditions.
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
Accordingly, the sensible and latent heat exchanger effectiveness are calculated with
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.BaseClasses.Effectiveness\">
Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.BaseClasses.Effectiveness</a>.
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
In addition, there is no sensible or latent heat transfer, i.e., the sensible
and latent effectiveness of the heat recovery wheel is 0.
</li>
</ul>
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 29, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end BypassDampers;
