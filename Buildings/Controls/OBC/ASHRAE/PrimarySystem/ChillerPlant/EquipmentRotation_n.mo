within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
block EquipmentRotation_n
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
  CDL.Logical.MultiOr mulOr(nu=2)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
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
  CDL.Continuous.Add add2[num](
    k1=1,
    k2=1)
    annotation (Placement(transformation(extent={{50,-160},{70,-140}})));
  CDL.Logical.Edge edg[num]
    annotation (Placement(transformation(extent={{-20,-220},{0,-200}})));
  CDL.Discrete.TriggeredSampler triSam[num]
    annotation (Placement(transformation(extent={{0,-180},{20,-160}})));
  CDL.Discrete.ZeroOrderHold zerOrdHol[num](samplePeriod=1) "Zero order hold"
    annotation (Placement(transformation(extent={{100,-130},{120,-110}})));
  CDL.Continuous.Sources.Constant con1[num](k=fill(1, num))
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));
  CDL.Continuous.Modulo mod[num]
    annotation (Placement(transformation(extent={{120,-200},{140,-180}})));
  CDL.Continuous.Sources.Constant con2[num](k=fill(num, num))
    annotation (Placement(transformation(extent={{80,-220},{100,-200}})));
  CDL.Continuous.LessThreshold lesThr[num](threshold=fill(0.5, num))
    annotation (Placement(transformation(extent={{160,-200},{180,-180}})));
  CDL.Continuous.Add add1[num](
    k1=1,
    k2=1,
    y(start=linspace(
          num,
          1,
          num), fixed=false))
    annotation (Placement(transformation(extent={{78,-184},{98,-164}})));
  CDL.Continuous.Sources.Constant con3[num](k=linspace(
        num - 1,
        0,
        num))
    annotation (Placement(transformation(extent={{42,-210},{62,-190}})));
equation
  connect(uDevSta, tim.u) annotation (Line(points={{-200,0},{-160,0},{-160,30},{
          -122,30}}, color={255,0,255}));
  connect(greEquThr.y, and3.u1) annotation (Line(points={{-59,30},{-30,30},{-30,
          8},{-22,8}}, color={255,0,255}));
  connect(mulOr.y, booRep.u) annotation (Line(points={{41.7,0},{58,0}},
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
  connect(edg.y, triSam.trigger) annotation (Line(points={{1,-210},{10,-210},{10,
          -181.8}}, color={255,0,255}));
  connect(triSam.y, add2.u2) annotation (Line(points={{21,-170},{40,-170},{40,-156},
          {48,-156}}, color={0,0,127}));
  connect(add2.y, zerOrdHol.u) annotation (Line(points={{71,-150},{80,-150},{80,
          -120},{98,-120}}, color={0,0,127}));
  connect(zerOrdHol.y, triSam.u) annotation (Line(points={{121,-120},{132,-120},
          {132,-100},{-20,-100},{-20,-170},{-2,-170}}, color={0,0,127}));
  connect(add2.u1, con1.y) annotation (Line(points={{48,-144},{34,-144},{34,-130},
          {21,-130}}, color={0,0,127}));
  connect(con2.y, mod.u2) annotation (Line(points={{101,-210},{108,-210},{108,-196},
          {118,-196}}, color={0,0,127}));
  connect(mod.y, lesThr.u) annotation (Line(points={{141,-189.8},{149.5,-189.8},
          {149.5,-190},{158,-190}}, color={0,0,127}));
  connect(add2.y, add1.u1) annotation (Line(points={{71,-150},{74,-150},{74,-168},
          {76,-168}}, color={0,0,127}));
  connect(add1.u2, con3.y) annotation (Line(points={{76,-180},{70,-180},{70,-200},
          {63,-200}}, color={0,0,127}));
  connect(add1.y, mod.u1) annotation (Line(points={{99,-174},{108,-174},{108,-184},
          {118,-184}}, color={0,0,127}));
  connect(booRep.y, edg.u) annotation (Line(points={{81,0},{92,0},{92,-82},{-68,
          -82},{-68,-210},{-22,-210}}, color={255,0,255}));
  connect(lesThr.y, pre.u) annotation (Line(points={{181,-190},{182,-190},{182,-82},
          {110,-82},{110,-50},{138,-50}}, color={255,0,255}));
  connect(lesThr.y, yDevRol) annotation (Line(points={{181,-190},{210,-190},{210,
          -22},{128,-22},{128,0},{190,0}}, color={255,0,255}));
  connect(and3.y, mulOr.u[1:num]) annotation (Line(points={{1,0},{10,0},{10,0},
          {18,0}},    color={255,0,255}));
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
end EquipmentRotation_n;
