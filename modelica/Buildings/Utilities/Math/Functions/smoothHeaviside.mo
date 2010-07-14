within Buildings.Utilities.Math.Functions;
function smoothHeaviside
  "Once continuously differentiable approximation to the Heaviside function"
  input Real x "Argument";
  input Real delta "Width of transition interval";
  output Real y "Result";
algorithm
  if x <= -delta then
    y := 0;
  elseif x >= delta then
    y := 1;
  else
    y := 0.5*(Modelica.Math.sin(0.5*Modelica.Constants.pi*x/delta) + 1);
  end if;
 annotation (Documentation(info="<html>
<p>
Once Lipschitz continuously differentiable approximation to the <tt>Heaviside(.,.)</tt> function.
</p>
</html>", revisions="<html>
<ul>
<li>
July 14, 2010, by Wangda Zuo, Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end smoothHeaviside;
