partial model PartialPipeManifold "Partial pipe manifold for a heat exchanger" 
  extends PartialDuctPipeManifold;
annotation(Diagram, Documentation(info="<html>
<p>
Partial pipe manifold for a heat exchanger.</p>
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
April 14, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  Modelica_Fluid.Interfaces.FluidPort_b[nPipPar] port_b(
        redeclare each package Medium = Medium,
        each m_flow(start=0, max=if allowFlowReversal then +Modelica.Constants.inf else 0)) 
    "Fluid connector b for medium (positive design flow direction is from port_a to port_b)"
    annotation (extent=[110,-10; 90,10]);
end PartialPipeManifold;
