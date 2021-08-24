within Buildings.Examples.VAVReheat.Controls.Examples;
model SystemHysteresis "Test model for the system hysteresis"
  extends Modelica.Icons.Example;
  Buildings.Examples.VAVReheat.Controls.SystemHysteresis sysHys
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Buildings.Examples.VAVReheat.Controls.SystemHysteresis sysHys1
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul(width=1/60, period=3600)
    "Pulse source"
    annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul1(width=1/10, period(
        displayUnit="min") = 60)  "Pulse source"
    annotation (Placement(transformation(extent={{-68,-40},{-48,-20}})));
equation
  connect(pul.y, sysHys.u)
    annotation (Line(points={{-46,30},{-12,30}}, color={0,0,127}));
  connect(pul1.y, sysHys1.u)
    annotation (Line(points={{-46,-30},{-12,-30}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model tests
<a href=\"modelica://Buildings.Examples.VAVReheat.Controls.SystemHysteresis\">
Buildings.Examples.VAVReheat.Controls.SystemHysteresis</a>.
</p>
<p>
In one test, there is repeated on/off, while in the other test, there is only one switch to on.
Note that <code>sys1</code> has a high frequency input, but the pump signal stays on to avoid short cycling.
</p>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVReheat/Controls/Examples/SystemHysteresis.mos"
        "Simulate and plot"),
    experiment(
      StopTime=21600,
      Tolerance=1e-06));
end SystemHysteresis;
