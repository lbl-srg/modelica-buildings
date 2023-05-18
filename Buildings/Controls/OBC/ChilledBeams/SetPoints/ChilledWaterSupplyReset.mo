within Buildings.Controls.OBC.ChilledBeams.SetPoints;
block ChilledWaterSupplyReset
  "Sequence to generate static pressure setpoint for chilled water loop"

  parameter Real valPosLowCloReq(
    final unit="1",
    displayUnit="1") = 0.05
    "Lower limit for sending one request for chilled water supply"
    annotation(Dialog(group="Chilled water supply parameters"));

  parameter Real valPosLowOpeReq(
    final unit="1",
    displayUnit="1") = 0.1
    "Upper limit for sending one request for chilled water supply"
    annotation(Dialog(group="Chilled water supply parameters"));

  parameter Real valPosHigCloReq(
    final unit="1",
    displayUnit="1") = 0.45
    "Lower limit for sending two requests for chilled water supply"
    annotation(Dialog(group="Chilled water supply parameters"));

  parameter Real valPosHigOpeReq(
    final unit="1",
    displayUnit="1") = 0.5
    "Upper limit for sending two requests for chilled water supply"
    annotation(Dialog(group="Chilled water supply parameters"));

  parameter Real thrTimLowReq(
    final unit="s",
    displayUnit="s",
    final quantity="Duration") = 300
    "Threshold time for generating one chilled water supply request"
    annotation(Dialog(group="Chilled water supply parameters"));

  parameter Real thrTimHigReq(
    final unit="s",
    displayUnit="s",
    final quantity="Duration") = 60
    "Threshold time for generating two chilled water supply requests"
    annotation(Dialog(group="Chilled water supply parameters"));

  parameter Real valPosLowCloTemRes(
    final unit="1",
    displayUnit="1") = 0.45
    "Lower limit for sending one request for chilled water temperature reset"
    annotation(Dialog(group="Chilled water temperature reset parameters"));

  parameter Real valPosLowOpeTemRes(
    final unit="1",
    displayUnit="1") = 0.5
    "Upper limit for sending one request for chilled water temperature reset"
    annotation(Dialog(group="Chilled water temperature reset parameters"));

  parameter Real valPosHigCloTemRes(
    final unit="1",
    displayUnit="1") = 0.95
    "Lower limit for sending two requests for chilled water temperature reset"
    annotation(Dialog(group="Chilled water temperature reset parameters"));

  parameter Real valPosHigOpeTemRes(
    final unit="1",
    displayUnit="1") = 0.99
    "Upper limit for sending two requests for chilled water temperature reset"
    annotation(Dialog(group="Chilled water temperature reset parameters"));

  parameter Real thrTimLowTemRes(
    final unit="s",
    displayUnit="s",
    final quantity="Duration") = 300
    "Threshold time for generating one chilled water temperature reset request"
    annotation(Dialog(group="Chilled water temperature reset parameters"));

  parameter Real thrTimHigTemRes(
    final unit="s",
    displayUnit="s",
    final quantity="Duration") = 60
    "Threshold time for generating two chilled water temperature reset requests"
    annotation(Dialog(group="Chilled water temperature reset parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConSen
    "Signal indicating condensation detected in zone"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uValPos(
    final unit="1",
    displayUnit="1")
    "Chilled water control valve position on chilled beams"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiWatSupReq
    "Number of requests for chilled water supply"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput TChiWatReq
    "Number of requests for chilled water supply temperature reset"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    "Send zero requests if condensation is detected in the zone. Else send requests generated from valve position"
    annotation (Placement(transformation(extent={{70,-70},{90,-50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=0)
    "Constant Integer source"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Generate True signal when no condensation is detected"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=thrTimLowReq)
    "Check if threshold time for generating one request has been exceeded"
    annotation (Placement(transformation(extent={{-50,70},{-30,90}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim1(
    final t=thrTimHigReq)
    "Check if threshold time for generating two requests has been exceeded"
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=valPosLowCloReq,
    final uHigh=valPosLowOpeReq)
    "Check if chilled water control valve is at limit required to send one request"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
    final uLow=valPosHigCloReq,
    final uHigh=valPosHigOpeReq)
    "Check if chilled water control valve is at limit required to send two requests"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    "Boolean to Integer conversion"
    annotation (Placement(transformation(extent={{10,70},{30,90}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1(
    final integerTrue=2)
    "Boolean to Integer conversion"
    annotation (Placement(transformation(extent={{10,40},{30,60}})));

  Buildings.Controls.OBC.CDL.Integers.Max maxInt
    "Find maximum integer output"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim2(
    final t=thrTimLowTemRes)
    "Check if threshold time for generating one request has been exceeded"
    annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim3(
    final t=thrTimHigTemRes)
    "Check if threshold time for generating two requests has been exceeded"
    annotation (Placement(transformation(extent={{-50,-60},{-30,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3(
    final uLow=valPosLowCloTemRes,
    final uHigh=valPosLowOpeTemRes)
    "Check if chilled water control valve is at limit required to send one request"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys4(
    final uLow=valPosHigCloTemRes,
    final uHigh=valPosHigOpeTemRes)
    "Check if chilled water control valve is at limit required to send two requests"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2
    "Boolean to Integer conversion"
    annotation (Placement(transformation(extent={{10,-20},{30,0}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt3(
    final integerTrue=2)
    "Boolean to Integer conversion"
    annotation (Placement(transformation(extent={{10,-60},{30,-40}})));

  Buildings.Controls.OBC.CDL.Integers.Max maxInt1
    "Find maximum integer output"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

equation

  connect(uValPos, hys1.u) annotation (Line(points={{-120,40},{-90,40},{-90,80},
          {-82,80}}, color={0,0,127}));

  connect(uValPos, hys2.u) annotation (Line(points={{-120,40},{-90,40},{-90,50},
          {-82,50}}, color={0,0,127}));

  connect(booToInt.y, maxInt.u1) annotation (Line(points={{32,80},{36,80},{36,
          66},{38,66}},
                    color={255,127,0}));

  connect(booToInt1.y, maxInt.u2) annotation (Line(points={{32,50},{36,50},{36,54},
          {38,54}}, color={255,127,0}));

  connect(hys1.y, tim.u)
    annotation (Line(points={{-58,80},{-52,80}},   color={255,0,255}));
  connect(hys2.y, tim1.u)
    annotation (Line(points={{-58,50},{-52,50}},   color={255,0,255}));
  connect(tim.passed, booToInt.u) annotation (Line(points={{-28,72},{-10,72},{
          -10,80},{8,80}}, color={255,0,255}));
  connect(tim1.passed, booToInt1.u) annotation (Line(points={{-28,42},{-10,42},{
          -10,50},{8,50}},  color={255,0,255}));
  connect(booToInt2.y, maxInt1.u1) annotation (Line(points={{32,-10},{36,-10},{36,
          -24},{38,-24}},    color={255,127,0}));
  connect(booToInt3.y, maxInt1.u2) annotation (Line(points={{32,-50},{36,-50},{36,
          -36},{38,-36}},    color={255,127,0}));
  connect(hys3.y, tim2.u)
    annotation (Line(points={{-58,-10},{-52,-10}}, color={255,0,255}));
  connect(hys4.y,tim3. u)
    annotation (Line(points={{-58,-50},{-52,-50}}, color={255,0,255}));
  connect(tim2.passed, booToInt2.u) annotation (Line(points={{-28,-18},{-10,-18},
          {-10,-10},{8,-10}}, color={255,0,255}));
  connect(tim3.passed, booToInt3.u) annotation (Line(points={{-28,-58},{-10,-58},
          {-10,-50},{8,-50}}, color={255,0,255}));
  connect(uValPos, hys3.u) annotation (Line(points={{-120,40},{-90,40},{-90,-10},
          {-82,-10}}, color={0,0,127}));
  connect(uValPos, hys4.u) annotation (Line(points={{-120,40},{-90,40},{-90,-50},
          {-82,-50}}, color={0,0,127}));
  connect(intSwi.y, TChiWatReq)
    annotation (Line(points={{92,-60},{120,-60}}, color={255,127,0}));
  connect(maxInt1.y, intSwi.u1) annotation (Line(points={{62,-30},{64,-30},{64,-52},
          {68,-52}}, color={255,127,0}));
  connect(conInt.y, intSwi.u3) annotation (Line(points={{42,-80},{60,-80},{60,-68},
          {68,-68}}, color={255,127,0}));
  connect(uConSen, not1.u)
    annotation (Line(points={{-120,-80},{-92,-80}}, color={255,0,255}));
  connect(not1.y, intSwi.u2) annotation (Line(points={{-68,-80},{-60,-80},{-60,-64},
          {60,-64},{60,-60},{68,-60}}, color={255,0,255}));
  connect(maxInt.y, yChiWatSupReq)
    annotation (Line(points={{62,60},{120,60}}, color={255,127,0}));
annotation(defaultComponentName="chiWatSupRes",
  Icon(coordinateSystem(preserveAspectRatio=false),
          graphics={
            Text(
              extent={{-100,150},{100,110}},
              lineColor={0,0,255},
              textString="%name"),
            Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={28,108,200},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-50,20},{50,-20}},
              lineColor={28,108,200},
              fillColor={255,255,255},
              fillPattern=FillPattern.None,
      textString="chiWatSupRes"),
        Text(
          extent={{-96,48},{-60,32}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uValPos"),
        Text(
          extent={{-96,-32},{-60,-48}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uConSen"),
        Text(
          extent={{52,-50},{96,-70}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="TChiWatReq"),
        Text(
          extent={{44,74},{96,48}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yChiWatSupReq")}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
Sequences for generating requests for chilled water supply and chilled water
supply temperature setpoint reset.
</p>
<p>
This block generates requests for chilled water supply <code>yChiWatSupReq</code>
and chilled water supply temperature setpoint reset <code>TChiWatReq</code>. The
requests are generated as follows:
<ol>
<li>
Chilled water supply
<ul>
<li>
one request is generated if a control valve is open greater than <code>valPosLowOpeReq</code>
for <code>thrTimLowReq</code> continuously.
</li>
<li>
two requests are generated if a control valve is open greater than <code>valPosHigOpeReq</code>
for <code>thrTimHigReq</code> continuously.
</li>
<li>
no requests are generated otherwise.
</li>
</ul>
</li>
<li>
Chilled water supply temperature setpoint reset
<ul>
<li>
one request is generated if a control valve is open greater than <code>valPosLowOpeTemRes</code>
for <code>thrTimLowTemRes</code> continuously.
</li>
<li>
two requests are generated if a control valve is open greater than <code>valPosHigOpeTemRes</code>
for <code>thrTimHigTemRes</code> continuously.
</li>
<li>
no requests are generated otherwise.
</li>
</ul>
</li>
</ol>
</p>
</html>",
revisions="<html>
<ul>
<li>
June 16, 2021, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChilledWaterSupplyReset;
