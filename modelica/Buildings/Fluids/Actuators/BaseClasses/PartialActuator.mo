partial model PartialActuator "Partial model of an actuator" 
  extends Buildings.Fluids.BaseClasses.PartialResistance;
  import SI = Modelica.SIunits;
  
   annotation (Documentation(info="<html>
Partial actuator that is the base class for dampers and two way valves.
</html>", revisions="<html>
<ul>
<li>
June 3, 2008 by Michael Wetter:<br>
Moved damper specific parameters and equations to DamperExponential.
</li>
<li>
July 20, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"), Icon,
    Diagram);
  
public 
  Modelica.Blocks.Interfaces.RealInput y "Damper position (0: closed, 1: open)"
    annotation (extent=[-140,60; -100,100]);
end PartialActuator;
