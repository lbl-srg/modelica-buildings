within Buildings.Fluid.Actuators.BaseClasses;
partial model PartialTwoWayValve "Partial model for a two way valve"
  extends Buildings.Fluid.Actuators.BaseClasses.PartialActuator(
       dp_nominal=6000);
  extends Buildings.Fluid.Actuators.BaseClasses.ValveParameters(
      rhoStd=Medium.density_pTX(101325, 273.15+4, Medium.X_default),
      final dpVal_nominal=dp_nominal);

  parameter Real l(min=0, max=1) = 0.0001 "Valve leakage, l=Cv(y=0)/Cvs";
  Real phi "Ratio actual to nominal mass flow rate, phi=Cv(y)/Cv(y=1)";

equation
 m_flow_turbulent = deltaM * abs(m_flow_nominal);

 if homotopyInitialization then
   if from_dp then
       m_flow=homotopy(actual=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(dp=dp, k=phi*Kv_SI,
                              m_flow_turbulent=m_flow_turbulent,
                              linearized=linearized),
                              simplified=m_flow_nominal_pos*dp/dp_nominal_pos);
   else
       dp=homotopy(actual=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(m_flow=m_flow, k=phi*Kv_SI,
                              m_flow_turbulent=m_flow_turbulent,
                              linearized=linearized),
                              simplified=dp_nominal_pos*m_flow/m_flow_nominal_pos);
   end if;
 else // do not use homotopy
   if from_dp then
     m_flow=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(dp=dp, k=phi*Kv_SI, 
                              m_flow_turbulent=m_flow_turbulent, linearized=linearized);
   else
     dp=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(m_flow=m_flow, k=phi*Kv_SI, 
                              m_flow_turbulent=m_flow_turbulent, linearized=linearized);
   end if;
 end if; // homotopyInitialization

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
in <a href=\"modelica://Modelica.Fluid\">
Modelica.Fluid</a> and are described in 
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.ValveParameters\">
Buildings.Fluid.Actuators.BaseClasses.ValveParameters</a>.
<p>
In contrast to the model in <a href=\"modelica://Modelica.Fluid\">
Modelica.Fluid</a>, this model uses the parameter <code>Kv_SI</code>,
which is the flow coefficient in SI units, i.e., 
it is the ratio between mass flow rate in <code>kg/s</code> and square root 
of pressure drop in <code>Pa</code>.
</p><p>
To prevent the derivative <code>d/dP (m_flow)</code> to be infinite near
the origin, this model linearizes the pressure drop vs. flow relation
ship. The region in which it is linearized is parameterized by 
<pre>m_turbulent_flow = deltaM * m_flow_nominal
</pre>
Because the parameterization contains <code>Kv_SI</code>, the values for
<code>deltaM</code> and <code>dp_nominal</code> need not be changed if the valve size
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
<code>Modelica.Fluid</code>.
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
April 4, 2011 by Michael Wetter:<br>
Revised implementation to use new base class for actuators.
</li>
<li>
June 3, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");
end PartialTwoWayValve;
