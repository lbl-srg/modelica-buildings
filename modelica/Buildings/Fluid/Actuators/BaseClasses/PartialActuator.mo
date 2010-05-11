within Buildings.Fluid.Actuators.BaseClasses;
partial model PartialActuator "Partial model of an actuator"
  extends Buildings.Fluid.BaseClasses.PartialResistance;
  import SI = Modelica.SIunits;


public
  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1)
    "Damper position (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
          rotation=270,
        origin={0,80}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,80})));
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
          extent={{38,112},{62,74}},
          lineColor={0,0,127},
          textString="y")}),
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}),
            graphics));
end PartialActuator;
