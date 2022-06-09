within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.Amigo.Validation;
model PIDDerivativeTime "Test model for PIDDerivativeTime"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.Amigo.PIDDerivativeTime
    pIDDerivativeTime "Calculates the integral time for a PI controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  CDL.Continuous.Sources.Ramp T(
    height=0.5,
    duration=1,
    offset=0.5) "Time constant of the first order time-delayed model"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  CDL.Continuous.Sources.Ramp L(
    height=0.3,
    duration=1,
    offset=0.3) "Time delay of the first order time-delayed model"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Modelica.Blocks.Sources.RealExpression referenceTd(y=0.5*L.y*T.y/(0.3*L.y + T.y))
    "Reference value for the derivative time"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
equation
  connect(L.y, pIDDerivativeTime.L) annotation (Line(points={{-38,-40},{-20,-40},
          {-20,-6},{-12,-6}}, color={0,0,127}));
  connect(T.y, pIDDerivativeTime.T) annotation (Line(points={{-38,0},{-26,0},{-26,
          6},{-12,6}}, color={0,0,127}));
  annotation (
      experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/AutoTuner/AMIGO/Validation/PIDDerivativeTime.mos" "Simulate and plot"),
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
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PIDerivativeTime\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.AutoTuner.AMIGO.PIDerivativeTime</a>.
</p>
</html>"));
end PIDDerivativeTime;
