within Buildings.DHC.EnergyTransferStations.BaseClasses;
model Pump_m_flow
  "Pump with prescribed mass flow rate"
  extends Buildings.Fluid.Movers.Preconfigured.FlowControlled_m_flow(
    addPowerToMedium=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_inputFilter=false);
  annotation (
    Icon(
      graphics={
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
          fillColor={255,255,255})}),
    Documentation(
      info="<html>
<p>
This is a steady-state model of a pump with ideally controlled
mass flow rate as input signal, and no heat added to the medium.
</p>
</html>", revisions="<html>
<ul>
<li>
December 12, 2023, by Ettore Zanetti:<br/>
Changed to preconfigured pump model,
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3431\">issue 3431</a>.
</li>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Pump_m_flow;
