within Buildings.Controls.OBC.CDL.Logical;
block Proof1 "Verify two boolean inputs"
  parameter Real debounce(
    final quantity="Time",
    final unit="s")
    "Threshold time that the input must remain unchanged before it is considered valid";
  parameter Real delay(
    final quantity="Time",
    final unit="s")
    "Delay between the time when the u2 changes and the time when the u1 changes";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uMea "Current status"
    annotation (Placement(transformation(extent={{-180,110},{-140,150}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCom "Commanded status"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1
    "True: commanded status is true and current status is false"
    annotation (Placement(transformation(extent={{140,110},{180,150}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y2
    "True: commanded status is false and current status is true"
    annotation (Placement(transformation(extent={{200,-150},{240,-110}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=debounce)
    "Delay a rising edge, to check if the true input is valid"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=debounce)
    "Delay a rising edge, to check if the false input is valid"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=debounce)
    "Delay a rising edge, to check if the false input is valid"
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel3(
    final delayTime=debounce)
    "Delay a rising edge, to check if the true input is valid"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Logical.And botTru
    "Check if both valid inputs are true"
    annotation (Placement(transformation(extent={{-20,120},{0,140}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{20,120},{40,140}})));
  Buildings.Controls.OBC.CDL.Logical.Not notBotFal "Not both false status"
    annotation (Placement(transformation(extent={{80,-140},{100,-120}})));
  Buildings.Controls.OBC.CDL.Logical.And falTru
    "Check if the valid commanded status is true and the valid measured status is false"
    annotation (Placement(transformation(extent={{100,120},{120,140}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delChe(
    final delayTime=delay)
    "Delay the difference check"
    annotation (Placement(transformation(extent={{60,120},{80,140}})));
  Buildings.Controls.OBC.CDL.Logical.And truFal
    "Check if the valid commanded status is false and the valid measured status is true"
    annotation (Placement(transformation(extent={{160,-140},{180,-120}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delChe1(
    final delayTime=delay) "Delay the difference check"
    annotation (Placement(transformation(extent={{120,-140},{140,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Not not5 "Logical not"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));

  Conversions.BooleanToInteger booToInt
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Integers.Equal equSta "Check if both status are the same"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Conversions.BooleanToInteger booToInt1
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{20,-140},{40,-120}})));
  And botFal "Both false status"
    annotation (Placement(transformation(extent={{120,70},{140,90}})));
  Switch valFal "Valid change from true to false"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Switch valFal1 "Valid change from true to false"
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));
  Sources.Constant con(k=true)
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
equation
  connect(uMea, truDel.u)
    annotation (Line(points={{-160,130},{-122,130}},
                                                   color={255,0,255}));
  connect(uMea, not1.u) annotation (Line(points={{-160,130},{-130,130},{-130,80},
          {-122,80}}, color={255,0,255}));
  connect(not1.y, truDel1.u)
    annotation (Line(points={{-98,80},{-82,80}}, color={255,0,255}));
  connect(uCom, truDel3.u)
    annotation (Line(points={{-160,-60},{-122,-60}}, color={255,0,255}));
  connect(uCom, not2.u) annotation (Line(points={{-160,-60},{-130,-60},{-130,
          -130},{-122,-130}},
                       color={255,0,255}));
  connect(not2.y, truDel2.u)
    annotation (Line(points={{-98,-130},{-82,-130}},
                                                   color={255,0,255}));
  connect(truDel.y, botTru.u1)
    annotation (Line(points={{-98,130},{-22,130}},
                                                 color={255,0,255}));
  connect(truDel3.y, botTru.u2) annotation (Line(points={{-98,-60},{-40,-60},{
          -40,122},{-22,122}},
                         color={255,0,255}));
  connect(botTru.y, not3.u)
    annotation (Line(points={{2,130},{18,130}},
                                              color={255,0,255}));
  connect(truDel3.y, not5.u) annotation (Line(points={{-98,-60},{-40,-60},{-40,
          -80},{-22,-80}},
                      color={255,0,255}));

  connect(not3.y, delChe.u)
    annotation (Line(points={{42,130},{58,130}}, color={255,0,255}));
  connect(delChe.y, falTru.u1)
    annotation (Line(points={{82,130},{98,130}}, color={255,0,255}));
  connect(truDel3.y, falTru.u2) annotation (Line(points={{-98,-60},{90,-60},{90,
          122},{98,122}}, color={255,0,255}));
  connect(falTru.y, y1)
    annotation (Line(points={{122,130},{160,130}}, color={255,0,255}));
  connect(notBotFal.y, delChe1.u)
    annotation (Line(points={{102,-130},{118,-130}}, color={255,0,255}));
  connect(delChe1.y, truFal.u1)
    annotation (Line(points={{142,-130},{158,-130}}, color={255,0,255}));
  connect(truFal.y, y2)
    annotation (Line(points={{182,-130},{220,-130}}, color={255,0,255}));
  connect(not5.y, truFal.u2) annotation (Line(points={{2,-80},{150,-80},{150,
          -138},{158,-138}}, color={255,0,255}));
  connect(booToInt.y, equSta.u1)
    annotation (Line(points={{42,80},{58,80}}, color={255,127,0}));
  connect(booToInt1.y, equSta.u2) annotation (Line(points={{42,-130},{50,-130},
          {50,72},{58,72}}, color={255,127,0}));
  connect(equSta.y, botFal.u1)
    annotation (Line(points={{82,80},{118,80}}, color={255,0,255}));
  connect(not5.y, botFal.u2) annotation (Line(points={{2,-80},{100,-80},{100,72},
          {118,72}}, color={255,0,255}));
  connect(truDel1.y, valFal.u2)
    annotation (Line(points={{-58,80},{-22,80}}, color={255,0,255}));
  connect(uMea, valFal.u1) annotation (Line(points={{-160,130},{-130,130},{-130,
          100},{-30,100},{-30,88},{-22,88}}, color={255,0,255}));
  connect(truDel2.y, valFal1.u2)
    annotation (Line(points={{-58,-130},{-22,-130}}, color={255,0,255}));
  connect(uCom, valFal1.u1) annotation (Line(points={{-160,-60},{-130,-60},{
          -130,-100},{-30,-100},{-30,-122},{-22,-122}}, color={255,0,255}));
  connect(valFal1.y, booToInt1.u)
    annotation (Line(points={{2,-130},{18,-130}}, color={255,0,255}));
  connect(con.y, valFal.u3) annotation (Line(points={{-98,40},{-50,40},{-50,72},
          {-22,72}}, color={255,0,255}));
  connect(con.y, valFal1.u3) annotation (Line(points={{-98,40},{-50,40},{-50,
          -138},{-22,-138}}, color={255,0,255}));
  connect(valFal.y, booToInt.u)
    annotation (Line(points={{2,80},{18,80}}, color={255,0,255}));
  connect(botFal.y, notBotFal.u) annotation (Line(points={{142,80},{150,80},{
          150,-40},{60,-40},{60,-130},{78,-130}}, color={255,0,255}));
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
end Proof1;
