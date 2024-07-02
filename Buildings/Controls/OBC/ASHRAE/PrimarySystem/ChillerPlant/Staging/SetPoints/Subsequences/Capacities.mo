within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences;
block Capacities
  "Returns design and minimal stage capacities for current and next available higher and lower stage"

  parameter Integer nSta = 3
    "Number of chiller stages, does not include zero stage";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLow
    "Current stage is the lowest available stage"
    annotation (Placement(transformation(extent={{-240,-80},{-200,-40}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHig
    "Current stage is the highest available stage"
    annotation (Placement(transformation(extent={{-240,-110},{-200,-70}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u(
    final min=0,
    final max=nSta) "Chiller stage"
    annotation (Placement(transformation(extent={{-240,100},{-200,140}}),
        iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uUp(
    final min=0,
    final max=nSta) "Next available higher stage"
    annotation (Placement(transformation(extent={{-240,40},{-200,80}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uDown(
    final min=0,
    final max=nSta) "Next available lower stage"
    annotation (Placement(transformation(extent={{-240,-40},{-200,0}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDesCap[nSta](
    final quantity=fill("HeatFlowRate", nSta),
    final unit=fill("W", nSta)) "Design stage capacities"
    annotation (Placement(transformation(extent={{-240,160},{-200,200}}),
        iconTransformation(extent={{-140,70},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMinCap[nSta](
    final quantity=fill("HeatFlowRate", nSta),
    final unit=fill("W", nSta)) "Unload stage capacities"
    annotation (Placement(transformation(extent={{-240,-200},{-200,-160}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDes(
    final unit="W",
    final quantity="HeatFlowRate") "Design capacity of the current stage"
    annotation (Placement(transformation(extent={{200,160},{240,200}}),
        iconTransformation(extent={{100,60},{140,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDowDes(
    final unit="W",
    final quantity="HeatFlowRate") "Design capacity of the next available lower stage"
    annotation (Placement(transformation(extent={{200,0},{240,40}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yUpDes(
    final unit="W",
    final quantity="HeatFlowRate") "Design capacity of the next available higher stage"
    annotation (Placement(transformation(extent={{200,40},{240,80}}),
        iconTransformation(extent={{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMin(
    final unit="W",
    final quantity="HeatFlowRate") "Minimum capacity of the current stage"
    annotation (Placement(transformation(extent={{200,-40},{240,0}}),
        iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yUpMin(
    final unit="W",
    final quantity="HeatFlowRate") "Minimum capacity of the next available higher stage"
    annotation (Placement(transformation(extent={{200,-110},{240,-70}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

protected
  final parameter Real larGai = 10
  "Large gain";

  Buildings.Controls.OBC.CDL.Routing.RealExtractor cap(
    final nin=nSta)
    "Extracts the design capacity at the current stage"
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor dowCap(
    final nin=nSta)
    "Extracts the design capacity of one stage lower than the current stage"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor upCapMin(
    final nin=nSta)
    "Extracts minimal capacity of the next higher stage"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor upCap(
    final nin=nSta)
    "Extracts the design capacity of the next stage"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor capMin(
    final nin=nSta)
    "Extracts the minimum capacity of the current stage"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi2 "Switch"
    annotation (Placement(transformation(extent={{160,50},{180,70}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi4 "Switch"
    annotation (Placement(transformation(extent={{160,-100},{180,-80}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Outputs minimum current stage capacity as design stage down capacity if operating in the lowest available stage"
    annotation (Placement(transformation(extent={{160,10},{180,30}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=larGai)
    "Ouputs a very large and unachievable staging up capacity when current is the highest available stage"
    annotation (Placement(transformation(extent={{80,110},{100,130}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[3]
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    "Ensure zero output when the index is out of range"
    annotation (Placement(transformation(extent={{30,140},{50,160}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul1
    "Ensure zero output when the index is out of range"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul2
    "Ensure zero output when the index is out of range"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul3
    "Ensure zero output when the index is out of range"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul4
    "Ensure zero output when the index is out of range"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold intGreEquThr[3](
    final t=fill(1, 3)) "Check if index is in the range"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr[3](
    final t=fill(nSta, 3)) "Check if index is in the range"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[3](
    final k=fill(1, 3))
    "Dummy index so the extractor will not have out of range index"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Logical.And and2[3]
    "Check if index is in the range"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi[3] "Valid index"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
equation
  connect(swi2.y, yUpDes) annotation (Line(points={{182,60},{220,60}}, color={0,0,127}));
  connect(swi4.y, yUpMin) annotation (Line(points={{182,-90},{220,-90}}, color={0,0,127}));
  connect(uMinCap, upCapMin.u) annotation (Line(points={{-220,-180},{-20,-180},{
          -20,-60},{-2,-60}},   color={0,0,127}));
  connect(uMinCap, capMin.u) annotation (Line(points={{-220,-180},{-20,-180},{-20,
          -140},{-2,-140}},  color={0,0,127}));
  connect(uDesCap, cap.u) annotation (Line(points={{-220,180},{-12,180}},
                       color={0,0,127}));
  connect(uDesCap, dowCap.u) annotation (Line(points={{-220,180},{-20,180},{-20,
          0},{-2,0}},                                color={0,0,127}));
  connect(uDesCap, upCap.u) annotation (Line(points={{-220,180},{-20,180},{-20,90},
          {-2,90}}, color={0,0,127}));
  connect(uLow, swi1.u2) annotation (Line(points={{-220,-60},{-50,-60},{-50,20},
          {158,20}}, color={255,0,255}));
  connect(uHig, swi2.u2) annotation (Line(points={{-220,-90},{140,-90},{140,60},
          {158,60}}, color={255,0,255}));
  connect(uHig, swi4.u2) annotation (Line(points={{-220,-90},{158,-90}},
                      color={255,0,255}));
  connect(gai.y, swi2.u1) annotation (Line(points={{102,120},{120,120},{120,68},
          {158,68}}, color={0,0,127}));
  connect(gai.y, swi4.u1) annotation (Line(points={{102,120},{120,120},{120,-82},
          {158,-82}},color={0,0,127}));
  connect(swi1.y, yDowDes) annotation (Line(points={{182,20},{220,20}}, color={0,0,127}));
  connect(cap.y, yDes) annotation (Line(points={{12,180},{220,180}},
                 color={0,0,127}));
  connect(intGreEquThr.y, and2.u1)
    annotation (Line(points={{-138,80},{-122,80}}, color={255,0,255}));
  connect(intLesEquThr.y, and2.u2) annotation (Line(points={{-138,0},{-130,0},{-130,
          72},{-122,72}}, color={255,0,255}));
  connect(and2.y, intSwi.u2) annotation (Line(points={{-98,80},{-90,80},{-90,30},
          {-82,30}}, color={255,0,255}));
  connect(conInt.y, intSwi.u3) annotation (Line(points={{-98,0},{-90,0},{-90,22},
          {-82,22}}, color={255,127,0}));
  connect(and2.y, booToRea.u)
    annotation (Line(points={{-98,80},{-82,80}}, color={255,0,255}));
  connect(cap.y, mul.u1) annotation (Line(points={{12,180},{20,180},{20,156},{28,
          156}}, color={0,0,127}));
  connect(mul.y, gai.u) annotation (Line(points={{52,150},{60,150},{60,120},{78,
          120}}, color={0,0,127}));
  connect(capMin.y, mul1.u2) annotation (Line(points={{22,-140},{40,-140},{40,-126},
          {58,-126}}, color={0,0,127}));
  connect(mul1.y, yMin) annotation (Line(points={{82,-120},{130,-120},{130,-20},
          {220,-20}}, color={0,0,127}));
  connect(mul1.y, swi1.u1) annotation (Line(points={{82,-120},{130,-120},{130,28},
          {158,28}}, color={0,0,127}));
  connect(u, intGreEquThr[1].u) annotation (Line(points={{-220,120},{-190,120},{
          -190,80},{-162,80}}, color={255,127,0}));
  connect(u, intLesEquThr[1].u) annotation (Line(points={{-220,120},{-190,120},{
          -190,0},{-162,0}}, color={255,127,0}));
  connect(u, intSwi[1].u1) annotation (Line(points={{-220,120},{-190,120},{-190,
          38},{-82,38}}, color={255,127,0}));
  connect(booToRea[1].y, mul1.u1) annotation (Line(points={{-58,80},{-30,80},{-30,
          -114},{58,-114}}, color={0,0,127}));
  connect(booToRea[1].y, mul.u2) annotation (Line(points={{-58,80},{-30,80},{-30,
          144},{28,144}}, color={0,0,127}));
  connect(intSwi[1].y, cap.index) annotation (Line(points={{-58,30},{-40,30},{-40,
          160},{0,160},{0,168}}, color={255,127,0}));
  connect(intSwi[1].y, capMin.index) annotation (Line(points={{-58,30},{-40,30},
          {-40,-160},{10,-160},{10,-152}}, color={255,127,0}));
  connect(mul2.y, swi4.u3) annotation (Line(points={{82,-40},{100,-40},{100,-98},
          {158,-98}}, color={0,0,127}));
  connect(upCapMin.y, mul2.u2) annotation (Line(points={{22,-60},{40,-60},{40,-46},
          {58,-46}}, color={0,0,127}));
  connect(booToRea[2].y, mul2.u1) annotation (Line(points={{-58,80},{-30,80},{-30,
          -34},{58,-34}}, color={0,0,127}));
  connect(intSwi[2].y, upCapMin.index) annotation (Line(points={{-58,30},{-40,30},
          {-40,-80},{10,-80},{10,-72}}, color={255,127,0}));
  connect(upCap.y, mul3.u1) annotation (Line(points={{22,90},{40,90},{40,76},{58,
          76}}, color={0,0,127}));
  connect(mul3.y, swi2.u3) annotation (Line(points={{82,70},{100,70},{100,52},{158,
          52}}, color={0,0,127}));
  connect(booToRea[2].y, mul3.u2) annotation (Line(points={{-58,80},{-10,80},{
          -10,64},{58,64}},
                        color={0,0,127}));
  connect(intSwi[2].y, upCap.index)
    annotation (Line(points={{-58,30},{10,30},{10,78}}, color={255,127,0}));
  connect(mul4.y, swi1.u3) annotation (Line(points={{82,40},{100,40},{100,12},{158,
          12}}, color={0,0,127}));
  connect(dowCap.y, mul4.u2)
    annotation (Line(points={{22,0},{40,0},{40,34},{58,34}}, color={0,0,127}));
  connect(booToRea[3].y, mul4.u1) annotation (Line(points={{-58,80},{-30,80},{-30,
          46},{58,46}}, color={0,0,127}));
  connect(intSwi[3].y, dowCap.index) annotation (Line(points={{-58,30},{-40,30},
          {-40,-20},{10,-20},{10,-12}}, color={255,127,0}));
  connect(uUp, intGreEquThr[2].u) annotation (Line(points={{-220,60},{-180,60},{
          -180,80},{-162,80}}, color={255,127,0}));
  connect(uUp, intLesEquThr[2].u) annotation (Line(points={{-220,60},{-180,60},{
          -180,0},{-162,0}}, color={255,127,0}));
  connect(uUp, intSwi[2].u1) annotation (Line(points={{-220,60},{-180,60},{-180,
          38},{-82,38}}, color={255,127,0}));
  connect(uDown, intGreEquThr[3].u) annotation (Line(points={{-220,-20},{-170,-20},
          {-170,80},{-162,80}}, color={255,127,0}));
  connect(uDown, intLesEquThr[3].u) annotation (Line(points={{-220,-20},{-170,-20},
          {-170,0},{-162,0}}, color={255,127,0}));
  connect(uDown, intSwi[3].u1) annotation (Line(points={{-220,-20},{-170,-20},{-170,
          38},{-82,38}}, color={255,127,0}));
annotation (defaultComponentName = "cap",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name")}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-200,-200},{200,200}})),
Documentation(info="<html>
<p>
This subsequence is not directly specified in Guideline36 as it provides
a side calculation pertaining to generalization of the staging 
sequences for any number of chillers and stages provided by the 
user.
</p>
<p>
Based on:
</p>
<ul>
<li>
the current chiller stage <code>u</code> index
</li>
<li>
the next available higher chiller stage <code>uUp</code> index
</li>
<li>
the next available lower chiller stage <code>uDown</code> index
</li>
<li>
boolean inputs that determine if the current stage is 
any of the following: the highest <code>uHigh</code> or the 
lowest <code>uLow</code> available chiller stage
</li>
</ul>
<p>
the subsequence selects from the design stage capacity <code>uDesCap</code>
and the minimal stage capacity <code>uMinCap</code> vectors 
the following variables and outputs them:
</p>
<ul>
<li>
the design capacities of the current <code>yDes</code>, first available higher
<code>yUpDes</code> and first available lower stage <code>yDowDes</code>
</li>
<li>
the minimal capacity of the current <code>yMin</code> and first available higher 
stage <code>yUpMin</code>
</li>
</ul>
<p>
for the purpose of calculating the operative part load ratios 
(OPLR) up and down, respectively. The OPLR is defined in 1711 March 2020 draft section 5.2.4.6.
</p>
<p>
For numerical reasons and to ensure expected behavior in corner cases such as 
when the plant operates at the highest or the lowest available stage, the
sequence implements the following:
</p>
<ul>
<li>
if operating at the lowest available chiller stage, the minimal capacity
of that stage is returned as the stage down design capacity.
</li>
<li>
if operating at the highest stage, the design and minimal stage up conditionals are set to
a value significantly larger than the design capacity of the highest stage.
This ensures numerical stability and satisfies the staging down conditionals.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
January 13, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Capacities;
