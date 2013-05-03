within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses;
function linearFourVariables "Linear fuction with four independent variables"
 input Real x[4] "Independent variable";
 input Real a[5] "Coefficients";
 output Real y "Result";
protected
  Real z;
algorithm
//  for i in 1:4 loop
//     z :=a[i+1]*x[i];
//  end for;
  z:=a[2]*x[1] + a[3]*x[2] + a[4]*x[3] + a[5]*x[4];
  y :=a[1]+z;
  annotation (Documentation(info="<html>
This function computes value of a linear equation with four variables.
The equation has the form
<p align=\"center\" style=\"font-style:italic;\">
  y = a<sub>1</sub> + a<sub>2</sub> x<sub>1</sub> + a<sub>3</sub> x<sub>2</sub> 
+ a<sub>4</sub> x<sub>3</sub>+ a<sub>5</sub> x<sub>4</sub>
</p>
</html>"),
revisions="<html>
<ul>
<li>
November 09, 2012, by Kaustubh Phalak:<br>
First implementation.
</li>
</ul>
</html>");
end linearFourVariables;
