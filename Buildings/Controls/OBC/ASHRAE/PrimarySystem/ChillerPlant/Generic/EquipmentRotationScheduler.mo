within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic;
block EquipmentRotationScheduler
  "Equipment rotation scheduler for equipment that runs continuously"

  parameter Boolean lag = true
    "true = lead/lag, false = lead/standby";

  parameter Boolean initRoles[nDev] = {true, false}
    "Initial roles: true = lead, false = lag/standby"
    annotation (Evaluate=true,Dialog(tab="Advanced", group="Initiation"));

  parameter Modelica.SIunits.Time stagingRuntime(
    final displayUnit = "h") = 864000
    "Staging runtime for each device";

  CDL.Continuous.Sources.CalendarTime                        calTim(zerTim=
        Buildings.Controls.OBC.CDL.Types.ZeroTime.NY2019, yearRef=2019)
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  CDL.Integers.Sources.Constant houOfDay(k=15)
    "Hour of the day for rotating devices that run continuously"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  CDL.Integers.Sources.Constant weeDay(k=3) "Weekday"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  CDL.Integers.Equal                        intEqu1
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  CDL.Integers.Equal                        intEqu
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  CDL.Logical.And and2
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  CDL.Integers.Equal                        intEqu2
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  CDL.Integers.Sources.Constant dayCou(k=2)
    "Number of days for scheduled rotation"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  CDL.Logical.Pre pre
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  CDL.Logical.Edge edg
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  CDL.Integers.OnCounter onCouInt
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  CDL.Integers.Equal                        intEqu3
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  CDL.Integers.Sources.Constant weeDay1(k=0) "Weekday"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  CDL.Logical.Or and1
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  CDL.Interfaces.BooleanOutput yRot "Rotation trigger signal" annotation (
      Placement(transformation(extent={{160,-20},{200,20}}), iconTransformation(
          extent={{100,-20},{140,20}})));
protected
  final parameter Integer nDev = 2
    "Total number of devices, such as chillers, isolation valves, CW pumps, or CHW pumps";

  final parameter Modelica.SIunits.Time stagingRuntimes[nDev] = fill(stagingRuntime, nDev)
    "Staging runtimes array";

equation
  connect(dayCou.y, intEqu2.u2) annotation (Line(points={{-118,-80},{32,-80},{32,
          -8},{38,-8}}, color={255,127,0}));
  connect(calTim.hour, intEqu.u1) annotation (Line(points={{-119,76},{-106,76},{
          -106,50},{-82,50}}, color={255,127,0}));
  connect(houOfDay.y, intEqu.u2) annotation (Line(points={{-118,30},{-108,30},{-108,
          42},{-82,42}}, color={255,127,0}));
  connect(calTim.weekDay, intEqu1.u1) annotation (Line(points={{-119,64},{-112,64},
          {-112,10},{-102,10}}, color={255,127,0}));
  connect(weeDay.y, intEqu1.u2) annotation (Line(points={{-118,-10},{-106,-10},{
          -106,2},{-102,2}}, color={255,127,0}));
  connect(intEqu.y, and2.u1) annotation (Line(points={{-58,50},{-50,50},{-50,0},
          {-32,0}}, color={255,0,255}));
  connect(intEqu2.y, pre.u)
    annotation (Line(points={{62,0},{78,0}}, color={255,0,255}));
  connect(pre.y, edg.u)
    annotation (Line(points={{102,0},{118,0}}, color={255,0,255}));
  connect(and2.y, onCouInt.trigger)
    annotation (Line(points={{-8,0},{-2,0}}, color={255,0,255}));
  connect(onCouInt.y, intEqu2.u1)
    annotation (Line(points={{22,0},{38,0}}, color={255,127,0}));
  connect(pre.y, onCouInt.reset) annotation (Line(points={{102,0},{110,0},{110,-28},
          {10,-28},{10,-12}}, color={255,0,255}));
  connect(calTim.weekDay, intEqu3.u1) annotation (Line(points={{-119,64},{-110,64},
          {-110,-30},{-102,-30}}, color={255,127,0}));
  connect(weeDay1.y, intEqu3.u2) annotation (Line(points={{-118,-40},{-110,-40},
          {-110,-38},{-102,-38}}, color={255,127,0}));
  connect(intEqu1.y, and1.u1) annotation (Line(points={{-78,10},{-68,10},{-68,-20},
          {-62,-20}}, color={255,0,255}));
  connect(intEqu3.y, and1.u2) annotation (Line(points={{-78,-30},{-70,-30},{-70,
          -28},{-62,-28}}, color={255,0,255}));
  connect(and1.y, and2.u2) annotation (Line(points={{-38,-20},{-36,-20},{-36,-8},
          {-32,-8}}, color={255,0,255}));
  connect(edg.y, yRot)
    annotation (Line(points={{142,0},{180,0}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-160,-100},{160,100}})),
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
end EquipmentRotationScheduler;
