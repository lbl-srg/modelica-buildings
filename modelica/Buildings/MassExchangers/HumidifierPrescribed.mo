model HumidifierPrescribed 
  "Ideal electric heater or cooler, no losses, no dynamics" 
  extends Fluids.Interfaces.PartialStaticTwoPortHeatMassTransfer;
  extends Buildings.BaseClasses.BaseIcon;
  annotation (Icon(
      Rectangle(extent=[-70,80; 70,-80], style(
          pattern=0,
          fillColor=71,
          rgbfillColor={85,170,255})),
      Rectangle(extent=[-102,5; 99,-5],   style(
          pattern=0,
          fillColor=0,
          rgbfillColor={0,0,0},
          fillPattern=1)),
      Text(
        extent=[-56,-12; 54,-72],
        style(color=3, rgbcolor={0,0,255}),
        string="m=%m0_flow"),
      Rectangle(extent=[-100,61; -70,58], style(
          color=3,
          rgbcolor={0,0,255},
          pattern=0,
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1)),
      Text(
        extent=[-144,114; -100,86],
        style(color=3, rgbcolor={0,0,255}),
        string="u"),
      Text(
        extent=[-140,-20; -96,-48],
        style(color=3, rgbcolor={0,0,255}),
        string="T"),
      Rectangle(extent=[-100,-59; -70,-62], style(
          color=3,
          rgbcolor={0,0,255},
          pattern=0,
          fillColor=1,
          rgbfillColor={255,0,0},
          fillPattern=1))),
Documentation(info="<html>
<p>
Model for an air humidifier or dehumidifier.
</p>
<p>
This model adds (or removes) moisture from the air stream.
The amount of exchanged moisture is equal to <tt>m_flow = u m0_flow</tt>.
The input signal <tt>u</tt> and the nominal moisture flow rate added to the air stream <tt>m0_flow</tt> can be positive or negative.
If the product <tt>u * m0_flow</tt> are positive, then moisture is added
to the air stream, otherwise it is removed.
</p>
<p>
<p>If the connector <tt>T_in</tt> is left unconnected, the value
set by the parameter <tt>T</tt> is used for temperature of the water that is 
added to the air stream.
</p>
<p>
Note that if the mass flow rate tends to zero, the moisture difference over this 
component tends to infinity for non-zero <tt>m_flow</tt>, so add proper control
when using this component.
</p>
<p>
This model can only be used with medium models that define the integer constant
<tt>Water</tt> which needs to be equal to the index of the water mass fraction 
in the species vector.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 17, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  
  parameter Modelica.SIunits.MassFlowRate m0_flow 
    "Water mass flow rate at u=1, positive for humidification";
  parameter Modelica.SIunits.Temperature T = 293.15 
    "Temperature of water that is added to the fluid stream (used only if T_in is unconnected)";
  Modelica.Blocks.Interfaces.RealInput T_in(
    redeclare type SignalType = Modelica.SIunits.Temperature) 
    "Temperature of water added to the fluid stream" 
    annotation (extent=[-140,-80; -100,-40]);
  Modelica.Blocks.Interfaces.RealInput u annotation (extent=[-140,40; -100,80]);
protected 
  constant Modelica.SIunits.MassFraction[Medium.nXi] XiWat = {1} 
    "Mass fraction of water";
  Modelica.SIunits.MassFlowRate mWat_flow "Water flow rate";
equation 
  if cardinality(T_in)==0 then
    T_in = T;
  end if;
  
  dp = 0;
  mWat_flow = u * m0_flow;
  Q_flow = Medium.enthalpyOfLiquid(T_in) * mWat_flow;
  for i in 1:Medium.nXi loop
     mXi_flow[i] = if ( i == Medium.Water) then  mWat_flow else 0;
  end for;
end HumidifierPrescribed;
