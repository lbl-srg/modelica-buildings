within Buildings.ChillerWSE.BaseClasses;
partial model PartialChillerWSE
  "Partial model that contains chillers and WSE without connected configurations"
  extends Buildings.ChillerWSE.BaseClasses.PartialChillerWSEInterface(
    final n=nChi+1);
  extends Buildings.ChillerWSE.BaseClasses.FourPortResistanceChillerWSE(
     final computeFlowResistance1=true,
     final computeFlowResistance2=true);

  parameter Integer nChi(min=1) "Number of identical chillers";
  parameter Modelica.SIunits.PressureDifference dpValveChiller1_nominal(
    min=0,
    displayUnit="Pa",
    fixed= if CvData==Buildings.Fluid.Types.CvTypes.OpPoint then true else false)=6000
    "Pressure difference for the chiller valve on Medium 1 side"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpValveChiller2_nominal(
    min=0,
    displayUnit="Pa",
    fixed= if CvData==Buildings.Fluid.Types.CvTypes.OpPoint then true else false)=6000
    "Pressure difference for the chiller valve on Medium 2 side"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpValveWSE1_nominal(
    min=0,
    displayUnit="Pa",
    fixed= if CvData==Buildings.Fluid.Types.CvTypes.OpPoint then true else false)=6000
    "Pressure difference for the WSE valve on Medium 1 side"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpValveWSE2_nominal(
    min=0,
    displayUnit="Pa",
    fixed= if CvData==Buildings.Fluid.Types.CvTypes.OpPoint then true else false)=6000
    "Pressure difference for the WSE valve on Medium 2 side"
    annotation(Dialog(group = "Nominal condition"));

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
    {mWSE1_flow_nominal,mWSE2_flow_nominal} ./ sqrt({dpWSE1_nominal,dpWSE2_nominal})
    "Flow coefficient of fixed resistance that may be in series with valves 
    in WSE, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)."
    annotation(Dialog(group="Valve"));
  parameter Real deltaM = 0.02
    "Fraction of nominal flow rate where linearization starts, if y=1"
    annotation(Dialog(group="Valve"));
  parameter Real R=50 "Rangeability, R=50...100 typically"
  annotation(Dialog(group="Valve"));
  parameter Real delta0=0.01
    "Range of significant deviation from equal percentage law"
    annotation(Dialog(group="Valve"));

  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Advanced",group="Valve"));
  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced",group="Valve"));
  parameter Modelica.SIunits.Density rhoStd=Medium1.density_pTX(101325, 273.15+4, Medium1.X_default)
    "Inlet density for which valve coefficients are defined"
  annotation(Dialog(group="Valve", tab="Advanced"));
  parameter Boolean use_inputFilter=true
    "= true, if opening is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Valve"));
  parameter Modelica.SIunits.Time riseTimeValve=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation(Dialog(tab="Dynamics", group="Valve",enable=use_inputFilterValve));
  parameter Modelica.Blocks.Types.Init initValve=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Valve",enable=use_inputFilterValve));
  parameter Real yValveChiller1_start=1 "Initial value of output from valve 1 in chillers"
    annotation(Dialog(tab="Dynamics", group="Valve",enable=use_inputFilterValve));
  parameter Real yValveChiller2_start=1 "Initial value of output from valve 2 in chillers"
    annotation(Dialog(tab="Dynamics", group="Valve",enable=use_inputFilterValve));
  parameter Real yValveWSE1_start=1 "Initial value of output from valve 1 in WSE"
    annotation(Dialog(tab="Dynamics", group="Valve",enable=use_inputFilterValve));
  parameter Real yValveWSE2_start=1 "Initial value of output from valve 2 in WSE"
    annotation(Dialog(tab="Dynamics", group="Valve",enable=use_inputFilterValve));

    // Dynamics
 parameter Modelica.SIunits.Time tau1 = 30 "Time constant at nominal flow in chillers"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));
  parameter Modelica.SIunits.Time tau2 = 30 "Time constant at nominal flow in chillers"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));

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
    n=nChi,
    per=per,
    final dpValve1_nominal=dpValveChiller1_nominal,
    final dpValve2_nominal=dpValveChiller2_nominal,
    final homotopyInitialization=homotopyInitialization,
    final from_dp=from_dp,
    final linearized=linearized,
    final rhoStd=rhoStd,
    final use_inputFilter=use_inputFilter,
    final riseTimeValve=riseTimeValve,
    final initValve=initValve,
    final yValve1_start=yValveWSE1_start,
    final yValve2_start=yValveWSE2_start,
    final m1_flow_nominal=mChiller1_flow_nominal,
    final m2_flow_nominal=mChiller2_flow_nominal,
    final dp1_nominal=dpChiller1_nominal,
    final dp2_nominal=dpChiller2_nominal,
    l1=lValveChiller1,
    kFixed1=kFixedChiller1,
    l2=lValveChiller2,
    kFixed2=kFixedChiller2,
    deltaM=deltaM,
    tau1=tau1,
    tau2=tau2,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    p1_start=p1_start,
    T1_start=T1_start,
    X1_start=X1_start,
    C1_start=C1_start,
    C1_nominal=C1_nominal,
    p2_start=p2_start,
    T2_start=T2_start,
    X2_start=X2_start,
    C2_start=C2_start,
    C2_nominal=C2_nominal,
    R=R,
    delta0=delta0)
     "Identical chillers"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  WatersideEconomizer wse "Waterside economizer"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  for i in 1:nChi loop
  connect(chiPar.on[i], on[i]) annotation (Line(points={{-42,4},{-92,4},{-92,40},
            {-120,40}},
                color={255,0,255}));
  connect(on[nChi+1], wse.on) annotation (Line(points={{-120,40},{-58,40},{-58,
            50},{6,50},{6,4},{18,4}},
        color={255,0,255}));
  end for;
  connect(chiPar.TSet, TSet) annotation (Line(points={{-42,0},{-120,0}},
                       color={0,0,127}));
  connect(port_a1, chiPar.port_a1) annotation (Line(points={{-100,60},{-80,60},
          {-80,48},{-60,48},{-60,6},{-40,6}}, color={0,127,255}));
  connect(chiPar.port_b1, port_b1) annotation (Line(points={{-20,6},{-10,6},{
          -10,60},{100,60}}, color={0,127,255}));
  connect(wse.port_b1, port_b1) annotation (Line(points={{40,6},{60,6},{60,60},{
          100,60}}, color={0,127,255}));
  connect(port_a1, wse.port_a1) annotation (Line(points={{-100,60},{-80,60},{-80,
          48},{10,48},{10,6},{20,6}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialChillerWSE;
