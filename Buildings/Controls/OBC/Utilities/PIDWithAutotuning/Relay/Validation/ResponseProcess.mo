within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Validation;
model ResponseProcess "Test model for processing the response of a relay controller"
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.ResponseProcess resPro(yHig=1,
      yLow=0.2) "Calculate the length of the on period and the off period"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.ModelTime modTim
    "Simulation time"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse enaSig(
    width=0.2,
    period=0.8,
    shift=-0.1) "Enable signal"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
equation
  connect(modTim.y, resPro.tim) annotation (Line(points={{-38,20},{-20,20},{-20,
          6},{-12,6}}, color={0,0,127}));
  connect(enaSig.y,resPro.on)  annotation (Line(points={{-38,-20},{-20,-20},{-20,
          -6},{-12,-6}}, color={255,0,255}));
  annotation (
      experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/Relay/Validation/ResponseProcess.mos" "Simulate and plot"),
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
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.ResponseProcess\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.ResponseProcess</a>.
</p>
<p>
This testing scenario in this example is the same to that in <a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Validation.OnOffPeriod\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Validation.OnOffPeriod</a>.
</p>
</html>"));
end ResponseProcess;
