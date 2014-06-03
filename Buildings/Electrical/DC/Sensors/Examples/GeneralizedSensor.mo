within Buildings.Electrical.DC.Sensors.Examples;
model GeneralizedSensor "Example model for generalized sensor"
  import Buildings;
  extends Modelica.Icons.Example;
  Buildings.Electrical.DC.Sensors.GeneralizedSensor sen
    annotation (Placement(transformation(extent={{-20,2},{0,22}})));
  Buildings.Electrical.DC.Loads.Conductor loa(V_nominal=120, P_nominal=120)
    "Constant load"
    annotation (Placement(transformation(extent={{40,2},{60,22}})));
  Buildings.Electrical.DC.Sources.ConstantVoltage sou(V=120) "Voltage source"
    annotation (Placement(transformation(extent={{-60,2},{-40,22}})));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{-70,-20},{-50,0}})));
equation
  connect(sen.terminal_p, loa.terminal)
    annotation (Line(points={{5.55112e-16,12},{40,12}}, smooth=Smooth.None));
  connect(sen.terminal_n, sou.terminal)
    annotation (Line(points={{-20,12},{-40,12}}, smooth=Smooth.None));
  connect(sou.n, ground.p) annotation (Line(
      points={{-60,12},{-60,0}},
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics),
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/DC/Sensors/Examples/GeneralizedSensor.mos"
        "Simulate and plot"));
end GeneralizedSensor;
