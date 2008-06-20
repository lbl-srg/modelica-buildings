partial model PartialDamperExponential 
  "Partial model for air dampers with exponential opening characteristics" 
  extends PartialActuator(m_small_flow=eta0*ReC*sqrt(A)*facRouDuc);
  
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
</html>"),
revisions="<html>
<ul>
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
  Real kDam(unit="(kg*m)^(1/2)", start=1) 
    "Flow coefficient for damper, k=m_flow/sqrt(dp)";
  
protected 
  Real kTheta(min=0) 
    "Flow coefficient, kTheta = pressure drop divided by dynamic pressure";
  
protected 
  parameter Real facRouDuc= if roundDuct then sqrt(Modelica.Constants.pi)/2 else 1;
  annotation (Icon(
                Polygon(points=[-20,4; 4,50; 16,50; -8,4; -20,4],         style(
          pattern=0,
          fillColor=0,
          rgbfillColor={0,0,0})),
                Polygon(points=[-22,-46; 2,0; 14,0; -10,-46; -22,-46],    style(
          pattern=0,
          fillColor=0,
          rgbfillColor={0,0,0}))));
equation 
   assert(y >= (15/90) and y <= (55/90),
          "Damper characteristics not implemented for angles outside 15...55 degree.\n" +
          "Received y = " + realString(y) + ". Corresponds to " +         realString(y*90) + " degrees.");
  
   kTheta = exp(a+b*(1-y)) "y=0 is closed, but theta=1 is closed in ASHRAE-825";
   kDam = sqrt(kTheta/2/medium_a.d) / A 
    "flow coefficient for resistance base model";
  
end PartialDamperExponential;
