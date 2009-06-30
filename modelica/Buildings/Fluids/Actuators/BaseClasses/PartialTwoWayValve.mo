within Buildings.Fluids.Actuators.BaseClasses;
partial model PartialTwoWayValve "Partial model for a two way valve"
  extends Buildings.Fluids.Actuators.BaseClasses.PartialActuator(
       dp_nominal=6000);
  extends Buildings.Fluids.Actuators.BaseClasses.ValveParameters(
      rhoStd=Medium.density_pTX(101325, 273.15+4, Medium.X_default),
      final dpVal_nominal=dp_nominal);

  annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}), graphics={
        Polygon(
          points={{2,-2},{-76,60},{-76,-60},{2,-2}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-50,40},{0,-2},{54,40},{54,40},{-50,40}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,-40},{0,-4},{56,38},{52,-42},{-48,-40}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-2},{82,60},{82,-60},{0,-2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,100},{0,-2}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-40,48},{40,48}},
          color={0,0,0},
          smooth=Smooth.None)}),
Documentation(info="<html>
<p>
Partial model for a two way valve. This is the base model for valves
with different opening characteristics, such as linear, equal percentage
or quick opening.
</p>
<p><b>Modelling options</b></p>
<p>The following options have been adapted from the valve implementation 
in <a href=\"Modelica://Modelica.Fluid\">
Modelica.Fluid</a> and are described in 
<a href=\"Modelica:Buildings.Fluids.Actuators.BaseClasses.ValveParameters\">
Buildings.Fluids.Actuators.BaseClasses.ValveParameters</a>.
<p>
In contrast to the model in <a href=\"Modelica://Modelica.Fluid\">
Modelica.Fluid</a>, this model uses the parameter <tt>Kv_SI</tt>,
which is the flow coefficient in SI units, i.e., 
it is the ratio between mass flow rate in <tt>kg/s</tt> and square root 
of pressure drop in <tt>Pa</tt>.
</p><p>
To prevent the derivative <tt>d/dP (m_flow)</tt> to be infinite near
the origin, this model linearizes the pressure drop vs. flow relation
ship. The region in which it is linearized is parameterized by 
<pre>m_small_flow = deltaM * Kv_SI * sqrt(dp_nominal)
</pre>
Because the parameterization contains <tt>Kv_SI</tt>, the values for
<tt>deltaM</tt> and <tt>dp_nominal</tt> need not be changed if the valve size
changes.
</p>
<p>
The two way valve models are implemented using this partial model, as opposed to using
different functions for the valve opening characteristics, because
each valve opening characteristics has different parameters.
</html>", revisions="<html>
<ul>
<li>
February 18, 2009 by Michael Wetter:<br>
Implemented parameterization of flow coefficient as in 
<tt>Modelica.Fluid</tt>.
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

  parameter Real l(min=0, max=1) = 0.0001 "Valve leakage, l=Cv(y=0)/Cvs";
  Real phi "Ratio actual to nominal mass flow rate, phi=Cv(y)/Cv(y=1)";

equation
 m_flow_turbulent = deltaM * m_flow_nominal;
 k = phi * Kv_SI;
end PartialTwoWayValve;
