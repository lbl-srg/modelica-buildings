within Buildings.Utilities.Math.Functions;
function exponentialIntegralE1 "Exponential integral, E1"
  extends Modelica.Icons.Function;

  input Real x "Independent variable";
  output Real E1 "Exponential integral E1(x)";

protected
  constant Real a1[6] = {-0.57721566, 0.99999193, -0.24991055, 0.05519968, -0.00976004, 0.00107857};
  constant Real a2[5] = {0.2677737343, 8.6347608925, 18.0590169730, 8.5733287401, 1.0};
  constant Real b2[5] = {3.9584969228, 21.0996530827, 25.6329561486, 9.5733223454, 1.0};

algorithm

    E1 := if x < 1 then
            Buildings.Utilities.Math.Functions.polynomial(x, a1) - log(x)
          else
           Buildings.Utilities.Math.Functions.polynomial(x, a2)/(Buildings.Utilities.Math.Functions.polynomial(x, b2)*x*exp(x));

annotation (
Inline=true,
Documentation(info="<html>
<p>
Evaluates the exponential integral (E<sub>1</sub>), based
on the polynomial and rational approximations of Abramowitz and Stegun (1964).
</p>
<h4>References</h4>
<p>
Abramowitz, Milton, and Irene A. Stegun. Handbook of Mathematical Functions
with Formulas, Graphs, and Mathematical Tables. National Bureau of Standards.
(1964): 1046 p.
</p>
</html>", revisions="<html>
<ul>
<li>
July 16, 2018 by Michael Wetter:<br/>
Inlined function.
</li>
<li>
March 21, 2018 by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end exponentialIntegralE1;
