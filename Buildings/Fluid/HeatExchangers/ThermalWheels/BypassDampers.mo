within Buildings.Fluid.HeatExchangers.ThermalWheels;
model BypassDampers
  "Sensible and latent air-to-air heat recovery wheel with bypass dampers"
  extends Modelica.Blocks.Icons.Block;
  replaceable package Medium1 =
    Modelica.Media.Interfaces.PartialCondensingGases
    "Supply air";
  replaceable package Medium2 =
    Modelica.Media.Interfaces.PartialCondensingGases
    "Exhaust air";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal
    "Nominal supply air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal
    "Nominal exhaust air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dp1_nominal(displayUnit="Pa") = 500
    "Nominal supply air pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dp2_nominal(displayUnit="Pa") = dp2_nominal
    "Nominal exhaust air pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Real P_nominal(final unit="W")
    "Power consumption at the design condition"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Efficiency epsSenCoo_nominal(
    final max=1) = 0.8
    "Nominal sensible heat exchanger effectiveness at the cooling mode"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Efficiency epsLatCoo_nominal(
    final max=1) = 0.8
    "Nominal latent heat exchanger effectiveness at the cooling mode"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Efficiency epsSenHea_nominal(
    final max=1) = 0.8
    "Nominal sensible heat exchanger effectiveness at the heating mode"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Efficiency epsLatHea_nominal(
    final max=1) = 0.8
    "Nominal latent heat exchanger effectiveness at the heating mode"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Efficiency epsSenCooPL(
    final max=1) = 0.75
    "Part load (75%) sensible heat exchanger effectiveness at the cooling mode"
    annotation (Dialog(group="Part load effectiveness"));
  parameter Modelica.Units.SI.Efficiency epsLatCooPL(
    final max=1) = 0.75
    "Part load (75%) latent heat exchanger effectiveness at the cooling mode"
    annotation (Dialog(group="Part load effectiveness"));
  parameter Modelica.Units.SI.Efficiency epsSenHeaPL(
    final max=1) = 0.75
    "Part load (75%) sensible heat exchanger effectiveness at the heating mode"
    annotation (Dialog(group="Part load effectiveness"));
  parameter Modelica.Units.SI.Efficiency epsLatHeaPL(
    final max=1) = 0.75
    "Part load (75%) latent heat exchanger effectiveness at the heating mode"
    annotation (Dialog(group="Part load effectiveness"));

  Modelica.Blocks.Interfaces.RealInput uBypDamPos(
    final unit="1",
    final min=0,
    final max=1)
    "Bypass damper position"
    annotation (Placement(transformation(extent={{-220,100},{-180,140}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.BooleanInput opeSig
    "True when the wheel is operating"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealOutput P(
    final unit="W")
    "Electric power consumption"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.HeatExchangerWithInputEffectiveness
    hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final show_T=true,
    final dp1_nominal=0,
    final dp2_nominal=0)
    "Heat exchanger"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.Effectiveness
    effCal(
    final epsSenCoo_nominal=epsSenCoo_nominal,
    final epsLatCoo_nominal=epsLatCoo_nominal,
    final epsSenCooPL=epsSenCooPL,
    final epsLatCooPL=epsLatCooPL,
    final epsSenHea_nominal=epsSenHea_nominal,
    final epsLatHea_nominal=epsLatHea_nominal,
    final epsSenHeaPL=epsSenHeaPL,
    final epsLatHeaPL=epsLatHeaPL,
    final VSup_flow_nominal=m1_flow_nominal/1.293)
    "Calculates the effectiveness of heat exchange"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
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
        extent={{10,10},{-10,-10}},rotation=-90,origin={60,-40})));
  Buildings.Fluid.Actuators.Dampers.Exponential bypDamExh(
    redeclare package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final dpDamper_nominal=dp2_nominal)
    "Exhaust air bypass damper"
    annotation (Placement(transformation(extent={{-40,-70},{-60,-50}})));
  Modelica.Blocks.Sources.RealExpression TSup(
    final y=Medium1.temperature(
      Medium1.setState_phX(
        p=port_a1.p,
        h=inStream(port_a1.h_outflow),
        X=inStream(port_a1.Xi_outflow))))
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}})));
  Modelica.Blocks.Sources.RealExpression TExh(
    final y=Medium2.temperature(
      Medium2.setState_phX(
        p=port_a2.p,
        h=inStream(port_a2.h_outflow),
        X=inStream(port_a2.Xi_outflow))))
    "Exhaust air temperature"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter PEle(
    final k=P_nominal)
    "Calculate the electric power consumption"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
    redeclare final package Medium = Medium1)
    "Fluid connector a1 of the supply air (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-190,70},{-170,90}}),
        iconTransformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium = Medium2)
    "Fluid connector b2 of the exhaust air (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-170,-70},{-190,-50}}),
        iconTransformation(extent={{-90,-70},{-110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
    redeclare final package Medium = Medium1)
    "Fluid connector b1 of the supply air (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{110,70},{90,90}}),
        iconTransformation(extent={{110,50},{90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare final package Medium = Medium2)
    "Fluid connector a2 of the exhaust air (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Blocks.Sources.Constant uni(final k=1)
    "Unity signal"
    annotation (Placement(transformation(extent={{-160,130},{-140,150}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    "Difference of the two inputs"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Modelica.Blocks.Sources.RealExpression VSup_flow(
    final y=hex.port_a1.m_flow/
        Medium1.density(state=Medium1.setState_phX(
        p=hex.port_a1.p,
        h=hex.port_a1.h_outflow,
        X=hex.port_a1.Xi_outflow)))
    "Supply air volume flow rate"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  Modelica.Blocks.Sources.RealExpression VExh_flow(
    final y=hex.port_a2.m_flow/
        Medium2.density(state=Medium2.setState_phX(
        p=hex.port_a2.p,
        h=hex.port_a2.h_outflow,
        X=hex.port_a2.Xi_outflow)))
    "Exhaust air volume flow rate"
    annotation (Placement(transformation(extent={{-160,14},{-140,34}})));
equation
  connect(bypDamSup.port_a, port_a1)
    annotation (Line(points={{-60,80},{-180,80}}, color={0,127,255}));
  connect(bypDamSup.port_b, port_b1)
    annotation (Line(points={{-40,80},{100,80}},                 color={0,127,255}));
  connect(bypDamExh.port_a, port_a2)
    annotation (Line(points={{-40,-60},{100,-60}},color={0,127,255}));
  connect(bypDamExh.port_b, port_b2)
    annotation (Line(points={{-60,-60},{-180,-60}}, color={0,127,255}));
  connect(PEle.y, P)
    annotation (Line(points={{92,0},{110,0}},  color={0,0,127}));
  connect(damExh.port_a, port_a2)
    annotation (Line(points={{60,-50},{60,-60},{100,-60}}, color={0,127,255}));
  connect(sub.y, damSup.y)
    annotation (Line(points={{-98,100},{20,100},{20,60},{-50,60},{-50,52}}, color={0,0,127}));
  connect(damExh.y,sub. y)
    annotation (Line(points={{48,-40},{20,-40},{20,100},{-98,100}}, color={0,0,127}));
  connect(effCal.epsSen, hex.epsSen)
    annotation (Line(points={{-79,23},{-12,23}}, color={0,0,127}));
  connect(effCal.epsLat, hex.epsLat)
    annotation (Line(points={{-79,17},{-12,17}},
                                              color={0,0,127}));
  connect(bypDamSup.y, uBypDamPos)
    annotation (Line(points={{-50,92},{-50,120},{-200,120}}, color={0,0,127}));
  connect(TSup.y, effCal.TSup)
    annotation (Line(points={{-139,-20},{-114,-20},{-114,16},{-102,16}},
        color={0,0,127}));
  connect(TExh.y, effCal.TExh)
    annotation (Line(points={{-139,-40},{-110,-40},{-110,12},{-102,12}},
        color={0,0,127}));
  connect(damSup.port_b, hex.port_a1)
    annotation (Line(points={{-40,40},{-20,40},{-20,26},{-10,26}},
        color={0,127,255}));
  connect(bypDamExh.y, uBypDamPos)
    annotation (Line(points={{-50,-48},{-50,-30},{40,-30},{40,120},{-200,120}},
        color={0,0,127}));
  connect(hex.port_b1, port_b1)
    annotation (Line(points={{10,26},{60,26},{60,80},{100,80}},
        color={0,127,255}));
  connect(hex.port_a2, damExh.port_b)
    annotation (Line(points={{10,14},{60,14},{60,-30}},
                                                      color={0,127,255}));
  connect(sub.u2, uBypDamPos)
    annotation (Line(points={{-122,94},{-140,94},{-140,120},{-200,120}},
        color={0,0,127}));
  connect(uni.y, sub.u1)
    annotation (Line(points={{-139,140},{-132,140},{-132,106},{-122,106}},
        color={0,0,127}));
  connect(opeSig, booleanToReal.u)
    annotation (Line(points={{-200,0},{-162,0}},
        color={255,0,255}));
  connect(booleanToReal.y, effCal.uSpe)
    annotation (Line(points={{-139,0},{-120,0},{-120,20},{-102,20}},
        color={0,0,127}));
  connect(PEle.u, booleanToReal.y)
    annotation (Line(points={{68,0},{-139,0}},
        color={0,0,127}));
  connect(damSup.port_a, port_a1)
    annotation (Line(points={{-60,40},{-100,40},{-100,80},{-180,80}},
        color={0,127,255}));
  connect(port_b2, port_b2)
    annotation (Line(points={{-180,-60},{-180,-60}}, color={0,127,255}));
  connect(port_b2, hex.port_b2)
    annotation (Line(points={{-180,-60},{-72,-60},{-72,-6},{-10,-6},{-10,14}},
        color={0,127,255}));
  connect(VSup_flow.y, effCal.VSup_flow)
    annotation (Line(points={{-139,40},{-120,40},{-120,28},{-102,28}},
        color={0,0,127}));
  connect(VExh_flow.y, effCal.VExh_flow)
    annotation (Line(points={{-139,24},{-102,24}},
        color={0,0,127}));
annotation (
        defaultComponentName="whe",
        Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{32,-56},{94,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,64},{94,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-92,-55},{-30,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-94,65},{-32,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{6,88},{38,-90}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,100},{0,100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.None),
        Rectangle(
          extent={{-2,88},{22,-98}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-38,88},{-4,-90}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(points={{-22,-90},{22,-90}}, color={28,108,200}),
        Line(points={{-20,88},{22,88}}, color={28,108,200}),
        Line(points={{-58,64},{-58,96},{64,96},{64,64}}, color={28,108,200}),
        Line(points={{-58,-64},{-58,-96},{64,-96},{64,-64}}, color={28,108,200})}),
          Diagram(
        coordinateSystem(preserveAspectRatio=true, extent={{-180,-100},{100,180}})),
Documentation(info="<html>
<p>
Model of a generic, sensible and latent air-to-air heat recovery wheel, which consists of 
a heat exchanger and two dampers to bypass the supply and exhaust airflow. 
</p>
<p>
This model does not require geometric data. The performance is defined by specifying the
part load (75%) and nominal sensible and latent effectiveness in both heating and cooling conditions.
This operation of the wheel is configured as follows.
</p>
<ul>
<li>
If the operating signal <code>opeSig=true</code>,
<ul>
<li>
The wheel power consumption is constant and equal to the nominal value.
</li>
<li>
The heat exchange in the heat recovery wheel is adjustable via bypassing supply/exhaust air 
through the heat exchanger.
Accordingly, the sensible and latent effectiveness is calculated with
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.Effectiveness\">
Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.Effectiveness</a>.
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
