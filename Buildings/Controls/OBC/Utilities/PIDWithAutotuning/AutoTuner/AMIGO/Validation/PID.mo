within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.Validation;
model PID "Test model for PID"
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PID PID
    "Calculate the parameters for a PI controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable RefDat(table=[0,1,0.5,
        0.3,0.95,0.446,0.127; 0.1,1.1, 0.55,0.33,0.864,0.49,0.14; 0.2,1.2,
        0.6,0.36,0.792,0.535,0.153; 0.3,1.3, 0.65,0.39,0.731,0.579,0.165;
        0.4,1.4,0.7,0.42,0.679,0.624,0.178; 0.5,1.5,0.75,0.45,0.633,0.669,0.191;
        0.6,1.6,0.8,0.48,0.594,0.713,0.203; 0.7,1.7,0.85,0.51,0.559,0.758,0.216;
        0.8,1.8,0.9,0.54,0.528,0.802,0.229; 0.9,1.9,0.95,0.57,0.5,
        0.847,0.242; 1,2,1,0.6,0.475,0.891,0.254], extrapolation=
        Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "Data for validating the PIDDerivativeTime block"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(PID.kp, RefDat.y[1]) annotation (Line(points={{-12,6},{-20,6},{-20,0},
          {-38,0}}, color={0,0,127}));
  connect(PID.T, RefDat.y[2])
    annotation (Line(points={{-12,0},{-38,0}}, color={0,0,127}));
  connect(PID.L, RefDat.y[3]) annotation (Line(points={{-12,-6},{-20,-6},{-20,0},
          {-38,0}}, color={0,0,127}));
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
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PID\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PID</a>.
</p>
<p>
The reference data is imported from a raw data that is generated with a Python implementation of this block.
</p>
</html>"));
end PID;
