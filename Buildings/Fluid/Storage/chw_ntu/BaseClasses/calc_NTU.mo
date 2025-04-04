within Buildings.Fluid.Storage.chw_ntu.BaseClasses;
function calc_NTU
  input Modelica.Units.SI.ThermalConductance UA "UA value";
  input Modelica.Units.SI.MassFlowRate m_flow;
input Modelica.Units.SI.MassFlowRate Tin;
    output Real eps;
protected
  Modelica.Units.SI.ThermalConductance c_flow;
  Real NTU;
algorithm
  c_flow:= m_flow * Buildings.Media.Antifreeze.Validation.BaseClasses.PropyleneGlycolWater.testSpecificHeatCapacityCp_TX_a(T=Tin, X_a=0.3);
  NTU := UA/Buildings.Utilities.Math.Functions.smoothMax(
    x1 = c_flow,
    x2 = 0.0001,
    deltaX = 1E-4);
  eps := 1 - exp(-NTU);

end calc_NTU;
