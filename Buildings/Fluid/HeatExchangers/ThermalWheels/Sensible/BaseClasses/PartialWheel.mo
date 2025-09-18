within Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible.BaseClasses;
partial model PartialWheel
  "Partial model for sensible heat recovery wheel"
  extends Modelica.Blocks.Icons.Block;
  replaceable package Medium = Modelica.Media.Interfaces.PartialCondensingGases
    "Air";
  parameter Buildings.Fluid.HeatExchangers.ThermalWheels.Data.Generic per(
     final have_latHEX=false)
    "Record with performance data"
    annotation (Placement(transformation(extent={{-170,-60},{-150,-40}})));

  parameter Boolean allowFlowReversal1 = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 1"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversal2 = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 2"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);


  parameter Boolean from_dp1 = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(
                tab="Flow resistance", group="Medium 1"));
  parameter Boolean linearizeFlowResistance1 = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(tab="Flow resistance", group="Medium 1"));

  parameter Boolean from_dp2 = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(
                tab="Flow resistance", group="Medium 2"));
  parameter Boolean linearizeFlowResistance2 = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(tab="Flow resistance", group="Medium 2"));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput P(
    final unit="W") "Electric power consumption"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput eps(final unit="1")
    "Sensible heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{100,20},{140,60}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
    redeclare final package Medium = Medium)
    "Fluid connector a1 of the supply air (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-190,70},{-170,90}}),
    iconTransformation(extent={{-110,70},{-90,90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium = Medium)
    "Fluid connector b2 of the exhaust air (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-170,-90},{-190,-70}}),
    iconTransformation(extent={{-90,-88},{-110,-68}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
    redeclare final package Medium = Medium)
    "Fluid connector b1 of the supply air (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{110,70},{90,90}}),
    iconTransformation(extent={{110,68},{90,88}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare final package Medium = Medium)
    "Fluid connector a2 of the exhaust air (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}}),
        iconTransformation(extent={{90,-90},{110,-70}})));

  Buildings.Fluid.Sensors.MassFlowRate senSupMasFlo(
    redeclare package Medium = Medium)
    "Supply air mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,40})));
  Buildings.Fluid.Sensors.MassFlowRate senExhMasFlo(
     redeclare package Medium = Medium)
    "Exhaust air mass flow rate"
    annotation (Placement(transformation(extent={{-110,-70},{-130,-50}})));

protected
  parameter Medium.ThermodynamicState sta_nominal=Medium.setState_pTX(
      T=Buildings.Utilities.Psychrometrics.Constants.T_ref,
      p=101325,
      X=Medium.X_default)
   "State of the supply air at the default properties";
  Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible.BaseClasses.HeatExchangerWithInputEffectiveness hex(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    final m1_flow_nominal=per.mSup_flow_nominal,
    final m2_flow_nominal=per.mExh_flow_nominal,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final from_dp1=from_dp1,
    final from_dp2=from_dp2,
    final linearizeFlowResistance1=linearizeFlowResistance1,
    final linearizeFlowResistance2=linearizeFlowResistance2)
    "Heat exchanger"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible.BaseClasses.Effectiveness effCal(
    final eps_nominal=per.epsSen_nominal,
    final epsPL=per.epsSenPL,
    final mSup_flow_nominal=per.mSup_flow_nominal)
    "Calculate the effectiveness of heat exchanger"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

equation
  connect(senExhMasFlo.port_b, port_b2)
    annotation (Line(points={{-130,-60},{-140,-60},{-140,-80},{-180,-80}},
    color={0,127,255}));
  connect(senExhMasFlo.port_a, hex.port_b2) annotation (Line(points={{-110,-60},
          {-20,-60},{-20,-6},{-10,-6}},
    color={0,127,255}));
  connect(hex.port_b1, senSupMasFlo.port_a)
    annotation (Line(points={{10,6},{40,6},{40,30}},
    color={0,127,255}));
  connect(senSupMasFlo.port_b, port_b1) annotation (Line(points={{40,50},{40,80},
          {100,80}},   color={0,127,255}));
  connect(senExhMasFlo.m_flow, effCal.mExh_flow) annotation (Line(points={{-120,
          -49},{-120,-6},{-102,-6}},                 color={0,0,127}));
  connect(senSupMasFlo.m_flow, effCal.mSup_flow) annotation (Line(points={{29,40},
          {-120,40},{-120,6},{-102,6}},         color={0,0,127}));
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
          extent={{24,-74},{92,-82}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{24,82},{92,74}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-92,-73},{-30,-82}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-94,83},{-28,74}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{8,90},{34,-90}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-6,90},{20,-90}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-38,90},{-8,-90}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(points={{-24,-90},{20,-90}}, color={0,0,0}),
        Line(points={{-22,90},{22,90}}, color={0,0,0}),
        Text(
          extent={{66,-26},{96,-48}},
          textColor={0,0,127},
          textString="P"),
        Text(
          extent={{54,54},{84,32}},
          textColor={0,0,127},
          textString="eps")}),
          Diagram(
        coordinateSystem(preserveAspectRatio=true, extent={{-180,-100},{100,100}})),
Documentation(info="<html>
<p>
Partial model of a sensible heat recovery wheel.
</p>
</html>", revisions="<html>
<ul>
<li>
January 8, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialWheel;
