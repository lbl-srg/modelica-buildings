within Buildings.Utilities.Math;
model TrapezoidalIntegration "Integration using the trapezoidal rule"
  extends Modelica.Blocks.Interfaces.MISO;
  parameter Integer N "Number of integrand points";
  parameter Real deltaX "Width of interval for Trapezoidal integration";
equation
  y = Buildings.Utilities.Math.Functions.trapezoidalIntegration(N=N, f=u, deltaX=deltaX);
  annotation (Icon(graphics={Text(
          extent={{-90,36},{90,-36}},
          textColor={160,160,164},
          textString="trapezoidalIntegration()")}), Documentation(info="<html>
<p>This function computes a definite integral using the trapezoidal rule. </p>
</html>", revisions="<html>
<ul>
<li>
November 29, 2013 by Marcus Fuchs:<br/>
Implementation based on Functions.trapezoidalIntegration.
</li>
</ul>
</html>"));
end TrapezoidalIntegration;
