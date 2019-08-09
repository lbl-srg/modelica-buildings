within Buildings.Applications.DHC.Loads.BaseClasses;
model HeatFlowEffectiveness "Model computing the heat flow rate based on the effectiveness method"
  extends Modelica.Blocks.Icons.Block;
  parameter Buildings.Fluid.Types.HeatExchangerFlowRegime flowRegime
    "Heat exchanger flow regime, see  Buildings.Fluid.Types.HeatExchangerFlowRegime";
  parameter Modelica.SIunits.MassFlowRate m_flow1_nominal(min=0)
    "Source side mass flow rate at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow2_nominal(min=0)
    "Load side mass flow rate at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.SpecificHeatCapacity cp1_nominal
    "Source side specific heat capacity at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.SpecificHeatCapacity cp2_nominal
    "Load side specific heat capacity at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput UA(
    quantity="ThermalConductance", unit="W/K", min=0)
    "Thermal conductance"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,90}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,80})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T1Inl(
    quantity="ThermodynamicTemperature", displayUnit="degC")
    "Source side temperature at inlet"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,10}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,0})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput m_flow1(
    quantity="MassFlowRate")
    "Source side mass flow rate"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,50}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T2Inl(
    quantity="ThermodynamicTemperature", displayUnit="degC")
    "Load side temperature at inlet"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-70}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-80})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput m_flow2(
    quantity="MassFlowRate")
    "Load side mass flow rate"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-30}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flow(
    quantity="HeatFlowRate")
    "Heat flow rate transferred to the load"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.SIunits.Efficiency eps
    "Heat exchanger effectiveness";
protected
  parameter Real deltaCMin = 1E-4 * CMin_flow_nominal
    "Regularization term for smoothing CMin_flow";
  parameter Modelica.SIunits.ThermalConductance CMin_flow_nominal = min(
    m_flow1_nominal * cp1_nominal, m_flow2_nominal * cp2_nominal);
  parameter Modelica.SIunits.ThermalConductance CMax_flow_nominal = max(
    m_flow1_nominal * cp1_nominal, m_flow2_nominal * cp2_nominal);
  final parameter Real deltaReg = m_flow1_nominal * 1E-7
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
  Real m_flow1_inv(unit="s/kg") "Regularization of 1/m_flow";
equation
  if flowRegime == Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange then
    // By convention, a zero value for m_flow2 is associated with that flow regime which requires
    // specific equations.
    eps = Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ(
      NTU=UA / cp1_nominal * m_flow1_inv,
      Z=0,
      flowRegime=Integer(Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange));
    m_flow1_inv = Buildings.Utilities.Math.Functions.inverseXRegularized(
      x=m_flow1, delta=deltaReg, deltaInv=deltaInvReg, a=aReg, b=bReg, c=cReg, d=dReg, e=eReg, f=fReg);
  else
    eps = Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_C(
      UA=UA,
      C1_flow=m_flow1 * cp1_nominal,
      C2_flow=m_flow2 * cp2_nominal,
      flowRegime=Integer(flowRegime),
      CMin_flow_nominal=CMin_flow_nominal,
      CMax_flow_nominal=CMax_flow_nominal);
    m_flow1_inv = 0;
  end if;
  // Equation for CMin_flow is inlined to optimize scaling and improve convergence of Newton solver.
  Q_flow = (if flowRegime == Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange then
      m_flow1 * cp1_nominal else Buildings.Utilities.Math.Functions.smoothMin(
        m_flow1 * cp1_nominal, m_flow2 * cp2_nominal, deltaCMin)) *
    eps * (T1Inl - T2Inl);
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
end HeatFlowEffectiveness;
