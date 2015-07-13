within Buildings.Utilities.Math.Functions.Examples;
model TrapezoidalIntegration
  "Tests the correct implementation of the function trapezoidalIntegration"
  extends Modelica.Icons.Example;
  Real y1[7] = {72, 70, 64, 54, 40, 22, 0}; //function values of y = -2*x^2-72 for x={0,1,2,3,4,5,6}
  Real y "Integration result";
  //Real y2[7] = {0.3333, 1.0, 3.0, 9.9, 27.0, 81.0, 243.0}; // //function values of y = 3^(3x-1) for x=0:0.3333:2
algorithm
  y := Buildings.Utilities.Math.Functions.trapezoidalIntegration(N=7, f=y1, deltaX=1);
 assert(y - 286.0 < 1E-4,
   "Error. Function should have returned 286.");
  annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/TrapezoidalIntegration.mos"
        "Simulate and plot"),
                     Documentation(info="<html>
<p>
Tests the correct implementation of function
<a href=\"modelica://Buildings.Utilities.Math.Functions.trapezoidalIntegration\">
Buildings.Utilities.Math.Functions.trapezoidalIntegration</a>.
</p>
<p>Integrands y1[7]={72, 70, 64, 54, 40, 22, 0} are the function values of y = -2*x^2-72 for x = {0,1,2,3,4,5,6}. The trapezoidal integration over the 7 integrand points should give a result of 286.</p>
</html>", revisions="<html>
<ul>
<li>
January 8, 2014, by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>"));
end TrapezoidalIntegration;
