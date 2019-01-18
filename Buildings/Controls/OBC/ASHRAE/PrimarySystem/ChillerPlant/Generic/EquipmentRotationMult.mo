within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic;
block EquipmentRotationMult
  "Defines lead-lag or lead-standby equipment rotation for any number of devices or groups of devices"

  parameter Integer num = 3
    "Total number of devices, such as chillers, isolation valves, CW pumps, or CHW pumps";

  parameter Real stagingRuntime(unit = "s") = 240 * 60 * 60
    "Staging runtime";

  parameter Boolean initRoles[num] = initialization[1:num]
    "Sets initial roles: true = lead, false = lag or standby";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaSta
    "Lead device status" annotation (Placement(transformation(extent={{-260,-20},
            {-220,20}}), iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDevRol[num]
    "Device role: true = lead, false = lag or standby"
    annotation (Placement(transformation(extent={{240,-10},{260,10}}),
        iconTransformation(extent={{100,-70},{120,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr[num](
    final threshold=stagingRuntime)
    "Stagin runtime hysteresis"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim[num](
    final reset=false)
    "Measures time spent loaded at the current role (lead or lag)"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));

  CDL.Routing.BooleanReplicator repLag(nout=num) "Replicates lag signal"
    annotation (Placement(transformation(extent={{-210,-110},{-190,-90}})));
  CDL.Routing.BooleanReplicator repLead(nout=num) "Replicates lead signal"
    annotation (Placement(transformation(extent={{-212,-10},{-192,10}})));
  CDL.Interfaces.BooleanInput uLagSta "Lag device status" annotation (Placement(
        transformation(extent={{-260,-120},{-220,-80}}), iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  CDL.Interfaces.BooleanOutput yDevSta[num]
    "Device status (index represents the physical device)" annotation (
      Placement(transformation(extent={{240,-50},{260,-30}}),
        iconTransformation(extent={{100,50},{120,70}})));
protected
  final parameter Boolean initialization[10] = {true, false, false, false, false, false, false, false, false, false}
    "Initiates device mapped to the first index with the lead role and all other to lag";

  Buildings.Controls.OBC.CDL.Logical.And3 and3[num] "Logical and"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(final nu=num) "Logical or with an array input"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(final nout=num)
    "Converts scalar input into an array output"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre[num](final pre_u_start=initRoles)
    "Returns previous timestep value to avoid algebraic loops"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1[num] "Falling edge"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1[num]
    "Logical not"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2[num](
    final k1=fill(1, num),
    final k2=fill(1, num))
    "Adder"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg[num]
    "Logical edge"
    annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam[num]
    "Sample trigger"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));

  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[num](
    final samplePeriod=fill(1,num)) "Zero order hold"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1[num](
    final k=fill(1, num)) "Constant"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Modulo mod[num]
    "Modulo"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2[num](
    final k=fill(num, num)) "Constant"
    annotation (Placement(transformation(extent={{60,-140},{80,-120}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr[num](
    final threshold=fill(0.5, num))
    "Identifies zero outputs of the modulo operation"
    annotation (Placement(transformation(extent={{140,-120},{160,-100}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add1[num](
    final k1=fill(1, num),
    final k2=fill(1, num))
    "Logical and"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3[num](
    final k=linspace(num - 1, 0, num)) "Constant"
    annotation (Placement(transformation(extent={{20,-120},{40,-100}})));

  CDL.Logical.LogicalSwitch                        logSwi[num]
    annotation (Placement(transformation(extent={{-180,-40},{-160,-20}})));
equation
  connect(greEquThr.y, and3.u1) annotation (Line(points={{-79,60},{-50,60},{-50,
          38},{-42,38}},
                       color={255,0,255}));
  connect(mulOr.y, booRep.u) annotation (Line(points={{21.7,30},{38,30}},
                    color={255,0,255}));
  connect(not1.y,and3. u2)
    annotation (Line(points={{-119,20},{-80,20},{-80,30},{-42,30}},
                                                 color={255,0,255}));
  connect(tim.u0, falEdg1.y) annotation (Line(points={{-142,52},{-160,52},{-160,
          100},{20,100},{20,70},{1,70}},color={255,0,255}));
  connect(pre.y, and3.u3) annotation (Line(points={{141,30},{150,30},{150,10},{-50,
          10},{-50,22},{-42,22}},              color={255,0,255}));
  connect(tim.y, greEquThr.u)
    annotation (Line(points={{-119,60},{-102,60}},
                                                 color={0,0,127}));
  connect(pre.y, falEdg1.u) annotation (Line(points={{141,30},{150,30},{150,90},
          {-40,90},{-40,70},{-22,70}},    color={255,0,255}));
  connect(edg.y, triSam.trigger) annotation (Line(points={{-39,-130},{-30,-130},
          {-30,-101.8}},
                    color={255,0,255}));
  connect(triSam.y, add2.u2) annotation (Line(points={{-19,-90},{0,-90},{0,-76},
          {18,-76}},  color={0,0,127}));
  connect(add2.y, zerOrdHol.u) annotation (Line(points={{41,-70},{60,-70},{60,-50},
          {78,-50}},        color={0,0,127}));
  connect(zerOrdHol.y, triSam.u) annotation (Line(points={{101,-50},{112,-50},{112,
          -20},{-60,-20},{-60,-90},{-42,-90}},         color={0,0,127}));
  connect(add2.u1, con1.y) annotation (Line(points={{18,-64},{0,-64},{0,-50},{-19,
          -50}},      color={0,0,127}));
  connect(con2.y, mod.u2) annotation (Line(points={{81,-130},{88,-130},{88,-116},
          {98,-116}},  color={0,0,127}));
  connect(mod.y, lesThr.u) annotation (Line(points={{121,-110},{129.5,-110},{129.5,
          -110},{138,-110}},        color={0,0,127}));
  connect(add2.y, add1.u1) annotation (Line(points={{41,-70},{50,-70},{50,-84},{
          58,-84}},   color={0,0,127}));
  connect(add1.u2, con3.y) annotation (Line(points={{58,-96},{50,-96},{50,-110},
          {41,-110}}, color={0,0,127}));
  connect(add1.y, mod.u1) annotation (Line(points={{81,-90},{88,-90},{88,-104},{
          98,-104}},   color={0,0,127}));
  connect(booRep.y, edg.u) annotation (Line(points={{61,30},{72,30},{72,0},{-80,
          0},{-80,-130},{-62,-130}},   color={255,0,255}));
  connect(lesThr.y, pre.u) annotation (Line(points={{161,-110},{180,-110},{180,0},
          {100,0},{100,30},{118,30}},     color={255,0,255}));
  connect(lesThr.y, yDevRol) annotation (Line(points={{161,-110},{200,-110},{200,
          0},{250,0}},                     color={255,0,255}));
  connect(and3.y, mulOr.u[1:num]) annotation (Line(points={{-19,30},{-2,30}},
                      color={255,0,255}));
  connect(logSwi.y, tim.u) annotation (Line(points={{-159,-30},{-150,-30},{-150,
          60},{-142,60}}, color={255,0,255}));
  connect(logSwi.y, not1.u) annotation (Line(points={{-159,-30},{-150,-30},{
          -150,20},{-142,20}}, color={255,0,255}));
  connect(uLagSta, repLag.u)
    annotation (Line(points={{-240,-100},{-212,-100}}, color={255,0,255}));
  connect(uLeaSta, repLead.u)
    annotation (Line(points={{-240,0},{-214,0}}, color={255,0,255}));
  connect(logSwi.u1, repLead.y) annotation (Line(points={{-182,-22},{-184,-22},
          {-184,0},{-191,0}}, color={255,0,255}));
  connect(logSwi.u3, repLag.y) annotation (Line(points={{-182,-38},{-186,-38},{
          -186,-100},{-189,-100}}, color={255,0,255}));
  connect(pre.y, logSwi.u2) annotation (Line(points={{141,30},{164,30},{164,124},
          {-190,124},{-190,-30},{-182,-30}}, color={255,0,255}));
  connect(logSwi.y, yDevSta) annotation (Line(points={{-159,-30},{-70,-30},{-70,
          -10},{220,-10},{220,-40},{250,-40}},
                                             color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-220,-160},{240,160}})),
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
Chapter 7, App B, 1.01, A.4.  The input vector <code>uDevRol<\code> indicates the lead/lag (or lead/standby) status
of the devices. Default initial lead role is assigned to the device associated
with the first index in the input vector. The block measures the <code>stagingRuntime<\code> 
for each device and switches the lead role to the next higher index
as its <code>stagingRuntime<\code> expires. It can be used for any number of devices <code>num<\code>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 20, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>

</html>"));
end EquipmentRotationMult;
