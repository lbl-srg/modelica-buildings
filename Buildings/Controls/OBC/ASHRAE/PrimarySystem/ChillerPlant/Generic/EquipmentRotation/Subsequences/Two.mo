within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences;
block Two
  "Equipment rotation signal based on device runtime and current device status"

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRot
    "Rising edge to rotate the equipment" annotation (Placement(transformation(
          extent={{-240,20},{-200,60}}), iconTransformation(extent={{-140,-20},{
            -100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDevRolSet[nDev]
    "Device role: true = lead, false = lag or standby"
    annotation (Placement(transformation(extent={{200,50},{220,70}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPreDevRolSet[nDev]
    "Device roles in the previous time instance: true = lead; false = lag or standby"
    annotation (Placement(transformation(extent={{200,-50},{220,-30}}),
        iconTransformation(extent={{100,-70},{120,-50}})));

//protected
  final parameter Integer nDev = 2
    "Total number of devices, such as chillers, isolation valves, CW pumps, or CHW pumps";

  final parameter Boolean initRoles[nDev] = {true, false}
    "Initial roles: true = lead, false = lag/standby"
    annotation (Evaluate=true,Dialog(tab="Advanced", group="Initiation"));

  Buildings.Controls.OBC.CDL.Logical.Not not0[nDev] "Logical not"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi[nDev] "Switch"
    annotation (Placement(transformation(extent={{-26,-10},{-6,10}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre[nDev](
    final pre_u_start=initRoles) "Previous timestep"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=nDev)
    "Signal replicator"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
equation
  connect(logSwi.u1,not0. y) annotation (Line(points={{-28,8},{-60,8},{-60,-10},
          {-78,-10}},color={255,0,255}));
  connect(logSwi.y,pre. u) annotation (Line(points={{-4,0},{10,0},{10,-20},{18,-20}},
                      color={255,0,255}));
  connect(pre.y,not0. u) annotation (Line(points={{42,-20},{60,-20},{60,-40},{-120,
          -40},{-120,-10},{-102,-10}}, color={255,0,255}));
  connect(pre.y,logSwi. u3) annotation (Line(points={{42,-20},{50,-20},{50,-34},
          {-40,-34},{-40,-8},{-28,-8}},color={255,0,255}));
  connect(logSwi.y, yDevRolSet) annotation (Line(points={{-4,0},{40,0},{40,60},{
          210,60}},        color={255,0,255}));
  connect(uRot, booRep.u)
    annotation (Line(points={{-220,40},{-102,40}}, color={255,0,255}));
  connect(booRep.y, logSwi.u2) annotation (Line(points={{-78,40},{-46,40},{-46,0},
          {-28,0}},    color={255,0,255}));
  connect(pre.y,yPreDevRolSet)  annotation (Line(points={{42,-20},{140,-20},{140,
          -40},{210,-40}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-200,-120},{200,120}})),
      defaultComponentName="rotTwo",
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Line(points={{-40,60},{0,60},{0,-60},{40,-60}}, color={128,128,128}),
        Ellipse(
          origin={-26.6667,38.6207},
          lineColor={128,128,128},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-53.3333,1.37927},{-13.3329,41.3792}}),
        Ellipse(
          origin={93.333,38.6207},
          lineColor={128,128,128},
          fillColor={28,108,200},
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
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Multiple\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Multiple</a>.
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
