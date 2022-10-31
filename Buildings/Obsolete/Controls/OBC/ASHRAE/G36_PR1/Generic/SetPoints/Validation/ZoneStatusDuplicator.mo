within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.Validation;
model ZoneStatusDuplicator
  "Validate block for duplicating zone status"

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatusDuplicator
    zonStaDup(final nZon=5, final nGro=2) "Zone status duplicator"
    annotation (Placement(transformation(extent={{0,-40},{20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant reaInp[6,5](
    final k=fill({1,2,3,4,5}, 6))
    "Real inputs"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant booInp[9,5](
    final k=fill({true,true,false,true,false},9))
    "Boolean inputs"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

equation
  connect(reaInp[1, :].y, zonStaDup.tNexOcc)
    annotation (Line(points={{-78,30},{-5,30}}, color={0,0,127}));
  connect(reaInp[2, :].y, zonStaDup.uCooTim) annotation (Line(points={{-78,30},{
          -60,30},{-60,22},{-5,22}}, color={0,0,127}));
  connect(reaInp[3, :].y, zonStaDup.uWarTim) annotation (Line(points={{-78,30},{
          -60,30},{-60,18},{-5,18}}, color={0,0,127}));
  connect(reaInp[4, :].y, zonStaDup.THeaSetOff) annotation (Line(points={{-78,30},
          {-60,30},{-60,-6},{-5,-6}}, color={0,0,127}));
  connect(reaInp[5, :].y, zonStaDup.TCooSetOff) annotation (Line(points={{-78,30},
          {-60,30},{-60,-22},{-5,-22}}, color={0,0,127}));
  connect(reaInp[6, :].y, zonStaDup.TZon) annotation (Line(points={{-78,30},{-60,
          30},{-60,-34},{-5,-34}}, color={0,0,127}));
  connect(booInp[1, :].y, zonStaDup.zonOcc) annotation (Line(points={{-78,-30},{
          -40,-30},{-40,38},{-5,38}}, color={255,0,255}));
  connect(booInp[2, :].y, zonStaDup.uOcc) annotation (Line(points={{-78,-30},{-40,
          -30},{-40,34},{-5,34}}, color={255,0,255}));
  connect(booInp[3, :].y, zonStaDup.uOccHeaHig) annotation (Line(points={{-78,-30},
          {-40,-30},{-40,10},{-5,10}}, color={255,0,255}));
  connect(booInp[4, :].y, zonStaDup.uHigOccCoo) annotation (Line(points={{-78,-30},
          {-40,-30},{-40,6},{-5,6}}, color={255,0,255}));
  connect(booInp[5, :].y, zonStaDup.uUnoHeaHig) annotation (Line(points={{-78,-30},
          {-40,-30},{-40,-2},{-5,-2}}, color={255,0,255}));
  connect(booInp[6, :].y, zonStaDup.uEndSetBac) annotation (Line(points={{-78,-30},
          {-40,-30},{-40,-10},{-5,-10}}, color={255,0,255}));
  connect(booInp[7, :].y, zonStaDup.uHigUnoCoo) annotation (Line(points={{-78,-30},
          {-40,-30},{-40,-18},{-5,-18}}, color={255,0,255}));
  connect(booInp[8, :].y, zonStaDup.uEndSetUp) annotation (Line(points={{-78,-30},
          {-40,-30},{-40,-26},{-5,-26}}, color={255,0,255}));
  connect(booInp[9, :].y, zonStaDup.uWin) annotation (Line(points={{-78,-30},{-40,
          -30},{-40,-38},{-5,-38}}, color={255,0,255}));

annotation (
  experiment(StopTime=1, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/ASHRAE/G36_PR1/Generic/SetPoints/Validation/ZoneStatusDuplicator.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatusDuplicator\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatusDuplicator</a>
for duplicating zone status.
</p>
</html>", revisions="<html>
<ul>
<li>
June 25, 2021, by Baptiste Ravache:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end ZoneStatusDuplicator;
