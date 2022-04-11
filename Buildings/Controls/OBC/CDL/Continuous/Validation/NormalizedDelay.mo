within Buildings.Controls.OBC.CDL.Continuous.Validation;
model NormalizedDelay "Validation model for the NormalizedDelay block"

  Modelica.Blocks.Sources.Sine sine(
    amplitude=1.2,
    f=1/60,
    offset=0.3,
    startTime=0.025)                                      "Sine source"
    annotation (Placement(transformation(extent={{-82,28},{-62,48}})));
  Modelica.Blocks.Sources.Constant const(k=0) annotation (Placement(transformation(extent={{-82,-42},{-62,-22}})));
  Buildings.Controls.OBC.CDL.Continuous.NormalizedDelay NormalizedDelay(gamma=3) annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Discrete.Relay                            relay(
    yHigher=4,
    yLower=-0.5,
    deadBand=0.5)
                annotation (Placement(transformation(extent={{-40,-8},{-20,12}})));
equation
  connect(sine.y, relay.u1) annotation (Line(points={{-61,38},{-54,38},{-54,6},{-41,6}},   color={0,0,127}));
  connect(relay.u2, const.y) annotation (Line(points={{-41,-2.4},{-54,-2.4},{-54,-32},{-61,-32}},
                                                                                              color={0,0,127}));
  connect(relay.dtON, NormalizedDelay.dtON) annotation (Line(points={{-19,4},{-12,4},{-12,6},{18,6}}, color={0,0,127}));
  connect(relay.dtOFF, NormalizedDelay.dtOFF) annotation (Line(points={{-19,-4},{-12,-4},{-12,-6},{18,-6}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=120,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/NormalizedDelay.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.NormalizedDelay\">
Buildings.Controls.OBC.CDL.Continuous.NormalizedDelay</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>March 30, 2022, by Sen Huang:<br>First implementation. </li>
</ul>
</html>"),
    Icon(
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
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end NormalizedDelay;
