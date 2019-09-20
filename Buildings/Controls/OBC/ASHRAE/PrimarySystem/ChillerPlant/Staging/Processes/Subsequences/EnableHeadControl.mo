within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences;
block EnableHeadControl
  "Sequences for enabling head pressure control for the chiller being enabled"

  parameter Integer nChi=2 "Total number of chiller";
  parameter Modelica.SIunits.Time thrTimEnb=10
    "Threshold time to enable head pressure control after condenser water pump being reset";
  parameter Modelica.SIunits.Time waiTim = 30
    "Waiting time after enabling next head pressure control";
  parameter Boolean heaStaCha = true
    "Flag to indicate if next head pressure control should be ON or OFF: true = in stage-up process";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uNexChaChi
    "Index of next enabling or disabling chiller"
    annotation (Placement(transformation(extent={{-180,-30},{-140,10}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Status of resetting status of device before enabling or disabling head pressure control"
    annotation (Placement(transformation(extent={{-180,100},{-140,140}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiHeaCon[nChi]
    "Chillers head pressure control status"
    annotation (Placement(transformation(extent={{-180,-110},{-140,-70}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaCha
    "Indicate if there is stage change"
    annotation (Placement(transformation(extent={{-180,52},{-140,92}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiHeaCon[nChi]
    "Chiller head pressure control enabling status"
    annotation (Placement(transformation(extent={{220,-30},{260,10}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEnaHeaCon
    "Status of heat pressure control: true=enabled head pressure control"
    annotation (Placement(transformation(extent={{220,100},{260,140}}),
      iconTransformation(extent={{100,40},{140,80}})));

protected
  final parameter Integer chiInd[nChi]={i for i in 1:nChi}
    "Chiller index, {1,2,...,n}";
  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Count the time after condenser water pump being reset"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr2(
    final threshold=thrTimEnb)
    "Check if it is 10 seconds after condenser water pump achieves its new setpoint"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam[nChi]
    "Record the old chiller head pressure control status"
    annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{140,-20},{160,0}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr1(
    final threshold=thrTimEnb + waiTim)
    "Check if it is 10 seconds after condenser water pump achieves its new setpoint and have waited another 30 seconds"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(
    final nout=nChi) "Replicate boolean input"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr[nChi](
    final threshold=fill(0.5, nChi))
    "Convert real input to boolean output"
    annotation (Placement(transformation(extent={{180,-20},{200,0}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep2(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep(final nout=nChi)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nChi]
    "Check next enabling isolation valve"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep3(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi "Logical switch"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(final k=false)
    "False constant"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(final k=heaStaCha)
    "Head control status change"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nChi](
    final k=chiInd)   "Chiller index array"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{140,110},{160,130}})));

equation
  connect(uUpsDevSta, edg.u)
    annotation (Line(points={{-160,120},{-122,120}}, color={255,0,255}));
  connect(lat.y, tim.u)
    annotation (Line(points={{-38,80},{-22,80}}, color={255,0,255}));
  connect(tim.y, greEquThr2.u)
    annotation (Line(points={{2,80},{38,80}}, color={0,0,127}));
  connect(uChiHeaCon, booToRea.u)
    annotation (Line(points={{-160,-90},{-122,-90}}, color={255,0,255}));
  connect(booToRea.y, triSam.u)
    annotation (Line(points={{-98,-90},{-22,-90}},
      color={0,0,127}));
  connect(edg.y, and2.u1)
    annotation (Line(points={{-98,120},{-80,120},{-80,100},{-130,100},{-130,80},
      {-122,80}}, color={255,0,255}));
  connect(uStaCha, and2.u2)
    annotation (Line(points={{-160,72},{-122,72}}, color={255,0,255}));
  connect(and2.y, lat.u)
    annotation (Line(points={{-98,80},{-62,80}}, color={255,0,255}));
  connect(and2.y, booRep.u)
    annotation (Line(points={{-98,80},{-80,80},{-80,-120},{-62,-120}},
      color={255,0,255}));
  connect(uStaCha, not1.u)
    annotation (Line(points={{-160,72},{-130,72},{-130,40},{-122,40}},
      color={255,0,255}));
  connect(not1.y, lat.clr)
    annotation (Line(points={{-98,40},{-70,40},{-70,74},{-62,74}},
      color={255,0,255}));
  connect(booRep.y, triSam.trigger)
    annotation (Line(points={{-38,-120},{-10,-120},{-10,-101.8}},
      color={255,0,255}));
  connect(tim.y, greEquThr1.u)
    annotation (Line(points={{2,80},{20,80},{20,120},{38,120}}, color={0,0,127}));
  connect(booRep1.y, swi.u2)
    annotation (Line(points={{102,80},{120,80},{120,-10},{138,-10}},
      color={255,0,255}));
  connect(greEquThr2.y, booRep1.u)
    annotation (Line(points={{62,80},{78,80}}, color={255,0,255}));
  connect(swi.y, greEquThr.u)
    annotation (Line(points={{162,-10},{178,-10}}, color={0,0,127}));
  connect(greEquThr.y, yChiHeaCon)
    annotation (Line(points={{202,-10},{240,-10}}, color={255,0,255}));
  connect(not2.y, booRep2.u)
    annotation (Line(points={{2,-60},{18,-60}}, color={255,0,255}));
  connect(booRep2.y, swi1.u2)
    annotation (Line(points={{42,-60},{78,-60}}, color={255,0,255}));
  connect(triSam.y, swi1.u3)
    annotation (Line(points={{2,-90},{60,-90},{60,-68},{78,-68}},
      color={0,0,127}));
  connect(swi1.y, swi.u3)
    annotation (Line(points={{102,-60},{120,-60},{120,-18},{138,-18}},
      color={0,0,127}));
  connect(lat.y, not2.u)
    annotation (Line(points={{-38,80},{-30,80},{-30,-60},{-22,-60}},
      color={255,0,255}));
  connect(uNexChaChi, intRep.u)
    annotation (Line(points={{-160,-10},{-122,-10}}, color={255,127,0}));
  connect(intRep.y, intEqu.u1)
    annotation (Line(points={{-98,-10},{-62,-10}}, color={255,127,0}));
  connect(booToRea.y, swi1.u1)
    annotation (Line(points={{-98,-90},{-60,-90},{-60,-40},{50,-40},{50,-52},
      {78,-52}}, color={0,0,127}));
  connect(intEqu.y, swi2.u2)
    annotation (Line(points={{-38,-10},{78,-10}}, color={255,0,255}));
  connect(swi2.y, swi.u1)
    annotation (Line(points={{102,-10},{110,-10},{110,-2},{138,-2}},
      color={0,0,127}));
  connect(triSam.y, swi2.u3)
    annotation (Line(points={{2,-90},{60,-90},{60,-18},{78,-18}},
      color={0,0,127}));
  connect(con1.y, logSwi.u1)
    annotation (Line(points={{-38,50},{-20,50},{-20,38},{-2,38}},
      color={255,0,255}));
  connect(con.y, logSwi.u3)
    annotation (Line(points={{-38,20},{-20,20},{-20,22},{-2,22}},
      color={255,0,255}));
  connect(greEquThr2.y, logSwi.u2)
    annotation (Line(points={{62,80},{70,80},{70,60},{-10,60},{-10,30},{-2,30}},
      color={255,0,255}));
  connect(logSwi.y, booRep3.u)
    annotation (Line(points={{22,30},{38,30}}, color={255,0,255}));
  connect(booRep3.y, booToRea1.u)
    annotation (Line(points={{62,30},{78,30}}, color={255,0,255}));
  connect(booToRea1.y, swi2.u1)
    annotation (Line(points={{102,30},{110,30},{110,10},{60,10},{60,-2},{78,-2}},
      color={0,0,127}));
  connect(conInt.y, intEqu.u2)
    annotation (Line(points={{-98,-40},{-90,-40},{-90,-18},{-62,-18}},
      color={255,127,0}));
  connect(uUpsDevSta, and1.u2)
    annotation (Line(points={{-160,120},{-130,120},{-130,104},{120,104},
      {120,112},{138,112}}, color={255,0,255}));
  connect(greEquThr1.y, and1.u1)
    annotation (Line(points={{62,120},{138,120}}, color={255,0,255}));
  connect(and1.y, yEnaHeaCon)
    annotation (Line(points={{162,120},{240,120}}, color={255,0,255}));

annotation (
  defaultComponentName="enaHeaCon",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-140,-140},{220,140}})),
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,-34},{-54,-46}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uNexChaChi"),
        Text(
          extent={{-98,88},{-46,74}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uUpsDevSta"),
        Text(
          extent={{-100,46},{-68,36}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uStaCha"),
        Text(
          extent={{-98,-72},{-46,-86}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChiHeaCon"),
        Text(
          extent={{44,68},{96,54}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yEnaHeaCon"),
        Text(
          extent={{44,-50},{96,-64}},
          lineColor={255,0,255},
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
          fillPattern=FillPattern.Solid)}),
  Documentation(info="<html>
<p>
Block that generates chiller head pressure control enabling status array when 
there is stage change command (<code>uStaCha=true</code>). It also generates status 
to indicate if the head pressure control status change process has finished.
This development is based on ASHRAE RP-1711 Advanced Sequences of Operation for 
HVAC Systems Phase II – Central Plants and Hydronic Systems (Draft 6 on July 25, 
2019):
</p>
<p>
In stage-up process, section 5.2.4.15, item 4: 
</p>
<ul>
<li>
10 seconds (<code>thrTimEnb=10</code>) after the changes on condenser water pumps, 
enable head pressure control for the chiller being enabled. 
Wait 30 seconds (<code>waiTim=30</code>).
</li>
</ul>
<p>
In stage-up process when requires smaller chiller being shut off and larger chiller
being enabled, section 5.2.4.15, item 7.c:
</p>
<ul>
<li>
When the controller of the smaller chiller being shut off indicates no request for
condenser water flow, disable the chiller's head pressure control loop, 
(<code>thrTimEnb=0</code> and <code>waiTim=0</code>).
</li>
</ul>
<p>
In stage-down process, section 5.2.4.16, item 4:
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
being disabled, section 5.2.4.16, item 1.c:
</p>
<ul>
<li>
After minimum flow bypass setpoint has been changed, enable head pressure control for
the chiller being enabled. Wait 30 seconds.
(<code>thrTimEnb=0</code> and <code>waiTim=30</code>).
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
Febuary 4, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableHeadControl;
