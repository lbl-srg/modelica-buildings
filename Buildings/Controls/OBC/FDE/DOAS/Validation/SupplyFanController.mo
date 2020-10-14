within Buildings.Controls.OBC.FDE.DOAS.Validation;
model SupplyFanController
  "This model simulates SupplyFanController"
  Buildings.Controls.OBC.FDE.DOAS.SupplyFanController SFcon
      annotation (Placement(transformation(extent={{40,-6},{60,14}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    delayTime=10,
    delayOnInit=true)
    "Simulates delay between fan start command and status feedback."
      annotation (Placement(transformation(extent={{8,-34},{28,-14}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse
  OccGen(width=0.6, period=2880)
      annotation (Placement(transformation(extent={{-66,32},{-46,52}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine
  mostOpenDamGen(
    amplitude=4,
    freqHz=1/5670,
    offset=90)
      annotation (Placement(transformation(extent={{-66,-2},{-46,18}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sensorDDSP(
    amplitude=9,
    freqHz=1/6780,
    offset=180)
      annotation (Placement(transformation(extent={{-66,-38},{-46,-18}})));
equation
  connect(SFcon.supFanStart, truDel.u) annotation (Line(points={{62,9.2},{66,9.2},
          {66,-46},{0,-46},{0,-24},{6,-24}}, color={255,0,255}));
  connect(truDel.y, SFcon.supFanStatus) annotation (Line(points={{30,-24},{34,-24},
          {34,0.4},{38,0.4}}, color={255,0,255}));
  connect(OccGen.y, SFcon.occ) annotation (Line(points={{-44,42},{-10,42},{-10,11},
          {38,11}}, color={255,0,255}));
  connect(mostOpenDamGen.y, SFcon.mostOpenDam) annotation (Line(points={{-44,8},
          {-10,8},{-10,7.4},{38,7.4}}, color={0,0,127}));
  connect(sensorDDSP.y, SFcon.DDSP) annotation (Line(points={{-44,-28},{-10,-28},
          {-10,-3.2},{38,-3.2}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
September 11, 2020, by Henry Nickels:</br>
First implementation.</li>
</ul>
</html>", info="<html>
<p>
This example simulates
<a href=\"modelica://Buildings.Controls.OBC.FDE.DOAS.SupplyFanController\">
Buildings.Controls.OBC.FDE.DOAS.SupplyFanController</a>.
</p>
</html>"));
end SupplyFanController;
