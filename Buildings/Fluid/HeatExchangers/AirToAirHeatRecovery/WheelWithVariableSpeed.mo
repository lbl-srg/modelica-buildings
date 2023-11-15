within Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery;
model WheelWithVariableSpeed
  "Sensible and latent air-to-air heat recovery wheel with a variable speed drive"
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
  Modelica.Blocks.Interfaces.RealInput wheSpe(final unit="1")
    "Wheel speed ratio"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput P
    "Electric power consumed by the wheel"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.HeatExchangerWithInputEffectiveness
    hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final show_T=true,
    final dp1_nominal=dp1_nominal,
    final dp2_nominal=dp2_nominal)
    "Heat exchanger"
    annotation (Placement(transformation(extent={{6,-10},{26,10}})));
  Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.Effectiveness
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
    "Calculates the effectiveness of heat exchange"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Fluid.Sensors.VolumeFlowRate senExhFlow(
    redeclare package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal)
    "Flow sensor in the exhaust air stream"
    annotation (Placement(transformation(extent={{56,-14},{42,2}})));
  Buildings.Fluid.Sensors.VolumeFlowRate senSupFlow(
    redeclare package Medium =Medium1,
    final m_flow_nominal=m1_flow_nominal)
    "Flow sensor in the supply air stream"
    annotation (Placement(transformation(extent={{-42,92},{-28,108}})));
  Modelica.Blocks.Sources.RealExpression TSup(final y=Medium1.temperature(
      Medium1.setState_phX(
        p=port_a1.p,
        h=inStream(port_a1.h_outflow),
        X=inStream(port_a1.Xi_outflow))))
    "Temperature of the supply air"
    annotation (Placement(transformation(extent={{-90,28},{-70,48}})));
  Modelica.Blocks.Sources.RealExpression TExh(final y=Medium2.temperature(
      Medium2.setState_phX(
        p=port_a2.p,
        h=inStream(port_a2.h_outflow),
        X=inStream(port_a2.Xi_outflow))))
    "Temperature of the exhaust air"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Modelica.Blocks.Sources.RealExpression PEle(y=P_nominal)
    "Electric power consumption"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
    redeclare final package Medium = Medium1)
    "Fluid connector a1 of the supply air"
    annotation (Placement(transformation(extent={{-110,90},{-90,110}}),
        iconTransformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium = Medium2)
    "Fluid connector b2 of the exhaust air"
    annotation (Placement(transformation(extent={{-90,-70},{-110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
    redeclare final package Medium = Medium1)
    "Fluid connector b1 of the supply air"
    annotation (Placement(transformation(extent={{110,90},{90,110}}),
        iconTransformation(extent={{110,50},{90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare final package Medium = Medium2)
    "Fluid connector a2 of the exhaust air"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
equation
  connect(senExhFlow.port_b, hex.port_a2)
    annotation (Line(points={{42,-6},{26,-6}}, color={0,127,255}));
  connect(hex.port_a1, senSupFlow.port_b)
    annotation (Line(points={{6,6},{-2,6},
    {-2,100},{-28,100}}, color={0,127,255}));
  connect(hex.port_b1, port_b1)
    annotation (Line(points={{26,6},{64,6},{64,100},
    {100,100}}, color={0,127,255}));
  connect(hex.port_b2, port_b2)
    annotation (Line(points={{6,-6},{-62,-6},{-62,-60},
    {-100,-60}}, color={0,127,255}));
  connect(PEle.y, P)
    annotation (Line(points={{91,0},{110,0}}, color={0,0,127}));
  connect(senExhFlow.port_a, port_a2)
    annotation (Line(points={{56,-6},{64,-6},{
    64,-60},{100,-60}}, color={0,127,255}));
  connect(senSupFlow.port_a, port_a1)
    annotation (Line(points={{-42,100},{-72,100},
    {-72,100},{-100,100}}, color={0,127,255}));
  connect(effCal.epsSen, hex.epsSen)
    annotation (Line(points={{-19,54},{-6,54},{-6,4},{4,4}}, color={0,0,127}));
  connect(effCal.epsLat, hex.epsLat)
    annotation (Line(points={{-19,46},{-12,46},
    {-12,-4},{4,-4}}, color={0,0,127}));
  connect(effCal.wheSpe, wheSpe)
    annotation (Line(points={{-42,50},{-94,50},{-94,
    0},{-120,0}}, color={0,0,127}));
  connect(senSupFlow.V_flow, effCal.VSup_flow)
    annotation (Line(points={{-35,108.8},
    {-35,120},{-80,120},{-80,58},{-42,58}}, color={0,0,127}));
  connect(senExhFlow.V_flow, effCal.VExh_flow)
    annotation (Line(points={{49,2.8},
    {49,80},{-74,80},{-74,54},{-42,54}}, color={0,0,127}));
  connect(TSup.y, effCal.TSup)
    annotation (Line(points={{-69,38},{-60,38},{-60,46},
    {-42,46}}, color={0,0,127}));
  connect(TExh.y, effCal.TExh)
    annotation (Line(points={{-69,20},{-52,20},{-52,42},
    {-42,42}}, color={0,0,127}));
  annotation (
        defaultComponentName="whe",
        Icon(coordinateSystem(extent={{-100,-100},{100,
            100}}), graphics={
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
          extent={{-92,-55},{-32,-64}},
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
        Ellipse(extent={{6,88},{38,-90}},   lineColor={28,108,200},
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
        Line(points={{-22,-90},{22,-90}},   color={28,108,200}),
        Line(points={{-20,88},{22,88}},   color={28,108,200}),
        Text(
          extent={{-149,-108},{151,-148}},
          textColor={0,0,255},
          textString="%name")}),
          Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,140}})),
Documentation(info="<html>
<p>
Model of a generic, sensible, and latent air-to-air heat recovery wheel with a variable speed drive.
</p>
<p>
The input requires no geometric data. Performance is defined by specifying sensible and latent effectiveness 
at 75% and 100% of the nominal supply air flow rate in both heating and cooling conditions.
For details, refer to
<a href=\"modelica://Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.Effectiveness\">
Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.Effectiveness</a>.
</p>
<p>
The operation of the heat recovery wheel is adjustable by modulating the wheel speed.
</p>
</html>", revisions="<html>
<ul>
<li>
September 29, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end WheelWithVariableSpeed;
