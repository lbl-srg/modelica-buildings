within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.Validation;
model TimeConstantDelay "Test model for TimeConstantDelay"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.TimeConstantDelay
    timeConstantDelay(yLow=0.1)
    "Calculates the time constant and the time delay"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  CDL.Continuous.Sources.TimeTable tOn(
    table=[0,1; 0.1,1; 0.3,1; 0.7,1; 0.83,1; 0.85,2],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "The length of the On period"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  CDL.Continuous.Sources.TimeTable k(
    table=[0,1; 0.1,1; 0.3,1; 0.7,1; 0.83,1],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "Gain of a first order time delay model"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  CDL.Continuous.Sources.TimeTable ratioLT(
    table=[0,0.3; 0.1,0.5; 0.3,0.1; 0.7,0.5; 0.83,0.8; 0.85,0.5],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "The ratio between the time constant and the time delay of a first order time delay model"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.RealExpression referenceT(y=tOn.y[1]/log((0.5/abs(k.y[
        1]) - 0.1 + exp(ratioLT.y[1])*(1 + 0.1))/(1 - 0.5/abs(k.y[1]))))
    "Reference value for the time constant"
    annotation (Placement(transformation(extent={{-10,48},{10,68}})));
  Modelica.Blocks.Sources.RealExpression referenceL(y=ratioLT.y[1]*referenceT.y)
    "Reference value for the time delay"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
equation
  connect(tOn.y[1], timeConstantDelay.tOn) annotation (Line(points={{-38,30},{-20,
          30},{-20,6},{-12,6}}, color={0,0,127}));
  connect(k.y[1], timeConstantDelay.k)
    annotation (Line(points={{-38,0},{-12,0}}, color={0,0,127}));
  connect(ratioLT.y[1], timeConstantDelay.ratioLT) annotation (Line(points={{-38,
          -30},{-20,-30},{-20,-6},{-12,-6}}, color={0,0,127}));
  annotation (
      experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/SystemIdentification/FirstOrderTimedelayed/Validation/TimeConstantDelay.mos" "Simulate and plot"),
      Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.TimeConstantDelay\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.TimeConstantDelay</a>.
</p>
</html>"));
end TimeConstantDelay;
