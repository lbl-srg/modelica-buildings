within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences;
block CHWIsoVal_New
  "Sequence of enable or disable chilled water isolation valve"

  parameter Integer nChi=2
    "Total number of chiller, which is also the total number of chilled water isolation valve";
  parameter Real chaChiWatIsoTim(
    final unit="s",
    final quantity="Time")
    "Time to slowly change isolation valve, should be determined in the field";
  parameter Real iniValPos
    "Initial valve position, if it needs to turn on chiller, the value should be 0";
  parameter Real endValPos
    "Ending valve position, if it needs to turn on chiller, the value should be 1";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexChaChi
    "Index of next chiller that should change status"
    annotation (Placement(transformation(extent={{-200,200},{-160,240}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Status of resetting status of device before enabling or disabling isolation valve"
    annotation (Placement(transformation(extent={{-200,-170},{-160,-130}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaPro
    "Indicate if there is a stage up or stage down command"
    annotation (Placement(transformation(extent={{-200,-210},{-160,-170}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  CDL.Interfaces.BooleanOutput y1ChiWatIsoVal[nChi]
    "Chiller chilled water isolation valve command" annotation (Placement(
        transformation(extent={{180,-60},{220,-20}}), iconTransformation(extent
          ={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEnaChiWatIsoVal
    "Status of chilled water isolation valve control: true=enabled valve is fully open"
    annotation (Placement(transformation(extent={{180,120},{220,160}}),
      iconTransformation(extent={{100,40},{140,80}})));

protected
  final parameter Integer chiInd[nChi]={i for i in 1:nChi}
    "Chiller index, {1,2,...,n}";
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=chaChiWatIsoTim)
    "Count the time after changing up-stream device status"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-100,-160},{-80,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{20,-200},{40,-180}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam[nChi]
    "Record the old chiller chilled water isolation valve status"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if it is time to change isolation valve position"
    annotation (Placement(transformation(extent={{-40,-160},{-20,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-40,-206},{-20,-186}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{60,-200},{80,-180}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2[nChi] "Logical not"
    annotation (Placement(transformation(extent={{120,-200},{140,-180}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nChi]
    "Check next enabling isolation valve"
    annotation (Placement(transformation(extent={{-20,210},{0,230}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(
    final nout=nChi)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{-80,210},{-60,230}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Check if the isolation valve has been fully open"
    annotation (Placement(transformation(extent={{100,130},{120,150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nChi](
    final k=chiInd) "Chiller index array"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=5) "Delay the true input"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Logical and"
    annotation (Placement(transformation(extent={{140,130},{160,150}})));
  CDL.Conversions.BooleanToReal cloVal[nChi] if have_isoValEndSwi
    "1: valve is fully closed"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  CDL.Conversions.BooleanToReal opeVal[nChi] if have_isoValEndSwi
    "1: valve is fully open"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));

public
  CDL.Interfaces.BooleanInput u1ChiIsoOpe[nChi] if have_isoValEndSwi
    "Chiller chilled water isolation valve open end switch. True: the valve is fully open"
    annotation (Placement(transformation(extent={{-200,-40},{-160,0}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  CDL.Interfaces.BooleanInput u1ChiIsoClo[nChi] if have_isoValEndSwi
    "Chiller chilled water isolation valve close end switch. True: the valve is fully closed"
    annotation (Placement(transformation(extent={{-200,-90},{-160,-50}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  CDL.Interfaces.BooleanInput                        uChi[nChi]
    "Chiller status: true=ON"
    annotation (Placement(transformation(extent={{-200,0},{-160,40}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
equation
  connect(uUpsDevSta, edg.u)
    annotation (Line(points={{-180,-150},{-102,-150}}, color={255,0,255}));
  connect(uStaPro, and2.u2)
    annotation (Line(points={{-180,-190},{-60,-190},{-60,-158},{-42,-158}},
          color={255,0,255}));
  connect(edg.y, and2.u1)
    annotation (Line(points={{-78,-150},{-42,-150}}, color={255,0,255}));
  connect(and2.y, lat.u)
    annotation (Line(points={{-18,-150},{0,-150},{0,-190},{18,-190}},
          color={255,0,255}));
  connect(uStaPro, not1.u) annotation (Line(points={{-180,-190},{-60,-190},{-60,
          -196},{-42,-196}}, color={255,0,255}));
  connect(not1.y, lat.clr)
    annotation (Line(points={{-18,-196},{18,-196}},
      color={255,0,255}));
  connect(lat.y, booRep1.u)
    annotation (Line(points={{42,-190},{58,-190}}, color={255,0,255}));
  connect(booRep.y, triSam.trigger)
    annotation (Line(points={{42,-150},{60,-150},{60,-120},{-30,-120},{-30,-82}},
      color={255,0,255}));
  connect(and2.y, booRep.u)
    annotation (Line(points={{-18,-150},{18,-150}},
      color={255,0,255}));
  connect(booRep1.y, not2.u)
    annotation (Line(points={{82,-190},{118,-190}},
                           color={255,0,255}));
  connect(nexChaChi, intRep.u)
    annotation (Line(points={{-180,220},{-82,220}},
                                                color={255,127,0}));
  connect(intRep.y, intEqu.u1)
    annotation (Line(points={{-58,220},{-22,220}},
                                               color={255,127,0}));
  connect(lat.y, tim.u)
    annotation (Line(points={{42,-190},{50,-190},{50,-220},{-110,-220},{-110,60},
          {-102,60}}, color={255,0,255}));
  connect(conInt.y, intEqu.u2)
    annotation (Line(points={{-58,180},{-40,180},{-40,212},{-22,212}},
      color={255,127,0}));
  connect(lat1.y, and5.u2)
    annotation (Line(points={{22,140},{80,140},{80,132},{98,132}},
      color={255,0,255}));
  connect(uUpsDevSta, lat1.u) annotation (Line(points={{-180,-150},{-130,-150},
          {-130,140},{-2,140}}, color={255,0,255}));
  connect(not1.y, truDel.u) annotation (Line(points={{-18,-196},{0,-196},{0,
          -230},{-120,-230},{-120,100},{-102,100}}, color={255,0,255}));
  connect(truDel.y, lat1.clr) annotation (Line(points={{-78,100},{-70,100},{-70,
          134},{-2,134}},  color={255,0,255}));
  connect(tim.passed, lat2.u) annotation (Line(points={{-78,52},{-60,52},{-60,
          110},{-2,110}},  color={255,0,255}));
  connect(truDel.y, lat2.clr) annotation (Line(points={{-78,100},{-70,100},{-70,
          104},{-2,104}},  color={255,0,255}));
  connect(and5.y, and1.u1)
    annotation (Line(points={{122,140},{138,140}}, color={255,0,255}));
  connect(and1.y, yEnaChiWatIsoVal)
    annotation (Line(points={{162,140},{200,140}}, color={255,0,255}));
  connect(lat2.y, and1.u2) annotation (Line(points={{22,110},{130,110},{130,132},
          {138,132}},      color={255,0,255}));
  connect(u1ChiIsoOpe, opeVal.u)
    annotation (Line(points={{-180,-20},{-102,-20}}, color={255,0,255}));
  connect(u1ChiIsoClo, cloVal.u)
    annotation (Line(points={{-180,-70},{-102,-70}}, color={255,0,255}));
annotation (
  defaultComponentName="enaChiIsoVal",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-240},{180,240}})),
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-96,-74},{-60,-86}},
          textColor={255,0,255},
          textString="uStaPro"),
        Text(
          extent={{-96,-42},{-46,-56}},
          textColor={255,0,255},
          textString="uUpsDevSta"),
        Text(
          extent={{-96,86},{-48,74}},
          textColor={255,127,0},
          textString="nexChaChi"),
        Text(
          extent={{-96,58},{-42,46}},
          textColor={0,0,127},
          textString="uChiWatIsoVal"),
        Text(
          extent={{32,70},{96,54}},
          textColor={255,0,255},
          textString="yEnaChiWatIsoVal"),
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
          extent={{44,-54},{98,-66}},
          textColor={0,0,127},
          textString="yChiWatIsoVal")}),
 Documentation(info="<html>
<p>
Block updates chiller chilled water isolation valve enabling-disabling status when 
there is stage change command (<code>uStaPro=true</code>). It will also generate 
status to indicate if the valve reset process has finished.
This development is based on ASHRAE Guideline 36-2021, 
section 5.20.4.16, item e, and section 5.20.4.17, item c, which specifies when 
and how the isolation valve should be controlled when it is in the stage changing process.
</p>
<ul>
<li>
When there is the stage up command (<code>uStaPro=true</code>) and next chiller 
head pressure control has been enabled (<code>uUpsDevSta=true</code>),
the chilled water isolation valve of the next enabling chiller indicated 
by <code>nexChaChi</code> will be enabled (<code>iniValPos=0</code>, 
<code>endValPos=1</code>). 
</li>
<li>
When there is the stage down command (<code>uStaPro=true</code>) and the disabling chiller 
(<code>nexChaChi</code>) has been shut off (<code>uUpsDevSta=true</code>),
the chiller's isolation valve will be disabled (<code>iniValPos=1</code>, 
<code>endValPos=0</code>). 
</li>
</ul>
<p>
The valve should open or close slowly. For example, this could be accomplished by 
resetting the valve position X /seconds, where X = (<code>endValPos</code> - 
<code>iniValPos</code>) / <code>chaChiWatIsoTim</code>.
The valve time <code>chaChiWatIsoTim</code> should be determined in the field. 
</p>
<p>
This sequence will generate array <code>yChiWatIsoVal</code>, which indicates 
chilled water isolation valve position setpoint. <code>yEnaChiWatIsoVal</code> 
will be true when all the enabled valves are fully open and all the disabled valves
are fully closed. 
</p>
</html>", revisions="<html>
<ul>
<li>
February 4, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end CHWIsoVal_New;
