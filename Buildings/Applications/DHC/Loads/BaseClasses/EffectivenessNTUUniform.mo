within Buildings.Applications.DHC.Loads.BaseClasses;
model EffectivenessNTUUniform
  "Model computing the heat flow rate based on the effectiveness-NTU method, for a load at uniform temperature"
  extends Modelica.Blocks.Icons.Block;
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
  import hexRegime = Buildings.Fluid.Types.HeatExchangerFlowRegime;
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal
    "Heat transfer (from primary to secondary fluid) at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal(min=0)
    "Source side mass flow rate at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a1_nominal
    "Primary fluid inlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a2_nominal
    "Secondary fluid inlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Real r_nominal(min=0, max=1) = 2/3
    "Ratio between secondary side and primary side convective heat transfer coefficient";
  final parameter Modelica.SIunits.ThermalConductance UA_nominal=
    Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(
      eps=abs(Q_flow_nominal / (CMin_flow_nominal * (T_a1_nominal - T_a2_nominal))),
      Z=0,
      flowRegime=Integer(floReg)) * CMin_flow_nominal
    "Thermal conductance at nominal conditions";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput m1_flow(
    quantity="MassFlowRate")
    "Primary fluid mass flow rate"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T_in1(
    quantity="ThermodynamicTemperature", unit="K", displayUnit="degC")
    "Primary fluid inlet temperature"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,0}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,0})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T_in2(
    quantity="ThermodynamicTemperature", unit="K", displayUnit="degC")
    "Primary fluid temperature (uniform)"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q1_flow(
    quantity="HeatFlowRate")
    "Heat flow rate transferred to primary fluid"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q2_flow(
    quantity="HeatFlowRate")
    "Heat flow rate transferred to secondary fluid"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));
  // MISCELLANEOUS VARIABLES
  Modelica.SIunits.ThermalConductance UA = 1/(1/hA1.hA + 1/hA2)
    "UA value";
  Modelica.SIunits.Efficiency eps
    "Heat exchanger effectiveness";
protected
  parameter Modelica.SIunits.SpecificHeatCapacity cp1_nominal=
    Medium1.specificHeatCapacityCp(sta1_nominal)
    "Primary fluid specific heat capacity at nominal conditions";
  parameter Modelica.SIunits.SpecificHeatCapacity cp2_nominal=
    Medium2.specificHeatCapacityCp(sta2_nominal)
    "Primary fluid specific heat capacity at nominal conditions";
  final parameter Medium1.ThermodynamicState sta1_nominal = Medium1.setState_pTX(
     T=T_a1_nominal,
     p=Medium1.p_default,
     X=Medium1.X_default[1:Medium1.nXi])
     "Nominal state for medium 1";
  final parameter Medium2.ThermodynamicState sta2_nominal = Medium2.setState_pTX(
     T=T_a2_nominal,
     p=Medium2.p_default,
     X=Medium2.X_default[1:Medium2.nXi])
     "Nominal state for medium 2";
  final parameter Modelica.SIunits.ThermalConductance hA2=
    UA_nominal * (r_nominal+1)
    "Secondary side convective heat transfer coefficient (constant)";
  final parameter hexRegime floReg = hexRegime.ConstantTemperaturePhaseChange
    "Heat exchanger flow regime";
  final parameter Modelica.SIunits.ThermalConductance CMin_flow_nominal=
    m1_flow_nominal * cp1_nominal
    "Minimal capacity flow rate at nominal conditions";
  final parameter Real deltaReg = m1_flow_nominal * 1E-7
    "Smoothing region for inverseXRegularized";
  final parameter Real deltaInvReg = 1/deltaReg
    "Inverse value of delta for inverseXRegularized";
  final parameter Real aReg = -15*deltaInvReg
    "Polynomial coefficient for inverseXRegularized";
  final parameter Real bReg = 119*deltaInvReg^2
    "Polynomial coefficient for inverseXRegularized";
  final parameter Real cReg = -361*deltaInvReg^3
    "Polynomial coefficient for inverseXRegularized";
  final parameter Real dReg = 534*deltaInvReg^4
    "Polynomial coefficient for inverseXRegularized";
  final parameter Real eReg = -380*deltaInvReg^5
    "Polynomial coefficient for inverseXRegularized";
  final parameter Real fReg = 104*deltaInvReg^6
    "Polynomial coefficient for inverseXRegularized";
  Real m1_flow_inv(unit="s/kg")
    "Regularization of 1/m_flow";
  Fluid.HeatExchangers.BaseClasses.HACoilInside hA1(
    final m_flow_nominal=m1_flow_nominal,
    final hA_nominal=UA_nominal * (r_nominal+1)/r_nominal,
    final T_nominal=T_a1_nominal)
    "Model computing primary side convective heat transfer coefficient";
equation
  hA1.m_flow = m1_flow;
  hA1.T = T_in1;
  eps = Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ(
    NTU=UA / cp1_nominal * m1_flow_inv,
    Z=0,
    flowRegime=Integer(floReg));
  m1_flow_inv = Buildings.Utilities.Math.Functions.inverseXRegularized(
    x=m1_flow, delta=deltaReg, deltaInv=deltaInvReg, a=aReg, b=bReg, c=cReg, d=dReg, e=eReg, f=fReg);
  Q2_flow = m1_flow * cp1_nominal * eps * (T_in1 - T_in2);
  Q1_flow = -Q2_flow;
annotation (
  defaultComponentName="heaFloEff",
  Documentation(info="
<html>
<p>
This model computes the heat flow rate transferred to a load at uniform temperature, 
based on the effectiveness method:
</p>
<p style=\"font-style:italic;\">
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
Under the assumption of a uniform load temperature, the effective capacity rate 
on the load side is infinite so <i>C<sub>min</sub></i> corresponds to the 
capacity rate of the heating or cooling fluid and the expression of
the effectiveness comes down to:
</p>
<p style=\"font-style:italic;\">
&epsilon; = 1 - exp(-UA / C<sub>min</sub>)
</p>
<p>
where <i>UA</i> is the overall uniform thermal conductance.
</p>
</p>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)));
end EffectivenessNTUUniform;
