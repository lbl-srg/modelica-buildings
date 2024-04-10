within Buildings.DHC.Networks.Controls.Examples;
model AgentPump1PipeExample
    extends Modelica.Icons.Example;
    parameter Modelica.Units.SI.Temperature TSou(displayUnit="degC") = 283.15
    "Agent source temperature";
  Modelica.Blocks.Sources.CombiTimeTable TSouIn(
  table=[0,TSou; 900,TSou + 3; 2700, TSou - 3; 3600,TSou],
  extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-80,58},{-60,78}})));
  Buildings.DHC.Networks.Controls.AgentPump1Pipe AgentPump(
    yPumMin=0,
    dToff=0.5,
    k=1,
    Ti=600) annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant  con2(k=TSou)
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.CombiTimeTable TSouOut(
  table=[0,TSou; 900,TSou + 1; 2700, TSou - 1; 3600,TSou],
  extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TsupDis(k=TSou)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.CombiTimeTable TretDis(
    table=[0,TSou; 1800,TSou + 1; 1800,TSou - 1; 3600,TSou],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
equation
  connect(con2.y, AgentPump.TSou) annotation (Line(points={{-58,40},{32,40},{32,
          3},{38.4615,3}},                             color={0,0,127}));
  connect(TSouOut.y[1], AgentPump.TSouOut) annotation (Line(points={{-59,10},{
          28,10},{28,-1},{38.4615,-1}},    color={0,0,127}));
  connect(TSouIn.y[1], AgentPump.TSouIn) annotation (Line(points={{-59,68},{
          38.4615,68},{38.4615,7}},
                                  color={0,0,127}));
  connect(TretDis.y[1],AgentPump.TRetDis)  annotation (Line(points={{-59,-20},{
          32,-20},{32,-5},{38.4615,-5}},        color={0,0,127}));
  connect(TsupDis.y,AgentPump.TSupDis)  annotation (Line(points={{-58,-50},{
          38.4615,-50},{38.4615,-8}},
                                   color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/DHC/Networks/Controls/Examples/AgentPump1PipeExample.mos"
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
<a href=\"modelica://Buildings.DHC.Networks.Controls.AgentPump1Pipe\">Buildings.DHC.Networks.Controls.AgentPump</a>.
For a practical application of the model check <a href=\"modelica://Buildings.DHC.Examples.Combined.SeriesVariableFlowAgentControl\">Buildings.DHC.Examples.Combined.SeriesVariableFlowUpdate</a>.
</p>
</html>"));
end AgentPump1PipeExample;
