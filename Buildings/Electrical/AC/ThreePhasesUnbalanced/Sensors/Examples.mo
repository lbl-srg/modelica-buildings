within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors;
package Examples "Package with example models"
  extends Modelica.Icons.ExamplesPackage;
  model Probes "Test models for probes"

    Sources.FixedVoltage source(
      f=60,
      V=480,
      Phi=0) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
    Loads.ResistiveLoadP load(P_nominal=10000, V_nominal=480)
      annotation (Placement(transformation(extent={{20,20},{40,40}})));
    ProbeWye probeWye(V_nominal=480)
      annotation (Placement(transformation(extent={{-46,48},{-26,68}})));
    ProbeDelta probeDelta(V_nominal=480)
      annotation (Placement(transformation(extent={{-20,48},{0,68}})));
  equation
    connect(source.terminal, load.terminal_p) annotation (Line(
        points={{-60,30},{20,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(probeWye.term, source.terminal) annotation (Line(
        points={{-36,49},{-36,30},{-60,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(probeDelta.term, source.terminal) annotation (Line(
        points={{-10,49},{-10,30},{-60,30}},
        color={0,120,120},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{
              -100,-100},{100,100}}), graphics), Documentation(revisions="<html>
<ul>
<li>
June 6, 2014, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>"));
  end Probes;
  annotation (Documentation(info="<html>
<p>
This package contains examples for the use of models that can be found in
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 25, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"));
end Examples;
