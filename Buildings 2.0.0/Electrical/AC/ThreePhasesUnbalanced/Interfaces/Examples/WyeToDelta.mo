within Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Examples;
model WyeToDelta "Test for Y to D connection"

  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.WyeToDelta wyeToDelta
    "Conversion of the voltages from Y to D"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.FixedVoltage V1(f=60, V=
        480) "Voltage source"
           annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeWye probe_Y(perUnit=
       false, V_nominal=480)
    "Probe that measures the voltage and the angles on each phase"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeWye probeD(perUnit=
        false, V_nominal=480)
    "Probe that measures the voltage and the angles on each phase"
    annotation (Placement(transformation(extent={{10,10},{30,30}})));
equation
  connect(V1.terminal, wyeToDelta.wye) annotation (Line(
      points={{-40,0},{-10,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(probe_Y.term, wyeToDelta.wye) annotation (Line(
      points={{-20,11},{-20,0},{-10,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(probeD.term, wyeToDelta.delta) annotation (Line(
      points={{20,11},{20,0},{10,0}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Interfaces/Examples/WyeToDelta.mos"
        "Simulate and plot"),
 Documentation(revisions="<html>
<ul>
<li>
October 9, 2014, by Marco Bonvini:<br/>
Revised example and documentation.
</li>
<li>
September 24, 2014, by Marco Bonvini:<br/>
Added info section.
</li>
</ul>
</html>", info="<html>
<p>
This simple example shows how to use a Y to D adapter.
</p>
<p>
The probe <code>probe_Y</code> mesaures the phase voltages before they
are converted into D. Their RMS value is equal to <i>480/sqrt(3)</i> V.
</p>
<p>
The probe <code>probe_D</code> measures the phase
voltages after the conversion to D. Their RMS value is equal to <i>480</i> V,
the line voltage provided by the voltage source.
</p>
</html>"));
end WyeToDelta;
