within Buildings.Fluid.HeatExchangers.BaseClasses;
model DuctManifoldFlowDistributor
  "Manifold for duct inlet that distributes the mass flow rate equally"
  extends PartialDuctManifold;

protected
  Medium.SpecificEnthalpy port_a_2_h_outflow[nPipSeg] "Outflowing enthalpies";
  Medium.MassFraction port_a_2_Xi_outflow[nPipSeg, Medium.nXi]
    "Outflowing mass fractions";
  Medium.ExtraProperty port_a_2_C_outflow[nPipSeg, Medium.nC]
    "Outflowing trace substances";

equation
  port_b[1, 1].m_flow = -port_a.m_flow/nPipPar/nPipSeg;
  for j in 2:nPipSeg loop
    port_b[1, j].m_flow = port_b[1, 1].m_flow;
  end for;
  for i in 2:nPipPar loop
    for j in 1:nPipSeg loop
      port_b[i, j].m_flow = port_b[1, 1].m_flow;
    end for;
  end for;

  port_b[1, 1].p = port_a.p;

  for i in 1:nPipPar loop
    for j in 1:nPipSeg loop
      inStream(port_a.h_outflow)  = port_b[i, j].h_outflow;
      inStream(port_a.Xi_outflow) = port_b[i, j].Xi_outflow;
      inStream(port_a.C_outflow)  = port_b[i, j].C_outflow;
    end for;
  end for;
  // As OpenModelica does not support multiple iterators as of August 2014, we
  // use here two sum(.) functions
  for j in 1:nPipSeg loop
    port_a_2_h_outflow[j] = sum(inStream(port_b[i, j].h_outflow) for i in 1:nPipPar)/nPipPar;
    port_a_2_Xi_outflow[j, 1:Medium.nXi] = sum(inStream(port_b[i, j].Xi_outflow[1:Medium.nXi]) for i in 1:nPipPar)/nPipPar;
    port_a_2_C_outflow[j, 1:Medium.nC] = sum(inStream(port_b[i, j].C_outflow[1:Medium.nC]) for i in 1:nPipPar)/nPipPar;
  end for;

  port_a.h_outflow                = sum(port_a_2_h_outflow[j] for j in 1:nPipSeg)/nPipSeg;
  port_a.Xi_outflow[1:Medium.nXi] = sum(port_a_2_Xi_outflow[j, 1:Medium.nXi] for j in 1:nPipSeg)/nPipSeg;
  port_a.C_outflow[1:Medium.nC]   = sum(port_a_2_C_outflow[j, 1:Medium.nC] for j in 1:nPipSeg)/nPipSeg;

annotation (Documentation(info="<html>
<p>
This model distributes the mass flow rates equally between all instances
of <code>port_b</code>.
</p>
<p>
The model connects the flows between the ports without
modeling flow friction.
The model is used in conjunction with
a manifold that
is added to the other side of the heat exchanger registers.
</p>
<p>
<b>Note:</b> It is important that there is an equal pressure drop
in each flow leg between this model, and the model that collects the flows.
Otherwise, no solution may exist. Hence, only use this model if you know
what you are doing.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 30, 2014, by Michael Wetter:<br/>
Reformulated model for OpenModelica.
</li>
<li>
August 10, 2014, by Michael Wetter:<br/>
Reformulated the multiple iterators in the <code>sum</code> function
as this language construct is not supported in OpenModelica.
</li>
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
end DuctManifoldFlowDistributor;
