within Buildings.Fluid.Chillers.BaseClasses;
model SixPortHeatMassExchanger
  "Model transporting four fluid streams between six ports with storing mass or energy"

  replaceable package Medium1 =
    Modelica.Media.Interfaces.PartialMedium "Medium 1 in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));
  replaceable package Medium2 =
    Modelica.Media.Interfaces.PartialMedium "Medium 2 in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));
  replaceable package Medium3 =
    Modelica.Media.Interfaces.PartialMedium "Medium 3 in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal(min=0)
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal(min=0)
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m3_flow_nominal(min=0)
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));

  parameter Boolean allowFlowReversal1 = true
    "= true to allow flow reversal in medium 1, false restricts to design direction (port_a -> port_b)"
  annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversal2 = true
    "= true to allow flow reversal in medium 2, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversal3 = true
    "= true to allow flow reversal in medium 3, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Medium1.MassFlowRate m1_flow_small(min=0) = 1E-4*abs(m1_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  parameter Medium2.MassFlowRate m2_flow_small(min=0) = 1E-4*abs(m2_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  parameter Medium3.MassFlowRate m3_flow_small(min=0) = 1E-4*abs(m3_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));

  // Diagnostics
  parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));
protected
  parameter Boolean computeFlowResistance1 = true
    "=true, compute flow resistance. Set to false to assume no friction"
    annotation (Evaluate=true, Dialog(tab="Flow resistance", group="Medium 1"));

  parameter Boolean from_dp1 = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable = computeFlowResistance1,
                tab="Flow resistance", group="Medium 1"));
  parameter Modelica.SIunits.Pressure dp1_nominal(min=0, displayUnit="Pa")
    "Pressure" annotation(Dialog(group = "Nominal condition"));
  parameter Boolean linearizeFlowResistance1 = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable = computeFlowResistance1,
               tab="Flow resistance", group="Medium 1"));
  parameter Real deltaM1 = 0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation(Dialog(enable = computeFlowResistance1,
                      tab="Flow resistance", group="Medium 1"));
  parameter Boolean computeFlowResistance2 = true
    "=true, compute flow resistance. Set to false to assume no friction"
    annotation (Evaluate=true, Dialog(tab="Flow resistance", group="Medium 2"));
  parameter Boolean from_dp2 = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable = computeFlowResistance2,
                tab="Flow resistance", group="Medium 2"));
  parameter Modelica.SIunits.Pressure dp2_nominal(min=0, displayUnit="Pa")
    "Pressure" annotation(Dialog(group = "Nominal condition"));
  parameter Boolean linearizeFlowResistance2 = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable = computeFlowResistance2,
               tab="Flow resistance", group="Medium 2"));
  parameter Real deltaM2 = 0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation(Dialog(enable = computeFlowResistance2,
                      tab="Flow resistance", group="Medium 2"));
  parameter Boolean computeFlowResistance3 = true
    "=true, compute flow resistance. Set to false to assume no friction"
    annotation (Evaluate=true, Dialog(tab="Flow resistance", group="Medium 3"));

  parameter Boolean from_dp3 = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable = computeFlowResistance3,
                tab="Flow resistance", group="Medium 3"));
  parameter Modelica.SIunits.Pressure dp3_nominal(min=0, displayUnit="Pa")
    "Pressure" annotation(Dialog(group = "Nominal condition"));
  parameter Boolean linearizeFlowResistance3 = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable = computeFlowResistance3,
               tab="Flow resistance", group="Medium 3"));
  parameter Real deltaM3 = 0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation(Dialog(enable = computeFlowResistance3,
                      tab="Flow resistance", group="Medium 3"));
