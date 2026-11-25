within Buildings.Controls.OBC.DemandFlexibility.HVACFaultRules.Validation;
model ZoneHeatingSetpointTooHigh
  "Validation model for the zone heating setpoint too high detection"

  Buildings.Controls.OBC.DemandFlexibility.HVACFaultRules.ZoneHeatingSetpointTooHigh
    heaSetHig(
    final nZon=2,
    final THeaSetLim=295.3722,
    final dTHys=0.5)
    "Zone heating setpoint too high detection"
    annotation (Placement(transformation(extent={{40,-20},{80,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin THeaSet[2](
    each final amplitude=2,
    each final freqHz=1/86400,
    final phase={0,3.1415926535898},
    each final offset=295.3722)
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uExc[2](
    each final width=0.5,
    each final period=43200,
    final shift={0,10800})
    "True: the zone is exempt from the check"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

equation
  connect(THeaSet.y, heaSetHig.THeaSet) annotation (Line(points={{-78,40},{0,40},
          {0,10},{38,10}}, color={0,0,127}));
  connect(uExc.y, heaSetHig.uExc) annotation (Line(points={{-78,-30},{-20,-30},
          {-20,-10},{38,-10}}, color={255,0,255}));

  annotation (experiment(StopTime=86400, Interval=1, Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/HVACFaultRules/Validation/ZoneHeatingSetpointTooHigh.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates the block
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.HVACFaultRules.ZoneHeatingSetpointTooHigh\">
Buildings.Controls.OBC.DemandFlexibility.HVACFaultRules.ZoneHeatingSetpointTooHigh</a>
for two zones.
</p>
<p>
The zone heating setpoints vary sinusoidally with an amplitude of <i>2 K</i>
around <i>295.3722 K (72 &deg;F)</i> in opposite phases over a <i>24 h</i>
period, thereby crossing the threshold. The exemption signals pulse with a
<i>12 h</i> period and a <i>50%</i> duty cycle, and the pulse of the second
zone is shifted by <i>3 h</i>.
Each zone is flagged
(<code>heaSetHig.yHigHeaSet[i] = true</code>) only when its heating setpoint
is higher than <i>295.3722 K (72 &deg;F)</i>, with hysteresis
<code>dTHys</code>, and it is not exempt from the check.
</p>
</html>", revisions="<html>
<ul>
<li>
November 25, 2026, by Weiping Huang:<br/>
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
      extent={{-120,-100},{100,100}})));
end ZoneHeatingSetpointTooHigh;
