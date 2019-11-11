within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation;
block Controller
  "Lead-lag or lead-standby equipment rotation for two devices or two groups of devices"

  parameter Boolean lag = true
    "true = lead/lag; false = lead/standby";

  parameter Boolean continuous = false
    "Continuous lead device operation"
    annotation (Evaluate=true, Dialog(enable=not lag));

  parameter Boolean initRoles[nDev] = {true, false}
    "Initial roles: true = lead, false = lag/standby"
    annotation (Evaluate=true,Dialog(tab="Advanced", group="Initiation"));

  parameter Modelica.SIunits.Time stagingRuntime(
    final displayUnit = "h") = 864000
    "Staging runtime for each device";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaStaSet
    "Lead device status command/setpoint"
    annotation (Placement(transformation(extent={{-300,20},{-260,60}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLagStaSet if lag
    "Lag device status" annotation (Placement(transformation(extent={{-300,-60},
            {-260,-20}}), iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDevStaSet[nDev]
    "Device status (index represents the physical device)" annotation (
      Placement(transformation(extent={{260,30},{280,50}}), iconTransformation(
          extent={{100,50},{120,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDevRolSet[nDev]
    "Device role: true = lead, false = lag or standby"
    annotation (Placement(transformation(extent={{260,-50},{280,-30}}),
    iconTransformation(extent={{100,-70},{120,-50}})));

//protected
  final parameter Integer nDev = 2
    "Total number of devices, such as chillers, isolation valves, CW pumps, or CHW pumps";

  final parameter Modelica.SIunits.Time stagingRuntimes[nDev] = fill(stagingRuntime, nDev)
    "Staging runtimes array";

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator repLead(
    final nout=nDev)
    "Replicates lead signal"
    annotation (Placement(transformation(extent={{-240,30},{-220,50}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator repLag(
    final nout=nDev) if lag
    "Replicates lag signal"
    annotation (Placement(transformation(extent={{-240,-50},{-220,-30}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi1[nDev] "Switch"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staBySta[nDev](
    final k=fill(false, nDev)) if not lag
    "Standby status"
    annotation (Placement(transformation(extent={{-240,-100},{-220,-80}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Scheduler equRot1 if continuous
    "mig_if_cont"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.ContinuousLeadSwap leaSwa if continuous
    "Lead role swap for continuously operating lead devices mig_if_cont"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.RuntimeCounter runCou if not continuous
    "Runtime counter"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Two rotTwo
    "mig if two"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Two rotTwoCon "mig_if_cont"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDevSta[nDev]
    "mig if cont operation"
    annotation (Placement(transformation(extent={{-300,70},{-260,110}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));

equation
  connect(logSwi1.u1,repLead. y) annotation (Line(points={{-182,-32},{-190,-32},
          {-190,40},{-218,40}}, color={255,0,255}));
  connect(logSwi1.u3,repLag. y) annotation (Line(points={{-182,-48},{-210,-48},{
          -210,-40},{-218,-40}},  color={255,0,255}));
  connect(uLeaStaSet, repLead.u)
    annotation (Line(points={{-280,40},{-242,40}}, color={255,0,255}));
  connect(uLagStaSet, repLag.u)
    annotation (Line(points={{-280,-40},{-242,-40}}, color={255,0,255}));
  connect(logSwi1.y, yDevStaSet) annotation (Line(points={{-158,-40},{-140,-40},
          {-140,80},{220,80},{220,40},{270,40}}, color={255,0,255}));
  connect(staBySta.y,logSwi1. u3) annotation (Line(points={{-218,-90},{-200,-90},{
          -200,-48},{-182,-48}},  color={255,0,255}));
  connect(logSwi1.y, runCou.uDevStaSet)
    annotation (Line(points={{-158,-40},{-42,-40}}, color={255,0,255}));
  connect(leaSwa.yDevStaSet, yDevStaSet) annotation (Line(points={{42,30},{200,30},
          {200,40},{270,40}}, color={255,0,255}));
  connect(runCou.yRot, rotTwo.uRot) annotation (Line(points={{-18,-40},{8,-40},{
          8,-70},{38,-70}}, color={255,0,255}));
  connect(rotTwo.yDevRolSet, yDevRolSet) annotation (Line(points={{61,-70},{160,
          -70},{160,-40},{270,-40}}, color={255,0,255}));
  connect(rotTwo.yPreDevRolSet, runCou.uPreDevRolSig) annotation (Line(points={{
          61,-76},{70,-76},{70,-100},{-60,-100},{-60,-48},{-42,-48}}, color={255,
          0,255}));
  connect(rotTwo.yPreDevRolSet, logSwi1.u2) annotation (Line(points={{61,-76},{70,
          -76},{70,-110},{-190,-110},{-190,-40},{-182,-40}}, color={255,0,255}));
  connect(equRot1.yRot, rotTwoCon.uRot)
    annotation (Line(points={{-58,30},{-42,30}}, color={255,0,255}));
  connect(uDevSta, leaSwa.uDevSta) annotation (Line(points={{-280,90},{10,90},{10,
          26},{18,26}}, color={255,0,255}));
  connect(rotTwoCon.yDevRolSet, leaSwa.uDevRolSet) annotation (Line(points={{-19,
          30},{0,30},{0,34},{18,34}}, color={255,0,255}));
  connect(rotTwoCon.yDevRolSet, yDevRolSet) annotation (Line(points={{-19,30},{0,
          30},{0,-20},{160,-20},{160,-40},{270,-40}}, color={255,0,255}));
    annotation (Evaluate=true,
              Diagram(coordinateSystem(extent={{-260,-160},{260,160}})),
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
end Controller;
