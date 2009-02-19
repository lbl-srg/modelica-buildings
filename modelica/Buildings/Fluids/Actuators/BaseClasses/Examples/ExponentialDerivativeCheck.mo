within Buildings.Fluids.Actuators.BaseClasses.Examples;
model ExponentialDerivativeCheck

 annotation(Diagram(graphics),
                     Commands(file="ExponentialDerivativeCheck.mos" "run"));
  annotation (
    Documentation(info="<html>
<p>
This example checks whether the function derivative
is implemented correctly. If the derivative implementation
is not correct, the model will stop with an assert statement.
</p>
</html>", revisions="<html>
<ul>
<li>
July 22, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

  parameter Real a(unit="")=-1.51 "Coefficient a for damper characteristics";
  parameter Real b(unit="")=0.105*90 "Coefficient b for damper characteristics";
  parameter Real yL = 15/90 "Lower value for damper curve";
  parameter Real yU = 55/90 "Upper value for damper curve";
  parameter Real k0(min=0) = 1E6
    "Flow coefficient for y=0, k0 = pressure drop divided by dynamic pressure";
  parameter Real k1(min=0) = 0.45
    "Flow coefficient for y=1, k1 = pressure drop divided by dynamic pressure";
  parameter Real[3] cL(fixed=false)
    "Polynomial coefficients for curve fit for y < yL";
  parameter Real[3] cU(fixed=false)
    "Polynomial coefficients for curve fit for y > yU";

  Real x;
  Real y;
initial equation
 cL[1] = (ln(k0) - b - a)/yL^2;
 cL[2] = (-b*yL - 2*ln(k0) + 2*b + 2*a)/yL;
 cL[3] = ln(k0);

 cU[1] = (ln(k1) - a)/(yU^2 - 2*yU + 1);
 cU[2] = (-b*yU^2 - 2*ln(k1)*yU - (-2*b - 2*a)*yU - b)/(yU^2 - 2*yU + 1);
 cU[3] = (ln(k1)*yU^2 + b*yU^2 + (-2*b - 2*a)*yU + b + a)/(yU^2 - 2*yU + 1);

   y=x;
equation
  x=Buildings.Fluids.Actuators.BaseClasses.exponentialDamper(y=time,a=a,b=b,cL=cL,cU=cU,yL=yL,yU=yU);
  der(y)=der(x);
  assert(abs(x-y) < 1E-2, "Model has an error");
end ExponentialDerivativeCheck;
