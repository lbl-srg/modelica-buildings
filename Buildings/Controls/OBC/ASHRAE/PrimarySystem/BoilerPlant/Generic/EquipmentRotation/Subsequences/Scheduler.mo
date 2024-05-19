within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.EquipmentRotation.Subsequences;
block Scheduler
  "Equipment rotation signal based on a scheduler for equipment that runs continuously"

  parameter Boolean simTimSta = true
    "Measure rotation time from the simulation start";

  parameter Boolean weeInt = false
    "Rotation is scheduled in: true = weekly intervals; false = daily intervals"
    annotation (Evaluate=true, Dialog(enable=not simTimSta));

  parameter Integer yearRef(
    final min=firstYear,
    final max=lastYear) = 2019
    "Year when time = 0, used if zerTim=Custom"
    annotation(Dialog(group="Calendar", enable=zerTim==Buildings.Controls.OBC.CDL.Types.ZeroTime.Custom));

  parameter Integer houOfDay = 2 "Rotation hour of the day: 0 = midnight; 23 = 11pm"
    annotation (Evaluate=true, Dialog(enable=not simTimSta));

  parameter Integer weeCou = 1 "Number of weeks"
    annotation (Evaluate=true, Dialog(enable=weeInt and not simTimSta));

  parameter Integer weekday = 1
    "Rotation weekday, 1 = Monday, 7 = Sunday"
    annotation (Evaluate=true, Dialog(enable=weeInt and not simTimSta));

  parameter Integer dayCou = 1 "Number of days"
    annotation (Evaluate=true, Dialog(enable=not weeInt and not simTimSta));

  parameter Real offset(
    final unit="s",
    final quantity="Time") = 0
    "Offset that is added to 'time', may be used for computing time in different time zone"
    annotation(Dialog(group="Calendar", enable=not simTimSta));

  parameter Real rotationPeriod(
    final unit="s",
    final quantity="Time",
    displayUnit="h") = 1209600
    "Rotation time period measured from simulation start"
    annotation(Dialog(group="Calendar", enable=simTimSta));

  parameter Real iniRotDel(
    final unit="s",
    final quantity="Time",
    displayUnit="s") = 1
    "Delay before the first rotation measured from simulation start"
    annotation(Dialog(group="Calendar", enable=simTimSta));

  parameter Buildings.Controls.OBC.CDL.Types.ZeroTime zerTim = Buildings.Controls.OBC.CDL.Types.ZeroTime.NY2019
    "Enumeration for choosing how reference time (time = 0) should be defined"
    annotation(Dialog(group="Calendar", enable=not simTimSta));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yRot
    "Rotation trigger signal"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.CalendarTime calTim(
    final zerTim=zerTim,
    final yearRef=yearRef,
    final offset=offset) if not simTimSta
    "Calendar time"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));

  Buildings.Controls.OBC.CDL.Integers.OnCounter onCouInt if not simTimSta
    "Integer counter"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger rotTri(final period=
        rotationPeriod, final shift=0) if simTimSta "Sample trigger"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));

