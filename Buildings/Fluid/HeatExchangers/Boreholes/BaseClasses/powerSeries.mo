within Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses;
function powerSeries "Power series used to compute far-field temperature"
  input Real u "u";
  input Integer N "Number of coefficients";
  output Real W "Power series";
algorithm
  W := -0.5772 - Modelica.Math.log(u) + sum((-1)^(j + 1)*u^j/(j*factorial(j))
    for j in 1:N);
  annotation ( Documentation(info="<html>
          <p>
This function computes the power series that is used to compute the far-field
temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
July 28 2011, by Pierre Vigouroux:<br/>
First implementation.
</li>
</ul>
</html>"));
end powerSeries;
