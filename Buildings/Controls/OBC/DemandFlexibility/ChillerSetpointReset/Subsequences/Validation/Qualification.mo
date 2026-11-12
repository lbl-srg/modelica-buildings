within Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences.Validation;
model Qualification
  "Validation model for the chiller qualification check"

  Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences.Qualification
    qua(
    final nChi=2,
    final uCooCoiMax={0.95,0.95},
    final fanSpeMax={0.95,0.95},
    final dTSupMax={1,1},
    final uCooCoiHys=0.01,
    final fanSpeHys=0.01,
    final dTSupHys=0.1)
    "Chiller qualification check"
    annotation (Placement(transformation(extent={{40,-20},{80,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse uCooCoi[2](
    each final amplitude=0.1,
    each final width=0.5,
    each final period=86400,
    final shift={0,43200},
    each final offset=0.9)
    "Cooling coil control signal"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse fanSpe[2](
    each final amplitude=0.1,
    each final width=0.5,
    each final period=43200,
    each final offset=0.9)
    "Fan speed"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse dTSup[2](
    each final amplitude=2,
    each final width=0.5,
    each final period=21600,
    each final offset=0)
    "Supply air temperature minus its setpoint"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));

equation
  connect(uCooCoi.y, qua.uCooCoi)
    annotation (Line(points={{-38,60},{0,60},{0,12},{36,12}},
      color={0,0,127}));
  connect(fanSpe.y, qua.fanSpe)
    annotation (Line(points={{-38,0},{36,0}}, color={0,0,127}));
  connect(dTSup.y, qua.dTSup)
    annotation (Line(points={{-38,-60},{0,-60},{0,-12},{36,-12}},
      color={0,0,127}));

annotation (experiment(StopTime=86400, Interval=1, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/ChillerSetpointReset/Subsequences/Validation/Qualification.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates the block
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences.Qualification\">
ChillerSetpointReset.Subsequences.Qualification</a>
for two chillers.
</p>
<p>
The cooling coil signals of the two chillers are high during
different halves of the day, while the fan speed and supply air
temperature deviation pulse with periods of 12 h and 6 h. As a
result, chiller 1 is at its cooling limit from 0 h to 3 h, so
<code>qua.yQua[1] = false</code>, and chiller 2 is at its
cooling limit from 12 h to 15 h, so
<code>qua.yQua[2] = false</code>. At all other times, both
outputs are <code>true</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 21, 2026, by Weiping Huang and Liam Cochrane:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
        graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}})));
end Qualification;
