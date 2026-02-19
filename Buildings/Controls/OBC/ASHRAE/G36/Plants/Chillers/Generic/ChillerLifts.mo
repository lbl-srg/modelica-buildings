within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Generic;
block ChillerLifts "Calculate the maximum and minimum enabled chiller lifts"

  parameter Integer nChi = 2 "Total number of chillers";
  parameter Real minChiLif[nChi](
    final unit=fill("K",nChi),
    final quantity=fill("TemperatureDifference",nChi))={12, 12}
      "Minimum LIFT of each chiller"
      annotation (Evaluate=true);
  parameter Real maxChiLif[nChi](
    final unit=fill("K",nChi),
    final quantity=fill("TemperatureDifference",nChi))={18, 18}
      "Maximum LIFT of each chiller"
      annotation (Evaluate=true);

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Vector of chillers proven on status: true=ON"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yLifMax(
    final unit="K")
    "Maximum LIFT among enabled chillers"
    annotation (Placement(transformation(extent={{140,30},{180,70}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yLifMin(
    final unit="K")
    "Minimum LIFT among enabled chillers"
    annotation (Placement(transformation(extent={{140,-110},{180,-70}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minLif[nChi](
    final k=minChiLif)
    "Minimum LIFT of chillers"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zeoCon[nChi](
    final k=fill(0, nChi))
    "Zero constant"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxLif[nChi](
    final k=maxChiLif)
    "Maximum LIFT of chillers"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1[nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(
    final k=1)
    "Dummy constant"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum(nin=nChi)
    "Total number of enabled chillers"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum minLifSum(nin=nChi)
    "Sum of the enabled chillers minimum lift"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum maxLifSum(nin=nChi)
    "Sum of the enabled chillers maximum lift"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr chiOn(nin=nChi)
    "Check if there is any chiller proven on"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2
    "Switch to avoid zero denominator"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Reals.Divide maxLifMea
    "Average maximum lift of the enabled chillers"
    annotation (Placement(transformation(extent={{60,82},{80,102}})));
  Buildings.Controls.OBC.CDL.Reals.Divide minLifMea
    "Average maximum lift of the enabled chillers"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi4 "Maximum lift"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3 "Minimum lift"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));

equation
  connect(uChi, swi.u2)
    annotation (Line(points={{-160,0},{-70,0},{-70,-70},{-62,-70}},
          color={255,0,255}));
  connect(zeoCon.y, swi.u3)
    annotation (Line(points={{-98,20},{-80,20},{-80,-78},{-62,-78}},
          color={0,0,127}));
  connect(minLif.y, swi.u1) annotation (Line(points={{-98,-80},{-90,-80},{-90,-62},
          {-62,-62}}, color={0,0,127}));
  connect(uChi, swi1.u2) annotation (Line(points={{-160,0},{-70,0},{-70,110},{
          -62,110}},
          color={255,0,255}));
  connect(zeoCon.y, swi1.u3) annotation (Line(points={{-98,20},{-80,20},{-80,102},
          {-62,102}},color={0,0,127}));
  connect(maxLif.y, swi1.u1) annotation (Line(points={{-98,110},{-90,110},{-90,118},
          {-62,118}}, color={0,0,127}));
  connect(uChi, booToRea.u)
    annotation (Line(points={{-160,0},{-70,0},{-70,-20},{-62,-20}},
          color={255,0,255}));
  connect(uChi,chiOn. u) annotation (Line(points={{-160,0},{-70,0},{-70,70},{
          -62,70}},  color={255,0,255}));
  connect(chiOn.y, swi2.u2)
    annotation (Line(points={{-38,70},{18,70}}, color={255,0,255}));
  connect(mulSum.y, swi2.u1)
    annotation (Line(points={{2,-20},{10,-20},{10,78},{18,78}}, color={0,0,127}));
  connect(swi2.y, maxLifMea.u2) annotation (Line(points={{42,70},{50,70},{50,86},
          {58,86}}, color={0,0,127}));
  connect(maxLifSum.y, maxLifMea.u1) annotation (Line(points={{2,110},{50,110},{
          50,98},{58,98}}, color={0,0,127}));
  connect(chiOn.y, swi4.u2) annotation (Line(points={{-38,70},{-30,70},{-30,50},
          {98,50}}, color={255,0,255}));
  connect(maxLifMea.y, swi4.u1) annotation (Line(points={{82,92},{90,92},{90,58},
          {98,58}}, color={0,0,127}));
  connect(minLifSum.y, minLifMea.u1) annotation (Line(points={{2,-70},{30,-70},{
          30,-54},{58,-54}}, color={0,0,127}));
  connect(swi2.y, minLifMea.u2) annotation (Line(points={{42,70},{50,70},{50,-66},
          {58,-66}}, color={0,0,127}));
  connect(minLifMea.y, swi3.u1) annotation (Line(points={{82,-60},{90,-60},{90,-82},
          {98,-82}}, color={0,0,127}));
  connect(chiOn.y, swi3.u2) annotation (Line(points={{-38,70},{-30,70},{-30,-90},
          {98,-90}}, color={255,0,255}));
  connect(minLif[1].y, swi3.u3) annotation (Line(points={{-98,-80},{-90,-80},{-90,
          -98},{98,-98}}, color={0,0,127}));
  connect(maxLif[1].y, swi4.u3) annotation (Line(points={{-98,110},{-90,110},{-90,
          42},{98,42}}, color={0,0,127}));
  connect(swi4.y, yLifMax)
    annotation (Line(points={{122,50},{160,50}}, color={0,0,127}));
  connect(swi3.y, yLifMin)
    annotation (Line(points={{122,-90},{160,-90}}, color={0,0,127}));
  connect(swi1.y, maxLifSum.u)
    annotation (Line(points={{-38,110},{-22,110}}, color={0,0,127}));
  connect(booToRea.y, mulSum.u)
    annotation (Line(points={{-38,-20},{-22,-20}}, color={0,0,127}));
  connect(swi.y, minLifSum.u)
    annotation (Line(points={{-38,-70},{-22,-70}}, color={0,0,127}));
  connect(one.y, swi2.u3) annotation (Line(points={{-38,20},{0,20},{0,62},{18,62}},
        color={0,0,127}));
annotation (
  defaultComponentName="chiLif",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-140,-140},{140,140}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),
Documentation(info="<html>
<p>
Block that outputs the maximum and minimum lifts of the enabled chillers. It is
based on ASHRAE Guideline 36-2021, section 5.20.4.14.
</p>
<p>
<code>yLifMin</code> and <code>yLifMax</code> shall be calculated as the averages of
<code>minChiLif</code> and <code>maxChiLif</code> for operating chillers, respectively.
</p>
</html>", revisions="<html>
<ul>
<li>
August 2, 2025, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillerLifts;
