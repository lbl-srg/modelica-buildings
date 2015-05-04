within Buildings.Fluid.HeatExchangers.BaseClasses;
model PipeManifoldFlowDistributor
  "Manifold for heat exchanger register that distributes the mass flow rate equally"
  extends PartialPipeManifold;

equation
    // mass and momentum balance
  port_b[1].m_flow = -port_a.m_flow/nPipPar;

  for i in 2:nPipPar loop
    port_b[i].m_flow = port_b[1].m_flow;
  end for;

  port_b[1].p = port_a.p;

  for i in 1:nPipPar loop
    inStream(port_a.h_outflow)  = port_b[i].h_outflow;
    inStream(port_a.Xi_outflow) = port_b[i].Xi_outflow;
    inStream(port_a.C_outflow)  = port_b[i].C_outflow;
  end for;
  port_a.h_outflow  = sum(inStream(port_b[i].h_outflow) for i in 1:nPipPar)/nPipPar;
  port_a.Xi_outflow = sum(inStream(port_b[i].Xi_outflow) for i in 1:nPipPar)/nPipPar;
  port_a.C_outflow  = sum(inStream(port_b[i].C_outflow) for i in 1:nPipPar)/nPipPar;

annotation (Documentation(info="<html>
<p>
This model distributes the mass flow rates equally between all instances
of <code>port_b</code>.
</p>
<p>
This model connects the flows between the ports without
modeling flow friction.
The model assigns an equal mass flow rate to each element of
<code>port_b</code>.
The model is used in conjunction with
a manifold that
is added to the other side of the heat exchanger registers.
</p>
<p>
<b>Note:</b> It is important that there is an equal pressure drop
in each flow leg between this model, and the model that collects the flows.
Otherwise, no solution may exist, and therefore the simulation may
stop with an error.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 29, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Polygon(
          points={{26,48},{50,72},{54,72},{30,48},{26,48}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Polygon(
          points={{26,-12},{50,12},{54,12},{30,-12},{26,-12}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Polygon(
          points={{26,-72},{50,-48},{54,-48},{30,-72},{26,-72}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255})}));
end PipeManifoldFlowDistributor;
