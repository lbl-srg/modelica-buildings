within Buildings.HeatTransfer.Examples;
model ConductorMultiLayer "Test model for heat conductor"
  extends Modelica.Icons.Example;
  Buildings.HeatTransfer.Sources.FixedTemperature TB(T=293.15)
    annotation (Placement(transformation(extent={{80,0},{60,20}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Sources.Step step(
    height=10,
    offset=293.15,
    startTime=43200)
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.HeatTransfer.Conduction.MultiLayer con(
    steadyStateInitial=false,
    redeclare
      Buildings.HeatTransfer.Data.OpaqueConstructions.Insulation100Concrete200
      layers,
    A=0.1)
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.HeatTransfer.Convection.Interior conv(      A=0.1, til=Buildings.Types.Tilt.Wall)
    "Convective heat transfer"
    annotation (Placement(transformation(extent={{0,0},{-20,20}})));
equation
  connect(step.y, TA.T) annotation (Line(
      points={{-79,10},{-62,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con.port_b, TB.port) annotation (Line(
      points={{40,10},{60,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conv.fluid, TA.port) annotation (Line(
      points={{-20,10},{-40,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conv.solid, con.port_a) annotation (Line(
      points={{5.55112e-16,10},{20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (experiment(StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Examples/ConductorMultiLayer.mos" "Simulate and plot"),
    Documentation(info="<html>
This example illustrates how to use a solid material, set its heat capacity to zero,
and then use this material in a multi-layer construction.
The plot window shows that the insulation is computed in steady state, where
as the brick is computed using transient heat conduction.
</html>", revisions="<html>
<ul>
<li>
March 6 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConductorMultiLayer;
