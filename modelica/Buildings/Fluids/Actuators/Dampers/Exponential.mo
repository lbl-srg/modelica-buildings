model Exponential "Air damper with exponential opening characteristics" 
  extends Buildings.Fluids.Actuators.BaseClasses.PartialDamperExponential;
   annotation (Documentation(info="<html>
This model is an air damper with flow coefficient that is an exponential function of the opening angle.
</html>", revisions="<html>
<ul>
<li>
June 10, 2008 by Michael Wetter:<br>
Introduced new partial base class, 
<a href=\"Modelica:Buildings.Fluids.Actuators.BaseClasses.PartialDamperExponential\">
PartialDamperExponential</a>.
</li>
<li>
June 30, 2007 by Michael Wetter:<br>
Introduced new partial base class, 
<a href=\"Modelica:Buildings.Fluids.Actuators.BaseClasses.PartialActuator\">PartialActuator</a>.
</li>
<li>
July 27, 2007 by Michael Wetter:<br>
Introduced partial base class.
</li>
<li>
July 20, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"), Icon,
    Diagram);
equation 
  k = kDam "flow coefficient for resistance base model";
end Exponential;
