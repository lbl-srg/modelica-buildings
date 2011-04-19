within Buildings.Fluid.Interfaces;
model PartialStaticTwoPortHeatMassTransfer
  "Partial model transporting fluid between two ports without storing mass or energy"
  extends Buildings.Fluid.Interfaces.PartialStaticTwoPortInterface(
  showDesignFlowDirection = false);
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(dp_nominal > Modelica.Constants.eps));
  import Modelica.Constants;

  input Modelica.SIunits.HeatFlowRate Q_flow "Heat transfered into the medium";
  input Medium.MassFlowRate mXi_flow[Medium.nXi]
    "Mass flow rates of independent substances added to the medium";
  constant Boolean sensibleOnly "Set to true if sensible exchange only";
protected
  Real m_flowInv(unit="s/kg") "Regularization of 1/m_flow";
equation
  // Regularization of m_flow around the origin to avoid a division by zero
/*  m_flowInv = smooth(2, if (abs(port_a.m_flow) > m_flow_small/1E3) then 
      1/port_a.m_flow
      else 
      Buildings.Utilities.Math.Functions.inverseXRegularized(x=port_a.m_flow, delta=m_flow_small/1E3));
 */
 m_flowInv = Buildings.Utilities.Math.Functions.inverseXRegularized(x=port_a.m_flow, delta=m_flow_small/1E3);
  //////////////////////////////////////////////////////////////////////////////////////////
  // Energy balance and mass balance
  if sensibleOnly then
    // Mass balance
    port_a.m_flow = -port_b.m_flow;
    // Energy balance
    port_b.h_outflow = inStream(port_a.h_outflow) + Q_flow * m_flowInv;
    port_a.h_outflow = inStream(port_b.h_outflow) - Q_flow * m_flowInv;

    // Transport of species
    port_a.Xi_outflow = inStream(port_b.Xi_outflow);
    port_b.Xi_outflow = inStream(port_a.Xi_outflow);

    // Transport of trace substances
    port_a.C_outflow = inStream(port_b.C_outflow);
    port_b.C_outflow = inStream(port_a.C_outflow);

  else
    // Mass balance (no storage)
    port_a.m_flow + port_b.m_flow = -sum(mXi_flow);

    // Energy balance.
    // This equation is approximate since m_flow = port_a.m_flow is used for the mass flow rate
    // at both ports. Since mXi_flow << m_flow, the error is small.
    port_b.h_outflow = inStream(port_a.h_outflow) + Q_flow * m_flowInv;
    port_a.h_outflow = inStream(port_b.h_outflow) - Q_flow * m_flowInv;

    // Transport of species
    for i in 1:Medium.nXi loop
      port_b.Xi_outflow[i] = inStream(port_a.Xi_outflow[i]) + mXi_flow[i] * m_flowInv;
      port_a.Xi_outflow[i] = inStream(port_b.Xi_outflow[i]) - mXi_flow[i] * m_flowInv;
    end for;
    // Transport of trace substances
    for i in 1:Medium.nC loop
      port_a.m_flow*port_a.C_outflow[i] = -port_b.m_flow*inStream(port_b.C_outflow[i]);
      port_b.m_flow*port_b.C_outflow[i] = -port_a.m_flow*inStream(port_a.C_outflow[i]);
    end for;
  end if; // sensibleOnly
  //////////////////////////////////////////////////////////////////////////////////////////
  // Pressure drop calculation
  if computeFlowResistance then
    if homotopyInitialization then
      if from_dp then
        m_flow = homotopy(actual=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
                                    dp=dp,
                                    k=m_flow_nominal/sqrt(dp_nominal),
                                    m_flow_turbulent=deltaM * m_flow_nominal,
                                    linearized=linearizeFlowResistance),
                          simplified=m_flow_nominal*dp/dp_nominal);
      else
        dp = homotopy(actual=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
                                    m_flow=m_flow,
                                    k=m_flow_nominal/sqrt(dp_nominal),
                                    m_flow_turbulent=deltaM * m_flow_nominal,
                                    linearized=linearizeFlowResistance),
                      simplified=dp_nominal*m_flow/m_flow_nominal);
      end if;
    else // do not use homotopy
      if from_dp then
        m_flow = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
                                    dp=dp,
                                    k=m_flow_nominal/sqrt(dp_nominal),
                                    m_flow_turbulent=deltaM * m_flow_nominal,
                                    linearized=linearizeFlowResistance);
      else
        dp = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
                                    m_flow=m_flow,
                                    k=m_flow_nominal/sqrt(dp_nominal),
                                    m_flow_turbulent=deltaM * m_flow_nominal,
                                    linearized=linearizeFlowResistance);
      end if;
    end if; // homotopyInitialization
  else // do not compute flow resistance
    dp = 0;
  end if; // computeFlowResistance

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
<a href=\"modelica://Modelica.Fluid.Interfaces.PartialTwoPortTransport\">
Modelica.Fluid.Interfaces.PartialTwoPortTransport</a> but it does
use a different implementation for handling reverse flow because
in this component, mass flow rate can be added or removed from
the medium.
<p>
Depending on the parameter settings, this component computes
pressure drop due to flow friction.
The pressure drop is defined by a quadratic function that goes through
the point <code>(m_flow_nominal, dp_nominal)</code>. At <code>|m_flow| &lt; deltaM * m_flow_nominal</code>,
the pressure drop vs. flow relation is linearized.
If the parameter <code>linearizeFlowResistance</code> is set to true,
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
March 29, 2011, by Michael Wetter:<br>
Changed energy and mass balance to avoid a division by zero if <code>m_flow=0</code>.
</li>
<li>
March 27, 2011, by Michael Wetter:<br>
Added <code>homotopy</code> operator.
</li>
<li>
August 19, 2010, by Michael Wetter:<br>
Fixed bug in energy and moisture balance that affected results if a component
adds or removes moisture to the air stream. 
In the old implementation, the enthalpy and species
outflow at <code>port_b</code> was multiplied with the mass flow rate at 
<code>port_a</code>. The old implementation led to small errors that were proportional
to the amount of moisture change. For example, if the moisture added by the component
was <code>0.005 kg/kg</code>, then the error was <code>0.5%</code>.
Also, the results for forward flow and reverse flow differed by this amount.
With the new implementation, the energy and moisture balance is exact.
</li>
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
