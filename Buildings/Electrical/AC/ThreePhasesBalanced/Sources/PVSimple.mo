within Buildings.Electrical.AC.ThreePhasesBalanced.Sources;
model PVSimple "Model of a simple PV panel"
  extends Buildings.Electrical.AC.OnePhase.Sources.PVSimple(
    redeclare Interfaces.Terminal_p terminal,
    redeclare Buildings.Electrical.AC.ThreePhasesBalanced.Loads.Capacitive load,
    V_nominal(start=480));

  annotation (
    defaultComponentName="pv",
    Documentation(revisions="<html>
<ul>
<li>
March 23, 2022, by Michael Wetter:<br/>
Corrected documentation string for parameter <code>A</code>.
</li>
<li>
October 7, 2019, by Michael Wetter:<br/>
Corrected model to include DC/AC conversion in output <code>P</code>.<br/>
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1577\">1577</a>.
</li>
<li>
August 24, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>", info="<html>
<p>
Model of a simple photovoltaic array.
</p>
<p>
See <a href=\"modelica://Buildings.Electrical.AC.OnePhase.Sources.PVSimple\">
Buildings.Electrical.AC.OnePhase.Sources.PVSimple</a> for
more information.
</p>
</html>"));
end PVSimple;
