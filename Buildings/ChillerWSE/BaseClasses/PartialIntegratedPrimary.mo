within Buildings.ChillerWSE.BaseClasses;
model PartialIntegratedPrimary
  "Integrated WSE for Primary Chilled Water System"
  extends Buildings.ChillerWSE.BaseClasses.PartialChillerWSE(
    nVal=6);

  //WSE mode valve parameters
  parameter Real lValve1(min=1e-10,max=1) = 0.0001
    "Valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Valve"));
  parameter Real lValve2(min=1e-10,max=1) = 0.0001
    "Valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Valve"));

  parameter Real yValve1_start = 0 "Initial value of output:0-closed, 1-fully opened"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));
  parameter Real yValve2_start = 1-yValve1_start "Initial value of output:0-closed, 1-fully opened"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));


  Buildings.Fluid.Actuators.Valves.TwoWayLinear val1(
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
    final l=lValve1,
    final kFixed=0,
    final rhoStd=rhoStd[5],
    final y_start=yValve1_start)
    annotation (Placement(transformation(extent={{60,-30},{40,-10}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val2(
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
    final l=lValve2,
    final kFixed=0,
    final rhoStd=rhoStd[6],
    final y_start=yValve2_start)
    annotation (Placement(transformation(extent={{-40,-30},{-60,-10}})));
equation
  connect(port_a2,val1. port_a) annotation (Line(points={{100,-60},{80,-60},{80,
          -20},{60,-20}}, color={0,127,255}));
  connect(port_a2, wse.port_a2) annotation (Line(points={{100,-60},{88,-60},{80,
          -60},{80,24},{60,24}}, color={0,127,255}));
  connect(wse.port_b2,val1. port_b) annotation (Line(points={{40,24},{20,24},{20,
          20},{20,-20},{40,-20}}, color={0,127,255}));
  connect(val2.port_a, chiPar.port_a2) annotation (Line(points={{-40,-20},{-20,-20},
          {-20,24},{-40,24}}, color={0,127,255}));
  connect(chiPar.port_b2, port_b2) annotation (Line(points={{-60,24},{-80,24},{-80,
          -60},{-100,-60}}, color={0,127,255}));
  connect(val2.port_b, port_b2) annotation (Line(points={{-60,-20},{-80,-20},{-80,
          -60},{-100,-60}}, color={0,127,255}));
  if use_inputFilter then
  else
  end if;

end PartialIntegratedPrimary;
