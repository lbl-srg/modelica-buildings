within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences;
block ReduceDemand "Sequence for reducing operating chiller demand"

  parameter Integer nChi = 2 "Total number of chillers in the plant";
  parameter Real chiDemRedFac = 0.75
    "Demand reducing factor of current operating chillers";
  parameter Modelica.SIunits.Time holChiDemTim = 300
    "Time of actual demand less than center percentage of currnet load";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiLoa[nChi](
    each final quantity="HeatFlowRate",
    each final unit="W") "Current chiller load"
    annotation (Placement(transformation(extent={{-200,60},{-160,100}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
     annotation (Placement(transformation(extent={{-200,-70},{-160,-30}}),
       iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDemLim
    "Demand limit: true=limit chiller demand"
    annotation (Placement(transformation(extent={{-200,90},{-160,130}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiDem[nChi](
    each final quantity="HeatFlowRate",
    each final unit="W") "Chiller demand setpoint"
    annotation (Placement(transformation(extent={{160,30},{180,50}}),
      iconTransformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiDemRed
    "Indicate if the chiller demand reduction process has finished"
    annotation (Placement(transformation(extent={{160,-10},{180,10}}),
      iconTransformation(extent={{100,-50},{120,-30}})));

protected
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam[nChi]
    "Triggered sampler to sample current chiller demand"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=nChi)
    "Replicate boolean input "
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi4[nChi]
    "Current setpoint to chillers"
    annotation (Placement(transformation(extent={{120,30},{140,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai[nChi](
    each final k=chiDemRedFac)
    "Reduce demand to a factor of current load"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[nChi](
    each final k=0.2)
    "Constant value to avoid zero as the denominator"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi[nChi]
    "Change zero input to a given constant if the chiller is not enabled"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys[nChi](
    each final uLow=chiDemRedFac + 0.5 - 0.1,
    each final uHigh=chiDemRedFac + 0.5 + 0.1)
    "Check if actual demand has already reduced at instant when receiving stage change signal"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div[nChi]
    "Output result of first input divided by second input"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1[nChi] "Logical not"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(final nu=nChi)
    "Output true when elements of input vector are true"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=holChiDemTim)
    "Wait a giving time before proceeding"
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(final nout=nChi)
    "Replicate boolean input "
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));

equation
  connect(booRep.y, triSam.trigger)
    annotation (Line(points={{-38,110},{-20,110},{-20,60},{10,60},{10,68.2}},
      color={255,0,255}));
  connect(uChiLoa, triSam.u)
    annotation (Line(points={{-180,80},{-2,80}}, color={0,0,127}));
  connect(triSam.y, gai.u)
    annotation (Line(points={{22,80},{58,80}}, color={0,0,127}));
  connect(uChiLoa, swi4.u3)
    annotation (Line(points={{-180,80},{-140,80},{-140,32},{118,32}},color={0,0,127}));
  connect(gai.y, swi4.u1)
    annotation (Line(points={{82,80},{100,80},{100,48},{118,48}},
      color={0,0,127}));
  connect(uChi, swi.u2)
    annotation (Line(points={{-180,-50},{-82,-50}}, color={255,0,255}));
  connect(con.y, swi.u3)
    annotation (Line(points={{-118,-100},{-100,-100},{-100,-58},{-82,-58}},
      color={0,0,127}));
  connect(triSam.y, swi.u1)
    annotation (Line(points={{22,80},{40,80},{40,20},{-100,20},{-100,-42},{-82,
          -42}},
      color={0,0,127}));
  connect(swi.y, div.u2)
    annotation (Line(points={{-58,-50},{-40,-50},{-40,-56},{-22,-56}},
      color={0,0,127}));
  connect(uChiLoa, div.u1)
    annotation (Line(points={{-180,80},{-140,80},{-140,-20},{-40,-20},
      {-40,-44},{-22,-44}}, color={0,0,127}));
  connect(div.y, hys.u)
    annotation (Line(points={{2,-50},{20,-50},{20,-70},{-60,-70},{-60,-100},{
          -42,-100}},         color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{-18,-100},{-2,-100}}, color={255,0,255}));
  connect(not1.y, mulAnd.u)
    annotation (Line(points={{22,-100},{38,-100}}, color={255,0,255}));
  connect(mulAnd.y, truDel.u)
    annotation (Line(points={{62,-100},{78,-100}},   color={255,0,255}));
  connect(swi4.y,yChiDem)
    annotation (Line(points={{142,40},{170,40}}, color={0,0,127}));
  connect(uDemLim, edg.u)
    annotation (Line(points={{-180,110},{-102,110}}, color={255,0,255}));
  connect(edg.y, booRep.u)
    annotation (Line(points={{-78,110},{-62,110}},   color={255,0,255}));
  connect(uDemLim, booRep1.u) annotation (Line(points={{-180,110},{-120,110},{-120,
          50},{-82,50}}, color={255,0,255}));
  connect(booRep1.y, swi4.u2)
    annotation (Line(points={{-58,50},{-40,50},{-40,40},{118,40}},
      color={255,0,255}));
  connect(uDemLim, and2.u1) annotation (Line(points={{-180,110},{-120,110},{-120,
          0},{118,0}}, color={255,0,255}));
  connect(truDel.y, and2.u2) annotation (Line(points={{102,-100},{110,-100},{
          110,-8},{118,-8}},
                         color={255,0,255}));
  connect(and2.y, yChiDemRed)
    annotation (Line(points={{142,0},{170,0}}, color={255,0,255}));

annotation (
  defaultComponentName="chiDemRed",
  Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-15,6.5},{15,-6.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={-85,-57.5},
          rotation=0,
          textString="uChi"),
        Text(
          extent={{-21,9.5},{21,-9.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={-77,1.5},
          rotation=0,
          textString="uChiCur"),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,70},{-54,54}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uStaUp"),
        Text(
          extent={{-21,9.5},{21,-9.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={75,41.5},
          rotation=0,
          textString="yChiCur"),
        Text(
          extent={{30,-30},{96,-46}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yChiDemRed")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-140},{160,140}})),
  Documentation(info="<html>
<p>
Block that reduces demand of current operating chillers when there is a stage-up
command, according to ASHRAE RP-1711 Advanced Sequences of Operation for 
HVAC Systems Phase II – Central Plants and Hydronic Systems (Draft 4 on 
January 7, 2019), section 5.2.4.18, part 5.2.4.18.1.
It is for primary-only parallel chiller plants with headered chilled water pumps
and headered condenser water pumps.
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

</html>",
revisions="<html>
<ul>
<li>
January 31, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReduceDemand;
