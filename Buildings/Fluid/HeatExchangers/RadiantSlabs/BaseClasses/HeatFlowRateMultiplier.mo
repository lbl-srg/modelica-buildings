within Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses;
model HeatFlowRateMultiplier "Multiplies the heat flow rate"

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    annotation (Placement(transformation(extent={{-110,10},{-90,-10}}),
        iconTransformation(extent={{-110,10},{-90,-10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));
  parameter Real k "Gain for mass flow rate";
initial equation
  assert( k > Modelica.Constants.small or -k < -Modelica.Constants.small,
    "Gain must not be zero. Received k = " + String(k));
equation
  // Energy balance. (Energy is not conserved by this model!)
  port_b.Q_flow = -k*port_a.Q_flow;
  port_a.T = port_b.T;
  annotation (    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Line(
          points={{0,90},{0,40}},
          color={181,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={255,237,228},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
                          Polygon(
          points={{-100,8},{100,20},{100,-20},{-100,-8},{-100,8}},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-144,-42},{156,-82}},
          textString="%name",
          textColor={0,0,255})}),
    Documentation(info="<html>
<p>
This model multiplies the heat flow rate so that
<code>0 = port_b.Q_flow + k * port_a.Q_flow</code>.
</p>
<p>
The temperature remains unchanged.
Therefore, this model does not conserve energy.
It is used in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab</a>
to avoid having to instanciate multiple slab models in parallel, with each
having the same mass flow rate and temperatures.
</p>
</html>"));
end HeatFlowRateMultiplier;
