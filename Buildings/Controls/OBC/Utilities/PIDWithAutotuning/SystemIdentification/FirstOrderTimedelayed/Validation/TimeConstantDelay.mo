within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.Validation;
model TimeConstantDelay "Test model for TimeConstantDelay"
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.TimeConstantDelay
    timConDel(yLow=0.1)
    "Calculate the time constant and the time delay of a first-order model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable RefDat(
        table=[0,1,1,0.3,0.754,0.226;
        0.098,1,1,0.3,0.754,0.226; 0.1,1,1,0.3,0.754,0.226;
        0.1,1,1,0.5,0.672,0.336; 0.298,1,1,0.5,0.672,0.336;
        0.3,1,1,0.5,0.672,0.336; 0.3,1,1,0.1,0.853,0.085;
        0.698,1,1,0.1,0.853,0.085; 0.7,1,1,0.1,0.853,
        0.085; 0.7,1,1,0.5,0.672,0.336; 0.828,1,1,0.5,0.672,
        0.336; 0.83,1,1,0.5,0.672,0.336; 0.83,1,1,0.8,0.575,0.46;
        0.848,1,1,0.8,0.575,0.46;0.85,1,1,0.8,0.575,0.46;
        0.85,2,1,0.5,1.344,0.672; 1,2,1,0.5,1.344,0.672], extrapolation=
        Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "Data for validating the timeConstantDelay block"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(RefDat.y[1], timConDel.tOn) annotation (Line(points={{-38,0},{-20,0},
          {-20,6},{-12,6}}, color={0,0,127}));
  connect(timConDel.k, RefDat.y[2])
    annotation (Line(points={{-12,0},{-38,0}}, color={0,0,127}));
  connect(timConDel.ratioLT, RefDat.y[3]) annotation (Line(points={{-12,-6},{-20,
          -6},{-20,0},{-38,0}}, color={0,0,127}));
  annotation (
      experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/SystemIdentification/FirstOrderTimedelayed/Validation/TimeConstantDelay.mos" "Simulate and plot"),
    Icon( coordinateSystem(
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
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.TimeConstantDelay\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.TimeConstantDelay</a>.
</p>
</html>"));
end TimeConstantDelay;
