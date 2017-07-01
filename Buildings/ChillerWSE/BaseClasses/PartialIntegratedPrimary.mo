within Buildings.ChillerWSE.BaseClasses;
model PartialIntegratedPrimary
  "Integrated water-side economizer for primary-only chilled water system"
  extends Buildings.ChillerWSE.BaseClasses.PartialChillerWSE(
    nVal=6);

  //WSE mode valve parameters
  parameter Real lValve5(min=1e-10,max=1) = 0.0001
    "Valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="On/Off valve"));
  parameter Real lValve6(min=1e-10,max=1) = 0.0001
    "Valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="On/Off valve"));

  parameter Real yValve5_start = 0 "Initial value of output:0-closed, 1-fully opened"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));
  parameter Real yValve6_start = 1-yValve5_start "Initial value of output:0-closed, 1-fully opened"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));


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
    "On/Off valve: closed when fully mechanic cooling is activated; open when fully mechanic cooling is activated"
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
    "On/Off valve: closed when free cooling mode is deactivated; open when free cooling is activated"
    annotation (Placement(transformation(extent={{-40,-30},{-60,-10}})));
  Modelica.Blocks.Interfaces.RealInput yVal6
    "Actuator position for valve 6 (0: closed, 1: open)" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-10}), iconTransformation(
        extent={{-16,-16},{16,16}},
        rotation=0,
        origin={-116,-2})));
  Modelica.Blocks.Interfaces.RealInput yVal5
    "Actuator position for valve 5(0: closed, 1: open)" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,20}), iconTransformation(
        extent={{16,16},{-16,-16}},
        rotation=180,
        origin={-116,30})));
equation
  connect(port_a2,val5. port_a) annotation (Line(points={{100,-60},{80,-60},{80,
          -20},{60,-20}}, color={0,127,255}));
  connect(port_a2, wse.port_a2) annotation (Line(points={{100,-60},{88,-60},{80,
          -60},{80,24},{60,24}}, color={0,127,255}));
  connect(wse.port_b2,val5. port_b) annotation (Line(points={{40,24},{20,24},{20,
          20},{20,-20},{40,-20}}, color={0,127,255}));
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
