within Buildings.DistrictHeatingCooling.Loads.BaseClasses;
model EffectivenessDirect
  "Model computing the heat flow rate transferred to a load at uniform temperature, based on the effectiveness"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Mass flow rate at nominal conditions";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput UA(
    quantity="ThermalConductance",
    unit="W/K",
    min=0) "Thermal conductance"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,90}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,80})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TInl(
    quantity="ThermodynamicTemperature", displayUnit="degC") "Fluid inlet temperature" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,10}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,0})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput m_flow(quantity="MassFlowRate") "Fluid mass flow rate" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,50}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TLoad(
    quantity="ThermodynamicTemperature", displayUnit="degC") "Temperature of the load" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-70}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-80})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput cpInl(quantity="SpecificHeatCapacity")
    "Fluid inlet specific heat capacity"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-30}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flow(quantity="HeatFlowRate") "Heat flow rate"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.SIunits.Efficiency eps "Heat exchanger effectiveness";
protected
  parameter Modelica.SIunits.HeatFlowRate m_flow_small = 1E-4 * abs(m_flow_nominal)
    "Small mass flow rate for regularization of zero flow";
  final parameter Real deltaReg = m_flow_small / 1E3
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
  Real m_flow_inv(unit="s/kg") "Regularization of 1/m_flow";
  Real NTU "Number of transfer units";
equation
  NTU = UA * m_flow_inv / cpInl;
  eps = Buildings.Utilities.Math.Functions.smoothMin(
      x1=Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ(
        NTU=NTU, Z=0,
        flowRegime=Integer(Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange)),
      x2=0.999,
      deltaX=1E-4);
  Q_flow = eps * abs(m_flow) * cpInl * (TLoad - TInl);
  m_flow_inv = Buildings.Utilities.Math.Functions.inverseXRegularized(
     x=m_flow, delta=deltaReg, deltaInv=deltaInvReg, a=aReg, b=bReg, c=cReg, d=dReg, e=eReg, f=fReg);
  annotation (
  defaultComponentName="effDir",
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
end EffectivenessDirect;
