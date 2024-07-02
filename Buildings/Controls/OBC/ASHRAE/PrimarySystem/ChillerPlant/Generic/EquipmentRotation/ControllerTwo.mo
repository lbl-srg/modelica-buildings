within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation;
block ControllerTwo
  "Lead/lag or lead/standby equipment rotation controller for two devices or two groups of devices"

  parameter Boolean lag = true
    "true = lead/lag; false = lead/standby";

  parameter Boolean continuous = false
    "Continuous lead device operation"
    annotation (Evaluate=true, Dialog(enable=not lag));

  parameter Boolean minLim = false
    "Utilize minimum runtime period for a current lead device before rotation may occur"
    annotation (Evaluate=true, Dialog(enable=not continuous));

  parameter Boolean initRoles[nDev] = {true, false}
    "Initial roles: true = lead, false = lag/standby"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Initiation"));

  parameter Boolean simTimSta = true
    "Measure rotation time from the simulation start"
    annotation(Evaluate=true, Dialog(group="Scheduler", enable=continuous));

  parameter Boolean weeInt = true
    "Rotation is scheduled in: true = weekly intervals; false = daily intervals"
    annotation(Evaluate=true, Dialog(group="Scheduler", enable=not simTimSta));

  parameter Real rotationPeriod(
    final unit="s",
    final quantity="Time",
    displayUnit="h") = 1209600
    "Rotation time period measured from simulation start"
    annotation(Dialog(group="Scheduler", enable=simTimSta));

  parameter Real minLeaRuntime(
    final unit="s",
    final quantity="Time",
    displayUnit="h") = 43200
    "Minimum cumulative runtime period for a current lead device before rotation may occur"
    annotation (Evaluate=true, Dialog(enable=(not continuous and minLim)));

  parameter Real offset(
    final unit="s",
    final quantity="Time") = 0
    "Offset that is added to 'time', may be used for computing time in a different time zone"
    annotation(Evaluate=true, Dialog(group="Calendar", enable=(continuous and not simTimSta)));

  parameter Buildings.Controls.OBC.CDL.Types.ZeroTime zerTim = Buildings.Controls.OBC.CDL.Types.ZeroTime.NY2019
    "Enumeration for choosing how reference time (time = 0) should be defined"
    annotation(Evaluate=true, Dialog(group="Calendar", enable=(continuous and not simTimSta)));

  parameter Integer yearRef(min=firstYear, max=lastYear) = 2019
    "Year when time = 0, used if zerTim=Custom"
    annotation(Evaluate=true, Dialog(group="Calendar", enable=zerTim==Buildings.Controls.OBC.CDL.Types.ZeroTime.Custom and continuous));

  parameter Integer houOfDay = 2
    "Rotation hour of the day: 0 = midnight; 23 = 11pm"
    annotation(Evaluate=true, Dialog(group="Scheduler", enable=not simTimSta));

  parameter Integer weeCou = 1 "Number of weeks"
    annotation (Evaluate=true, Dialog(enable=weeInt and not simTimSta, group="Scheduler"));

  parameter Integer weekday = 1
    "Rotation weekday, 1 = Monday, 7 = Sunday"
    annotation (Evaluate=true, Dialog(enable=weeInt and not simTimSta, group="Scheduler"));

  parameter Integer dayCou = 1 "Number of days"
    annotation (Evaluate=true, Dialog(enable=not weeInt and not simTimSta, group="Scheduler"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaStaSet if not continuous
    "Lead device status setpoint"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLagStaSet if lag
    "Lag device status setpoint"
     annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
                          iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDevSta[nDev]
    "Device proven ON status, where each index represents a physical device/group of devices"
    annotation (Placement(transformation(extent={{-200,60},{-160,100}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDevStaSet[nDev]
    "Device status setpoint, where each index represents a physical device/group of devices"
    annotation (Placement(transformation(extent={{160,10},{180,30}}), iconTransformation(
          extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDevRol[nDev]
    "Device role: true = lead, false = lag or standby" annotation (Placement(
        transformation(extent={{160,-30},{180,-10}}), iconTransformation(extent={{100,-80},
            {140,-40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Scheduler
    rotSch(
    final rotationPeriod=rotationPeriod,
    final simTimSta=simTimSta,
    final weeInt=weeInt,
    final houOfDay=houOfDay,
    final weeCou=weeCou,
    final weekday=weekday,
    final dayCou=dayCou,
    final zerTim=zerTim,
    final yearRef=yearRef,
    final offset=offset) if continuous
    "Generates equipment rotation trigger based on a schedule"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.MinimumLeadRuntime
    minLeaTim(final minLeaRuntime=minLeaRuntime) if (minLim and not continuous)
    "Rotation signal generator with a minimum leading device runtime limiter"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

protected
  final parameter Integer nDev = 2
    "Total number of devices, such as chillers, isolation valves, CW pumps, or CHW pumps";

  final constant Integer firstYear = 2010
    "First year that is supported, i.e. the first year in timeStampsNewYear[:]"
    annotation (Evaluate=true, Dialog(enable=not continuous));

  final constant Integer lastYear = firstYear + 20
    "Last year that is currently supported"
    annotation (Evaluate=true, Dialog(enable=not continuous));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.LeastRuntime
    leaRunTim(final lag=lag) if (not minLim and not continuous)
    "Rotation signal generator based on least runtime, at device enable"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.ContinuousLeadSwapTwo
    leaSwa if continuous
    "Ensures no old lead device is switched off until the new lead device is proven on"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Two
    rotTwoCon if continuous
    "Based on a rotation trigger sets device roles according to equipment rotation"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Two
    rotTwo if not continuous
    "Based on a rotation trigger sets device roles according to equipment rotation"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repLea(
    final nout=nDev) if not continuous "Replicates lead signal"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repLag(
    final nout=nDev) if lag "Replicates lag signal"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1[nDev] if not continuous
    "Switch"
    annotation (Placement(transformation(extent={{-60,-42},{-40,-22}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staBySta[nDev](
    final k=fill(false, nDev)) if not lag and not continuous "Standby status"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));

equation
  connect(logSwi1.u1, repLea.y) annotation (Line(points={{-62,-24},{-80,-24},{-80,
          -10},{-98,-10}},     color={255,0,255}));
  connect(logSwi1.u3,repLag. y) annotation (Line(points={{-62,-40},{-98,-40}},
                                 color={255,0,255}));
  connect(uLeaStaSet, repLea.u)
    annotation (Line(points={{-180,0},{-140,0},{-140,-10},{-122,-10}},
                                                   color={255,0,255}));
  connect(uLagStaSet, repLag.u)
    annotation (Line(points={{-180,-80},{-140,-80},{-140,-40},{-122,-40}},
                                                     color={255,0,255}));
  connect(logSwi1.y, yDevStaSet) annotation (Line(points={{-38,-32},{-30,-32},{-30,
          60},{140,60},{140,20},{170,20}},       color={255,0,255}));
  connect(staBySta.y,logSwi1. u3) annotation (Line(points={{-98,-80},{-90,-80},{
          -90,-40},{-62,-40}},    color={255,0,255}));
  connect(leaSwa.yDevStaSet, yDevStaSet) annotation (Line(points={{122,30},{140,
          30},{140,20},{170,20}},
                              color={255,0,255}));
  connect(minLeaTim.yRot, rotTwo.uRot)
    annotation (Line(points={{62,-30},{98,-30}}, color={255,0,255}));
  connect(rotTwo.yDevRol, yDevRol) annotation (Line(points={{122,-30},{140,-30},
          {140,-20},{170,-20}},color={255,0,255}));
  connect(rotTwo.yPreDevRolSig, minLeaTim.uPreDevRolSig) annotation (Line(
        points={{122,-36},{140,-36},{140,-60},{20,-60},{20,-38},{38,-38}},
        color={255,0,255}));
  connect(rotTwo.yPreDevRolSig, logSwi1.u2) annotation (Line(points={{122,-36},{
          140,-36},{140,-60},{-80,-60},{-80,-32},{-62,-32}}, color={255,0,255}));
  connect(rotSch.yRot, rotTwoCon.uRot)
    annotation (Line(points={{22,30},{38,30}},   color={255,0,255}));
  connect(uDevSta, leaSwa.uDevSta) annotation (Line(points={{-180,80},{90,80},{90,
          26},{98,26}}, color={255,0,255}));
  connect(rotTwoCon.yDevRol, leaSwa.uDevRolSet) annotation (Line(points={{62,30},
          {80,30},{80,34},{98,34}},
                                  color={255,0,255}));
  connect(rotTwoCon.yDevRol, yDevRol) annotation (Line(points={{62,30},{80,30},{
          80,0},{140,0},{140,-20},{170,-20}},    color={255,0,255}));
  connect(uDevSta, minLeaTim.uDevSta) annotation (Line(points={{-180,80},{-20,80},
          {-20,-30},{38,-30}}, color={255,0,255}));
  connect(rotTwo.yPreDevRolSig, leaRunTim.uPreDevRolSig) annotation (Line(
        points={{122,-36},{140,-36},{140,-94},{30,-94},{30,-88},{38,-88}},
        color={255,0,255}));
  connect(uDevSta, leaRunTim.uDevSta) annotation (Line(points={{-180,80},{-20,80},
          {-20,-80},{38,-80}}, color={255,0,255}));
  connect(leaRunTim.yRot, rotTwo.uRot) annotation (Line(points={{62,-80},{80,-80},
          {80,-30},{98,-30}}, color={255,0,255}));

annotation(Diagram(coordinateSystem(extent={{-160,-100},{160,100}})),
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
          textColor={0,0,255},
          textString="%name"),
        Ellipse(
          origin={-26.6667,38.6207},
          lineColor={128,128,128},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-53.3333,1.37927},{-13.3329,41.3792}}),
        Ellipse(
          origin={93.3333,-81.3793},
          lineColor={128,128,128},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-53.3333,1.37927},{-13.3329,41.3792}}),
        Ellipse(
          origin={-26.6667,-81.3793},
          lineColor={128,128,128},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          extent={{-53.3333,1.37927},{-13.3329,41.3792}}),
        Ellipse(
          origin={93.333,38.6207},
          lineColor={128,128,128},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          extent={{-53.3333,1.37927},{-13.3329,41.3792}}),
        Line(points={{-40,60},{0,60},{0,-60},{40,-60}}, color={128,128,128}),
        Line(points={{-40,-60},{0,-60},{0,60},{40,60}}, color={128,128,128})}),
  Documentation(info="<html>
<p>
This controller block rotates equipment, such as chillers, pumps or valves, in order
to ensure equal wear and tear. It is intended to be used for lead/lag and
lead/standby operation of two devices or groups of devices. The implementation is
based on the specification from ASHRAE Guideline36-2021, section 5.1.15.1.-4.
</p>
<p>
The controller takes as inputs the current device proven ON/OFF status vector <code>uDevSta</code>,
lead device status setpoint <code>uLeaStaSet</code> and lag device status setpoint <code>uLagStaSet</code>.
The controller features the following rotation subsequences to generate the device status setpoints <code>yDevStaSet</code>
and device roles <code>yDevRol</code> outputs:
</p>
<ul>
<li>
To rotate lead/lag device configurations, and lead/standby device configurations where the lead does
not operate continuously, the controller can use:
<ul>
<li>
the <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.LeastRuntime\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.LeastRuntime</a> subsequence.
In this subsequence the rotation signal is generated based on Guideline36 5.1.15.3 and 5.1.15.4.a. as applied to two devices/groups of devices.
</li>
<li>
the <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.MinimumLeadRuntime\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.MinimumLeadRuntime</a> subsequence.
This subsequences uses a minimum cumulative runtime period <code>minLeaRuntime</code> for a current lead device before rotation may occur.
</li>
</ul>
</li>
<li>
To rotate lead/standby device configurations where the lead operates continuously the controller uses
the <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Scheduler\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Scheduler</a> subsequence.
In this subsequence the rotation signal is generated in regular time intervals, either measured from the simulation start or prescribed using a schedule.
Before a device is put to stand-by, the new lead device must be proven on, as implemented by the
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.ContinuousLeadSwapTwo\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.ContinuousLeadSwapTwo</a> subsequence.
The implementations are based on section 5.1.15.4.b.
</li>
</ul>
<p>
The <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Two\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Two</a> subsequence allocates
the status setpoints <code>yDevStaSet</code> to devices based on the rotation signal.
</p>
<p>
The output vector <code>yDevRol</code> indicates the role of each device, where true
represents a lead role and false represents a lag or a standby role.
</p>
<p>
The indices of both output vectors and the <code>uDevSta</code> input vector represent physical devices.
</p>
<p>
In addition to the specification in Guideline36, this model allows the user to:
</p>
<ul>
<li>
specify time of day and either a number of days or a weekday with a number of weeks
as time period to rotate devices or groups of devices that run continuously.
</li>
<li>
optionally impose a minimum cumulative runtime period <code>minLeaRuntime</code> for a current
lead device before rotation may occur. The time is accumulated in any role for each device and
reset for each lead device or group of devices at role rotation.
This implementation assumes that a more frequent load is being sent to a lead device or group of devices.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
May 18, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end ControllerTwo;
