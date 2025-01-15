within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences;
block ReduceDemand "Sequence for reducing operating chiller demand"

  parameter Integer nChi=2 "Total number of chillers in the plant";
  parameter Real chiDemRedFac = 0.75
    "Demand reducing factor of current operating chillers";
  parameter Real holChiDemTim(
    final unit="s",
    final quantity="Time") = 300
    "Maximum time to wait for the actual demand less than percentage of current load";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDemLim
    "Demand limit: true=limit chiller demand"
    annotation (Placement(transformation(extent={{-200,170},{-160,210}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiLoa[nChi](
    final quantity=fill("ElectricCurrent", nChi),
    final unit=fill("A", nChi))
    "Current chiller load"
    annotation (Placement(transformation(extent={{-200,140},{-160,180}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yOpeParLoaRatMin(
    final min=0,
    final max=1,
    final unit="1")
    "Current stage minimum cycling operative partial load ratio"
    annotation (Placement(transformation(extent={{-200,0},{-160,40}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow "Stage down status: true=stage-down"
    annotation (Placement(transformation(extent={{-200,-50},{-160,-10}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "True: if the stage change require one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{-200,-90},{-160,-50}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
    annotation (Placement(transformation(extent={{-200,-160},{-160,-120}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiDem[nChi](
    final quantity=fill("ElectricCurrent", nChi),
    final unit=fill("A", nChi))
    "Chiller demand setpoint"
    annotation (Placement(transformation(extent={{160,100},{200,140}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiDemRed
    "Flag: true if it is not requiring reducing demand or the chiller demand reduction process has finished"
    annotation (Placement(transformation(extent={{160,60},{200,100}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

protected
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam[nChi](
    final y_start=fill(1e-6,nChi))
    "Triggered sampler to sample current chiller demand"
    annotation (Placement(transformation(extent={{0,150},{20,170}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-60,180},{-40,200}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi4[nChi]
    "Current setpoint to chillers"
    annotation (Placement(transformation(extent={{120,110},{140,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con[nChi](
    final k=fill(0.2, nChi)) "Constant value to avoid zero as the denominator"
    annotation (Placement(transformation(extent={{-140,-200},{-120,-180}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nChi]
    "Change zero input to a given constant if the chiller is not enabled"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys[nChi](
    final uLow=fill(chiDemRedFac + 0.05 - 0.01, nChi),
    final uHigh=fill(chiDemRedFac + 0.05 + 0.01, nChi))
    "Check if actual demand has already reduced at instant when receiving stage change signal"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div[nChi]
    "Output result of first input divided by second input"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1[nChi] "Logical not"
    annotation (Placement(transformation(extent={{40,-150},{60,-130}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(final nin=nChi)
    "Current chillers demand have been lower than 80%"
    annotation (Placement(transformation(extent={{80,-150},{100,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-100,180},{-80,200}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nChi)
    "Replicate boolean input "
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Buildings.Controls.OBC.CDL.Logical.And finRedDem
    "Demand reducing process is done"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Minimum cycling operative partial load ratio"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2(
    final k=chiDemRedFac)
    "Demand reducing factor of current operating chillers"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Controls.OBC.CDL.Reals.Max max "Maximum value of two real inputs"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(final nout=nChi)
    "Replicate real input"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro[nChi]
    "Percentage of the current load"
    annotation (Placement(transformation(extent={{80,150},{100,170}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar[nChi](
    final p=fill(1e-6, nChi))
    "Add a small value to avoid potentially zero denominator"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=holChiDemTim)
    "Check if the demand limit has been 5 minutes"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logical or"
    annotation (Placement(transformation(extent={{120,-110},{140,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Not requiring reducing demand"
    annotation (Placement(transformation(extent={{120,70},{140,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not notReqRed
    "Not requiring reduce demand"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Buildings.Controls.OBC.CDL.Logical.Or notRed
    "Not requiring reducing demand"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));

equation
  connect(booRep.y, triSam.trigger)
    annotation (Line(points={{-38,190},{-20,190},{-20,140},{10,140},{10,148}},
      color={255,0,255}));
  connect(uChiLoa, triSam.u)
    annotation (Line(points={{-180,160},{-2,160}}, color={0,0,127}));
  connect(uChiLoa, swi4.u3)
    annotation (Line(points={{-180,160},{-140,160},{-140,112},{118,112}}, color={0,0,127}));
  connect(uChi, swi.u2)
    annotation (Line(points={{-180,-140},{-82,-140}}, color={255,0,255}));
  connect(con.y, swi.u3)
    annotation (Line(points={{-118,-190},{-100,-190},{-100,-148},{-82,-148}},
      color={0,0,127}));
  connect(swi.y, div.u2)
    annotation (Line(points={{-58,-140},{-50,-140},{-50,-146},{-42,-146}},
      color={0,0,127}));
  connect(uChiLoa, div.u1)
    annotation (Line(points={{-180,160},{-140,160},{-140,-110},{-50,-110},{-50,-134},
          {-42,-134}}, color={0,0,127}));
  connect(div.y, hys.u)
    annotation (Line(points={{-18,-140},{-2,-140}}, color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{22,-140},{38,-140}},  color={255,0,255}));
  connect(not1.y, mulAnd.u)
    annotation (Line(points={{62,-140},{78,-140}}, color={255,0,255}));
  connect(swi4.y,yChiDem)
    annotation (Line(points={{142,120},{180,120}}, color={0,0,127}));
  connect(uDemLim, edg.u)
    annotation (Line(points={{-180,190},{-102,190}}, color={255,0,255}));
  connect(edg.y, booRep.u)
    annotation (Line(points={{-78,190},{-62,190}},   color={255,0,255}));
  connect(uDemLim, booRep1.u)
    annotation (Line(points={{-180,190},{-120,190},{-120,130},{-102,130}},
      color={255,0,255}));
  connect(booRep1.y, swi4.u2)
    annotation (Line(points={{-78,130},{-40,130},{-40,120},{118,120}},
      color={255,0,255}));
  connect(uDemLim, finRedDem.u1) annotation (Line(points={{-180,190},{-120,190},
          {-120,30},{118,30}}, color={255,0,255}));
  connect(uStaDow, and1.u1)
    annotation (Line(points={{-180,-30},{-102,-30}}, color={255,0,255}));
  connect(uOnOff, and1.u2)
    annotation (Line(points={{-180,-70},{-130,-70},{-130,-38},{-102,-38}},
      color={255,0,255}));
  connect(yOpeParLoaRatMin, swi1.u1)
    annotation (Line(points={{-180,20},{-60,20},{-60,-22},{-42,-22}},
      color={0,0,127}));
  connect(and1.y, swi1.u2)
    annotation (Line(points={{-78,-30},{-42,-30}}, color={255,0,255}));
  connect(con1.y, swi1.u3)
    annotation (Line(points={{-78,-60},{-60,-60},{-60,-38},{-42,-38}},
      color={0,0,127}));
  connect(swi1.y, max.u2)
    annotation (Line(points={{-18,-30},{-10,-30},{-10,-6},{-2,-6}}, color={0,0,127}));
  connect(con2.y, max.u1)
    annotation (Line(points={{-18,10},{-10,10},{-10,6},{-2,6}},
      color={0,0,127}));
  connect(max.y, reaRep.u)
    annotation (Line(points={{22,0},{58,0}}, color={0,0,127}));
  connect(triSam.y, pro.u1)
    annotation (Line(points={{22,160},{40,160},{40,166},{78,166}},
      color={0,0,127}));
  connect(reaRep.y, pro.u2)
    annotation (Line(points={{82,0},{90,0},{90,130},{60,130},{60,154},{78,154}},
      color={0,0,127}));
  connect(pro.y, swi4.u1)
    annotation (Line(points={{102,160},{110,160},{110,128},{118,128}},
      color={0,0,127}));
  connect(triSam.y, addPar.u)
    annotation (Line(points={{22,160},{40,160},{40,-50},{58,-50}},
      color={0,0,127}));
  connect(addPar.y, swi.u1)
    annotation (Line(points={{82,-50},{100,-50},{100,-82},{-100,-82},{-100,-132},
          {-82,-132}}, color={0,0,127}));
  connect(uDemLim, tim.u)
    annotation (Line(points={{-180,190},{-120,190},{-120,-100},{-42,-100}},
      color={255,0,255}));
  connect(mulAnd.y, or2.u2)
    annotation (Line(points={{102,-140},{110,-140},{110,-108},{118,-108}},
      color={255,0,255}));
  connect(or2.y, finRedDem.u2) annotation (Line(points={{142,-100},{150,-100},{150,
          -30},{100,-30},{100,22},{118,22}}, color={255,0,255}));
  connect(tim.passed, or2.u1)
    annotation (Line(points={{-18,-108},{40,-108},{40,-100},{118,-100}},
      color={255,0,255}));
  connect(edg.y, lat.clr) annotation (Line(points={{-78,190},{-70,190},{-70,74},
          {118,74}}, color={255,0,255}));
  connect(uDemLim, notReqRed.u) annotation (Line(points={{-180,190},{-120,190},{
          -120,90},{-62,90}}, color={255,0,255}));
  connect(notReqRed.y, notRed.u1)
    annotation (Line(points={{-38,90},{-2,90}}, color={255,0,255}));
  connect(finRedDem.y, notRed.u2) annotation (Line(points={{142,30},{150,30},{150,
          50},{-20,50},{-20,82},{-2,82}}, color={255,0,255}));
  connect(notRed.y, lat.u) annotation (Line(points={{22,90},{60,90},{60,80},{118,
          80}}, color={255,0,255}));
  connect(lat.y, yChiDemRed)
    annotation (Line(points={{142,80},{180,80}}, color={255,0,255}));
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
          extent={{-23,8.5},{23,-8.5}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={-75,10.5},
          rotation=0,
          textString="yOpeParLoaRatMin")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-220},{160,220}})),
  Documentation(info="<html>
<p>
Block that reduces demand of current operating chillers when there is a stage-up
command, according to ASHRAE Guideline36-2021,
section 5.20.4.16, item a which specifies how to start the stage-up
process of the current operating chillers; and section 5.20.4.17, item a.1 which specifies
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
