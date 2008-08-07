model MixingVolumeLatent 
  "Mixing volume with heat port for latent heat exchange" 
  extends BaseClasses.PartialMixingVolume;
  annotation (Diagram, Icon( Text(
        extent=[-68,-20; 206,-62],
        string="Xi",
        style(
          color=7,
          rgbcolor={255,255,255},
          fillColor=0,
          rgbfillColor={0,0,0})),                          Text(
        extent=[-190,4; -36,-18],
        style(color=0),
        string="QLat"),                                    Text(
        extent=[-190,-60; -32,-88],
        style(color=0),
        string="TLiq")),
Documentation(info="<html>
Model for an ideally mixed fluid volume with <tt>nP</tt> ports and the ability 
to store mass and energy. The volume is fixed, and latent and sensible heat can be exchanged.
<p>
This model represents the same physics as 
<a href=\"Modelica:Buildings.Fluids.Components.MixingVolume\">
Buildings.Fluids.Components.MixingVolume</a>, but in addition, it allows
adding (or subtracting) latent heat, which causes a change in enthalpy and water
vapor concentration. The latent heat is assumed to be added or extracted at the
temperature of the input port <tt>TLiq</tt>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 7, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  Modelica.Blocks.Interfaces.RealOutput X_out[Medium.nX](redeclare type 
      SignalType = Medium.MassFraction) "Species composition of medium" 
    annotation (extent=[100,-80; 140,-40]);
  Medium.MassFlowRate mXi_flow[Medium.nXi] 
    "Mass flow rates of independent substances added to the medium";
  Modelica.Blocks.Interfaces.RealInput TLiq(redeclare type SignalType = 
        Modelica.SIunits.Temperature) 
    "Temperature of liquid that is drained from or injected into volume" 
    annotation (extent=[-140,-120; -100,-80]);
  Modelica.Blocks.Interfaces.RealInput QLat_flow(redeclare type SignalType = 
        Modelica.SIunits.HeatFlowRate) "Latent heat transfered into the medium"
    annotation (extent=[-140,-60; -100,-20]);
protected 
  Modelica.SIunits.MassFlowRate mWat_flow "Water flow rate";
equation 
  mWat_flow = QLat_flow / Medium.enthalpyOfLiquid(TLiq);
  for i in 1:Medium.nXi loop
     mXi_flow[i] = if ( i == Medium.Water) then mWat_flow else 0;
  end for;
  
// Mass and energy balance
  der(m) = sum(port[i].m_flow for i in 1:nP) + mWat_flow;
  der(mXi) = sum(port[i].mXi_flow for i in 1:nP) + mXi_flow;
  der(U) = sum(port[i].H_flow for i in 1:nP) + Qs_flow + Ws_flow
               + QLat_flow;
// Medium species concentration
  X_out = medium.X;
end MixingVolumeLatent;
