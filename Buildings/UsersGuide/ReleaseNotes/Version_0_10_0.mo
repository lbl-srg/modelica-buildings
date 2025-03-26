within Buildings.UsersGuide.ReleaseNotes;
class Version_0_10_0 "Version 0.10.0"
  extends Modelica.Icons.ReleaseNotes;
annotation (preferredView="info", Documentation(info=
                 "<html>
<ul>
<li>
Added package
<code>Buildings.Airflow.Multizone</code>
with models for multizone airflow and contaminant transport.
</li>
<li>
Added the model
<code>Buildings.Utilities.Comfort.Fanger</code>
for thermal comfort calculations.
</li>
<li>
Rewrote
<code>Buildings.Fluid.Storage.BaseClasses.ThirdOrderStratifier</code>, which is used in
<code>Buildings.Fluid.Storage.StratifiedEnhanced</code>,
to avoid state events when the flow reverses.
This leads to faster and more robust simulation.
</li>
<li>
In models of package
<code>Buildings.Fluid.MixingVolumes</code>,
added nominal value for <code>mC</code> to avoid wrong trajectory
when concentration is around 1E-7.
See also <a href=\"https://trac.modelica.org/Modelica/ticket/393\">
https://trac.modelica.org/Modelica/ticket/393</a>.
</li>
<li>
Fixed bug in fan and pump models that led to too small an enthalpy
increase across the flow device.
</li>
<li>
In model <code>Buildings.Fluid.Movers.FlowControlled_dp</code>,
changed <code>assert(dp_in &ge; 0, ...)</code> to <code>assert(dp_in &ge; -0.1, ...)</code>.
The former implementation triggered the assert if <code>dp_in</code> was solved for
in a nonlinear equation since the solution can be slightly negative while still being
within the solver tolerance.
</li>
<li>
Added model
<code>Buildings.Controls.SetPoints.Table</code>
that allows the specification of a floating setpoint using a table of values.
</li>
<li>
Revised model
<code>Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2</code>.
The new version has exactly the same nominal power during the simulation as specified
by the parameters. This also required a change in the parameters.
</li>
</ul>
</html>"));
end Version_0_10_0;
