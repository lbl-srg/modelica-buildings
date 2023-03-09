within Buildings.Controls.OBC.CDL.Logical;
block Proof "Verify two boolean inputs"
  parameter Real debounce(
    final quantity="Time",
    final unit="s")
    "Threshold time that the input must remain unchanged before it is considered valid";
  parameter Real delay(
    final quantity="Time",
    final unit="s")
    "Delay between the time when the u2 changes and the time when the u1 changes";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1
    "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-180,70},{-140,110}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u2
    "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-180,-50},{-140,-10}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1
    "True: u2 is true and u1 is false"
    annotation (Placement(transformation(extent={{140,70},{180,110}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y2
    "True: u2 is false and u1 is true"
    annotation (Placement(transformation(extent={{140,-110},{180,-70}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=debounce)
    "Delay a rising edge, to check if the true input is valid"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=debounce)
    "Delay a rising edge, to check if the false input is valid"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=debounce)
    "Delay a rising edge, to check if the false input is valid"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel3(
    final delayTime=debounce)
    "Delay a rising edge, to check if the true input is valid"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Logical.And botTru
    "Check if both valid inputs are true"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Buildings.Controls.OBC.CDL.Logical.And botFal
    "Check if both valid inputs are false"
    annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4 "Logical not"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Buildings.Controls.OBC.CDL.Logical.And falTru
    "Check if the valid u2 is true and the valid u1 is false"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delChe(
    final delayTime=delay)
    "Delay the difference check"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Logical.And truFal
    "Check if the valid u2 is false and the valid u1 is true"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delChe1(
    final delayTime=delay) "Delay the difference check"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Not not5 "Logical not"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));

equation
  connect(u1, truDel.u)
    annotation (Line(points={{-160,90},{-122,90}}, color={255,0,255}));
  connect(u1, not1.u) annotation (Line(points={{-160,90},{-130,90},{-130,50},{-122,
          50}}, color={255,0,255}));
  connect(not1.y, truDel1.u)
    annotation (Line(points={{-98,50},{-82,50}}, color={255,0,255}));
  connect(u2, truDel3.u)
    annotation (Line(points={{-160,-30},{-122,-30}}, color={255,0,255}));
  connect(u2, not2.u) annotation (Line(points={{-160,-30},{-130,-30},{-130,-90},
          {-122,-90}}, color={255,0,255}));
  connect(not2.y, truDel2.u)
    annotation (Line(points={{-98,-90},{-82,-90}}, color={255,0,255}));
  connect(truDel.y, botTru.u1)
    annotation (Line(points={{-98,90},{-22,90}}, color={255,0,255}));
  connect(truDel3.y, botTru.u2) annotation (Line(points={{-98,-30},{-40,-30},{-40,
          82},{-22,82}}, color={255,0,255}));
  connect(truDel1.y, botFal.u2) annotation (Line(points={{-58,50},{-50,50},{-50,
          -98},{-22,-98}}, color={255,0,255}));
  connect(truDel2.y, botFal.u1)
    annotation (Line(points={{-58,-90},{-22,-90}}, color={255,0,255}));
  connect(botTru.y, not3.u)
    annotation (Line(points={{2,90},{18,90}}, color={255,0,255}));
  connect(falTru.y, delChe.u)
    annotation (Line(points={{82,90},{98,90}}, color={255,0,255}));
  connect(delChe.y, y1)
    annotation (Line(points={{122,90},{160,90}}, color={255,0,255}));
  connect(not3.y, falTru.u1)
    annotation (Line(points={{42,90},{58,90}}, color={255,0,255}));
  connect(botFal.y, not4.u)
    annotation (Line(points={{2,-90},{18,-90}}, color={255,0,255}));
  connect(not4.y, truFal.u1)
    annotation (Line(points={{42,-90},{58,-90}}, color={255,0,255}));
  connect(truFal.y, delChe1.u)
    annotation (Line(points={{82,-90},{98,-90}}, color={255,0,255}));
  connect(delChe1.y, y2)
    annotation (Line(points={{122,-90},{160,-90}}, color={255,0,255}));
  connect(truDel3.y, falTru.u2) annotation (Line(points={{-98,-30},{50,-30},{50,
          82},{58,82}}, color={255,0,255}));
  connect(truDel3.y, not5.u) annotation (Line(points={{-98,-30},{-40,-30},{-40,-50},
          {-22,-50}}, color={255,0,255}));
  connect(not5.y, truFal.u2) annotation (Line(points={{2,-50},{52,-50},{52,-98},
          {58,-98}}, color={255,0,255}));

annotation (defaultComponentName="pro",
  Diagram(coordinateSystem(extent={{-140,-120},{140,120}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Ellipse(
          extent={{-73,67},{-87,53}},
          lineColor=DynamicSelect({235,235,235}, if u1 then {0,255,0} else {235,
              235,235}),
          fillColor=DynamicSelect({235,235,235}, if u1 then {0,255,0} else {235,
              235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-73,-53},{-87,-67}},
          lineColor=DynamicSelect({235,235,235}, if u2 then {0,255,0} else {235,
              235,235}),
          fillColor=DynamicSelect({235,235,235}, if u2 then {0,255,0} else {235,
              235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{73,67},{87,53}},
          lineColor=DynamicSelect({235,235,235}, if y1 then {0,255,0} else {235,
              235,235}),
          fillColor=DynamicSelect({235,235,235}, if y1 then {0,255,0} else {235,
              235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{73,-53},{87,-67}},
          lineColor=DynamicSelect({235,235,235}, if y2 then {0,255,0} else {235,
              235,235}),
          fillColor=DynamicSelect({235,235,235}, if y2 then {0,255,0} else {235,
              235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name")}));
end Proof;
