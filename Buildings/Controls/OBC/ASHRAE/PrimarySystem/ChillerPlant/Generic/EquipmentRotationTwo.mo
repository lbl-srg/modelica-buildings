within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic;
block EquipmentRotationTwo
  "Lead-lag or lead-standby equipment rotation for two devices or two groups of devices"

  parameter Boolean lag = true
    "true = lead/lag, false = lead/standby";

  parameter Integer num = 2
    "Total number of devices, such as chillers, isolation valves, CW pumps, or CHW pumps";

  parameter Real stagingRuntime(unit = "s") = 240 * 60 * 60
    "Staging runtime";

  parameter Boolean initRoles[:] = {if i==1 then true else false for i in 1:num}
    "Initial roles: true = lead, false = lag/standby";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaSta
    "Lead device status"
    annotation (Placement(transformation(extent={{-240,20},
    {-200,60}}), iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLagSta if lag
    "Lag device status"
    annotation (Placement(transformation(extent={{-240,-60},{-200,-20}}),
    iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDevSta[num]
    "Device status (index represents the physical device)" annotation (
      Placement(transformation(extent={{200,30},{220,50}}),
        iconTransformation(extent={{100,50},{120,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDevRol[num]
    "Device role: true = lead, false = lag or standby"
    annotation (Placement(transformation(extent={{200,-40},{220,-20}}),
        iconTransformation(extent={{100,-70},{120,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr[num](
    final threshold=stagingRuntime)
    "Staging runtime hysteresis"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim[num](
    final reset=false)
    "Measures time spent loaded at the current role (lead or lag)"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));

protected
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator repLead(
    final nout=num) "Replicates lead signal"
    annotation (Placement(transformation(extent={{-170,30},{-150,50}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator repLag(
    final nout=num) if lag
    "Replicates lag signal"
    annotation (Placement(transformation(extent={{-182,-80},{-162,-60}})));

  Buildings.Controls.OBC.CDL.Logical.And3 and3[num] "Logical and"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nu=num) "Array input or"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Logical.Not not0[num] "Logical not"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi[num]
    "Switch"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=num) "Signal replicator"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre[num](
    final pre_u_start=initRoles) "Previous timestep"
    annotation (Placement(transformation(extent={{140,-60},{160,-40}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1[num]
    "Falling Edge"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1[num] "Logical not"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));

  CDL.Logical.LogicalSwitch logSwi1[num] "Switch"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));

  CDL.Logical.Sources.Constant staSta[num](final k=false) if not lag
    "Standby status"
    annotation (Placement(transformation(extent={{-180,-110},{-160,-90}})));

equation
  connect(greEquThr.y, and3.u1) annotation (Line(points={{-59,30},{-30,30},{-30,
          8},{-22,8}}, color={255,0,255}));
  connect(logSwi.u1, not0.y) annotation (Line(points={{98,-22},{70,-22},{70,-50},
          {41,-50}}, color={255,0,255}));
  connect(mulOr.u[1:2],and3. y)
    annotation (Line(points={{18,0},{18,0},{1,0}},    color={255,0,255}));
  connect(mulOr.y, booRep.u) annotation (Line(points={{41.7,0},{58,0}},
    color={255,0,255}));
  connect(logSwi.u2, booRep.y) annotation (Line(points={{98,-30},{90,-30},{90,0},
          {81,0}}, color={255,0,255}));
  connect(logSwi.y, pre.u) annotation (Line(points={{121,-30},{130,-30},{130,
          -50},{138,-50}}, color={255,0,255}));
  connect(pre.y, not0.u) annotation (Line(points={{161,-50},{170,-50},{170,-70},
          {10,-70},{10,-50},{18,-50}}, color={255,0,255}));
  connect(pre.y, logSwi.u3) annotation (Line(points={{161,-50},{170,-50},{170,
          -70},{90,-70},{90,-38},{98,-38}}, color={255,0,255}));
  connect(not1.y,and3. u2)
    annotation (Line(points={{-99,-10},{-60,-10},{-60,0},{-22,0}},
    color={255,0,255}));
  connect(tim.u0, falEdg1.y) annotation (Line(points={{-122,22},{-140,22},{-140,
          60},{40,60},{40,40},{21,40}}, color={255,0,255}));
  connect(pre.y, and3.u3) annotation (Line(points={{161,-50},{170,-50},{170,-70},
          {-30,-70},{-30,-8},{-22,-8}},        color={255,0,255}));
  connect(tim.y, greEquThr.u)
    annotation (Line(points={{-99,30},{-82,30}}, color={0,0,127}));
  connect(pre.y, falEdg1.u)
    annotation (Line(points={{161,-50},{170,-50},{170,
          20},{-20,20},{-20,40},{-2,40}}, color={255,0,255}));
  connect(logSwi.y, yDevRol)
    annotation (Line(points={{121,-30},{210,-30}},
                       color={255,0,255}));
  connect(pre.y, logSwi1.u2) annotation (Line(points={{161,-50},{170,-50},{170,-80},
          {-152,-80},{-152,-60},{-142,-60}}, color={255,0,255}));
  connect(logSwi1.u1, repLead.y) annotation (Line(points={{-142,-52},{-142,40},{
          -149,40}}, color={255,0,255}));
  connect(logSwi1.u3, repLag.y) annotation (Line(points={{-142,-68},{-142,-70},{
          -161,-70}}, color={255,0,255}));
  connect(logSwi1.y, tim.u) annotation (Line(points={{-119,-60},{-110,-60},{-110,
          -40},{-130,-40},{-130,30},{-122,30}}, color={255,0,255}));
  connect(uLeaSta, repLead.u)
    annotation (Line(points={{-220,40},{-172,40}}, color={255,0,255}));
  connect(uLagSta, repLag.u) annotation (Line(points={{-220,-40},{-190,-40},{-190,
          -70},{-184,-70}}, color={255,0,255}));
  connect(logSwi1.y, yDevSta) annotation (Line(points={{-119,-60},{-110,-60},{-110,
          -100},{180,-100},{180,40},{210,40}}, color={255,0,255}));
  connect(logSwi1.y, not1.u) annotation (Line(points={{-119,-60},{-110,-60},{-110,
          -26},{-126,-26},{-126,-10},{-122,-10}}, color={255,0,255}));
  connect(staSta.y, logSwi1.u3) annotation (Line(points={{-159,-100},{-152,-100},
          {-152,-68},{-142,-68}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-200,-120},{200,120}})),
      defaultComponentName="equRot",
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
                              Text(
          extent={{-90,40},{90,-40}},
          lineColor={0,0,0},
          textString="equRot"),
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
          textString="%name")}),
  Documentation(info="<html>
<p>
This block rotates equipment, such as chillers, pumps or valves, in order 
to ensure equal wear and tear. It can be used for lead/lag and 
lead/standby operation, as specified in &quot;ASHRAE Fundamentals of Chilled Water Plant Design and Control SDL&quot;, 
Chapter 7, App B, 1.01, A.4.  The output vector <code>yDevRol<\code> indicates the lead/lag (or lead/standby) status
of the devices, while the <code>yDevSta<\code> indicates the on/off status of each device. The index of
output vectors and <code>initRoles<\code> parameter indicates the physical device.
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
end EquipmentRotationTwo;
