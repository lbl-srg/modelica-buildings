within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.Validation;
model ControlProcessModel "Test model for ControlProcessModel"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.ControlProcessModel
    controlProcessModel(yLow=0.1)
    "Calculates the parameters of the system model for the control process"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  CDL.Continuous.Sources.TimeTable tOn(
    table=[0,1; 0.1,1; 0.3,1; 0.7,1; 0.83,1; 0.85,2],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "The length of the On period"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  CDL.Continuous.Sources.TimeTable ratioLT(
    table=[0,0.3; 0.1,0.5; 0.3,0.1; 0.7,0.5; 0.83,0.8; 0.85,0.5],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "The ratio between the time constant and the time delay of a first order time delay model"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.RealExpression referenceT(y=tOn.y[1]/log(max((0.5/max(
         abs(controlProcessModel.k), 1E-11) - 0.1 + exp(ratioLT.y[1])*(1 + 0.1))
        /(1 - 0.5/max(abs(controlProcessModel.k), 1E-11)), 1E-11)))
    "Reference value for the time constant"
    annotation (Placement(transformation(extent={{-10,48},{10,68}})));
  Modelica.Blocks.Sources.RealExpression referenceL(y=ratioLT.y[1]*referenceT.y)
    "Reference value for the time delay"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  CDL.Continuous.Sources.TimeTable u(
    table=[0,1; 0.1,0.5; 0.3,0.5; 0.7,0.5; 0.83,1; 0.85,1],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "The response of a relay controller"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  CDL.Continuous.Sources.TimeTable tOff(
    table=[0,1; 0.1,1; 0.3,1; 0.7,3; 0.83,3; 0.85,3],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "The length of the Off period"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  CDL.Logical.Sources.TimeTable tuningStart(table=[0,0; 0.1,0; 0.3,1; 0.7,1;
        0.83,1; 0.85,1], period=2)
    "Mimicking the signal for the tuning period start"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  CDL.Logical.Sources.TimeTable tuningEnd(table=[0,0; 0.1,0; 0.3,0; 0.7,1; 0.83,
        1; 0.85,1], period=2) "Mimicking the signal for the tuning period end"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
equation
  connect(tOn.y[1], controlProcessModel.tOn) annotation (Line(points={{-38,30},{
          -20,30},{-20,4},{-12,4}}, color={0,0,127}));
  connect(ratioLT.y[1], controlProcessModel.ratioLT) annotation (Line(points={{-38,
          -30},{-20,-30},{-20,-8},{-12,-8}}, color={0,0,127}));
  connect(u.y[1], controlProcessModel.u) annotation (Line(points={{-38,60},{-16,
          60},{-16,8},{-12,8}}, color={0,0,127}));
  connect(tOff.y[1], controlProcessModel.tOff) annotation (Line(points={{-38,0},
          {-20,0},{-20,-4},{-12,-4}}, color={0,0,127}));
  connect(tuningStart.y[1], controlProcessModel.triggerStart) annotation (Line(
        points={{-38,-70},{-30,-70},{-30,-38},{-6,-38},{-6,-12}}, color={255,0,
          255}));
  connect(controlProcessModel.triggerEnd, tuningEnd.y[1])
    annotation (Line(points={{6,-12},{6,-70},{2,-70}}, color={255,0,255}));
  annotation (
      experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/SystemIdentification/FirstOrderTimedelayed/Validation/ControlProcessModel.mos" "Simulate and plot"),
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
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.ControlProcessModel\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.ControlProcessModel</a>.
</p>
</html>"));
end ControlProcessModel;
