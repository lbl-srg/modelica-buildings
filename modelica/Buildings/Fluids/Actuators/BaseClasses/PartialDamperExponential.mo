within Buildings.Fluids.Actuators.BaseClasses;
partial model PartialDamperExponential
  "Partial model for air dampers with exponential opening characteristics"
  extends PartialActuator;

 annotation(Documentation(info="<html>
<p>
Partial model for air dampers with exponential opening characteristics. 
This is the base model for air dampers.
The model defines the flow rate where the linearization near the origin occurs. 
The model also defines parameters that are used by different air damper
models.
</p><p>
This model does not assign <tt>k=kDam</tt> because the model
<a href=\"Modelica:Buildings.Fluids.Actuators.Dampers.VAVBoxExponential\">
VAVBoxExponential</a> consists of a fixed resistance and a resistance due to the
air damper. If <tt>k</tt> would be assigned here, then this partial model could not
be used as a base class for 
<a href=\"Modelica:Buildings.Fluids.Actuators.Dampers.VAVBoxExponential\">
VAVBoxExponential</a>.
</p>
<p>
For a description of the opening characteristics and typical parameter values, see the damper model
<a href=\"Modelica:Buildings.Fluids.Actuators.Dampers.Exponential\">
Exponential</a>.
 
</p>
</html>"),
revisions="<html>
<ul>
<li>
June 22, 2008 by Michael Wetter:<br>
Extended range of control signal from 0 to 1 by implementing the function 
<a href=\"Modelica:Buildings.Fluids.Actuators.BaseClasses.exponentialDamper\">
exponentialDamper</a>.
</li>
<li>
June 10, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");
  parameter Modelica.SIunits.Area A "Face area";
  parameter Boolean roundDuct = false
    "Set to true for round duct, false for square cross section";
  parameter Real ReC=4000 "Reynolds number where transition to laminar starts";

  parameter Real a(unit="")=-1.51 "Coefficient a for damper characteristics";
  parameter Real b(unit="")=0.105*90 "Coefficient b for damper characteristics";
  parameter Real yL = 15/90 "Lower value for damper curve";
  parameter Real yU = 55/90 "Upper value for damper curve";
  parameter Real k0(min=0) = 1E6
    "Flow coefficient for y=0, k0 = pressure drop divided by dynamic pressure";
  parameter Real k1(min=0) = 0.45
    "Flow coefficient for y=1, k1 = pressure drop divided by dynamic pressure";
  Real kDam(start=1)
    "Flow coefficient for damper, k=m_flow/sqrt(dp), with unit=(kg*m)^(1/2)";

protected
  Real kTheta(min=0)
    "Flow coefficient, kTheta = pressure drop divided by dynamic pressure";
  parameter Real[3] cL(fixed=false)
    "Polynomial coefficients for curve fit for y < yl";
  parameter Real[3] cU(fixed=false)
    "Polynomial coefficients for curve fit for y > yu";

protected
  parameter Real facRouDuc= if roundDuct then sqrt(Modelica.Constants.pi)/2 else 1;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Polygon(
          points={{-20,4},{4,50},{16,50},{-8,4},{-20,4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid), Polygon(
          points={{-22,-46},{2,0},{14,0},{-10,-46},{-22,-46}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
initial equation
 cL[1] = (ln(k0) - b - a)/yL^2;
 cL[2] = (-b*yL - 2*ln(k0) + 2*b + 2*a)/yL;
 cL[3] = ln(k0);

 cU[1] = (ln(k1) - a)/(yU^2 - 2*yU + 1);
 cU[2] = (-b*yU^2 - 2*ln(k1)*yU - (-2*b - 2*a)*yU - b)/(yU^2 - 2*yU + 1);
 cU[3] = (ln(k1)*yU^2 + b*yU^2 + (-2*b - 2*a)*yU + b + a)/(yU^2 - 2*yU + 1);
 assert(k0 > k1, "k0 must be bigger than k1.");
equation
   m_flow_laminar=eta0*ReC*sqrt(A)*facRouDuc;
   kTheta = exponentialDamper(y=y, a=a, b=b, cL=cL, cU=cU, yL=yL, yU=yU)
    "y=0 is closed";
   assert(kTheta>=0, "Flow coefficient must not be negative");
   kDam = sqrt(2*Medium.density(state_a)/kTheta) * A
    "flow coefficient for resistance base model, kDam=k=m_flow/sqrt(dp)";

end PartialDamperExponential;
