within Buildings.Fluid.Interfaces;
partial model PartialStaticFourPortHeatMassTransfer
  "Partial model transporting two fluid streams between four ports without storing mass or energy"
  extends Buildings.Fluid.Interfaces.PartialStaticFourPortInterface;
  extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
   final computeFlowResistance1=(dp1_nominal > Modelica.Constants.eps),
   final computeFlowResistance2=(dp2_nominal > Modelica.Constants.eps));
  import Modelica.Constants;

  Modelica.SIunits.HeatFlowRate Q1_flow "Heat transfered into the medium 1";
  Medium1.MassFlowRate mXi1_flow[Medium1.nXi]
    "Mass flow rates of independent substances added to the medium 1";
  Modelica.SIunits.HeatFlowRate Q2_flow "Heat transfered into the medium 2";
  Medium2.MassFlowRate mXi2_flow[Medium2.nXi]
    "Mass flow rates of independent substances added to the medium 2";

protected
  constant Boolean sensibleOnly1
    "Set to true if sensible exchange only for medium 1";
  constant Boolean sensibleOnly2
    "Set to true if sensible exchange only for medium 2";
equation
  // Energy balance (no storage, no heat loss/gain)
  port_a1.m_flow*port_a1.h_outflow + port_b1.m_flow*inStream(port_b1.h_outflow) = -Q1_flow;
  port_a1.m_flow*port_b1.h_outflow + port_b1.m_flow*inStream(port_a1.h_outflow) =  Q1_flow;
  port_a2.m_flow*port_a2.h_outflow + port_b2.m_flow*inStream(port_b2.h_outflow) = -Q2_flow;
  port_a2.m_flow*port_b2.h_outflow + port_b2.m_flow*inStream(port_a2.h_outflow) =  Q2_flow;

  // Mass balance (no storage)
  port_a1.m_flow + port_b1.m_flow = -sum(mXi1_flow);
  port_a2.m_flow + port_b2.m_flow = -sum(mXi2_flow);

  if sensibleOnly1 then
    port_a1.Xi_outflow = inStream(port_b1.Xi_outflow);
    port_b1.Xi_outflow = inStream(port_a1.Xi_outflow);
  else
    port_a1.m_flow*port_a1.Xi_outflow + port_b1.m_flow*inStream(port_b1.Xi_outflow) = -mXi1_flow;
    port_a1.m_flow*port_b1.Xi_outflow + port_b1.m_flow*inStream(port_a1.Xi_outflow) =  mXi1_flow;
  end if;
  if sensibleOnly2 then
    port_a2.Xi_outflow = inStream(port_b2.Xi_outflow);
    port_b2.Xi_outflow = inStream(port_a2.Xi_outflow);
  else
    port_a2.m_flow*port_a2.Xi_outflow + port_b2.m_flow*inStream(port_b2.Xi_outflow) = -mXi2_flow;
    port_a2.m_flow*port_b2.Xi_outflow + port_b2.m_flow*inStream(port_a2.Xi_outflow) =  mXi2_flow;
  end if;

  // Transport of trace substances
  port_a1.C_outflow = inStream(port_b1.C_outflow);
  port_b1.C_outflow = inStream(port_a1.C_outflow);
  port_a2.C_outflow = inStream(port_b2.C_outflow);
  port_b2.C_outflow = inStream(port_a2.C_outflow);

  // Pressure drop calculation
  // Medium 1
  if computeFlowResistance1 then
   if from_dp1 then
      m1_flow = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
         dp=dp1, k=m1_flow_nominal/sqrt(dp1_nominal), m_flow_turbulent=deltaM1 * m1_flow_nominal,
         linearized=linearizeFlowResistance1);
   else
      dp1 = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
         m_flow=m1_flow, k=m1_flow_nominal/sqrt(dp1_nominal), m_flow_turbulent=deltaM1 * m1_flow_nominal,
         linearized=linearizeFlowResistance1);
   end if;
  else
    dp1 = 0;
  end if;

  // Medium 2
  if computeFlowResistance2 then
   if from_dp2 then
      m2_flow = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
         dp=dp2, k=m2_flow_nominal/sqrt(dp2_nominal), m_flow_turbulent=deltaM2 * m2_flow_nominal,
         linearized=linearizeFlowResistance2);
   else
      dp2 = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
         m_flow=m2_flow, k=m2_flow_nominal/sqrt(dp2_nominal), m_flow_turbulent=deltaM2 * m2_flow_nominal,
         linearized=linearizeFlowResistance2);
   end if;
  else
    dp2 = 0;
  end if;

  annotation (
    preferedView="info",
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics),
    Documentation(info="<html>
<p>
This component transports two fluid streams between four ports, without
storing mass or energy. It is similar to
<a href=\"modelica://Buildings.Fluid.Interfaces.PartialStaticTwoPortHeatMassTransfer\">
Buildings.Fluid.Interfaces.PartialStaticTwoPortHeatMassTransfer</a>,
but it has four ports instead of two. See the documentation of 
<a href=\"modelica://Buildings.Fluid.Interfaces.PartialStaticTwoPortHeatMassTransfer\">
Buildings.Fluid.Interfaces.PartialStaticTwoPortHeatMassTransfer</a>
for how to use this partial model.
</p>
</html>", revisions="<html>
<ul>
<li>
March 22, 2010, by Michael Wetter:<br>
Added constants <code>sensibleOnly1</code> and
<code>sensibleOnly2</code> to 
simplify species balance equations.
</li>
<li>
April 13, 2009, by Michael Wetter:<br>
Added model to compute flow friction.
</li>
<li>
March 25, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,65},{101,55}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-55},{101,-65}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end PartialStaticFourPortHeatMassTransfer;
