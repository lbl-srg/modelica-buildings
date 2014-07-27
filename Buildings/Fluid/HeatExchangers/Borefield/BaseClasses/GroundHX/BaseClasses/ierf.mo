within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.GroundHX.BaseClasses;
function ierf "Integral of erf(u) for u=0 till u"
  extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;

protected
  Real lb=0 "lower boundary for integral";

algorithm
  y := u*erf(u) - 1/sqrt(Modelica.Constants.pi)*(1 - Modelica.Constants.e^(-u^2));

end ierf;
