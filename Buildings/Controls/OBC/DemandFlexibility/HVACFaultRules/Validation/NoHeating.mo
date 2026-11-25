within Buildings.Controls.OBC.DemandFlexibility.HVACFaultRules.Validation;
model NoHeating "Validation model for the no heating detection"

  Buildings.Controls.OBC.DemandFlexibility.HVACFaultRules.NoHeating noHea(
    final nZon=2,
    final dTApp=1,
    final dTHys=0.5,
    final yValOpe=0.9,
    final yValHys=0.01)
    "No heating detection"
    annotation (Placement(transformation(extent={{40,-20},{80,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TDisAir[2](
    each final amplitude=2,
    each final freqHz=1/86400,
    final phase={0,3.1415926535898},
    each final offset=273.15 + 14)
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
  connect(TDisAir.y, noHea.TDisAir) annotation (Line(points={{-78,40},{0,40},{
          0,10},{38,10}}, color={0,0,127}));
  connect(TSupAir.y, noHea.TSupAir) annotation (Line(points={{-78,-30},{-20,-30},
          {-20,0},{38,0}}, color={0,0,127}));
  connect(yVal.y, noHea.yVal) annotation (Line(points={{-78,-80},{0,-80},{0,-10},
          {38,-10}}, color={0,0,127}));

  annotation (experiment(StopTime=86400, Interval=1, Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/HVACFaultRules/Validation/NoHeating.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates the block
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.HVACFaultRules.NoHeating\">
Buildings.Controls.OBC.DemandFlexibility.HVACFaultRules.NoHeating</a>
for two zones.
</p>
<p>
The AHU supply air temperature is constant at <i>286.15 K (13 &deg;C)</i>. The
discharge air temperatures of the two zones vary sinusoidally with an amplitude
of <i>2 K</i> around <i>287.15 K (14 &deg;C)</i> in opposite phases over a
<i>24 h</i> period, so that the absolute difference between the discharge air
temperature and the AHU supply air temperature crosses the threshold
<code>dTApp = 1 K</code>. The reheat valve positions pulse between
<i>0.05</i> and <i>0.95</i> with a period of <i>12 h</i>, thereby crossing the
<i>90%</i> open threshold, and the pulse of the second zone is shifted by
<i>6 h</i>.
Each zone is flagged with no heating (<code>noHea.yNoHea[i] = true</code>)
only when its discharge air temperature is approximately equal to the AHU
supply air temperature, with hysteresis <code>dTHys</code>, and its reheat
valve is open at <i>90%</i> or more, with hysteresis <code>yValHys</code>.
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
end NoHeating;
