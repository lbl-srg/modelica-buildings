within Buildings.Electrical.AC.OnePhase.Basics;
model Ground
  extends Buildings.Electrical.Interfaces.PartialGround(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Interfaces.Terminal_n terminal);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Line(
          points={{0,90},{0,0}},
          color={0,120,120},
          smooth=Smooth.None),
        Line(
          points={{-80,0},{80,0}},
          color={0,120,120},
          smooth=Smooth.None),
        Line(
          points={{-60,-20},{60,-20}},
          color={0,120,120},
          smooth=Smooth.None),
        Line(
          points={{-40,-40},{40,-40}},
          color={0,120,120},
          smooth=Smooth.None)}));
end Ground;
