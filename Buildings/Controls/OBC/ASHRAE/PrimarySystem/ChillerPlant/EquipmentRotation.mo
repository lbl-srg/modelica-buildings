within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
block EquipmentRotation
  "Defines lead-lag or lead-standby equipment rotation"

  parameter Integer num = 2
    "Total number of chillers, the same number applied to isolation valves, CW pumps, CHW pumps";

  parameter Real small(unit = "s") = 1
    "Hysteresis detla";

  parameter Real stagingRuntime(unit = "s") = 240 * 60 * 60
    "Staging runtime";

  parameter Boolean initRoles[num] = {true, false}
    "Sets initial roles: true = lead, false = lag. There should be only one lead device";

  parameter Real overlap(unit = "s") = 5 * 60
    "Time period during which the previous lead stays on";

  CDL.Interfaces.BooleanInput uDevSta[num]
    "Current devices operation status"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  CDL.Logical.Timer tim[num](reset=false)
    "Measures time spent loaded at the current role (lead or lag)"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));

  CDL.Continuous.GreaterEqualThreshold
                            greEquThr
                               [num](threshold=stagingRuntime)
    "Stagin runtime hysteresis"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  CDL.Logical.And3 and3
                      [num]
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  CDL.Logical.MultiOr mulOr(nu=num)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  CDL.Logical.Not fixme_for_n[num]
    "Fixme: For more than 2 devices this should be replaced by an implementation which moves the lead chiller to the first higher index"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  CDL.Logical.LogicalSwitch logSwi[num]
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  CDL.Routing.BooleanReplicator booRep(nout=num)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  CDL.Interfaces.BooleanOutput yDevRol[num]
    "Device role (true - lead, false - lag)"
    annotation (Placement(transformation(extent={{180,-10},{200,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  CDL.Logical.Pre pre[num](pre_u_start=initRoles)
    annotation (Placement(transformation(extent={{140,-60},{160,-40}})));

  CDL.Logical.FallingEdge
                     falEdg1
                         [num]
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  CDL.Logical.Not not1[num]
    "Fixme: For more than 2 devices this should be replaced by an implementation which moves the lead chiller to the first higher index"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
equation
  connect(uDevSta, tim.u) annotation (Line(points={{-200,0},{-160,0},{-160,30},{
          -122,30}}, color={255,0,255}));
  connect(greEquThr.y, and3.u1) annotation (Line(points={{-59,30},{-30,30},{-30,
          8},{-22,8}}, color={255,0,255}));
  connect(logSwi.u1, fixme_for_n.y) annotation (Line(points={{98,-22},{70,-22},
          {70,-50},{41,-50}},color={255,0,255}));
  connect(mulOr.u[1:2],and3. y)
    annotation (Line(points={{18,0},{18,0},{1,0}},    color={255,0,255}));
  connect(mulOr.y, booRep.u) annotation (Line(points={{41.7,0},{58,0}},
                    color={255,0,255}));
  connect(logSwi.u2, booRep.y) annotation (Line(points={{98,-30},{90,-30},{90,0},
          {81,0}},   color={255,0,255}));
  connect(logSwi.y, pre.u) annotation (Line(points={{121,-30},{130,-30},{130,
          -50},{138,-50}},
                      color={255,0,255}));
  connect(pre.y, fixme_for_n.u) annotation (Line(points={{161,-50},{170,-50},{
          170,-70},{10,-70},{10,-50},{18,-50}},
                                            color={255,0,255}));
  connect(pre.y, logSwi.u3) annotation (Line(points={{161,-50},{170,-50},{170,
          -70},{90,-70},{90,-38},{98,-38}},
                                        color={255,0,255}));
  connect(uDevSta, not1.u) annotation (Line(points={{-200,0},{-160,0},{-160,-10},
          {-122,-10}},color={255,0,255}));
  connect(not1.y,and3. u2)
    annotation (Line(points={{-99,-10},{-60,-10},{-60,0},{-22,0}},
                                                 color={255,0,255}));
  connect(tim.u0, falEdg1.y) annotation (Line(points={{-122,22},{-140,22},{-140,
          60},{40,60},{40,40},{21,40}}, color={255,0,255}));
  connect(pre.y, and3.u3) annotation (Line(points={{161,-50},{170,-50},{170,-70},
          {-30,-70},{-30,-8},{-22,-8}},        color={255,0,255}));
  connect(tim.y, greEquThr.u)
    annotation (Line(points={{-99,30},{-82,30}}, color={0,0,127}));
  connect(pre.y, falEdg1.u) annotation (Line(points={{161,-50},{170,-50},{170,
          20},{-20,20},{-20,40},{-2,40}}, color={255,0,255}));
  connect(logSwi.y, yDevRol) annotation (Line(points={{121,-30},{150,-30},{150,
          0},{190,0}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-180,-120},{180,120}})),
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
fixme
</p>
</html>", revisions="<html>
<ul>
<li>
, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>

</html>"));
end EquipmentRotation;
