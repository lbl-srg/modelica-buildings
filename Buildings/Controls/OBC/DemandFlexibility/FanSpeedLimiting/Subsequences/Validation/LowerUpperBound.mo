within Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting.Subsequences.Validation;
model LowerUpperBound
  "Validation model for the block that checks whether the fan speed limit has reached the lower or upper bound"
  extends Modelica.Icons.Example;

  Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting.Subsequences.LowerUpperBound lowUppBou(
    final nAHU=2,
    final fanSpeDel_small=0.005)
    "Check whether the fan speed limit has reached the lower or upper bound"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable demFleMod(
    table=[0,1; 600,2; 2400,3; 3600,1; 4200,1],
    period=4200)
    "Demand flexibility mode"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable fanSpeLimCur(
    table=[0,1,1;
           600,1,1;
           1500,0.7,0.85;
           2100,0.7,0.7;
           2400,0.7,0.7;
           3000,1,0.85;
           3300,1,1;
           4200,1,1],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.LinearSegments)
    "Current fan speed limit for each unit"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant fanSpeLimDef[2](
    each k=1)
    "Default fan speed limit"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant fanSpeLimTarShe[2](
    each k=0.7)
    "Shed target fan speed limit"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));

equation
  connect(demFleMod.y[1], lowUppBou.demFleMod)
    annotation (Line(points={{-38,60},{0,60},{0,7.8},{38,7.8}},
                                                            color={255,127,0}));
  connect(fanSpeLimCur.y, lowUppBou.fanSpeLimCur)
    annotation (Line(points={{-38,20},{-10,20},{-10,2},{38,2}}, color={0,0,127}));
  connect(fanSpeLimDef.y, lowUppBou.fanSpeLimDef)
    annotation (Line(points={{-38,-20},{-10,-20},{-10,-2},{38,-2}}, color={0,0,127}));
  connect(fanSpeLimTarShe.y, lowUppBou.fanSpeLimTarShe)
    annotation (Line(points={{-38,-60},{0,-60},{0,-6},{38,-6}}, color={0,0,127}));

  annotation (
    experiment(StopTime=4200, Tolerance=1e-06),
    Documentation(info="<html>
<p>
This model validates the block
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting.Subsequences.LowerUpperBound\">
Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting.Subsequences.LowerUpperBound</a>
for two air handling units.
</p>
<p>
The default fan speed limit is constant at <code>1</code> and the shed target fan speed
limit is constant at <code>0.7</code>, with <code>fanSpeDel_small = 0.005</code>.
The demand flexibility mode and the current fan speed limits change as follows:
</p>
<ul>
<li>
From <code>0</code> s to <code>600</code> s, the mode is <code>1</code> (normal operation).
Both outputs are <code>false</code>.
</li>
<li>
From <code>600</code> s to <code>2400</code> s, the mode is <code>2</code> (shed).
The current fan speed limit of unit 1 decreases from <code>1</code> to <code>0.7</code>
between <code>600</code> s and <code>1500</code> s. The limit of unit 2 decreases
more slowly and reaches <code>0.7</code> at <code>2100</code> s.
The output for each unit becomes <code>true</code> once its current fan speed limit
falls below approximately <code>0.705</code>, which is the shed target plus
<code>fanSpeDel_small</code>. This occurs at about <code>1490</code> s for unit 1
and at about <code>2090</code> s for unit 2.
</li>
<li>
From <code>2400</code> s to <code>3600</code> s, the mode is <code>3</code> (rebound).
The current fan speed limit of unit 1 increases from <code>0.7</code> to <code>1</code>
between <code>2400</code> s and <code>3000</code> s. The limit of unit 2 increases
more slowly and reaches <code>1</code> at <code>3300</code> s.
The output for each unit becomes <code>true</code> once its current fan speed limit
rises above approximately <code>0.995</code>, which is the default limit minus
<code>fanSpeDel_small</code>. This occurs at about <code>2995</code> s for unit 1
and at about <code>3295</code> s for unit 2.
</li>
<li>
After <code>3600</code> s, the mode returns to <code>1</code> and both outputs
return to <code>false</code>.
</li>
</ul>
<p>
Because the comparisons use a hysteresis of <code>0.5*fanSpeDel_small</code>,
the actual switching times may differ slightly from those listed above.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 11, 2026, by Weiping Huang and Liam Cochrane:<br/>
First implementation.
</li>
</ul>
</html>"));
end LowerUpperBound;
