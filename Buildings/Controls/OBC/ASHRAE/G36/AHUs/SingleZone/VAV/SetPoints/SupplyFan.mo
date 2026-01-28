within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints;
block SupplyFan
  "Supply fan speed setpoint for single zone VAV system"

  parameter Real TSupDew_max(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Maximum supply air dew-point temperature. It's typically only needed in humid type “A” climates. A typical value is 17°C. 
    For mild and dry climates, a high set point (e.g. 24°C) should be entered for maximum efficiency"
    annotation (Dialog(group="Temperatures"));
  parameter Real maxHeaSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Maximum fan speed for heating"
    annotation (Dialog(group="Speed"));
  parameter Real maxCooSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Maximum fan speed for cooling"
    annotation (Dialog(group="Speed"));
  parameter Real minSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Minimum fan speed"
    annotation (Dialog(group="Speed"));

  parameter Real spePoiOne(
    final unit="1",
    final min=0,
    final max=1)=0.5
    "Point 1 on x-axis of control map for speed control, when it is in heating state"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Advanced", group="Speed"));
  parameter Real spePoiTwo(
    final unit="1",
    final min=0,
    final max=1)=0.25
    "Point 2 on x-axis of control map for speed control, when it is in cooling state"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Advanced", group="Speed"));
  parameter Real spePoiThr(
    final unit="1",
    final min=0,
    final max=1)=0.5
    "Point 3 on x-axis of control map for speed control, when it is in cooling state"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Advanced", group="Speed"));
  parameter Real spePoiFou(
    final unit="1",
    final min=0,
    final max=1)=0.75
    "Point 4 on x-axis of control map for speed control, when it is in cooling state"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Advanced", group="Speed"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone temperature"
    annotation (Placement(transformation(extent={{-260,210},{-220,250}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-260,170},{-220,210}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final min=0,
    final max=1,
    final unit="1")
    "Heating control signal"
    annotation (Placement(transformation(extent={{-260,20},{-220,60}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-260,-80},{-220,-40}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final min=0,
    final max=1,
    final unit="1") "Fan speed"
    annotation (Placement(transformation(extent={{220,-20},{260,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxDewPoi(
    final k=TSupDew_max)
    "Maximum supply air dew-point temperature"
    annotation (Placement(transformation(extent={{-200,260},{-180,280}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=-1)
    "Maximum supply dewpoint temperature minus threshold"
    annotation (Placement(transformation(extent={{-140,260},{-120,280}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar1(
    final p=-6)
    "Zone temperature minus threshold"
    annotation (Placement(transformation(extent={{-140,220},{-120,240}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar2(
    final p=0.5)
    "Zone temperature plus threshold"
    annotation (Placement(transformation(extent={{-160,130},{-140,150}})));
  Buildings.Controls.OBC.CDL.Reals.Min endPoiTwo
    "End point two for specifying medium fan speed"
    annotation (Placement(transformation(extent={{-100,240},{-80,260}})));
  Buildings.Controls.OBC.CDL.Reals.Min endPoiOne
    "End point one for specifying medium fan speed"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minFanSpe(
    final k=minSpe)
    "Minimum fan speed"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxCooFanSpe(
    final k=maxCooSpe)
    "Maximum fan speed for cooling"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Reals.Line medFanSpe
    "Medium fan speed"
    annotation (Placement(transformation(extent={{-20,180},{0,200}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(
    final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-140,-220},{-120,-200}})));
  Buildings.Controls.OBC.CDL.Reals.Line heaFanSpe
    "Fan speed when it is in heating state"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant speOnePoi(
    final k=spePoiOne)
    "Speed control point one in x-axis of control map"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxHeaFanSpe(
    final k=maxHeaSpe)
    "Maximum fan speed for heating"
    annotation (Placement(transformation(extent={{-180,70},{-160,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant speTwoPoi(
    final k=spePoiTwo)
    "Speed control point two in x-axis of control map"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant speThrPoi(
    final k=spePoiThr)
    "Speed control point three in x-axis of control map"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant speFouPoi(
    final k=spePoiFou)
    "Speed control point four in x-axis of control map"
    annotation (Placement(transformation(extent={{-140,-160},{-120,-140}})));
  Buildings.Controls.OBC.CDL.Reals.Line cooFanSpe1
    "Fan speed when it is in cooling state"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Line cooFanSpe2
    "Fan speed when it is in cooling mode"
    annotation (Placement(transformation(extent={{60,-190},{80,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Max spe
    "Fan speed"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch cooFan
    "Fan speed when it is in cooling state"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Less les(
    final h=spePoiFou - spePoiThr)
    "Check setpoint section"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));

equation
  connect(maxDewPoi.y, addPar.u)
    annotation (Line(points={{-178,270},{-142,270}}, color={0,0,127}));
  connect(addPar.y, endPoiTwo.u1) annotation (Line(points={{-118,270},{-110,270},
          {-110,256},{-102,256}}, color={0,0,127}));
  connect(addPar1.y, endPoiTwo.u2) annotation (Line(points={{-118,230},{-110,230},
          {-110,244},{-102,244}}, color={0,0,127}));
  connect(endPoiTwo.y, medFanSpe.x1) annotation (Line(points={{-78,250},{-60,250},
          {-60,198},{-22,198}}, color={0,0,127}));
  connect(maxCooFanSpe.y, medFanSpe.f1) annotation (Line(points={{-98,80},{-80,80},
          {-80,194},{-22,194}},   color={0,0,127}));
  connect(endPoiOne.y, medFanSpe.x2) annotation (Line(points={{-98,160},{-60,160},
          {-60,186},{-22,186}}, color={0,0,127}));
  connect(minFanSpe.y, medFanSpe.f2) annotation (Line(points={{-38,80},{-30,80},
          {-30,182},{-22,182}}, color={0,0,127}));
  connect(TOut, medFanSpe.u) annotation (Line(points={{-240,190},{-22,190}},
          color={0,0,127}));
  connect(uHea, heaFanSpe.u) annotation (Line(points={{-240,40},{78,40}},
          color={0,0,127}));
  connect(speTwoPoi.y, cooFanSpe1.x1) annotation (Line(points={{-118,-30},{20,-30},
          {20,-52},{58,-52}},     color={0,0,127}));
  connect(minFanSpe.y, cooFanSpe1.f1) annotation (Line(points={{-38,80},{-30,80},
          {-30,-56},{58,-56}},                  color={0,0,127}));
  connect(speThrPoi.y, cooFanSpe1.x2) annotation (Line(points={{-118,-90},{20,-90},
          {20,-64},{58,-64}},color={0,0,127}));
  connect(medFanSpe.y, cooFanSpe1.f2) annotation (Line(points={{2,190},{10,190},
          {10,-68},{58,-68}},                         color={0,0,127}));
  connect(uCoo, cooFanSpe1.u)
    annotation (Line(points={{-240,-60},{58,-60}}, color={0,0,127}));
  connect(speFouPoi.y, cooFanSpe2.x1) annotation (Line(points={{-118,-150},{20,-150},
          {20,-172},{58,-172}},color={0,0,127}));
  connect(medFanSpe.y, cooFanSpe2.f1) annotation (Line(points={{2,190},{10,190},
          {10,-176},{58,-176}},                       color={0,0,127}));
  connect(one.y, cooFanSpe2.x2) annotation (Line(points={{-118,-210},{-20,-210},
          {-20,-184},{58,-184}}, color={0,0,127}));
  connect(maxCooFanSpe.y, cooFanSpe2.f2) annotation (Line(points={{-98,80},{-80,
          80},{-80,-188},{58,-188}}, color={0,0,127}));
  connect(uCoo, cooFanSpe2.u) annotation (Line(points={{-240,-60},{-200,-60},{-200,
          -180},{58,-180}},  color={0,0,127}));
  connect(heaFanSpe.y, spe.u1) annotation (Line(points={{102,40},{150,40},{150,6},
          {178,6}}, color={0,0,127}));
  connect(speOnePoi.y, heaFanSpe.x1) annotation (Line(points={{-118,10},{-40,10},
          {-40,48},{78,48}}, color={0,0,127}));
  connect(minFanSpe.y, heaFanSpe.f1) annotation (Line(points={{-38,80},{-30,80},
          {-30,44},{78,44}}, color={0,0,127}));
  connect(one.y, heaFanSpe.x2) annotation (Line(points={{-118,-210},{-20,-210},{
          -20,36},{78,36}}, color={0,0,127}));
  connect(maxHeaFanSpe.y, heaFanSpe.f2) annotation (Line(points={{-158,80},{-140,
          80},{-140,32},{78,32}},   color={0,0,127}));
  connect(cooFan.y, spe.u2) annotation (Line(points={{142,-120},{150,-120},{150,
          -6},{178,-6}}, color={0,0,127}));
  connect(TZon, addPar1.u)
    annotation (Line(points={{-240,230},{-142,230}}, color={0,0,127}));
  connect(TZon, addPar2.u) annotation (Line(points={{-240,230},{-180,230},{-180,
          140},{-162,140}}, color={0,0,127}));
  connect(les.y, cooFan.u2)
    annotation (Line(points={{82,-120},{118,-120}}, color={255,0,255}));
  connect(maxDewPoi.y, endPoiOne.u1) annotation (Line(points={{-178,270},{-170,270},
          {-170,166},{-122,166}}, color={0,0,127}));
  connect(addPar2.y, endPoiOne.u2) annotation (Line(points={{-138,140},{-130,140},
          {-130,154},{-122,154}}, color={0,0,127}));
  connect(spe.y, y)
    annotation (Line(points={{202,0},{240,0}}, color={0,0,127}));
  connect(speThrPoi.y, les.u2) annotation (Line(points={{-118,-90},{20,-90},{20,
          -128},{58,-128}}, color={0,0,127}));
  connect(uCoo, les.u1) annotation (Line(points={{-240,-60},{-200,-60},{-200,-120},
          {58,-120}}, color={0,0,127}));
  connect(cooFanSpe1.y, cooFan.u1) annotation (Line(points={{82,-60},{100,-60},{
          100,-112},{118,-112}}, color={0,0,127}));
  connect(cooFanSpe2.y, cooFan.u3) annotation (Line(points={{82,-180},{100,-180},
          {100,-128},{118,-128}}, color={0,0,127}));
annotation (defaultComponentName = "supFanSpe",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
    graphics={
      Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-100,140},{100,100}},
        textString="%name",
        textColor={0,0,255}),
    Polygon(
      points={{80,-48},{58,-42},{58,-54},{80,-48}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
    Line(points={{8,-48},{78,-48}},   color={95,95,95}),
    Text(
      extent={{64,-54},{88,-65}},
      textColor={0,0,0},
          textString="u"),
    Line(points={{-4,-48},{-60,-48}}, color={95,95,95}),
    Polygon(
      points={{-64,-48},{-42,-42},{-42,-54},{-64,-48}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,-24},{-76,-34}},
          textColor={0,0,127},
          fillColor={0,0,0},
          textString="uHea"),
        Text(
          extent={{-100,-74},{-80,-84}},
          textColor={0,0,127},
          fillColor={0,0,0},
          textString="uCoo"),
        Text(
          extent={{86,6},{100,-4}},
          textColor={0,0,127},
          fillColor={0,0,0},
          textString="y"),
        Text(
          extent={{-100,36},{-80,26}},
          textColor={0,0,127},
          fillColor={0,0,0},
          textString="TOut"),
    Line(points={{-54,50},{-54,-42}}, color={95,95,95}),
    Polygon(
      points={{-54,72},{-60,50},{-48,50},{-54,72}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
    Text(
      extent={{-88,68},{-47,48}},
      textColor={0,0,0},
          textString="y"),
        Line(points={{-46,6},{-28,-18},{18,-18},{28,-2},{38,-2},{50,16}},color={
              0,0,0}),
        Line(points={{18,-18},{38,-18},{50,16},{28,16},{18,-18}}, color={0,0,0}),
        Text(
          extent={{-100,84},{-80,74}},
          textColor={0,0,127},
          fillColor={0,0,0},
          textString="TZon")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-240},{220,300}})),
  Documentation(info="<html>
<p>
Block that outputs the set points for the fan speed for a single zone VAV system.
The implementation is according to the Section 5.18.4 of ASHRAE Guideline 36, May 2020.
</p> 

<h4>Fan speed setpoint</h4>
<p>
The supply fan shall run whenever the unit is in any mode other than unoccupied mode.
Also, a ramp function should be applied to prevent changes in fan speed of more
than 10% per minute.
</p>
<h5>Minimum, medium, and maximum fan speeds shall be as follows:</h5>
<ol>
<li>
Minimum speed <code>minSpe</code>, maximum cooling speed <code>maxCooSpe</code>, and 
maximum heatng speed <code>maxHeaSpe</code> shall be given per Section 3.2.2.1 of
ASHRAE Guideline 36.
</li>
<li>
Medium fan speed shall be reset linearly based on outdoor air temperature
<code>TOut</code> from <code>minSpe</code> when outdoor air temperature is greater
than or equal to Endpoint 1 to <code>maxCooSpe</code> when <code>TOut</code> is
less than or equal to Endpoint 2.
<ul>
<li>
Endpoint 1: the lesser of zone temperature <code>TZon</code> plus 0.5 &deg;C (1 &deg;F)
and maximum supply air dew point <code>TSupDew_max</code>.
</li>
<li>
Endpoint 2: the lesser of zone temperature <code>TZon</code> minus 6 &deg;C (10 &deg;F)
and maximum supply air dew point <code>TSupDew_max</code> minus 1 &deg;C (2 &deg;F).
</li>
</ul>
</li>
</ol>

<h5>Control mapping</h5>
<ol>
<li>
For a heating-loop signal <code>uHea</code> of 100% to <code>spePoiOne</code> (default 50%), 
fan speed is reset from <code>maxHeaSpe</code> to <code>minSpe</code>.
</li>
<li>
For a heating-loop signal <code>uHea</code> of <code>spePoiOne</code> to 0%,
fan speed set point is <code>minSpe</code>.
</li>
<li>
In deadband (<code>uHea=0</code>, <code>uCoo=0</code>), fan speed set point is
<code>minSpe</code>.
</li>
<li>
For a cooling-loop signal <code>uCoo</code> of 0% to <code>spePoiTwo</code> (default 25%),
fan speed is <code>minSpe</code>.
</li>
<li>
For a cooling-loop signal <code>uCoo</code> of <code>spePoiTwo</code> to <code>spePoiThr</code>
(default 50%), fan speed is reset from <code>minSpe</code> to medium fan speed.
</li>
<li>
For a cooling-loop signal <code>uCoo</code> of <code>spePoiThr</code> to <code>spePoiFou</code> 
(default 75%), fan speed is medium.
</li>
<li>
For a cooling-loop signal of <code>uCoo</code> <code>spePoiFou</code> to 100%, fan speed
is reset from medium to <code>maxCooSpe</code>.
</li>
</ol>

<p>
The figure below shows the sequence.
</p>
<p align=\"center\">
<img alt=\"Image of speed reset\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/AHUs/SingleZone/VAV/SetPoints/Supply_Speed.png\"/>
</p>

<p>
Note that the inputs <code>uHea</code> and <code>uCoo</code> must be computed
based on the same temperature sensors and control loops.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2025, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SupplyFan;
