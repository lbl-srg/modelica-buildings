within Buildings.Fluids.Interfaces;
partial model PartialStaticTwoPortHeatMassTransfer
  "Partial element transporting fluid between two ports without storing mass or energy"
  extends Buildings.Fluids.Interfaces.PartialStaticTwoPortInterface;
  import Modelica.Constants;

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics),
    Documentation(info="<html>
<p>
This component transports fluid between its two ports, without
storing mass or energy. It is based on 
<tt>Modelica_Fluid.Interfaces.PartialTwoPortTransport</tt> but it does
use a different implementation for handling reverse flow because
in this component, mass flow rate can be added or removed from
the medium.
<p>
When using this partial component, an equation for the momentum
balance has to be added by specifying a relationship
between the pressure drop <tt>dp</tt> and the mass flow rate <tt>m_flow</tt> and 
the energy and mass balances, such as
<pre>
  dp = 0;
  mWat_flow = u * m0_flow;
  Q_flow = Medium.enthalpyOfLiquid(TWat) * mWat_flow;
  for i in 1:Medium.nXi loop
     mXi_flow[i] = if ( i == Medium.Water) then  mWat_flow else 0;
  end for;
</pre>
</p>
</html>", revisions="<html>
<ul>
<li>
April 22, 2008, by Michael Wetter:<br>
Revised to add mass balance.
<li>
March 17, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics));
  Modelica.SIunits.HeatFlowRate Q_flow "Heat transfered into the medium";
  Medium.MassFlowRate mXi_flow[Medium.nXi]
    "Mass flow rates of independent substances added to the medium";
equation
  // Energy balance (no storage, no heat loss/gain)
  port_a.m_flow*port_a.h_outflow + port_b.m_flow*inStream(port_b.h_outflow) = -Q_flow;
  port_a.m_flow*port_b.h_outflow + port_b.m_flow*inStream(port_a.h_outflow) =  Q_flow;

  // Mass balance (no storage)
  port_a.m_flow + port_b.m_flow = -sum(mXi_flow);

  port_a.m_flow*port_a.Xi_outflow + port_b.m_flow*inStream(port_b.Xi_outflow) = -mXi_flow;
  port_a.m_flow*port_b.Xi_outflow + port_b.m_flow*inStream(port_a.Xi_outflow) = mXi_flow;

  // Transport of trace substances
  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);
end PartialStaticTwoPortHeatMassTransfer;
