within Buildings.ChillerWSE;
model ChillerParallel "Ensembled multiple chillers via vector"
  extends Buildings.Fluid.Interfaces.PartialFourPort;
  extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
     final computeFlowResistance1=true,
     final computeFlowResistance2=true);

 replaceable parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic per[nChi]
    "Performance data"
    annotation (choicesAllMatching = true,
                Placement(transformation(extent={{42,74},{62,94}})));
  parameter Integer nChi(min=1)=2 "Number of identical chillers";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal=per[nChi].mEva_flow_nominal
    "Nominal mass flow at evaporator";
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal=per[nChi].mCon_flow_nominal
    "Nominal mass flow at condenser";
  parameter Modelica.SIunits.Time tau1 = 30 "Time constant at nominal flow"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));
  parameter Modelica.SIunits.Time tau2 = 30 "Time constant at nominal flow"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpValve1_nominal(min=0,displayUnit="Pa")
    "Pressure difference for the valve on Medium 1 side"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpValve2_nominal(min=0,displayUnit="Pa")
    "Pressure difference for the valve on Medium 2 side"
    annotation(Dialog(group = "Nominal condition"));
  // Diagnostics
  parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

  // Advanced
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  parameter Medium1.MassFlowRate m1_flow_small(min=0) = 1E-4*abs(m1_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  parameter Medium2.MassFlowRate m2_flow_small(min=0) = 1E-4*abs(m2_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));

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

  // valve parameters
  parameter Real l(min=1e-10, max=1) = 0.0001
    "Valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Valve"));
  parameter Real kFixed(unit="", min=0)= 0
    "Flow coefficient of fixed resistance that may be in series with valve, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)."
    annotation(Dialog(group="Valve"));

  parameter Real deltaM = 0.02
    "Fraction of nominal flow rate where linearization starts, if y=1"
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
  parameter Real yValve1_start=1 "Initial value of output from valve 1"
    annotation(Dialog(tab="Dynamics", group="Valve",enable=use_inputFilterValve));
  parameter Real yValve2_start=1 "Initial value of output from valve 2"
    annotation(Dialog(tab="Dynamics", group="Valve",enable=use_inputFilterValve));

  replaceable Buildings.Fluid.Chillers.ElectricEIR chi[nChi](
    redeclare each final replaceable package Medium1 = Medium1,
    redeclare each final replaceable package Medium2 = Medium2,
    each final allowFlowReversal1=allowFlowReversal1,
    each final allowFlowReversal2=allowFlowReversal2,
    each final from_dp1=from_dp1,
    each final linearizeFlowResistance1=linearizeFlowResistance1,
    each final deltaM1=deltaM1,
    each final from_dp2=from_dp2,
    each final linearizeFlowResistance2=linearizeFlowResistance2,
    each final deltaM2=deltaM2,
    each final m1_flow_small=m1_flow_small,
    each final m2_flow_small=m2_flow_small,
    each final homotopyInitialization=homotopyInitialization,
    each final tau1=tau1,
    each final tau2=tau2,
    each final energyDynamics=energyDynamics,
    each final massDynamics=massDynamics,
    each final p1_start=p1_start,
    each final T1_start=T1_start,
    each final X1_start=X1_start,
    each final C1_start=C1_start,
    each final C1_nominal=C1_nominal,
    each final p2_start=p2_start,
    each final T2_start=T2_start,
    each final X2_start=X2_start,
    each final C2_start=C2_start,
    each final C2_nominal=C2_nominal,
    each final show_T=show_T,
    each final m1_flow_nominal=m1_flow_nominal,
    each final m2_flow_nominal=m2_flow_nominal,
    each final dp1_nominal=0,
    each final dp2_nominal=0,
    per=per)
    constrainedby Buildings.Fluid.Chillers.BaseClasses.PartialElectric
    "Multiple identical chillers"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={0,0})));
  replaceable Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValveKv val2[nChi](
    redeclare each final package Medium = Medium2,
    each final allowFlowReversal=allowFlowReversal2,
    each final m_flow_nominal=m2_flow_nominal,
    each final dpFixed_nominal=dp2_nominal,
    each final show_T=show_T,
    each final dpValve_nominal=dpValve2_nominal,
    each final deltaM=deltaM,
    each final l=l,
    each final kFixed=kFixed,
    each CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each final from_dp=from_dp,
    each final homotopyInitialization=homotopyInitialization,
    each final linearized=linearized,
    each final rhoStd=rhoStd,
    each final riseTime=riseTimeValve,
    each final init=initValve,
    each final y_start=yValve2_start,
    each final use_inputFilter=use_inputFilter)
    constrainedby Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValveKv
    "Valves on medium 2 side" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-40,-30})));
  replaceable Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValveKv val1[nChi](
    redeclare each final package Medium = Medium1,
    each final allowFlowReversal=allowFlowReversal1,
    each final m_flow_nominal=m1_flow_nominal,
    each final dpFixed_nominal=dp1_nominal,
    each final show_T=show_T,
    each final dpValve_nominal=dpValve1_nominal,
    each final deltaM=deltaM,
    each final l=l,
    each final kFixed=kFixed,
    each CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each final from_dp=from_dp,
    each final homotopyInitialization=homotopyInitialization,
    each final linearized=linearized,
    each final rhoStd=rhoStd,
    each final use_inputFilter=use_inputFilter,
    each final riseTime=riseTimeValve,
    each final init=initValve,
    each final y_start=yValve1_start)
    "Valves on medium 1 side" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={40,30})));
  Modelica.Blocks.Interfaces.BooleanInput on[nChi]
    "Set to true to enable compressor, or false to disable compressor"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput TSet
    "Set point for leaving chilled water temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Math.BooleanToReal booToRea[nChi](
    each final realTrue=1,
    each final realFalse=0)
    "Boolean to real (if true then 1 else 0)"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

