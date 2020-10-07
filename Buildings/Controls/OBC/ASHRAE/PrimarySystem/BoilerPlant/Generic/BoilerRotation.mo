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

  parameter Integer nBoi
    "Number of boilers in the plant";

  parameter Integer nSta
    "Number of stages";

  parameter Integer staMat[nSta,nBoi]
    "Matrix indicating which boilers can be enabled in each stage";

  parameter Integer lagDevMat[nSta,nDev]
    "Matrix indicating indices of lead/lag boilers in each stage";

  EquipmentRotation.ControllerTwo equRot[nSta](
    lag=false,
    continuous=false,
    minLim=false,
    simTimSta=true,
    rotationPeriod(displayUnit="h")) "Boiler rotation controller"
    annotation (Placement(transformation(extent={{100,100},{120,120}})));
  CDL.Integers.Sources.Constant conInt[nSta,nDev](k=lagDevMat)
    "Matrix indicating indices of lead/lag devices in each stage; Enter 0 if absent"
    annotation (Placement(transformation(extent={{-150,60},{-130,80}})));
  CDL.Interfaces.BooleanInput uBoi[nBoi] "Vector of boiler enable status"
    annotation (Placement(transformation(extent={{-200,90},{-160,130}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
// protected
  final parameter Integer nDev = 2
    "Total number of devices";

  final constant Integer firstYear = 2010
    "First year that is supported, i.e. the first year in timeStampsNewYear[:]"
    annotation (Evaluate=true, Dialog(enable=not continuous));

  final constant Integer lastYear = firstYear + 20
    "Last year that is currently supported"
    annotation (Evaluate=true, Dialog(enable=not continuous));

  final parameter Integer boiInd[nBoi]={i for i in 1:nBoi}
    "Vector of boiler indices up to total number of boilers in  plant";

  final parameter Integer boiIndMat[nSta,nBoi] = {j for i in 1:nSta, j in 1:nBoi}
    "Matrix with rows of boiler indices for each stage";

  final parameter Integer staInd[nSta]={i for i in 1:nSta}
    "Vector of stage indices up to highest stage";

  final parameter Integer devInd[nDev]={i for i in 1:nDev}
    "Vector of device indices";

  CDL.Continuous.GreaterThreshold greThr[nSta,nDev](t=fill(
        0.5,
        nSta,
        nDev)) "Convert boiler enable status to Boolean"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));
  CDL.Conversions.BooleanToInteger booToInt[nSta,nDev]
    "Boolean to Integer conversion"
    annotation (Placement(transformation(extent={{-150,-60},{-130,-40}})));
  CDL.Integers.Product proInt2[nSta,nDev]
    "Element-wise product to find indices of boilers enabled/disabled by rotation controller"
    annotation (Placement(transformation(extent={{-110,-60},{-90,-40}})));
  CDL.Conversions.IntegerToReal intToRea1[nSta,nDev]
    "Integer to Real conversion"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  CDL.Continuous.MatrixMax matMax1(nRow=nSta, nCol=nDev)
    "Find index of enabled lead boiler"
    annotation (Placement(transformation(extent={{-50,-60},{-30,-40}})));
  CDL.Conversions.RealToInteger reaToInt1[nSta] "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  CDL.Routing.IntegerReplicator intRep[nSta](nout=fill(nBoi, nSta))
    "Integer replicator"
    annotation (Placement(transformation(extent={{10,-60},{30,-40}})));
  CDL.Integers.Equal intEqu[nSta,nBoi]
    "Find index of current lead boiler in staging matrix"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  CDL.Conversions.BooleanToInteger booToInt1[nSta,nBoi]
    "Boolean to Integer conversion"
    annotation (Placement(transformation(extent={{70,-60},{90,-40}})));
  CDL.Integers.Sources.Constant conInt1[nSta,nBoi](k=staMat)
    "Matrix indicating all boilers that can be enabled in each stage"
    annotation (Placement(transformation(extent={{-150,-150},{-130,-130}})));
  CDL.Interfaces.IntegerOutput yStaMat[nSta,nBoi]
    "Actual staging matrix after boiler rotation has been performed"
    annotation (Placement(transformation(extent={{160,-90},{200,-50}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  CDL.Integers.Sources.Constant conInt3[nSta,nBoi](k=boiIndMat)
    "Matrix with rows of boiler indices for each stage"
    annotation (Placement(transformation(extent={{-150,-110},{-130,-90}})));
  CDL.Integers.Equal intEqu1[nSta,nBoi]
    "Find index of current lead boiler in staging matrix"
    annotation (Placement(transformation(extent={{-110,-110},{-90,-90}})));
  CDL.Conversions.BooleanToInteger booToInt2[nSta,nBoi]
    "Boolean to Integer conversion"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  CDL.Integers.Add addInt[nSta,nBoi](k1=fill(
        -1,
        nSta,
        nBoi)) "Subtract status of boiler with lower index"
    annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
  CDL.Integers.Add addInt1[nSta,nBoi](k1=fill(
        -1,
        nSta,
        nBoi)) "Subtract status of boiler with lower index"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));
  CDL.Conversions.IntegerToReal intToRea[nSta,nDev]
    "Integer to Real conversion"
    annotation (Placement(transformation(extent={{-110,40},{-90,60}})));
  CDL.Continuous.MatrixMax matMax(nRow=nSta, nCol=nDev)
    "Find lead/lag boiler with higher index"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  CDL.Continuous.MatrixMin matMin(nRow=nSta, nCol=nDev)
    "Find lead/lag boiler with lower index"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  CDL.Conversions.RealToInteger reaToInt2[nSta] "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  CDL.Conversions.RealToInteger reaToInt3[nSta] "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
  CDL.Integers.Equal intEqu2[nSta,nBoi]
    "Find index of current lead boiler in staging matrix"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  CDL.Conversions.BooleanToInteger booToInt3[nSta,nBoi]
    "Boolean to Integer conversion"
    annotation (Placement(transformation(extent={{30,-110},{50,-90}})));
  CDL.Integers.Add addInt2[nSta,nBoi](k1=fill(
        2,
        nSta,
        nBoi)) "Add status of lead/lag boiler that has been enabled"
    annotation (Placement(transformation(extent={{110,-80},{130,-60}})));
  CDL.Conversions.BooleanToInteger booToInt4[nBoi]
    "Boolean to Integer conversion"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  CDL.Integers.Sources.Constant conInt2[nBoi](k=boiInd)
    "Vector of boiler indices up to total number of boilers"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  CDL.Integers.Product proInt[nBoi] "Find indices of enabled boilers"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  CDL.Routing.IntegerReplicator intRep1[nDev](nout=fill(nBoi, nDev))
    "Integer replicator"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  CDL.Routing.IntegerReplicator intRep2[nSta](nout=fill(nBoi, nSta))
    "Integer replicator"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  CDL.Routing.IntegerReplicator intRep3[nSta](nout=fill(nBoi, nSta))
    "Integer replicator"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  CDL.Continuous.GreaterThreshold greThr1[nSta]
    "Generate signal indicating presence of lead/lag pair in stage"
    annotation (Placement(transformation(extent={{20,130},{40,150}})));
equation
  connect(greThr.y, equRot.uDevSta) annotation (Line(points={{42,110},{60,110},{
          60,104},{98,104}},
                        color={255,0,255}));
  connect(equRot.yDevStaSet, booToInt.u) annotation (Line(points={{122,116},{150,
          116},{150,4},{-156,4},{-156,-50},{-152,-50}},    color={255,0,255}));
  connect(booToInt.y, proInt2.u2) annotation (Line(points={{-128,-50},{-120,-50},
          {-120,-56},{-112,-56}},
                               color={255,127,0}));
  connect(proInt2.y, intToRea1.u)
    annotation (Line(points={{-88,-50},{-82,-50}}, color={255,127,0}));
  connect(intToRea1.y, matMax1.u)
    annotation (Line(points={{-58,-50},{-52,-50}}, color={0,0,127}));
  connect(matMax1.y, reaToInt1.u)
    annotation (Line(points={{-28,-50},{-22,-50}}, color={0,0,127}));
  connect(reaToInt1.y, intRep.u)
    annotation (Line(points={{2,-50},{8,-50}}, color={255,127,0}));
  connect(intRep.y, intEqu.u1)
    annotation (Line(points={{32,-50},{38,-50}}, color={255,127,0}));
  connect(intEqu.y, booToInt1.u)
    annotation (Line(points={{62,-50},{68,-50}}, color={255,0,255}));
  connect(conInt1.y, addInt.u2) annotation (Line(points={{-128,-140},{-100,-140},
          {-100,-120},{-54,-120},{-54,-106},{-52,-106}},
                               color={255,127,0}));
  connect(conInt.y, proInt2.u1) annotation (Line(points={{-128,70},{-120,70},{-120,
          -44},{-112,-44}}, color={255,127,0}));
  connect(conInt.y, intToRea.u) annotation (Line(points={{-128,70},{-120,70},{-120,
          50},{-112,50}}, color={255,127,0}));
  connect(intToRea.y, matMax.u)
    annotation (Line(points={{-88,50},{-82,50}}, color={0,0,127}));
  connect(intToRea.y, matMin.u) annotation (Line(points={{-88,50},{-86,50},{-86,
          20},{-82,20}}, color={0,0,127}));
  connect(conInt3.y, intEqu1.u1)
    annotation (Line(points={{-128,-100},{-112,-100}}, color={255,127,0}));
  connect(intEqu1.y, booToInt2.u)
    annotation (Line(points={{-88,-100},{-82,-100}}, color={255,0,255}));
  connect(intEqu2.y, booToInt3.u)
    annotation (Line(points={{22,-100},{28,-100}}, color={255,0,255}));
  connect(booToInt3.y, addInt1.u1) annotation (Line(points={{52,-100},{56,-100},
          {56,-94},{58,-94}}, color={255,127,0}));
  connect(addInt.y, addInt1.u2) annotation (Line(points={{-28,-100},{-26,-100},{
          -26,-120},{56,-120},{56,-106},{58,-106}}, color={255,127,0}));
  connect(conInt3.y, intEqu2.u1) annotation (Line(points={{-128,-100},{-124,-100},
          {-124,-114},{-10,-114},{-10,-100},{-2,-100}}, color={255,127,0}));
  connect(addInt1.y, addInt2.u2) annotation (Line(points={{82,-100},{100,-100},{
          100,-76},{108,-76}}, color={255,127,0}));
  connect(booToInt1.y, addInt2.u1) annotation (Line(points={{92,-50},{100,-50},{
          100,-64},{108,-64}}, color={255,127,0}));
  connect(addInt2.y, yStaMat)
    annotation (Line(points={{132,-70},{180,-70}}, color={255,127,0}));
  connect(conInt3.y, intEqu.u2) annotation (Line(points={{-128,-100},{-124,-100},
          {-124,-70},{34,-70},{34,-58},{38,-58}}, color={255,127,0}));
  connect(booToInt2.y, addInt.u1) annotation (Line(points={{-58,-100},{-54,-100},
          {-54,-94},{-52,-94}}, color={255,127,0}));
  connect(uBoi, booToInt4.u)
    annotation (Line(points={{-180,110},{-142,110}}, color={255,0,255}));
  connect(conInt2.y, proInt.u1) annotation (Line(points={{-118,140},{-110,140},
          {-110,136},{-102,136}}, color={255,127,0}));
  connect(booToInt4.y, proInt.u2) annotation (Line(points={{-118,110},{-110,110},
          {-110,124},{-102,124}}, color={255,127,0}));
  connect(reaToInt2.u, matMax.y)
    annotation (Line(points={{-52,50},{-58,50}}, color={0,0,127}));
  connect(matMin.y, reaToInt3.u)
    annotation (Line(points={{-58,20},{-52,20}}, color={0,0,127}));
  connect(reaToInt3.y, intRep3.u)
    annotation (Line(points={{-28,20},{-22,20}}, color={255,127,0}));
  connect(reaToInt2.y, intRep2.u)
    annotation (Line(points={{-28,50},{-22,50}}, color={255,127,0}));
  connect(intRep3.y, intEqu2.u2) annotation (Line(points={{2,20},{4,20},{4,-80},
          {-20,-80},{-20,-108},{-2,-108}}, color={255,127,0}));
  connect(intRep2.y, intEqu1.u2) annotation (Line(points={{2,50},{20,50},{20,0},
          {-116,0},{-116,-108},{-112,-108}}, color={255,127,0}));
  connect(matMax.y, greThr1.u) annotation (Line(points={{-58,50},{-54,50},{-54,
          140},{18,140}}, color={0,0,127}));
  connect(greThr1.y, equRot.uLeaStaSet) annotation (Line(points={{42,140},{80,
          140},{80,116},{98,116}}, color={255,0,255}));
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
