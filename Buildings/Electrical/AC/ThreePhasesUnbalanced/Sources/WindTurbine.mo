within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources;
model WindTurbine
  extends BaseClasses.UnbalancedWindTurbine(
  redeclare Buildings.Electrical.AC.OnePhase.Sources.WindTurbine wt_phase1,
  redeclare Buildings.Electrical.AC.OnePhase.Sources.WindTurbine wt_phase2,
  redeclare Buildings.Electrical.AC.OnePhase.Sources.WindTurbine wt_phase3);
equation
  connect(vWin, wt_phase1.vWin) annotation (Line(
      points={{8.88178e-16,120},{8.88178e-16,70},{-28,70},{-28,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vWin, wt_phase2.vWin) annotation (Line(
      points={{1.11022e-15,120},{0,120},{0,70},{-54,70},{-54,20},{-30,20},{-30,12}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(vWin, wt_phase3.vWin) annotation (Line(
      points={{0,120},{0,70},{-54,70},{-54,-28},{-30,-28},{-30,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end WindTurbine;
