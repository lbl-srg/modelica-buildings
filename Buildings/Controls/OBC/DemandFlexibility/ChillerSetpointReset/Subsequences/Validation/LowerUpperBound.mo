within Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences.Validation;
model LowerUpperBound
  "Validation model for the chilled water temperature setpoint bound check"

  Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences.LowerUpperBound
    lowUppBou(
    final nChi=2,
    final dT_small=0.1)
    "Check whether the setpoint has reached its bound"
    annotation (Placement(transformation(extent={{40,-20},{80,20}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable demFleMod(
    final table=[0,1; 600,2; 2400,3; 3600,1],
    final period=4200)
    "Demand flexibility mode: default, load-shed, load-rebound, default"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable TChiSetCur(
    final table=[0,279.82,279.82;
                 600,279.82,279.82;
                 1500,281.48,280.82;
                 2100,281.48,281.48;
                 2400,281.48,281.48;
                 3000,279.82,280.37;
                 3300,279.82,279.82;
                 4200,279.82,279.82],
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.LinearSegments,
    final extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "Current chilled water temperature setpoint of the two chillers"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiSetDef[2](
    each final k=279.82)
    "Default chilled water temperature setpoint (44 degF)"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiSetTarShe[2](
    each final k=281.48)
    "Target chilled water temperature setpoint for the load-shed mode (47 degF)"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));

equation
  connect(demFleMod.y[1], lowUppBou.demFleMod)
    annotation (Line(points={{-58,60},{20,60},{20,15.6},{36,15.6}},
      color={255,127,0}));
  connect(TChiSetCur.y, lowUppBou.TChiSetCur)
    annotation (Line(points={{-58,20},{10,20},{10,4},{36,4}},
      color={0,0,127}));
  connect(TChiSetDef.y, lowUppBou.TChiSetDef)
    annotation (Line(points={{-58,-20},{10,-20},{10,-4},{36,-4}},
      color={0,0,127}));
  connect(TChiSetTarShe.y, lowUppBou.TChiSetTarShe)
    annotation (Line(points={{-58,-60},{20,-60},{20,-12},{36,-12}},
      color={0,0,127}));

annotation (experiment(StopTime=4200, Interval=1, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/ChillerSetpointReset/Subsequences/Validation/LowerUpperBound.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates the block
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences.LowerUpperBound\">
ChillerSetpointReset.Subsequences.LowerUpperBound</a>
for two chillers.
</p>
<p>
The demand flexibility mode is default from 0 s to 600 s,
load-shed from 600 s to 2400 s, load-rebound from 2400 s to
3600 s, and default afterwards. During load-shed, the setpoint
of each chiller ramps up to the load-shed target, and during
load-rebound it ramps back down to the default setpoint.
Chiller 2 ramps more slowly than chiller 1, so the two outputs
switch at different times.
</p>
<p>
In load-shed mode, <code>lowUppBou.reach_lowUppBou[1]</code>
becomes <code>true</code> shortly before 1500 s and
<code>lowUppBou.reach_lowUppBou[2]</code> shortly before 2100 s.
Both become <code>false</code> when the mode changes to
load-rebound at 2400 s. In load-rebound mode, output 1 becomes
<code>true</code> shortly before 3000 s and output 2 shortly
before 3300 s. In default mode, both outputs are
<code>false</code>, even though the setpoint equals the default
setpoint.
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
end LowerUpperBound;
