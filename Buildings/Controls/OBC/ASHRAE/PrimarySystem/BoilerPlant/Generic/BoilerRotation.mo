within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic;
block BoilerRotation
  "Control sequence for enabling and disabling lead-lag boilers"

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

  EquipmentRotation.ControllerTwo equRot[nSta](
    continuous=false,
    minLim=false,
    rotationPeriod(displayUnit="h")) "Boiler rotation controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
protected
  final parameter Integer nDev = 2
    "Total number of devices, such as chillers, isolation valves, CW pumps, or CHW pumps";

  final constant Integer firstYear = 2010
    "First year that is supported, i.e. the first year in timeStampsNewYear[:]"
    annotation (Evaluate=true, Dialog(enable=not continuous));

  final constant Integer lastYear = firstYear + 20
    "Last year that is currently supported"
    annotation (Evaluate=true, Dialog(enable=not continuous));

equation

annotation(Diagram(coordinateSystem(extent={{-160,-160},{160,160}})),
      defaultComponentName="equRot",
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
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
based on the specification from ASHRAE RP-1711, March 2020 Draft, section 5.1.2.1.-4.
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
In this subsequence the rotation signal is generated based on RP-1711 5.1.2.3 and 5.1.2.4.1. as applied to two devices/groups of devices.
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
The implementations are based on section 5.1.2.4.2.
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
In addition to the specification in RP-1711, this model allows the user to:
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
end BoilerRotation;
