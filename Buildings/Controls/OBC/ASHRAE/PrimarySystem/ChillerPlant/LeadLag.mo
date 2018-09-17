within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
block LeadLag "Defines lead-lag equipment rotation"

  parameter Integer num = 2
    "Total number of chillers, the same number applied to isolation valves, CW pumps, CHW pumps";

  parameter Real overlap(unit = "s") = 15
    "Staging runtime hysteresis detla";

  parameter Real stagingRuntime(unit = "s") = 240 * 60 * 60
    "Staging runtime";

  parameter Boolean initRoles[num] = {true, false}
    "Sets initial roles: true = lead, false = lag. There should be only one lead device";

  CDL.Interfaces.BooleanInput uDevSta[num]
    "Current devices operation status"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  CDL.Logical.Timer tim[num]
    "Measures time spent loaded at the current role (lead or lag)"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));

  CDL.Continuous.Hysteresis hys[num](
    uLow=stagingRuntime,
    uHigh=stagingRuntime + overlap)
    "Stagin runtime hysteresis"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  CDL.Logical.Change cha[num]
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  CDL.Logical.And and2[num]
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  CDL.Logical.MultiOr mulOr(nu=2)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  CDL.Logical.Not not1[num]
    "Fixme: For more than 2 devices this should be replaced by an implementation which moves the lead chiller to the first higher index"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  CDL.Logical.LogicalSwitch logSwi[num]
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  CDL.Routing.BooleanReplicator booRep(nout=num)
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  CDL.Interfaces.BooleanOutput DevRol[num] "Device role (1 - lead, 0 - lag)"
    annotation (Placement(transformation(extent={{180,-10},{200,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  CDL.Logical.Pre pre[num](pre_u_start=initRoles)
    annotation (Placement(transformation(extent={{140,-100},{160,-80}})));

equation
  connect(uDevSta, tim.u) annotation (Line(points={{-200,0},{-160,0},{-160,30},{
          -122,30}}, color={255,0,255}));
  connect(tim.y, hys.u)
    annotation (Line(points={{-99,30},{-82,30}}, color={0,0,127}));
  connect(hys.y, tim.u0) annotation (Line(points={{-59,30},{-50,30},{-50,10},{-130,
          10},{-130,22},{-122,22}}, color={255,0,255}));
  connect(uDevSta, cha.u) annotation (Line(points={{-200,0},{-160,0},{-160,-30},
          {-122,-30}}, color={255,0,255}));
  connect(hys.y, and2.u1) annotation (Line(points={{-59,30},{-30,30},{-30,0},{-22,
          0}}, color={255,0,255}));
  connect(cha.y, and2.u2) annotation (Line(points={{-99,-30},{-30,-30},{-30,-8},
          {-22,-8}}, color={255,0,255}));
  connect(logSwi.u1, not1.y) annotation (Line(points={{98,-42},{70,-42},{70,-50},
          {41,-50}}, color={255,0,255}));
  connect(mulOr.u[1:2], and2.y)
    annotation (Line(points={{18,-3.5},{18,0},{1,0}}, color={255,0,255}));
  connect(mulOr.y, booRep.u) annotation (Line(points={{41.7,0},{52,0},{52,-20},{
          58,-20}}, color={255,0,255}));
  connect(logSwi.u2, booRep.y) annotation (Line(points={{98,-50},{90,-50},{90,-20},
          {81,-20}}, color={255,0,255}));
  connect(logSwi.y, DevRol) annotation (Line(points={{121,-50},{160,-50},{160,0},
          {190,0}}, color={255,0,255}));
  connect(logSwi.y, pre.u) annotation (Line(points={{121,-50},{130,-50},{130,-90},
          {138,-90}}, color={255,0,255}));
  connect(pre.y, not1.u) annotation (Line(points={{161,-90},{170,-90},{170,-110},
          {10,-110},{10,-50},{18,-50}}, color={255,0,255}));
  connect(pre.y, logSwi.u3) annotation (Line(points={{161,-90},{170,-90},{170,-110},
          {88,-110},{88,-58},{98,-58}}, color={255,0,255}));
  annotation (    defaultComponentName="leaLag",
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

</html>"),
    Diagram(coordinateSystem(extent={{-180,-120},{180,120}})));
end LeadLag;
