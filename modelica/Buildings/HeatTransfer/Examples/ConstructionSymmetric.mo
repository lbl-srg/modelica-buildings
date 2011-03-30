within Buildings.HeatTransfer.Examples;
model ConstructionSymmetric
  "Test model for a construction with the same boundary condition on both sides"
  import Buildings;
  extends Modelica.Icons.Example;
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.Step step(
    offset=293.15,
    startTime=43200,
    height=20)
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.HeatTransfer.ConductorMultiLayer con(
    steadyStateInitial=true,
    redeclare Buildings.HeatTransfer.Data.OpaqueConstructions.Brick120 layers(
        material={Data.Solids.Brick(x=0.12, nStaRef=5)}),
    A=10)
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.HeatTransfer.Convection conv(A=10,
  til=Buildings.RoomsBeta.Types.Tilt.Wall) "Convective heat transfer"
    annotation (Placement(transformation(extent={{20,40},{0,60}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA1
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.HeatTransfer.Convection conv1(A=10,
  til=Buildings.RoomsBeta.Types.Tilt.Wall) "Convective heat transfer"
    annotation (Placement(transformation(extent={{20,10},{0,30}})));
  Buildings.HeatTransfer.ConstructionOpaque conMod(
    steadyStateInitial=true,
    redeclare Buildings.HeatTransfer.Data.OpaqueConstructions.Brick120 layers(
        material={Data.Solids.Brick(x=0.12, nStaRef=5)}),
    A=10,
    til=Buildings.RoomsBeta.Types.Tilt.Wall)
    "Model of the construction with convective heat transfer"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA2
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA3
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFlo1
    annotation (Placement(transformation(extent={{-26,14},{-14,26}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFlo2
    annotation (Placement(transformation(extent={{-14,-46},{-26,-34}})));
  Buildings.Utilities.Diagnostics.AssertEquality assertEquality(threShold=1E-8)
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.Utilities.Diagnostics.AssertEquality assertEquality1(
                                                                threShold=1E-8)
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFlo3
    annotation (Placement(transformation(extent={{-26,-76},{-14,-64}})));
  Modelica.Blocks.Sources.Constant Tb(k=293.15 + 30)
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
equation
  connect(step.y, TA.T) annotation (Line(
      points={{-79,50},{-62,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conv.fluid, TA.port) annotation (Line(
      points={{-5.55112e-16,50},{-40,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conv.solid, con.port_a) annotation (Line(
      points={{20,50},{40,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conv1.solid, con.port_b) annotation (Line(
      points={{20,20},{70,20},{70,50},{60,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(step.y, TA2.T)
                        annotation (Line(
      points={{-79,50},{-69.5,50},{-69.5,-40},{-62,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TA1.port, heaFlo1.port_a) annotation (Line(
      points={{-40,20},{-26,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaFlo1.port_b, conv1.fluid) annotation (Line(
      points={{-14,20},{-5.55112e-16,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conMod.port_b, heaFlo3.port_b) annotation (Line(
      points={{20,-40},{30,-40},{30,-70},{-14,-70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaFlo3.port_a, TA3.port) annotation (Line(
      points={{-26,-70},{-40,-70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaFlo1.Q_flow, assertEquality.u1) annotation (Line(
      points={{-20,14},{-20,-4},{58,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaFlo2.Q_flow, assertEquality1.u1) annotation (Line(
      points={{-20,-46},{-20,-54},{40,-54},{40,-74},{58,-74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaFlo3.Q_flow, assertEquality1.u2) annotation (Line(
      points={{-20,-76},{-20,-86},{58,-86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaFlo3.Q_flow, assertEquality.u2) annotation (Line(
      points={{-20,-76},{-20,-86},{50,-86},{50,-16},{58,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tb.y, TA1.T) annotation (Line(
      points={{-79,20},{-62,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tb.y, TA3.T) annotation (Line(
      points={{-79,20},{-74,20},{-74,-70},{-62,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TA2.port, heaFlo2.port_b) annotation (Line(
      points={{-40,-40},{-26,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaFlo2.port_a, conMod.port_a) annotation (Line(
      points={{-14,-40},{-5.55112e-16,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics), Commands(file=
          "ConstructionSymmetric.mos" "run"),
    Documentation(info="<html>
This example test the construction model. The boundary condition 
at both surfaces are identical. Thus, the model on top and the composite
model on the bottom should give identical results.
The <code>assert</code> block will stop the simulation if the heat exchange with the boundary
condition differs.
</html>", revisions="<html>
<ul>
<li>
March 6 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    experiment(StopTime=86400),
    experimentSetupOutput);
end ConstructionSymmetric;
