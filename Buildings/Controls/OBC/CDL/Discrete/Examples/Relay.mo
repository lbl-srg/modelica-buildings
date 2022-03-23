within Buildings.Controls.OBC.CDL.Discrete.Examples;
model Relay "Example model for block that outputs a relay signal"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.CDL.Discrete.Relay relay(
    yUpperLimit=1,
    yLowerLimit=-0.5,
    deadBand=1) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=1.2,
    f=1/60,
    offset=0,
    startTime=0.025)                                      "Sine source"
    annotation (Placement(transformation(extent={{-60,12},{-40,32}})));
  Modelica.Blocks.Sources.Constant const(k=0) annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
equation
  connect(sine.y, relay.u1) annotation (Line(points={{-39,22},{-20,22},{-20,4},{-11,4}}, color={0,0,127}));
  connect(const.y, relay.u2) annotation (Line(points={{-39,-20},{-20,-20},{-20,-4.4},{-11,-4.4}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Discrete/Examples/Relay.mos"
        "Simulate and plot"),Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=120, __Dymola_Algorithm="Dassl"));
end Relay;
