within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences;
block Scheduler
  "Equipment rotation scheduler for equipment that runs continuously"

  parameter Boolean lag = true
    "true = lead/lag, false = lead/standby";

  parameter Boolean weeInt = true
    "Set to true if rotation is scheduled in weekly intervals";

  parameter Integer houOfDay = 2 "Rotation hour of the day";

  parameter Integer weeCou = 1 if weeInt "Number of weeks";

  parameter Integer weekday = 1 if weeInt
    "Rotation weekday, 1 = Monday, 7 = Sunday";

  parameter Integer dayCou = 1 if not weeInt "Number of days";

  parameter Boolean initRoles[nDev] = {true, false}
    "Initial roles: true = lead, false = lag/standby"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Initiation"));

  parameter Modelica.SIunits.Time stagingRuntime(
    final displayUnit = "h") = 864000
    "Staging runtime for each device";

  Buildings.Controls.OBC.CDL.Continuous.Sources.CalendarTime calTim(zerTim=
    Buildings.Controls.OBC.CDL.Types.ZeroTime.NY2019, yearRef=2019)
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant houOfDay1(k=houOfDay)
    "Hour of the day for rotating devices that run continuously"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant weeDay(
    final k=weekday) if weeInt "Weekday for the rotation"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant weeCou1(
    final k=weeCou) if weeInt "Number of weeks for scheduled rotation"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant dayCou1(
    final k=dayCou) if not weeInt "Number of days for scheduled rotation"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));

  Buildings.Controls.OBC.CDL.Integers.Equal isWee
    "Checks if current weekday is the rotation weekday"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2
    annotation (Placement(transformation(extent={{40,10},{60,30}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre
    annotation (Placement(transformation(extent={{80,10},{100,30}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    annotation (Placement(transformation(extent={{120,10},{140,30}})));

  Buildings.Controls.OBC.CDL.Integers.OnCounter onCouInt
    annotation (Placement(transformation(extent={{0,10},{20,30}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yRot "Rotation trigger signal"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant truSig(k=true) "True signal"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

protected
  final parameter Boolean dayInt = true if not weeInt
    "True if rotation is scheduled in daily intervals";

  final parameter Integer nDev = 2
    "Total number of devices, such as chillers, isolation valves, CW pumps, or CHW pumps";

  final parameter Modelica.SIunits.Time stagingRuntimes[nDev] = fill(stagingRuntime, nDev)
    "Staging runtimes array";

equation
  connect(dayCou1.y, intEqu2.u2) annotation (Line(points={{-118,-90},{30,-90},{30,
          12},{38,12}}, color={255,127,0}));
  connect(calTim.hour, intEqu.u1) annotation (Line(points={{-119,96},{-106,96},{
          -106,70},{-82,70}}, color={255,127,0}));
  connect(houOfDay.y, intEqu.u2) annotation (Line(points={{-118,50},{-108,50},{-108,
          62},{-82,62}}, color={255,127,0}));
  connect(calTim.weekDay, isWee.u1) annotation (Line(points={{-119,84},{-110,84},
          {-110,20},{-102,20}}, color={255,127,0}));
  connect(weeDay.y, isWee.u2) annotation (Line(points={{-118,10},{-110,10},{-110,
          12},{-102,12}}, color={255,127,0}));
  connect(intEqu.y, and2.u1) annotation (Line(points={{-58,70},{-50,70},{-50,20},
          {-32,20}},color={255,0,255}));
  connect(intEqu2.y, pre.u)
    annotation (Line(points={{62,20},{78,20}},
                                             color={255,0,255}));
  connect(pre.y, edg.u)
    annotation (Line(points={{102,20},{118,20}},
                                               color={255,0,255}));
  connect(and2.y, onCouInt.trigger)
    annotation (Line(points={{-8,20},{-2,20}},
                                             color={255,0,255}));
  connect(onCouInt.y, intEqu2.u1)
    annotation (Line(points={{22,20},{38,20}},
                                             color={255,127,0}));
  connect(pre.y, onCouInt.reset) annotation (Line(points={{102,20},{110,20},{110,
          -8},{10,-8},{10,8}},color={255,0,255}));
  connect(edg.y, yRot)
    annotation (Line(points={{142,20},{150,20},{150,0},{180,0}},
                                               color={255,0,255}));
  connect(weeCou1.y, intEqu2.u2) annotation (Line(points={{-118,-60},{30,-60},{30,
          12},{38,12}}, color={255,127,0}));
  connect(isWee.y, and2.u2) annotation (Line(points={{-78,20},{-60,20},{-60,12},
          {-32,12}}, color={255,0,255}));
  connect(truSig.y, and2.u2) annotation (Line(points={{-78,-10},{-60,-10},{-60,12},
          {-32,12}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-160,-120},{160,120}})),
      defaultComponentName="equRot",
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
This block rotates equipment, such as chillers, pumps or valves, in order 
to ensure equal wear and tear. It can be used for lead/lag and 
lead/standby operation, as specified in &quot;ASHRAE Fundamentals of Chilled Water Plant Design and Control SDL&quot;, 
Chapter 7, App B, 1.01, A.4.  The output vector <code>yDevRol<\code> indicates the lead/lag (or lead/standby) status
of the devices, while the <code>yDevSta<\code> indicates the on/off status of each device. The index of
output vectors and <code>initRoles<\code> parameter represents the physical device.
Default initial lead role is assigned to the device associated
with the first index in the input vector. The block measures the <code>stagingRuntime<\code> 
for each device and switches the lead role to the next higher index
as its <code>stagingRuntime<\code> expires. This block can be used for 2 devices. 
If using more than 2 devices, see 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotationMult\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotationMult</a>.
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
