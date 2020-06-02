within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences;
block Speed
  "Output design speed of condenser water pumps at current stage"

  parameter Boolean have_WSE = true
    "Flag to indicate if the plant has water side economizer";
  parameter Integer totSta = 6
    "Total number of stages, including the stages with a WSE, if applicable";
  parameter Real staVec[totSta] = {0, 0.5, 1, 1.5, 2, 2.5}
    "Chiller stage vector, element value like x.5 means chiller stage x plus WSE";
  parameter Real desConWatPumSpe[totSta] = {0, 0.5, 0.75, 0.6, 0.75, 0.9}
    "Design condenser water pump speed setpoint, according to current chiller stage and WSE status"
    annotation (Dialog(group="Setpoint according to stage"));
  parameter Real desConWatPumNum[totSta] = {0,1,1,2,2,2}
    "Design number of condenser water pumps that should be ON, according to current chiller stage and WSE status"
    annotation (Dialog(group="Setpoint according to stage"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Current chiller stage index that does not include the WSE"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE if have_WSE
    "Water side economizer status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yConWatPumNum
    "Design number of operating condenser water pumps at current stage"
    annotation (Placement(transformation(extent={{140,-60},{180,-20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDesConWatPumSpe
    "Design condenser water pump speed at current stage"
    annotation (Placement(transformation(extent={{140,0},{180,40}}),
      iconTransformation(extent={{100,40},{140,80}})));

protected
  Buildings.Controls.OBC.CDL.Routing.RealExtractor conWatPumOn(
    final nin=totSta)  "Number of condenser water pump should be on"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor conWatPumSpe(
    final nin=totSta)   "Condenser water pump speed"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1[totSta](
    final k=desConWatPumSpe) "Condenser water pump speed setpoint"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2[totSta](
    final k=desConWatPumNum) "Number of condenser water pump should be on"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Convert integer to real number"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3[totSta](
    final k=staVec)
    "Chiller stage vector, element value like x.5 means chiller stage x plus WSE"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=0.5) if have_WSE
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2 "Add two real inputs"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(
    final nout=totSta) "Replicate real input"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1[totSta](
    final k1=fill(-1, totSta),
    final k2=fill(1, totSta)) "Add two real inputs"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr[totSta](
    final threshold=fill(-0.1, totSta))  "Identify current stage"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[totSta]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(
    final nin=totSta) "Current stage index"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4(final k=0) if not have_WSE
    "Constant zero"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

equation
  connect(con1.y,conWatPumSpe. u)
    annotation (Line(points={{62,20},{78,20}}, color={0,0,127}));
  connect(con2.y,conWatPumOn. u)
    annotation (Line(points={{22,-40},{38,-40}},color={0,0,127}));
  connect(uChiSta,intToRea. u)
    annotation (Line(points={{-160,60},{-122,60}},color={255,127,0}));
  connect(conWatPumSpe.y, yDesConWatPumSpe)
    annotation (Line(points={{102,20},{160,20}}, color={0,0,127}));
  connect(yConWatPumNum, reaToInt.y)
    annotation (Line(points={{160,-40},{102,-40}},color={255,127,0}));
  connect(conWatPumOn.y, reaToInt.u)
    annotation (Line(points={{62,-40},{78,-40}}, color={0,0,127}));
  connect(uWSE, booToRea.u)
    annotation (Line(points={{-160,-60},{-122,-60}}, color={255,0,255}));
  connect(intToRea.y, add2.u1)
    annotation (Line(points={{-98,60},{-90,60},{-90,66},{-82,66}}, color={0,0,127}));
  connect(booToRea.y, add2.u2)
    annotation (Line(points={{-98,-60},{-90,-60},{-90,54},{-82,54}}, color={0,0,127}));
  connect(add2.y, reaRep.u)
    annotation (Line(points={{-58,60},{-42,60}}, color={0,0,127}));
  connect(con3.y, add1.u1)
    annotation (Line(points={{-18,100},{-10,100},{-10,86},{-2,86}},color={0,0,127}));
  connect(reaRep.y, add1.u2)
    annotation (Line(points={{-18,60},{-8,60},{-8,74},{-2,74}}, color={0,0,127}));
  connect(add1.y,greEquThr. u)
    annotation (Line(points={{22,80},{38,80}}, color={0,0,127}));
  connect(greEquThr.y, booToInt.u)
    annotation (Line(points={{62,80},{78,80}}, color={255,0,255}));
  connect(mulSumInt.y, conWatPumSpe.index)
    annotation (Line(points={{-38,0},{90,0},{90,8}}, color={255,127,0}));
  connect(mulSumInt.y, conWatPumOn.index)
    annotation (Line(points={{-38,0},{-20,0},{-20,-70},{50,-70},{50,-52}},
      color={255,127,0}));
  connect(booToInt.y, mulSumInt.u)
    annotation (Line(points={{102,80},{120,80},{120,40},{-80,40},{-80,0},{-62,0}},
      color={255,127,0}));
  connect(con4.y, add2.u2)
    annotation (Line(points={{-98,0},{-90,0},{-90,54},{-82,54}}, color={0,0,127}));

annotation (
  defaultComponentName="conPumSpe",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics={
        Text(
          extent={{-100,150},{100,110}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{36,74},{96,50}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yConWatPumSpe"),
        Text(
          extent={{-98,-32},{-54,-48}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uWSE"),
        Text(
          extent={{36,14},{96,-10}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yConWatPumNum"),
        Text(
          extent={{-96,52},{-36,28}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uChiSta")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{140,120}})),
  Documentation(info="<html>
<p>
Block that outputs number of operating condenser water pumps and design pump speed 
for current stage, 
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 6 on July 25, 2019), 
section 5.2.9 Condenser water pumps, part 5.2.9.6. This sequence is for plants
have variable speed condenser water pumps.
</p>
<p>
The number of operating condenser water pumps <code>yConWatPumNum</code> and design
condenser water pump speed <code>yDesConWatPumSpe</code> shall be set by chiller 
stage per the table below.
</p>
<table summary=\"summary\" border=\"1\">
<tr>
<th>Chiller stage </th> 
<th>Number of pump ON</th>  
<th>Design pump speed setpoint for current stage</th>
</tr>
<tr>
<td align=\"center\">0</td>
<td align=\"center\">0</td>
<td align=\"left\">N/A, Off</td>
</tr>
<tr>
<td align=\"center\">0+WSE</td>
<td align=\"center\">1</td>
<td align=\"left\">Per TAB to provide design flow through HX</td>
</tr>
<tr>
<td align=\"center\">1</td>
<td align=\"center\">1</td>
<td align=\"left\">Per TAB to provide design flow through chiller</td>
</tr>
<tr>
<td align=\"center\">1+WSE</td>
<td align=\"center\">2</td>
<td align=\"left\">Per TAB to provide at least design flow through both chiller and WSE</td>
</tr>
<tr>
<td align=\"center\">2</td>
<td align=\"center\">2</td>
<td align=\"left\">Per TAB to provide at least design flow through both chillers</td>
</tr>
<tr>
<td align=\"center\">2+WSE</td>
<td align=\"center\">2</td>
<td align=\"left\">Per TAB to provide at least design flow through both chillers and WSE, 
or 100% speed if design flow cannot be achieved.</td>
</tr>
</table>
<br/>
<p>
Note that this sequence is for plants with variable speed condenser water pumps and
the pumps are equally sized.
</p>
</html>", revisions="<html>
<ul>
<li>
January 28, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Speed;