public
  parameter Modelica.SIunits.Time tau1 = 30 "Time constant at nominal flow"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));
  parameter Modelica.SIunits.Time tau2 = 30 "Time constant at nominal flow"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));
  parameter Modelica.SIunits.Time tau3 = 30 "Time constant at nominal flow"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));
  // Advanced
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

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
       quantity=Medium1.extraPropertiesNames)=fill(0, Medium1.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", group = "Medium 1", enable=Medium1.nC > 0));
  parameter Medium1.ExtraProperty C1_nominal[Medium1.nC](
       quantity=Medium1.extraPropertiesNames) = fill(1E-2, Medium1.nC)
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
       quantity=Medium2.extraPropertiesNames)=fill(0, Medium2.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", group = "Medium 2", enable=Medium2.nC > 0));
  parameter Medium2.ExtraProperty C2_nominal[Medium2.nC](
       quantity=Medium2.extraPropertiesNames) = fill(1E-2, Medium2.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", group = "Medium 2", enable=Medium2.nC > 0));

  parameter Medium3.AbsolutePressure p3_start = Medium3.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization", group = "Medium 3"));
  parameter Medium3.Temperature T3_start = Medium3.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", group = "Medium 3"));
  parameter Medium3.MassFraction X3_start[Medium3.nX] = Medium3.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group = "Medium 3", enable=Medium3.nXi > 0));
  parameter Medium3.ExtraProperty C3_start[Medium3.nC](
       quantity=Medium3.extraPropertiesNames)=fill(0, Medium3.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", group = "Medium 3", enable=Medium3.nC > 0));
  parameter Medium3.ExtraProperty C3_nominal[Medium3.nC](
       quantity=Medium3.extraPropertiesNames) = fill(1E-2, Medium3.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", group = "Medium 3", enable=Medium3.nC > 0));
  Modelica.Fluid.Interfaces.FluidPort_a conEnt(
    redeclare final package Medium = Medium1,
    m_flow(min=if allowFlowReversal1 then -Modelica.Constants.inf else 0),
    h_outflow(start=h_outflow_a1_start)) "Condenser entering fluid port."
    annotation (Placement(transformation(extent={{-110,70},{-90,90}}),
        iconTransformation(extent={{-110,70},{-90,90}})));
  Modelica.Fluid.Interfaces.FluidPort_b conLvg(
    redeclare final package Medium = Medium1,
    m_flow(max=if allowFlowReversal1 then +Modelica.Constants.inf else 0),
    h_outflow(start=h_outflow_b1_start)) "Condenser leaving fluid port."
    annotation (Placement(transformation(extent={{110,70},{90,90}}),
        iconTransformation(extent={{110,70},{90,90}})));
  Modelica.Fluid.Interfaces.FluidPort_a genEnt(
    redeclare final package Medium = Medium3,
    m_flow(min=if allowFlowReversal2 then -Modelica.Constants.inf else 0),
    h_outflow(start=h_outflow_a3_start)) "Generator entering fluid port."
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-111,-11},{-91,9}})));
  Modelica.Fluid.Interfaces.FluidPort_b genLvg(
    redeclare final package Medium = Medium2,
    m_flow(max=if allowFlowReversal2 then +Modelica.Constants.inf else 0),
    h_outflow(start=h_outflow_b2_start)) "Generator leaving fluid port."
    annotation (Placement(transformation(extent={{110,-10},{90,10}}),
        iconTransformation(extent={{110,-11},{90,9}})));

  Modelica.Fluid.Interfaces.FluidPort_a evaEnt(
    redeclare final package Medium = Medium2,
    m_flow(min=if allowFlowReversal2 then -Modelica.Constants.inf else 0),
    h_outflow(start=h_outflow_a2_start)) "Evaporator entering fluid port."
    annotation (Placement(transformation(extent={{90,-90},{110,-70}}),
        iconTransformation(extent={{90,-91},{110,-71}})));
  Modelica.Fluid.Interfaces.FluidPort_b evaLvg(
    redeclare final package Medium = Medium2,
    m_flow(max=if allowFlowReversal2 then +Modelica.Constants.inf else 0),
    h_outflow(start=h_outflow_b2_start)) "Evaporator leaving fluid port."
    annotation (Placement(transformation(extent={{-90,-90},{-110,-70}}),
        iconTransformation(extent={{-90,-90},{-110,-70}})));

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Formulation of energy balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Formulation of mass balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  Medium1.MassFlowRate m1_flow=conEnt.m_flow
    "Mass flow rate from port_a1 to port_b1 (m1_flow > 0 is design flow direction)";
  Modelica.SIunits.Pressure dp1(displayUnit="Pa")
    "Pressure difference between port_a1 and port_b1";
  Medium2.MassFlowRate m3_flow=genEnt.m_flow
    "Mass flow rate from port_a2 to port_b2 (m2_flow > 0 is design flow direction)";
  Modelica.SIunits.Pressure dp3(displayUnit="Pa")
    "Pressure difference between port_a2 and port_b2";
  Medium3.MassFlowRate m2_flow=evaEnt.m_flow
    "Mass flow rate from port_a3 to port_b3 (m3_flow > 0 is design flow direction)";
  Modelica.SIunits.Pressure dp2(displayUnit="Pa")
    "Pressure difference between port_a3 and port_b3";

  Medium1.ThermodynamicState sta_a1=Medium1.setState_phX(
      conEnt.p,
      noEvent(actualStream(conEnt.h_outflow)),
      noEvent(actualStream(conEnt.Xi_outflow))) if show_T
    "Medium properties in port_a1";
  Medium1.ThermodynamicState sta_b1=Medium1.setState_phX(
      conLvg.p,
      noEvent(actualStream(conLvg.h_outflow)),
      noEvent(actualStream(conLvg.Xi_outflow))) if show_T
    "Medium properties in port_b1";
  Medium2.ThermodynamicState sta_a2=Medium2.setState_phX(
      evaEnt.p,
      noEvent(actualStream(evaEnt.h_outflow)),
      noEvent(actualStream(evaEnt.Xi_outflow))) if show_T
    "Medium properties in port_a2";
  Medium2.ThermodynamicState sta_b2=Medium2.setState_phX(
      evaLvg.p,
      noEvent(actualStream(evaLvg.h_outflow)),
      noEvent(actualStream(evaLvg.Xi_outflow))) if show_T
    "Medium properties in port_b2";
  Medium3.ThermodynamicState sta_a3=Medium3.setState_phX(
      genEnt.p,
      noEvent(actualStream(genEnt.h_outflow)),
      noEvent(actualStream(genEnt.Xi_outflow))) if show_T
    "Medium properties in port_a3";
  Medium3.ThermodynamicState sta_b3=Medium3.setState_phX(
      genLvg.p,
      noEvent(actualStream(genLvg.h_outflow)),
      noEvent(actualStream(genLvg.Xi_outflow))) if show_T
    "Medium properties in port_b3";

 replaceable Buildings.Fluid.MixingVolumes.MixingVolume conVol constrainedby
    Buildings.Fluid.MixingVolumes.BaseClasses.MixingVolumeHeatPort(
    redeclare final package Medium = Medium1,
    V=m1_flow_nominal*tau1/rho1_nominal,
    final m_flow_nominal=m1_flow_nominal,
    energyDynamics=if tau1 > Modelica.Constants.eps then energyDynamics else
        Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=if tau1 > Modelica.Constants.eps then massDynamics else
        Modelica.Fluid.Types.Dynamics.SteadyState,
    final p_start=p1_start,
    final T_start=T1_start,
    final X_start=X1_start,
    final C_start=C1_start,
    final C_nominal=C1_nominal,
    nPorts=2) "Condenser volume for fluid 1."
    annotation (Placement(transformation(extent={{-10,80},{10,60}})));
 replaceable Buildings.Fluid.MixingVolumes.MixingVolume evaVol constrainedby
    Buildings.Fluid.MixingVolumes.BaseClasses.MixingVolumeHeatPort(
    redeclare final package Medium = Medium2,
    V=m2_flow_nominal*tau2/rho2_nominal,
    final m_flow_nominal=m2_flow_nominal,
    energyDynamics=if tau2 > Modelica.Constants.eps then energyDynamics else
        Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=if tau2 > Modelica.Constants.eps then massDynamics else
        Modelica.Fluid.Types.Dynamics.SteadyState,
    final p_start=p2_start,
    final T_start=T2_start,
    final X_start=X2_start,
    final C_start=C2_start,
    final C_nominal=C2_nominal,
    nPorts=2) "Evaporator volume for fluid 2."
    annotation (Placement(
        transformation(
        origin={0,-60},
        extent={{10,10},{-10,-10}},
        rotation=180)));
    replaceable Buildings.Fluid.MixingVolumes.MixingVolume genVol constrainedby
    Buildings.Fluid.MixingVolumes.BaseClasses.MixingVolumeHeatPort(
    redeclare final package Medium = Medium3,
    V=m3_flow_nominal*tau3/rho3_nominal,
    final m_flow_nominal=m3_flow_nominal,
    energyDynamics=if tau3 > Modelica.Constants.eps then energyDynamics else
        Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=if tau3 > Modelica.Constants.eps then massDynamics else
        Modelica.Fluid.Types.Dynamics.SteadyState,
    final p_start=p3_start,
    final T_start=T3_start,
    final X_start=X3_start,
    final C_start=C3_start,
    final C_nominal=C3_nominal,
    nPorts=2) "Generator volume for fluid 3."
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  Buildings.Fluid.FixedResistances.PressureDrop preDroCon(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final deltaM=deltaM1,
    final allowFlowReversal=allowFlowReversal1,
    final show_T=false,
    final from_dp=from_dp1,
    final linearized=linearizeFlowResistance1,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=dp1_nominal) "Pressure drop model for fluid 1."
    annotation (Placement(transformation(extent={{-64,82},{-44,102}})));

  Buildings.Fluid.FixedResistances.PressureDrop preDroEva(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final deltaM=deltaM2,
    final allowFlowReversal=allowFlowReversal2,
    final show_T=false,
    final from_dp=from_dp2,
    final linearized=linearizeFlowResistance2,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=dp2_nominal) "Pressure drop model for fluid 2."
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroGen(
    redeclare final package Medium = Medium3,
    final m_flow_nominal=m3_flow_nominal,
    final deltaM=deltaM3,
    final allowFlowReversal=allowFlowReversal3,
    final show_T=false,
    final from_dp=from_dp3,
    final linearized=linearizeFlowResistance3,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=dp3_nominal) "Pressure drop model for fluid 3."
    annotation (Placement(transformation(extent={{68,-10},{48,10}})));

  Modelica.SIunits.HeatFlowRate Q1_flow=conVol.heatPort.Q_flow
    "Heat flow rate into medium 1";
  Modelica.SIunits.HeatFlowRate Q2_flow=evaVol.heatPort.Q_flow
    "Heat flow rate into medium 2";
  Modelica.SIunits.HeatFlowRate Q3_flow=genVol.heatPort.Q_flow
    "Heat flow rate into medium 3";

