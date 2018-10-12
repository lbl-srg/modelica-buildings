within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
block testIteration "Defines lead-lag or lead-standby equipment rotation"

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

  CDL.Continuous.Add add2[3](
    k1=1,
    k2=1,
    u1(start=0, fixed=false),
    y(start={3,2,1}, fixed=false))
    annotation (Placement(transformation(extent={{-30,-20},{-10,0}})));
  CDL.Logical.Edge edg[3]
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  CDL.Discrete.TriggeredSampler triSam[3]
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  CDL.Logical.Sources.Pulse booPul[3](width=fill(0.8, 3), period=fill(2, 3))
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  CDL.Discrete.ZeroOrderHold zerOrdHol[3](samplePeriod=1) "Zero order hold"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  CDL.Continuous.Sources.Constant con1[3](k=fill(1, 3))
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  CDL.Continuous.Modulo mod[3]
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  CDL.Continuous.Sources.Constant con2[3](k=fill(3, 3))
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  CDL.Continuous.LessThreshold lesThr[3](threshold=0.5)
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  CDL.Continuous.Add add1[3](
    k1=1,
    k2=1,
    u1(start=0, fixed=false),
    y(start={3,2,1}, fixed=false))
    annotation (Placement(transformation(extent={{-2,-44},{18,-24}})));
  CDL.Continuous.Sources.Constant con3[3](k={2,1,0})
    annotation (Placement(transformation(extent={{-38,-70},{-18,-50}})));
equation
  connect(edg.y, triSam.trigger) annotation (Line(points={{-79,-70},{-70,-70},{
          -70,-41.8}}, color={255,0,255}));
  connect(triSam.y, add2.u2) annotation (Line(points={{-59,-30},{-40,-30},{-40,
          -16},{-32,-16}}, color={0,0,127}));
  connect(edg.u, booPul.y)
    annotation (Line(points={{-102,-70},{-119,-70}}, color={255,0,255}));
  connect(add2.y, zerOrdHol.u) annotation (Line(points={{-9,-10},{0,-10},{0,20},
          {18,20}}, color={0,0,127}));
  connect(zerOrdHol.y, triSam.u) annotation (Line(points={{41,20},{52,20},{52,
          40},{-100,40},{-100,-30},{-82,-30}}, color={0,0,127}));
  connect(add2.u1, con1.y) annotation (Line(points={{-32,-4},{-46,-4},{-46,10},
          {-59,10}}, color={0,0,127}));
  connect(con2.y, mod.u2) annotation (Line(points={{21,-70},{28,-70},{28,-56},{
          38,-56}}, color={0,0,127}));
  connect(mod.y, lesThr.u) annotation (Line(points={{61,-50},{69.5,-50},{69.5,
          -50},{78,-50}},      color={0,0,127}));
  connect(add2.y, add1.u1) annotation (Line(points={{-9,-10},{-6,-10},{-6,-28},
          {-4,-28}}, color={0,0,127}));
  connect(add1.u2, con3.y) annotation (Line(points={{-4,-40},{-10,-40},{-10,-60},
          {-17,-60}}, color={0,0,127}));
  connect(add1.y, mod.u1) annotation (Line(points={{19,-34},{28,-34},{28,-44},{
          38,-44}}, color={0,0,127}));
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
end testIteration;
