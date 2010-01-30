within Buildings.Fluid.HeatExchangers.BaseClasses;
model ConstantEffectiveness "Heat exchanger with constant effectiveness"
  extends Fluid.Interfaces.PartialStaticFourPortHeatMassTransfer;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
          extent={{-70,78},{70,-82}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid)}),
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
In the region <tt>mK_flow_small > abs(mK_flow) > mK_flow_small/2</tt>, for <tt>K = 1</tt> or
<tt>2</tt>, the effectivness <tt>eps</tt> is transitioned from 
its user-specified value to 0. This improves the numerical robustness near
zero flow.
</p>
<p>
Classes that extend this model need to define the mass balance in a form like<pre>
  // no mass exchange
  mXi1_flow = zeros(Medium1.nXi);
  mXi2_flow = zeros(Medium2.nXi);
</pre>
</p>
</html>",
revisions="<html>
<ul>
<li>
January 28, 2010, by Michael Wetter:<br>
Added regularization near zero flow.
</li>
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
protected
  Real gai1(min=0, max=1) "Auxiliary variable for smoothing at zero flow";
  Real gai2(min=0, max=1) "Auxiliary variable for smoothing at zero flow";

equation
  // Definitions for heat transfer effectiveness model
  T_in1 = Modelica.Fluid.Utilities.regStep(m1_flow,
                  Medium1.temperature(state_a1_inflow),
                  Medium1.temperature(state_b1_inflow), m1_flow_small);
  T_in2 = Modelica.Fluid.Utilities.regStep(m2_flow,
                  Medium2.temperature(state_a2_inflow),
                  Medium2.temperature(state_b2_inflow), m2_flow_small);

  // Compute a gain that goes to zero near zero flow rate.
  // This is required to smoothen the heat transfer at very small flow rates.
  // Note that gaiK = 1 for abs(mK_flow) > mK_flow_small
  gai1 = Modelica.Fluid.Utilities.regStep(abs(m1_flow)- 0.75 * m1_flow_small, 1, 0, 0.25*m1_flow_small);
  gai2 = Modelica.Fluid.Utilities.regStep(abs(m2_flow)- 0.75 * m2_flow_small, 1, 0, 0.25*m2_flow_small);

  // The specific heat capacity is computed using the state of the
  // medium at port_a. For forward flow, this is correct, for reverse flow,
  // this is an approximation.
  C1_flow = smooth(1, gai1 * abs(m1_flow)) * Medium1.specificHeatCapacityCp(sta_a1);
  C2_flow = smooth(1, gai2 * abs(m2_flow)) * Medium2.specificHeatCapacityCp(sta_a2);
  CMin_flow = min(C1_flow, C2_flow);
  QMax_flow = CMin_flow * (T_in2 - T_in1);

  // transfered heat
  Q1_flow = eps * QMax_flow;
  0 = Q1_flow + Q2_flow;

end ConstantEffectiveness;
