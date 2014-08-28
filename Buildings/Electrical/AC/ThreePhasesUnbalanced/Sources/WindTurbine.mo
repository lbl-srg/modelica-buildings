within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources;
model WindTurbine "Simple wind turbine source"
  extends BaseClasses.UnbalancedWindTurbine(
  redeclare Buildings.Electrical.AC.OnePhase.Sources.WindTurbine wt_phase1,
  redeclare Buildings.Electrical.AC.OnePhase.Sources.WindTurbine wt_phase2,
  redeclare Buildings.Electrical.AC.OnePhase.Sources.WindTurbine wt_phase3);
equation

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(revisions="<html>
<ul>
<li>
August 27, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>", info="<html>
<p>
Simple wind turbine model for three phases unbalanced systems.
</p>
<p>
For more information see 
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Sources.WindTurbine\">
Buildings.Electrical.AC.OnePhase.Sources.WindTurbine</a>, and
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.UnbalancedWindTurbine\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.UnbalancedWindTurbine</a>.
</p>
</html>"));
end WindTurbine;
