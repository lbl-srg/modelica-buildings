within Buildings.DHC.Networks.Controls.Examples;
model MainPump1PipeExample
  extends Modelica.Icons.Example;
  parameter Real TSou(
    displayUnit="degC",
    unit="K") = 284.65
    "Agent source temperature";
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable TMixandTSouIn(
    table=[0,TSou; 900,TSou + 6.5; 2700,TSou - 6.5; 3600,TSou],
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable TSouOut(
    table=[0,TSou; 900,TSou + 4; 2700,TSou - 4; 3600,TSou],
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.DHC.Networks.Controls.MainPump1Pipe conPum(
    nMix=1,
    nSou=1,
    nBui=1,
    TMax=289.15)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable QCoo_flow(
    table=[0,-500; 1800,-500; 1800,0; 3600,0],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
equation
  connect(TSouOut.y, conPum.TSouOut) annotation (Line(points={{-58,0},{-10,0},{-10,
          -4},{38,-4}}, color={0,0,127}));
  connect(TMixandTSouIn.y, conPum.TSouIn) annotation (Line(points={{-58,50},{20,
          50},{20,4},{38,4}},  color={0,0,127}));
  connect(QCoo_flow.y, conPum.QCoo_flow) annotation (Line(points={{-58,-40},{20,
          -40},{20,-8},{38,-8}}, color={0,0,127}));
  connect(TMixandTSouIn.y, conPum.TMix) annotation (Line(points={{-58,50},{20,50},
          {20,8},{38,8}}, color={0,0,127}));
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
<a href=\"modelica://Buildings.DHC.Networks.Controls.MainPump1Pipe\">
Buildings.DHC.Networks.Controls.MainPump1Pipe</a>.
For a practical application of the model check
<a href=\"modelica://Buildings.DHC.Examples.Combined.SeriesVariableFlow\">
Buildings.DHC.Examples.Combined.SeriesVariableFlow</a>.
</p>
</html>"));
end MainPump1PipeExample;