equation
  for i in 1:nChi loop
    connect(port_a1, chi[i].port_a1) annotation (Line(points={{-100,60},{-70,60},{
          -40,60},{-40,6},{-10,6}}, color={0,127,255}));
    connect(chi[i].port_b1, val1[i].port_a)
      annotation (Line(points={{10,6},{40,6},{40,20}}, color={0,127,255}));
    connect(val1[i].port_b, port_b1)
      annotation (Line(points={{40,40},{40,60},{100,60}}, color={0,127,255}));
    connect(chi[i].port_b2, val2[i].port_a) annotation (Line(points={{-10,-6},{-10,
            -6},{-40,-6},{-40,-20}}, color={0,127,255}));
    connect(val2[i].port_b, port_b2) annotation (Line(points={{-40,-40},{-40,-60},
            {-100,-60}}, color={0,127,255}));
    connect(chi[i].port_a2, port_a2) annotation (Line(points={{10,-6},{10,-6},{40,
          -6},{40,-60},{100,-60}}, color={0,127,255}));
    connect(chi[i].TSet, TSet) annotation (Line(points={{-12,-3},{-92,-3},{-92,-40},{
          -120,-40}}, color={0,0,127}));
    connect(on[i], booToRea[i].u)
    annotation (Line(points={{-120,40},{-92,40},{-82,40}}, color={255,0,255}));
    connect(on[i], chi[i].on) annotation (Line(points={{-120,40},{-106,40},{-92,40},{-92,
          3},{-12,3}}, color={255,0,255}));
    connect(booToRea[i].y, val1[i].y) annotation (Line(points={{-59,40},{20,40},
            {20,30},{28,30}}, color={0,0,127}));
    connect(booToRea[i].y, val2[i].y) annotation (Line(points={{-59,40},{-56,40},
            {-56,-30},{-52,-30}}, color={0,0,127}));
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255})}),
         Diagram(coordinateSystem(preserveAspectRatio=false)));
end ChillerParallel;
