within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources;
model WindTurbine
  extends BaseClasses.UnbalancedWindTurbine(
  redeclare Buildings.Electrical.AC.OnePhase.Sources.WindTurbine wt_phase1,
  redeclare Buildings.Electrical.AC.OnePhase.Sources.WindTurbine wt_phase2,
  redeclare Buildings.Electrical.AC.OnePhase.Sources.WindTurbine wt_phase3);
equation

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end WindTurbine;
