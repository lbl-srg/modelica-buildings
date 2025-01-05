within Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.BaseClasses;
partial model PartialWheel
  "Partial model for enthalpy recovery wheel"
  extends Modelica.Blocks.Icons.Block;
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialCondensingGases
    "Air";

  parameter Buildings.Fluid.HeatExchangers.ThermalWheels.Data.Generic per
    "Record with performance data"
    annotation (Placement(transformation(extent={{-150,-40},{-130,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput P(
    final unit="W")
    "Electric power consumption"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput epsSen(final unit="1")
    "Sensible heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput epsLat(final unit="1")
    "Latent heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Fluid.Sensors.MassFlowRate senSupMasFlo(
    redeclare package Medium = Medium)
    "Supply air mass flow rate"
    annotation (Placement(transformation(extent={{50,-4},{70,16}})));
  Buildings.Fluid.Sensors.MassFlowRate senExhMasFlo(
    redeclare package Medium = Medium)
    "Exhaust air mass flow rate"
    annotation (Placement(transformation(extent={{-100,-54},{-120,-34}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
    redeclare final package Medium = Medium)
    "Fluid connector a1 of the supply air (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-190,70},{-170,90}}),
        iconTransformation(extent={{-110,68},{-90,88}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium = Medium)
    "Fluid connector b2 of the exhaust air (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-170,-90},{-190,-70}}),
        iconTransformation(extent={{-90,-90},{-110,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
    redeclare final package Medium = Medium)
    "Fluid connector b1 of the supply air (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{110,70},{90,90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare final package Medium = Medium)
    "Fluid connector a2 of the exhaust air (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));

protected
  Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.BaseClasses.Effectiveness effCal(
    final epsSen_nominal=per.epsSen_nominal,
    final epsLat_nominal=per.epsLat_nominal,
    final epsSenPL=per.epsSenPL,
    final epsLatPL=per.epsLatPL,
    final mSup_flow_nominal=per.mSup_flow_nominal)
    "Calculate the effectiveness of heat exchanger"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.BaseClasses.HeatExchangerWithInputEffectiveness hex(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    final m1_flow_nominal=per.mSup_flow_nominal,
    final m2_flow_nominal=per.mExh_flow_nominal,
    final dp1_nominal=per.dpSup_nominal,
    final dp2_nominal=per.dpExh_nominal)
    "Heat exchanger"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));

initial equation
  assert(per.haveLatentHeatExchange,
         "In " + getInstanceName() + ": The performance data record
         is wrong, the latent heat exchange flag must be true",
         level=AssertionLevel.error)
         "Check if the performance data record is correct";

equation
  connect(senSupMasFlo.m_flow, effCal.mSup_flow) annotation (Line(points={{60,17},
          {60,60},{-110,60},{-110,6},{-102,6}}, color={0,0,127}));
  connect(senExhMasFlo.m_flow, effCal.mExh_flow) annotation (Line(points={{-110,
          -33},{-110,-6},{-102,-6}}, color={0,0,127}));
  connect(hex.port_b1, senSupMasFlo.port_a)
    annotation (Line(points={{30,6},{50,6}}, color={0,127,255},
      thickness=0.5));
  connect(senSupMasFlo.port_b, port_b1) annotation (Line(points={{70,6},{80,6},
          {80,80},{100,80}}, color={0,127,255},
      thickness=0.5));
  connect(senExhMasFlo.port_a, hex.port_b2) annotation (Line(points={{-100,-44},
          {-30,-44},{-30,-6},{10,-6}},  color={0,127,255},
      thickness=0.5));
  connect(senExhMasFlo.port_b, port_b2) annotation (Line(points={{-120,-44},{
          -160,-44},{-160,-80},{-180,-80}},
                                      color={0,127,255},
      thickness=0.5));
annotation (
        defaultComponentName="whe",
        Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{24,-76},{94,-84}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{26,84},{92,76}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-92,-75},{-24,-84}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-94,85},{-22,76}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{6,94},{34,-90}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,100},{0,100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.None),
        Rectangle(
          extent={{-8,96},{22,-94}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-40,94},{0,-88}},
          lineColor={28,108,200},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid),
        Line(points={{-22,-88},{22,-88}}, color={0,0,0}),
        Line(points={{-22,94},{22,94}}, color={0,0,0})}),
          Diagram(
        coordinateSystem(preserveAspectRatio=true, extent={{-180,-100},{100,100}})),
Documentation(info="<html>
<p>
Partial model of an enthalpy recovery wheel.
</p>
</html>", revisions="<html>
<ul>
<li>
January 5, 2024, by Michael Wetter:<br/>
Refactored and used base classes to avoid code duplication and
to facilitate adding heat recovery wheels in addition to enthalpy recovery wheels.
</li>
<li>
September 29, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialWheel;
