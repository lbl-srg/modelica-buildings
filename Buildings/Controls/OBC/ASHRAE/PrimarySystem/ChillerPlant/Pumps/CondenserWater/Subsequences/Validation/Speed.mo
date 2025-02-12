within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.Validation;
model Speed
  "Validate sequence for generating design speed of condenser water pump at current stage"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.Speed
    conPumSpe(
    final desConWatPumSpe={0,0.5,0.75,0.6,0.75,0.9},
    final desConWatPumNum={0,1,1,2,2,2}) "Condenser water pump speed"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ramp(
    final duration=1,
    final height=2.5)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Reals.Round round(final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse wseSta(
    final period=0.75,
    final shift=0) "Waterside economizer status"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));

equation
  connect(ramp.y, round.u)
    annotation (Line(points={{-58,20},{-42,20}}, color={0,0,127}));
  connect(round.y, reaToInt.u)
    annotation (Line(points={{-18,20},{-2,20}}, color={0,0,127}));
  connect(reaToInt.y, conPumSpe.uChiSta)
    annotation (Line(points={{22,20},{40,20},{40,4},{58,4}}, color={255,127,0}));
  connect(wseSta.y, conPumSpe.uWSE)
    annotation (Line(points={{22,-20},{40,-20},{40,-4},{58,-4}}, color={255,0,255}));

annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Pumps/CondenserWater/Subsequences/Validation/Speed.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.Speed\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.Speed</a>.
</p>
<p>
The example shows a chiller plant has 3 chiller stages and 6 plant stages. The plant
stage means the stage that considers both chiller stage and waterside economizer
status. The plant stage is specified by the parameter <code>staVec</code>, which
in this exmple is <code>{0, 0.5, 1, 1.5, 2, 2.5}</code>. The element like <i>x.5</i>
means chiller stage x plus enabled waterside economizer.
At different plant stage, the number of enabled condenser water pumps and the speed
are specified by parameter <code>desConWatPumNum</code> (<code>{0, 1, 1, 2, 2, 2}</code>)
and <code>desConWatPumSpe</code> (<code>{0, 0.5, 0.75, 0.6, 0.75, 0.9}</code>).
</p>
<p>
The process of setting the condenser water pump speed and the pump number are
demonstrated as below:
</p>
<ul>
<li>
Before 0.2 seconds, the chiller stage is 0 and waterside economizer is enabled.
Thus, the plant stage is 0.5 (2nd stage), the number of enabled pumps is 1 and the
pump speed is 0.5.
</li>
<li>
In the period between 0.2 seconds and 0.375 seconds, the chiller stage is 1 and
waterside economizer is enabled. Thus, the plant stage is 1.5 (4th stage), the
number of enabled pumps is 2 and the pump speed is 0.6.
</li>
<li>
In the period between 0.375 seconds and 0.6 seconds, the chiller stage is 1 and
waterside economizer is disabled. Thus, the plant stage is 1 (3th stage), the
number of enabled pumps is 1 and the pump speed is 0.75.
</li>
<li>
In the period between 0.6 seconds and 0.75 seconds, the chiller stage is 2 and
waterside economizer is disabled. Thus, the plant stage is 2 (5th stage), the
number of enabled pumps is 2 and the pump speed is 0.75.
</li>
<li>
After 0.75 seconds, the chiller stage is 2 and waterside economizer is enabled. Thus,
the plant stage is 2.5 (6th stage), the number of enabled pumps is 2 and the pump
speed is 0.9.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
August 4, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Speed;
