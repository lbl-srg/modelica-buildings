within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.BaseClasses.Validation;
model Gain "Test model for identifying the gain of the control process"
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.BaseClasses.Gain
    gai "Block that calculate the gain of a first-order model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse u(
    amplitude=0.5,
    width=0.125,
    period=0.8,
    offset=0.5)
    "The response of a relay controller"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse tOn(
    amplitude=-0.1,
    width=0.1,
    period=1,
    offset=0.1)
    "The length of the on period"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse tOff(
    amplitude=-0.7,
    width=0.8,
    period=1,
    offset=0.7)
    "The length of the off period"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse tunSta(
    width=0.9,
    period=1,
    shift=-0.9) "Mimicking the signal for the tuning period starts"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
equation
  connect(tunSta.y, gai.triSta)
    annotation (Line(points={{-38,-80},{0,-80},{0,-12}}, color={255,0,255}));
  connect(tOff.y, gai.tOff) annotation (Line(points={{-38,-40},{-20,-40},{-20,-8},
          {-12,-8}}, color={0,0,127}));
  connect(tOn.y, gai.tOn)
    annotation (Line(points={{-38,0},{-12,0}}, color={0,0,127}));
  connect(u.y, gai.u) annotation (Line(points={{-38,40},{-20,40},{-20,8},{-12,8}},
        color={0,0,127}));
  annotation (
      experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/SystemIdentification/FirstOrderTimedelayed/BaseClasses/Validation/Gain.mos" "Simulate and plot"),
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
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.Gain\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.Gain</a>.
</p>
<p>
This testing scenario in this example is the same to that in <a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.Validation.ControlProcessModel\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.Validation.ControlProcessModel</a>.
</p>
</html>"));
end Gain;
