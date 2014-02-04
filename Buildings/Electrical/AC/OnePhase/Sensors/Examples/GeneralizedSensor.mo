within Buildings.Electrical.AC.OnePhase.Sensors.Examples;
model GeneralizedSensor "Example model for generalized sensor"
  import Buildings;
  extends Modelica.Icons.Example;
  Buildings.Electrical.AC.OnePhase.Sensors.GeneralizedSensor
                                                          sen
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Electrical.AC.OnePhase.Loads.CapacitiveLoadP
                                                      loa(
    mode=Buildings.Electrical.Types.Assumption.FixedZ_dynamic,
    V_nominal=120,
    P_nominal=-100) "Constant load"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Electrical.AC.OnePhase.Sources.FixedVoltage sou(V=120)
    "Voltage source"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Electrical.AC.OnePhase.Lines.TwoPortResistance res(R=0.05)
    annotation (Placement(transformation(extent={{-32,0},{-12,20}})));
equation
  connect(sen.terminal_p, loa.terminal)
    annotation (Line(points={{20,10},{40,10}},          smooth=Smooth.None));
  connect(sou.terminal, res.terminal_n) annotation (Line(
      points={{-40,10},{-32,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(res.terminal_p, sen.terminal_n) annotation (Line(
      points={{-12,10},{-4.44089e-16,10}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (experiment(StopTime=0.1, Tolerance=1e-05),
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
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/OnePhase/Sensors/Examples/GeneralizedSensor.mos"
        "Simulate and plot"));
end GeneralizedSensor;
