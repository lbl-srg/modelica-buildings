within Buildings.Controls.OBC.CDL.Continuous.Validation;
model LimPIDInitialOutput
  "Test model for LimPID controller with initial output specified"

  Buildings.Controls.OBC.CDL.Continuous.LimPID limPIDPar(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID,
    k=3,
    yMax=1,
    yMin=0,
    initType=Buildings.Controls.OBC.CDL.Types.Init.InitialOutput,
    y_start=0.5) "Controller, reset to parameter value"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID limPIDInp(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID,
    k=3,
    yMax=1,
    yMin=0,
    initType=Buildings.Controls.OBC.CDL.Types.Init.InitialOutput,
    y_start=0.5,
    y_reset=0.5) "Controller, reset to input value"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yMea(k=0.75)
    "Measured value"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID limPIPar(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=3,
    yMax=1,
    yMin=0,
    initType=Buildings.Controls.OBC.CDL.Types.Init.InitialOutput,
    y_start=0.5) "Controller, reset to parameter value"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID limPIInp(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=3,
    yMax=1,
    yMin=0,
    initType=Buildings.Controls.OBC.CDL.Types.Init.InitialOutput,
    y_start=0.5) "Controller, reset to input value"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Sources.Constant ySet(k=0.75) "Set point"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
equation
  connect(ySet.y, limPIDPar.u_s) annotation (Line(points={{-18,80},{0,80},{0,70},
          {18,70}}, color={0,0,127}));
  connect(ySet.y, limPIDInp.u_s) annotation (Line(points={{-18,80},{0,80},{0,30},
          {18,30}}, color={0,0,127}));
  connect(ySet.y, limPIPar.u_s) annotation (Line(points={{-18,80},{0,80},{0,-30},
          {18,-30}}, color={0,0,127}));
  connect(ySet.y, limPIInp.u_s) annotation (Line(points={{-18,80},{0,80},{0,-70},
          {18,-70}}, color={0,0,127}));
  connect(yMea.y, limPIDPar.u_m)
    annotation (Line(points={{-18,50},{30,50},{30,58}}, color={0,0,127}));
  connect(yMea.y, limPIDInp.u_m) annotation (Line(points={{-18,50},{-4,50},{-4,
          8},{30,8},{30,18}}, color={0,0,127}));
  connect(yMea.y, limPIPar.u_m) annotation (Line(points={{-18,50},{-4,50},{-4,
          -46},{30,-46},{30,-42}}, color={0,0,127}));
  connect(yMea.y, limPIInp.u_m) annotation (Line(points={{-18,50},{-4,50},{-4,
          -86},{30,-86},{30,-82}}, color={0,0,127}));
 annotation (
 experiment(
      StopTime=10,
      Tolerance=1e-06),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/LimPIDWithReset.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.LimPID\">
Buildings.Controls.OBC.CDL.Continuous.LimPID</a>.
</p>
<p>
This model validates the controller for different settings of the control output reset.
</p>
</html>", revisions="<html>
<ul>
<li>
April 7, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-140},{100,100}}),
         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})));
end LimPIDInitialOutput;
