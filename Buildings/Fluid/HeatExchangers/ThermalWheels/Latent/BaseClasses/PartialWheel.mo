within Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.BaseClasses;
partial model PartialWheel
  "Partial model for enthalpy recovery wheel"
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
  parameter Modelica.Units.SI.PressureDifference dp2_nominal(displayUnit="Pa") = dp1_nominal
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
    "Part load (75% of the nominal supply flow rate) sensible heat exchanger effectiveness at the cooling mode"
    annotation (Dialog(group="Part load effectiveness"));
  parameter Modelica.Units.SI.Efficiency epsLatCooPL(
    final max=1) = 0.75
    "Part load (75% of the nominal supply flow rate) latent heat exchanger effectiveness at the cooling mode"
    annotation (Dialog(group="Part load effectiveness"));
  parameter Modelica.Units.SI.Efficiency epsSenHeaPL(
    final max=1) = 0.75
    "Part load (75% of the nominal supply flow rate) sensible heat exchanger effectiveness at the heating mode"
    annotation (Dialog(group="Part load effectiveness"));
  parameter Modelica.Units.SI.Efficiency epsLatHeaPL(
    final max=1) = 0.75
    "Part load (75% of the nominal supply flow rate) latent heat exchanger effectiveness at the heating mode"
    annotation (Dialog(group="Part load effectiveness"));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput P(
    final unit="W")
    "Electric power consumption"
    annotation (Placement(transformation(extent={{100,-110},{140,-70}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput epsSen(final unit="1")
    "Sensible heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{100,10},{140,50}}),
        iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput epsLat(final unit="1")
    "Latent heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{100,-50},{140,-10}}),
        iconTransformation(extent={{100,-50},{140,-10}})));
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

protected
  parameter Medium1.ThermodynamicState sta_nominal=Medium1.setState_pTX(
      T=Buildings.Utilities.Psychrometrics.Constants.T_ref,
      p=101325,
      X=Medium1.X_default)
   "State of the supply air at the default properties";
    Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.BaseClasses.Effectiveness effCal(
    final epsSenCoo_nominal=epsSenCoo_nominal,
    final epsLatCoo_nominal=epsLatCoo_nominal,
    final epsSenCooPL=epsSenCooPL,
    final epsLatCooPL=epsLatCooPL,
    final epsSenHea_nominal=epsSenHea_nominal,
    final epsLatHea_nominal=epsLatHea_nominal,
    final epsSenHeaPL=epsSenHeaPL,
    final epsLatHeaPL=epsLatHeaPL,
    final VSup_flow_nominal=m1_flow_nominal/Medium1.density(sta_nominal))
    "Calculates the effectiveness of heat exchange"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.BaseClasses.HeatExchangerWithInputEffectiveness hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final dp1_nominal=dp1_nominal,
    final dp2_nominal=dp2_nominal)
    "Heat exchanger"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.RealExpression VSup_flow(
    final y(final unit="m3/s")=hex.port_a1.m_flow/
        Medium1.density(state=Medium1.setState_phX(
        p=hex.port_a1.p,
        h=hex.port_a1.h_outflow,
        X=hex.port_a1.Xi_outflow)))
    "Supply air volume flow rate"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  Modelica.Blocks.Sources.RealExpression VExh_flow(
    final y(final unit="m3/s")=hex.port_a2.m_flow/
        Medium2.density(state=Medium2.setState_phX(
        p=hex.port_a2.p,
        h=hex.port_a2.h_outflow,
        X=hex.port_a2.Xi_outflow)))
    "Exhaust air volume flow rate"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  Modelica.Blocks.Sources.RealExpression TSup(
    final y(final unit="K")=Medium1.temperature(
      Medium1.setState_phX(
        p=port_a1.p,
        h=inStream(port_a1.h_outflow),
        X=inStream(port_a1.Xi_outflow))))
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}})));
  Modelica.Blocks.Sources.RealExpression TExh(
    final y(final unit="K")=Medium2.temperature(
      Medium2.setState_phX(
        p=port_a2.p,
        h=inStream(port_a2.h_outflow),
        X=inStream(port_a2.Xi_outflow))))
    "Exhaust air temperature"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));

equation
  connect(effCal.epsSen, hex.epsSen)
    annotation (Line(points={{-78,5},{-46,5},{-46,3},{-12,3}},
                                               color={0,0,127}));
  connect(effCal.epsLat, hex.epsLat)
    annotation (Line(points={{-78,-5},{-46,-5},{-46,-3},{-12,-3}},
                                                 color={0,0,127}));
  connect(TSup.y, effCal.TSup)
    annotation (Line(points={{-139,-20},{-120,-20},{-120,-4},{-102,-4}},
        color={0,0,127}));
  connect(TExh.y, effCal.TExh)
    annotation (Line(points={{-139,-40},{-110,-40},{-110,-8},{-102,-8}},
        color={0,0,127}));
  connect(hex.port_b1, port_b1)
    annotation (Line(points={{10,6},{60,6},{60,80},{100,80}},
        color={0,127,255}));
  connect(port_b2, port_b2)
    annotation (Line(points={{-180,-60},{-180,-60}}, color={0,127,255}));
  connect(port_b2, hex.port_b2)
    annotation (Line(points={{-180,-60},{-40,-60},{-40,-6},{-10,-6}},
        color={0,127,255}));
  connect(VSup_flow.y, effCal.VSup_flow)
    annotation (Line(points={{-139,40},{-110,40},{-110,8},{-102,8}},
        color={0,0,127}));
  connect(VExh_flow.y, effCal.VExh_flow)
    annotation (Line(points={{-139,20},{-120,20},{-120,4},{-102,4}},
        color={0,0,127}));
  connect(epsSen, effCal.epsSen) annotation (Line(points={{120,30},{-60,30},{
          -60,5},{-78,5}}, color={0,0,127}));
  connect(effCal.epsLat, epsLat) annotation (Line(points={{-78,-5},{-60,-5},{
          -60,-16},{80,-16},{80,-30},{120,-30}}, color={0,0,127}));
annotation (
        defaultComponentName="whe",
        Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{26,-56},{94,-64}},
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
          extent={{-94,65},{-28,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{8,78},{38,-74}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,100},{0,100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.None),
        Rectangle(
          extent={{-6,78},{22,-74}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-38,78},{-6,-74}},
          lineColor={28,108,200},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid),
        Line(points={{-22,-74},{22,-74}}, color={0,0,0}),
        Line(points={{-22,78},{22,78}}, color={0,0,0}),
        Text(
          extent={{46,46},{96,22}},
          textColor={0,0,127},
          textString="epsSen"),
        Text(
          extent={{46,-16},{96,-40}},
          textColor={0,0,127},
          textString="epsLat"),
        Text(
          extent={{52,-76},{102,-100}},
          textColor={0,0,127},
          textString="P")}),
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
