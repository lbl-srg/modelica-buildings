within Buildings.Fluid.Interfaces;
partial model PartialStaticTwoPortHeatMassTransfer
  "Partial model transporting fluid between two ports without storing mass or energy"
  extends Buildings.Fluid.Interfaces.PartialStaticTwoPortInterface(
  showDesignFlowDirection = false);
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(dp_nominal > Modelica.Constants.eps));
  import Modelica.Constants;

  Modelica.SIunits.HeatFlowRate Q_flow "Heat transfered into the medium";
  Medium.MassFlowRate mXi_flow[Medium.nXi]
    "Mass flow rates of independent substances added to the medium";
protected
  constant Boolean sensibleOnly "Set to true if sensible exchange only";
equation
  // Energy balance (no storage, no heat loss/gain)
  port_a.m_flow*port_a.h_outflow + port_b.m_flow*inStream(port_b.h_outflow) = -Q_flow;
  port_a.m_flow*port_b.h_outflow + port_b.m_flow*inStream(port_a.h_outflow) =  Q_flow;

  // Mass balance (no storage)
  port_a.m_flow + port_b.m_flow = -sum(mXi_flow);

  // Species balance, mXi_flow is ignored by this model
  if sensibleOnly then
    port_a.Xi_outflow = inStream(port_b.Xi_outflow);
    port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  else
    port_a.m_flow*port_a.Xi_outflow + port_b.m_flow*inStream(port_b.Xi_outflow) = -mXi_flow;
    port_a.m_flow*port_b.Xi_outflow + port_b.m_flow*inStream(port_a.Xi_outflow) = mXi_flow;
  end if;
  // Transport of trace substances
  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);

  // Pressure drop calculation
  if computeFlowResistance then
   if from_dp then
      m_flow = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
         dp=dp, k=m_flow_nominal/sqrt(dp_nominal), m_flow_turbulent=deltaM * m_flow_nominal,
         linearized=linearizeFlowResistance);
   else
      dp = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
         m_flow=m_flow, k=m_flow_nominal/sqrt(dp_nominal), m_flow_turbulent=deltaM * m_flow_nominal,
         linearized=linearizeFlowResistance);
   end if;
  else
    dp = 0;
  end if;

  annotation (
    preferedView="info",
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics),
    Documentation(info="<html>
<p>
This component transports fluid between its two ports, without
storing mass or energy. It is based on 
<tt>Modelica.Fluid.Interfaces.PartialTwoPortTransport</tt> but it does
use a different implementation for handling reverse flow because
in this component, mass flow rate can be added or removed from
the medium.
<p>
Depending on the parameter settings, this component computes
pressure drop due to flow friction.
The pressure drop is defined by a quadratic function that goes through
the point <tt>(m_flow_nominal, dp_nominal)</tt>. At <tt>|m_flow| &lt; deltaM * m_flow_nominal</tt>,
the pressure drop vs. flow relation is linearized.
If the parameter <tt>linearizeFlowResistance</tt> is set to true,
then the whole pressure drop vs. flow resistance curve is linearized.
</p>
<p>
When using this partial component, an equation for 
the energy and mass balances need to be added, such as
<pre>
  mWat_flow = u * m_flow_nominal;
  Q_flow = Medium.enthalpyOfLiquid(TWat) * mWat_flow;
  for i in 1:Medium.nXi loop
     mXi_flow[i] = if ( i == Medium.Water) then  mWat_flow else 0;
  end for;
</pre>
</p>
</html>", revisions="<html>
<ul>
<li>
March 22, 2010, by Michael Wetter:<br>
Added constant <code>sensibleOnly</code> to 
simplify species balance equation.
</li>
<li>
April 10, 2009, by Michael Wetter:<br>
Added model to compute flow friction.
</li>
<li>
April 22, 2008, by Michael Wetter:<br>
Revised to add mass balance.
</li>
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
end PartialStaticTwoPortHeatMassTransfer;
