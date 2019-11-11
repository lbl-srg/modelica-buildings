within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences;
block RuntimeCounter
  "Equipment rotation signal based on runtime and status"

  parameter Modelica.SIunits.Time stagingRuntime(
    final displayUnit = "h") = 864000
    "Staging runtime for each device";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDevStaSet[nDev] "Device status setpoint"
    annotation (Placement(transformation(extent={{-240,-20},{-200,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDevRolSet[nDev]
    "Device role: true = lead, false = lag or standby"
    annotation (Placement(transformation(extent={{200,50},{220,70}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPreDevRolSet[nDev]
    "Device role in the previous step: true = lead, false = lag or standby"
    annotation (Placement(transformation(extent={{200,-50},{220,-30}}),
        iconTransformation(extent={{100,-70},{120,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr[nDev](
    final threshold=stagingRuntimes) "Staging runtime hysteresis"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim[nDev](
    final reset={false,false})
    "Measures time spent loaded at the current role (lead or lag)"
    annotation (Placement(transformation(extent={{-130,30},{-110,50}})));

protected
  final parameter Integer nDev = 2
    "Total number of devices, such as chillers, isolation valves, CW pumps, or CHW pumps";

  final parameter Boolean initRoles[nDev] = {true, false}
    "Initial roles: true = lead, false = lag/standby"
    annotation (Evaluate=true,Dialog(tab="Advanced", group="Initiation"));

  final parameter Modelica.SIunits.Time stagingRuntimes[nDev] = fill(stagingRuntime, nDev)
    "Staging runtimes array";

  Buildings.Controls.OBC.CDL.Logical.And3 and3[nDev] "Logical and"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nu=nDev) "Array input or"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));

  Buildings.Controls.OBC.CDL.Logical.Not not0[nDev] "Logical not"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi[nDev] "Switch"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=nDev) "Signal replicator"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre[nDev](
    final pre_u_start=initRoles) "Previous timestep"
    annotation (Placement(transformation(extent={{140,-60},{160,-40}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1[nDev] "Falling Edge"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));

  Buildings.Controls.OBC.CDL.Logical.MultiAnd allOn(
    final nu=nDev) "Outputs true if all devices are commanded enable"
    annotation (Placement(transformation(extent={{-130,0},{-110,20}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr anyOn(
    final nu=nDev) "Checks if any device is commanded enable"
    annotation (Placement(transformation(extent={{-170,-40},{-150,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Not allOff "Returns true if all devices are commanded disable"
    annotation (Placement(transformation(extent={{-130,-40},{-110,-20}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(
    final nout=nDev) "Booolean replicator"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Controls.OBC.CDL.Logical.Or equSig
    "Outputs true if either all devices are commanded enable or all devices are commanded disable"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));

equation
  connect(greEquThr.y,and3. u1) annotation (Line(points={{-38,40},{-20,40},{-20,
          8},{-12,8}},   color={255,0,255}));
  connect(logSwi.u1,not0. y) annotation (Line(points={{98,-22},{70,-22},{70,-40},
          {52,-40}}, color={255,0,255}));
  connect(mulOr.u[1:2],and3. y)
    annotation (Line(points={{28,0},{12,0}},  color={255,0,255}));
  connect(mulOr.y,booRep. u) annotation (Line(points={{52,0},{58,0}},
    color={255,0,255}));
  connect(logSwi.u2,booRep. y) annotation (Line(points={{98,-30},{90,-30},{90,0},
          {82,0}}, color={255,0,255}));
  connect(logSwi.y,pre. u) annotation (Line(points={{122,-30},{130,-30},{130,-50},
          {138,-50}}, color={255,0,255}));
  connect(pre.y,not0. u) annotation (Line(points={{162,-50},{180,-50},{180,-70},
          {20,-70},{20,-40},{28,-40}}, color={255,0,255}));
  connect(pre.y,logSwi. u3) annotation (Line(points={{162,-50},{170,-50},{170,-64},
          {90,-64},{90,-38},{98,-38}}, color={255,0,255}));
  connect(tim.u0,falEdg1. y) annotation (Line(points={{-132,32},{-140,32},{-140,
          70},{60,70},{60,40},{52,40}}, color={255,0,255}));
  connect(pre.y,and3. u3) annotation (Line(points={{162,-50},{190,-50},{190,-76},
          {-20,-76},{-20,-8},{-12,-8}}, color={255,0,255}));
  connect(tim.y,greEquThr. u)
    annotation (Line(points={{-108,40},{-62,40}},color={0,0,127}));
  connect(pre.y,falEdg1. u)
    annotation (Line(points={{162,-50},{190,-50},{190,20},{20,20},{20,40},{28,
          40}}, color={255,0,255}));
  connect(logSwi.y, yDevRolSet) annotation (Line(points={{122,-30},{160,-30},{
          160,60},{210,60}},
                           color={255,0,255}));
  connect(booRep1.y, and3.u2)
    annotation (Line(points={{-38,0},{-12,0}}, color={255,0,255}));
  connect(anyOn.y, allOff.u)
    annotation (Line(points={{-148,-30},{-132,-30}}, color={255,0,255}));
  connect(booRep1.u, equSig.y)
    annotation (Line(points={{-62,0},{-68,0}}, color={255,0,255}));
  connect(allOff.y, equSig.u2) annotation (Line(points={{-108,-30},{-100,-30},{-100,
          -8},{-92,-8}}, color={255,0,255}));
  connect(allOn.y, equSig.u1) annotation (Line(points={{-108,10},{-100,10},{-100,
          0},{-92,0}}, color={255,0,255}));
  connect(uDevStaSet, tim.u) annotation (Line(points={{-220,0},{-180,0},{-180,40},
          {-132,40}}, color={255,0,255}));
  connect(uDevStaSet, allOn.u[1:2]) annotation (Line(points={{-220,0},{-180,0},{
          -180,10},{-132,10},{-132,10}},  color={255,0,255}));
  connect(uDevStaSet, anyOn.u[1:2]) annotation (Line(points={{-220,0},{-190,0},{
          -190,-30},{-172,-30},{-172,-30}},   color={255,0,255}));
  connect(pre.y, yPreDevRolSet) annotation (Line(points={{162,-50},{190,-50},{190,
          -40},{210,-40}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-200,-120},{200,120}})),
      defaultComponentName="runCou",
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
      Line(points={{-66,-70},{82,-70}},
        color={192,192,192}),
      Line(points={{-58,68},{-58,-80}},
        color={192,192,192}),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{90.0,-70.0},{68.0,-62.0},{68.0,-78.0},{90.0,-70.0}}),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{-58,90},{-66,68},{-50,68},{-58,90}}),
      Line(points={{-56,-70},{-38,-70},{-38,-26},{40,-26},{40,-70},{68,-70}},
        color={255,0,255}),
      Line(points={{-58,0},{-40,0},{40,90},{40,0},{68,0}},
        color={0,0,127})}),
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
end RuntimeCounter;
