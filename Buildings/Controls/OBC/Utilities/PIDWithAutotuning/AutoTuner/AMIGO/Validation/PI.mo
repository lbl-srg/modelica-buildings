within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.Validation;
model PI "Test model for PI"
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PI PI
    "Calculate the parameters for a PI controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable RefDat(table=[0,1,0.5,
        0.3,0.343,0.469; 0.1,1.1,0.55,0.33,0.312,0.516; 0.2,1.2,0.6,0.36,0.286,0.563;
        0.3,1.3,0.65,0.39,0.264,0.609;0.4,1.4,0.7, 0.42,0.245,0.656; 0.5,1.5,
        0.75,0.45,0.228,0.703; 0.6,1.6,0.8,0.48,0.214,0.75; 0.7,1.7, 0.85,0.51,0.202,0.797;
        0.8,1.8,0.9,0.54,0.19,0.844; 0.9,1.9, 0.95,0.57,0.18,0.891; 1,2,1,0.6,0.171,0.938],
        extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "Data for validating the PI block"
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));

equation
  connect(RefDat.y[1], PI.kp) annotation (Line(points={{-36,0},{-20,0},{-20,6},
          {-12,6}}, color={0,0,127}));
  connect(PI.T, RefDat.y[2])
    annotation (Line(points={{-12,0},{-36,0}}, color={0,0,127}));
  connect(PI.L, RefDat.y[3]) annotation (Line(points={{-12,-6},{-20,-6},{-20,0},
          {-36,0}}, color={0,0,127}));
  annotation (
      experiment(
      StopTime=1.0,
      Tolerance=1e-06),
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
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PI\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PI</a>.
</p>
<p>
The reference data is imported from a raw data that is generated with a Python implementation of this block.
</p>
</html>"));
end PI;
