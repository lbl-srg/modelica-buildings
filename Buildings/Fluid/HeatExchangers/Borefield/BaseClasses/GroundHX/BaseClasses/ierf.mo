within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.GroundHX.BaseClasses;
function ierf "Integral of erf(u) for u=0 till u"
  extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;

protected
  Real lb=0 "Lower boundary for integral";

algorithm
  y := u*erf(u) - 1/sqrt(Modelica.Constants.pi)*(1 - Modelica.Constants.e^(-u^2));
  annotation (Documentation(info="<html>
  <p>Integral of error function. </p>
</html>", revisions="<html>
<ul>
<li>
September 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end ierf;