protected
  parameter Medium1.ThermodynamicState sta1_nominal=Medium1.setState_pTX(
      T=Medium1.T_default, p=Medium1.p_default, X=Medium1.X_default);
  parameter Modelica.SIunits.Density rho1_nominal=Medium1.density(sta1_nominal)
    "Density, used to compute fluid volume";
  parameter Medium2.ThermodynamicState sta2_nominal=Medium2.setState_pTX(
      T=Medium2.T_default, p=Medium2.p_default, X=Medium2.X_default);
  parameter Modelica.SIunits.Density rho2_nominal=Medium2.density(sta2_nominal)
    "Density, used to compute fluid volume";
  parameter Medium1.ThermodynamicState sta3_nominal=Medium3.setState_pTX(
      T=Medium3.T_default, p=Medium3.p_default, X=Medium3.X_default);
  parameter Modelica.SIunits.Density rho3_nominal=Medium3.density(sta3_nominal)
    "Density, used to compute fluid volume";
  parameter Medium1.ThermodynamicState sta1_start=Medium1.setState_pTX(
      T=T1_start, p=p1_start, X=X1_start);
  parameter Modelica.SIunits.SpecificEnthalpy h1_outflow_start = Medium1.specificEnthalpy(sta1_start)
    "Start value for outflowing enthalpy";
  parameter Medium2.ThermodynamicState sta2_start=Medium2.setState_pTX(
      T=T2_start, p=p2_start, X=X2_start);
  parameter Modelica.SIunits.SpecificEnthalpy h2_outflow_start = Medium2.specificEnthalpy(sta2_start)
    "Start value for outflowing enthalpy";
  parameter Medium3.ThermodynamicState sta3_start=Medium3.setState_pTX(
      T=T3_start, p=p3_start, X=X3_start);
  parameter Modelica.SIunits.SpecificEnthalpy h3_outflow_start = Medium3.specificEnthalpy(sta3_start)
    "Start value for outflowing enthalpy";

  parameter Modelica.SIunits.SpecificEnthalpy h_outflow_a1_start = Medium1.h_default
    "Start value for enthalpy flowing out of port a1"
    annotation (Dialog(tab="Advanced", group="Initialization"));

  parameter Modelica.SIunits.SpecificEnthalpy h_outflow_b1_start = Medium1.h_default
    "Start value for enthalpy flowing out of port b1"
    annotation (Dialog(tab="Advanced", group="Initialization"));

  parameter Modelica.SIunits.SpecificEnthalpy h_outflow_a2_start = Medium2.h_default
    "Start value for enthalpy flowing out of port a2"
    annotation (Dialog(tab="Advanced", group="Initialization"));

  parameter Modelica.SIunits.SpecificEnthalpy h_outflow_b2_start = Medium2.h_default
    "Start value for enthalpy flowing out of port b2"
    annotation (Dialog(tab="Advanced", group="Initialization"));

  parameter Modelica.SIunits.SpecificEnthalpy h_outflow_a3_start = Medium3.h_default
    "Start value for enthalpy flowing out of port a1"
    annotation (Dialog(tab="Advanced", group="Initialization"));

  parameter Modelica.SIunits.SpecificEnthalpy h_outflow_b3_start = Medium3.h_default
    "Start value for enthalpy flowing out of port b1"
    annotation (Dialog(tab="Advanced", group="Initialization"));

  Medium1.ThermodynamicState state_a1_inflow=Medium1.setState_phX(
      conEnt.p,
      inStream(conEnt.h_outflow),
      inStream(conEnt.Xi_outflow)) "state for medium inflowing through port_a1";
  Medium1.ThermodynamicState state_b1_inflow=Medium1.setState_phX(
      conLvg.p,
      inStream(conLvg.h_outflow),
      inStream(conLvg.Xi_outflow)) "state for medium inflowing through port_b1";
  Medium2.ThermodynamicState state_a2_inflow=Medium2.setState_phX(
      evaEnt.p,
      inStream(evaEnt.h_outflow),
      inStream(evaEnt.Xi_outflow)) "state for medium inflowing through port_a2";
  Medium2.ThermodynamicState state_b2_inflow=Medium2.setState_phX(
      evaLvg.p,
      inStream(evaLvg.h_outflow),
      inStream(evaLvg.Xi_outflow)) "state for medium inflowing through port_b2";
  Medium3.ThermodynamicState state_a3_inflow=Medium3.setState_phX(
      genEnt.p,
      inStream(genEnt.h_outflow),
      inStream(genEnt.Xi_outflow)) "state for medium inflowing through port_a3";
  Medium3.ThermodynamicState state_b3_inflow=Medium3.setState_phX(
      genLvg.p,
      inStream(genLvg.h_outflow),
      inStream(genLvg.Xi_outflow)) "state for medium inflowing through port_b3";

