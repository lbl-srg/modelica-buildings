within Buildings.UsersGuide.ReleaseNotes;
class Version_0_5_0 "Version 0.5.0"
  extends Modelica.Icons.ReleaseNotes;
    annotation (preferredView="info", Documentation(info=
                 "<html>
<ul>
<li>
Updated library to Modelica.Fluid 1.0.
</li>
<li>
Moved most examples from package <code>Buildings.Fluid.Examples</code> to the
example directory in the package of the individual model.
</li>
<li>
Renamed package <code>Buildings.Utilites.Controls</code> to
<code>Buildings.Utilites.Diagnostics</code>.
</li>
<li>
Introduced packages
<code>Buildings.Controls</code>,
<code>Buildings.HeatTransfer</code>
(which contains models for heat transfer that generally does not involve
modeling of the fluid flow),
<code>Buildings.Fluid.Boilers</code> and
<code>Buildings.Fluid.HeatExchangers.Radiators</code>.
</li>
<li>
Changed valve models in <code>Buildings.Fluid.Actuators.Valves</code> so that
<code>Kv</code> or <code>Cv</code> can
be used as the flow coefficient (in [m3/h] or [USG/min]).
</li>
</ul>
</html>"));
end Version_0_5_0;
