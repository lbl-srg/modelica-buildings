within Buildings.DHC.Networks.Controls.Examples;
model MainPump1PipeExample
    extends Modelica.Icons.Example;
    parameter Modelica.Units.SI.Temperature TSou(displayUnit="degC") = 284.65
    "Agent source temperature";
  Modelica.Blocks.Sources.CombiTimeTable TMixandTSouIn(
  table=[0,TSou; 900,TSou + 6.5; 2700,TSou - 6.5; 3600,TSou],
  extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.CombiTimeTable TSouOut(
  table=[0,TSou; 900,TSou + 4; 2700,TSou - 4; 3600,TSou],
  extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.DHC.Networks.Controls.MainPump1Pipe conPum(
    nMix=1,
    nSou=1,
    nBui=1,
    TMax=289.15) annotation (Placement(transformation(extent={{40,0},{66,40}})));
  Modelica.Blocks.Sources.CombiTimeTable QCoo_flow(
    table=[0,-500; 1800,-500; 1800,0; 3600,0],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
equation
  connect(TSouOut.y, conPum.TSouOut) annotation (Line(points={{-59,10},{-10,10},
          {-10,16},{37.8,16}},
                           color={0,0,127}));
  connect(TMixandTSouIn.y, conPum.TSouIn) annotation (Line(points={{-59,50},{20,
          50},{20,26},{37.8,26}}, color={0,0,127}));
  connect(QCoo_flow.y, conPum.QCoo_flow) annotation (Line(points={{-59,-20},{20,
          -20},{20,8},{37.8,8}}, color={0,0,127}));
  connect(TMixandTSouIn.y, conPum.TMix) annotation (Line(points={{-59,50},{20,
          50},{20,34},{37.8,34}},
                              color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/DHC/Networks/Controls/Examples/MainPump1PipeExample.mos"
  "Simulate and plot"),
    experiment(StopTime=3600,Tolerance=1e-06),
    Documentation(revisions="<html>
<ul>
<li>
January 20, 2023, by Ettore Zanetti:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model is used to test the controller
<a href=\"modelica://Buildings.DHC.Networks.Controls.MainPump1Pipe\">Buildings.DHC.Networks.Controls.MainPump1Pipe</a>.For a practical application of the model check <a href=\"modelica://Buildings.DHC.Examples.Combined.SeriesVariableFlow\">Buildings.DHC.Examples.Combined.SeriesVariableFlow</a>.
</p>
</html>"));
end MainPump1PipeExample;
