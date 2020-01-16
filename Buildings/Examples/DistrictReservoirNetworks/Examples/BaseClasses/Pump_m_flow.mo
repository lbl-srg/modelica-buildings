within Buildings.Examples.DistrictReservoirNetworks.Examples.BaseClasses;
model Pump_m_flow "Pump with prescribed mass flow rate"
  extends Buildings.Fluid.Movers.FlowControlled_m_flow(
    per(final motorCooledByFluid=false),
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=false,
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=false,
    final nominalValuesDefineDefaultPressureCurve=true,
    final use_inputFilter=false,
    final show_T=true);
  annotation (Icon(graphics={
        Ellipse(
          extent={{-58,58},{58,-58}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,0,0}),
        Polygon(
          points={{-2,52},{-2,-48},{52,2},{-2,52}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255})}), Documentation(info="<html>
<p>
Model that configures common parameters of all pumps that are used in
<a href=\"Buildings.Examples.DistrictReservoirNetworks\">
Buildings.Examples.DistrictReservoirNetworks</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 16, 2020, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end Pump_m_flow;
