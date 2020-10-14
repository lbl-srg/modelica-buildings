within Buildings.Controls.OBC.FDE.DOAS.Validation;
model EconMode "This model simulates EconMode."

  parameter Real econCooAdj(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=2
   "Value subtracted from supply air temperature cooling set point.";

  Buildings.Controls.OBC.FDE.DOAS.EconMode EconMod
    annotation (Placement(transformation(extent={{44,-10},{64,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse                        SFproof(width=0.75, period=5760)
      annotation (Placement(transformation(extent={{-30,32},{-10,52}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine oaTGen(
    amplitude=5,
    freqHz=1/4800,
    offset=296,
    startTime=202)
    annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine supCooSPgen(
    amplitude=5,
    freqHz=1/3600,
    offset=297,
    startTime=960)
    annotation (Placement(transformation(extent={{-28,-50},{-8,-30}})));
equation
  connect(SFproof.y, EconMod.supFanProof) annotation (Line(points={{-8,42},{18,42},
          {18,7},{41.8,7}}, color={255,0,255}));
  connect(oaTGen.y, EconMod.oaT)
    annotation (Line(points={{-6,0},{41.8,0}}, color={0,0,127}));
  connect(supCooSPgen.y, EconMod.supCooSP) annotation (Line(points={{-6,-40},{18,
          -40},{18,-7},{41.8,-7}}, color={0,0,127}));
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
September 15, 2020, by Henry Nickels:</br>
First implementation.</li>
</ul>
</html>", info="<html>
<p>
This example simulates
<a href=\"modelica://Buildings.Controls.OBC.FDE.DOAS.EconMode\">
Buildings.Controls.OBC.FDE.DOAS.EconMode</a>.
</p>
</html>"));
end EconMode;
