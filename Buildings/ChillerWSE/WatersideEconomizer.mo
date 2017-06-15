within Buildings.ChillerWSE;
model WatersideEconomizer "Parallel heat exchangers"
  extends Buildings.ChillerWSE.BaseClasses.PartialPlantParallel(
    final n=1,
    final nVal=3,
    final m_flow_nominal={m1_flow_nominal,m2_flow_nominal,m2_flow_nominal},
    rhoStd = {Medium1.density_pTX(101325, 273.15+4, Medium1.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default)},
    final deltaM=deltaM2,
    val2(each final dpFixed_nominal=0),
    val1(each final dpFixed_nominal=dp1_nominal),
    final yValve_start={yValWSE_start});
  extends Buildings.ChillerWSE.BaseClasses.PartialControllerInterface(
    final reverseAction=true);
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations(
    final mSenFac=1,
    redeclare package Medium=Medium2);

  // Filter opening
  parameter Real yBypVal_start=1 "Initial value of output from the filter in the bypass valve"
    annotation(Dialog(tab="Dynamics",group="Filtered opening",enable=use_inputFilter));
  parameter Real yValWSE_start=1 "Initial value of output from the filter in the bypass valve"
    annotation(Dialog(tab="Dynamics",group="Filtered opening",enable=use_inputFilter));
 // Heat exchanger
  parameter Modelica.SIunits.Efficiency eta=0.8 "constant effectiveness";
 // Bypass valve parameters
  parameter Real fraK_BypVal(min=0, max=1) = 0.7
    "Fraction Kv(port_3&rarr;port_2)/Kv(port_1&rarr;port_2)for the bypass valve"
    annotation(Dialog(group="Bypass Valve"));
  parameter Real l_BypVal[2](min=1e-10, max=1) = {0.0001,0.0001}
    "Bypass valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Bypass Valve"));
  parameter Real R=50 "Rangeability, R=50...100 typically for bypass valve"
    annotation(Dialog(group="Bypass Valve"));
  parameter Real delta0=0.01
    "Range of significant deviation from equal percentage law for bypass valve"
    annotation(Dialog(group="Bypass Valve"));

  Buildings.ChillerWSE.HeatExchanger_T heaExc(
    redeclare final replaceable package Medium1 = Medium1,
    redeclare final replaceable package Medium2 = Medium2,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final dp1_nominal=dp1_nominal,
    final dp2_nominal=dp2_nominal,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin,
    final wp=wp,
    final wd=wd,
    final Ni=Ni,
    final Nd=Nd,
    final initType=initType,
    final xi_start=xi_start,
    final xd_start=xd_start,
    final y_startController=y_startController,
    final reset=reset,
    final y_reset=y_reset,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final m1_flow_small=m1_flow_small,
    final m2_flow_small=m2_flow_small,
    final show_T=show_T,
    final from_dp1=from_dp1,
    final linearizeFlowResistance1=linearizeFlowResistance1,
    final deltaM1=deltaM1,
    final from_dp2=from_dp2,
    final linearizeFlowResistance2=linearizeFlowResistance2,
    final deltaM2=deltaM2,
    final homotopyInitialization=homotopyInitialization,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    each final X_start=X_start,
    each final C_start=C_start,
    each final C_nominal=C_nominal,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTimeValve,
    final init=initValve,
    final yBypVal_start=yBypVal_start,
    final eta=eta,
    final fraK_BypVal=fraK_BypVal,
    each final l_BypVal=l_BypVal,
    final R=R,
    final delta0=delta0,
    final dpValve_nominal=dpValve_nominal[3],
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final rhoStd=rhoStd[3])
    "Water-to-water heat exchanger"
    annotation (Placement(transformation(extent={{-10,-12},{10,4}})));
equation
  connect(port_a1, heaExc.port_a1) annotation (Line(points={{-100,60},{-40,60},
            {-40,2},{-10,2}},
                            color={0,127,255}));
  connect(heaExc.port_a2, port_a2) annotation (Line(points={{10,-10},{40,-10},
            {40,-60},{100,-60}},
                              color={0,127,255}));
  connect(TSet, heaExc.TSet) annotation (Line(points={{-120,0},{-12,0}},
                       color={0,0,127}));

  connect(y_reset_in, heaExc.y_reset_in) annotation (Line(points={{-90,-100},{-90,
          -100},{-90,-80},{-10,-80},{-10,-14}},
                                   color={0,0,127}));
  connect(trigger, heaExc.trigger) annotation (Line(points={{-60,-100},{-60,-80},
          {-6,-80},{-6,-14}}, color={255,0,255}));
  connect(heaExc.port_b1, val1[1].port_a)
    annotation (Line(points={{10,2},{40,2},{40,22}}, color={0,127,255}));
  connect(val2[1].port_a, heaExc.port_b2) annotation (Line(points={{-40,-22},{-40,
          -22},{-40,-10},{-10,-10}}, color={0,127,255}));
end WatersideEconomizer;
