model DamperExponential "Air damper with exponential opening characteristics" 
  extends Buildings.Fluids.Actuators.BaseClasses.PartialDamperExponential;
  import SI = Modelica.SIunits;
  
   annotation (Documentation(info="<html>
This model is an air damper with flow coefficient that is an exponential function of the opening angle.
</html>", revisions="<html>
<ul>
<li>
July 27, 2007 by Michael Wetter:<br>
Introduced partial base class.
</li>
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
  
equation 
   k = kDam "flow coefficient for resistance base model";
end DamperExponential;
