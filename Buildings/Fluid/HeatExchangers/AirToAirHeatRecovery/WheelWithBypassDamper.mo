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
  parameter Modelica.Units.SI.PressureDifference dp1_nominal
    "Nominal pressure drop of the supply air stream";
  parameter Modelica.Units.SI.PressureDifference dp2_nominal
    "Nominal pressure drop of the exhaust air stream";
  parameter Real P_nominal(final unit="W") = 1000
    "Power at design condition";
  parameter Modelica.Units.SI.Efficiency epsS_cool_nominal(final max=1) = 0.8
    "Nominal sensible heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsL_cool_nominal(final max=1) = 0.8
    "Nominal latent heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsS_cool_partload(final max=1) = 0.75
    "Partial load (75%) sensible heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsL_cool_partload(final max=1) = 0.75
    "Partial load (75%) latent heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsS_heat_nominal(final max=1) = 0.8
    "Nominal sensible heat exchanger effectiveness at the heating mode";
  parameter Modelica.Units.SI.Efficiency epsL_heat_nominal(final max=1) = 0.8
    "Nominal latent heat exchanger effectiveness at the heating mode";
  parameter Modelica.Units.SI.Efficiency epsS_heat_partload(final max=1) = 0.75
    "Partial load (75%) sensible heat exchanger effectiveness at the heating mode";
  parameter Modelica.Units.SI.Efficiency epsL_heat_partload(final max=1) = 0.75
    "Partial load (75%) latent heat exchanger effectiveness at the heating mode";

  Modelica.Blocks.Interfaces.RealInput yBypDam(final unit="1")
    "Bypass damper position"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
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
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.EffectivenessCalculation
    effCal(
    final epsS_cool_nominal=epsS_cool_nominal,
    final epsL_cool_nominal=epsL_cool_nominal,
    final epsS_cool_partload=epsS_cool_partload,
    final epsL_cool_partload=epsL_cool_partload,
    final epsS_heat_nominal=epsS_heat_nominal,
    final epsL_heat_nominal=epsL_heat_nominal,
    final epsS_heat_partload=epsS_heat_partload,
    final epsL_heat_partload=epsL_heat_partload,
    final vSup_flow_nominal=m1_flow_nominal/1.293)
    "Calculates the effectiveness of heat exchanges"
    annotation (Placement(transformation(extent={{-54,100},{-34,120}})));
  Buildings.Fluid.Sensors.VolumeFlowRate senExhFlow(
    redeclare package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal)
    "Damper in the exhaust air stream"
    annotation (Placement(transformation(extent={{34,-14},{20,2}})));
  Buildings.Fluid.Sensors.VolumeFlowRate senSupFlow(
    redeclare package Medium =Medium1,
    final m_flow_nominal=m1_flow_nominal)
    "Flow sensor in the supply air stream"
    annotation (Placement(transformation(extent={{-46,12},{-32,28}})));
  Buildings.Fluid.Actuators.Dampers.Exponential bypDamSup(
    redeclare package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final dpDamper_nominal=dp1_nominal)
    "Bypass damper in the supply air stream"
    annotation (Placement(transformation(extent={{36,50},{56,70}})));
  Buildings.Fluid.Actuators.Dampers.Exponential damSup(
    redeclare package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final dpDamper_nominal=dp1_nominal)
    "Damper in the supply air stream"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,40})));
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
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
  Modelica.Blocks.Sources.RealExpression TSup(
      final y=Medium1.temperature(
      Medium1.setState_phX(
        p=port_a1.p,
        h=inStream(port_a1.h_outflow),
        X=inStream(port_a1.Xi_outflow))))
    "Temperature of the supply air"
    annotation (Placement(transformation(extent={{-98,92},{-78,112}})));
  Modelica.Blocks.Sources.RealExpression TExh(
      final y=Medium2.temperature(
      Medium2.setState_phX(
        p=port_a2.p,
        h=inStream(port_a2.h_outflow),
        X=inStream(port_a2.Xi_outflow))))
    "Temperature of the exhaust air"
    annotation (Placement(transformation(extent={{-98,70},{-78,90}})));
  Modelica.Blocks.Sources.RealExpression PEle(y=P_nominal)
    "Electrical power consumption"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
    redeclare final package Medium = Medium1)
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium = Medium2)
    "Fluid connector b2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-90,-70},{-110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
    redeclare final package Medium = Medium1)
    "Fluid connector b1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{110,50},{90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare final package Medium = Medium2)
    "Fluid connector a2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Blocks.Sources.Constant uni(final k=1)
    "Unity signal"
    annotation (Placement(transformation(extent={{-88,120},{-74,134}})));
  Modelica.Blocks.Math.Add add(final k2=-1)
    "Adder"
    annotation (Placement(transformation(extent={{-6,100},{10,116}})));
