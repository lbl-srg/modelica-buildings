within Buildings.Fluids.Interfaces;
partial model PartialStaticFourPortHeatMassTransfer
  "Partial element transporting two fluid streams between four ports without storing mass or energy"
  extends Buildings.Fluids.Interfaces.PartialStaticFourPortInterface;
  import Modelica.Constants;

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics),
    Documentation(info="<html>
<p>
This component transports two fluid streams between four ports, without
storing mass or energy. It is similar to
<a href=\"Modelica:Buildings.Fluids.Interfaces.PartialStaticTwoPortHeatMassTransfer\">
Buildings.Fluids.Interfaces.PartialStaticTwoPortHeatMassTransfer</a>,
but it has four ports instead of two. See the documentation of the
<a href=\"Modelica:Buildings.Fluids.Interfaces.PartialStaticTwoPortHeatMassTransfer\">
Buildings.Fluids.Interfaces.PartialStaticTwoPortHeatMassTransfer</a>
for how to use this model.
</p>
</html>", revisions="<html>
<ul>
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

  Modelica.SIunits.HeatFlowRate Q1_flow "Heat transfered into the medium 1";
  Medium1.MassFlowRate mXi1_flow[Medium1.nXi]
    "Mass flow rates of independent substances added to the medium 1";
  Modelica.SIunits.HeatFlowRate Q2_flow "Heat transfered into the medium 2";
  Medium2.MassFlowRate mXi2_flow[Medium2.nXi]
    "Mass flow rates of independent substances added to the medium 2";
//  Real TInStr_a1=inStream(port_a1.h_outflow)/4200+298.15-273.15;
equation
  // Energy balance (no storage, no heat loss/gain)
  port_a1.m_flow*port_a1.h_outflow + port_b1.m_flow*inStream(port_b1.h_outflow) = -Q1_flow;
  port_a1.m_flow*port_b1.h_outflow + port_b1.m_flow*inStream(port_a1.h_outflow) =  Q1_flow;
  port_a2.m_flow*port_a2.h_outflow + port_b2.m_flow*inStream(port_b2.h_outflow) = -Q2_flow;
  port_a2.m_flow*port_b2.h_outflow + port_b2.m_flow*inStream(port_a2.h_outflow) =  Q2_flow;

  // Mass balance (no storage)
  port_a1.m_flow + port_b1.m_flow = -sum(mXi1_flow);
  port_a2.m_flow + port_b2.m_flow = -sum(mXi2_flow);

  port_a1.m_flow*port_a1.Xi_outflow + port_b1.m_flow*inStream(port_b1.Xi_outflow) = -mXi1_flow;
  port_a1.m_flow*port_b1.Xi_outflow + port_b1.m_flow*inStream(port_a1.Xi_outflow) =  mXi1_flow;
  port_a2.m_flow*port_a2.Xi_outflow + port_b2.m_flow*inStream(port_b2.Xi_outflow) = -mXi2_flow;
  port_a2.m_flow*port_b2.Xi_outflow + port_b2.m_flow*inStream(port_a2.Xi_outflow) =  mXi2_flow;

  // Transport of trace substances
  port_a1.C_outflow = inStream(port_b1.C_outflow);
  port_b1.C_outflow = inStream(port_a1.C_outflow);
  port_a2.C_outflow = inStream(port_b2.C_outflow);
  port_b2.C_outflow = inStream(port_a2.C_outflow);
end PartialStaticFourPortHeatMassTransfer;
