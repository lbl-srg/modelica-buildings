within Buildings.Electrical.DC.Lines.Examples;
model RCModel "Example model to test for the DC RC two port model"
  extends Modelica.Icons.Example;

  TwoPortRCLine RC_ss(
    C=1,
    V_nominal=50,
    R=8) "Line resistance"
         annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Sources.ConstantVoltage constantVoltage(V=50) "Voltage source"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{-72,-16},{-52,4}})));
  Loads.Resistor sc_ss(V_nominal=50, R=0) "Short circuit load"
    annotation (Placement(transformation(extent={{30,10},{50,30}})));
  Sensors.GeneralizedSensor sen_ss "Sensor"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  TwoPortRCLine RC_dyn(
    C=1,
    V_nominal=50,
    use_C=true,
    R=8) "Line resistance"
         annotation (Placement(transformation(extent={{-28,-20},{-8,0}})));
  Loads.Resistor sc_dyn(V_nominal=50, R=0) "Load"
    annotation (Placement(transformation(extent={{32,-20},{52,0}})));
  Sensors.GeneralizedSensor sen_dyn "Sensor"
    annotation (Placement(transformation(extent={{2,-20},{22,0}})));
equation
  connect(ground.p, constantVoltage.n) annotation (Line(
      points={{-62,4},{-62,20},{-60,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(constantVoltage.terminal, RC_ss.terminal_n) annotation (Line(
      points={{-40,20},{-30,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(RC_ss.terminal_p, sen_ss.terminal_n) annotation (Line(
      points={{-10,20},{0,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sen_ss.terminal_p, sc_ss.terminal) annotation (Line(
      points={{20,20},{30,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(RC_dyn.terminal_p, sen_dyn.terminal_n) annotation (Line(
      points={{-8,-10},{2,-10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sen_dyn.terminal_p, sc_dyn.terminal) annotation (Line(
      points={{22,-10},{32,-10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(constantVoltage.terminal, RC_dyn.terminal_n) annotation (Line(
      points={{-40,20},{-34,20},{-34,-10},{-28,-10}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/DC/Lines/Examples/RCmodel.mos"
        "Simulate and plot"),
        experiment(StopTime=15.0,Tolerance=1e-06),
    Documentation(info="<html>
<p>
This model shows how to use a two port resistance-capacitance model.
The example also shows a comparison between the dynamic and steady state version model
that can be selected by changing the boolean flag <code>use_C</code>.
</p>
<p>
In this example the RC connects an ideal constant voltage source with
a short circuit. The steady state current value passing through the RC
model depends just on the value of <i>R</i>.
</p>
<p>
The RC model implement a T-model to represent the electric connection between the
two connectors (see <a href=\"modelica://Buildings.Electrical.DC.Lines.TwoPortRCLine\">
Buildings.Electrical.DC.Lines.TwoPortRCLine</a> for more details).
</p>
<p>
The capacitance <i>C</i> see an equivalent Thevenin's resistance that is equal to
<i>R<sub>EQ</sub> = 0.5 R</i> and thus the time constant associated to the capacitance is
</p>
<p align=\"center\" style=\"font-style:italic;\">
&tau; = R<sub>EQ</sub> C = 0.5 R C = 2 seconds,
</p>
<p>
thus the duration of transient period is about 10 seconds.
</p>
</html>", revisions="<html>
<ul>
<li>
June 4, 2014, by Marco Bonvini:<br/>
Added model, documentation and results for regression test.
</li>
</ul>
</html>"));
end RCModel;
