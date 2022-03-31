within Buildings.Controls.OBC.CDL.Continuous.Validation;
model PIDWithAutoTuning "Test model for PID controller"
  Sources.Sine                                        sin1(freqHz=1/60, offset=0.3,
    startTime=0.025)
                 "Setpoint"
    annotation (Placement(transformation(extent={{-90,14},{-70,34}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithAutoTuning limPIDwithAutoTuning(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID,
    Ti_start=1,
    Td_start=1,
    yUpperLimit=4,
    yLowerLimit=-0.5,
    deadBand=0.3,
    yMin=-1) "PID controller" annotation (Placement(transformation(extent={{-30,40},{-10,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const(k=0)
    "Measurement data"
    annotation (Placement(transformation(extent={{-90,-22},{-70,-2}})));
  Buildings.Controls.OBC.CDL.Continuous.PID limPID(
    Ti=1,
    Td=1,
    yMin=-1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID) "PID controller" annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));

equation
  connect(sin1.y, limPIDwithAutoTuning.u_s) annotation (Line(points={{-68,24},{-54,24},{-54,50},{-32,50}}, color={0,0,127}));
  connect(const.y, limPIDwithAutoTuning.u_m) annotation (Line(points={{-68,-12},{-62,-12},{-62,30},{-20,30},{-20,38}}, color={0,0,127}));
  connect(const.y, limPID.u_m) annotation (Line(points={{-68,-12},{-62,-12},{-62,30},{2,30},{2,-18},{-18,-18},{-18,-12}}, color={0,0,127}));
  connect(sin1.y, limPID.u_s) annotation (Line(points={{-68,24},{-54,24},{-54,0},{-30,0}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=120,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/PIDWithAutoTuning.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.PIDWithAutoTuning\">
Buildings.Controls.OBC.CDL.Continuous.PIDWithAutoTuning</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>March 30, 2022, by Sen Huang:<br>First implementation. </li>
</ul>
</html>"),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end PIDWithAutoTuning;
