partial model PartialDamperExponential 
  "Partial model of an air damper with exponential opening characteristics" 
  extends Buildings.Fluids.Actuators.BaseClasses.PartialResistance(
                                                   m_small_flow=eta0*ReC*sqrt(A)
        *facRouDuc);
  import SI = Modelica.SIunits;
  
   annotation (Documentation(info="<html>
Partial air damper with an flow coefficient that is an exponential function of the opening angle.
</html>", revisions="<html>
<ul>
<li>
July 20, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"), Icon(Polygon(points=[-52,-60; 12,58; 24,58; -42,-60; -52,-60], style(
          pattern=0,
          fillColor=0,
          rgbfillColor={0,0,0}))),
    Diagram);
  
  parameter SI.Area A "Face area";
  parameter Real a(unit="")=-1.51 "Coefficient a for damper characteristics";
  parameter Real b(unit="")=0.105*90 "Coefficient b for damper characteristics";
  parameter Real ReC=4000 "Reynolds number where transition to laminar starts";
  
  parameter Boolean roundDuct = false 
    "Set to true for round duct, false for square cross section";
  
protected 
  Real kTheta(min=0) 
    "Flow coefficient, kTheta = pressure drop divided by dynamic pressure";
  Real kDam(unit="(kg*m)^(1/2)", start=1) 
    "Flow coefficient for damper, k=m_flow/sqrt(dp)";
protected 
  parameter Real facRouDuc= if roundDuct then sqrt(Modelica.Constants.pi)/2 else 1;
public 
  Modelica.Blocks.Interfaces.RealInput y "Damper position (0: closed, 1: open)"
    annotation (extent=[-140,60; -100,100]);
equation 
   assert(y >= (15/90) and y <= (55/90),
          "Damper characteristics not implemented for angles outside 15...55 degree.\n" +
          "Received y = " + realString(y) + ". Corresponds to " +         realString(y*90) + " degrees.");
  
   kTheta = exp(a+b*(1-y)) "y=0 is closed, but theta=1 is closed in ASHRAE-825";
   A = kDam * sqrt(kTheta/2/medium_a.d) 
    "flow coefficient for resistance base model";
end PartialDamperExponential;
