within Buildings.Fluid.Actuators.BaseClasses;
partial model PartialActuator "Partial model of an actuator"
    extends Buildings.Fluid.BaseClasses.PartialResistance;

  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1)
    "Actuator position (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
          rotation=270,
        origin={0,80}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,80})));

   annotation (Documentation(info="<html>
<p>
Partial actuator that is the base class for dampers and two way valves.
</p>
<h4>Implementation</h4>
<p>
This model extends 
<a href=\"modelica://Buildings.Fluid.BaseClasses.PartialResistance\">
Buildings.Fluid.BaseClasses.PartialResistance</a>
and adds an input signal for the actuator.
</p>
</html>", revisions="<html>
<ul>
<li>
January 16, 2012 by Michael Wetter:<br>
To simplify object inheritance tree, revised base classes
<code>Buildings.Fluid.BaseClasses.PartialResistance</code>,
<code>Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve</code>,
<code>Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential</code>,
<code>Buildings.Fluid.Actuators.BaseClasses.PartialActuator</code>
and model
<code>Buildings.Fluid.FixedResistances.FixedResistanceDpM</code>.
</li>
<li>
August 1, 2008 by Michael Wetter:<br>
Set start values for <code>dp</code> and <code>m_flow</code>
to zero.
</li>
<li>
April 4, 2008, by Michael Wetter:<br>
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
