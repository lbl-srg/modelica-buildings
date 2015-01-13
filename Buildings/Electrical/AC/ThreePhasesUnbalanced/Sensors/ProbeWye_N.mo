within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors;
model ProbeWye_N
  "Model of a probe that measures voltage magnitude and angle (Wye configuration) witn neutral cable connection"
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.BaseClasses.GeneralizedProbe;
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Terminal4_n
    term "Electrical connector" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-90})));
equation

  for i in 1:4 loop
    term.phase[i].i = zeros(Buildings.Electrical.PhaseSystems.OnePhase.n);
  end for;

  for i in 1:3 loop
      theta[i] = Buildings.Electrical.PhaseSystems.OnePhase.phase(term.phase[i].v - term.phase[4].v);
      if perUnit then
        V[i] = Buildings.Electrical.PhaseSystems.OnePhase.systemVoltage(term.phase[i].v - term.phase[4].v)/(V_nominal/sqrt(3));
      else
        V[i] = Buildings.Electrical.PhaseSystems.OnePhase.systemVoltage(term.phase[i].v - term.phase[4].v);
      end if;
  end for;
  annotation (defaultComponentName="sen",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Line(
          points={{0,-10},{0,-30},{-14,-44}},
          color={127,0,127},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{0,-30},{14,-44}},
          color={127,0,127},
          smooth=Smooth.None,
          thickness=0.5)}),
Documentation(info="<html>
<p>
This model represents a probe that measures the RMS voltage and the angle
of the voltage phasors at a given point. The probes are connected
in the Wye (Y) grounded configuration.
</p>
</html>", revisions="<html>
<ul>
<li>
June 6, 2014, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>"));
end ProbeWye_N;
