partial model PartialMixingVolumeWaterPort 
  "Partial mixing volume that allows adding or subtracting water vapor" 
  extends PartialMixingVolume;
  annotation (
    Documentation(info="<html>
Model for an ideally mixed fluid volume with <tt>nP</tt> ports and the ability 
to store mass and energy. The volume is fixed. 
<p>
This model represents the same physics as 
<a href=\"Modelica:Buildings.Fluids.Components.BaseClasses.PartialMixingVolume\">
Buildings.Fluids.Components.BaseClasses.PartialMixingVolume</a> but in addition,
it allows to connect signals for the water exchanged with the volume.
The model is partial in order to allow a submodel that can be used with media
that contain water as a substance, and a submodel that can be used with dry air.
Having separate models is required because calls to the medium property function
<tt>enthalpyOfLiquid</tt> results in a linker error if a medium such as 
<a href=\"Modelica:Modelica.Media.Air.SimpleAir\">Modelica.Media.Air.SimpleAir</a>
is used that does not implement this function.
</p>
</html>", revisions="<html>
<ul>
<li>
August 12, 2008 by Michael Wetter:<br>
Introduced option to compute model in steady state. This allows the heat exchanger model
to switch from a dynamic model for the medium to a steady state model.
</li>
<li>
August 13, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"), Diagram, 
    Icon(                    Text(
        extent=[-76,-6; 198,-48],
        style(
          color=7,
          rgbcolor={255,255,255},
          fillColor=0,
          rgbfillColor={0,0,0}),
        string="XWat"),                                    Text(
        extent=[-164,18; -10,-4],
        style(color=0),
        string="mWat_flow"),                               Text(
        extent=[-180,-46; -22,-74],
        style(color=0),
        string="TWat")));
  Modelica.Blocks.Interfaces.RealInput mWat_flow(redeclare type SignalType = 
        Modelica.SIunits.MassFlowRate) "Water flow rate added into the medium" 
    annotation (extent=[-140,-40; -100,0]);
  Modelica.Blocks.Interfaces.RealInput TWat(redeclare type SignalType = 
        Modelica.SIunits.Temperature) 
    "Temperature of liquid that is drained from or injected into volume" 
    annotation (extent=[-140,-100; -100,-60]);
  Modelica.Blocks.Interfaces.RealOutput XWat(redeclare type SignalType = 
        Modelica.SIunits.MassFraction) "Species composition of medium" 
    annotation (extent=[100,-60; 140,-20]);
  Medium.MassFlowRate mXi_flow[Medium.nXi] 
    "Mass flow rates of independent substances added to the medium";
  Modelica.SIunits.HeatFlowRate HWat_flow 
    "Enthalpy flow rate of extracted water";
equation 
// Mass and energy balance
  if steadyState then
    0 = sum(port[i].m_flow for i in 1:nP) + mWat_flow;
    zeros(Medium.nXi) = sum(port[i].mXi_flow for i in 1:nP) + mXi_flow;
    0 = sum(port[i].H_flow for i in 1:nP) + Qs_flow + Ws_flow
               + HWat_flow;
  else
    der(m) = sum(port[i].m_flow for i in 1:nP) + mWat_flow;
    der(mXi) = sum(port[i].mXi_flow for i in 1:nP) + mXi_flow;
    der(U) = sum(port[i].H_flow for i in 1:nP) + Qs_flow + Ws_flow
               + HWat_flow;
  end if;
end PartialMixingVolumeWaterPort;
