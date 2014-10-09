within Districts.Electrical.AC.ThreePhasesBalanced.Sensors.Examples;
model GeneralizedSensor "Example model for generalized sensor"
  import Districts;
  extends Modelica.Icons.Example;
  Districts.Electrical.AC.ThreePhasesBalanced.Sensors.GeneralizedSensor
                                                          sen
    annotation (Placement(transformation(extent={{-20,2},{0,22}})));
  Districts.Electrical.AC.ThreePhasesBalanced.Loads.CapacitiveLoadP
                                                         loa(P_nominal=100)
    "Constant load"
    annotation (Placement(transformation(extent={{40,2},{60,22}})));
  Districts.Electrical.AC.ThreePhasesBalanced.Sources.FixedVoltage
                                                        sou(V=120)
    "Voltage source"
    annotation (Placement(transformation(extent={{-60,2},{-40,22}})));
equation
  connect(sen.terminal_p, loa.terminal)
    annotation (Line(points={{5.55112e-16,12},{40,12}}, smooth=Smooth.None));
  connect(sen.terminal_n, sou.terminal)
    annotation (Line(points={{-20,12},{-40,12}}, smooth=Smooth.None));
  annotation (Documentation(
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics),
Commands(file=
          "modelica://Districts/Resources/Scripts/Dymola/Electrical/AC/AC3ph/Sensors/Examples/GeneralizedSensor.mos"
        "Simulate and plot"));
end GeneralizedSensor;
