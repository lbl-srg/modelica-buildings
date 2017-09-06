within Buildings.Fluid.Actuators.BaseClasses;
partial model PartialTwoWayValveKv
  "Partial model for a two way valve using a Kv characteristic"
  extends Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve;

equation
 kVal = phi*Kv_SI;
 if (dpFixed_nominal > Modelica.Constants.eps) then
   k = sqrt(1/(1/kFixed^2 + 1/kVal^2));
 else
   k = kVal;
 end if;

 if linearized then
   // This implementation yields m_flow_nominal = phi*kv_SI * sqrt(dp_nominal)
   // if m_flow = m_flow_nominal and dp = dp_nominal
   m_flow*m_flow_nominal_pos = k^2 * dp;
 else
   if homotopyInitialization then
     if from_dp then
         m_flow=homotopy(actual=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(dp=dp, k=k,
                                m_flow_turbulent=m_flow_turbulent),
                                simplified=m_flow_nominal_pos*dp/dp_nominal_pos);
      else
         dp=homotopy(actual=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(m_flow=m_flow, k=k,
                                m_flow_turbulent=m_flow_turbulent),
                                simplified=dp_nominal_pos*m_flow/m_flow_nominal_pos);
     end if;
   else // do not use homotopy
     if from_dp then
       m_flow=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(dp=dp, k=k,
                                m_flow_turbulent=m_flow_turbulent);
      else
        dp=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(m_flow=m_flow, k=k,
                                m_flow_turbulent=m_flow_turbulent);
      end if;
    end if; // homotopyInitialization
 end if; // linearized
  annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
            {100,100}}),       graphics={
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
          points={{-52,-42},{0,-4},{60,40},{60,-42},{-52,-42}},
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
          points={{0,40},{0,-4}}),
        Line(
          visible=not use_inputFilter,
          points={{0,100},{0,40}})}),
Documentation(info="<html>
<p>
Partial model for valves with different opening characteristics,
such as linear, equal percentage or quick opening. This partial extends from
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve\">
Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve</a>
and also contains the governing equations for these three two way valve models.
</p>
<h4>Implementation</h4>
<p>
Models that extend this model need to provide a binding equation
for the flow function <code>phi</code>.
An example of such a code can be found in
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.TwoWayLinear\">
Buildings.Fluid.Actuators.Valves.TwoWayLinear</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 24, 2017, by Michael Wetter:<br/>
Renamed <code>filteredInput</code> to <code>use_inputFilter</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/665\">#665</a>.
</li>
<li>
January 29, 2015 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialTwoWayValveKv;
