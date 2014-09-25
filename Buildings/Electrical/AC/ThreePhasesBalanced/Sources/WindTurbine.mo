within Buildings.Electrical.AC.ThreePhasesBalanced.Sources;
model WindTurbine "Model of a simple wind turbine generator"
  extends Buildings.Electrical.AC.OnePhase.Sources.WindTurbine(
    redeclare Interfaces.Terminal_p terminal,
    redeclare Buildings.Electrical.AC.ThreePhasesBalanced.Loads.Capacitive load,
    V_nominal(start=480));
  annotation (
    defaultComponentName="winTur",
    Documentation(revisions="<html>
<ul>
<li>
August 24, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>", info="<html>
<p>
Model of a wind turbine whose power is computed as a function of wind-speed as defined in a table.
</p>
<p>
See <a href=\"modelica://Buildings.Electrical.AC.OnePhase.Sources.WindTurbine\">
Buildings.Electrical.AC.OnePhase.Sources.WindTurbine</a> for
more information.
</p>
</html>"));
end WindTurbine;
