within Buildings.Examples.ChillerPlants.RP1711.BaseClasses;
model testParPum "Test parallel pump configuration"
  extends Modelica.Icons.Example;
  package MediumW = Buildings.Media.Water;
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal=6
    "Nominal mass flow rate in condenser water loop";
  final parameter Modelica.Units.SI.PressureDifference dpCon_nominal=50000+15000+75000
    "Nominal pressure difference in condenser water loop";

  Buildings.Fluid.Movers.SpeedControlled_y conWatPum1(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=false,
    per(pressure(V_flow={0,mCon_flow_nominal,2*mCon_flow_nominal}/1.2,
                     dp={2*dpCon_nominal,dpCon_nominal,0})),
    final use_inputFilter=false)
    "Condenser water pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,origin={-30,30})));
  Buildings.Fluid.Movers.SpeedControlled_y conWatPum2(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=false,
    per(pressure(V_flow={0,mCon_flow_nominal,2*mCon_flow_nominal}/1.2,
                     dp={2*dpCon_nominal,dpCon_nominal,0})),
    final use_inputFilter=false)
    "Condenser water pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,origin={30,30})));
  Buildings.Fluid.FixedResistances.Junction jun1(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mCon_flow_nominal,mCon_flow_nominal,mCon_flow_nominal},
    final dp_nominal={0,0,0}) "Flow junction"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,origin={30,60})));
  Buildings.Fluid.FixedResistances.Junction jun2(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mCon_flow_nominal,mCon_flow_nominal,mCon_flow_nominal},
    final dp_nominal={0,0,0}) "Flow junction"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,origin={30,-20})));

  Fluid.Sources.Boundary_pT           sou(
    redeclare package Medium = MediumW,
    use_p_in=false,
    p=101325,
    T=293.15,
    nPorts=1) annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Fluid.Sources.Boundary_pT           sin(
    redeclare package Medium = MediumW,
    use_p_in=false,
    p=101325,
    T=293.15,
    nPorts=1) annotation (Placement(transformation(extent={{80,-80},{60,-60}})));
  Fluid.FixedResistances.PressureDrop           dp1(
    redeclare package Medium = MediumW,
    from_dp=true,
    m_flow_nominal=mCon_flow_nominal,
    dp_nominal=dpCon_nominal)
                      "Pressure drop"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={30,-50})));
  Fluid.FixedResistances.CheckValve cheVal(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCon_flow_nominal,
    dpValve_nominal=3400) annotation (Placement(transformation(
        extent={{-10,-11},{10,11}},
        rotation=-90,
        origin={-30,1})));
  Fluid.FixedResistances.CheckValve cheVal1(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCon_flow_nominal,
    dpValve_nominal=3400) annotation (Placement(transformation(
        extent={{-10,-11},{10,11}},
        rotation=-90,
        origin={30,5})));
protected
  Controls.OBC.CDL.Continuous.Sources.Ramp     ram[2](
    height={1,0},
    duration=fill(1, 2),
    startTime=fill(0.2, 2))
    "Constant "
    annotation (Placement(transformation(extent={{-60,-46},{-40,-26}})));
equation
  connect(conWatPum2.port_a, jun1.port_2)
    annotation (Line(points={{30,40},{30,50}},     color={28,108,200},
      thickness=1));
  connect(conWatPum1.port_a, jun1.port_3)
    annotation (Line(points={{-30,40},{-30,60},{20,60}},     color={28,108,200},
      thickness=1));
  connect(sou.ports[1], jun1.port_1)
    annotation (Line(points={{0,80},{30,80},{30,70}}, color={0,127,255},
      thickness=1));
  connect(ram[1].y, conWatPum1.y) annotation (Line(points={{-38,-36},{-8,-36},{-8,
          30},{-18,30}},
                       color={0,0,127}));
  connect(ram[2].y, conWatPum2.y) annotation (Line(points={{-38,-36},{52,-36},{52,
          30},{42,30}},
                      color={0,0,127}));
  connect(jun2.port_2, dp1.port_a)
    annotation (Line(points={{30,-30},{30,-40}}, color={28,108,200},
      thickness=1));
  connect(dp1.port_b, sin.ports[1])
    annotation (Line(points={{30,-60},{30,-70},{60,-70}}, color={28,108,200},
      thickness=1));
  connect(conWatPum1.port_b, cheVal.port_a)
    annotation (Line(points={{-30,20},{-30,11}}, color={28,108,200},
      thickness=1));
  connect(cheVal.port_b, jun2.port_3)
    annotation (Line(points={{-30,-9},{-30,-20},{20,-20}}, color={28,108,200},
      thickness=1));
  connect(jun2.port_1, cheVal1.port_b)
    annotation (Line(points={{30,-10},{30,-5}}, color={28,108,200},
      thickness=1));
  connect(cheVal1.port_a, conWatPum2.port_b)
    annotation (Line(points={{30,15},{30,20}}, color={28,108,200},
      thickness=1));
 annotation (
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
    graphics={Line(points={{290,46}},color={28,108,200})}),
    experiment(
      __Dymola_NumberOfIntervals=5000000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end testParPum;
