within Buildings.Fluid.Interfaces;
model StaticTwoPortHeatMassExchanger
  "Partial model transporting fluid between two ports without storing mass or energy"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
  showDesignFlowDirection = false,
  final show_T=true);
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));
  import Modelica.Constants;
  input Modelica.SIunits.HeatFlowRate Q_flow "Heat transfered into the medium";
  input Medium.MassFlowRate mXi_flow[Medium.nXi]
    "Mass flow rates of independent substances added to the medium";
  constant Boolean sensibleOnly "Set to true if sensible exchange only";
  // Outputs that are needed in models that extend this model
  Modelica.Blocks.Interfaces.RealOutput hOut(unit="J/kg")
    "Leaving temperature of the component";
  Modelica.Blocks.Interfaces.RealOutput XiOut[Medium.nXi](unit="1")
    "Leaving species concentration of the component";
  Modelica.Blocks.Interfaces.RealOutput COut[Medium.nC](unit="1")
    "Leaving trace substances of the component";
  constant Boolean use_safeDivision=true
    "Set to true to improve numerical robustness";
protected
  Real m_flowInv(unit="s/kg") "Regularization of 1/m_flow";
  final parameter Real k(unit="")=if computeFlowResistance
   then abs(m_flow_nominal)/sqrt(abs(dp_nominal)) else 0
    "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  final parameter Real kLin(unit="") = if computeFlowResistance
   then abs(m_flow_nominal/dp_nominal) else 0;
equation
  // Regularization of m_flow around the origin to avoid a division by zero
/*  m_flowInv = smooth(2, if (abs(port_a.m_flow) > m_flow_small/1E3) then 
      1/port_a.m_flow
      else 
      Buildings.Utilities.Math.Functions.inverseXRegularized(x=port_a.m_flow, delta=m_flow_small/1E3));
 */
 if use_safeDivision then
    m_flowInv = Buildings.Utilities.Math.Functions.inverseXRegularized(x=port_a.m_flow, delta=m_flow_small/1E3);
 else
     m_flowInv = 1/port_a.m_flow;
 end if;
 if allowFlowReversal then
/* This formulation fails to simulate in Buildings.Fluid.MixingVolumes.Examples.MixingVolumePrescribedHeatFlowRate. See also Dynasim ticket 13596
   if (port_a.m_flow >= 0) then
     hOut =  port_b.h_outflow;
     XiOut = port_b.Xi_outflow;
     COut =  port_b.C_outflow;
    else
     hOut =  port_a.h_outflow;
     XiOut = port_a.Xi_outflow;
     COut =  port_a.C_outflow;
    end if;
*/
   hOut = smooth(0, if (port_a.m_flow >= 0) then
      port_b.h_outflow else
      port_a.h_outflow);
   XiOut = smooth(0, if (port_a.m_flow >= 0) then
      port_b.Xi_outflow else
      port_a.Xi_outflow);
   COut = smooth(0, if (port_a.m_flow >= 0) then
      port_b.C_outflow else
      port_a.C_outflow);

 else
   hOut =  port_b.h_outflow;
   XiOut = port_b.Xi_outflow;
   COut =  port_b.C_outflow;
 end if;
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
    if linearizeFlowResistance then
      m_flow = kLin*dp;
    else
      if homotopyInitialization then
        if from_dp then
           m_flow = homotopy(actual=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
                                    dp=dp,
                                    k=k,
                                    m_flow_turbulent=deltaM * m_flow_nominal),
                                    simplified=m_flow_nominal*dp/dp_nominal);
         else
           dp = homotopy(actual=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
                                    m_flow=m_flow,
                                    k=k,
                                    m_flow_turbulent=deltaM * m_flow_nominal),
                                    simplified=dp_nominal*m_flow/m_flow_nominal);
        end if; // from_dp
      else // do not use homotopy
        if from_dp then
          m_flow = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
                                    dp=dp,
                                    k=k,
                                    m_flow_turbulent=deltaM * m_flow_nominal);
        else
          dp = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
                                    m_flow=m_flow,
                                    k=k,
                                    m_flow_turbulent=deltaM * m_flow_nominal);
        end if; // from_dp
      end if; // homotopyInitialization
    end if; // linearized
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
</p>
<p>
If <code>dp_nominal &gt; Modelica.Constants.eps</code>, this component computes
pressure drop due to flow friction.
The pressure drop is defined by a quadratic function that goes through
the point <code>(m_flow_nominal, dp_nominal)</code>. At <code>|m_flow| &lt; deltaM * m_flow_nominal</code>,
the pressure drop vs. flow relation is linearized.
If the parameter <code>linearizeFlowResistance</code> is set to true,
then the whole pressure drop vs. flow resistance curve is linearized.
</p>
<h4>Implementation</h4>
<p>
This model uses inputs and constants that need to be set by models
that extend or instantiate this model.
The following inputs need to be assigned:
<ul>
<li>
<code>Q_flow</code>, which is the heat flow rate added to the medium.
</li>
<li>
<code>mXi_flow</code>, which is the species mass flow rate added to the medium.
</li>
</ul>
</p>
<p>
Set the constant <code>sensibleOnly=true</code> if the model that extends
or instantiates this model sets <code>mXi_flow = zeros(Medium.nXi)</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 19, 2011, by Michael Wetter:<br>
Changed assignment of <code>hOut</code>, <code>XiOut</code> and
<code>COut</code> to declare that it is not differentiable.
</li>
<li>
August 4, 2011, by Michael Wetter:<br>
Moved linearized pressure drop equation from the function body to the equation
section. With the previous implementation, 
the symbolic processor may not rearrange the equations, which can lead 
to coupled equations instead of an explicit solution.
</li>
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
end StaticTwoPortHeatMassExchanger;
