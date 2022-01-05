within Buildings.Electrical.DC.Sources.Examples;
model VoltageSource "Example for the variable voltage source model"
  extends Modelica.Icons.Example;
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{-92,-40},{-72,-20}})));
  Buildings.Electrical.DC.Loads.Resistor res(R=0.5, V_nominal=12)
    "Resistance"
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));
  Buildings.Electrical.DC.Sources.VoltageSource sou "Voltage source"
    annotation (Placement(transformation(extent={{-82,-10},{-62,10}})));
  Buildings.Electrical.DC.Lines.TwoPortResistance lin(R=0.5)
    "Transmission line"
    annotation (Placement(transformation(extent={{-52,-10},{-32,10}})));
  Buildings.Electrical.DC.Sensors.GeneralizedSensor sen "Sensor"
    annotation (Placement(transformation(extent={{-14,-10},{6,10}})));
  Modelica.Blocks.Sources.Sine cosine(
    phase=0,
    f=1,
    offset=12,
    amplitude=3) "Variable voltage signal"
    annotation (Placement(transformation(extent={{-120,-4},{-100,16}})));
equation
  connect(lin.terminal_p, sen.terminal_n) annotation (Line(
      points={{-32,0},{-14,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.n, ground.p) annotation (Line(
      points={{-82,0},{-82,-20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sen.terminal_p, res.terminal) annotation (Line(
      points={{6,0},{26,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.terminal, lin.terminal_n) annotation (Line(
      points={{-62,0},{-52,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(cosine.y, sou.V_in) annotation (Line(
      points={{-99,6},{-82,6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -100},{100,140}}),      graphics),
    experiment(StopTime=1, Tolerance=1e-6),
Documentation(info="<html>
<p>
This model illustrates the use of the variable voltage source model.
</p>
</html>",
      revisions="<html>
<ul>
<li>
October 14, 2012, by Marco Bonvini:<br/>
Added model and documentation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/DC/Sources/Examples/VoltageSource.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(extent={{-140,-100},{100,140}})));
end VoltageSource;
