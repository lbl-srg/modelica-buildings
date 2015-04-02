within Buildings.Electrical.DC.Sensors.Examples;
model GeneralizedSensor "Example model for generalized sensor"
  extends Modelica.Icons.Example;
  Buildings.Electrical.DC.Sensors.GeneralizedSensor sen "Power sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Electrical.DC.Loads.Conductor loa(V_nominal=120, P_nominal=120)
    "Constant load"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Electrical.DC.Sources.ConstantVoltage sou(V=120) "Voltage source"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{-60,-32},{-40,-12}})));
equation
  connect(sen.terminal_p, loa.terminal)
    annotation (Line(points={{10,0},{40,0}},            smooth=Smooth.None));
  connect(sen.terminal_n, sou.terminal)
    annotation (Line(points={{-10,0},{-30,0}},   smooth=Smooth.None));
  connect(sou.n, ground.p) annotation (Line(
      points={{-50,0},{-50,-12}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation ( experiment(StopTime=1,Tolerance=1e-05),
  Documentation(
  info="<html>
<p>
This example illustrates the use of the generalized sensor.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 24, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/DC/Sensors/Examples/GeneralizedSensor.mos"
        "Simulate and plot"));
end GeneralizedSensor;
