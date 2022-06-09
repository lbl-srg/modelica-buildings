within Buildings.Fluid.HydronicConfigurations.Examples.ControlValves;
model TwoWayClosedLoop
  "Model illustrating the concept of the authority for two-way valves and closed loop control"
  extends Modelica.Icons.Example;

  package MediumLiq = Buildings.Media.Water
    "Medium model for hot water";
  parameter Modelica.Units.SI.MassFlowRate mLiq_flow_nominal = 1
    "Circuit mass flow rate at design conditions";
  parameter Modelica.Units.SI.Pressure p_min = 2E5
    "Circuit minimum pressure";
  parameter Modelica.Units.SI.PressureDifference dp_nominal = 1E5
    "Circuit total pressure drop at design conditions";

  parameter Modelica.Units.SI.Temperature TAirEnt_nominal = 20 + 273.15
    "Air entering temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TLiqEnt_nominal = 60 + 273.15
    "Hot water entering temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TLiqLvg_nominal = 50 + 273.15
    "Hot water leaving temperature at design conditions";

  Sources.Boundary_pT sup(
    redeclare final package Medium = MediumLiq,
    final p=p_min + dp_nominal,
    T=TLiqEnt_nominal,
    nPorts=2) "Pressure boundary condition at supply"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-80,-90})));
  Sources.Boundary_pT ret(
    redeclare final package Medium = MediumLiq,
    final p=p_min,
    nPorts=2) "Pressure boundary condition at return"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-90})));
  Actuators.Valves.TwoWayEqualPercentage valAut100(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    final dpValve_nominal=dp_nominal,
    use_inputFilter=false,
    dpFixed_nominal=0) "Control valve with 100% authority"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,0})));

  .Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable fraLoa(
    table=[0,0; 1,0.2; 2,0.2; 3,0.5; 4,0.5; 5,0.7; 6,0.7; 7,0.6; 8,0.6; 9,1; 10,
        1],
    timeScale=20,
    y(unit="K", displayUnit="degC")) "Load modulating signal"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));

  BaseClasses.Load loa100(
    redeclare final package MediumLiq = MediumLiq,
    final mLiq_flow_nominal=mLiq_flow_nominal,
    final TAirEnt_nominal=TAirEnt_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal,
    k=10) "Load"
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));
  BaseClasses.Load loa20(
    redeclare final package MediumLiq = MediumLiq,
    final mLiq_flow_nominal=mLiq_flow_nominal,
    final TAirEnt_nominal=TAirEnt_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal,
    k=10) "Load"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  Actuators.Valves.TwoWayEqualPercentage valAut20(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    final dpValve_nominal=0.2*dp_nominal,
    use_inputFilter=false,
    dpFixed_nominal=0.8*dp_nominal) "Control valve with 20% authority"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,0})));
equation
  connect(loa100.port_b, valAut100.port_a)
    annotation (Line(points={{-50,40},{-40,40},{-40,10}}, color={0,127,255}));
  connect(loa100.yVal, valAut100.y) annotation (Line(points={{-48,46},{-20,46},
          {-20,0},{-28,0}}, color={0,0,127}));
  connect(fraLoa.y[1], loa100.u) annotation (Line(points={{-98,60},{-80,60},{-80,
          46},{-72,46}}, color={0,0,127}));
  connect(sup.ports[1], loa100.port_a) annotation (Line(points={{-81,-80},{-80,-80},
          {-80,40},{-70,40}},      color={0,127,255}));
  connect(valAut100.port_b, ret.ports[1])
    annotation (Line(points={{-40,-10},{-40,-80},{1,-80}}, color={0,127,255}));
  connect(sup.ports[2], loa20.port_a) annotation (Line(points={{-79,-80},{-80,-80},
          {-80,-40},{0,-40},{0,40},{10,40}}, color={0,127,255}));
  connect(loa20.port_b, valAut20.port_a)
    annotation (Line(points={{30,40},{40,40},{40,10}}, color={0,127,255}));
  connect(loa20.yVal, valAut20.y)
    annotation (Line(points={{32,46},{60,46},{60,0},{52,0}}, color={0,0,127}));
  connect(fraLoa.y[1], loa20.u) annotation (Line(points={{-98,60},{-10,60},{-10,
          46},{8,46}}, color={0,0,127}));
  connect(valAut20.port_b, ret.ports[2])
    annotation (Line(points={{40,-10},{40,-80},{-1,-80}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-140,-120},{140,120}})),
    experiment(
    StopTime=1000,
    Tolerance=1e-6));
end TwoWayClosedLoop;
