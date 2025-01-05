within Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible.BaseClasses;
partial model PartialWheel
  "Partial model for sensible heat recovery wheel"
  extends Modelica.Blocks.Icons.Block;
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialCondensingGases
    "Air";
  parameter Buildings.Fluid.HeatExchangers.ThermalWheels.Data.Generic per
    "Record with performance data"
    annotation (Placement(transformation(extent={{-130,-60},{-110,-40}})));

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
    annotation (Placement(transformation(extent={{30,10},{50,30}})));
  Buildings.Fluid.Sensors.MassFlowRate senExhMasFlo(
     redeclare package Medium = Medium)
    "Exhaust air mass flow rate"
    annotation (Placement(transformation(extent={{-70,-50},{-90,-30}})));
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
    final dp1_nominal=per.dpSup_nominal,
    final dp2_nominal=per.dpExh_nominal) "Heat exchanger"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible.BaseClasses.Effectiveness effCal(
    final eps_nominal=per.epsSen_nominal,
    final epsPL=per.epsSenPL,
    final mSup_flow_nominal=per.mSup_flow_nominal)
    "Calculate the effectiveness of heat exchanger"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

initial equation
  assert(not per.haveLatentHeatExchange,
         "In " + getInstanceName() + ": The performance data record
         is wrong, the latent heat exchange flag must be false",
         level=AssertionLevel.error)
         "Check if the performance data record is correct";

equation
  connect(senExhMasFlo.port_b, port_b2)
    annotation (Line(points={{-90,-40},{-100,-40},{-100,-80},{-180,-80}},
    color={0,127,255},
      thickness=0.5));
  connect(senExhMasFlo.port_a, hex.port_b2) annotation (Line(points={{-70,-40},
          {-30,-40},{-30,-6},{-10,-6}},
    color={0,127,255},
      thickness=0.5));
  connect(hex.port_b1, senSupMasFlo.port_a)
    annotation (Line(points={{10,6},{20,6},{20,20},{30,20}},
    color={0,127,255},
      thickness=0.5));
  connect(senSupMasFlo.port_b, port_b1) annotation (Line(points={{50,20},{60,20},
    {60,80},{100,80}}, color={0,127,255},
      thickness=0.5));
  connect(senExhMasFlo.m_flow, effCal.mExh_flow) annotation (Line(points={{-80,-29},
          {-80,-20},{-130,-20},{-130,-6},{-102,-6}},
                                             color={0,0,127}));
  connect(senSupMasFlo.m_flow, effCal.mSup_flow) annotation (Line(points={{40,31},
          {40,40},{-130,40},{-130,6},{-102,6}},
                                          color={0,0,127}));
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
        Line(points={{-22,90},{22,90}}, color={0,0,0})}),
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
