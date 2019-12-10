within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences;
block Scheduler
  "Equipment rotation signal based on a scheduler for equipment that runs continuously"

  parameter Buildings.Controls.OBC.CDL.Types.ZeroTime zerTim = Buildings.Controls.OBC.CDL.Types.ZeroTime.NY2019
    "Enumeration for choosing how reference time (time = 0) should be defined"
    annotation(Dialog(group="Calendar"));

  parameter Integer yearRef(min=firstYear, max=lastYear) = 2019
    "Year when time = 0, used if zerTim=Custom"
    annotation(Dialog(group="Calendar", enable=zerTim==Buildings.Controls.OBC.CDL.Types.ZeroTime.Custom));

  parameter Modelica.SIunits.Time offset = 0
    "Offset that is added to 'time', may be used for computing time in different time zone"
    annotation(Dialog(group="Calendar"));

  parameter Boolean weeInt = true
    "Rotation is scheduled in: true = weekly intervals; false = daily intervals";

  parameter Integer houOfDay = 2 "Rotation hour of the day: 0 = midnight; 23 = 11pm";

  parameter Integer weeCou = 1 "Number of weeks"
    annotation (Evaluate=true, Dialog(enable=weeInt));

  parameter Integer weekday = 1
    "Rotation weekday, 1 = Monday, 7 = Sunday"
    annotation (Evaluate=true, Dialog(enable=weeInt));

  parameter Integer dayCou = 1 "Number of days"
    annotation (Evaluate=true, Dialog(enable=not weeInt));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yRot
    "Rotation trigger signal"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.CalendarTime calTim(
    final zerTim=zerTim,
    final yearRef=yearRef,
    final offset=offset)
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));

  Buildings.Controls.OBC.CDL.Integers.OnCounter onCouInt "Integer counter"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant houOfDay1(
    final k=houOfDay)
    "Hour of the day for rotating devices that run continuously"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant weeDay(
    final k=weekday) if weeInt "Weekday for the rotation"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant weeCou1(
    final k=weeCou) if weeInt "Number of weeks for scheduled rotation"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant dayCou1(
    final k=dayCou) if not weeInt "Number of days for scheduled rotation"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));

  Buildings.Controls.OBC.CDL.Integers.Equal isWee if weeInt
    "Checks if current weekday is the rotation weekday"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu "Checks equality"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2 "Logical equal"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre "Logical pre"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg "Rising edge"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant truSig(
    final k=true) if  not weeInt "True signal"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

protected
  final constant Integer firstYear = 2010
    "First year that is supported, i.e. the first year in timeStampsNewYear[:]";

  final constant Integer lastYear = firstYear + 11
    "Last year that is supported (actual building automation system need to support a larger range)";

equation
  connect(dayCou1.y, intEqu2.u2) annotation (Line(points={{-118,-90},{30,-90},{30,
          -8},{38,-8}}, color={255,127,0}));
  connect(calTim.hour, intEqu.u1) annotation (Line(points={{-119,96},{-100,96},
          {-100,70},{-82,70}},color={255,127,0}));
  connect(houOfDay1.y, intEqu.u2) annotation (Line(points={{-118,50},{-100,50},
          {-100,62},{-82,62}}, color={255,127,0}));
  connect(calTim.weekDay, isWee.u1) annotation (Line(points={{-119,84},{-110,84},
          {-110,20},{-102,20}}, color={255,127,0}));
  connect(weeDay.y, isWee.u2) annotation (Line(points={{-118,10},{-110,10},{-110,
          12},{-102,12}}, color={255,127,0}));
  connect(intEqu.y, and2.u1) annotation (Line(points={{-58,70},{-50,70},{-50,0},
          {-42,0}}, color={255,0,255}));
  connect(intEqu2.y, pre.u)
    annotation (Line(points={{62,0},{78,0}},   color={255,0,255}));
  connect(pre.y, edg.u)
    annotation (Line(points={{102,0},{118,0}},   color={255,0,255}));
  connect(and2.y, onCouInt.trigger)
    annotation (Line(points={{-18,0},{-2,0}},  color={255,0,255}));
  connect(onCouInt.y, intEqu2.u1)
    annotation (Line(points={{22,0},{38,0}},   color={255,127,0}));
  connect(pre.y, onCouInt.reset) annotation (Line(points={{102,0},{110,0},{110,-28},
          {10,-28},{10,-12}}, color={255,0,255}));
  connect(edg.y, yRot)
    annotation (Line(points={{142,0},{180,0}},                   color={255,0,255}));
  connect(weeCou1.y, intEqu2.u2) annotation (Line(points={{-118,-50},{30,-50},{30,
          -8},{38,-8}},    color={255,127,0}));
  connect(isWee.y, and2.u2) annotation (Line(points={{-78,20},{-60,20},{-60,-8},
          {-42,-8}}, color={255,0,255}));
  connect(truSig.y, and2.u2) annotation (Line(points={{-78,-10},{-60,-10},{-60,-8},
          {-42,-8}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-160,-120},{160,120}})),
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
          lineColor={0,0,255},
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
The implementation is based on RP 1711 5.1.2.4.2, except 5.1.2.4.2 a).

The user needs to select the time of the day as an hour between 0 and 23 at which the rotation shall occur.
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
September 18, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Scheduler;
