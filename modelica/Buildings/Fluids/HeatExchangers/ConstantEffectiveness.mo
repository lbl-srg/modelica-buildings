within Buildings.Fluids.HeatExchangers;
model ConstantEffectiveness "Heat exchanger with constant effectiveness"
  extends Fluids.Interfaces.PartialStaticFourPortHeatMassTransfer;
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
<a href=\"Modelica:Buildings.Fluids.MassExchangers.ConstantEffectiveness\">
Buildings.Fluids.MassExchangers.ConstantEffectiveness</a>
instead of this model.
</p>
</html>",
revisions="<html>
<ul>
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
  Modelica.SIunits.ThermalConductance C_flow_1
    "Heat capacity flow rate medium 1";
  Modelica.SIunits.ThermalConductance C_flow_2
    "Heat capacity flow rate medium 2";
  Modelica.SIunits.ThermalConductance CMin_flow(min=0)
    "Minimum heat capacity flow rate";
  Modelica.SIunits.HeatFlowRate QMax_flow "Maximum heat flow rate";

equation
  // Definitions for heat transfer effectiveness model
  T_in1 = if m_flow_1 >= 0 then sta_a1.T else sta_b1.T;
  T_in2 = if m_flow_2 >= 0 then sta_a2.T else sta_b2.T;

  // The specific heat capacity is computed using the state of the
  // medium at port_a. For forward flow, this is correct, for reverse flow,
  // this is an approximation.
  C_flow_1 = abs(m_flow_1)* Medium_1.specificHeatCapacityCp(sta_a1);
  C_flow_2 = abs(m_flow_2)* Medium_2.specificHeatCapacityCp(sta_a2);

  CMin_flow = min(C_flow_1, C_flow_2);
  QMax_flow = CMin_flow * (T_in2 - T_in1);

  // transferred heat
  Q_flow_1 = eps * QMax_flow;
  0 = Q_flow_1 + Q_flow_2;

  // no mass exchange
  mXi_flow_1 = zeros(Medium_1.nXi);
  mXi_flow_2 = zeros(Medium_2.nXi);

  // no pressure drop
  dp_1 = 0;
  dp_2 = 0;
end ConstantEffectiveness;
