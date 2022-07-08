within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences;
block DisableChiller "Sequence for disabling chiller in stage-down process"

  parameter Integer nChi=2 "Total number of chillers";
  parameter Real proOnTim(
    final unit="s",
    final quantity="Time",
    displayUnit="h") = 300
    "Enabled chiller operation time to indicate if it is proven on";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexEnaChi
    "Index of next enabling chiller"
    annotation (Placement(transformation(extent={{-240,180},{-200,220}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow
    "Stage-down command"
    annotation (Placement(transformation(extent={{-240,120},{-200,160}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaChiWatIsoVal
    "Status of chiller chilled water isolation valve control: true=enabled valve is fully open"
    annotation (Placement(transformation(extent={{-240,90},{-200,130}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
     annotation (Placement(transformation(extent={{-240,60},{-200,100}}),
       iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexDisChi
    "Next disabling chiller when there is any stage up that need one chiller on and another off"
    annotation (Placement(transformation(extent={{-240,-100},{-200,-60}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "Indicate if the stage require one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{-240,-140},{-200,-100}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chiller enabling status"
    annotation (Placement(transformation(extent={{200,-140},{240,-100}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yReaDemLim
    "Release demand limit"
    annotation (Placement(transformation(extent={{200,-70},{240,-30}}),
      iconTransformation(extent={{100,-100},{140,-60}})));

protected
  final parameter Integer chiInd[nChi]={i for i in 1:nChi}
    "Chiller index, {1,2,...,n}";
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{100,190},{120,210}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{-160,130},{-140,150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  Buildings.Controls.OBC.CDL.Logical.And and1[nChi] "Logical and"
    annotation (Placement(transformation(extent={{-40,190},{-20,210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[nChi](
    final k=fill(true, nChi)) "True constant"
    annotation (Placement(transformation(extent={{-40,220},{-20,240}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greEquThr[nChi](
    final t=fill(0.5, nChi))
    "Convert real input to boolean output"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1[nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Buildings.Controls.OBC.CDL.Logical.And and3[nChi] "Logical and"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nChi](
    final k=fill(false, nChi)) "False constant"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi2[nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{160,40},{180,60}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(final nout=nChi)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{-160,190},{-140,210}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nChi]
    "Check next enabling isolation valve"
    annotation (Placement(transformation(extent={{-100,190},{-80,210}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(final t=proOnTim)
    "Count the time after new chiller has been enabled"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam[nChi]
    "Record the old chiller chilled water isolation valve status"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep2(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep3(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nChi](
    final k=chiInd) "Chiller index array"
    annotation (Placement(transformation(extent={{-160,160},{-140,180}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep1(final nout=nChi)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nChi]
    "Check next enabling isolation valve"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep4(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-160,-170},{-140,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-160,-250},{-140,-230}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-160,-220},{-140,-200}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1[nChi]
    "Record the old chiller chilled water isolation valve status"
    annotation (Placement(transformation(extent={{-80,-220},{-60,-200}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep5(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-120,-250},{-100,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greEquThr1[nChi](
    final t=fill(0.5, nChi))
    "Convert real input to boolean output"
    annotation (Placement(transformation(extent={{40,-220},{60,-200}})));
  Buildings.Controls.OBC.CDL.Logical.And and4[nChi] "Logical and"
    annotation (Placement(transformation(extent={{40,-190},{60,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[nChi](
    final k=fill(false, nChi))
    "False constant"
    annotation (Placement(transformation(extent={{40,-160},{60,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi3[nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{100,-190},{120,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi4[nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{160,-130},{180,-110}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep6(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{100,-130},{120,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi5[nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi6[nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{100,-250},{120,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi7
    "Logical switch"
    annotation (Placement(transformation(extent={{160,-62},{180,-42}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3(
    final k=true)
    "When the process does not require chiller on-off, there is no need to limit chiller demand"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

equation
  connect(nexEnaChi, intRep.u)
    annotation (Line(points={{-220,200},{-162,200}}, color={255,127,0}));
  connect(intRep.y,intEqu. u1)
    annotation (Line(points={{-138,200},{-102,200}}, color={255,127,0}));
  connect(uEnaChiWatIsoVal,and2. u2)
    annotation (Line(points={{-220,110},{-170,110},{-170,132},{-162,132}},
      color={255,0,255}));
  connect(uStaDow, and2.u1)
    annotation (Line(points={{-220,140},{-162,140}}, color={255,0,255}));
  connect(and2.y,booRep. u)
    annotation (Line(points={{-138,140},{-102,140}}, color={255,0,255}));
  connect(intEqu.y,and1. u1)
    annotation (Line(points={{-78,200},{-42,200}},  color={255,0,255}));
  connect(booRep.y,and1. u2)
    annotation (Line(points={{-78,140},{-70,140},{-70,192},{-42,192}},
      color={255,0,255}));
  connect(and1.y,logSwi. u2)
    annotation (Line(points={{-18,200},{98,200}}, color={255,0,255}));
  connect(con.y,logSwi. u1)
    annotation (Line(points={{-18,230},{0,230},{0,208},{98,208}}, color={255,0,255}));
  connect(uChi,booToRea. u)
    annotation (Line(points={{-220,80},{-170,80},{-170,100},{-102,100}},
      color={255,0,255}));
  connect(and2.y,edg. u)
    annotation (Line(points={{-138,140},{-120,140},{-120,70},{-102,70}},
      color={255,0,255}));
  connect(booToRea.y,triSam. u)
    annotation (Line(points={{-78,100},{-22,100}}, color={0,0,127}));
  connect(edg.y,booRep1. u)
    annotation (Line(points={{-78,70},{-62,70}}, color={255,0,255}));
  connect(booRep1.y,triSam. trigger)
    annotation (Line(points={{-38,70},{-10,70},{-10,88}},   color={255,0,255}));
  connect(triSam.y,greEquThr. u)
    annotation (Line(points={{2,100},{18,100}}, color={0,0,127}));
  connect(greEquThr.y,logSwi. u3)
    annotation (Line(points={{42,100},{60,100},{60,192},{98,192}},
      color={255,0,255}));
  connect(and2.y,tim. u)
    annotation (Line(points={{-138,140},{-120,140},{-120,0},{-102,0}},
      color={255,0,255}));
  connect(booRep2.y,and3. u1)
    annotation (Line(points={{2,0},{38,0}}, color={255,0,255}));
  connect(and3.y,logSwi1. u2)
    annotation (Line(points={{62,0},{80,0},{80,10},{98,10}},
      color={255,0,255}));
  connect(con1.y,logSwi1. u1)
    annotation (Line(points={{62,30},{80,30},{80,18},{98,18}},
      color={255,0,255}));
  connect(uChi,logSwi1. u3)
    annotation (Line(points={{-220,80},{-170,80},{-170,-20},{90,-20},{90,2},
      {98,2}}, color={255,0,255}));
  connect(booRep3.y,logSwi2. u2)
    annotation (Line(points={{102,50},{158,50}}, color={255,0,255}));
  connect(logSwi1.y,logSwi2. u3)
    annotation (Line(points={{122,10},{140,10},{140,42},{158,42}},
      color={255,0,255}));
  connect(logSwi.y,logSwi2. u1)
    annotation (Line(points={{122,200},{140,200},{140,58},{158,58}},
      color={255,0,255}));
  connect(conInt.y,intEqu. u2)
    annotation (Line(points={{-138,170},{-110,170},{-110,192},{-102,192}},
      color={255,127,0}));
  connect(nexDisChi, intRep1.u)
    annotation (Line(points={{-220,-80},{-162,-80}}, color={255,127,0}));
  connect(intRep1.y,intEqu1. u1)
    annotation (Line(points={{-138,-80},{-102,-80}}, color={255,127,0}));
  connect(conInt.y,intEqu1. u2)
    annotation (Line(points={{-138,170},{-110,170},{-110,-88},{-102,-88}},
      color={255,127,0}));
  connect(intEqu1.y,and3. u2)
    annotation (Line(points={{-78,-80},{10,-80},{10,-8},{38,-8}},
      color={255,0,255}));
  connect(not1.y, booRep3.u)
    annotation (Line(points={{2,50},{78,50}}, color={255,0,255}));
  connect(uStaDow, booRep4.u)
    annotation (Line(points={{-220,140},{-180,140},{-180,-160},{-162,-160}},
      color={255,0,255}));
  connect(uChi, booToRea1.u)
    annotation (Line(points={{-220,80},{-170,80},{-170,-210},{-162,-210}},
      color={255,0,255}));
  connect(uStaDow, edg1.u)
    annotation (Line(points={{-220,140},{-180,140},{-180,-240},{-162,-240}},
      color={255,0,255}));
  connect(booToRea1.y, triSam1.u)
    annotation (Line(points={{-138,-210},{-82,-210}},color={0,0,127}));
  connect(edg1.y, booRep5.u)
    annotation (Line(points={{-138,-240},{-122,-240}}, color={255,0,255}));
  connect(triSam1.y, greEquThr1.u)
    annotation (Line(points={{-58,-210},{38,-210}}, color={0,0,127}));
  connect(booRep4.y, and4.u2)
    annotation (Line(points={{-138,-160},{0,-160},{0,-188},{38,-188}},
      color={255,0,255}));
  connect(intEqu1.y, and4.u1)
    annotation (Line(points={{-78,-80},{10,-80},{10,-180},{38,-180}},
      color={255,0,255}));
  connect(and4.y, logSwi3.u2)
    annotation (Line(points={{62,-180},{98,-180}}, color={255,0,255}));
  connect(con2.y, logSwi3.u1)
    annotation (Line(points={{62,-150},{72,-150},{72,-172},{98,-172}},
      color={255,0,255}));
  connect(greEquThr1.y, logSwi3.u3)
    annotation (Line(points={{62,-210},{80,-210},{80,-188},{98,-188}},
      color={255,0,255}));
  connect(uOnOff, booRep6.u)
    annotation (Line(points={{-220,-120},{98,-120}}, color={255,0,255}));
  connect(booRep6.y, logSwi4.u2)
    annotation (Line(points={{122,-120},{158,-120}},color={255,0,255}));
  connect(logSwi4.y, yChi)
    annotation (Line(points={{182,-120},{220,-120}}, color={255,0,255}));
  connect(booRep.y, logSwi5.u2)
    annotation (Line(points={{-78,140},{-70,140},{-70,-90},{98,-90}},
      color={255,0,255}));
  connect(uChi, logSwi5.u3)
    annotation (Line(points={{-220,80},{-170,80},{-170,-98},{98,-98}},
      color={255,0,255}));
  connect(logSwi2.y, logSwi5.u1)
    annotation (Line(points={{182,50},{190,50},{190,-28},{60,-28},{60,-82},{98,-82}},
      color={255,0,255}));
  connect(logSwi5.y, logSwi4.u1)
    annotation (Line(points={{122,-90},{140,-90},{140,-112},{158,-112}},
      color={255,0,255}));
  connect(booRep5.y, triSam1.trigger)
    annotation (Line(points={{-98,-240},{-70,-240},{-70,-222}},   color={255,0,255}));
  connect(booRep4.y, logSwi6.u2)
    annotation (Line(points={{-138,-160},{0,-160},{0,-240},{98,-240}}, color={255,0,255}));
  connect(logSwi3.y, logSwi6.u1)
    annotation (Line(points={{122,-180},{130,-180},{130,-220},{80,-220},
      {80,-232},{98,-232}}, color={255,0,255}));
  connect(uChi, logSwi6.u3)
    annotation (Line(points={{-220,80},{-170,80},{-170,-180},{-40,-180},
      {-40,-248},{98,-248}}, color={255,0,255}));
  connect(logSwi6.y, logSwi4.u3)
    annotation (Line(points={{122,-240},{140,-240},{140,-128},{158,-128}},
      color={255,0,255}));
  connect(uOnOff, logSwi7.u2)
    annotation (Line(points={{-220,-120},{80,-120},{80,-52},{158,-52}},
      color={255,0,255}));
  connect(logSwi7.y, yReaDemLim)
    annotation (Line(points={{182,-52},{202,-52},{202,-50},{220,-50}},
      color={255,0,255}));
  connect(tim.passed, not1.u)
    annotation (Line(points={{-78,-8},{-40,-8},{-40,50},{-22,50}},
      color={255,0,255}));
  connect(tim.passed, booRep2.u)
    annotation (Line(points={{-78,-8},{-40,-8},{-40,0},{-22,0}},
      color={255,0,255}));
  connect(tim.passed, logSwi7.u1)
    annotation (Line(points={{-78,-8},{-40,-8},{-40,-44},{158,-44}},
      color={255,0,255}));

  connect(con3.y, logSwi7.u3) annotation (Line(points={{42,-70},{90,-70},{90,-60},
          {158,-60}}, color={255,0,255}));
annotation (
  defaultComponentName="disChi",
  Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-60,0},{60,-80}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-52,20},{-40,0}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,20},{52,0}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,60},{60,20}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,98},{-44,82}},
          textColor={255,127,0},
          textString="nexEnaChi"),
        Text(
          extent={{-98,70},{-52,56}},
          textColor={255,0,255},
          textString="uStaDow"),
        Text(
          extent={{-96,30},{-24,10}},
          textColor={255,0,255},
          textString="uEnaChiWatIsoVal"),
        Text(
          extent={{-100,-14},{-78,-24}},
          textColor={255,0,255},
          textString="uChi"),
        Text(
          extent={{-98,-82},{-70,-94}},
          textColor={255,0,255},
          textString="uOnOff"),
        Text(
          extent={{-98,-40},{-44,-56}},
          textColor={255,127,0},
          textString="nexDisChi"),
        Text(
          extent={{74,6},{98,-6}},
          textColor={255,0,255},
          textString="yChi"),
        Text(
          extent={{44,-72},{96,-84}},
          textColor={255,0,255},
          textString="yReaDemLim")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-260},{200,260}}),
        graphics={
          Rectangle(
          extent={{-198,-142},{198,-258}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Rectangle(
          extent={{-198,258},{198,-98}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{100,188},{170,168}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Enable small chiller"),
          Text(
          extent={{102,-6},{172,-24}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Disable large chiller"),
          Text(
          extent={{-164,-244},{190,-286}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Disable chiller when the down-process does not require any other chiller being enabled"),
          Text(
          extent={{-144,278},{166,258}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Disable chiller when the down-process requires small chiller being enabled")}),
Documentation(info="<html>
<p>
Block that controlles chiller when there is staging down command <code>uStaDow=true</code>.
This implementation is based on ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II – 
Central Plants and Hydronic Systems (Draft on March 23, 2020), section 5.2.4.17,
item 1.e and f. These two sections specify how to start the smaller chiller and shut
off larger chiller when the stage change requires large chiller off and small chill on.
In other stage change, when it does not require chiller on/off, the chiller will then
be shut off as specified in section 5.2.4.17, item 2.
</p>
<p>
When the stage-down process requires a smaller chiller being staged on and a larger
chiller being staged off:
</p>
<ul>
<li>
Start the smaller chiller after its chilled water isolation valve is fully open (
<code>uEnaChiWatIsoVal</code> becomes true).
</li>
<li>
Wait 5 minutes (<code>proOnTim</code>) for the newly enabled chiller to prove that 
it is operating correctly, then shut off the larger chiller and release the demand limit.
</li>
</ul>
<p>
If staging-down from any other stage that does not require one chiller off and another
chiller on, then shut off the last stage chiller.
</p>
</html>", revisions="<html>
<ul>
<li>
September 15, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end DisableChiller;
