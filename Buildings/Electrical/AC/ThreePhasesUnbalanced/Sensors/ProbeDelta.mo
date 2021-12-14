within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors;
model ProbeDelta
  "Model of a probe that measures voltage magnitude and angle (Delta configuration)"
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.BaseClasses.GeneralizedProbe;
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Terminal_n
  term "Electrical connector" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-90})));
  Interfaces.WyeToDelta wyeToDelta "Y to D transformation"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={20,0})));
equation
  for i in 1:3 loop
      theta[i] = Buildings.Electrical.PhaseSystems.OnePhase.phase(wyeToDelta.delta.phase[i].v);
      if perUnit then
        V[i] = Buildings.Electrical.PhaseSystems.OnePhase.systemVoltage(wyeToDelta.delta.phase[i].v)/V_nominal;
      else
        V[i] = Buildings.Electrical.PhaseSystems.OnePhase.systemVoltage(wyeToDelta.delta.phase[i].v);
      end if;
  end for;

  connect(term, wyeToDelta.wye) annotation (Line(
      points={{0,-90},{0,4.44089e-16},{10,4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (defaultComponentName="sen",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{40,60},{100,40}},
          textColor={0,120,120},
          pattern=LinePattern.Dash,
          fillColor={0,120,120},
          fillPattern=FillPattern.Solid,
          textString="V"), Text(
          extent={{18,-40},{140,-60}},
          textColor={0,120,120},
          pattern=LinePattern.Dash,
          fillColor={0,120,120},
          fillPattern=FillPattern.Solid,
          textString="theta"),
        Line(
          points={{-20,-44},{0,-14},{20,-44},{-20,-44}},
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.5)}),         Documentation(info="<html>
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
end ProbeDelta;
