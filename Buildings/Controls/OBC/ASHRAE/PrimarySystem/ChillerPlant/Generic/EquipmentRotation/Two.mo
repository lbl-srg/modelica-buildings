within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation;
block Two
  "Lead-lag or lead-standby equipment rotation for two devices or two groups of devices"

  parameter Boolean lag = true
    "true = lead/lag, false = lead/standby";

  parameter Boolean continuous = false if not lag
    "Continuous lead device operation";

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

  CDL.Routing.BooleanReplicator                        repLead(final nout=nDev)
                     "Replicates lead signal"
    annotation (Placement(transformation(extent={{-240,30},{-220,50}})));
  CDL.Routing.BooleanReplicator                        repLag(final nout=nDev) if
                        lag
    "Replicates lag signal"
    annotation (Placement(transformation(extent={{-240,-50},{-220,-30}})));
  CDL.Logical.LogicalSwitch                        logSwi1[nDev] "Switch"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  CDL.Logical.Sources.Constant                        staSta[nDev](final k=fill(
         false, nDev)) if         not lag
    "Standby status"
    annotation (Placement(transformation(extent={{-240,-100},{-220,-80}})));
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
        transformation(extent={{260,-50},{280,-30}}), iconTransformation(extent=
           {{100,-70},{120,-50}})));
  Subsequences.Scheduler equRot1
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Subsequences.LeadSwap equRot2
    annotation (Placement(transformation(extent={{-12,18},{8,38}})));
  Subsequences.RuntimeCounter runCou
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
equation
  connect(logSwi1.u1,repLead. y) annotation (Line(points={{-182,-32},{-190,-32},
          {-190,40},{-218,40}}, color={255,0,255}));
  connect(logSwi1.u3,repLag. y) annotation (Line(points={{-182,-48},{-210,-48},{
          -210,-40},{-218,-40}},  color={255,0,255}));
  connect(uLeaStaSet, repLead.u)
    annotation (Line(points={{-280,40},{-242,40}}, color={255,0,255}));
  connect(uLagStaSet, repLag.u)
    annotation (Line(points={{-280,-40},{-242,-40}}, color={255,0,255}));
  connect(logSwi1.y, yDevStaSet) annotation (Line(points={{-158,-40},{-150,-40},
          {-150,76},{224,76},{224,40},{270,40}}, color={255,0,255}));
  connect(staSta.y,logSwi1. u3) annotation (Line(points={{-218,-90},{-200,-90},{
          -200,-48},{-182,-48}},  color={255,0,255}));
  connect(logSwi1.y, runCou.uDevStaSet)
    annotation (Line(points={{-158,-40},{-42,-40}}, color={255,0,255}));
  connect(runCou.yDevRolSet, yDevRolSet)
    annotation (Line(points={{-19,-40},{270,-40}}, color={255,0,255}));
  connect(runCou.yPreDevRolSet, logSwi1.u2) annotation (Line(points={{-19,-46},
          {0,-46},{0,-60},{-190,-60},{-190,-40},{-182,-40}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-260,-160},{260,160}})),
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
end Two;
