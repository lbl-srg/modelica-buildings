within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors;
function finiteLineSource_Erfint "Integral of the error function"
  extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;

algorithm
  y := u*Modelica.Math.Special.erf(u) - 1/sqrt(Modelica.Constants.pi)*(1 - exp(-u^2));

annotation (
Inline=true,
Documentation(info="<html>
<p>
This function evaluates the integral of the error function, given by:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/ErrorFunctionIntegral_01.png\" />
</p>
</html>", revisions="<html>
<ul>
<li>
March 22, 2018 by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end finiteLineSource_Erfint;
