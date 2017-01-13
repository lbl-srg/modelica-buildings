within Buildings.HeatTransfer.Examples;
model ConductorMultiLayerCTF
  "Test model for heat conductor that uses the CTF method"
  extends Modelica.Icons.Example;

  parameter Data.OpaqueConstructions.Insulation100Concrete200 datOpaCon
    annotation (Placement(transformation(extent={{60,40},{80,60}})));

  Buildings.HeatTransfer.Sources.FixedTemperature TB(T=293.15)
    "Boundary temperature at surface b"
    annotation (Placement(transformation(extent={{90,0},{70,20}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA
    "Boundary temperature at surface a"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Sources.Step step(
    height=10,
    offset=293.15,
    startTime=43200)
    "Step function for temperature"
    annotation (Placement(transformation(extent={{-92,0},{-72,20}})));
  Conduction.MultiLayerCTF con(
    A=0.1,
    layers=datOpaCon,
    samplePeriod=900)
    "Conduction model"
    annotation (Placement(transformation(extent={{10,0},{30,20}})));

  Buildings.HeatTransfer.Convection.Interior conv_a(
    A=0.1,
    til=Buildings.Types.Tilt.Wall)
    "Convective heat transfer"
    annotation (Placement(transformation(extent={{-10,0},{-30,20}})));
  Buildings.HeatTransfer.Convection.Interior conv_b(
    A=0.1,
    til=Buildings.Types.Tilt.Wall)
    "Convective heat transfer"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
equation
  connect(step.y, TA.T) annotation (Line(
      points={{-71,10},{-62,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conv_a.fluid, TA.port) annotation (Line(
      points={{-30,10},{-40,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conv_a.solid, con.port_a) annotation (Line(
      points={{-10,10},{10,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conv_b.fluid, TB.port)
    annotation (Line(points={{60,10},{65,10},{70,10}}, color={191,0,0}));
  connect(conv_b.solid, con.port_b)
    annotation (Line(points={{40,10},{30,10}},         color={191,0,0}));
  annotation (experiment(StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Examples/ConductorMultiLayerCTF.mos" "Simulate and plot"),
    Documentation(info="<html>
<p>
This example illustrates how to use the conduction transfer model
that uses the CTF calculation.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConductorMultiLayerCTF;
