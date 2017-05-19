within Buildings.ChillerWSE;
model ChillerParallel "Ensembled multiple chillers via vector"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
     m1_flow_nominal=mCon_flow_nominal,
     m2_flow_nominal=mEva_flow_nominal,
    port_a1(h_outflow(start=h1_outflow_start)),
    port_b1(h_outflow(start=h1_outflow_start)),
    port_a2(h_outflow(start=h2_outflow_start)),
    port_b2(h_outflow(start=h2_outflow_start)));
  extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
     final computeFlowResistance1=true,
     final computeFlowResistance2=true);

  parameter Integer nChi "Number of identical chillers";
  parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal
    "Nominal mass flow at evaporator";
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal
    "Nominal mass flow at condenser";

  parameter Modelica.SIunits.Time tau1 = 30 "Time constant at nominal flow"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));
  parameter Modelica.SIunits.Time tau2 = 30 "Time constant at nominal flow"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));

  // Advanced
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

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

protected
  parameter Medium1.ThermodynamicState sta1_start=Medium1.setState_pTX(
      T=T1_start, p=p1_start, X=X1_start);
  parameter Modelica.SIunits.SpecificEnthalpy h1_outflow_start = Medium1.specificEnthalpy(sta1_start)
    "Start value for outflowing enthalpy";
  parameter Medium2.ThermodynamicState sta2_start=Medium2.setState_pTX(
      T=T2_start, p=p2_start, X=X2_start);
  parameter Modelica.SIunits.SpecificEnthalpy h2_outflow_start = Medium2.specificEnthalpy(sta2_start)
    "Start value for outflowing enthalpy";

  Buildings.Fluid.Chillers.ElectricEIR chi[nChi](
    redeclare each final replaceable package Medium1 = Medium1,
    redeclare each final replaceable package Medium2 = Medium2,
    each final allowFlowReversal1=allowFlowReversal1,
    each final allowFlowReversal2=allowFlowReversal2,
    each final m1_flow_nominal=mCon_flow_nominal,
    each final m2_flow_nominal=mEva_flow_nominal,
    each final from_dp1=from_dp1,
    each final dp1_nominal=dp1_nominal,
    each final linearizeFlowResistance1=linearizeFlowResistance1,
    each final deltaM1=deltaM1,
    each final from_dp2=from_dp2,
    each final dp2_nominal=dp2_nominal,
    each final linearizeFlowResistance2=linearizeFlowResistance2,
    each final deltaM2=deltaM2,
    each final m1_flow_small=m1_flow_small,
    each final m2_flow_small=m2_flow_small,
    each final homotopyInitialization=homotopyInitialization,
    each final tau1=tau1,
    each final tau2=tau2,
    each final energyDynamics=energyDynamics,
    each final massDynamics=massDynamics,
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
    show_T=show_T)
    "Multiple identical chillers"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={0,0})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val2[nChi](
      allowFlowReversal=allowFlowReversal2, redeclare package Medium = Medium2)
    "Valves on medium 2 side" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-40,-30})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val1[nChi](
      allowFlowReversal=allowFlowReversal1, redeclare each final package Medium =
        Medium1) "Valves on medium 1 side" annotation (Placement(transformation(
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
    final realTrue=1,
    final realFalse=0)
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
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ChillerParallel;
