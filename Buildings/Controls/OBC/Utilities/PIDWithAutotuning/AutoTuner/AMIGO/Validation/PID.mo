within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.Amigo.Validation;
model PID "Test model for PID"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.Amigo.PID pID
    "Calculates the parameters for a PI controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp kp(duration=1, offset=1)
    "Gain of the first order time-delayed model"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp T(
    height=0.5,
    duration=1,
    offset=0.5) "Time constant of the first order time-delayed model"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp L(
    height=0.3,
    duration=1,
    offset=0.3) "Time delay of the first order time-delayed model"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Modelica.Blocks.Sources.RealExpression referencek(y=1/kp.y*(0.2 + 0.45*T.y/L.y))
                                                "Reference value for the gain"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Modelica.Blocks.Sources.RealExpression referenceTi(y=(0.4*L.y + 0.8*T.y)/(L.y +
        0.1*T.y)*L.y)
    "Reference value for the integral time"
    annotation (Placement(transformation(extent={{-10,32},{10,52}})));
  Modelica.Blocks.Sources.RealExpression referenceTd(y=0.5*L.y*T.y/(0.3*L.y + T.y))
    "Reference value for the derivative time"
    annotation (Placement(transformation(extent={{-10,12},{10,32}})));
equation
  connect(L.y, pID.L) annotation (Line(points={{-38,-40},{-20,-40},{-20,-6},{-12,
          -6}}, color={0,0,127}));
  connect(T.y, pID.T)
    annotation (Line(points={{-38,0},{-12,0}}, color={0,0,127}));
  connect(pID.kp, kp.y) annotation (Line(points={{-12,6},{-20,6},{-20,40},{-38,40}},
        color={0,0,127}));
  annotation (
      experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/AutoTuner/AMIGO/Validation/PID.mos" "Simulate and plot"),
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
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PID\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PID</a>.
</p>
</html>"));
end PID;
