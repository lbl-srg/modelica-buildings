within Districts.Electrical.AC.ThreePhasesBalanced.Conversion.Examples;
model ACDCConverter "Example model for 3phase AC to DC converter"
  import Districts;
  extends Modelica.Icons.Example;
  Districts.Electrical.AC.ThreePhasesBalanced.Conversion.ACDCConverter
                                                         tra(conversionFactor=
        380/15000, eta=0.9) "Transformer"
    annotation (Placement(transformation(extent={{-26,0},{-6,20}})));
  Districts.Electrical.AC.ThreePhasesBalanced.Sources.FixedVoltage
                                                     V(
    f=50,
    Phi=0,
    V(displayUnit="kV") = 15000)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=1,
    duration=0.5,
    startTime=0.3)
    annotation (Placement(transformation(extent={{80,0},{60,20}})));
  Districts.Electrical.DC.Loads.Conductor    loadRL(
      P_nominal=12000,
    linear=false,
    mode=Districts.Electrical.Types.Assumption.VariableZ_y_input)
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
equation
  connect(V.terminal, tra.terminal_n)        annotation (Line(
      points={{-60,10},{-26,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(ramp.y, loadRL.y) annotation (Line(
      points={{59,10},{40,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tra.terminal_p, loadRL.terminal) annotation (Line(
      points={{-6,10},{20,10}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),        graphics), Documentation(
            info="<html>
<p>
This test model illustrates use of a transformer from 3 phase AC to DC circuit.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 24, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ACDCConverter;
