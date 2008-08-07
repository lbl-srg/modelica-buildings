model MixingVolume 
  "Mixing volume with inlet and outlet ports (flow reversal is allowed)" 
  extends BaseClasses.PartialMixingVolume;
  annotation (
    Documentation(info="<html>
Model for an ideally mixed fluid volume with <tt>nP</tt> ports and the ability 
to store mass and energy. The volume is fixed.
<p>
This model represents the same physics as 
<tt>Modelica_Fluid.Volumes.MixingVolume</tt>, but it allows to have more than 
two fluid ports. This is convenient for modeling the room volume in a 
building energy simulation since rooms often have more than two fluid connections, 
such as an HVAC inlet, outlet and a leakage flow to other rooms or the outside. 
If a fluid port is connected twice, the model will terminate the 
simulation with an error message.
</p>
<p>
The thermal port need not be connected, but can have any number of connections.
</p>
</html>", revisions="<html>
<ul>
<li>
August 6, 2008 by Michael Wetter:<br>
Introduced partial class.
</li>
<li>
March 14, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram);
equation 
// Mass and energy balance
  der(m) = sum(port[i].m_flow for i in 1:nP);
  der(mXi) = sum(port[i].mXi_flow for i in 1:nP);
  der(U) = sum(port[i].H_flow for i in 1:nP) + Qs_flow + Ws_flow;
end MixingVolume;
