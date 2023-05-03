within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences;
block ReduceDemand "Sequence for reducing operating chiller demand"

  parameter Integer nChi=2 "Total number of chillers in the plant";
  parameter Real chiDemRedFac = 0.75
    "Demand reducing factor of current operating chillers";
  parameter Real holChiDemTim(
    final unit="s",
    final quantity="Time",
    displayUnit="h") = 300
    "Maximum time to wait for the actual demand less than percentage of current load";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDemLim
    "Demand limit: true=limit chiller demand"
    annotation (Placement(transformation(extent={{-200,140},{-160,180}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiLoa[nChi](
    final quantity=fill("ElectricCurrent", nChi),
    final unit=fill("A", nChi))
    "Current chiller load"
    annotation (Placement(transformation(extent={{-200,110},{-160,150}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yOpeParLoaRatMin(
    final min=0,
    final max=1,
    final unit="1")
    "Current stage minimum cycling operative partial load ratio"
    annotation (Placement(transformation(extent={{-200,20},{-160,60}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow "Stage down status: true=stage-down"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "True: if the stage change require one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
    annotation (Placement(transformation(extent={{-200,-130},{-160,-90}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiDem[nChi](
    final quantity=fill("ElectricCurrent", nChi),
    final unit=fill("A", nChi))
    "Chiller demand setpoint"
    annotation (Placement(transformation(extent={{160,70},{200,110}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiDemRed
    "Indicate if the chiller demand reduction process has finished"
    annotation (Placement(transformation(extent={{160,30},{200,70}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

protected
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam[nChi](
    final y_start=fill(1e-6,nChi))
    "Triggered sampler to sample current chiller demand"
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi4[nChi]
    "Current setpoint to chillers"
    annotation (Placement(transformation(extent={{120,80},{140,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[nChi](
    final k=fill(0.2, nChi)) "Constant value to avoid zero as the denominator"
    annotation (Placement(transformation(extent={{-140,-170},{-120,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi[nChi]
    "Change zero input to a given constant if the chiller is not enabled"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys[nChi](
    final uLow=fill(chiDemRedFac + 0.05 - 0.01, nChi),
    final uHigh=fill(chiDemRedFac + 0.05 + 0.01, nChi))
    "Check if actual demand has already reduced at instant when receiving stage change signal"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div[nChi]
    "Output result of first input divided by second input"
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1[nChi] "Logical not"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(final nin=nChi)
    "Current chillers demand have been lower than 80%"
    annotation (Placement(transformation(extent={{80,-120},{100,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nChi)
    "Replicate boolean input "
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{120,40},{140,60}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Minimum cycling operative partial load ratio"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(
    final k=chiDemRedFac)
    "Demand reducing factor of current operating chillers"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max "Maximum value of two real inputs"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(final nout=nChi)
    "Replicate real input"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro[nChi]
    "Percentage of the current load"
    annotation (Placement(transformation(extent={{80,120},{100,140}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar[nChi](
    final p=fill(1e-6, nChi))
    "Add a small value to avoid potentially zero denominator"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=holChiDemTim)
    "Check if the demand limit has been 5 minutes"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logical or"
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));

equation
  connect(booRep.y, triSam.trigger)
    annotation (Line(points={{-38,160},{-20,160},{-20,110},{10,110},{10,118}},
      color={255,0,255}));
  connect(uChiLoa, triSam.u)
    annotation (Line(points={{-180,130},{-2,130}}, color={0,0,127}));
  connect(uChiLoa, swi4.u3)
    annotation (Line(points={{-180,130},{-140,130},{-140,82},{118,82}}, color={0,0,127}));
  connect(uChi, swi.u2)
    annotation (Line(points={{-180,-110},{-82,-110}}, color={255,0,255}));
  connect(con.y, swi.u3)
    annotation (Line(points={{-118,-160},{-100,-160},{-100,-118},{-82,-118}},
      color={0,0,127}));
  connect(swi.y, div.u2)
    annotation (Line(points={{-58,-110},{-50,-110},{-50,-116},{-42,-116}},
      color={0,0,127}));
  connect(uChiLoa, div.u1)
    annotation (Line(points={{-180,130},{-140,130},{-140,-80},{-50,-80},
      {-50,-104},{-42,-104}}, color={0,0,127}));
  connect(div.y, hys.u)
    annotation (Line(points={{-18,-110},{-2,-110}}, color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{22,-110},{38,-110}},  color={255,0,255}));
  connect(not1.y, mulAnd.u)
    annotation (Line(points={{62,-110},{78,-110}}, color={255,0,255}));
  connect(swi4.y,yChiDem)
    annotation (Line(points={{142,90},{180,90}}, color={0,0,127}));
  connect(uDemLim, edg.u)
    annotation (Line(points={{-180,160},{-102,160}}, color={255,0,255}));
  connect(edg.y, booRep.u)
    annotation (Line(points={{-78,160},{-62,160}},   color={255,0,255}));
  connect(uDemLim, booRep1.u)
    annotation (Line(points={{-180,160},{-120,160},{-120,100},{-82,100}},
      color={255,0,255}));
  connect(booRep1.y, swi4.u2)
    annotation (Line(points={{-58,100},{-40,100},{-40,90},{118,90}},
      color={255,0,255}));
  connect(uDemLim, and2.u1)
    annotation (Line(points={{-180,160},{-120,160},{-120,50},{118,50}},
      color={255,0,255}));
  connect(and2.y, yChiDemRed)
    annotation (Line(points={{142,50},{180,50}}, color={255,0,255}));
  connect(uStaDow, and1.u1)
    annotation (Line(points={{-180,0},{-102,0}}, color={255,0,255}));
  connect(uOnOff, and1.u2)
    annotation (Line(points={{-180,-40},{-130,-40},{-130,-8},{-102,-8}},
      color={255,0,255}));
  connect(yOpeParLoaRatMin, swi1.u1)
    annotation (Line(points={{-180,40},{-60,40},{-60,8},{-42,8}},
      color={0,0,127}));
  connect(and1.y, swi1.u2)
    annotation (Line(points={{-78,0},{-42,0}}, color={255,0,255}));
  connect(con1.y, swi1.u3)
    annotation (Line(points={{-78,-30},{-60,-30},{-60,-8},{-42,-8}},
      color={0,0,127}));
  connect(swi1.y, max.u2)
    annotation (Line(points={{-18,0},{-10,0},{-10,14},{-2,14}}, color={0,0,127}));
  connect(con2.y, max.u1)
    annotation (Line(points={{-18,30},{-10,30},{-10,26},{-2,26}},
      color={0,0,127}));
  connect(max.y, reaRep.u)
    annotation (Line(points={{22,20},{58,20}}, color={0,0,127}));
  connect(triSam.y, pro.u1)
    annotation (Line(points={{22,130},{40,130},{40,136},{78,136}},
      color={0,0,127}));
  connect(reaRep.y, pro.u2)
    annotation (Line(points={{82,20},{90,20},{90,100},{60,100},{60,124},{78,124}},
      color={0,0,127}));
  connect(pro.y, swi4.u1)
    annotation (Line(points={{102,130},{110,130},{110,98},{118,98}},
      color={0,0,127}));
  connect(triSam.y, addPar.u)
    annotation (Line(points={{22,130},{40,130},{40,-20},{58,-20}},
      color={0,0,127}));
  connect(addPar.y, swi.u1)
    annotation (Line(points={{82,-20},{100,-20},{100,-52},{-100,-52},{-100,-102},
      {-82,-102}}, color={0,0,127}));
  connect(uDemLim, tim.u)
    annotation (Line(points={{-180,160},{-120,160},{-120,-70},{-42,-70}},
      color={255,0,255}));
  connect(mulAnd.y, or2.u2)
    annotation (Line(points={{102,-110},{110,-110},{110,-78},{118,-78}},
      color={255,0,255}));
  connect(or2.y, and2.u2)
    annotation (Line(points={{142,-70},{150,-70},{150,0},{100,0},{100,42},
      {118,42}}, color={255,0,255}));
  connect(tim.passed, or2.u1)
    annotation (Line(points={{-18,-78},{40,-78},{40,-70},{118,-70}},
      color={255,0,255}));

annotation (
  defaultComponentName="chiDemRed",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-60,60},{60,20}},
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
          extent={{-60,0},{60,-80}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-15,9.5},{15,-9.5}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={-83,49.5},
          rotation=0,
          textString="uChiLoa"),
        Text(
          extent={{-98,98},{-66,86}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uDemLim"),
        Text(
          extent={{-18,6.5},{18,-6.5}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={78,42.5},
          rotation=0,
          textString="yChiDem"),
        Text(
          extent={{46,-34},{96,-46}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yChiDemRed"),
        Text(
          extent={{-100,-84},{-76,-94}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChi"),
        Text(
          extent={{-98,-42},{-74,-56}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOnOff"),
        Text(
          extent={{-98,-12},{-64,-28}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uStaDow"),
        Text(
          extent={{-17,9.5},{17,-9.5}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={-81,11.5},
          rotation=0,
          textString="yOpeParLoaRatMin")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-180},{160,180}})),
  Documentation(info="<html>
<p>
Block that reduces demand of current operating chillers when there is a stage-up
command, according to ASHRAE RP-1711 Advanced Sequences of Operation for 
HVAC Systems Phase II – Central Plants and Hydronic Systems (Draft on March 23, 2020),
section 5.2.4.16, item 1 which specifies how to start the stage-up
process of the current operating chillers; and section 5.2.4.17, item 1.a which specifies
how to start the stage-down process of the current operating chiller when the 
stage-down process requires one chiller off and another chiller on.
</p>
<p>
When there is a stage-up command, 
</p>
<ul>
<li>
Command operating chillers to reduce demand to <code>chiDemRedFac</code> of 
their current load, e.g. 75%.
</li>
<li>
Wait until actual demand &lt; 80% of current load up to a maximum of 
<code>holChiDemTim</code> (e.g. 5 minutes) before proceeding.
</li>
</ul>
<p>
When there is a stage-down command (<code>uStaDow=true</code>) and the process
requires a smaller chiller being enabled and a larger chiller being disabled 
(<code>uOnOff=true</code>),
</p>
<ul>
<li>
Command operating chillers to reduce demand to <code>chiDemRedFac</code> of 
their current load, e.g. 75% or a percentage equal to current stage
minimum cycling operative partial load ratio <code>yOpeParLoaRatMin</code>, whichever is 
greater.
</li>
<li>
Wait until actual demand &lt; 80% of current load up to a maximum of 
<code>holChiDemTim</code> (e.g. 5 minutes) before proceeding.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
September 17, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReduceDemand;
