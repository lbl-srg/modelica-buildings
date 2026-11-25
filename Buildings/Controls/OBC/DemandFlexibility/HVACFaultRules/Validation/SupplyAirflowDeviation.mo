within Buildings.Controls.OBC.DemandFlexibility.HVACFaultRules.Validation;
model SupplyAirflowDeviation
  "Validation model for the supply airflow deviation detection"

  Buildings.Controls.OBC.DemandFlexibility.HVACFaultRules.SupplyAirflowDeviation
    supAirFloDev(
    final nZon=2,
    final rSetMin=0.9,
    final rSetMax=1.1,
    final V_flowMin=0.0235974,
    final V_flowHys=0.005)
    "Supply airflow deviation detection"
    annotation (Placement(transformation(extent={{40,-20},{80,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin VDis_flow[2](
    each final amplitude=0.1,
    each final freqHz=1/86400,
    final phase={0,3.1415926535898},
    each final offset=0.5)
    "Measured VAV box discharge airflow"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant VDisSet_flow[2](final k={
        0.5,0.5})
    "VAV box discharge airflow setpoint"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

equation
  connect(VDis_flow.y, supAirFloDev.VDis_flow) annotation (Line(points={{-78,40},
          {0,40},{0,10},{38,10}}, color={0,0,127}));
  connect(VDisSet_flow.y, supAirFloDev.VDisSet_flow) annotation (Line(points={{-78,-30},
          {-20,-30},{-20,0},{36,0}},               color={0,0,127}));

  annotation (experiment(StopTime=86400, Interval=1, Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/HVACFaultRules/Validation/SupplyAirflowDeviation.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates the block
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.HVACFaultRules.SupplyAirflowDeviation\">
Buildings.Controls.OBC.DemandFlexibility.HVACFaultRules.SupplyAirflowDeviation</a>
for two zones.
</p>
<p>
The supply airflow setpoints of the two zones are constant at
<i>0.5 m3/s</i>. The measured supply airflows vary sinusoidally with an
amplitude of <i>0.1 m3/s</i> around <i>0.5 m3/s</i> in opposite phases over a
<i>24 h</i> period, thereby crossing the lower limit
<i>0.9 &times; 0.5 = 0.45 m3/s</i> and the upper limit
<i>1.1 &times; 0.5 = 0.55 m3/s</i>, and reaching an absolute deviation of up
to <i>0.1 m3/s</i>, which exceeds the threshold
<i>50 cfm = 0.0235974 m3/s</i>.
Each zone is flagged
(<code>supAirFloDev.yAirFloDev[i] = true</code>) when its measured supply
airflow is outside the <i>90%</i> to <i>110%</i> band of its supply airflow
setpoint, with hysteresis <code>V_flowHys</code>, and its absolute airflow
deviation is greater than <code>V_flowMin</code>.
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
end SupplyAirflowDeviation;
