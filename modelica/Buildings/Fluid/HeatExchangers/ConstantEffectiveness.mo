within Buildings.Fluid.HeatExchangers;
model ConstantEffectiveness "Heat exchanger with constant effectiveness"
  extends Buildings.Fluid.HeatExchangers.BaseClasses.PartialEffectiveness(
    sensibleOnly1 = true,
    sensibleOnly2 = true);
  parameter Real eps(start=0.8, min=0, max=1, unit="1")
    "Heat exchanger effectiveness";
equation
  // transfered heat
  Q1_flow = eps * QMax_flow;
  // no heat loss to ambient
  0 = Q1_flow + Q2_flow;
  // no mass exchange
  mXi1_flow = zeros(Medium1.nXi);
  mXi2_flow = zeros(Medium2.nXi);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
          extent={{-70,78},{70,-82}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid), Text(
          extent={{-56,-12},{54,-72}},
          lineColor={255,255,255},
          textString="eps=%eps")}),
          preferedView="info",
Documentation(info="<html>
<p>
Model for a heat exchanger with constant effectiveness.
</p>
<p>
This model transfers heat in the amount of 
<p align=\"center\" style=\"font-style:italic;\">
  Q = Q<sub>max</sub> &epsilon;,
</p>
where <i>&epsilon;</i> is a constant effectiveness and 
<i>Q<sub>max</sub></i> is the maximum heat that can be transferred.
</p>
<p>
In the region <code>mK_flow_small > abs(mK_flow) > mK_flow_small/2</code>, for <code>K = 1</code> or
<code>2</code>, the effectivness <code>eps</code> is transitioned from 
its user-specified value to 0. This improves the numerical robustness near
zero flow.
</p>
<p>
For a heat and moisture exchanger, use
<a href=\"modelica://Buildings.Fluid.MassExchangers.ConstantEffectiveness\">
Buildings.Fluid.MassExchangers.ConstantEffectiveness</a>
instead of this model.
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
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),     graphics));
end ConstantEffectiveness;
