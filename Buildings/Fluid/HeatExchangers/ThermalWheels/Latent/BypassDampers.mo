within Buildings.Fluid.HeatExchangers.ThermalWheels.Latent;
model BypassDampers
  "Enthalpy recovery wheel with bypass dampers"
  extends
    Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.BaseClasses.PartialWheel;
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uBypDamPos(
    final unit="1",
    final min=0,
    final max=1)
    "Bypass damper position"
    annotation (Placement(transformation(extent={{-222,120},{-182,160}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRot
    "True when the wheel is operating"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Fluid.Actuators.Dampers.Exponential bypDamSup(
    redeclare package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final dpDamper_nominal=dp1_nominal)
    "Supply air bypass damper"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Fluid.Actuators.Dampers.Exponential damSup(
    redeclare package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final dpDamper_nominal=dp1_nominal)
    "Supply air damper"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},rotation=0,origin={-50,40})));
  Buildings.Fluid.Actuators.Dampers.Exponential damExh(
    redeclare package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final dpDamper_nominal=dp2_nominal)
    "Exhaust air damper"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},rotation=-90,origin={60,-30})));
  Buildings.Fluid.Actuators.Dampers.Exponential bypDamExh(
    redeclare package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final dpDamper_nominal=dp2_nominal)
    "Exhaust air bypass damper"
    annotation (Placement(transformation(extent={{0,-70},{-20,-50}})));
protected
  Modelica.Blocks.Sources.Constant uni(final k=1)
    "Unity signal"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    "Difference of the two inputs"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Modelica.Blocks.Math.BooleanToReal PEle(
    final realTrue=P_nominal,
    final realFalse=0) "Electric power consumption for motor"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));
equation
  connect(bypDamSup.port_a, port_a1)
    annotation (Line(points={{-60,80},{-180,80}}, color={0,127,255}));
  connect(bypDamSup.port_b, port_b1)
    annotation (Line(points={{-40,80},{100,80}}, color={0,127,255}));
  connect(bypDamExh.port_a, port_a2)
    annotation (Line(points={{0,-60},{100,-60}},  color={0,127,255}));
  connect(bypDamExh.port_b, port_b2)
    annotation (Line(points={{-20,-60},{-180,-60}}, color={0,127,255}));
  connect(damExh.port_a, port_a2)
    annotation (Line(points={{60,-40},{60,-60},{100,-60}}, color={0,127,255}));
  connect(sub.y, damSup.y)
    annotation (Line(points={{-78,100},{20,100},{20,60},{-50,60},{-50,52}},
        color={0,0,127}));
  connect(damExh.y,sub. y)
    annotation (Line(points={{48,-30},{40,-30},{40,84},{20,84},{20,100},{-78,100}},
                                                                    color={0,0,127}));
  connect(bypDamSup.y, uBypDamPos)
    annotation (Line(points={{-50,92},{-50,140},{-202,140}}, color={0,0,127}));
  connect(damSup.port_b, hex.port_a1)
    annotation (Line(points={{-40,40},{-20,40},{-20,6},{-10,6}},
        color={0,127,255}));
  connect(bypDamExh.y, uBypDamPos)
    annotation (Line(points={{-10,-48},{-10,-30},{30,-30},{30,140},{-202,140}},
        color={0,0,127}));
  connect(hex.port_b1, port_b1)
    annotation (Line(points={{10,6},{60,6},{60,80},{100,80}},
        color={0,127,255}));
  connect(hex.port_a2, damExh.port_b)
    annotation (Line(points={{10,-6},{60,-6},{60,-20}}, color={0,127,255}));
  connect(sub.u2, uBypDamPos)
    annotation (Line(points={{-102,94},{-160,94},{-160,140},{-202,140}},
        color={0,0,127}));
  connect(uni.y, sub.u1)
    annotation (Line(points={{-119,120},{-110,120},{-110,106},{-102,106}},
        color={0,0,127}));
  connect(uRot, booleanToReal.u)
    annotation (Line(points={{-200,0},{-162,0}}, color={255,0,255}));
  connect(booleanToReal.y, effCal.uSpe)
    annotation (Line(points={{-139,0},{-120,0},{-120,0},{-102,0}},
        color={0,0,127}));
  connect(damSup.port_a, port_a1)
    annotation (Line(points={{-60,40},{-100,40},{-100,80},{-180,80}},
        color={0,127,255}));
  connect(port_b2, port_b2)
    annotation (Line(points={{-180,-60},{-180,-60}}, color={0,127,255}));
  connect(PEle.y, P) annotation (Line(points={{-139,-80},{80,-80},{80,-90},{120,
          -90}}, color={0,0,127}));
  connect(PEle.u, uRot) annotation (Line(points={{-162,-80},{-168,-80},{-168,0},
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
