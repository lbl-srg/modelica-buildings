within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Validation;
model Controller "Test model for Control"
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller relCon(
    yHig=1,
    yLow=0.5,
    deaBan=0.4) "A relay controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin sin(freqHz=2) "Measured value"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=0) "Setpoint"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(con.y, relCon.u_s)
    annotation (Line(points={{-38,0},{-12,0}}, color={0,0,127}));
  connect(sin.y, relCon.u_m)
    annotation (Line(points={{-38,-50},{0,-50},{0,-12}}, color={0,0,127}));
  annotation (
      experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/Relay/Validation/Controller.mos" "Simulate and plot"),
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
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller</a>.
</p>
</html>"));
end Controller;
