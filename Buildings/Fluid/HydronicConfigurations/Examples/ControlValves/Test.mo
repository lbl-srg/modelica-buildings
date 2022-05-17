within Buildings.Fluid.HydronicConfigurations.Examples.ControlValves;
model Test
  package MediumLiq = Buildings.Media.Water
    "Medium model for hot water";
  parameter Modelica.Units.SI.MassFlowRate mLiq_flow_nominal = 1
    "Circuit mass flow rate at design conditions";
  parameter Modelica.Units.SI.Pressure p_min = 2E5
    "Circuit minimum pressure";
  parameter Modelica.Units.SI.Pressure dp_nominal = 1E5
    "Circuit total pressure drop at design conditions";

  Sources.Boundary_pT sup(
    redeclare final package Medium = MediumLiq,
    final p=p_min + dp_nominal,
    nPorts=8) "Pressure boundary condition at supply"
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
  Sources.Boundary_pT ret(
    redeclare final package Medium = MediumLiq,
    final p=p_min,
    nPorts=4)
    "Pressure boundary condition at return"
    annotation (Placement(transformation(extent={{-70,-90},{-50,-70}})));
  Actuators.Valves.ThreeWayEqualPercentageLinear val(
    redeclare final package Medium = MediumLiq,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_inputFilter=false,
    final m_flow_nominal=mLiq_flow_nominal,
    fraK=1,
    final dpValve_nominal=dp_nominal)
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,-20})));
  Controls.OBC.CDL.Continuous.Sources.Ramp ope(duration=100)
    "Valve opening signal"
    annotation (Placement(transformation(extent={{220,-10},{200,10}})));
  Actuators.Valves.ThreeWayEqualPercentageLinear valAut90(
    redeclare final package Medium = MediumLiq,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_inputFilter=false,
    final m_flow_nominal=mLiq_flow_nominal,
    fraK=1,
    final dpValve_nominal=0.9*dp_nominal) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,0})));
  FixedResistances.PressureDrop ter10(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    dp_nominal=0.1*dp_nominal)
    "Terminal unit as a fixed resistance destroying 10% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,40})));
  FixedResistances.PressureDrop ter1(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    dp_nominal=0.1*dp_nominal)
    "Terminal unit as a fixed resistance destroying 10% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,40})));
  Actuators.Valves.ThreeWayEqualPercentageLinear valAut1(
    redeclare final package Medium = MediumLiq,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_inputFilter=false,
    final m_flow_nominal=mLiq_flow_nominal,
    fraK=1,
    final dpValve_nominal=0.1*dp_nominal) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,-20})));
  FixedResistances.PressureDrop ter2(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    dp_nominal=0.8*dp_nominal)
    "Terminal unit as a fixed resistance destroying xx% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,-60})));
  Actuators.Valves.ThreeWayEqualPercentageLinear valAut2(
    redeclare final package Medium = MediumLiq,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_inputFilter=false,
    final m_flow_nominal=mLiq_flow_nominal,
    fraK=1,
    final dpValve_nominal=0.5*dp_nominal) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={140,20})));
  FixedResistances.PressureDrop ter3(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    dp_nominal=0.5*dp_nominal)
    "Terminal unit as a fixed resistance destroying 10% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={140,46})));
equation
  connect(sup.ports[1], val.port_1)
    annotation (Line(points={{-50,58.25},{-20,58.25},{-20,-10}},
                                                        color={0,127,255}));
  connect(val.port_2, ret.ports[1])
    annotation (Line(points={{-20,-30},{-20,-81.5},{-50,-81.5}},
                                                           color={0,127,255}));
  connect(ope.y, val.y)
    annotation (Line(points={{198,0},{50,0},{50,-20},{-8,-20}},
                                             color={0,0,127}));
  connect(sup.ports[2], val.port_3) annotation (Line(points={{-50,58.75},{-40,
          58.75},{-40,-20},{-30,-20}},
                          color={0,127,255}));
  connect(ope.y, valAut90.y)
    annotation (Line(points={{198,0},{32,0}}, color={0,0,127}));
  connect(sup.ports[3], ter10.port_a) annotation (Line(points={{-50,59.25},{20,
          59.25},{20,50}}, color={0,127,255}));
  connect(sup.ports[4], valAut90.port_3) annotation (Line(points={{-50,59.75},{
          0,59.75},{0,0},{10,0}}, color={0,127,255}));
  connect(ter10.port_b, valAut90.port_1)
    annotation (Line(points={{20,30},{20,10},{20,10}}, color={0,127,255}));
  connect(valAut90.port_2, ret.ports[2]) annotation (Line(points={{20,-10},{20,
          -80.5},{-50,-80.5}}, color={0,127,255}));
  connect(valAut1.port_2, ter2.port_a)
    annotation (Line(points={{80,-30},{80,-50}}, color={0,127,255}));
  connect(ter2.port_b, ret.ports[3]) annotation (Line(points={{80,-70},{80,-82},
          {-50,-82},{-50,-79.5}}, color={0,127,255}));
  connect(sup.ports[5], ter1.port_a) annotation (Line(points={{-50,60.25},{80,
          60.25},{80,50}}, color={0,127,255}));
  connect(sup.ports[6], valAut1.port_3) annotation (Line(points={{-50,60.75},{
          60,60.75},{60,-20},{70,-20}}, color={0,127,255}));
  connect(ter1.port_b, valAut1.port_1)
    annotation (Line(points={{80,30},{80,-10}}, color={0,127,255}));
  connect(valAut1.y, ope.y) annotation (Line(points={{92,-20},{116,-20},{116,0},
          {198,0}}, color={0,0,127}));
  connect(sup.ports[7], valAut2.port_3) annotation (Line(points={{-50,61.25},{
          120,61.25},{120,20},{130,20}}, color={0,127,255}));
  connect(sup.ports[8], ter3.port_a) annotation (Line(points={{-50,61.75},{140,
          61.75},{140,56}}, color={0,127,255}));
  connect(ter3.port_b, valAut2.port_1)
    annotation (Line(points={{140,36},{140,30}}, color={0,127,255}));
  connect(valAut2.port_2, ret.ports[4]) annotation (Line(points={{140,10},{140,
          -78.5},{-50,-78.5}}, color={0,127,255}));
  connect(ope.y, valAut2.y) annotation (Line(points={{198,0},{176,0},{176,20},{
          152,20}}, color={0,0,127}));
  annotation (experiment(
    StopTime=100,
    Tolerance=1e-6),Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Test;
