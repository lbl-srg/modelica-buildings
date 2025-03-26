within Buildings.Examples.VAVReheat.BaseClasses.Controls.Examples;
model SystemHysteresis "Test model for the system hysteresis"
  extends Modelica.Icons.Example;
  Buildings.Examples.VAVReheat.BaseClasses.Controls.SystemHysteresis sysHys
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Buildings.Examples.VAVReheat.BaseClasses.Controls.SystemHysteresis sysHys1
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul(width=1/60, period=3600)
    "Pulse source"
    annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul1(width=1/10, period(
        displayUnit="min") = 60)  "Pulse source"
    annotation (Placement(transformation(extent={{-68,-40},{-48,-20}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse
                        booPul(
    final width=0.5,
    final period(displayUnit="h") = 10800,
    final shift=0)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-68,60},{-48,80}})));
equation
  connect(pul.y, sysHys.u)
    annotation (Line(points={{-46,30},{-12,30}}, color={0,0,127}));
  connect(pul1.y, sysHys1.u)
    annotation (Line(points={{-46,-30},{-12,-30}}, color={0,0,127}));
  connect(booPul.y, sysHys.sysOn) annotation (Line(points={{-46,70},{-30,70},{
          -30,36},{-12,36}}, color={255,0,255}));
  connect(booPul.y, sysHys1.sysOn) annotation (Line(points={{-46,70},{-30,70},{
          -30,-24},{-12,-24}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model tests
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.Controls.SystemHysteresis\">
Buildings.Examples.VAVReheat.BaseClasses.Controls.SystemHysteresis</a>.
</p>
<p>
In one test, there is repeated on/off, while in the other test, there is only one switch to on.
Note that <code>sys1</code> has a high frequency input, but the pump signal stays on to avoid short cycling.
</p>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVReheat/BaseClasses/Controls/Examples/SystemHysteresis.mos"
        "Simulate and plot"),
    experiment(
      StopTime=21600,
      Tolerance=1e-06));
end SystemHysteresis;
