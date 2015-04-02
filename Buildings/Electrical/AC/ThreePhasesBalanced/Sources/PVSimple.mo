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
