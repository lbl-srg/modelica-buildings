within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Validation;
model Status_u_uAva "Validates chiller stage status subsequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Status sta(
    final nSta=4,
    final nChi=3,
    final staMat={{1,0,0},{1,1,0},{0,1,1},{1,1,1}})
    "Tests chiller stage status"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Status sta1(
    final nSta=4,
    final nChi=3,
    final staMat={{1,0,0},{1,1,0},{0,1,1},{1,1,1}})
    "Tests chiller stage status at the first stage"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Status sta2(
    final nSta=4,
    final nChi=3,
    final staMat={{0,1,0},{1,1,0},{0,1,1},{1,1,1}})
    "Tests chiller stage status with no higher stages available"
    annotation (Placement(transformation(extent={{120,120},{140,140}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Status sta3(
    final nSta=4,
    final nChi=3,
    final staMat={{0,1,0},{1,1,0},{0,1,1},{1,1,1}})
    "Tests chiller stage status with no lower stages available"
    annotation (Placement(transformation(extent={{120,40},{140,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Status sta4(
    final nSta=4,
    final nChi=3,
    final staMat={{1,0,0},{1,1,0},{0,1,1},{1,1,1}})
    "Tests chiller stage status at the highest stage"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Status sta6(
    final nSta=4,
    final nChi=3,
    final staMat={{1,0,0},{1,1,0},{0,1,1},{1,1,1}})
    "Tests for unavailable current stage input"
    annotation (Placement(transformation(extent={{120,-60},{140,-40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Status sta7(
    final nSta=4,
    final nChi=3,
    final staMat={{1,0,0},{1,1,0},{0,1,1},{1,1,1}})
    "Tests for unavailable current stage input, with no higher stages available"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Status sta5(
    final nSta=4,
    final nChi=3,
    final staMat={{1,0,0},{1,1,0},{0,1,1},{1,1,1}})
    "Tests chiller stage status at zero current stage"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant u(final k=3)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant u1(final k=2)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant u2(final k=3)
    "Chiller stage"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant u3(final k=1)
    "Chiller stage"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant u4(final k=4)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant u5(final k=2)
    "Chiller stage"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant u7(final k=0)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-140,-160},{-120,-140}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ava[4](
    final k={true,true,true,true}) "Stage availability array"
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ava1[4](
    final k={false,true,true,true}) "Stage availability array"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ava2[4](
    final k={true,false,true,false}) "Stage availability array"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ava3[4](
    final k={true,false,true,false})  "Stage availability array"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ava6[4](
    final k={true,true,false,false}) "Stage availability array"
    annotation (Placement(transformation(extent={{20,-120},{40,-100}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea "Type converter"
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt "Type converter"
    annotation (Placement(transformation(extent={{80,-160},{100,-140}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel(
    final samplePeriod=1,
    final y_start=3) "Unit delay"
    annotation (Placement(transformation(extent={{50,-160},{70,-140}})));

equation
  connect(ava.y, sta.uAva) annotation (Line(points={{-118,150},{-80,150},{-80,
          124},{-42,124}},
                     color={255,0,255}));
  connect(u.y, sta.u) annotation (Line(points={{-118,110},{-60,110},{-60,136},{
          -42,136}},
                color={255,127,0}));
  connect(ava1.y, sta1.uAva) annotation (Line(points={{-118,70},{-80,70},{-80,
          44},{-42,44}},
                     color={255,0,255}));
  connect(u1.y, sta1.u) annotation (Line(points={{-118,30},{-60,30},{-60,56},{
          -42,56}},
                color={255,127,0}));
  connect(ava2.y, sta2.uAva) annotation (Line(points={{42,150},{80,150},{80,124},
          {118,124}}, color={255,0,255}));
  connect(u2.y, sta2.u) annotation (Line(points={{42,110},{100,110},{100,136},{
          118,136}},
                 color={255,127,0}));
  connect(ava3.y, sta3.uAva) annotation (Line(points={{42,70},{80,70},{80,44},{
          118,44}},
                color={255,0,255}));
  connect(u3.y, sta3.u) annotation (Line(points={{42,30},{100,30},{100,56},{118,
          56}}, color={255,127,0}));
  connect(u4.y, sta4.u) annotation (Line(points={{-118,-70},{-80,-70},{-80,-44},
          {-42,-44}}, color={255,127,0}));
  connect(u5.y, sta6.u) annotation (Line(points={{42,-70},{100,-70},{100,-44},{
          118,-44}},
                 color={255,127,0}));
  connect(ava6.y, sta7.uAva) annotation (Line(points={{42,-110},{80,-110},{80,
          -126},{118,-126}},
                       color={255,0,255}));
  connect(u7.y, sta5.u) annotation (Line(points={{-118,-150},{-80,-150},{-80,
          -124},{-42,-124}},
                       color={255,127,0}));
  connect(ava.y, sta4.uAva) annotation (Line(points={{-118,150},{-100,150},{
          -100,-56},{-42,-56}},
                           color={255,0,255}));
  connect(ava.y, sta5.uAva) annotation (Line(points={{-118,150},{-100,150},{
          -100,-136},{-42,-136}},
                             color={255,0,255}));
  connect(ava3.y, sta6.uAva) annotation (Line(points={{42,70},{60,70},{60,-56},
          {118,-56}},color={255,0,255}));
  connect(intToRea.y, uniDel.u)
    annotation (Line(points={{42,-150},{48,-150}}, color={0,0,127}));
  connect(uniDel.y, reaToInt.u)
    annotation (Line(points={{72,-150},{78,-150}}, color={0,0,127}));
  connect(reaToInt.y, sta7.u) annotation (Line(points={{102,-150},{110,-150},{
          110,-114},{118,-114}},
                             color={255,127,0}));
  connect(sta7.yAvaUp, intToRea.u) annotation (Line(points={{142,-113},{148,-113},
          {148,-168},{8,-168},{8,-150},{18,-150}}, color={255,127,0}));
annotation (
 experiment(StopTime=10.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/SetPoints/Subsequences/Validation/Status_u_uAva.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Status\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Status</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 26, 2020, by Milica Grahovac:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-180},{160,180}})));
end Status_u_uAva;
