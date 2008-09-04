model PipeManifoldNoResistance "Manifold for heat exchanger register" 
  extends PartialPipeManifold;
annotation (Diagram,
Documentation(info="<html>
<p>
Pipe manifold without flow resistance.</p>
</p>
<p>
This model connects the flows between the ports without 
modeling flow friction. The model is used in conjunction with
a manifold which contains pressure drop elements and that
is added to the other side of the heat exchanger registers.
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
 parameter Boolean connectAllPressures=true;
equation 
  for i in 1:nPipPar loop
   if (connectAllPressures == true) then
     port_a.p = port_b[i].p;
   end if;
    port_a.h = port_b[i].h;
    port_a.Xi = port_b[i].Xi;
    port_a.C = port_b[i].C;
  end for;
   if (connectAllPressures == false) then
     port_a.p = port_b[1].p;
        for i in 2:nPipPar loop
          port_b[1].m_flow = port_b[i].m_flow;
        end for;
   end if;
  
   port_a.m_flow + sum(port_b[i].m_flow for i in 1:nPipPar) = 0;
   port_a.H_flow + sum(port_b[i].H_flow  for i in 1:nPipPar) = 0;
   port_a.mXi_flow + sum(port_b[i].mXi_flow for i in 1:nPipPar) = zeros(Medium.nXi);
   port_a.mC_flow + sum(port_b[i].mC_flow for i in 1:nPipPar) = zeros(Medium.nC);
end PipeManifoldNoResistance;