equation
  connect(senExhFlow.port_b, hex.port_a2)
    annotation (Line(points={{20,-6},{10,-6}}, color={0,127,255}));
  connect(hex.port_a1, senSupFlow.port_b) annotation (Line(points={{-10,6},{-20,
          6},{-20,20},{-32,20}}, color={0,127,255}));
  connect(bypDamSup.port_a, port_a1)
    annotation (Line(points={{36,60},{-100,60}},  color={0,127,255}));
  connect(bypDamSup.port_b, port_b1)
    annotation (Line(points={{56,60},{100,60}}, color={0,127,255}));
  connect(bypDamExh.port_a, port_a2)
    annotation (Line(points={{10,-60},{100,-60}}, color={0,127,255}));
  connect(bypDamExh.port_b, port_b2)
    annotation (Line(points={{-10,-60},{-100,-60}}, color={0,127,255}));
  connect(hex.port_b1, port_b1) annotation (Line(points={{10,6},{66,6},{66,60},{
          100,60}}, color={0,127,255}));
  connect(hex.port_b2, port_b2) annotation (Line(points={{-10,-6},{-44,-6},{-44,
          -60},{-100,-60}}, color={0,127,255}));
  connect(PEle.y, P)
    annotation (Line(points={{91,0},{110,0}}, color={0,0,127}));
  connect(senSupFlow.port_a, damSup.port_b)
    annotation (Line(points={{-46,20},{-70,20},{-70,30}}, color={0,127,255}));
  connect(damSup.port_a, port_a1)
    annotation (Line(points={{-70,50},{-70,60},{-100,60}}, color={0,127,255}));
  connect(senExhFlow.port_a, damExh.port_b)
    annotation (Line(points={{34,-6},{60,-6},{60,-30}}, color={0,127,255}));
  connect(damExh.port_a, port_a2)
    annotation (Line(points={{60,-50},{60,-60},{100,-60}}, color={0,127,255}));
  connect(TSup.y, effCal.TSup)
    annotation (Line(points={{-77,102},{-70,102},{-70,114},{-56,114}},
                                                   color={0,0,127}));
  connect(effCal.TExh, TExh.y) annotation (Line(points={{-56,110},{-68,110},{-68,
          80},{-77,80}}, color={0,0,127}));
  connect(senSupFlow.V_flow, effCal.vSup_flow) annotation (Line(points={{-39,28.8},
          {-39,90},{-62,90},{-62,106},{-56,106}}, color={0,0,127}));
  connect(senExhFlow.V_flow, effCal.vExh_flow) annotation (Line(points={{27,2.8},
          {26,2.8},{26,64},{-36,64},{-36,96},{-60,96},{-60,102},{-56,102}},
        color={0,0,127}));
  connect(effCal.epsS, hex.epsS) annotation (Line(points={{-33,114},{-26,114},{-26,
          4},{-12,4}}, color={0,0,127}));
  connect(effCal.epsL, hex.epsL) annotation (Line(points={{-33,106},{-30,106},{-30,
          -4},{-12,-4}}, color={0,0,127}));
  connect(bypDamSup.y, yBypDam) annotation (Line(points={{46,72},{46,80},{-52,80},
          {-52,0},{-120,0}}, color={0,0,127}));
  connect(bypDamExh.y, yBypDam) annotation (Line(points={{0,-48},{0,-24},{-52,-24},
          {-52,0},{-120,0}}, color={0,0,127}));
  connect(uni.y, effCal.y) annotation (Line(points={{-73.3,127},{-62,127},{-62,118},
          {-56,118}}, color={0,0,127}));
  connect(add.u1, uni.y) annotation (Line(points={{-7.6,112.8},{-20,112.8},{-20,
          127},{-73.3,127}}, color={0,0,127}));
  connect(add.u2, yBypDam) annotation (Line(points={{-7.6,103.2},{-20,103.2},{-20,
          80},{-52,80},{-52,0},{-120,0}}, color={0,0,127}));
  connect(add.y, damSup.y) annotation (Line(points={{10.8,108},{20,108},{20,40},
          {-58,40}}, color={0,0,127}));
  connect(damExh.y, add.y) annotation (Line(points={{48,-40},{14,-40},{14,40},{20,
          40},{20,108},{10.8,108}}, color={0,0,127}));
  annotation (
        defaultComponentName="whe",
        Icon(coordinateSystem(extent={{-100,-100},{100,
            100}}),                                       graphics={
        Rectangle(
          extent={{-92,-55},{-34,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-94,65},{-34,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{6,88},{38,-90}},   lineColor={28,108,200}),
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
        Line(points={{-20,88},{24,88}},   color={28,108,200}),
        Rectangle(
          extent={{34,64},{94,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{36,-56},{94,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-108},{151,-148}},
          textColor={0,0,255},
          textString="%name"),
        Line(points={{-58,62},{-58,96},{64,96},{64,64}}, color={28,108,200}),
        Line(points={{-58,-62},{-58,-96},{64,-96},{64,-64}}, color={28,108,200})}),
          Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,140}})),
    Documentation(info="<html>
Model for a generic, sensible and latent air-to-air heat recovery wheel, that consists of 
a heat exchanger and primary/secondary airflow bypass dampers.

The input requires no geometric data. Performance is defined by specifying sensible and/or latent effectiveness 
at 75% and 100% of the nominal supply air flow rate in both heating and cooling conditions
For details, refer to
<a href=\"modelica://Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.EffectivenessCalculation\">
Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.EffectivenessCalculation</a>.

The operation of the heat recovery wheel is adjustable through wheel speed modulation or bypassing supply air 
around the heat exchanger.
The parameter, <i>controlType</i>, can be used to specify either wheel speed modulation or bypassing supply air
is used.
See more in  
<a href=\"modelica://Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.Types.RecoveryControlType\">
Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.Types.RecoveryControlType</a>.

</html>", revisions="<html>
<ul>
<li>
September 29, 2023, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>"));
end WheelWithBypassDamper;
