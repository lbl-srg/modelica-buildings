within Buildings.ChillerWSE.BaseClasses;
model PartialIntegratedPrimary
  "Integrated water-side economizer for primary-only chilled water system"
  extends Buildings.ChillerWSE.BaseClasses.PartialChillerWSE(
    nVal=6);

  //Parameters for the valve used in free cooling mode
  parameter Real lValve5(min=1e-10,max=1) = 0.0001
    "Valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Shutoff valve"));
  parameter Real lValve6(min=1e-10,max=1) = 0.0001
    "Valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Shutoff valve"));

  parameter Real yValve5_start = 0 "Initial value of output:0-closed, 1-fully opened"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));
  parameter Real yValve6_start = 1-yValve5_start "Initial value of output:0-closed, 1-fully opened"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));
  // Temperature sensor
  parameter Modelica.SIunits.Time tau_SenT=1
    "Time constant at nominal flow rate (use tau=0 for steady-state sensor, but see user guide for potential problems)"
   annotation(Dialog(tab="Dynamics", group="Temperature Sensor",
     enable=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));
  parameter Modelica.Blocks.Types.Init initTSenor = Modelica.Blocks.Types.Init.InitialState
    "Type of initialization of the temperature sensor (InitialState and InitialOutput are identical)"
  annotation(Evaluate=true, Dialog(tab="Dynamics", group="Temperature Sensor"));

  Modelica.Blocks.Interfaces.RealOutput wseCHWST(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=0,
    start=T2_start)
    "Chilled water supply temperature in the waterside economizer" annotation (
      Placement(transformation(extent={{100,30},{120,50}}), iconTransformation(
          extent={{100,30},{120,50}})));


 Modelica.Blocks.Interfaces.RealInput yVal6(min=0,max=1)
    "Actuator position for valve 6 (0: closed, 1: open)" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-10}), iconTransformation(
        extent={{-16,-16},{16,16}},
        rotation=0,
        origin={-116,-2})));

  Modelica.Blocks.Interfaces.RealInput yVal5(min=0,max=1)
    "Actuator position for valve 5(0: closed, 1: open)" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,20}), iconTransformation(
        extent={{16,16},{-16,-16}},
        rotation=180,
        origin={-116,30})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val5(
    redeclare final package Medium = Medium2,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final allowFlowReversal=allowFlowReversal2,
    final m_flow_nominal=nChi*mChiller2_flow_nominal,
    final show_T=show_T,
    final from_dp=from_dp2,
    final homotopyInitialization=homotopyInitialization,
    final linearized=linearizeFlowResistance2,
    final deltaM=deltaM2,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTimeValve,
    final init=initValve,
    final dpFixed_nominal=0,
    final dpValve_nominal=dpValve_nominal[5],
    final l=lValve5,
    final kFixed=0,
    final rhoStd=rhoStd[5],
    final y_start=yValve5_start)
    "Shutoff valve: closed when fully mechanic cooling is activated; open when fully mechanic cooling is activated"
    annotation (Placement(transformation(extent={{60,-30},{40,-10}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val6(
    redeclare final package Medium = Medium2,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final m_flow_nominal=mWSE2_flow_nominal,
    final allowFlowReversal=allowFlowReversal2,
    final show_T=show_T,
    final from_dp=from_dp2,
    final homotopyInitialization=homotopyInitialization,
    final linearized=linearizeFlowResistance2,
    final deltaM=deltaM2,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTimeValve,
    final init=initValve,
    final dpFixed_nominal=0,
    final dpValve_nominal=dpValve_nominal[6],
    final l=lValve6,
    final kFixed=0,
    final rhoStd=rhoStd[6],
    final y_start=yValve6_start)
    "Shutoff valve: closed when free cooling mode is deactivated; open when free cooling is activated"
    annotation (Placement(transformation(extent={{-40,-30},{-60,-10}})));

  Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare final replaceable package Medium = Medium2,
    final m_flow_nominal=mWSE2_flow_nominal,
    final tau=tau_SenT,
    final initType=initTSenor,
    final T_start=T2_start,
    final allowFlowReversal=allowFlowReversal2,
    final m_flow_small=m2_flow_small) "Temperature sensor"
    annotation (Placement(transformation(extent={{28,14},{8,34}})));

equation
  connect(port_a2,val5. port_a) annotation (Line(points={{100,-60},{80,-60},{80,
          -20},{60,-20}}, color={0,127,255}));
  connect(port_a2, wse.port_a2) annotation (Line(points={{100,-60},{88,-60},{80,
          -60},{80,24},{60,24}}, color={0,127,255}));
  connect(val6.port_a, chiPar.port_a2) annotation (Line(points={{-40,-20},{-20,-20},
          {-20,24},{-40,24}}, color={0,127,255}));
  connect(chiPar.port_b2, port_b2) annotation (Line(points={{-60,24},{-80,24},{-80,
          -60},{-100,-60}}, color={0,127,255}));
  connect(val6.port_b, port_b2) annotation (Line(points={{-60,-20},{-80,-20},{-80,
          -60},{-100,-60}}, color={0,127,255}));
  connect(val5.y, yVal5) annotation (Line(points={{50,-8},{50,0},{50,0},{-94,0},
          {-94,20},{-120,20}}, color={0,0,127}));
  connect(yVal6, val6.y) annotation (Line(points={{-120,-10},{-94,-10},{-94,0},
          {-50,0},{-50,-8}}, color={0,0,127}));
  connect(wse.port_b2, senTem.port_a)
    annotation (Line(points={{40,24},{28,24}}, color={0,127,255}));
  connect(senTem.port_b, val5.port_b) annotation (Line(points={{8,24},{-4,24},{-4,
          -20},{40,-20}}, color={0,127,255}));
  connect(senTem.T, wseCHWST) annotation (Line(points={{18,35},{18,35},{18,52},
          {90,52},{90,40},{110,40}}, color={0,0,127}));
  annotation (Documentation(info="<html>
Partial model that implements integrated waterside economizer in primary-ony chilled water system.
</html>", revisions="<html>
<ul>
<li>
July 1, 2017, by Yangyang Fu:<br>
First implementation.
</li>
</ul>
</html>"));
end PartialIntegratedPrimary;
