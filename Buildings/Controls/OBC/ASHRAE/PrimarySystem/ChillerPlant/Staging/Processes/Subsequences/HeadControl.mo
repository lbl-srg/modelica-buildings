within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences;
block HeadControl
  "Sequences for enabling or disabling head pressure control for the chiller being enabled or disabled"

  parameter Integer nChi=2 "Total number of chiller";
  parameter Real thrTimEnb(
    final unit="s",
    final quantity="Time",
    displayUnit="h")=10
    "Threshold time to enable head pressure control after condenser water pump being reset";
  parameter Real waiTim(
    final unit="s",
    final quantity="Time",
    displayUnit="h") = 30
    "Waiting time after enabling next head pressure control";
  parameter Boolean heaStaCha = true
    "Flag to indicate if head pressure control of next chiller should be ON or OFF: true = in stage-up process so it should be ON";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaPla
    "True: plant is just enabled"
    annotation(Placement(transformation(extent={{-220,140},{-180,180}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexChaChi
    "Index of next enabling or disabling chiller"
    annotation (Placement(transformation(extent={{-220,-50},{-180,-10}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Status of resetting status of device before enabling or disabling head pressure control"
    annotation (Placement(transformation(extent={{-220,110},{-180,150}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiHeaCon[nChi]
    "Chillers head pressure control status"
    annotation (Placement(transformation(extent={{-220,-130},{-180,-90}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput chaPro
    "Indicate if there is stage change"
    annotation (Placement(transformation(extent={{-220,32},{-180,72}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiHeaCon[nChi]
    "Chiller head pressure control enabling status"
    annotation (Placement(transformation(extent={{180,-100},{220,-60}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEnaHeaCon
    "Status of heat pressure control: true=enabled head pressure control"
    annotation (Placement(transformation(extent={{180,80},{220,120}}),
      iconTransformation(extent={{100,40},{140,80}})));

protected
  final parameter Integer chiInd[nChi]={i for i in 1:nChi}
    "Chiller index, {1,2,...,n}";
  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Count the time after condenser water pump being reset"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=thrTimEnb)
    "Check if it has been threhold time after condenser water pump achieves its new setpoint"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam[nChi]
    "Record the old chiller head pressure control status"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-160,-120},{-140,-100}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(
    final t=thrTimEnb + waiTim)
    "Check if it has been threshold time after condenser water pump achieves its new setpoint and have waited for another amount of time"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nChi) "Replicate boolean input"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greEquThr[nChi](
    final t=fill(0.5, nChi))
    "Convert real input to boolean output"
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep2(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(final nout=nChi)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nChi]
    "Check next enabling isolation valve"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep3(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi "Logical switch"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(final k=false)
    "False constant"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(final k=heaStaCha)
    "Head control status change"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nChi](
    final k=chiInd)   "Chiller index array"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1[nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{140,-90},{160,-70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep4(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{40,-160},{60,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Plant just enabeld or it is in the chiller staging process"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));

equation
  connect(lat.y, tim.u)
    annotation (Line(points={{-78,60},{-62,60}}, color={255,0,255}));
  connect(tim.y, greThr.u)
    annotation (Line(points={{-38,60},{-2,60}}, color={0,0,127}));
  connect(uChiHeaCon, booToRea.u)
    annotation (Line(points={{-200,-110},{-162,-110}}, color={255,0,255}));
  connect(booToRea.y, triSam.u)
    annotation (Line(points={{-138,-110},{-62,-110}}, color={0,0,127}));
  connect(edg.y, and2.u1)
    annotation (Line(points={{-138,100},{-120,100},{-120,80},{-170,80},{-170,60},
          {-162,60}}, color={255,0,255}));
  connect(chaPro, and2.u2)
    annotation (Line(points={{-200,52},{-162,52}}, color={255,0,255}));
  connect(and2.y, lat.u)
    annotation (Line(points={{-138,60},{-102,60}}, color={255,0,255}));
  connect(chaPro, not1.u)
    annotation (Line(points={{-200,52},{-170,52},{-170,20},{-162,20}},
      color={255,0,255}));
  connect(not1.y, lat.clr)
    annotation (Line(points={{-138,20},{-110,20},{-110,54},{-102,54}},
      color={255,0,255}));
  connect(booRep.y, triSam.trigger)
    annotation (Line(points={{-78,-130},{-50,-130},{-50,-122}},
      color={255,0,255}));
  connect(tim.y, greThr1.u)
    annotation (Line(points={{-38,60},{-20,60},{-20,100},{-2,100}}, color={0,0,127}));
  connect(booRep1.y, swi.u2)
    annotation (Line(points={{62,60},{80,60},{80,-20},{98,-20}},
      color={255,0,255}));
  connect(greThr.y, booRep1.u)
    annotation (Line(points={{22,60},{38,60}}, color={255,0,255}));
  connect(swi.y, greEquThr.u)
    annotation (Line(points={{122,-20},{138,-20}}, color={0,0,127}));
  connect(not2.y, booRep2.u)
    annotation (Line(points={{-38,-60},{-22,-60}}, color={255,0,255}));
  connect(booRep2.y, swi1.u2)
    annotation (Line(points={{2,-60},{38,-60}},  color={255,0,255}));
  connect(triSam.y, swi1.u3)
    annotation (Line(points={{-38,-110},{20,-110},{20,-68},{38,-68}},
      color={0,0,127}));
  connect(swi1.y, swi.u3)
    annotation (Line(points={{62,-60},{80,-60},{80,-28},{98,-28}},
      color={0,0,127}));
  connect(lat.y, not2.u)
    annotation (Line(points={{-78,60},{-70,60},{-70,-60},{-62,-60}},
      color={255,0,255}));
  connect(nexChaChi, intRep.u)
    annotation (Line(points={{-200,-30},{-162,-30}}, color={255,127,0}));
  connect(intRep.y, intEqu.u1)
    annotation (Line(points={{-138,-30},{-102,-30}}, color={255,127,0}));
  connect(booToRea.y, swi1.u1)
    annotation (Line(points={{-138,-110},{-100,-110},{-100,-80},{10,-80},{10,-52},
          {38,-52}}, color={0,0,127}));
  connect(intEqu.y, swi2.u2)
    annotation (Line(points={{-78,-30},{38,-30}}, color={255,0,255}));
  connect(swi2.y, swi.u1)
    annotation (Line(points={{62,-30},{70,-30},{70,-12},{98,-12}},
      color={0,0,127}));
  connect(triSam.y, swi2.u3)
    annotation (Line(points={{-38,-110},{20,-110},{20,-38},{38,-38}},
      color={0,0,127}));
  connect(con1.y, logSwi.u1)
    annotation (Line(points={{-78,30},{-60,30},{-60,18},{-42,18}},
      color={255,0,255}));
  connect(con.y, logSwi.u3)
    annotation (Line(points={{-78,0},{-60,0},{-60,2},{-42,2}},
      color={255,0,255}));
  connect(greThr.y, logSwi.u2)
    annotation (Line(points={{22,60},{30,60},{30,40},{-50,40},{-50,10},{-42,10}},
      color={255,0,255}));
  connect(logSwi.y, booRep3.u)
    annotation (Line(points={{-18,10},{-2,10}},color={255,0,255}));
  connect(booRep3.y, booToRea1.u)
    annotation (Line(points={{22,10},{38,10}}, color={255,0,255}));
  connect(booToRea1.y, swi2.u1)
    annotation (Line(points={{62,10},{70,10},{70,-10},{20,-10},{20,-22},{38,-22}},
      color={0,0,127}));
  connect(conInt.y, intEqu.u2)
    annotation (Line(points={{-138,-60},{-130,-60},{-130,-38},{-102,-38}},
      color={255,127,0}));
  connect(greThr1.y, and1.u1)
    annotation (Line(points={{22,100},{98,100}},  color={255,0,255}));
  connect(and1.y, yEnaHeaCon)
    annotation (Line(points={{122,100},{200,100}}, color={255,0,255}));
  connect(and2.y, booRep.u)
    annotation (Line(points={{-138,60},{-120,60},{-120,-130},{-102,-130}},
      color={255,0,255}));
  connect(chaPro, booRep4.u)
    annotation (Line(points={{-200,52},{-170,52},{-170,-150},{38,-150}},
      color={255,0,255}));
  connect(uChiHeaCon, logSwi1.u3)
    annotation (Line(points={{-200,-110},{-166,-110},{-166,-88},{138,-88}},
      color={255,0,255}));
  connect(booRep4.y, logSwi1.u2)
    annotation (Line(points={{62,-150},{80,-150},{80,-80},{138,-80}},
      color={255,0,255}));
  connect(greEquThr.y, logSwi1.u1)
    annotation (Line(points={{162,-20},{170,-20},{170,-50},{120,-50},{120,-72},{
          138,-72}}, color={255,0,255}));
  connect(logSwi1.y, yChiHeaCon)
    annotation (Line(points={{162,-80},{200,-80}}, color={255,0,255}));
  connect(uEnaPla, or1.u1)
    annotation (Line(points={{-200,160},{-142,160}}, color={255,0,255}));
  connect(or1.y, and1.u2) annotation (Line(points={{-118,160},{80,160},{80,92},
          {98,92}}, color={255,0,255}));
  connect(uUpsDevSta, or1.u2) annotation (Line(points={{-200,130},{-160,130},{-160,
          152},{-142,152}}, color={255,0,255}));
  connect(or1.y, edg.u) annotation (Line(points={{-118,160},{-100,160},{-100,
          120},{-170,120},{-170,100},{-162,100}}, color={255,0,255}));
annotation (
  defaultComponentName="enaHeaCon",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-180,-180},{180,180}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,-34},{-54,-46}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="nexChaChi"),
        Text(
          extent={{-96,52},{-44,38}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uUpsDevSta"),
        Text(
          extent={{-100,6},{-66,-6}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="chaPro"),
        Text(
          extent={{-98,-72},{-46,-86}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChiHeaCon"),
        Text(
          extent={{44,68},{96,54}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yEnaHeaCon"),
        Text(
          extent={{44,-50},{96,-64}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yChiHeaCon"),
        Polygon(
          points={{-60,40},{-60,-40},{0,0},{-60,40}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{60,40},{60,-40},{0,0},{60,40}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,88},{-48,74}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uEnaPla")}),
  Documentation(info="<html>
<p>
Block that generates chiller head pressure control enabling status array when 
there is stage change command (<code>chaPro=true</code>). It also generates status 
to indicate if the head pressure control status change process has finished.
This development is based on ASHRAE RP-1711 Advanced Sequences of Operation for 
HVAC Systems Phase II – Central Plants and Hydronic Systems (Draft on March 23, 2020):
</p>
<p>
In stage-up process, section 5.2.4.16, item 4: 
</p>
<ul>
<li>
After the condenser water pumps speed or number has been changed by <code>thrTimEnb</code>,
e.g. 10 seconds, enable head pressure control for the chiller being enabled. 
Wait 30 seconds (<code>waiTim=30</code>).
</li>
</ul>
<p>
In stage-up process when requires smaller chiller being shut off and larger chiller
being enabled, section 5.2.4.16, item 7.c:
</p>
<ul>
<li>
When the controller of the smaller chiller being shut off indicates no request for
condenser water flow, disable the chiller's head pressure control loop, 
(<code>thrTimEnb=0</code> and <code>waiTim=0</code>).
</li>
</ul>
<p>
In stage-down process, section 5.2.4.17, item 4:
</p>
<ul>
<li>
When the controller of the chiller being shut off indicates no request for condenser
water flow, disable the chiller's head pressure control loop,
(<code>thrTimEnb=0</code> and <code>waiTim=0</code>).
</li>
</ul>
<p>
In stage-down process when requires smaller chiller being enabled and larger chiller
being disabled, section 5.2.4.17, item 1.c:
</p>
<ul>
<li>
After minimum flow bypass has been changed, enable head pressure control for
the chiller being enabled. Wait 30 seconds.
(<code>thrTimEnb=0</code> and <code>waiTim=30</code>).
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
February 4, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeadControl;
