within Buildings.Controls.OBC.Utilities.BaseClasses.Validation;
model Relay
  "Test model for Relay"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.Utilities.BaseClasses.Relay relay(yLow=-0.5, deaBan=0.4)
    "A relay controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  CDL.Continuous.Sources.Sine sin(freqHz=2) "Measured value"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  CDL.Continuous.Sources.Constant const(k=0) "Setpoint"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(const.y, relay.u_s)
    annotation (Line(points={{-38,0},{-12,0}}, color={0,0,127}));
  connect(sin.y, relay.u_m)
    annotation (Line(points={{-38,-50},{0,-50},{0,-12}}, color={0,0,127}));
  annotation (
      experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/BaseClasses/Validation/Relay.mos" "Simulate and plot"),
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
<a href=\"modelica://Buildings.Controls.OBC.Utilities.BaseClasses.Relay\">
Buildings.Controls.OBC.Utilities.BaseClasses.Relay</a>.
</p>
</html>"));
end Relay;
