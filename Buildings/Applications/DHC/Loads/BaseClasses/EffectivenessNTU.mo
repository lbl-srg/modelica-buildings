within Buildings.Applications.DHC.Loads.BaseClasses;
block EffectivenessNTU
  "Model computing the heat flow rate based on the effectiveness-NTU method"
  extends Modelica.Blocks.Icons.Block;

  import con = Buildings.Fluid.Types.HeatExchangerConfiguration;
  import flo = Buildings.Fluid.Types.HeatExchangerFlowRegime;

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

  parameter con configuration "Heat exchanger configuration"
  annotation (Evaluate=true);

  parameter Boolean use_Q_flow_nominal = true
    "Set to true to specify Q_flow_nominal and temperatures, or to false to specify effectiveness"
    annotation (Evaluate=true,
                Dialog(group="Nominal thermal performance"));

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(
    fixed=use_Q_flow_nominal)
    "Nominal heat transfer"
    annotation (Dialog(group="Nominal thermal performance",
                       enable=use_Q_flow_nominal));
  parameter Modelica.SIunits.Temperature T_a1_nominal(
    fixed=use_Q_flow_nominal)
    "Nominal temperature at port a1"
    annotation (Dialog(group="Nominal thermal performance",
                       enable=use_Q_flow_nominal));
  parameter Modelica.SIunits.Temperature T_a2_nominal(
    fixed=use_Q_flow_nominal)
    "Nominal temperature at port a2"
    annotation (Dialog(group="Nominal thermal performance",
                       enable=use_Q_flow_nominal));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput UA(
    quantity="ThermalConductance", unit="W/K", min=0)
    "Thermal conductance"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-20}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-20})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T_in1(
    quantity="ThermodynamicTemperature", displayUnit="degC")
    "Primary fluid temperature at inlet"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,60}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,60})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput m1_flow(
    quantity="MassFlowRate")
    "Primary fluid mass flow rate"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,80}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,80})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T_in2(
    quantity="ThermodynamicTemperature", displayUnit="degC")
    "Secondary fluid temperature at inlet"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,20}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,20})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput m2_flow(
    quantity="MassFlowRate")
    "Secondary fluid mass flow rate"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput cp1(
    quantity="SpecificHeatCapacity")
    "Primary fluid specific heat capacity"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput cp2(
    quantity="SpecificHeatCapacity")
    "Secondary fluid specific heat capacity"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-60}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-60})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q1_flow(
    quantity="HeatFlowRate")
    "Heat flow rate transferred to primary fluid"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q2_flow(
    quantity="HeatFlowRate")
    "Heat flow rate transferred to secondary fluid"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));

  Modelica.SIunits.ThermalConductance C1_flow = abs(m1_flow) * cp1
    "Heat capacity flow rate medium 1";
  Modelica.SIunits.ThermalConductance C2_flow = abs(m2_flow) * cp2
    "Heat capacity flow rate medium 2";
  Modelica.SIunits.ThermalConductance CMin_flow(min=0) = min(C1_flow, C2_flow)
    "Minimum heat capacity flow rate";
  Modelica.SIunits.HeatFlowRate QMax_flow = CMin_flow*(T_in2 - T_in1)
    "Maximum heat flow rate into medium 1";

  Real eps(min=0, max=1) "Heat exchanger effectiveness";

  // NTU has been removed as NTU goes to infinity as CMin goes to zero.
  // This quantity is not good for modeling.
  //  Real NTU(min=0) "Number of transfer units";
  final parameter Modelica.SIunits.ThermalConductance UA_nominal(fixed=false)
    "Nominal UA value";
  final parameter Real NTU_nominal(min=0, fixed=false)
    "Nominal number of transfer units";

protected
  final parameter Medium1.ThermodynamicState sta1_default = Medium1.setState_pTX(
     T=Medium1.T_default,
     p=Medium1.p_default,
     X=Medium1.X_default[1:Medium1.nXi]) "Default state for medium 1";
  final parameter Medium2.ThermodynamicState sta2_default = Medium2.setState_pTX(
     T=Medium1.T_default,
     p=Medium2.p_default,
     X=Medium2.X_default[1:Medium2.nXi]) "Default state for medium 2";

  parameter Modelica.SIunits.SpecificHeatCapacity cp1_nominal(fixed=false)
    "Specific heat capacity of medium 1 at nominal condition";
  parameter Modelica.SIunits.SpecificHeatCapacity cp2_nominal(fixed=false)
    "Specific heat capacity of medium 2 at nominal condition";
  parameter Modelica.SIunits.ThermalConductance C1_flow_nominal(fixed=false)
    "Nominal capacity flow rate of Medium 1";
  parameter Modelica.SIunits.ThermalConductance C2_flow_nominal(fixed=false)
    "Nominal capacity flow rate of Medium 2";
  parameter Modelica.SIunits.ThermalConductance CMin_flow_nominal(fixed=false)
    "Minimal capacity flow rate at nominal condition";
  parameter Modelica.SIunits.ThermalConductance CMax_flow_nominal(fixed=false)
    "Maximum capacity flow rate at nominal condition";
  parameter Real Z_nominal(
    min=0,
    max=1,
    fixed=false) "Ratio of capacity flow rate at nominal condition";
  parameter Modelica.SIunits.Temperature T_b1_nominal(fixed=false)
    "Nominal temperature at port b1";
  parameter Modelica.SIunits.Temperature T_b2_nominal(fixed=false)
    "Nominal temperature at port b2";
  parameter flo flowRegime_nominal(fixed=false)
    "Heat exchanger flow regime at nominal flow rates";
  flo flowRegime(fixed=false, start=flowRegime_nominal)
    "Heat exchanger flow regime";
