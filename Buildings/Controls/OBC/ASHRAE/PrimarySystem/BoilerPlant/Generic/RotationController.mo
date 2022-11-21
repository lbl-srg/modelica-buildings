within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic;
block RotationController
  "Sequence to rotate components in lead/lag pairs"

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

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDevStaSet[nDev]
    "Device status setpoint from controller"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}}),
      iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDevSta[nDev]
    "Measured device status from plant"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDevStaSet[nDev]
    "Device status setpoint from equipment rotation controller"
    annotation (Placement(transformation(extent={{100,30},{140,70}}),
      iconTransformation(extent={{100,30},{140,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yStaFee[nDev]
    "Component status feedback signal back to main controller"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
      iconTransformation(extent={{100,-70},{140,-30}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.EquipmentRotation.ControllerTwo equRot(
    final lag = lag,
    final continuous = continuous,
    final minLim = minLim,
    final initRoles = initRoles,
    final simTimSta = simTimSta,
    final weeInt = weeInt,
    final rotationPeriod = rotationPeriod,
    final minLeaRuntime = minLeaRuntime,
    final offset = offset,
    final zerTim = zerTim,
    final yearRef = yearRef,
    final houOfDay = houOfDay,
    final weeCou = weeCou,
    final weekday = weekday,
    final dayCou = dayCou)
    "Equipment rotation controller"
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));

protected
  final parameter Integer nDev = 2
    "Number of devices in lead/lag relationship";

  final constant Integer firstYear = 2010
    "First year that is supported, i.e. the first year in timeStampsNewYear[:]"
    annotation (Evaluate=true, Dialog(enable=not continuous));

  final constant Integer lastYear = firstYear + 20
    "Last year that is currently supported"
    annotation (Evaluate=true, Dialog(enable=not continuous));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nDev]
    "Boolean to Integer conversion"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(
    final nin=nDev)
    "Integer Multi-sum"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr
    "Check if one component is enabled"
    annotation (Placement(transformation(extent={{50,20},{70,40}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr1(
    final t=1)
    "Check if both components are enabled"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep[nDev](
    final nout=fill(nDev, nDev))
    "Boolean replicator"
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nDev]
    "Logical switch"
    annotation (Placement(transformation(extent={{10,-90},{30,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[nDev](
    final k={true,false})
    "Constant Boolean source"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nDev](
    final k={false,false})
    "Constant Boolean source"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1[nDev]
    "Logical switch"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[nDev](
    final k={true,true})
    "Constant Boolean source"
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));

equation
  connect(uDevStaSet[1], equRot.uLeaStaSet) annotation (Line(points={{-120,40},{
          -120,50},{-80,50},{-80,46},{-72,46}},
                                              color={255,0,255}));
  connect(uDevSta, equRot.uDevSta) annotation (Line(points={{-120,-30},{-80,-30},
          {-80,34},{-72,34}}, color={255,0,255}));
  connect(equRot.yDevStaSet, yDevStaSet) annotation (Line(points={{-48,46},{-30,
          46},{-30,50},{120,50}}, color={255,0,255}));
  connect(booToInt.y, mulSumInt.u[1:2])
    annotation (Line(points={{2,0},{8,0},{8,-3.5}}, color={255,127,0}));
  connect(mulSumInt.y, intGreThr.u) annotation (Line(points={{32,0},{40,0},{40,30},
          {48,30}}, color={255,127,0}));
  connect(mulSumInt.y, intGreThr1.u)
    annotation (Line(points={{32,0},{48,0}}, color={255,127,0}));
  connect(intGreThr.y, booRep[1].u) annotation (Line(points={{72,30},{80,30},{80,
          -20},{-40,-20},{-40,-40},{-32,-40}}, color={255,0,255}));
  connect(intGreThr1.y, booRep[2].u) annotation (Line(points={{72,0},{80,0},{80,
          -20},{-40,-20},{-40,-40},{-32,-40}}, color={255,0,255}));
  connect(booRep[1].y, logSwi.u2) annotation (Line(points={{-8,-40},{0,-40},{0,-80},
          {8,-80}}, color={255,0,255}));
  connect(con.y, logSwi.u1) annotation (Line(points={{-58,-50},{-48,-50},{-48,-72},
          {8,-72}}, color={255,0,255}));
  connect(con1.y, logSwi.u3) annotation (Line(points={{-58,-80},{-54,-80},{-54,-88},
          {8,-88}}, color={255,0,255}));
  connect(logSwi.y, logSwi1.u3) annotation (Line(points={{32,-80},{40,-80},{40,-68},
          {48,-68}}, color={255,0,255}));
  connect(booRep[2].y, logSwi1.u2) annotation (Line(points={{-8,-40},{0,-40},{0,
          -60},{48,-60}}, color={255,0,255}));
  connect(con2.y, logSwi1.u1) annotation (Line(points={{32,-40},{40,-40},{40,-52},
          {48,-52}}, color={255,0,255}));
  connect(logSwi1.y, yStaFee)
    annotation (Line(points={{72,-60},{120,-60}}, color={255,0,255}));
  connect(uDevSta, booToInt.u) annotation (Line(points={{-120,-30},{-80,-30},{-80,
          0},{-22,0}}, color={255,0,255}));
  connect(uDevStaSet[2], equRot.uLagStaSet) annotation (Line(points={{-120,60},{
          -120,50},{-80,50},{-80,40},{-72,40}}, color={255,0,255}));
  annotation (defaultComponentName="rotCon",
    Icon(graphics={
      Text(
        extent={{-120,146},{100,108}},
        textColor={0,0,255},
        textString="%name"),
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
        Ellipse(
          origin={-26.667,38.6207},
          lineColor={128,128,128},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-53.3333,1.37927},{-13.3329,41.3792}}),
        Ellipse(
          origin={93.333,-81.379},
          lineColor={128,128,128},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-53.3333,1.37927},{-13.3329,41.3792}}),
        Ellipse(
          origin={-26.667,-81.379},
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
        Line(points={{-40,-60},{0,-60},{0,60},{40,60}}, color={128,128,128})},
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}})),
  Diagram(
    coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}})),
  Documentation(
    info="<html>
    <p>
    Block that controls equipment rotation process according to ASHRAE RP-1711, 
    March, 2020 draft, section 5.1.2.3.
    </p>
    <p>
    The implemented block acts as a wrapper for the equipment rotation controller
    <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.EquipmentRotation.ControllerTwo\">
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.EquipmentRotation.ControllerTwo</a>.
    In addition to the inputs and outputs available from the above block, 
    the implemented sequence has an additional output <code>yStaFee</code>, 
    which is the device status feedback to the main controller. This vector 
    arranges the status vector in the lead/lag order and sends it back to the 
    main controller.
    </html>",
    revisions="<html>
    <ul>
    <li>
    April 12, 2021, by Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end RotationController;
