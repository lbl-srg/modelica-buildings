within Buildings.Templates.Plants.Components.Controls.Enabling;
block Enable "Evaluation of system enable command"
  parameter Buildings.Templates.Plants.Components.Controls.Types.Application typ
    "Type of application"
    annotation(Evaluate=true);
  parameter Boolean have_inpSch=false
    "Set to true to provide schedule via software input point"
    annotation(Dialog(tab="Advanced"), Evaluate=true);
  parameter Real sch[:, 2] = [0,1; 24*3600,1]
    "Enable schedule"
    annotation(Dialog(enable=not have_inpSch));
  parameter Real TOutLck(
    final min=100,
    final unit="K",
    displayUnit="degC")=
    if typ==Buildings.Templates.Plants.Components.Controls.Types.Application.Heating
      then 18 + 273.15 else 15 + 273.15
    "Outdoor air lockout temperature";
  parameter Real dTOutLck(
    final min=0,
    final unit="K")=0.5
    "Hysteresis for outdoor air lockout temperature";
  parameter Real dtRun(
    final min=0,
    final unit="s")=15*60
    "Minimum runtime of enable and disable states";
  parameter Real dtReq(
    final min=0,
    final unit="s")=3*60
    "Runtime with low number of request before disabling";
  parameter Integer nReqIgn(final min=0)=0
    "Number of ignored requests";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Sch if have_inpSch
    "System enable via schedule"
    annotation (Placement(transformation(extent={{-200,
            80},{-160,120}}), iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nReq
    "Number of requests"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-200,-120},{-160,-80}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1
    "Enable command"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
     iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable schEna(
    final table=sch,
    final period=max(sch[:,1]))
    if not have_inpSch "Enable schedule"
    annotation (Placement(transformation(extent={{-150,50},{-130,70}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold greIgn(
    final t=nReqIgn)
    "Return true if number of requests > number of ignored requests"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greLck(
    final t=TOutLck)
    if typ==Buildings.Templates.Plants.Components.Controls.Types.Application.Cooling
    "Return true if OAT > lockout temperature"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesLck(
    final t=TOutLck)
    if typ==Buildings.Templates.Plants.Components.Controls.Types.Application.Heating
    "Return true if OAT < lockout temperature"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Pre preEna
    "Left limit (in discrete-time) of enable signal"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timEna(final t=dtRun)
    "Return true if system has been enabled for specified duration"
    annotation (Placement(transformation(extent={{0,110},{20,130}})));
  Buildings.Controls.OBC.CDL.Logical.Not dis "Return true if disabled"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Logical.Timer runDis(final t=dtRun)
    "Return true if system has been disabled for specified duration"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(nin=4)
    "Combine enable conditions"
    annotation (Placement(transformation(extent={{50,30},{70,50}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(nin=3)
    "Combine disable conditions"
    annotation (Placement(transformation(extent={{50,-50},{70,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not disSch
    "Return true if disabled by schedule"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold lowIgn(final t=nReqIgn)
    "Return true if number of requests ≤ number of ignored requests"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timLowReq(final t=dtReq)
    "Return true if low number of requests for specified duration"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lowLckHys(
    final t=TOutLck - dTOutLck)
    if typ==Buildings.Templates.Plants.Components.Controls.Types.Application.Cooling
    "Return true if OAT < lockout temperature - hysteresis"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greLckHys(
    final t=TOutLck + dTOutLck)
    if typ==Buildings.Templates.Plants.Components.Controls.Types.Application.Heating
    "Return true if OAT > lockout temperature + hysteresis"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And andRun
    "Disable conditions met AND enable minimum runtime exceeded"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Clear enable signal if disable conditions are met"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
equation
  connect(nReq,greIgn. u)
    annotation (Line(points={{-180,0},{-122,0}}, color={255,127,0}));
  connect(TOut,greLck. u) annotation (Line(points={{-180,-100},{-140,-100},{-140,
          -80},{-122,-80}}, color={0,0,127}));
  connect(TOut,lesLck. u) annotation (Line(points={{-180,-100},{-140,-100},{-140,
          -120},{-122,-120}}, color={0,0,127}));
  connect(preEna.y, dis.u) annotation (Line(points={{-58,120},{-50,120},{-50,100},
          {-42,100}}, color={255,0,255}));
  connect(dis.y, runDis.u) annotation (Line(points={{-18,100},{-10,100},{-10,80},
          {-2,80}}, color={255,0,255}));
  connect(preEna.y, timEna.u)
    annotation (Line(points={{-58,120},{-2,120}}, color={255,0,255}));
  connect(runDis.passed, mulAnd.u[1]) annotation (Line(points={{22,72},{40,72},{
          40,37.375},{48,37.375}},   color={255,0,255}));
  connect(schEna.y[1], mulAnd.u[2]) annotation (Line(points={{-128,60},{-100,60},
          {-100,39.125},{48,39.125}},
                                   color={255,0,255}));
  connect(u1Sch, mulAnd.u[2]) annotation (Line(points={{-180,100},{-100,100},{-100,
          40},{48,40},{48,39.125}}, color={255,0,255}));
  connect(greIgn.y, mulAnd.u[3]) annotation (Line(points={{-98,0},{40,0},{40,40.875},
          {48,40.875}},  color={255,0,255}));
  connect(schEna.y[1], disSch.u) annotation (Line(points={{-128,60},{-82,60}},
                         color={255,0,255}));
  connect(u1Sch, disSch.u) annotation (Line(points={{-180,100},{-100,100},{-100,
          60},{-82,60}}, color={255,0,255}));
  connect(disSch.y, mulOr.u[1]) annotation (Line(points={{-58,60},{0,60},{0,
          -42.3333},{48,-42.3333}},
                         color={255,0,255}));
  connect(nReq, lowIgn.u) annotation (Line(points={{-180,0},{-140,0},{-140,-40},
          {-122,-40}}, color={255,127,0}));
  connect(lowIgn.y, timLowReq.u)
    annotation (Line(points={{-98,-40},{-82,-40}}, color={255,0,255}));
  connect(timLowReq.passed, mulOr.u[2]) annotation (Line(points={{-58,-48},{-40,
          -48},{-40,-40},{48,-40}},         color={255,0,255}));
  connect(greLck.y, mulAnd.u[4]) annotation (Line(points={{-98,-80},{20,-80},{20,
          42.625},{48,42.625}}, color={255,0,255}));
  connect(lesLck.y, mulAnd.u[4]) annotation (Line(points={{-98,-120},{20,-120},{
          20,42.625},{48,42.625}},   color={255,0,255}));
  connect(TOut, lowLckHys.u)
    annotation (Line(points={{-180,-100},{-82,-100}}, color={0,0,127}));
  connect(lowLckHys.y, mulOr.u[3]) annotation (Line(points={{-58,-100},{40,-100},
          {40,-37.6667},{48,-37.6667}}, color={255,0,255}));
  connect(TOut, greLckHys.u) annotation (Line(points={{-180,-100},{-140,-100},{-140,
          -140},{-82,-140}}, color={0,0,127}));
  connect(greLckHys.y, mulOr.u[3]) annotation (Line(points={{-58,-140},{40,-140},
          {40,-37.6667},{48,-37.6667}}, color={255,0,255}));
  connect(timEna.passed, andRun.u1) annotation (Line(points={{22,112},{80,112},{
          80,-40},{88,-40}},    color={255,0,255}));
  connect(mulOr.y, andRun.u2) annotation (Line(points={{72,-40},{76,-40},{76,-48},
          {88,-48}},  color={255,0,255}));
  connect(y1, lat.y)
    annotation (Line(points={{180,0},{142,0}}, color={255,0,255}));
  connect(mulAnd.y, lat.u) annotation (Line(points={{72,40},{114,40},{114,0},{118,
          0}}, color={255,0,255}));
  connect(andRun.y, lat.clr) annotation (Line(points={{112,-40},{114,-40},{114,-6},
          {118,-6}},                    color={255,0,255}));
  connect(y1, preEna.u) annotation (Line(points={{180,0},{150,0},{150,140},{-100,
          140},{-100,120},{-82,120}}, color={255,0,255}));
  annotation (defaultComponentName = "ena",
  Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.1),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=5,
          borderPattern=BorderPattern.Raised),
        Ellipse(extent={{-80,80},{80,-80}}, lineColor={28,108,200},fillColor={170,255,213},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-90,90},{90,-90}}, lineColor={28,108,200}),
        Rectangle(extent={{-75,2},{75,-2}}, lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-66,46},{76,10}},
          textColor={28,108,200},
          textString="START"),
        Text(
          extent={{-66,-8},{76,-44}},
          textColor={28,108,200},
          textString="STOP"),
        Text(
          extent={{-150,150},{150,110}},
          textColor={0,0,255},
          textString="%name")},
          coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This block generates the system enable command.
</p>
<p>
The system is enabled when it has been disabled for at least the duration <code>dtRun</code> and:
</p>
<ul>
<li>
Number of system requests &gt; number of ignored requests <code>nReqIgn</code>, and
</li>
<li>
<b>For cooling systems</b>: outdoor air temperature &gt; outdoor air lockout 
temperature <code>TOutLck</code>, and
</li>
<li>
<b>For heating systems</b>: outdoor air temperature &lt; outdoor air lockout 
temperature <code>TOutLck</code>, and
</li>
<li>
The enable schedule is active.
</li>
</ul>
<p>
The system is disabled when it has been enabled for at least the duration 
<code>dtRun</code> and:
</p>
<ul>
<li>
Number of system requests &le; number of ignored requests <code>nReqIgn</code> 
for at least the duration <code>dtReq</code>, or
</li>
<li>
<b>For cooling systems</b>: outdoor air temperature &lt; outdoor air lockout 
temperature <code>TOutLck</code> minus hysteresis <code>dTOutLck</code>, or
</li>
<li>
<b>For heating systems</b>: outdoor air temperature &gt; outdoor air lockout 
temperature <code>TOutLck</code> plus hysteresis <code>dTOutLck</code>, or
</li>
<li>
The system enable schedule is inactive.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-160,-160},{160,160}})));
end Enable;
