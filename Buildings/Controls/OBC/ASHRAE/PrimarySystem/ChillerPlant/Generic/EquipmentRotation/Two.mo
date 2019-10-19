within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation;
block Two
  "Lead-lag or lead-standby equipment rotation for two devices or two groups of devices"

  parameter Boolean lag = true
    "true = lead/lag, false = lead/standby";

  parameter Boolean initRoles[nDev] = {true, false}
    "Initial roles: true = lead, false = lag/standby"
    annotation (Evaluate=true,Dialog(tab="Advanced", group="Initiation"));

  parameter Modelica.SIunits.Time stagingRuntime(
    final displayUnit = "h") = 864000
    "Staging runtime for each device";

//protected
  final parameter Integer nDev = 2
    "Total number of devices, such as chillers, isolation valves, CW pumps, or CHW pumps";

  final parameter Modelica.SIunits.Time stagingRuntimes[nDev] = fill(stagingRuntime, nDev)
    "Staging runtimes array";

  CDL.Continuous.GreaterEqualThreshold                        greEquThr[nDev](final
      threshold=stagingRuntimes)
    "Staging runtime hysteresis"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  CDL.Logical.Timer                        tim[nDev](final reset={false,false})
    "Measures time spent loaded at the current role (lead or lag)"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  CDL.Routing.BooleanReplicator                        repLead(final nout=nDev)
                     "Replicates lead signal"
    annotation (Placement(transformation(extent={{-240,30},{-220,50}})));
  CDL.Routing.BooleanReplicator                        repLag(final nout=nDev)
    if                  lag
    "Replicates lag signal"
    annotation (Placement(transformation(extent={{-240,-50},{-220,-30}})));
  CDL.Logical.And3                        and3[nDev] "Logical and"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  CDL.Logical.MultiOr                        mulOr(final nu=nDev)
                   "Array input or"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  CDL.Logical.Not                        not0[nDev] "Logical not"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  CDL.Logical.LogicalSwitch                        logSwi[nDev]
    "Switch"
    annotation (Placement(transformation(extent={{130,-50},{150,-30}})));
  CDL.Routing.BooleanReplicator                        booRep(final nout=nDev)
                     "Signal replicator"
    annotation (Placement(transformation(extent={{90,-20},{110,0}})));
  CDL.Logical.Pre                        pre[nDev](final pre_u_start=initRoles)
                                 "Previous timestep"
    annotation (Placement(transformation(extent={{170,-70},{190,-50}})));
  CDL.Logical.FallingEdge                        falEdg1[nDev]
    "Falling Edge"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  CDL.Logical.LogicalSwitch                        logSwi1[nDev] "Switch"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  CDL.Logical.Sources.Constant                        staSta[nDev](final k=fill(
        false, nDev)) if          not lag
    "Standby status"
    annotation (Placement(transformation(extent={{-240,-100},{-220,-80}})));
  CDL.Logical.MultiAnd allOn(nu=2)
    "Outputs true if all devices are commanded enable"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  CDL.Logical.MultiOr anyOn(nu=2) "Checks if any device is commanded enable"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  CDL.Logical.Not allOff "Returns true if all devices are commanded disable"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  CDL.Routing.BooleanReplicator booRep1(nout=nDev)
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  CDL.Logical.Or equSig
    "Outputs true if either all devices are commanded enable or all devices are commanded disable"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  CDL.Interfaces.BooleanInput uLeaStaSet "Lead device status command/setpoint"
    annotation (Placement(transformation(extent={{-300,20},{-260,60}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  CDL.Interfaces.BooleanInput uLagStaSet if                     lag
    "Lag device status" annotation (Placement(transformation(extent={{-300,-60},
            {-260,-20}}), iconTransformation(extent={{-140,-80},{-100,-40}})));
  CDL.Interfaces.BooleanOutput yDevStaSet[nDev]
    "Device status (index represents the physical device)" annotation (
      Placement(transformation(extent={{260,30},{280,50}}), iconTransformation(
          extent={{100,50},{120,70}})));
  CDL.Interfaces.BooleanOutput yDevRolSet[nDev]
    "Device role: true = lead, false = lag or standby" annotation (Placement(
        transformation(extent={{260,-40},{280,-20}}), iconTransformation(extent
          ={{100,-70},{120,-50}})));
equation
  connect(greEquThr.y,and3. u1) annotation (Line(points={{2,30},{10,30},{10,-2},
          {18,-2}},      color={255,0,255}));
  connect(logSwi.u1,not0. y) annotation (Line(points={{128,-32},{100,-32},{100,
          -40},{82,-40}},
                 color={255,0,255}));
  connect(mulOr.u[1:2],and3. y)
    annotation (Line(points={{58,-10},{42,-10}},
                                              color={255,0,255}));
  connect(mulOr.y,booRep. u) annotation (Line(points={{82,-10},{88,-10}},
    color={255,0,255}));
  connect(logSwi.u2,booRep. y) annotation (Line(points={{128,-40},{120,-40},{
          120,-10},{112,-10}},
                color={255,0,255}));
  connect(logSwi.y,pre. u) annotation (Line(points={{152,-40},{160,-40},{160,
          -60},{168,-60}},
                 color={255,0,255}));
  connect(pre.y,not0. u) annotation (Line(points={{192,-60},{210,-60},{210,-80},
          {40,-80},{40,-40},{58,-40}}, color={255,0,255}));
  connect(pre.y,logSwi. u3) annotation (Line(points={{192,-60},{200,-60},{200,
          -74},{120,-74},{120,-48},{128,-48}},
                                     color={255,0,255}));
  connect(tim.u0,falEdg1. y) annotation (Line(points={{-102,22},{-110,22},{-110,
          60},{90,60},{90,30},{82,30}}, color={255,0,255}));
  connect(pre.y,and3. u3) annotation (Line(points={{192,-60},{220,-60},{220,-86},
          {10,-86},{10,-18},{18,-18}},  color={255,0,255}));
  connect(tim.y,greEquThr. u)
    annotation (Line(points={{-78,30},{-22,30}}, color={0,0,127}));
  connect(pre.y,falEdg1. u)
    annotation (Line(points={{192,-60},{220,-60},{220,10},{40,10},{40,30},{58,
          30}}, color={255,0,255}));
  connect(logSwi.y, yDevRolSet) annotation (Line(points={{152,-40},{240,-40},{
          240,-30},{270,-30}}, color={255,0,255}));
  connect(pre.y,logSwi1. u2) annotation (Line(points={{192,-60},{220,-60},{220,
          -100},{-190,-100},{-190,-40},{-182,-40}},
                                             color={255,0,255}));
  connect(logSwi1.u1,repLead. y) annotation (Line(points={{-182,-32},{-190,-32},
          {-190,40},{-218,40}}, color={255,0,255}));
  connect(logSwi1.u3,repLag. y) annotation (Line(points={{-182,-48},{-210,-48},{
          -210,-40},{-218,-40}},  color={255,0,255}));
  connect(logSwi1.y,tim. u) annotation (Line(points={{-158,-40},{-150,-40},{
          -150,30},{-102,30}},                  color={255,0,255}));
  connect(uLeaStaSet, repLead.u)
    annotation (Line(points={{-280,40},{-242,40}}, color={255,0,255}));
  connect(uLagStaSet, repLag.u)
    annotation (Line(points={{-280,-40},{-242,-40}}, color={255,0,255}));
  connect(logSwi1.y, yDevStaSet) annotation (Line(points={{-158,-40},{-150,-40},
          {-150,-90},{230,-90},{230,40},{270,40}}, color={255,0,255}));
  connect(staSta.y,logSwi1. u3) annotation (Line(points={{-218,-90},{-200,-90},{
          -200,-48},{-182,-48}},  color={255,0,255}));
  connect(logSwi1.y, allOn.u[1:2]) annotation (Line(points={{-158,-40},{-150,
          -40},{-150,0},{-102,0},{-102,-3.5}}, color={255,0,255}));
  connect(booRep1.y, and3.u2)
    annotation (Line(points={{2,-10},{18,-10}}, color={255,0,255}));
  connect(anyOn.y, allOff.u)
    annotation (Line(points={{-118,-40},{-102,-40}}, color={255,0,255}));
  connect(logSwi1.y, anyOn.u[1:2]) annotation (Line(points={{-158,-40},{-142,
          -40},{-142,-43.5}}, color={255,0,255}));
  connect(booRep1.u, equSig.y)
    annotation (Line(points={{-22,-10},{-38,-10}}, color={255,0,255}));
  connect(allOff.y, equSig.u2) annotation (Line(points={{-78,-40},{-70,-40},{
          -70,-18},{-62,-18}}, color={255,0,255}));
  connect(allOn.y, equSig.u1) annotation (Line(points={{-78,0},{-70,0},{-70,-10},
          {-62,-10}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-260,-160},{260,160}})),
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
end Two;
