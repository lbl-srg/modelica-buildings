within Buildings.HeatTransfer.Examples;
model ConductorMultiLayerCTF
  "Test model for heat conductor that uses the CTF method"
  extends Modelica.Icons.Example;

  parameter Data.OpaqueConstructions.Insulation100Concrete200 datOpaCon
    "Data for construction"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));

  Sources.FixedHeatFlow Q_b_flow(Q_flow=0) "Heat flow rate at surface b"
    annotation (Placement(transformation(extent={{40,0},{20,20}})));
  Sources.PrescribedHeatFlow Q_a_flow "Heat flow rate at surface a"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.Step step(
    startTime=43200,
    offset=0,
    height=10) "Step function for heat flow rate"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Conduction.MultiLayerCTF con(
    A=0.1,
    layers=datOpaCon,
    samplePeriod=900)
    "Conduction model"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

equation
  connect(Q_a_flow.Q_flow, step.y)
    annotation (Line(points={{-40,10},{-48,10},{-59,10}}, color={0,0,127}));
  connect(Q_a_flow.port, con.port_a)
    annotation (Line(points={{-20,10},{-20,10},{-10,10}}, color={191,0,0}));
  connect(Q_b_flow.port, con.port_b)
    annotation (Line(points={{20,10},{20,10},{10,10}}, color={191,0,0}));
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
January 12, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConductorMultiLayerCTF;
