within Buildings.Controls.OBC.DemandFlexibility.HVACFaultRules.Validation;
model LeakyReheatValve "Validation model for the leaky reheat valve detection"

  Buildings.Controls.OBC.DemandFlexibility.HVACFaultRules.LeakyReheatValve
    leaReaVal(
    final nZon=2,
    final dTLik=2.77778,
    final dTHys=0.5,
    final yValClo=0.05,
    final yValHys=0.01)
    "Leaky reheat valve detection"
    annotation (Placement(transformation(extent={{40,-20},{80,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TDisAir[2](
    each final amplitude=3,
    each final freqHz=1/86400,
    final phase={0,3.1415926535898},
    each final offset=273.15 + 16)
    "VAV box discharge air temperature"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSupAir(final k=273.15 + 13)
    "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse yVal[2](
    each final amplitude=0.9,
    each final offset=0.05,
    each final width=0.5,
    each final period=43200,
    final shift={0,21600})
    "Reheat valve position"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));

equation
  connect(TDisAir.y, leaReaVal.TDisAir) annotation (Line(points={{-78,40},{0,40},
          {0,10},{38,10}}, color={0,0,127}));
  connect(TSupAir.y, leaReaVal.TSupAir) annotation (Line(points={{-78,-30},{
          -20,-30},{-20,0},{38,0}}, color={0,0,127}));
  connect(yVal.y, leaReaVal.yVal) annotation (Line(points={{-78,-80},{0,-80},{
          0,-10},{38,-10}}, color={0,0,127}));

  annotation (experiment(StopTime=86400, Interval=1, Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/HVACFaultRules/Validation/LeakyReheatValve.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates the block
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.HVACFaultRules.LeakyReheatValve\">
Buildings.Controls.OBC.DemandFlexibility.HVACFaultRules.LeakyReheatValve</a>
for two zones.
</p>
<p>
The AHU supply air temperature is constant at <i>286.15 K (13 &deg;C)</i>. The
discharge air temperatures of the two zones vary sinusoidally with an amplitude
of <i>3 K</i> around <i>289.15 K (16 &deg;C)</i> in opposite phases over a
<i>24 h</i> period, thereby crossing the fault threshold of
<i>286.15 K + 2.77778 K = 288.9278 K</i>. The reheat valve positions pulse
between <i>0.05</i> (closed) and <i>0.95</i> (open) with a period of
<i>12 h</i>, and the pulse of the second zone is shifted by <i>6 h</i>.
Each zone is flagged with a leaky reheat valve
(<code>leaReaVal.yLeaVal[i] = true</code>) only when its discharge air
temperature is higher than the AHU supply air temperature by more than
<i>2.77778 K (5 &deg;F)</i>, with hysteresis <code>dTHys</code>, and its reheat
valve is closed, with hysteresis <code>yValHys</code>.
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
end LeakyReheatValve;
