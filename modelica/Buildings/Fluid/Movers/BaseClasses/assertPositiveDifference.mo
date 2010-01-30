within Buildings.Fluid.Movers.BaseClasses;
function assertPositiveDifference
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Pressure p;
  input Modelica.SIunits.Pressure p_sat;
  input String message;
  output Modelica.SIunits.Pressure dp;
algorithm
  dp := p - p_sat;
  assert(p >= p_sat, message);
end assertPositiveDifference;
