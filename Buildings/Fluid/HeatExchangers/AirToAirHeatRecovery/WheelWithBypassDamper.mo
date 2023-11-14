within Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery;
model WheelWithBypassDamper
  "Sensible and latent air-to-air heat recovery wheel with bypass dampers"
  replaceable package Medium1 =
      Modelica.Media.Interfaces.PartialCondensingGases
    "Medium of the supply air stream";
  replaceable package Medium2 =
      Modelica.Media.Interfaces.PartialCondensingGases
    "Medium of the exhaust air stream";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal
    "Air flow rate of the supply air stream";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal
    "Air flow rate of the exhaust air stream";
  parameter Modelica.Units.SI.PressureDifference dp1_nominal = 125
    "Nominal pressure drop of the supply air stream";
  parameter Modelica.Units.SI.PressureDifference dp2_nominal = 125
    "Nominal pressure drop of the exhaust air stream";
  parameter Real P_nominal(final unit="W") = 100
    "Power at design condition";
  parameter Modelica.Units.SI.Efficiency epsSenCoo_nominal(final max=1) = 0.8
    "Nominal sensible heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsLatCoo_nominal(final max=1) = 0.8
    "Nominal latent heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsSenCoo_ParLoa(final max=1) = 0.75
    "Partial load (75%) sensible heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsLatCoo_ParLoa(final max=1) = 0.75
    "Partial load (75%) latent heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsSenHea_nominal(final max=1) = 0.8
    "Nominal sensible heat exchanger effectiveness at the heating mode";
  parameter Modelica.Units.SI.Efficiency epsLatHea_nominal(final max=1) = 0.8
    "Nominal latent heat exchanger effectiveness at the heating mode";
  parameter Modelica.Units.SI.Efficiency epsSenHea_ParLoa(final max=1) = 0.75
    "Partial load (75%) sensible heat exchanger effectiveness at the heating mode";
  parameter Modelica.Units.SI.Efficiency epsLatHea_ParLoa(final max=1) = 0.75
    "Partial load (75%) latent heat exchanger effectiveness at the heating mode";
  Modelica.Blocks.Interfaces.RealInput bypDamPos(final unit="1")
    "Bypass damper position"
    annotation (Placement(transformation(extent={{-220,100},{-180,140}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput P
    "Electric power consumed by the wheel"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.HeatExchagerWithInputEffectiveness hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final show_T=true,
    final dp1_nominal=0,
    final dp2_nominal=0)
    "Heat exchanger"
    annotation (Placement(transformation(extent={{-10,4},{10,24}})));
  Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.EffectivenessCalculation
    effCal(
    final epsSenCoo_nominal=epsSenCoo_nominal,
    final epsLatCoo_nominal=epsLatCoo_nominal,
    final epsSenCoo_ParLoa=epsSenCoo_ParLoa,
    final epsLatCoo_ParLoa=epsLatCoo_ParLoa,
    final epsSenHea_nominal=epsSenHea_nominal,
    final epsLatHea_nominal=epsLatHea_nominal,
    final epsSenHea_ParLoa=epsSenHea_ParLoa,
    final epsLatHea_ParLoa=epsLatHea_ParLoa,
    final VSup_flow_nominal=m1_flow_nominal/1.293)
    "Calculates the effectiveness of heat exchanges"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Fluid.Sensors.VolumeFlowRate VExh_flow(redeclare package Medium =
        Medium2, final m_flow_nominal=m2_flow_nominal)
    "Damper in the exhaust air stream"
    annotation (Placement(transformation(extent={{-42,-28},{-56,-12}})));
  Buildings.Fluid.Sensors.VolumeFlowRate VSup_flow(redeclare package Medium =
        Medium1, final m_flow_nominal=m1_flow_nominal)
    "Flow sensor in the supply air stream"
    annotation (Placement(transformation(extent={{-78,28},{-64,44}})));
  Buildings.Fluid.Actuators.Dampers.Exponential bypDamSup(
    redeclare package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final dpDamper_nominal=dp1_nominal)
    "Bypass damper in the supply air stream"
    annotation (Placement(transformation(extent={{-38,70},{-18,90}})));
  Buildings.Fluid.Actuators.Dampers.Exponential damSup(
    redeclare package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final dpDamper_nominal=dp1_nominal)
    "Damper in the supply air stream"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-28,36})));
  Buildings.Fluid.Actuators.Dampers.Exponential damExh(
    redeclare package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final dpDamper_nominal=dp2_nominal)
    "Damper in the exhaust air stream"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={60,-40})));
  Buildings.Fluid.Actuators.Dampers.Exponential bypDamExh(
    redeclare package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final dpDamper_nominal=dp2_nominal)
    "Bypass damper in the exhaust air stream"
    annotation (Placement(transformation(extent={{-20,-70},{-40,-50}})));
  Modelica.Blocks.Sources.RealExpression TSup(
      final y=Medium1.temperature(
      Medium1.setState_phX(
        p=port_a1.p,
        h=inStream(port_a1.h_outflow),
        X=inStream(port_a1.Xi_outflow))))
    "Temperature of the supply air"
    annotation (Placement(transformation(extent={{-162,-20},{-142,0}})));
  Modelica.Blocks.Sources.RealExpression TExh(
      final y=Medium2.temperature(
      Medium2.setState_phX(
        p=port_a2.p,
        h=inStream(port_a2.h_outflow),
        X=inStream(port_a2.Xi_outflow))))
    "Temperature of the exhaust air"
    annotation (Placement(transformation(extent={{-162,-40},{-142,-20}})));
  Modelica.Blocks.Sources.RealExpression PEle(y=P_nominal)
    "Electrical power consumption"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
    redeclare final package Medium = Medium1)
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-190,70},{-170,90}}),
        iconTransformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium = Medium2)
    "Fluid connector b2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-170,-70},{-190,-50}}),
        iconTransformation(extent={{-90,-70},{-110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
    redeclare final package Medium = Medium1)
    "Fluid connector b1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{110,70},{90,90}}),
        iconTransformation(extent={{110,50},{90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare final package Medium = Medium2)
    "Fluid connector a2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Blocks.Sources.Constant uni(final k=1)
    "Unity signal"
    annotation (Placement(transformation(extent={{-154,32},{-140,46}})));
  Modelica.Blocks.Math.Add add(k1=-1, final k2=+1)
    "Adder"
    annotation (Placement(transformation(extent={{-120,94},{-106,108}})));
equation
  connect(bypDamSup.port_a, port_a1)
    annotation (Line(points={{-38,80},{-180,80}}, color={0,127,255}));
  connect(bypDamSup.port_b, port_b1)
    annotation (Line(points={{-18,80},{42,80},{42,80},{100,80}}, color={0,127,255}));
  connect(bypDamExh.port_a, port_a2)
    annotation (Line(points={{-20,-60},{100,-60}},color={0,127,255}));
  connect(bypDamExh.port_b, port_b2)
    annotation (Line(points={{-40,-60},{-180,-60}}, color={0,127,255}));
  connect(PEle.y, P)
    annotation (Line(points={{91,0},{110,0}}, color={0,0,127}));
  connect(damExh.port_a, port_a2)
    annotation (Line(points={{60,-50},{60,-60},{100,-60}}, color={0,127,255}));
  connect(add.y, damSup.y)
    annotation (Line(points={{-105.3,101},{20,101},{20,60},{-28,60},{-28,48}}, color={0,0,127}));
  connect(damExh.y, add.y)
    annotation (Line(points={{48,-40},{20,-40},{20,101},{-105.3,101}}, color={0,0,127}));
  connect(effCal.epsSen, hex.epsSen)
    annotation (Line(points={{-79,14},{-76,14},{-76,18},{-12,18}}, color={0,0,127}));
  connect(effCal.epsLat, hex.epsLat) annotation (Line(points={{-79,6},{-76,6},{
          -76,10},{-12,10}},  color={0,0,127}));
  connect(bypDamSup.y, bypDamPos)
    annotation (Line(points={{-28,92},{-28,120},{-200,120}}, color={0,0,127}));
  connect(add.u2, uni.y)
    annotation (Line(points={{-121.4,96.8},{-132,96.8},{-132,
          39},{-139.3,39}}, color={0,0,127}));
  connect(effCal.wheSpe, uni.y)
    annotation (Line(points={{-102,10},{-124,10},{-124,39},{-139.3,39}},
                            color={0,0,127}));
  connect(TSup.y, effCal.TSup)
    annotation (Line(points={{-141,-10},{-114,-10},{-114,6},{-102,6}},
                          color={0,0,127}));
  connect(TExh.y, effCal.TExh)
    annotation (Line(points={{-141,-30},{-110,-30},{-110,2},{-102,2}},
                        color={0,0,127}));
  connect(damSup.port_b, hex.port_a1)
    annotation (Line(points={{-18,36},{-10,36},{-10,20}}, color={0,127,255}));
  connect(bypDamExh.y, bypDamPos)
    annotation (Line(points={{-30,-48},{-30,-30},{40,-30},{40,120},{-200,120}},
                                          color={0,0,127}));
  connect(add.u1, bypDamPos)
    annotation (Line(points={{-121.4,105.2},{-132,105.2},
          {-132,120},{-200,120}}, color={0,0,127}));
  connect(VSup_flow.V_flow, effCal.VSup_flow)
    annotation (Line(points={{-71,44.8},{-71,50},{-112,50},{-112,18},{-102,18}},
                                                  color={0,0,127}));
  connect(damSup.port_a, VSup_flow.port_b)
    annotation (Line(points={{-38,36},{-64,36}}, color={0,127,255}));
  connect(VSup_flow.port_a, port_a1)
    annotation (Line(points={{-78,36},{-100,36},{-100,80},{-180,80}},
                                color={0,127,255}));
  connect(hex.port_b1, port_b1)
    annotation (Line(points={{10,20},{58,20},{58,80},
          {100,80}}, color={0,127,255}));
  connect(hex.port_b2, VExh_flow.port_a)
    annotation (Line(points={{-10,8},{-22,8},
          {-22,-20},{-42,-20}}, color={0,127,255}));
  connect(VExh_flow.port_b, port_b2)
    annotation (Line(points={{-56,-20},{-70,-20},
          {-70,-60},{-180,-60}}, color={0,127,255}));
  connect(hex.port_a2, damExh.port_b)
    annotation (Line(points={{10,8},{60,8},{60,-30}}, color={0,127,255}));
  connect(VExh_flow.V_flow, effCal.VExh_flow)
    annotation (Line(points={{-49,-11.2},{-49,60},{-120,60},{-120,14},{-102,14}},
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
        Line(points={{-58,-64},{-58,-96},{64,-96},{64,-64}}, color={28,108,200}),
        Text(
          extent={{-147,-104},{153,-144}},
          textColor={0,0,255},
          textString="%name")}),
          Diagram(
        coordinateSystem(preserveAspectRatio=true, extent={{-180,-100},{100,140}})),
    Documentation(info="<html>
Model for a generic, sensible, and latent air-to-air heat recovery wheel, that consists of 
a heat exchanger and supply/exhaust airflow bypass dampers.

The input requires no geometric data. Performance is defined by specifying sensible and/or latent effectiveness 
at 75% and 100% of the nominal supply air flow rate in both heating and cooling conditions
For details, refer to
<a href=\"modelica://Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.EffectivenessCalculation\">
Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.EffectivenessCalculation</a>.

The operation of the heat recovery wheel is adjustable via bypassing supply/exhaust air 
around the heat exchanger.
</html>", revisions="<html>
<ul>
<li>
September 29, 2023, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>"));
end WheelWithBypassDamper;