protected
  final constant Integer firstYear = 2010
    "First year that is supported, i.e. the first year in timeStampsNewYear[:]";

  final constant Integer lastYear = firstYear + 11
    "Last year that is supported (actual building automation system need to support a larger range)";

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant houOfDay1(
    final k=houOfDay) if not simTimSta
    "Hour of the day for rotating devices that run continuously"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant weeDay(
    final k=weekday) if (weeInt and not simTimSta) "Weekday for the rotation"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant weeCou1(
    final k=weeCou) if (weeInt and not simTimSta) "Number of weeks for scheduled rotation"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant dayCou1(
    final k=dayCou) if (not weeInt and not simTimSta) "Number of days for scheduled rotation"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));

  Buildings.Controls.OBC.CDL.Integers.Equal isWee if (weeInt and not simTimSta)
    "Checks if current weekday is the rotation weekday"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu if not simTimSta
    "Checks equality"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

  Buildings.Controls.OBC.CDL.Logical.And and2 if not simTimSta
    "Logical and"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2 if not simTimSta
    "Logical equal"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre if  not simTimSta
    "Logical pre"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg if not simTimSta
    "Rising edge"
    annotation (Placement(transformation(extent={{120,10},{140,30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant truSig(
    final k=true) if (not weeInt and not simTimSta) "True signal"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=iniRotDel) if simTimSta
    "Timer"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));

  Buildings.Controls.OBC.CDL.Logical.And and1 if simTimSta
    "Logical And"
    annotation (Placement(transformation(extent={{20,-120},{40,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true) if simTimSta "True constant for the timer"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

equation
  connect(dayCou1.y, intEqu2.u2) annotation (Line(points={{-118,-60},{30,-60},{30,
          12},{38,12}}, color={255,127,0}));
  connect(calTim.hour, intEqu.u1) annotation (Line(points={{-119,116},{-100,116},
          {-100,90},{-82,90}},color={255,127,0}));
  connect(houOfDay1.y, intEqu.u2) annotation (Line(points={{-118,70},{-100,70},{
          -100,82},{-82,82}},  color={255,127,0}));
  connect(calTim.weekDay, isWee.u1) annotation (Line(points={{-119,104},{-110,104},
          {-110,40},{-102,40}}, color={255,127,0}));
  connect(weeDay.y, isWee.u2) annotation (Line(points={{-118,30},{-110,30},{-110,
          32},{-102,32}}, color={255,127,0}));
  connect(intEqu.y, and2.u1) annotation (Line(points={{-58,90},{-50,90},{-50,20},
          {-42,20}},color={255,0,255}));
  connect(intEqu2.y, pre.u)
    annotation (Line(points={{62,20},{78,20}}, color={255,0,255}));
  connect(pre.y, edg.u)
    annotation (Line(points={{102,20},{118,20}}, color={255,0,255}));
  connect(and2.y, onCouInt.trigger)
    annotation (Line(points={{-18,20},{-2,20}},color={255,0,255}));
  connect(onCouInt.y, intEqu2.u1)
    annotation (Line(points={{22,20},{38,20}}, color={255,127,0}));
  connect(pre.y, onCouInt.reset) annotation (Line(points={{102,20},{110,20},{110,
          -8},{10,-8},{10,8}},color={255,0,255}));
  connect(edg.y, yRot)
    annotation (Line(points={{142,20},{150,20},{150,0},{180,0}}, color={255,0,255}));
  connect(weeCou1.y, intEqu2.u2) annotation (Line(points={{-118,-20},{30,-20},{30,
          12},{38,12}},    color={255,127,0}));
  connect(isWee.y, and2.u2) annotation (Line(points={{-78,40},{-60,40},{-60,12},
          {-42,12}}, color={255,0,255}));
  connect(truSig.y, and2.u2) annotation (Line(points={{-78,10},{-60,10},{-60,12},
          {-42,12}}, color={255,0,255}));
  connect(rotTri.y, and1.u2) annotation (Line(points={{-118,-110},{-70,-110},{-70,
          -118},{18,-118}},  color={255,0,255}));
  connect(and1.y, yRot) annotation (Line(points={{42,-110},{150,-110},{150,0},{180,
          0}},     color={255,0,255}));
  connect(con.y, tim.u)
    annotation (Line(points={{-78,-90},{-62,-90}}, color={255,0,255}));
  connect(tim.passed, and1.u1) annotation (Line(points={{-38,-98},{0,-98},{0,
          -110},{18,-110}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-160,-140},{160,140}})),
      defaultComponentName="rotSch",
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-75,-6},{-89,8}},
          lineColor=DynamicSelect({235,235,235}, if u1 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if u1 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Ellipse(
          extent={{-52,56},{58,-54}},
          lineColor={160,160,164},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Line(
          points={{4,0},{-20,24}},
          thickness=0.5),
        Line(
          points={{4,0},{30,0}},
          thickness=0.5)}),
  Documentation(info="<html>
<p>
This block outputs generates a rotation trigger at
chosen time intervals for lead/standby configurations where a lead device runs continuously.
The implementation is based on RP 1711 5.1.2.4.2, except 5.1.2.4.2 a.
</p>
<p>
The user may chose to start counting time from simulation start to generate the
rotation signal at regular intervals <code>rotationPeriod</code> by setting a
flag <code>sinTimSta</code> to <code>true</code>, or to use a calendar.
</p>
<p>
If a calender is used the user needs to select the time of the day as an hour between 0 and 23 at which the rotation shall occur.
Hour 0 is midnight.
The block implements two options to select the time interval for the equipment rotation:
</p>
<ul>
<li>
Each <code>dayCou</code> days;
</li>
<li>
Each <code>weeCou</code> weeks on a <code>weekday</code> selected between 1 = Monday and 7 = Sunday.
</li>
</ul>
<p>
To enable weekly intervals set the <code>weeInt</code> to true, otherwise a number of days can be used.
</p>
</html>", revisions="<html>
<ul>
<li>
May 18, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Scheduler;
