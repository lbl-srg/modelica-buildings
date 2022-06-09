within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Validation;
model ResponseProcess "Test model for ResponseProcess"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.ResponseProcess
    responseProcess(yHig=1, yLow=0.2)
    "Calculating the length of the On period and the Off period"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable relayResponse(
     table=[0,1;0.1,0; 0.3,0; 0.7,1; 0.83,0; 0.85,1], period=2)
    "Mimicking the response for a relay controller"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.ModelTime modTim
    "Simulation time"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
equation
  connect(responseProcess.On, relayResponse.y[1]) annotation (Line(points={{-12,
          -6},{-20,-6},{-20,-10},{-38,-10}}, color={255,0,255}));
  connect(modTim.y, responseProcess.tim) annotation (Line(points={{-38,20},{-20,
          20},{-20,6},{-12,6}}, color={0,0,127}));
  annotation (
      experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/Relay/Validation/ResponseProcess.mos" "Simulate and plot"),
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
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.ResponseProcess\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.ResponseProcess</a>.
</p>
</html>"));
end ResponseProcess;
