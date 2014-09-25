within Buildings.Electrical.AC.ThreePhasesBalanced.Sources;
model PVSimpleOriented "Model of a simple PV panel with orientation"
  extends Buildings.Electrical.AC.OnePhase.Sources.PVSimpleOriented(
    redeclare Interfaces.Terminal_p terminal,
    redeclare Buildings.Electrical.AC.ThreePhasesBalanced.Sources.PVSimple
    panel(V_nominal = V_nominal),
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
This model takes as an input the direct and diffuse solar radiation from
the weather bus.
</p>
<p>
See <a href=\"modelica://Buildings.Electrical.AC.OnePhase.Sources.PVSimpleOriented\">
Buildings.Electrical.AC.OnePhase.Sources.PVSimpleOriented</a> for
more information.
</p>
</html>"));
end PVSimpleOriented;
