within Buildings.Fluid.HeatExchangers;
model ConstantEffectiveness "Heat exchanger with constant effectiveness"
  extends Fluid.Interfaces.PartialStaticFourPortHeatMassTransfer;
  extends Buildings.BaseClasses.BaseIcon;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Text(
          extent={{-122,106},{-78,78}},
          lineColor={0,0,255},
          textString="u"),
        Rectangle(
          extent={{-70,78},{70,-82}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-56,-12},{54,-72}},
          lineColor={255,255,255},
          textString="eps=%eps")}),
Documentation(info="<html>
<p>
Model for a heat exchanger with constant effectiveness.
</p>
<p>
This model transfers heat in the amount of 
<pre>
  Q = Q_max * eps,
</pre>
where <tt>eps</tt> is a constant effectiveness and 
<tt>Q_max</tt> is the maximum heat that can be transferred.
</p>
<p>
For a heat and moisture exchanger, use
<a href=\"Modelica:Buildings.Fluid.MassExchangers.ConstantEffectiveness\">
Buildings.Fluid.MassExchangers.ConstantEffectiveness</a>
instead of this model.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 2, 2009, by Michael Wetter:<br>
Changed computation of inlet temperatures to use 
<code>state_*_inflow</code> which is already known in base class.
</li>
<li>
April 28, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics));
  parameter Real eps(min=0, max=1) = 0.8 "Heat exchanger effectiveness";

  Modelica.SIunits.Temperature T_in1 "Inlet temperature medium 1";
  Modelica.SIunits.Temperature T_in2 "Inlet temperature medium 2";
  Modelica.SIunits.ThermalConductance C1_flow
    "Heat capacity flow rate medium 1";
  Modelica.SIunits.ThermalConductance C2_flow
    "Heat capacity flow rate medium 2";
  Modelica.SIunits.ThermalConductance CMin_flow(min=0)
    "Minimum heat capacity flow rate";
  Modelica.SIunits.HeatFlowRate QMax_flow "Maximum heat flow rate";

equation
  // Definitions for heat transfer effectiveness model
  T_in1 = if m1_flow >= 0 then Medium1.temperature(state_a1_inflow) else 
                                Medium1.temperature(state_b1_inflow);
  T_in2 = if m2_flow >= 0 then Medium2.temperature(state_a2_inflow) else 
                                Medium2.temperature(state_b2_inflow);

  // The specific heat capacity is computed using the state of the
  // medium at port_a. For forward flow, this is correct, for reverse flow,
  // this is an approximation.
  C1_flow = abs(m1_flow) * Medium1.specificHeatCapacityCp(sta_a1);
  C2_flow = abs(m2_flow) * Medium2.specificHeatCapacityCp(sta_a2);

  CMin_flow = min(C1_flow, C2_flow);
  QMax_flow = CMin_flow * (T_in2 - T_in1);

  // transfered heat
  Q1_flow = eps * QMax_flow;
  0 = Q1_flow + Q2_flow;

  // no mass exchange
  mXi1_flow = zeros(Medium1.nXi);
  mXi2_flow = zeros(Medium2.nXi);

end ConstantEffectiveness;
