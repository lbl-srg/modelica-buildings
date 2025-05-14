within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.BaseClasses.Validation;
model PIIntegralTime "Test model for calculating the integral time for a PI controller"
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.BaseClasses.PIIntegralTime
    PIIntTim
    "Block that calculates the integral time"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp T(
    duration=1,
    offset=0.5,
    height=0.5)
    "Time constant of a first-order plus time-delay (FOPTD) model"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp L(
    duration=1,
    offset=0.3,
    height=0.3)
    "Time delay of the FOPTD model"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
equation
  connect(T.y, PIIntTim.T) annotation (Line(points={{-38,20},{-20,20},{-20,6},{-12,
          6}}, color={0,0,127}));
  connect(L.y, PIIntTim.L) annotation (Line(points={{-38,-20},{-20,-20},{-20,-6},
          {-12,-6}}, color={0,0,127}));
  annotation (
      experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/AutoTuner/AMIGO/BaseClasses/Validation/PIIntegralTime.mos" "Simulate and plot"),
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
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.BaseClasses.PIIntegralTime\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.BaseClasses.PIIntegralTime</a>.
</p>
<p>
The input <code>T</code> varies from <i>0.5</i> to <i>1</i>,
and input <code>L</code> varies from <i>0.3</i> to <i>0.6</i>.
</p>
</html>"));
end PIIntegralTime;
