within Buildings.ChillerWSE.BaseClasses;
partial model PartialChillerWSE
  "Partial model that contains chillers and WSE without connected configurations"
  extends Buildings.ChillerWSE.BaseClasses.PartialChillerWSEInterface(
     final n=nChi+1);
  extends Buildings.ChillerWSE.BaseClasses.FourPortResistanceChillerWSE(
     final computeFlowResistance1=true,
     final computeFlowResistance2=true);
  extends Buildings.ChillerWSE.BaseClasses.PartialControllerInterface(
     final reverseAction=true);
  extends Buildings.ChillerWSE.BaseClasses.ValvesParameters(
     nVal=4,
     final deltaM=deltaM1);
  extends Buildings.ChillerWSE.BaseClasses.PartialSignalFilter(
     final nFilter=1,
     final yValve_start={yValveWSE_start});
  parameter Integer nChi(min=1) "Number of identical chillers";

  // Advanced
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
 // valve parameters
  parameter Real[2] lValveChiller(each min=1e-10, each max=1) = {0.0001,0.0001}
    "Valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Valve"));
  parameter Real[2] kFixedChiller(each unit="",each min=0)=
    {mChiller1_flow_nominal,mChiller2_flow_nominal} ./ sqrt({dpChiller1_nominal,dpChiller2_nominal})
    "Flow coefficient of fixed resistance that may be in series with valves
    in chillers, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)."
    annotation(Dialog(group="Valve"));
  parameter Real[2] lValveWSE(each min=1e-10, each max=1) = {0.0001,0.0001}
    "Valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Valve"));
  parameter Real[2] kFixedWSE(each unit="", each min=0)=
    {mWSE1_flow_nominal/ sqrt(dpWSE1_nominal),0}
    "Flow coefficient of fixed resistance that may be in series with valves 
    in WSE, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)."
    annotation(Dialog(group="Valve"));
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
  parameter Real[nChi] yValveChiller_start=fill(0,nChi) "Initial value of output from valve 1 in chillers"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilterValve));
  parameter Real yValveWSE_start=0 "Initial value of output from valve 1 in WSE"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilterValve));
  parameter Real yBypValWSE_start=0 "Initial value of output from bypass valve in WSE"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilterValve));
    // Dynamics
 parameter Modelica.SIunits.Time tauChiller1 = 30 "Time constant at nominal flow in chillers"
     annotation (Dialog(tab = "Dynamics", group="Chiller"));
 parameter Modelica.SIunits.Time tauChiller2 = 30 "Time constant at nominal flow in chillers"
     annotation (Dialog(tab = "Dynamics", group="Chiller"));
 parameter Modelica.SIunits.Time tauWSE=10
    "Time constant at nominal flow for dynamic energy and momentum balance of the three-way valve"
    annotation(Dialog(tab="Dynamics", group="WSE",
               enable=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  // Initialization
  parameter Medium1.AbsolutePressure p1_start = Medium1.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization", group = "Medium 1"));
  parameter Medium1.Temperature T1_start = Medium1.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", group = "Medium 1"));
  parameter Medium1.MassFraction X1_start[Medium1.nX] = Medium1.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group = "Medium 1", enable=Medium1.nXi > 0));
  parameter Medium1.ExtraProperty C1_start[Medium1.nC](
    final quantity=Medium1.extraPropertiesNames)=fill(0, Medium1.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", group = "Medium 1", enable=Medium1.nC > 0));
  parameter Medium1.ExtraProperty C1_nominal[Medium1.nC](
    final quantity=Medium1.extraPropertiesNames) = fill(1E-2, Medium1.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", group = "Medium 1", enable=Medium1.nC > 0));

  parameter Medium2.AbsolutePressure p2_start = Medium2.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization", group = "Medium 2"));
  parameter Medium2.Temperature T2_start = Medium2.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", group = "Medium 2"));
  parameter Medium2.MassFraction X2_start[Medium2.nX] = Medium2.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group = "Medium 2", enable=Medium2.nXi > 0));
  parameter Medium2.ExtraProperty C2_start[Medium2.nC](
    final quantity=Medium2.extraPropertiesNames)=fill(0, Medium2.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", group = "Medium 2", enable=Medium2.nC > 0));
  parameter Medium2.ExtraProperty C2_nominal[Medium2.nC](
    final quantity=Medium2.extraPropertiesNames) = fill(1E-2, Medium2.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", group = "Medium 2", enable=Medium2.nC > 0));

  replaceable parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic per[nChi]
    "Performance data"
    annotation (choicesAllMatching = true,
                Placement(transformation(extent={{42,74},{62,94}})));

  Buildings.ChillerWSE.ElectricChilerParallel chiPar(
    redeclare final replaceable package Medium1 = Medium1,
    redeclare final replaceable package Medium2 = Medium2,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
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
    final n=nChi,
    final per=per,
    final homotopyInitialization=homotopyInitialization,
    final use_inputFilter=use_inputFilter,
    final riseTimeValve=riseTimeValve,
    final initValve=initValve,
    final m1_flow_nominal=mChiller1_flow_nominal,
    final m2_flow_nominal=mChiller2_flow_nominal,
    final dp1_nominal=dpChiller1_nominal,
    final tau1=tauChiller1,
    final tau2=tauChiller2,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p1_start=p1_start,
    final T1_start=T1_start,
    final X1_start=X1_start,
    final C1_start=C1_start,
    final C1_nominal=C1_nominal,
    final p2_start=p2_start,
    final T2_start=T2_start,
    final X2_start=X2_start,
    final C2_start=C2_start,
    final C2_nominal=C2_nominal,
    final l=lValveChiller,
    final kFixed=kFixedChiller,
    final dp2_nominal=dpChiller2_nominal,
    each final dpValve_nominal=dpValve_nominal[1:2],
    final rhoStd=rhoStd[1:2],
    final yValve_start=yValveChiller_start)
     "Identical chillers"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.ChillerWSE.WatersideEconomizer wse(
    final replaceable package Medium1 = Medium1,
    final replaceable package Medium2 = Medium2,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final m1_flow_nominal=mWSE1_flow_nominal,
    final m2_flow_nominal=mWSE2_flow_nominal,
    final m1_flow_small=m1_flow_small,
    final m2_flow_small=m2_flow_small,
    final show_T=homotopyInitialization,
    final from_dp1=from_dp1,
    final dp1_nominal=dpWSE1_nominal,
    final linearizeFlowResistance1=linearizeFlowResistance1,
    final deltaM1=deltaM1,
    final from_dp2=from_dp2,
    final dp2_nominal=dpWSE2_nominal,
    final linearizeFlowResistance2=linearizeFlowResistance2,
    final deltaM2=deltaM2,
    final homotopyInitialization=homotopyInitialization,
    each final l=lValveWSE,
    each final kFixed=kFixedWSE,
    final use_inputFilter=use_inputFilter,
    final riseTimeValve=riseTimeValve,
    final initValve=initValve,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p2_start,
    final T_start=T2_start,
    each final X_start=X2_start,
    each final C_start=C2_start,
    each final C_nominal=C2_nominal,
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
    final eta=eta,
    final fraK_BypVal=fraK_BypVal,
    final l_BypVal=l_BypVal,
    final R=R,
    final delta0=delta0,
    final dpValve_nominal=dpValve_nominal[3:4],
    final rhoStd=rhoStd[3:4],
    final yBypVal_start=yBypValWSE_start,
    final yValWSE_start=yValveWSE_start,
    final tau_BypVal=tauWSE)
    "Waterside economizer"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
equation
  for i in 1:nChi loop
  connect(chiPar.on[i], on[i]) annotation (Line(points={{-62,34},{-92,34},{-92,40},
            {-120,40}},
                color={255,0,255}));
  end for;
  connect(on[nChi+1], wse.on[1]) annotation (Line(points={{-120,40},{-92,40},{-92,
          56},{20,56},{20,34},{38,34}},
        color={255,0,255}));
  connect(chiPar.TSet, TSet) annotation (Line(points={{-62,30},{-92,30},{-92,0},
          {-120,0}},   color={0,0,127}));
  connect(port_a1, chiPar.port_a1) annotation (Line(points={{-100,60},{-80,60},{
          -72,60},{-72,36},{-60,36}},         color={0,127,255}));
  connect(chiPar.port_b1, port_b1) annotation (Line(points={{-40,36},{-20,36},{-20,
          60},{100,60}},     color={0,127,255}));
  connect(wse.port_b1, port_b1) annotation (Line(points={{60,36},{80,36},{80,60},
          {100,60}},color={0,127,255}));
  connect(port_a1, wse.port_a1) annotation (Line(points={{-100,60},{-80,60},{-80,
          66},{0,66},{0,36},{40,36}}, color={0,127,255}));
  connect(TSet, wse.TSet) annotation (Line(points={{-120,0},{-94,0},{-92,0},{-92,
          56},{20,56},{20,30},{38,30}},
                                    color={0,0,127}));
  connect(y_reset_in, wse.y_reset_in) annotation (Line(points={{-90,-100},{-90,-100},
          {-90,10},{40,10},{40,20}},                   color={0,0,127}));
  connect(trigger, wse.trigger) annotation (Line(points={{-60,-100},{-60,-100},{
          -60,-80},{-90,-80},{-90,10},{44,10},{44,20}},
                                       color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255})}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialChillerWSE;
