within Buildings.Fluid.HeatExchangers.BaseClasses;
partial model PartialPipeManifold "Partial pipe manifold for a heat exchanger"
  extends PartialDuctPipeManifold;
  Modelica.Fluid.Interfaces.FluidPort_b[nPipPar] port_b(
        redeclare each package Medium = Medium,
        each m_flow(start=-mStart_flow_a/nPipPar, max=if allowFlowReversal then +Modelica.Constants.inf else 0))
    "Fluid connector b for medium (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}})));
annotation (                   Documentation(info="<html>
<p>
Partial pipe manifold for a heat exchanger.
</p>
<p>
This model defines the pipe connection to a heat exchanger.
It is extended by other models that model the flow connection
between the ports with and without flow friction.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 22, 2008, by Michael Wetter:<br/>
Added start value for port mass flow rate.
</li>
<li>
April 14, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialPipeManifold;
