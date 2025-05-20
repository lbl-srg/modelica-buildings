within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.Validation;
model PID "Test model for calculating parameters of a PID controller"
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PID PID
    "Block that calculates the control gain, the integral time, and the derivative time"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp kp(
    duration=1,
    offset=1,
    height=1)
    "Gain of a first-order plus time-delay (FOPTD) model"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp T(
    duration=1,
    offset=0.5,
    height=0.5)
    "Time constant of the FOPTD model"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp L(
    duration=1,
    offset=0.3,
    height=0.3)
    "Time delay of the FOPTD model"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
equation
  connect(kp.y, PID.kp) annotation (Line(points={{-38,30},{-20,30},{-20,6},{-12,
          6}}, color={0,0,127}));
  connect(T.y, PID.T) annotation (Line(points={{-38,-10},{-20,-10},{-20,0},{-12,
          0}}, color={0,0,127}));
  connect(PID.L, L.y) annotation (Line(points={{-12,-6},{-16,-6},{-16,-50},{-38,
          -50}}, color={0,0,127}));
  annotation (
      experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/AutoTuner/AMIGO/Validation/PID.mos" "Simulate and plot"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
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
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation.<br/>
</li>
</ul>
</html>", info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PID\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PID</a>.
</p>
<p>
The input <code>kp</code> varies from <i>1</i> to <i>2</i>, input <code>T</code> varies from <i>0.5</i> to <i>1</i>,
and input <code>L</code> varies from <i>0.3</i> to <i>0.6</i>.
</p>
<p>
The control gain,
the time constant of the integral term, and the time constant of the derivative term are calculated
based on the equations shown in
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.BaseClasses.PIDGain\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.AutoTuner.BaseClasses.AMIGO.PIDGain</a>,
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.BaseClasses.PIDIntegralTime\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.AutoTuner.AMIGO.BaseClasses.PIDIntegralTime</a>,
and
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.BaseClasses.PIDDerivativeTime\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.AutoTuner.AMIGO.BaseClasses.PIDDerivativeTime</a>.
</p>
</html>"));
end PID;
