within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors;
package Examples "Package with example models"
  extends Modelica.Icons.ExamplesPackage;
  model Sensors "Test models for sensors and probes"
    extends Modelica.Icons.Example;
    Sources.FixedVoltage source(f=60,V=480)
      "Voltage source without neutral cable"
             annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
    Loads.Resistive load(V_nominal=480, mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
      P_nominal=-1e4) "Load model"
      annotation (Placement(transformation(extent={{20,20},{40,40}})));
    ProbeWye probeWye(V_nominal=480) "Probe that measures the phase voltages"
      annotation (Placement(transformation(extent={{-46,48},{-26,68}})));
    ProbeDelta probeDelta(V_nominal=480)
      "Probe that measures the line voltages"
      annotation (Placement(transformation(extent={{-20,48},{0,68}})));
    Sources.FixedVoltage_N source_N(f=60, V=480)
      "Voltage source with neutral cable"
      annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
    Loads.Resistive_N load_N(V_nominal=480, mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
      P_nominal=-1e4) "Load model"
      annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
    ProbeWye_N probeWye_N(V_nominal=480)
      annotation (Placement(transformation(extent={{-30,-12},{-10,8}})));
    GeneralizedSensor sen "Generalized sensor withour neutral cable"
      annotation (Placement(transformation(extent={{-4,20},{16,40}})));
    GeneralizedSensor_N sen_N "Generalized sensor with neutral cable"
      annotation (Placement(transformation(extent={{-8,-40},{12,-20}})));
    Modelica.Blocks.Sources.Ramp ramp(
      height=2e4,
      duration=0.5,
      offset=-1e4,
      startTime=0.25)
      annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  equation
    connect(probeWye.term, source.terminal) annotation (Line(
        points={{-36,49},{-36,30},{-60,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(probeDelta.term, source.terminal) annotation (Line(
        points={{-10,49},{-10,30},{-60,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(source_N.terminal, probeWye_N.term) annotation (Line(
        points={{-60,-30},{-20,-30},{-20,-11}},
        color={127,0,127},
        smooth=Smooth.None));
    connect(source_N.terminal, sen_N.terminal_n) annotation (Line(
        points={{-60,-30},{-8,-30}},
        color={127,0,127},
        smooth=Smooth.None));
    connect(sen_N.terminal_p, load_N.terminal) annotation (Line(
        points={{12,-30},{20,-30}},
        color={127,0,127},
        smooth=Smooth.None));
    connect(sen.terminal_p, load.terminal) annotation (Line(
        points={{16,30},{20,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(sen.terminal_n, source.terminal) annotation (Line(
        points={{-4,30},{-60,30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(ramp.y, load.Pow1) annotation (Line(
        points={{59,0},{50,0},{50,38},{42,38}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(ramp.y, load.Pow2) annotation (Line(
        points={{59,0},{50,0},{50,30},{42,30}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(ramp.y, load.Pow3) annotation (Line(
        points={{59,0},{50,0},{50,22},{42,22}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(ramp.y, load_N.Pow1) annotation (Line(
        points={{59,0},{50,0},{50,-22},{42,-22}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(ramp.y, load_N.Pow2) annotation (Line(
        points={{59,0},{50,0},{50,-30},{42,-30}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(ramp.y, load_N.Pow3) annotation (Line(
        points={{59,0},{50,0},{50,-38},{42,-38}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation ( Documentation(
  revisions="<html>
<ul>
<li>
October 3, 2014, by Marco Bonvini:<br/>
Revised model and documentation.
</li>
<li>
June 6, 2014, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This example shows how different types of sensors and probes can be used
to measure the voltages, currents and powers in a three-phase
unbalanced system.
</p>
<p>
In this example all the loads are directly connected to the sources,
avoiding voltage losses. The loads are all resistive and they start
by consuming <i>10</i> kW for each phase, while at the end of the simulation
they all produce <i>10</i> kW.
</p>
</html>"),
  experiment(Tolerance=1e-05),
  __Dymola_Commands(file=
   "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Sensors/Examples/Sensors.mos"
          "Simulate and plot"));
  end Sensors;
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
