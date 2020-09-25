within Buildings.Controls.OBC.FDE.DOAS.Validation;
model HeatingCoil "This model simulates HeatingCoil"

  Buildings.Controls.OBC.FDE.DOAS.HeatingCoil Heating
    "This block commands the heating coil."
    annotation (Placement(transformation(extent={{42,-10},{62,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse SFproof(
    width=0.8,
    period=5760,
    startTime=300)
      annotation (Placement(transformation(extent={{-42,-10},{-22,10}})));
   Buildings.Controls.OBC.CDL.Continuous.Sources.Sine saTGen(
    amplitude=3,
    freqHz=1/4800,
    phase=0.87266462599716,
    offset=295,
    startTime=0)
    annotation (Placement(transformation(extent={{-12,-40},{8,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine supHeaGen(
    amplitude=2,
    freqHz=1/3100,
    offset=295,
    startTime=12)
    annotation (Placement(transformation(extent={{-14,14},{6,34}})));
equation
  connect(SFproof.y, Heating.supFanProof)
    annotation (Line(points={{-20,0},{39.8,0}}, color={255,0,255}));
  connect(saTGen.y, Heating.saT)
    annotation (Line(points={{10,-30},{26,-30},{26,-5},{39.8,-5}},
      color={0,0,127}));
  connect(supHeaGen.y, Heating.supHeaSP)
    annotation (Line(points={{8,24},{24,24},{24,4.8},{39.8,4.8}},
      color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This example simulates
<a href=\"modelica://Buildings.Controls.OBC.FDE.DOAS.HeatingCoil\">
Buildings.Controls.OBC.FDE.DOAS.HeatingCoil</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 25, 2020, by Henry Nickels:</br>
First implementation.</li>
</ul>
</html>"));
end HeatingCoil;
