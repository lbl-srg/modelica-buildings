within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.Validation;
model PI "Test model for calculating parameters of a PI controller"
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PI PI
    "Blocks that calculates the control gain and the integral time"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp kp(
    duration=1,
    offset=1,
    height=1)
    "Gain of a first-order plus time-delay (FOPTD) model"
    annotation (Placement(transformation(extent={{-60,22},{-40,42}})));
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
  connect(L.y, PI.L) annotation (Line(points={{-38,-50},{-20,-50},{-20,-6},{-12,
          -6}}, color={0,0,127}));
  connect(T.y, PI.T) annotation (Line(points={{-38,-10},{-26,-10},{-26,0},{-12,0}},
        color={0,0,127}));
  connect(kp.y, PI.kp) annotation (Line(points={{-38,32},{-20,32},{-20,6},{-12,6}},
        color={0,0,127}));

annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/AutoTuner/AMIGO/Validation/PI.mos" "Simulate and plot"),
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
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
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
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PI\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PI</a>.
</p>
<p>
The input <code>kp</code> varies from <i>1</i> to <i>2</i>, input <code>T</code> varies from <i>0.5</i> to <i>1</i>,
and input <code>L</code> varies from <i>0.3</i> to <i>0.6</i>.
</p>
<p>
The control gain and
the time constant of the integral term are calculated based on the equations shown in
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.BaseClasses.PIGain\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.AutoTuner.BaseClasses.AMIGO.PIGain</a>
and
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.BaseClasses.PIIntegralTime\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.AutoTuner.AMIGO.BaseClasses.PIIntegralTime</a>.
</p>
</html>"));
end PI;
