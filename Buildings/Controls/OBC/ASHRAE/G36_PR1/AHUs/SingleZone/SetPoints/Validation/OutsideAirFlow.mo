within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.SetPoints.Validation;
model OutsideAirFlow
  "Validate the model of calculating minimum outdoor airflow setpoint"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.SetPoints.OutsideAirFlow
    outAirSet_SinZon(AFlo=40, have_occSen=true)
    "Block to output minimum outdoor airflow rate for system with single zone "
    annotation (Placement(transformation(extent={{20,-20},{60,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc(
    height=4,
    duration=3600)
    "Number of occupant detected in zone"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant winSta(
    k=false) "Window status"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant supFan(
    k=true) "Supply fan status"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    height=6,
    offset=273.15 + 17,
    duration=3600) "Measured zone temperature"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TDis(
    height=4,
    duration=3600,
    offset=273.15 + 18) "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));

equation
  connect(numOfOcc.y, outAirSet_SinZon.nOcc)
    annotation (Line(points={{-39,50},{0,50},{0,16},{18,16}}, color={0,0,127}));
  connect(winSta.y, outAirSet_SinZon.uWin)
    annotation (Line(points={{-39,-40},{-9.75,-40},{-9.75,-8},{18,-8}}, color={255,0,255}));
  connect(TZon.y, outAirSet_SinZon.TZon)
    annotation (Line(points={{-39,20},{-39,20},{-10,20},{-10,8},{18,8}}, color={0,0,127}));
  connect(outAirSet_SinZon.uOpeMod, opeMod.y)
    annotation (Line(points={{18,-16},{10,-16},{10,-70},{1,-70}}, color={255,127,0}));
  connect(supFan.y, outAirSet_SinZon.uSupFan)
    annotation (Line(points={{-39,-70},{-30,-70},{-30,-50},{0,-50},{0,-12},{18,-12}}, color={255,0,255}));
  connect(TDis.y, outAirSet_SinZon.TDis)
    annotation (Line(points={{-39,-10},{-20,-10},{-20,0},{18,0}}, color={0,0,127}));
annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/SetPoints/Validation/OutsideAirFlow.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.SetPoints.OutsideAirFlow\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.SetPoints.OutsideAirFlow</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 6, 2017, by Jianjun Hu:<br/>
Revised implementation.
</li>
<li>
May 12, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end OutsideAirFlow;
