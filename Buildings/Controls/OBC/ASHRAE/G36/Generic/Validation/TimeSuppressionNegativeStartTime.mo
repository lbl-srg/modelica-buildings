within Buildings.Controls.OBC.ASHRAE.G36.Generic.Validation;
model TimeSuppressionNegativeStartTime
  "Model validates the block for suppresing changes due to the setpoint change with a negative start time
  "

  Buildings.Controls.OBC.ASHRAE.G36.Generic.TimeSuppression timSupCooReq
    "Time suppression for generating cooling request"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.TimeSuppression timSupAla(
    final chaRat=1080,
    final maxTim=7200) "Time suppression for temperature alarm"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin zonTem(
    final amplitude=2,
    final freqHz=1/7200,
    final offset=298.15)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp cooSet(
    final height=5,
    final duration=600,
    final offset=295.15,
    final startTime=900) "Cooling setpoint"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));

equation
  connect(cooSet.y, timSupCooReq.TSet) annotation (Line(points={{-38,20},{-20,20},
          {-20,84},{38,84}}, color={0,0,127}));
  connect(cooSet.y, timSupAla.TSet) annotation (Line(points={{-38,20},{-20,20},{
          -20,-76},{38,-76}}, color={0,0,127}));
  connect(zonTem.y, timSupCooReq.TZon) annotation (Line(points={{-38,-30},{0,-30},
          {0,76},{38,76}}, color={0,0,127}));
  connect(zonTem.y, timSupAla.TZon) annotation (Line(points={{-38,-30},{0,-30},{
          0,-84},{38,-84}}, color={0,0,127}));

annotation (experiment(
      StartTime=-360,
      StopTime=7200,
      Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Generic/Validation/TimeSuppressionNegativeStartTime.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Generic.TimeSuppression\">
Buildings.Controls.OBC.ASHRAE.G36.Generic.TimeSuppression</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 12, 2023, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
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
    Diagram(coordinateSystem(extent={{-100,-120},{100,120}})));
end TimeSuppressionNegativeStartTime;
