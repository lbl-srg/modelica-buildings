within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences;
block FlowSetpoint "Chilled water minimum flow bypass setpoint"

  parameter Integer nSta = 3
    "Total number of stages, zero stage should be seem as one stage";
  parameter Modelica.SIunits.Time byPasSetTim = 300
    "Time to reset minimum by-pass flow";
  parameter Modelica.SIunits.VolumeFlowRate minFloSet[nSta] = {0, 0.0089, 0.0177}
    "Minimum flow rate at each chiller stage";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp "Indicate if there is stage up"
    annotation (Placement(transformation(extent={{-300,160},{-260,200}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Status of resetting status of device before reset minimum bypass flow setpoint"
    annotation (Placement(transformation(extent={{-300,120},{-260,160}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta "Current stage index"
    annotation (Placement(transformation(extent={{-300,60},{-260,100}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "Indicate if the stage require one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{-300,-20},{-260,20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaNexChi
    "Status to indicate that it starts to enable another chiller. This input used when the stage change needs chiller on/off"
    annotation (Placement(transformation(extent={{-300,-60},{-260,-20}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow
    "Indicate if there is stage down"
    annotation (Placement(transformation(extent={{-300,-160},{-260,-120}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatBypSet(
    final unit="m3/s")
    "Chilled water minimum flow bypass setpoint"
    annotation (Placement(transformation(extent={{260,10},{280,30}}),
      iconTransformation(extent={{100,-10},{120,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[nSta](
    final k=minFloSet)
    "Minimum bypass flow setpoint at each stage, equal to the sum of minimum chilled water flowrate of the chillers being enabled at the stage"
    annotation (Placement(transformation(extent={{-220,90},{-200,110}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor curMinSet(final nin=nSta)
    "Targeted minimum flow setpoint at current stage"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-220,-110},{-200,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt
    "One stage lower than current one"
    annotation (Placement(transformation(extent={{-180,-130},{-160,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=byPasSetTim)
    "Duration time to change old setpoint to new setpoint"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Line upSet
    "Minimum flow setpoint when there is stage up command"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{20,110},{40,130}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Time after suppress chiller demand"
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(final k=-1)
    "Constant one"
    annotation (Placement(transformation(extent={{-220,30},{-200,50}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt1
    "One stage lower than current one"
    annotation (Placement(transformation(extent={{-180,10},{-160,30}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor lowMinSet(final nin=nSta)
    "Minimum flow setpoint at previous low stage"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor uppMinSet(final nin=nSta)
    "Minimum flow setpoint at previous upper stage"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Line dowSet
    "Minimum flow setpoint when there is stage down command"
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1
    "Time after suppress chiller demand"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch byPasSet
    "Minimum flow bypass setpoint"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Buildings.Controls.OBC.CDL.Logical.And3 and4 "Logical and"
    annotation (Placement(transformation(extent={{200,150},{220,170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-180,-190},{-160,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{140,150},{160,170}})));
  Buildings.Controls.OBC.CDL.Logical.Switch byPasSet1
    "Minimum flow bypass setpoint"
    annotation (Placement(transformation(extent={{200,10},{220,30}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical not"
    annotation (Placement(transformation(extent={{-120,170},{-100,190}})));
  Buildings.Controls.OBC.CDL.Logical.And and3 "Logical not"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{80,130},{100,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4 "Logical not"
    annotation (Placement(transformation(extent={{-220,-50},{-200,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical not"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

equation
  connect(curMinSet.u, con.y)
    annotation (Line(points={{-122,100},{-199,100}}, color={0,0,127}));
  connect(con.y, lowMinSet.u)
    annotation (Line(points={{-199,100},{-140,100},{-140,40},{-122,40}},
      color={0,0,127}));
  connect(addInt1.y, lowMinSet.index)
    annotation (Line(points={{-159,20},{-110,20},{-110,28}}, color={255,127,0}));
  connect(con2.y, upSet.x1)
    annotation (Line(points={{41,120},{50,120},{50,88},{78,88}},
      color={0,0,127}));
  connect(lowMinSet.y, upSet.f1)
    annotation (Line(points={{-99,40},{-80,40},{-80,84},{78,84}},
      color={0,0,127}));
  connect(tim.y, upSet.u)
    annotation (Line(points={{-19,180},{60,180},{60,80},{78,80}},
      color={0,0,127}));
  connect(con3.y, upSet.x2)
    annotation (Line(points={{-19,120},{-10,120},{-10,76},{78,76}},
      color={0,0,127}));
  connect(addInt.y, uppMinSet.index)
    annotation (Line(points={{-159,-120},{-110,-120},{-110,-92}},
      color={255,127,0}));
  connect(uppMinSet.y, dowSet.f1)
    annotation (Line(points={{-99,-80},{-80,-80},{-80,-96},{78,-96}},
      color={0,0,127}));
  connect(conInt1.y, addInt1.u1)
    annotation (Line(points={{-199,40},{-190,40},{-190,26},{-182,26}},
      color={255,127,0}));
  connect(uSta, addInt1.u2)
    annotation (Line(points={{-280,80},{-240,80},{-240,14},{-182,14}},
      color={255,127,0}));
  connect(uSta, curMinSet.index)
    annotation (Line(points={{-280,80},{-110,80},{-110,88}}, color={255,127,0}));
  connect(curMinSet.y, add2.u1)
    annotation (Line(points={{-99,100},{-60,100},{-60,66},{-42,66}},
      color={0,0,127}));
  connect(lowMinSet.y, add2.u2)
    annotation (Line(points={{-99,40},{-80,40},{-80,54},{-42,54}},
      color={0,0,127}));
  connect(add2.y, swi.u1)
    annotation (Line(points={{-19,60},{0,60},{0,8},{18,8}},
      color={0,0,127}));
  connect(curMinSet.y, swi.u3)
    annotation (Line(points={{-99,100},{-60,100},{-60,-8},{18,-8}},
      color={0,0,127}));
  connect(swi.y, upSet.f2)
    annotation (Line(points={{41,0},{60,0},{60,72},{78,72}}, color={0,0,127}));
  connect(con.y, uppMinSet.u)
    annotation (Line(points={{-199,100},{-140,100},{-140,-80},{-122,-80}},
      color={0,0,127}));
  connect(curMinSet.y, add1.u1)
    annotation (Line(points={{-99,100},{-60,100},{-60,-34},{-42,-34}},
      color={0,0,127}));
  connect(uppMinSet.y, add1.u2)
    annotation (Line(points={{-99,-80},{-80,-80},{-80,-46},{-42,-46}},
      color={0,0,127}));
  connect(add1.y, swi1.u1)
    annotation (Line(points={{-19,-40},{0,-40},{0,-52},{18,-52}},
      color={0,0,127}));
  connect(curMinSet.y, swi1.u3)
    annotation (Line(points={{-99,100},{-60,100},{-60,-68},{18,-68}},
      color={0,0,127}));
  connect(con2.y, dowSet.x1)
    annotation (Line(points={{41,120},{50,120},{50,-92},{78,-92}},
      color={0,0,127}));
  connect(con3.y, dowSet.x2)
    annotation (Line(points={{-19,120},{-10,120},{-10,-104},{78,-104}},
      color={0,0,127}));
  connect(swi1.y, dowSet.f2)
    annotation (Line(points={{41,-60},{60,-60},{60,-108},{78,-108}},
      color={0,0,127}));
  connect(uSta, addInt.u2)
    annotation (Line(points={{-280,80},{-240,80},{-240,-126},{-182,-126}},
      color={255,127,0}));
  connect(conInt.y, addInt.u1)
    annotation (Line(points={{-199,-100},{-190,-100},{-190,-114},{-182,-114}},
      color={255,127,0}));
  connect(tim1.y, dowSet.u)
    annotation (Line(points={{-19,-140},{20,-140},{20,-100},{78,-100}},
      color={0,0,127}));
  connect(upSet.y, byPasSet.u1)
    annotation (Line(points={{101,80},{110,80},{110,8},{138,8}},
      color={0,0,127}));
  connect(dowSet.y, byPasSet.u3)
    annotation (Line(points={{101,-100},{120,-100},{120,-8},{138,-8}},
      color={0,0,127}));
  connect(uStaUp, byPasSet.u2)
    annotation (Line(points={{-280,180},{-220,180},{-220,160},{120,160},
      {120,0},{138,0}}, color={255,0,255}));
  connect(uStaDow, not2.u)
    annotation (Line(points={{-280,-140},{-220,-140},{-220,-180},{-182,-180}},
      color={255,0,255}));
  connect(uStaUp, not3.u)
    annotation (Line(points={{-280,180},{-220,180},{-220,160},{138,160}},
      color={255,0,255}));
  connect(not3.y,and4. u1)
    annotation (Line(points={{161,160},{168,160},{168,168},{198,168}},
      color={255,0,255}));
  connect(not2.y,and4. u2)
    annotation (Line(points={{-159,-180},{174,-180},{174,160},{198,160}},
      color={255,0,255}));
  connect(and4.y, byPasSet1.u2)
    annotation (Line(points={{221,160},{240,160},{240,60},{180,60},{180,20},
      {198,20}},  color={255,0,255}));
  connect(byPasSet1.y, yChiWatBypSet)
    annotation (Line(points={{221,20},{270,20}}, color={0,0,127}));
  connect(byPasSet.y, byPasSet1.u3)
    annotation (Line(points={{161,0},{180,0},{180,12},{198,12}}, color={0,0,127}));
  connect(curMinSet.y, byPasSet1.u1)
    annotation (Line(points={{-99,100},{-60,100},{-60,28},{198,28}},
      color={0,0,127}));
  connect(uStaUp, and1.u1)
    annotation (Line(points={{-280,180},{-122,180}}, color={255,0,255}));
  connect(and1.y, tim.u)
    annotation (Line(points={{-99,180},{-42,180}},color={255,0,255}));
  connect(uUpsDevSta, and1.u2)
    annotation (Line(points={{-280,140},{-230,140},{-230,172},{-122,172}},
      color={255,0,255}));
  connect(uUpsDevSta, and3.u2)
    annotation (Line(points={{-280,140},{-230,140},{-230,-148},{-122,-148}},
      color={255,0,255}));
  connect(uStaDow, and3.u1)
    annotation (Line(points={{-280,-140},{-122,-140}}, color={255,0,255}));
  connect(and3.y, tim1.u)
    annotation (Line(points={{-99,-140},{-42,-140}}, color={255,0,255}));
  connect(uUpsDevSta, not1.u)
    annotation (Line(points={{-280,140},{78,140}}, color={255,0,255}));
  connect(not1.y, and4.u3)
    annotation (Line(points={{101,140},{180,140},{180,152},{198,152}},
      color={255,0,255}));
  connect(uOnOff, and2.u1)
    annotation (Line(points={{-280,0},{-122,0}}, color={255,0,255}));
  connect(uEnaNexChi, not4.u)
    annotation (Line(points={{-280,-40},{-222,-40}}, color={255,0,255}));
  connect(not4.y, and2.u2)
    annotation (Line(points={{-199,-40},{-180,-40},{-180,-8},{-122,-8}}, color={255,0,255}));
  connect(and2.y, swi.u2)
    annotation (Line(points={{-99,0},{18,0}}, color={255,0,255}));
  connect(and2.y, swi1.u2)
    annotation (Line(points={{-99,0},{-70,0},{-70,-60},{18,-60}}, color={255,0,255}));

annotation (
  defaultComponentName="minBypSet",
  Icon(graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(extent={{-36,42},{0,28}}, lineColor={28,108,200}),
        Rectangle(extent={{-36,28},{0,14}}, lineColor={28,108,200}),
        Rectangle(extent={{-36,14},{0,0}}, lineColor={28,108,200}),
        Rectangle(extent={{-36,0},{0,-14}}, lineColor={28,108,200}),
        Rectangle(extent={{-36,-14},{0,-28}}, lineColor={28,108,200}),
        Text(
          extent={{-32,38},{-12,32}},
          lineColor={28,108,200},
          textString="Stage #"),
        Text(
          extent={{-30,24},{-10,18}},
          lineColor={28,108,200},
          textString="0"),
        Text(
          extent={{-30,10},{-10,4}},
          lineColor={28,108,200},
          textString="1"),
        Text(
          extent={{-30,-4},{-10,-10}},
          lineColor={28,108,200},
          textString="2"),
        Rectangle(extent={{-36,-28},{0,-42}}, lineColor={28,108,200}),
        Text(
          extent={{-30,-18},{-10,-24}},
          lineColor={28,108,200},
          textString="..."),
        Text(
          extent={{-30,-32},{-10,-38}},
          lineColor={28,108,200},
          textString="n"),
        Rectangle(extent={{2,42},{38,28}}, lineColor={28,108,200}),
        Rectangle(extent={{2,28},{38,14}}, lineColor={28,108,200}),
        Rectangle(extent={{2,14},{38,0}}, lineColor={28,108,200}),
        Rectangle(extent={{2,0},{38,-14}}, lineColor={28,108,200}),
        Rectangle(extent={{2,-14},{38,-28}}, lineColor={28,108,200}),
        Text(
          extent={{4,40},{36,30}},
          lineColor={28,108,200},
          textString="Min bypass flow"),
        Text(
          extent={{6,24},{34,18}},
          lineColor={28,108,200},
          textString="minFloSet[1]"),
        Rectangle(extent={{2,-28},{38,-42}}, lineColor={28,108,200}),
        Text(
          extent={{8,-18},{28,-24}},
          lineColor={28,108,200},
          textString="..."),
        Text(
          extent={{6,10},{34,4}},
          lineColor={28,108,200},
          textString="minFloSet[2]"),
        Text(
          extent={{6,-32},{34,-38}},
          lineColor={28,108,200},
          textString="minFloSet[n]"),
        Text(
          extent={{6,-4},{34,-10}},
          lineColor={28,108,200},
          textString="minFloSet[3]")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-260,-200},{260,200}})),
  Documentation(info="<html>
<p>
Block that output chilled water minimum flow bypass flow setpoint for primary-only
plants with a minimum flow bypass valve, 
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 4 on January 7, 2019), 
section 5.2.8 Chilled water minimum flow bypass valve.
</p>

<ul>
<li>
Bypass valve shall modulate to maintain minimum flow <code>VBypas_flow</code>
at a setpoint equal to the sum of the minimum chilled water flowrate of the chillers
commanded on run in each stage.
</li>
</ul>

<table summary=\"summary\" border=\"1\">
<tr>
<th> Chiller stage </th> 
<th> Minimum flow </th>  
</tr>
<tr>
<td align=\"center\">0</td>
<td align=\"center\">0</td>
</tr>
<tr>
<td align=\"center\">1</td>
<td align=\"center\"><code>minFloSet</code>[1]</td>
</tr>
<tr>
<td align=\"center\">2</td>
<td align=\"center\"><code>minFloSet</code>[2]</td>
</tr>
<tr>
<td align=\"center\">...</td>
<td align=\"center\">...</td>
</tr>
</table>
<br/>

<ul>
<li>
If there is any stage change requiring a chiller on and another chiller off,
the minimum flow setpoint shall temporarily change to include the minimum 
chilled water flowrate of both enabling chiller and disabled chiller prior
to starting the newly enabled chiller.
</li>
</ul>

<p>
Note that when there is stage change thus requires changes of 
minimum bypass flow setpoint, the change should be slowly.
For example, this could be accomplished by resetting the setpoint X GPM/second, 
where X = (NewSetpoint - OldSetpoint) / <code>byPasSetTim</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 31, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end FlowSetpoint;
