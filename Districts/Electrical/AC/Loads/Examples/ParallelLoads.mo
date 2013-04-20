within Districts.Electrical.AC.Loads.Examples;
model ParallelLoads
  "Example that illustrates the use of the load models at constant voltage"
  extends Modelica.Icons.Example;
  VariableInductorResistor varIndRes(P_nominal=1e3, measureP=true)
    "Variable inductor and resistor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,50})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground gro "Ground"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));
  Districts.Electrical.AC.Sources.ConstantVoltage                                               sou(
    f=60,
    V=120,
    phi=0,
    measureP=true) "Voltage source"
                            annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,-20})));
  Modelica.Blocks.Sources.Ramp ramp(duration=1, offset=0)
    annotation (Placement(transformation(extent={{80,40},{60,60}})));
  InductorResistor indRes(P_nominal=1e3, measureP=true)
    "Constant inductor and resistor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,30})));
  VariableCapacitorResistor varConRes(P_nominal=1e3, measureP=true)
    "Variable conductor and resistor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,10})));
  CapacitorResistor conRes(P_nominal=1e3, measureP=true)
    "Constant conductor and resistor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,-10})));
  Resistor res(P_nominal=1e3, measureP=true) "Resistive load"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,-30})));
equation
  connect(ramp.y, varConRes.y) annotation (Line(
      points={{59,50},{38,50},{38,10},{20,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.n, gro.pin) annotation (Line(
      points={{-80,-30},{-80,-40}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(ramp.y, varIndRes.y) annotation (Line(
      points={{59,50},{20,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.sPhasePlug, varIndRes.sPhasePlug) annotation (Line(
      points={{-80,-10},{-60,-10},{-60,50},{-4.44089e-16,50}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(sou.sPhasePlug, indRes.sPhasePlug) annotation (Line(
      points={{-80,-10},{-60,-10},{-60,30},{0,30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(sou.sPhasePlug, varConRes.sPhasePlug) annotation (Line(
      points={{-80,-10},{-60,-10},{-60,10},{0,10}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(sou.sPhasePlug, conRes.sPhasePlug) annotation (Line(
      points={{-80,-10},{0,-10}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(sou.sPhasePlug, res.sPhasePlug) annotation (Line(
      points={{-80,-10},{-60,-10},{-60,-30},{-4.44089e-16,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics),
    Documentation(info="<html>
<p>
This model illustrates the use of the load models.
The first two lines are inductive loads, followed by two capacitive loads and a resistive load.
At time equal to <i>1</i> second, all loads consume the same actual power as specified by the
nominal condition. Between <i>t = 0...1</i>, the power is increased from zero to one.
Consequently, the power factor is highest at <i>t=0</i> but decreases to its nominal value
at <i>t=1</i> second.
</p>
</html>",
    revisions="<html>
<ul>
<li>
January 3, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Commands(file=
          "Resources/Scripts/Dymola/Electrical/AC/Loads/Examples/ParallelLoads.mos"
        "Simulate and plot"));
end ParallelLoads;