initial equation
  if configuration == con.ConstantTemperaturePhaseChange then
    assert(m1_flow_nominal == 0 or m2_flow_nominal == 0,
      "For the constant temperature configuration, either
      m1_flow_nominal or m2_flow_nominal must be equal to zero.");
    // Heat transferred from fluid 1 to 2 at nominal condition
    if m1_flow_nominal == 0 then
      C1_flow_nominal = Modelica.Constants.inf;
      T_b1_nominal = T_a1_nominal;
      Q_flow_nominal = -m2_flow_nominal*cp2_nominal*(T_a2_nominal - T_b2_nominal);
    else
      C2_flow_nominal = Modelica.Constants.inf;
      T_b2_nominal = T_a2_nominal;
      Q_flow_nominal = m1_flow_nominal*cp1_nominal*(T_a1_nominal - T_b1_nominal);
    end if;
    Z_nominal = 0;
  else
    assert(m1_flow_nominal > 0,
      "For a configuration different than constant temperature,
       m1_flow_nominal must be positive, m1_flow_nominal = " + String(
      m1_flow_nominal));
    assert(m2_flow_nominal > 0,
      "For a configuration different than constant temperature,
      m2_flow_nominal must be positive, m2_flow_nominal = " + String(
      m2_flow_nominal));
    // Heat transferred from fluid 1 to 2 at nominal condition
    C1_flow_nominal = m1_flow_nominal*cp1_nominal;
    C2_flow_nominal = m2_flow_nominal*cp2_nominal;
    Z_nominal = CMin_flow_nominal/CMax_flow_nominal;
    Q_flow_nominal = m1_flow_nominal*cp1_nominal*(T_a1_nominal - T_b1_nominal);
    if use_Q_flow_nominal then
      eps_nominal = abs(Q_flow_nominal/((T_a1_nominal - T_a2_nominal)*
        CMin_flow_nominal));
    else
      T_a1_nominal = Medium1.T_default;
      T_a2_nominal = Medium2.T_default;
      T_b1_nominal = Medium1.T_default;
      T_b2_nominal = Medium2.T_default;
    end if;
  end if;
  if use_Q_flow_nominal then
    eps_nominal = abs(Q_flow_nominal/((T_a1_nominal - T_a2_nominal)*
      CMin_flow_nominal));
  else
    T_a1_nominal = Medium1.T_default;
    T_a2_nominal = Medium2.T_default;
    T_b1_nominal = Medium1.T_default;
    T_b2_nominal = Medium2.T_default;
  end if;
  cp1_nominal = Medium1.specificHeatCapacityCp(sta1_default);
  cp2_nominal = Medium2.specificHeatCapacityCp(sta2_default);
  CMin_flow_nominal = min(C1_flow_nominal, C2_flow_nominal);
  CMax_flow_nominal = max(C1_flow_nominal, C2_flow_nominal);
  assert(eps_nominal > 0 and eps_nominal < 1,
    "eps_nominal out of bounds, eps_nominal = " + String(eps_nominal) +
    "\n  To achieve the required heat transfer rate at epsilon=0.8, set |T_a1_nominal-T_a2_nominal| = "
     + String(abs(Q_flow_nominal/0.8*CMin_flow_nominal)) +
    "\n  or increase flow rates. The current parameters result in " +
    "\n  CMin_flow_nominal = " + String(CMin_flow_nominal) +
    "\n  CMax_flow_nominal = " + String(CMax_flow_nominal));
  // Assign the flow regime for the given heat exchanger configuration and capacity flow rates
  if (configuration == con.CrossFlowStream1MixedStream2Unmixed) then
    flowRegime_nominal = if (C1_flow_nominal < C2_flow_nominal) then flo.CrossFlowCMinMixedCMaxUnmixed
       else flo.CrossFlowCMinUnmixedCMaxMixed;
  elseif (configuration == con.CrossFlowStream1UnmixedStream2Mixed) then
    flowRegime_nominal = if (C1_flow_nominal < C2_flow_nominal) then flo.CrossFlowCMinUnmixedCMaxMixed
       else flo.CrossFlowCMinMixedCMaxUnmixed;
  elseif (configuration == con.ParallelFlow) then
    flowRegime_nominal = flo.ParallelFlow;
  elseif (configuration == con.CounterFlow) then
    flowRegime_nominal = flo.CounterFlow;
  elseif (configuration == con.CrossFlowUnmixed) then
    flowRegime_nominal = flo.CrossFlowUnmixed;
  elseif (configuration == con.ConstantTemperaturePhaseChange) then
    flowRegime_nominal = flo.ConstantTemperaturePhaseChange;
  else
    // Invalid flow regime. Assign a value to flowRegime_nominal, and stop with an assert
    flowRegime_nominal = flo.CrossFlowUnmixed;
    assert(configuration >= con.ParallelFlow and configuration <= con.CrossFlowStream1UnmixedStream2Mixed,
      "Invalid heat exchanger configuration.");
  end if;
  // The equation sorter of Dymola 7.3 does not guarantee that the above assert is tested prior to the
  // function call on the next line. Thus, we add the test on eps_nominal to avoid an error in ntu_epsilonZ
  // for invalid input arguments
  NTU_nominal = if (eps_nominal > 0 and eps_nominal < 1) then
    Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(
    eps=eps_nominal,
    Z=Z_nominal,
    flowRegime=Integer(flowRegime_nominal)) else 0;
  UA_nominal = NTU_nominal*CMin_flow_nominal;
