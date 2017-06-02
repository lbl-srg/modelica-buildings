within Buildings.ChillerWSE;
model WatersideEconomizerParallel "Parallel heat exchangers"
  extends Buildings.ChillerWSE.BaseClasses.PartialParallelPlant(
    redeclare each final Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val1[n](
      each final R=R,
      each final delta0=delta0,
      redeclare each final replaceable package Medium = Medium1,
      each final m_flow_nominal=m1_flow_nominal,
      each final dpValve_nominal=dpValve1_nominal,
      each final dpFixed_nominal=dp1_nominal,
      each final l=l1,
      each final kFixed=kFixed1,
      each final allowFlowReversal=allowFlowReversal1,
      each final show_T=show_T,
      each final from_dp=from_dp,
      each final homotopyInitialization=homotopyInitialization,
      each final linearized=linearized,
      each final deltaM=deltaM,
      each final rhoStd=rhoStd,
      each final use_inputFilter=use_inputFilter,
      each final riseTime=riseTimeValve,
      each final init=initValve,
      each final y_start=yValve1_start),
    redeclare each final Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val2[n](
      each final R=R,
      each final delta0=delta0,
      redeclare each final replaceable package Medium = Medium2,
      each final m_flow_nominal=m2_flow_nominal,
      each final dpValve_nominal=dpValve2_nominal,
      each final dpFixed_nominal=dp2_nominal,
      each final l=l2,
      each final kFixed=kFixed2,
      each final allowFlowReversal=allowFlowReversal2,
      each final show_T=show_T,
      each final from_dp=from_dp,
      each final homotopyInitialization=homotopyInitialization,
      each final linearized=linearized,
      each final deltaM=deltaM,
      each final rhoStd=rhoStd,
      each final use_inputFilter=use_inputFilter,
      each final riseTime=riseTimeValve,
      each final init=initValve,
      each final y_start=yValve2_start));

  parameter Real R=50 "Rangeability, R=50...100 typically"
    annotation(Dialog(group="Valve"));
  parameter Real delta0=0.01
    "Range of significant deviation from equal percentage law"
    annotation(Dialog(group="Valve"));

  Buildings.ChillerWSE.HeatExchanger_T heaExc[n](
    redeclare each final replaceable package Medium1 = Medium1,
    redeclare each final replaceable package Medium2 = Medium2,
    each final m1_flow_nominal=m1_flow_nominal,
    each final m2_flow_nominal=m2_flow_nominal,
    each final dp1_nominal=dp1_nominal,
    each final dp2_nominal=dp2_nominal,
    each final controllerType=Modelica.Blocks.Types.SimpleController.PI)
    "Water-to-water heat exchanger"
    annotation (Placement(transformation(extent={{-10,-10},{10,6}})));
equation
  connect(val2.port_a, heaExc.port_b2)
    annotation (Line(points={{-40,-22},{-40,-8},{-10,-8}}, color={0,127,255}));
  for i in 1:n loop
  connect(port_a1, heaExc[i].port_a1) annotation (Line(points={{-100,60},{-40,60},
          {-40,4},{-10,4}}, color={0,127,255}));
  connect(heaExc[i].port_a2, port_a2) annotation (Line(points={{10,-8},{40,-8},{
          40,-60},{100,-60}}, color={0,127,255}));
  connect(TSet, heaExc[i].TSet) annotation (Line(points={{-120,-40},{-80,-40},{-80,
          0},{-12,0}}, color={0,0,127}));
  end for;
  connect(booToRea.y, val1.y) annotation (Line(points={{-59,40},{-26,40},{20,40},
          {20,32},{28,32}}, color={0,0,127}));
  connect(heaExc.port_b1, val1.port_a)
    annotation (Line(points={{10,4},{40,4},{40,22}}, color={0,127,255}));

end WatersideEconomizerParallel;
