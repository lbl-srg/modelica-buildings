within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic;
block EquipmentRotationTwo
  "Lead-lag or lead-standby equipment rotation for two devices or two groups of devices"

  parameter Boolean lag = true
    "true = lead/lag, false = lead/standby";

  parameter Boolean initRoles[nDev] = {true, false}
    "Initial roles: true = lead, false = lag/standby"
    annotation (Evaluate=true,Dialog(tab="Advanced", group="Initiation"));

  parameter Modelica.SIunits.Time stagingRuntime(
    final displayUnit = "h") = 864000
    "Staging runtime for each device";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaSta
    "Lead device status"
    annotation (Placement(transformation(extent={{-260,20},{-220,60}}),
                 iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLagSta if lag
    "Lag device status"
    annotation (Placement(transformation(extent={{-260,-60},{-220,-20}}),
    iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDevSta[nDev]
    "Device status (index represents the physical device)" annotation (
      Placement(transformation(extent={{220,30},{240,50}}),
        iconTransformation(extent={{100,50},{120,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDevRol[nDev]
    "Device role: true = lead, false = lag or standby"
    annotation (Placement(transformation(extent={{220,-40},{240,-20}}),
        iconTransformation(extent={{100,-70},{120,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr[nDev](
    final threshold=stagingRuntimes)
    "Staging runtime hysteresis"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim[nDev](
    final reset={false,false})
    "Measures time spent loaded at the current role (lead or lag)"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));

protected
  final parameter Integer nDev = 2
    "Total number of devices, such as chillers, isolation valves, CW pumps, or CHW pumps";

  final parameter Modelica.SIunits.Time stagingRuntimes[nDev] = fill(stagingRuntime, nDev)
    "Staging runtimes array";

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator repLead(
    final nout=nDev) "Replicates lead signal"
    annotation (Placement(transformation(extent={{-200,30},{-180,50}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator repLag(
    final nout=nDev) if lag
    "Replicates lag signal"
    annotation (Placement(transformation(extent={{-200,-50},{-180,-30}})));

  Buildings.Controls.OBC.CDL.Logical.And3 and3[nDev] "Logical and"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nu=nDev) "Array input or"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.CDL.Logical.Not not0[nDev] "Logical not"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi[nDev]
    "Switch"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=nDev) "Signal replicator"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre[nDev](
    final pre_u_start=initRoles) "Previous timestep"
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1[nDev]
    "Falling Edge"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1[nDev] "Logical not"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi1[nDev] "Switch"
    annotation (Placement(transformation(extent={{-134,-90},{-114,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staSta[nDev](
    final k=fill(false, nDev)) if not lag
    "Standby status"
    annotation (Placement(transformation(extent={{-180,-110},{-160,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Or or0[nDev] "Logical or"
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));

  Buildings.Controls.OBC.CDL.Logical.And or1[nDev] "Logical or"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

equation
  connect(greEquThr.y, and3.u1) annotation (Line(points={{-58,60},{-30,60},{-30,
          38},{-22,38}}, color={255,0,255}));
  connect(logSwi.u1, not0.y) annotation (Line(points={{98,8},{70,8},{70,-20},{42,
          -20}}, color={255,0,255}));
  connect(mulOr.u[1:2],and3. y)
    annotation (Line(points={{18,30},{2,30}}, color={255,0,255}));
  connect(mulOr.y, booRep.u) annotation (Line(points={{42,30},{58,30}},
    color={255,0,255}));
  connect(logSwi.u2, booRep.y) annotation (Line(points={{98,0},{90,0},{90,30},{82,
          30}}, color={255,0,255}));
  connect(logSwi.y, pre.u) annotation (Line(points={{122,0},{130,0},{130,-20},{138,
          -20}}, color={255,0,255}));
  connect(pre.y, not0.u) annotation (Line(points={{162,-20},{170,-20},{170,-40},
          {10,-40},{10,-20},{18,-20}}, color={255,0,255}));
  connect(pre.y, logSwi.u3) annotation (Line(points={{162,-20},{170,-20},{170,-40},
          {90,-40},{90,-8},{98,-8}}, color={255,0,255}));
  connect(tim.u0, falEdg1.y) annotation (Line(points={{-122,52},{-140,52},{-140,
          90},{40,90},{40,70},{22,70}}, color={255,0,255}));
  connect(pre.y, and3.u3) annotation (Line(points={{162,-20},{170,-20},{170,-40},
          {-30,-40},{-30,22},{-22,22}}, color={255,0,255}));
  connect(tim.y, greEquThr.u)
    annotation (Line(points={{-98,60},{-82,60}}, color={0,0,127}));
  connect(pre.y, falEdg1.u)
    annotation (Line(points={{162,-20},{170,-20},{170,50},{-20,50},{-20,70},{-2,
          70}}, color={255,0,255}));
  connect(logSwi.y, yDevRol)
    annotation (Line(points={{122,0},{190,0},{190,-30},{230,-30}}, color={255,0,255}));
  connect(pre.y, logSwi1.u2) annotation (Line(points={{162,-20},{170,-20},{170,-50},
          {-150,-50},{-150,-80},{-136,-80}}, color={255,0,255}));
  connect(logSwi1.u1, repLead.y) annotation (Line(points={{-136,-72},{-146,-72},
          {-146,40},{-178,40}}, color={255,0,255}));
  connect(logSwi1.u3, repLag.y) annotation (Line(points={{-136,-88},{-152,-88},{
          -152,-40},{-178,-40}},  color={255,0,255}));
  connect(logSwi1.y, tim.u) annotation (Line(points={{-112,-80},{-110,-80},{-110,
          -10},{-130,-10},{-130,60},{-122,60}}, color={255,0,255}));
  connect(uLeaSta, repLead.u)
    annotation (Line(points={{-240,40},{-202,40}}, color={255,0,255}));
  connect(uLagSta, repLag.u) annotation (Line(points={{-240,-40},{-202,-40}},
                            color={255,0,255}));
  connect(logSwi1.y, yDevSta) annotation (Line(points={{-112,-80},{-110,-80},{-110,
          -70},{180,-70},{180,40},{230,40}}, color={255,0,255}));
  connect(logSwi1.y, not1.u) annotation (Line(points={{-112,-80},{-110,-80},{-110,
          4},{-126,4},{-126,20},{-122,20}}, color={255,0,255}));
  connect(staSta.y, logSwi1.u3) annotation (Line(points={{-158,-100},{-152,-100},
          {-152,-88},{-136,-88}}, color={255,0,255}));
  connect(or0.y, and3.u2) annotation (Line(points={{-48,20},{-40,20},{-40,30},{-22,
          30}}, color={255,0,255}));
  connect(not1.y, or0.u1)
    annotation (Line(points={{-98,20},{-72,20}},   color={255,0,255}));
  connect(or1.y, or0.u2) annotation (Line(points={{-58,-20},{-50,-20},{-50,0},{-80,
          0},{-80,12},{-72,12}}, color={255,0,255}));
  connect(repLag.y, or1.u2) annotation (Line(points={{-178,-40},{-150,-40},{-150,
          -60},{-92,-60},{-92,-28},{-82,-28}}, color={255,0,255}));
  connect(repLead.y, or1.u1) annotation (Line(points={{-178,40},{-144,40},{-144,
          0},{-90,0},{-90,-20},{-82,-20}}, color={255,0,255}));
  connect(staSta.y, or1.u2) annotation (Line(points={{-158,-100},{-140,-100},{-140,
          -64},{-90,-64},{-90,-28},{-82,-28}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-220,-120},{220,120}})),
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
end EquipmentRotationTwo;
