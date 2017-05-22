within Buildings.ChillerWSE;
model ElectricChilerParallel "Ensembled multiple electric chillers via vector"
  extends Buildings.ChillerWSE.BaseClasses.PartialParallelElectricEIR(
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
      each final y_start=yValve2_start),
    redeclare each final Buildings.Fluid.Chillers.ElectricEIR chi[n](
      redeclare each final replaceable package Medium1 = Medium1,
      redeclare each final replaceable package Medium2 = Medium2,
      per=per));

  parameter Real R=50 "Rangeability, R=50...100 typically"
  annotation(Dialog(group="Valve"));
  parameter Real delta0=0.01
    "Range of significant deviation from equal percentage law"
    annotation(Dialog(group="Valve"));
  replaceable parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic per[n]
    "Performance data"
    annotation (choicesAllMatching = true,
                Placement(transformation(extent={{42,74},{62,94}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255})}),
         Diagram(coordinateSystem(preserveAspectRatio=false)));
end ElectricChilerParallel;
