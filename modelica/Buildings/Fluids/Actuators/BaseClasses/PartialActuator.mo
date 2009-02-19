within Buildings.Fluids.Actuators.BaseClasses;
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
</html>"), Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{-134,138},{-110,100}},
          lineColor={0,0,127},
          textString="y")}),
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}),
            graphics));

public
  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1)
    "Damper position (0: closed, 1: open)" 
    annotation (Placement(transformation(extent={{-140,60},{-100,100}},
          rotation=0)));
end PartialActuator;
