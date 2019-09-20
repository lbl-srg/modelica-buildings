within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences;
block ReduceDemand "Sequence for reducing operating chiller demand"

  parameter Integer nChi = 2 "Total number of chillers in the plant";
  parameter Real chiDemRedFac = 0.75
    "Demand reducing factor of current operating chillers";
  parameter Modelica.SIunits.Time holChiDemTim = 300
    "Time of actual demand less than percentage of currnet load";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDemLim
    "Demand limit: true=limit chiller demand"
    annotation (Placement(transformation(extent={{-200,140},{-160,180}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiLoa[nChi](
    final quantity=fill("HeatFlowRate", nChi),
    final unit=fill("W", nChi)) "Current chiller load"
    annotation (Placement(transformation(extent={{-200,110},{-160,150}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput minOPLR(
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
    "Indicate if the stage require one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
     annotation (Placement(transformation(extent={{-200,-130},{-160,-90}}),
       iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiDem[nChi](
    final quantity=fill("HeatFlowRate", nChi),
    final unit=fill("W", nChi)) "Chiller demand setpoint"
    annotation (Placement(transformation(extent={{160,70},{200,110}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiDemRed
    "Indicate if the chiller demand reduction process has finished"
    annotation (Placement(transformation(extent={{160,30},{200,70}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

protected
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam[nChi]
    "Triggered sampler to sample current chiller demand"
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=nChi)
    "Replicate boolean input "
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi4[nChi]
    "Current setpoint to chillers"
    annotation (Placement(transformation(extent={{120,80},{140,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[nChi](
    final k=fill(0.2, nChi)) "Constant value to avoid zero as the denominator"
    annotation (Placement(transformation(extent={{-140,-170},{-120,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi[nChi]
    "Change zero input to a given constant if the chiller is not enabled"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys[nChi](
    final uLow=fill(chiDemRedFac + 0.05 - 0.01, nChi),
    final uHigh=fill(chiDemRedFac + 0.05 + 0.01, nChi))
    "Check if actual demand has already reduced at instant when receiving stage change signal"
    annotation (Placement(transformation(extent={{-40,-170},{-20,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div[nChi]
    "Output result of first input divided by second input"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1[nChi] "Logical not"
    annotation (Placement(transformation(extent={{0,-170},{20,-150}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(final nu=nChi)
    "Output true when elements of input vector are true"
    annotation (Placement(transformation(extent={{40,-170},{60,-150}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=holChiDemTim)
    "Wait a giving time before proceeding"
    annotation (Placement(transformation(extent={{80,-170},{100,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(final nout=nChi)
    "Replicate boolean input "
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{120,40},{140,60}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
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
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(final nout=nChi)
    "Replicate real input"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro[nChi]
    "Percentage of the current load"
    annotation (Placement(transformation(extent={{80,120},{100,140}})));

equation
  connect(booRep.y, triSam.trigger)
    annotation (Line(points={{-38,160},{-20,160},{-20,110},{10,110},{10,118.2}},
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
  connect(triSam.y, swi.u1)
    annotation (Line(points={{22,130},{40,130},{40,-60},{-100,-60},{-100,-102},
      {-82,-102}},
      color={0,0,127}));
  connect(swi.y, div.u2)
    annotation (Line(points={{-58,-110},{-40,-110},{-40,-116},{-22,-116}},
      color={0,0,127}));
  connect(uChiLoa, div.u1)
    annotation (Line(points={{-180,130},{-140,130},{-140,-80},{-40,-80},
      {-40,-104},{-22,-104}}, color={0,0,127}));
  connect(div.y, hys.u)
    annotation (Line(points={{2,-110},{20,-110},{20,-130},{-60,-130},{-60,-160},
      {-42,-160}}, color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{-18,-160},{-2,-160}}, color={255,0,255}));
  connect(not1.y, mulAnd.u)
    annotation (Line(points={{22,-160},{38,-160}}, color={255,0,255}));
  connect(mulAnd.y, truDel.u)
    annotation (Line(points={{62,-160},{78,-160}},   color={255,0,255}));
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
  connect(truDel.y, and2.u2)
    annotation (Line(points={{102,-160},{110,-160},{110,42},{118,42}},
      color={255,0,255}));
  connect(and2.y, yChiDemRed)
    annotation (Line(points={{142,50},{180,50}}, color={255,0,255}));
  connect(uStaDow, and1.u1)
    annotation (Line(points={{-180,0},{-102,0}}, color={255,0,255}));
  connect(uOnOff, and1.u2)
    annotation (Line(points={{-180,-40},{-120,-40},{-120,-8},{-102,-8}},
      color={255,0,255}));
  connect(minOPLR, swi1.u1)
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
          lineColor={0,0,255},
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
          extent={{-21,9.5},{21,-9.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={-77,51.5},
          rotation=0,
          textString="uChiLoa"),
        Text(
          extent={{-98,100},{-54,84}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uDemLim"),
        Text(
          extent={{-21,9.5},{21,-9.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={75,41.5},
          rotation=0,
          textString="yChiDem"),
        Text(
          extent={{30,-30},{96,-46}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yChiDemRed"),
        Text(
          extent={{-100,-82},{-72,-96}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChi"),
        Text(
          extent={{-98,-40},{-64,-56}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOnOff"),
        Text(
          extent={{-100,-10},{-56,-30}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uStaDow"),
        Text(
          extent={{-21,9.5},{21,-9.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={-77,13.5},
          rotation=0,
          textString="minOPLR")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-180},{160,180}})),
  Documentation(info="<html>
<p>
Block that reduces demand of current operating chillers when there is a stage-up
command, according to ASHRAE RP-1711 Advanced Sequences of Operation for 
HVAC Systems Phase II – Central Plants and Hydronic Systems (Draft 6 on 
July 25, 2019), section 5.2.4.15, item 1 which specifies how to start the stage-up
process of the current operating chillers; and section 5.2.4.16, item 1.a which specifies
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
requires one chiller being enabled and another chiller being disabled 
(<code>uOnOff=true</code>),
</p>
<ul>
<li>
Command operating chillers to reduce demand to <code>chiDemRedFac</code> of 
their current load, e.g. 75% or a percentage equal to current stage
minimum cycling operative partial load ratio <code>minOPLR</code>, whichever is 
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
