within Buildings.HeatTransfer.Examples;
model ConstructionConvection
  "Test model for a construction with different film coefficients"
  import Buildings;
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TA
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.Step step(
    offset=293.15,
    startTime=43200,
    height=20)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TA1
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.HeatTransfer.ConstructionOpaque const(
    steadyStateInitial=true,
    A=10,
    redeclare function qCon_a_flow =
        Buildings.HeatTransfer.Functions.ConvectiveHeatFlux.constantCoefficient,
    redeclare function qCon_b_flow =
        Buildings.HeatTransfer.Functions.ConvectiveHeatFlux.constantCoefficient,
    redeclare Buildings.HeatTransfer.Data.OpaqueConstructions.Concrete200
      layers) "Model of the construction with convective heat transfer"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,10})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TB1
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Modelica.Blocks.Sources.Constant Tb(k=293.15 + 30)
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TA4
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TA5
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Buildings.HeatTransfer.ConstructionOpaque wall(
    steadyStateInitial=true,
    A=10,
    redeclare function qCon_a_flow =
        Buildings.HeatTransfer.Functions.ConvectiveHeatFlux.wall,
    redeclare function qCon_b_flow =
        Buildings.HeatTransfer.Functions.ConvectiveHeatFlux.wall,
    redeclare Buildings.HeatTransfer.Data.OpaqueConstructions.Concrete200
      layers) "Model of the construction with convective heat transfer"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,10})));
  Buildings.HeatTransfer.ConstructionOpaque floor(
    steadyStateInitial=true,
    A=10,
    redeclare function qCon_a_flow =
        Buildings.HeatTransfer.Functions.ConvectiveHeatFlux.floor,
    redeclare function qCon_b_flow =
        Buildings.HeatTransfer.Functions.ConvectiveHeatFlux.ceiling,
    redeclare Buildings.HeatTransfer.Data.OpaqueConstructions.Concrete200
      layers) "Model of the construction with convective heat transfer"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,10})));
  Buildings.HeatTransfer.ConstructionOpaque ceiling(
    steadyStateInitial=true,
    A=10,
    redeclare function qCon_a_flow =
        Buildings.HeatTransfer.Functions.ConvectiveHeatFlux.ceiling,
    redeclare function qCon_b_flow =
        Buildings.HeatTransfer.Functions.ConvectiveHeatFlux.floor,
    redeclare Buildings.HeatTransfer.Data.OpaqueConstructions.Concrete200
      layers) "Model of the construction with convective heat transfer"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={120,10})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TB2
    annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TB3
    annotation (Placement(transformation(extent={{70,-40},{90,-20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TB4
    annotation (Placement(transformation(extent={{110,-40},{130,-20}})));
equation
  connect(step.y, TA.T) annotation (Line(
      points={{-59,70},{-50,70},{-50,50},{-42,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tb.y,TB1. T) annotation (Line(
      points={{-29,-60},{-24,-60},{-24,-30},{-12,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TA.port, const.port_a)  annotation (Line(
      points={{-20,50},{-16,50},{-16,10},{-10,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TA1.port, wall.port_a)    annotation (Line(
      points={{20,50},{24,50},{24,10},{30,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TA4.port, floor.port_a)   annotation (Line(
      points={{60,50},{66,50},{66,10},{70,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TA5.port,ceiling. port_a) annotation (Line(
      points={{100,50},{106,50},{106,10},{110,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(step.y, TA1.T) annotation (Line(
      points={{-59,70},{-10,70},{-10,50},{-2,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(step.y, TA4.T) annotation (Line(
      points={{-59,70},{30,70},{30,50},{38,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(step.y, TA5.T) annotation (Line(
      points={{-59,70},{70,70},{70,50},{78,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tb.y, TB2.T) annotation (Line(
      points={{-29,-60},{20,-60},{20,-30},{28,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tb.y, TB3.T) annotation (Line(
      points={{-29,-60},{58,-60},{58,-30},{68,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tb.y, TB4.T) annotation (Line(
      points={{-29,-60},{98,-60},{98,-30},{108,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.port_b, TB1.port)  annotation (Line(
      points={{10,10},{14,10},{14,-30},{10,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(wall.port_b, TB2.port)    annotation (Line(
      points={{50,10},{54,10},{54,-30},{50,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(floor.port_b, TB3.port)   annotation (Line(
      points={{90,10},{94,10},{94,-30},{90,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ceiling.port_b, TB4.port) annotation (Line(
      points={{130,10},{134,10},{134,-30},{130,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{160,100}}), graphics), Commands(file=
          "ConstructionConvection.mos" "run"),
    Documentation(info="<html>
This example test the construction model with different convective heat transfer coefficients.
</html>", revisions="<html>
<ul>
<li>
March 6 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    experiment(StopTime=86400),
    experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{160,100}})));
end ConstructionConvection;
