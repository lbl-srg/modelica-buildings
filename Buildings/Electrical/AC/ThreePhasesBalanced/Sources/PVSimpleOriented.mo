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
March 23, 2022, by Michael Wetter:<br/>
Corrected documentation string for parameter <code>A</code>.
</li>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed parameter <code>lat</code> as this is now obtained from the weather data reader.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
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
