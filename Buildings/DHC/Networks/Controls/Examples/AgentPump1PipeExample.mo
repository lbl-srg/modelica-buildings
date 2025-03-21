within Buildings.DHC.Networks.Controls.Examples;
model AgentPump1PipeExample
  extends Modelica.Icons.Example;
  parameter Real TSou(
    displayUnit="degC",
    unit="K") = 283.15
    "Agent source temperature";
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable TSouIn(
    table=[0,TSou; 900,TSou + 3; 2700, TSou - 3; 3600,TSou],
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic)
    "Source inlet temperature"
    annotation (Placement(transformation(extent={{-80,58},{-60,78}})));
  Buildings.DHC.Networks.Controls.AgentPump1Pipe agePumCon(
    yPumMin=0,
    dToff=0.5,
    k=1,
    Ti=600) "Agent pump controller"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant  con2(k=TSou)
    "Average source temperature"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable TSouOut(
    table=[0,TSou; 900,TSou + 1; 2700, TSou - 1; 3600,TSou],
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic)
    "Supply temperature"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TPlaSup(k=TSou)
    "Plant supply temperature"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable TDisRet(
    table=[0,TSou; 1800,TSou + 1; 1800,TSou - 1; 3600,TSou],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic)
    "District return temperature"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
equation
  connect(con2.y,agePumCon. TSou) annotation (Line(points={{-58,40},{32,40},{32,
          3},{58,3}},  color={0,0,127}));
  connect(TSouOut.y[1],agePumCon. TSouOut) annotation (Line(points={{-58,10},{28,
          10},{28,-1},{58,-1}}, color={0,0,127}));
  connect(TDisRet.y[1],agePumCon.TRetDis)  annotation (Line(points={{-58,-20},{32,
          -20},{32,-5},{58,-5}}, color={0,0,127}));
  connect(TSouIn.y[1], agePumCon.TSouIn) annotation (Line(points={{-58,68},{40,68},
          {40,7},{58,7}}, color={0,0,127}));
  connect(TPlaSup.y, agePumCon.TSupDis) annotation (Line(points={{-58,-50},{40,-50},
          {40,-8},{58,-8}}, color={0,0,127}));
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
