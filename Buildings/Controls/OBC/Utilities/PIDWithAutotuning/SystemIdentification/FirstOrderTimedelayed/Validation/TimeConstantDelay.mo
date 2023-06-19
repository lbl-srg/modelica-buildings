within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.Validation;
model TimeConstantDelay "Test model for identifying the the time constant and the time delay of the control process"
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.TimeConstantDelay
    timConDel(yLow=0.1)
    "Block that calculates the time constant and the time delay of a first-order model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant k(k=1)
  "Gain"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse tOn(
    amplitude=-0.1,
    width=0.1,
    period=1,
    offset=0.1)
    "The length of the on period"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse ratioLT(
    amplitude=-0.1,
    width=0.4,
    period=0.8,
    offset=0.4)
    "Ratio between the time constant and the time delay"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

equation
  connect(tOn.y, timConDel.tOn) annotation (Line(points={{-38,40},{-20,40},{-20,
          6},{-12,6}}, color={0,0,127}));
  connect(k.y, timConDel.k)
    annotation (Line(points={{-38,0},{-12,0}}, color={0,0,127}));
  connect(ratioLT.y, timConDel.ratioLT) annotation (Line(points={{-38,-40},{-20,
          -40},{-20,-6},{-12,-6}}, color={0,0,127}));
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
<p>
Input <code>tOn</code> changes from 0 to 0.1 at 0.1s,
Input <code>k</code> is constant,
Input <code>ratioLT</code> changes twice, from 0.3 to 0.4 at 0.32s and from 0.4 to 0.3 at 0.8s.
</p>
</html>"));
end TimeConstantDelay;
