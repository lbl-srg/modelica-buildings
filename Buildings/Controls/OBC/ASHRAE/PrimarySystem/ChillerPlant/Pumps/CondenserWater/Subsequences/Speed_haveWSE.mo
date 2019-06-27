within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences;
block Speed_haveWSE
  "Sequence for operating condenser water pumps for plants with waterside economizer"

  parameter Integer staNum = 3
    "Total number of stages, stage zero should be counted as one stage";
  parameter Real conWatPumSpeSet[2*staNum] = {0, 0.5, 0.75, 0.6, 0.75, 0.9}
    "Condenser water pump speed setpoint, according to current chiller stage and WSE status"
    annotation (Dialog(group="Setpoint according to stage"));
  parameter Real conWatPumOnSet[2*staNum] = {0,1,1,2,2,2}
    "Number of condenser water pumps that should be ON, according to current chiller stage and WSE status"
    annotation (Dialog(group="Setpoint according to stage"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE
    "Water side economizer status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yConWatPumNum
    "Number of operating condenser water pumps"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}}),
      iconTransformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatPumSpeSet
    "Condenser water pump speed"
    annotation (Placement(transformation(extent={{100,60},{120,80}}),
      iconTransformation(extent={{100,50},{120,70}})));

protected
  Buildings.Controls.OBC.CDL.Routing.RealExtractor conWatPumOn(
    final nin=2*staNum) "Number of condenser water pump should be on"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor conWatPumSpe(
    final nin=2*staNum)
    "Condenser water pump speed"
    annotation (Placement(transformation(extent={{30,60},{50,80}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=1,
    final k=2)
    "Double current stage number"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1[2*staNum](
    final k=conWatPumSpeSet)
    "Condenser water pump speed setpoint"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2[2*staNum](
    final k=conWatPumOnSet)
    "Number of condenser water pump should be on"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger pumSpeSta
    "Convert real number to integer"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Convert integer to real number"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=1,
    final k=1)
    "Current stage plus WSE on status"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Check if it should consider WSE"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

equation
  connect(con1.y,conWatPumSpe. u)
    annotation (Line(points={{11,70},{28,70}}, color={0,0,127}));
  connect(con2.y,conWatPumOn. u)
    annotation (Line(points={{1,-70},{18,-70}}, color={0,0,127}));
  connect(uWSE,swi. u2)
    annotation (Line(points={{-120,-30},{-42,-30}}, color={255,0,255}));
  connect(addPar.y,swi. u1)
    annotation (Line(points={{-19,30},{0,30},{0,0},{-60,0},{-60,-22},
      {-42,-22}}, color={0,0,127}));
  connect(swi.y,pumSpeSta. u)
    annotation (Line(points={{-19,-30},{-2,-30}}, color={0,0,127}));
  connect(uChiSta,intToRea. u)
    annotation (Line(points={{-120,70},{-82,70}}, color={255,127,0}));
  connect(intToRea.y,addPar1. u)
    annotation (Line(points={{-59,70},{-40,70},{-40,50},{-90,50},{-90,30},
      {-82,30}}, color={0,0,127}));
  connect(addPar1.y,addPar. u)
    annotation (Line(points={{-59,30},{-42,30}}, color={0,0,127}));
  connect(addPar1.y,swi. u3)
    annotation (Line(points={{-59,30},{-50,30},{-50,-38},{-42,-38}},
      color={0,0,127}));
  connect(pumSpeSta.y, conWatPumOn.index)
    annotation (Line(points={{21,-30},{40,-30},{40,-50},{10,-50},{10,-90},
      {30,-90},{30,-82}}, color={255,127,0}));
  connect(pumSpeSta.y, conWatPumSpe.index)
    annotation (Line(points={{21,-30},{40,-30},{40,58}}, color={255,127,0}));
  connect(conWatPumSpe.y, yConWatPumSpeSet)
    annotation (Line(points={{51,70},{78,70},{78,70},{110,70}}, color={0,0,127}));
  connect(yConWatPumNum, reaToInt.y)
    annotation (Line(points={{110,-70},{81,-70}}, color={255,127,0}));
  connect(conWatPumOn.y, reaToInt.u)
    annotation (Line(points={{41,-70},{50,-70},{50,-70},{58,-70}},
      color={0,0,127}));

annotation (
  defaultComponentName="conPumSpe",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
          extent={{-98,8},{-54,-8}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChiOn"),
        Text(
          extent={{36,14},{96,-10}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yConWatPumNum")}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
Block that enable and disable leading primary chilled water pump, for plants
with headered primary chilled water pumps, 
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 4 on January 7, 2019), 
section 5.2.9 Condenser water pumps, part 5.2.9.5.
</p>

<p>
The number of operating condenser water pumps <code>yConWatPumNum</code> and 
condenser water pump speed <code>yConWatPumSpeSet</code> shall be set by chiller 
stage per the table below.
</p>

<table summary=\"summary\" border=\"1\">
<tr>
<th>Chiller stage </th> 
<th>Number of pump ON</th>  
<th>Pump speed setpoint</th>
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
</html>", revisions="<html>
<ul>
<li>
January 28, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Speed_haveWSE;