initial algorithm
  // Check for tau1
  assert((energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau1 > Modelica.Constants.eps,
"The parameter tau1, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau1 = " + String(tau1) + "\n");
  assert((massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau1 > Modelica.Constants.eps,
"The parameter tau1, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau1 = " + String(tau1) + "\n");

 // Check for tau2
  assert((energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau2 > Modelica.Constants.eps,
"The parameter tau2, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau2 = " + String(tau2) + "\n");
  assert((massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau2 > Modelica.Constants.eps,
"The parameter tau2, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau2 = " + String(tau2) + "\n");

  // Check for tau3
  assert((energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau3 > Modelica.Constants.eps,
"The parameter tau3, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau3 = " + String(tau3) + "\n");
  assert((massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau3 > Modelica.Constants.eps,
"The parameter tau3, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau3 = " + String(tau3) + "\n");

equation
  dp1 =conEnt.p - conLvg.p;
  dp2 =evaEnt.p - evaLvg.p;
  dp3 =genEnt.p - genLvg.p;
  connect(conEnt, preDroCon.port_a) annotation (Line(points={{-100,80},{-80,80},
          {-80,92},{-64,92}}, color={0,127,255}));
  connect(preDroCon.port_b, conVol.ports[1])
    annotation (Line(points={{-44,92},{0,92},{0,80}}, color={0,127,255}));
  connect(evaEnt, preDroEva.port_b)
    annotation (Line(points={{100,-80},{70,-80}}, color={0,127,255}));
  connect(evaVol.ports[1], preDroEva.port_a) annotation (Line(points={{-1.9984e-15,
          -70},{2,-70},{2,-80},{50,-80},{50,-80}}, color={0,127,255}));
  connect(evaVol.ports[2], evaLvg)
    annotation (Line(points={{-1.77636e-15,-70},{
          -2,-70},{-2,-80},{-100,-80}}, color={0,127,255}));
  connect(preDroGen.port_a, genLvg)
    annotation (Line(points={{68,0},{100,0}}, color={0,127,255}));
  connect(preDroGen.port_b, genVol.ports[1])
    annotation (Line(points={{48,0},{0,0}}, color={0,127,255}));
  connect(genEnt, genVol.ports[2])
    annotation (Line(points={{-100,0},{0,0}}, color={0,127,255}));
  connect(conVol.ports[2], conLvg)
    annotation (Line(points={{0,80},{2,80},{2,92},
          {82,92},{82,80},{100,80}}, color={0,127,255}));
  connect(conEnt, conEnt)
    annotation (Line(points={{-100,80},{-92,80},{-92,80},{
          -100,80}}, color={0,127,255}));
  annotation (
    Documentation(info="<html>
<p>
This component transports three fluid streams between six ports.
</p>
<p>The model can be used as-is, although there will be no heat or mass transfer between the three fluid streams. To add heat transfer,
heat flow can be added to the heat port of the three volumes.
</p>
</html>", revisions="<html>
<ul>
<li>January 4, 2020, by Hagar Elarga:<br/>
First implementation. 
</li>
</ul>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Rectangle(
          extent={{-71,90},{70,-90}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={212,212,212},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-99,85},{102,75}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-97,4},{104,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-99,-76},{102,-86}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})));
end SixPortHeatMassExchanger;