equation
  C1_flow = abs(m1_flow) * cp1;
  C2_flow = abs(m2_flow) * cp2;
  CMin_flow = min(C1_flow, C2_flow);
  QMax_flow = CMin_flow*(T_in2 - T_in1);
  Q1_flow = eps*QMax_flow;
  Q2_flow = -Q1_flow;
  mWat1_flow = 0;
  mWat2_flow = 0;
  // Assign the flow regime for the given heat exchanger configuration and capacity flow rates
  if (configuration == con.ParallelFlow) then
    flowRegime = if (C1_flow*C2_flow >= 0) then flo.ParallelFlow else flo.CounterFlow;
  elseif (configuration == con.CounterFlow) then
    flowRegime = if (C1_flow*C2_flow >= 0) then flo.CounterFlow else flo.ParallelFlow;
  elseif (configuration == con.CrossFlowUnmixed) then
    flowRegime = flo.CrossFlowUnmixed;
  elseif (configuration == con.CrossFlowStream1MixedStream2Unmixed) then
    flowRegime = if (C1_flow < C2_flow) then flo.CrossFlowCMinMixedCMaxUnmixed
       else flo.CrossFlowCMinUnmixedCMaxMixed;
  else
    // have ( configuration == con.CrossFlowStream1UnmixedStream2Mixed)
    flowRegime = if (C1_flow < C2_flow) then flo.CrossFlowCMinUnmixedCMaxMixed
       else flo.CrossFlowCMinMixedCMaxUnmixed;
  end if;

  // Effectiveness
  eps = Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_C(
    UA=UA,
    C1_flow=C1_flow,
    C2_flow=C2_flow,
    flowRegime=Integer(flowRegime),
    CMin_flow_nominal=CMin_flow_nominal,
    CMax_flow_nominal=CMax_flow_nominal,
    delta=delta);
annotation (
  defaultComponentName="heaFloEff",
  Documentation(info="
  <html>
  <p>
  This model computes the heat flow rate transferred to a load at uniform temperature, based on the
  effectiveness method:
  </p>
  <p align=\"center\" style=\"font-style:italic;\">
  Q&#775; = &epsilon; * C<sub>min</sub> * (T<sub>inl</sub> - T<sub>load</sub>)
  </p>
  <p>
  where
  <i>&epsilon;</i> is the effectiveness,
  <i>C<sub>min</sub></i> is the minimum capacity rate,
  <i>T<sub>inl</sub></i> is the fluid inlet temperature and
  <i>T<sub>load</sub></i> is the temperature of the load.
  </p>
  <p>
  Under the assumption of a uniform load temperature, the effective capacity rate on the load side is infinite
  so <i>C<sub>min</sub></i> corresponds to the capacity rate of the circulating fluid and the expression of
  the effectiveness comes down to:
  </p>
  <p align=\"center\" style=\"font-style:italic;\">
  &epsilon; = 1 - exp(-UA / C<sub>min</sub>)
  </p>
  <p>
  where <i>UA</i> is the overall uniform thermal conductance.
  </p>
  </p>
  </html>"),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end EffectivenessNTU;
