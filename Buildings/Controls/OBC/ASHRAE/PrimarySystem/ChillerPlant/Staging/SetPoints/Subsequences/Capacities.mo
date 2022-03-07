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
    annotation (Placement(transformation(extent={{-240,-140},{-200,-100}}),
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
    annotation (Placement(transformation(extent={{-240,-20},{-200,20}}),
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
    annotation (Placement(transformation(extent={{200,130},{240,170}}),
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
    final nin=nSta,
    final outOfRangeValue=0,
    final allowOutOfRange=true)
    "Extracts the design capacity at the current stage"
    annotation (Placement(transformation(extent={{-100,140},{-80,160}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor dowCap(
    final nin=nSta,
    final outOfRangeValue=0,
    final allowOutOfRange=true)
    "Extracts the design capacity of one stage lower than the current stage"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor upCapMin(
    final nin=nSta,
    final allowOutOfRange=true,
    final outOfRangeValue=0)
    "Extracts minimal capacity of the next higher stage"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor upCap(
    final nin=nSta,
    final allowOutOfRange=true,
    final outOfRangeValue=0)
    "Extracts the design capacity of the next stage"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor capMin(
    final nin=nSta,
    final outOfRangeValue=0,
    final allowOutOfRange=true)
    "Extracts the minimum capacity of the current stage"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi2 "Switch"
    annotation (Placement(transformation(extent={{160,50},{180,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi4 "Switch"
    annotation (Placement(transformation(extent={{160,-100},{180,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Outputs minimum current stage capacity as design stage down capacity if operating in the lowest available stage"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(final k=larGai)
    "Ouputs a very large and unachievable staging up capacity when current is the highest available stage"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));

equation
  connect(swi2.y, yUpDes) annotation (Line(points={{182,60},{220,60}}, color={0,0,127}));
  connect(upCap.y, swi2.u3) annotation (
    Line(points={{22,80},{80,80},{80,52},{158,52}}, color={0,0,127}));
  connect(yMin, yMin)
    annotation (Line(points={{220,-20},{220,-20}}, color={0,0,127}));
  connect(upCapMin.y, swi4.u3) annotation (Line(points={{22,-30},{40,-30},{40,-98},
          {158,-98}}, color={0,0,127}));
  connect(swi4.y, yUpMin) annotation (Line(points={{182,-90},{220,-90}}, color={0,0,127}));
  connect(capMin.y, yMin) annotation (Line(points={{22,-70},{80,-70},{80,-20},{220,
          -20}},      color={0,0,127}));
  connect(dowCap.y, swi1.u3) annotation (Line(points={{-78,80},{-40,80},{-40,12},
          {98,12}}, color={0,0,127}));
  connect(uMinCap, upCapMin.u) annotation (Line(points={{-220,-180},{-120,-180},
          {-120,-30},{-2,-30}}, color={0,0,127}));
  connect(uMinCap, capMin.u) annotation (Line(points={{-220,-180},{-120,-180},{-120,
          -70},{-2,-70}}, color={0,0,127}));
  connect(uDesCap, cap.u) annotation (Line(points={{-220,180},{-120,180},{-120,150},
          {-102,150}}, color={0,0,127}));
  connect(uDesCap, dowCap.u) annotation (Line(points={{-220,180},{-140,180},{-140,
          80},{-102,80}},                            color={0,0,127}));
  connect(uDesCap, upCap.u) annotation (Line(points={{-220,180},{-20,180},{-20,80},
          {-2,80}}, color={0,0,127}));
  connect(uLow, swi1.u2) annotation (Line(points={{-220,-60},{-140,-60},{-140,20},
          {98,20}},  color={255,0,255}));
  connect(uHig, swi2.u2) annotation (Line(points={{-220,-120},{140,-120},{140,60},
          {158,60}}, color={255,0,255}));
  connect(uHig, swi4.u2) annotation (Line(points={{-220,-120},{140,-120},{140,-90},
          {158,-90}}, color={255,0,255}));
  connect(cap.y, gai.u) annotation (Line(points={{-78,150},{-70,150},{-70,120},{
          -62,120}}, color={0,0,127}));
  connect(gai.y, swi2.u1) annotation (Line(points={{-38,120},{100,120},{100,68},
          {158,68}}, color={0,0,127}));
  connect(gai.y, swi4.u1) annotation (Line(points={{-38,120},{60,120},{60,-82},{
          158,-82}}, color={0,0,127}));
  connect(swi1.y, yDowDes) annotation (Line(points={{122,20},{220,20}}, color={0,0,127}));
  connect(u, cap.index) annotation (Line(points={{-220,120},{-90,120},{-90,138}},
           color={255,127,0}));
  connect(uDown, dowCap.index) annotation (Line(points={{-220,0},{-90,0},{-90,68}},
          color={255,127,0}));
  connect(uUp, upCap.index) annotation (Line(points={{-220,60},{10,60},{10,68}},
          color={255,127,0}));
  connect(uUp, upCapMin.index) annotation (Line(points={{-220,60},{-60,60},{-60,
          -50},{10,-50},{10,-42}}, color={255,127,0}));
  connect(cap.y, yDes) annotation (Line(points={{-78,150},{220,150}},
          color={0,0,127}));
  connect(capMin.y, swi1.u1) annotation (Line(points={{22,-70},{80,-70},{80,28},
          {98,28}},color={0,0,127}));
  connect(u, capMin.index) annotation (Line(points={{-220,120},{-160,120},{-160,
          -90},{10,-90},{10,-82}}, color={255,127,0}));
  connect(yUpMin, yUpMin)
    annotation (Line(points={{220,-90},{220,-90}}, color={0,0,127}));

annotation (defaultComponentName = "cap",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-200,-200},{200,200}})),
Documentation(info="<html>
<p>
This subsequence is not directly specified in 1711 as it provides
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
