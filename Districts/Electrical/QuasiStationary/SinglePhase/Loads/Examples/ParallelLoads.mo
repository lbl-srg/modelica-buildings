within Districts.Electrical.QuasiStationary.SinglePhase.Loads.Examples;
model ParallelLoads
  "Example that illustrates the use of the load models at constant voltage"
  extends Modelica.Icons.Example;
  VariableInductorResistor varIndRes(P_nominal=1e3)
    "Variable inductor and resistor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,-10})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground gro "Ground"
    annotation (Placement(transformation(extent={{-90,-74},{-70,-54}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource sou(
    f=60,
    V=120,
    phi=0) "Voltage source" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,-10})));
  Modelica.Blocks.Sources.Ramp ramp(duration=1, offset=0)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Sensors.PowerSensor powSenVarIndRes "Power sensor" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,30})));
  InductorResistor indRes(P_nominal=1e3) "Constant inductor and resistor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,-10})));
  Sensors.PowerSensor powSenIndRes "Power sensor" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,30})));
  VariableCapacitorResistor varConRes(P_nominal=1e3)
    "Variable conductor and resistor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={120,-10})));
  Sensors.PowerSensor powSenVarConRes "Power sensor" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={120,30})));
  CapacitorResistor conRes(P_nominal=1e3) "Constant conductor and resistor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={180,-10})));
  Sensors.PowerSensor powSenConRes "Power sensor" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={180,30})));
  Resistor res(P_nominal=1e3) "Resistive load"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={250,-10})));
  Sensors.PowerSensor powSenRes "Power sensor" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={250,30})));
equation
  connect(gro.pin, sou.pin_n) annotation (Line(
      points={{-80,-54},{-80,-20}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(varIndRes.pin_n, gro.pin) annotation (Line(
      points={{-10,-20},{-10,-40},{-80,-40},{-80,-54}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(ramp.y, varIndRes.y) annotation (Line(
      points={{-39,70},{20,70},{20,-10},{8.88178e-16,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(varIndRes.pin_p, powSenVarIndRes.currentN) annotation (Line(
      points={{-10,4.44089e-16},{-10,20}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(powSenVarIndRes.currentP, sou.pin_p) annotation (Line(
      points={{-10,40},{-10,50},{-80,50},{-80,4.44089e-16}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(gro.pin, indRes.pin_n) annotation (Line(
      points={{-80,-54},{-80,-40},{50,-40},{50,-20}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(powSenIndRes.currentN, indRes.pin_p) annotation (Line(
      points={{50,20},{50,0},{50,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(powSenIndRes.currentP, sou.pin_p) annotation (Line(
      points={{50,40},{50,50},{-80,50},{-80,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(varConRes.pin_n, gro.pin) annotation (Line(
      points={{120,-20},{120,-40},{-80,-40},{-80,-54}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(varConRes.pin_p, powSenVarConRes.currentN) annotation (Line(
      points={{120,0},{120,5},{120,5},{120,20}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(powSenVarConRes.currentP, sou.pin_p) annotation (Line(
      points={{120,40},{120,50},{-80,50},{-80,4.44089e-16}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(gro.pin, conRes.pin_n) annotation (Line(
      points={{-80,-54},{-80,-40},{180,-40},{180,-20}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(powSenConRes.currentN, conRes.pin_p) annotation (Line(
      points={{180,20},{180,0},{180,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(powSenConRes.currentP, sou.pin_p) annotation (Line(
      points={{180,40},{180,50},{-80,50},{-80,4.44089e-16}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(ramp.y, varConRes.y) annotation (Line(
      points={{-39,70},{146,70},{146,-10},{130,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(powSenRes.currentP, sou.pin_p) annotation (Line(
      points={{250,40},{250,50},{-80,50},{-80,4.44089e-16}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(powSenRes.currentN, res.pin_p) annotation (Line(
      points={{250,20},{250,0},{250,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(res.pin_n, gro.pin) annotation (Line(
      points={{250,-20},{250,-40},{-80,-40},{-80,-54}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(powSenRes.voltageP, gro.pin) annotation (Line(
      points={{260,30},{268,30},{268,-40},{-80,-40},{-80,-54}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(powSenRes.voltageN, powSenRes.currentP) annotation (Line(
      points={{240,30},{220,30},{220,50},{250,50},{250,40}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(powSenConRes.voltageN, powSenConRes.currentP) annotation (Line(
      points={{170,30},{150,30},{150,50},{180,50},{180,40}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(powSenVarConRes.voltageN, powSenVarConRes.currentP) annotation (Line(
      points={{110,30},{100,30},{100,50},{120,50},{120,40}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(powSenIndRes.voltageN, powSenIndRes.currentP) annotation (Line(
      points={{40,30},{32,30},{32,50},{50,50},{50,40}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(powSenVarIndRes.voltageN, powSenVarIndRes.currentP) annotation (Line(
      points={{-20,30},{-30,30},{-30,50},{-10,50},{-10,40}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(powSenVarIndRes.voltageP, varIndRes.pin_n) annotation (Line(
      points={{4.44089e-16,30},{10,30},{10,-40},{-10,-40},{-10,-20}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(powSenIndRes.voltageP, indRes.pin_n) annotation (Line(
      points={{60,30},{70,30},{70,-40},{50,-40},{50,-20}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(powSenVarConRes.voltageP, varConRes.pin_n) annotation (Line(
      points={{130,30},{140,30},{140,-40},{120,-40},{120,-20}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(powSenConRes.voltageP, conRes.pin_n) annotation (Line(
      points={{190,30},{200,30},{200,-40},{180,-40},{180,-20}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{280,
            100}}), graphics),
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
          "Resources/Scripts/Dymola/Electrical/QuasiStationary/SinglePhase/Loads/Examples/ParallelLoads.mos"
        "Simulate and plot"));
end ParallelLoads;
