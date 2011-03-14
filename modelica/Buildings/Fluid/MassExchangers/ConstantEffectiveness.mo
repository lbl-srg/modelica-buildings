within Buildings.Fluid.MassExchangers;
model ConstantEffectiveness
  "Heat and moisture exchanger with constant effectiveness"
  extends Buildings.Fluid.HeatExchangers.BaseClasses.PartialEffectiveness(
  sensibleOnly1=false,
  sensibleOnly2=false);
  parameter Real epsS(min=0, max=1) = 0.8
    "Sensible heat exchanger effectiveness";
  parameter Real epsL(min=0, max=1) = 0.8 "Latent heat exchanger effectiveness";

  Medium1.MassFraction X_w_in1 "Inlet water mass fraction of medium 1";
  Medium2.MassFraction X_w_in2 "Inlet water mass fraction of medium 2";

  Modelica.SIunits.MassFlowRate mWat_flow
    "Water flow rate from medium 2 to medium 1";
  Modelica.SIunits.MassFlowRate mMax_flow
    "Maximum water flow rate from medium 2 to medium 1";

equation
  // transfered heat
  Q1_flow = epsS * QMax_flow;
  // no heat loss to ambient
  0 = Q1_flow + Q2_flow;
  // Definitions for effectiveness model
  X_w_in1 = Modelica.Fluid.Utilities.regStep(m1_flow,
                  state_a1_inflow.X[Medium1.Water],
                  state_b1_inflow.X[Medium1.Water], m1_flow_small);
  X_w_in2 = Modelica.Fluid.Utilities.regStep(m2_flow,
                  state_a2_inflow.X[Medium2.Water],
                  state_b2_inflow.X[Medium2.Water], m2_flow_small);

  // mass exchange
  mMax_flow = smooth(1, min(smooth(1, gai1 * abs(m1_flow)),
                            smooth(1, gai2 * abs(m2_flow)))) * (X_w_in2 - X_w_in1);
  mWat_flow = epsL * mMax_flow;

  for i in 1:Medium1.nXi loop
     mXi1_flow[i] = if ( i == Medium1.Water) then mWat_flow else 0;
  end for;

  for i in 1:Medium2.nXi loop
     mXi2_flow[i] = if ( i == Medium2.Water) then -mWat_flow else 0;
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,61},{-70,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-122,106},{-78,78}},
          lineColor={0,0,255},
          textString="u"),
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-62,50},{48,-10}},
          lineColor={255,255,255},
          textString="epsS=%epsS"),
        Text(
          extent={{-60,4},{50,-56}},
          lineColor={255,255,255},
          textString="epsL=%epsL")}),
          preferedView="info",
Documentation(info="<html>
<p>
Model for a heat and moisture exchanger with constant effectiveness.
</p>
<p>
This model transfers heat and moisture in the amount of 
<pre>
  Q = epsS * Q_max,
  m = epsL * mWat_max,
</pre>
where <code>epsS</code> and <code>epsL</code> are constant effectiveness 
for the sensible and latent heat transfer,  
<code>Q_max</code> is the maximum heat that can be transferred and
<code>mWat_max</code> is the maximum moisture that can be transferred.
</p>
<p>
In the region <code>mK_flow_small > abs(mK_flow) > mK_flow_small/2</code>, for <code>K = 1</code> or
<code>2</code>, the effectivness <code>epsS</code> and <code>epsL</code> are transitioned from 
their user-specified value to 0. This improves the numerical robustness near
zero flow.
</p>
<p>
For a sensible heat exchanger, use
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ConstantEffectiveness\">
Buildings.Fluid.HeatExchangers.ConstantEffectiveness</a>
instead of this model.
</p>
<p>
This model can only be used with medium models that define the integer constant
<code>Water</code> which needs to be equal to the index of the water mass fraction 
in the species vector.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 28, 2010, by Michael Wetter:<br>
Added regularization near zero flow.
</li>
<li>
October 21, 2008, by Michael Wetter:<br>
First implementation, based on 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ConstantEffectiveness\">
Buildings.Fluid.HeatExchangers.ConstantEffectiveness</a>.
</li>
</ul>
</html>"));
end ConstantEffectiveness;
