partial model PartialTwoWayValve "Partial model for a two way valve" 
  extends PartialActuator(final m_small_flow = deltaM * k_SI * sqrt(dp0));
  annotation (Icon(                     Polygon(points=[-2,-2; -80,60; -80,-60;
            -2,-2], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=0,
          rgbfillColor={0,0,0})),
      Polygon(points=[-54,40; -2,-2; 54,40; 54,40; -54,40], style(
          pattern=0,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1)),
      Polygon(points=[-52,-40; -2,-2; 54,40; 50,-40; -52,-40], style(
          pattern=0,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1)),
                   Polygon(points=[-2,-2; 80,60; 80,-60; -2,-2], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=7,
          rgbfillColor={255,255,255}))),
Documentation(info="<html>
<p>
Partial model for a two way valve. This is the base model for valves
with different opening characteristics, such as linear, equal percentage
or quick opening.
</p><p>
The parameter <tt>k_SI</tt> is the flow coefficient in SI units, i.e., 
it is the ratio between mass flow rate in <tt>kg/s</tt> and square root 
of pressure drop in <tt>Pa</tt>.
</p><p>
To prevent the derivative <tt>d/dP (m_flow)</tt> to assume infinity near
the origin, this model linearizes the pressure drop vs. flow relation
ship. The region in which it is linearized is parameterized by 
<pre>m_small_flow = deltaM * k_SI * sqrt(dp0)
</pre>
Because the parameterization contains <tt>k_SI</tt>, the values for
<tt>deltaM</tt> and <tt>dp0</tt> need not be changed if the valve size
changes.
</p><p>
The two way valve models are implemented using this partial model, as opposed to using
different functions for the valve opening characteristics, because
each valve opening characteristics has different parameters.
</html>", revisions="<html>
<ul>
<li>
August 15, 2008 by Michael Wetter:<br>
Set valve leakage to nonzero value.
<li>
June 3, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
revisions="<html>
<ul>
<li>
June 3, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");
  
  parameter Real k_SI(min=0, unit="(kg*m)^(1/2)") 
    "Flow coefficient for fully open valve in SI units, k=m_flow/sqrt(dp)";
  parameter Real l(min=0, max=1) = 0.005 "Valve leakage, l=Cv(y=0)/Cvs";
  parameter Real deltaM = 0.02 
    "Fraction of nominal flow rate where linearization starts, if y=1" 
    annotation(Dialog(group="Pressure-flow linearization"));
  parameter Modelica.SIunits.Pressure dp0 = 6000 "Nominal pressure drop" 
    annotation(Dialog(group="Pressure-flow linearization"));
  Real phi "Ratio actual to nominal mass flow rate, phi=Cv(y)/Cv(y=1)";
equation 
 k = phi * k_SI;
end PartialTwoWayValve;
