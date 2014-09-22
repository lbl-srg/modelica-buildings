within Buildings.Electrical.AC.OnePhase.Basics;
model Ground "Ground connection"
  extends Buildings.Electrical.Interfaces.Ground(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Interfaces.Terminal_n terminal);
  annotation (
    defaultComponentName="gnd",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
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
          smooth=Smooth.None)}), Documentation(info="<html>
<p>
This model represents a connection to the ground.
</p>
</html>", revisions="<html>
<ul>
<li>
June 4, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>"));
end Ground;
