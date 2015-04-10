within Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses;
model MassFlowRateMultiplier "Model that multiplies the mass flow rate"
  extends Modelica.Fluid.Interfaces.PartialTwoPort;

  parameter Real k "Gain for mass flow rate";
initial equation
  assert( k > Modelica.Constants.small or -k < -Modelica.Constants.small,
    "Gain must not be zero. Received k = " + String(k));
equation
    // Pressure drop in design flow direction
  port_a.p = port_b.p;

  // Mass balance (mass is not conserved by this model!)
 port_b.m_flow = -k*port_a.m_flow;

  // Specific enthalpy flow rate
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);
  // Transport of substances
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);

  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);

  annotation (Documentation(info="<html>
<p>
This model multiplies the mass flow rate so that
<code>0 = port_b.m_flow + k * port_a.m_flow</code>.
</p>
<p>
The specific enthalpy, the species concentration and the trace substance concentration
remains unchanged.
Therefore, this model does not conserve mass or energy.
It is used in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab</a>
to avoid having to instanciate multiple slab models in parallel, with each
having the same mass flow rate and temperatures.
</p>
</html>", revisions="<html>
<ul>
<li>
March 27, 2013, by Michael Wetter:<br/>
Changed implementation to extend from <code>Modelica.Fluid</code>.
</li>
<li>
June 27, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={255,237,228},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
                          Polygon(
          points={{-100,8},{100,20},{100,-20},{-100,-8},{-100,8}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-144,-38},{156,-78}},
          textString="%name",
          lineColor={0,0,255})}));
end MassFlowRateMultiplier;
