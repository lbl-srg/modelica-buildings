within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences;
block DisableBoiler
    "Sequence for disabling boiler in stage-down process"

  parameter Integer nBoi = 3
    "Total number of boilers";

  parameter Real proOnTim(
    final unit="s",
    final quantity="Time",
    displayUnit="s") = 300
    "Enabled boiler operation time to indicate if it is proven on";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow
    "Stage-down command"
    annotation (Placement(transformation(extent={{-240,120},{-200,160}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Status of upstream device: true=upstream device has completed stage change
    process"
    annotation (Placement(transformation(extent={{-240,90},{-200,130}}),
        iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uBoi[nBoi]
    "Boiler proven on status vector"
     annotation (Placement(transformation(extent={{-240,40},{-200,80}}),
       iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "Signal indicating if the stage change process requires one boiler to be
    enabled while another is disabled"
    annotation (Placement(transformation(extent={{-240,-140},{-200,-100}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexDisBoi
    "Next disabling boiler index"
    annotation (Placement(transformation(extent={{-240,-100},{-200,-60}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexEnaBoi
    "Index of next enabling boiler  when there is any stage down that requires one boiler
    on and another off"
    annotation (Placement(transformation(extent={{-240,180},{-200,220}}),
      iconTransformation(extent={{-140,70},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yBoi[nBoi]
    "Boiler enabling status vector"
    annotation (Placement(transformation(extent={{200,-140},{240,-100}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yBoiDisPro
    "Signal indicating completion of boiler disable process; True: Disable process
    has been completed for the stage change process"
    annotation (Placement(transformation(extent={{200,-70},{240,-30}}),
      iconTransformation(extent={{100,-100},{140,-60}})));

protected
  final parameter Integer boiInd[nBoi]={i for i in 1:nBoi}
    "Boiler index, {1,2,...,n}";

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nBoi]
    "Logical switch"
    annotation (Placement(transformation(extent={{100,190},{120,210}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check for stage change sigal and upstream device status"
    annotation (Placement(transformation(extent={{-160,130},{-140,150}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nBoi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));

  Buildings.Controls.OBC.CDL.Logical.And and1[nBoi]
    "Logical and"
    annotation (Placement(transformation(extent={{-40,190},{-20,210}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[nBoi](
    final k=fill(true, nBoi))
    "True constant"
    annotation (Placement(transformation(extent={{-40,220},{-20,240}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nBoi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greEquThr[nBoi](
    final t=fill(0.5, nBoi))
    "Convert real input to boolean output"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1[nBoi]
    "Logical switch"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));

  Buildings.Controls.OBC.CDL.Logical.And and3[nBoi]
    "Logical and"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nBoi](
    final k=fill(false, nBoi))
    "False constant"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi2[nBoi]
    "Logical switch"
    annotation (Placement(transformation(extent={{160,40},{180,60}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(
    final nout=nBoi)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{-160,190},{-140,210}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nBoi]
    "Check next enabling isolation valve"
    annotation (Placement(transformation(extent={{-100,190},{-80,210}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(t=proOnTim)
    "Count the time after new boiler has been enabled"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam[nBoi]
    "Record the old boiler hot water isolation valve status"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nBoi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge detector"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep2(
    final nout=nBoi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep3(
    final nout=nBoi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nBoi](
    final k=boiInd)
    "Boiler index array"
    annotation (Placement(transformation(extent={{-160,160},{-140,180}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep1(
    final nout=nBoi)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nBoi]
    "Check next enabling isolation valve"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep4(
    final nout=nBoi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-160,-250},{-140,-230}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[nBoi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-160,-220},{-140,-200}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1[nBoi]
    "Record the old boiler hot water isolation valve status"
    annotation (Placement(transformation(extent={{-80,-220},{-60,-200}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep5(
    final nout=nBoi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-120,-250},{-100,-230}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greEquThr1[nBoi](
    final t=fill(0.5, nBoi))
    "Convert real input to boolean output"
    annotation (Placement(transformation(extent={{40,-220},{60,-200}})));

  Buildings.Controls.OBC.CDL.Logical.And and4[nBoi]
    "Logical and"
    annotation (Placement(transformation(extent={{40,-190},{60,-170}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[nBoi](
    final k=fill(false, nBoi))
    "False constant"
    annotation (Placement(transformation(extent={{40,-160},{60,-140}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi3[nBoi]
    "Logical switch"
    annotation (Placement(transformation(extent={{100,-190},{120,-170}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi4[nBoi]
    "Logical switch"
    annotation (Placement(transformation(extent={{160,-130},{180,-110}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep6(
    final nout=nBoi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{100,-130},{120,-110}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi5[nBoi]
    "Logical switch"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi6[nBoi]
    "Logical switch"
    annotation (Placement(transformation(extent={{100,-250},{120,-230}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi7
    "Logical switch"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));

equation
  connect(nexEnaBoi, intRep.u)
    annotation (Line(points={{-220,200},{-162,200}}, color={255,127,0}));

  connect(intRep.y,intEqu. u1)
    annotation (Line(points={{-138,200},{-102,200}}, color={255,127,0}));

  connect(uUpsDevSta, and2.u2) annotation (Line(points={{-220,110},{-170,110},{-170,
          132},{-162,132}}, color={255,0,255}));

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

  connect(uBoi,booToRea. u)
    annotation (Line(points={{-220,60},{-170,60},{-170,100},{-102,100}},
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

  connect(uBoi,logSwi1. u3)
    annotation (Line(points={{-220,60},{-170,60},{-170,-20},{90,-20},{90,2},{98,
          2}}, color={255,0,255}));

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

  connect(nexDisBoi, intRep1.u)
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

  connect(uBoi, booToRea1.u)
    annotation (Line(points={{-220,60},{-170,60},{-170,-210},{-162,-210}},
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
    annotation (Line(points={{-58,-160},{0,-160},{0,-188},{38,-188}},
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

  connect(logSwi4.y,yBoi)
    annotation (Line(points={{182,-120},{220,-120}}, color={255,0,255}));

  connect(booRep.y, logSwi5.u2)
    annotation (Line(points={{-78,140},{-70,140},{-70,-90},{98,-90}},
      color={255,0,255}));

  connect(uBoi, logSwi5.u3)
    annotation (Line(points={{-220,60},{-170,60},{-170,-98},{98,-98}},
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
    annotation (Line(points={{-58,-160},{0,-160},{0,-240},{98,-240}},  color={255,0,255}));

  connect(logSwi3.y, logSwi6.u1)
    annotation (Line(points={{122,-180},{130,-180},{130,-220},{80,-220},
      {80,-232},{98,-232}}, color={255,0,255}));

  connect(uBoi, logSwi6.u3)
    annotation (Line(points={{-220,60},{-170,60},{-170,-180},{-40,-180},{-40,-248},
          {98,-248}},        color={255,0,255}));

  connect(logSwi6.y, logSwi4.u3)
    annotation (Line(points={{122,-240},{140,-240},{140,-128},{158,-128}},
      color={255,0,255}));

  connect(uOnOff, logSwi7.u2)
    annotation (Line(points={{-220,-120},{80,-120},{80,-50},{98,-50}},
      color={255,0,255}));


  connect(and2.y, booRep4.u) annotation (Line(points={{-138,140},{-120,140},{
          -120,-160},{-82,-160}}, color={255,0,255}));

  connect(and2.y, logSwi7.u3) annotation (Line(points={{-138,140},{-120,140},{
          -120,-58},{98,-58}}, color={255,0,255}));

  connect(logSwi7.y, yBoiDisPro)
    annotation (Line(points={{122,-50},{220,-50}}, color={255,0,255}));

  connect(tim.passed, booRep2.u) annotation (Line(points={{-78,-8},{-30,-8},{
          -30,0},{-22,0}}, color={255,0,255}));
  connect(tim.passed, logSwi7.u1) annotation (Line(points={{-78,-8},{-30,-8},{
          -30,-42},{98,-42}}, color={255,0,255}));
  connect(tim.passed, not1.u) annotation (Line(points={{-78,-8},{-30,-8},{-30,
          50},{-22,50}}, color={255,0,255}));
annotation (
  defaultComponentName="disBoi",
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
          textString="nexEnaBoi"),
        Text(
          extent={{-98,70},{-52,56}},
          textColor={255,0,255},
          textString="uStaDow"),
        Text(
          extent={{-96,30},{-24,10}},
          textColor={255,0,255},
          textString="uUpsDevSta"),
        Text(
          extent={{-100,-14},{-78,-24}},
          textColor={255,0,255},
          textString="uBoi"),
        Text(
          extent={{-98,-82},{-70,-94}},
          textColor={255,0,255},
          textString="uOnOff"),
        Text(
          extent={{-98,-40},{-44,-56}},
          textColor={255,127,0},
          textString="nexDisBoi"),
        Text(
          extent={{74,6},{98,-6}},
          textColor={255,0,255},
          textString="yBoi"),
        Text(
          extent={{44,-72},{96,-84}},
          textColor={255,0,255},
          textString="yBoiDis")}),
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
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Enable small boiler"),
          Text(
          extent={{102,-6},{172,-24}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Disable large boiler"),
          Text(
          extent={{-164,-244},{190,-286}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Disable boiler when the down-process does not require any other boiler being disabled"),
          Text(
          extent={{-144,278},{166,258}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString=
              "Disable boiler when the down-process requires small boiler being enabled")}),
Documentation(info="<html>
<p>
Block that controls boiler diabling process when there is stage down command 
<code>uStaDow=true</code>.
This implementation is based on RP-1711, March 2020 draft, sections 5.3.3.12,
5.3.3.16, 5.3.3.17 and 5.3.3.18. These sections specify how to start the
smaller boiler and shut off larger boiler when the stage change requires large
boiler off and smaller boiler on.
In other stage change, when it does not require boiler on/off, the boiler will then
be shut off.
</p>
<p>
When the stage-down process requires a smaller boiler being staged on and a larger
boiler being staged off:
</p>
<ul>
<li>
Start the smaller boiler after the upstream device is proven functional(
<code>uUpsDevSta</code> becomes true).
</li>
<li>
Wait 5 minutes (<code>proOnTim</code>) for the newly enabled boiler to prove that 
it is operating correctly, then shut off the larger boiler.
</li>
</ul>
<p>
If staging-down from any other stage that does not require one boiler off and another
boiler on, then shut off the last stage boiler.
</p>
</html>", revisions="<html>
<ul>
<li>
July 09, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end DisableBoiler;
