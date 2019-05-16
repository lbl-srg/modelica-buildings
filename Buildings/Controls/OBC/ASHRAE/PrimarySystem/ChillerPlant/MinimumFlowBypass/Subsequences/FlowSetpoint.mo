within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences;
block FlowSetpoint "Chilled water minimum flow setpoint"

  parameter Integer nChi = 3
    "Total number of chillers";
  parameter Modelica.SIunits.Time byPasSetTim = 300
    "Time to reset minimum by-pass flow";
  parameter Modelica.SIunits.VolumeFlowRate minFloSet[nChi] = {0.005, 0.005, 0.005}
    "Minimum chilled water flow through each chiller";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp
    "Stage up logical signal"
    annotation (Placement(transformation(extent={{-300,160},{-260,200}}),
      iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Resetting status of upstream device (in staging up or down process) before reset minimum chilled water flow setpoint"
    annotation (Placement(transformation(extent={{-300,120},{-260,160}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaNexChi
    "Status to indicate that it starts to enable another chiller. This input used when the stage change needs chiller on/off"
    annotation (Placement(transformation(extent={{-300,60},{-260,100}}),
      iconTransformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "Indicate if the stage change requires one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{-300,30},{-260,70}}),
      iconTransformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
    annotation (Placement(transformation(extent={{-300,-20},{-260,20}}),
      iconTransformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexEnaChi
    "Index of next enabling chiller"
    annotation (Placement(transformation(extent={{-300,-80},{-260,-40}}),
      iconTransformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexDisChi
    "Index of next disabling chiller"
    annotation (Placement(transformation(extent={{-300,-120},{-260,-80}}),
      iconTransformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow
    "Stage down logical signal"
    annotation (Placement(transformation(extent={{-300,-160},{-260,-120}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatMinFloSet(
    quantity="VolumeFlowRate",
    final unit="m3/s",
    final min=0)
    "Chilled water minimum flow setpoint"
    annotation (Placement(transformation(extent={{260,50},{280,70}}),
      iconTransformation(extent={{100,-10},{120,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=byPasSetTim)
    "Duration time to change old setpoint to new setpoint"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Line upSet
    "Minimum flow setpoint when there is stage up command"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{20,110},{40,130}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Time after suppress chiller demand"
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Line dowSet
    "Minimum flow setpoint when there is stage down command"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1
    "Time after suppress chiller demand"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.OBC.CDL.Logical.Switch byPasSet
    "Minimum flow chilled water flow setpoint"
    annotation (Placement(transformation(extent={{140,30},{160,50}})));
  Buildings.Controls.OBC.CDL.Logical.And3 and4 "Logical and"
    annotation (Placement(transformation(extent={{200,150},{220,170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-180,-190},{-160,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{140,150},{160,170}})));
  Buildings.Controls.OBC.CDL.Logical.Switch byPasSet1
    "Minimum flow chilled water flow setpoint"
    annotation (Placement(transformation(extent={{200,50},{220,70}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{-180,170},{-160,190}})));
  Buildings.Controls.OBC.CDL.Logical.And and3 "Logical and"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{80,130},{100,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4 "Logical not"
    annotation (Placement(transformation(extent={{-220,70},{-200,90}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-180,40},{-160,60}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(final nin=nChi)
    "Sum of minimum flow setpoint of running chillers"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3 "Next stage minimum chilled water flow rate setpoint"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(final k1=-1)
    "Next stage minimum chilled water flow rate setpoint"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minFlo[nChi](
    final k=minFloSet)
    "Minimum chilled water flow rate through each chiller"
    annotation (Placement(transformation(extent={{-220,10},{-200,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2[nChi]
    "Minimum chilled water flow rate of the running chiller"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer[nChi](
    each final k=0) "Zero flow rate "
    annotation (Placement(transformation(extent={{-220,-30},{-200,-10}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor enaChiMinFlo(
    final nin=nChi)
    "Minimum flow setpoint of next enabling chiller"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor disChiMinFlo(final nin=nChi)
    "Minimum flow setpoint of next disabling chiller"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));

equation
  connect(con2.y, upSet.x1)
    annotation (Line(points={{41,120},{50,120},{50,98},{78,98}},
      color={0,0,127}));
  connect(tim.y, upSet.u)
    annotation (Line(points={{-19,180},{60,180},{60,90},{78,90}},
      color={0,0,127}));
  connect(con3.y, upSet.x2)
    annotation (Line(points={{-19,120},{-10,120},{-10,86},{78,86}},
      color={0,0,127}));
  connect(swi.y, upSet.f2)
    annotation (Line(points={{41,50},{60,50},{60,82},{78,82}}, color={0,0,127}));
  connect(con2.y, dowSet.x1)
    annotation (Line(points={{41,120},{50,120},{50,-52},{78,-52}},
      color={0,0,127}));
  connect(con3.y, dowSet.x2)
    annotation (Line(points={{-19,120},{-10,120},{-10,-64},{78,-64}},
      color={0,0,127}));
  connect(tim1.y, dowSet.u)
    annotation (Line(points={{-19,-140},{20,-140},{20,-60},{78,-60}},
      color={0,0,127}));
  connect(upSet.y, byPasSet.u1)
    annotation (Line(points={{101,90},{110,90},{110,48},{138,48}},
      color={0,0,127}));
  connect(dowSet.y, byPasSet.u3)
    annotation (Line(points={{101,-60},{120,-60},{120,32},{138,32}},
      color={0,0,127}));
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
  connect(byPasSet1.y, yChiWatMinFloSet)
    annotation (Line(points={{221,60},{270,60}}, color={0,0,127}));
  connect(byPasSet.y, byPasSet1.u3)
    annotation (Line(points={{161,40},{180,40},{180,52},{198,52}}, color={0,0,127}));
  connect(uStaUp, and1.u1)
    annotation (Line(points={{-280,180},{-182,180}}, color={255,0,255}));
  connect(and1.y, tim.u)
    annotation (Line(points={{-159,180},{-42,180}}, color={255,0,255}));
  connect(uUpsDevSta, and1.u2)
    annotation (Line(points={{-280,140},{-240,140},{-240,172},{-182,172}},
      color={255,0,255}));
  connect(uUpsDevSta, and3.u2)
    annotation (Line(points={{-280,140},{-240,140},{-240,-148},{-122,-148}},
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
    annotation (Line(points={{-280,50},{-182,50}}, color={255,0,255}));
  connect(uEnaNexChi, not4.u)
    annotation (Line(points={{-280,80},{-222,80}}, color={255,0,255}));
  connect(not4.y, and2.u2)
    annotation (Line(points={{-199,80},{-190,80},{-190,42},{-182,42}}, color={255,0,255}));
  connect(and2.y, swi.u2)
    annotation (Line(points={{-159,50},{18,50}}, color={255,0,255}));
  connect(minFlo.y, swi2.u1)
    annotation (Line(points={{-199,20},{-180,20},{-180,8},{-162,8}}, color={0,0,127}));
  connect(uChi, swi2.u2)
    annotation (Line(points={{-280,0},{-162,0}}, color={255,0,255}));
  connect(zer.y, swi2.u3)
    annotation (Line(points={{-199,-20},{-190,-20},{-190,-8},{-162,-8}}, color={0,0,127}));
  connect(minFlo.y, enaChiMinFlo.u)
    annotation (Line(points={{-199,20},{-180,20}, {-180,-40},{-162,-40}}, color={0,0,127}));
  connect(nexEnaChi, enaChiMinFlo.index)
    annotation (Line(points={{-280,-60},{-150,-60},{-150,-52}}, color={255,127,0}));
  connect(minFlo.y, disChiMinFlo.u)
    annotation (Line(points={{-199,20},{-180,20},{-180,-80},{-162,-80}}, color={0,0,127}));
  connect(nexDisChi, disChiMinFlo.index)
    annotation (Line(points={{-280,-100},{-150,-100},{-150,-92}}, color={255,127,0}));
  connect(mulSum.y, add3.u1)
    annotation (Line(points={{-99,0},{-80,0},{-80,-14}, {-42,-14}}, color={0,0,127}));
  connect(enaChiMinFlo.y, add3.u2)
    annotation (Line(points={{-139,-40},{-90,-40},{-90,-26},{-42,-26}},  color={0,0,127}));
  connect(mulSum.y, upSet.f1)
    annotation (Line(points={{-99,0},{-80,0},{-80,94},{78,94}}, color={0,0,127}));
  connect(add3.y, swi.u1)
    annotation (Line(points={{-19,-20},{0,-20},{0,58},{18,58}}, color={0,0,127}));
  connect(mulSum.y, byPasSet1.u1)
    annotation (Line(points={{-99,0},{-80,0},{-80,68},{198,68}}, color={0,0,127}));
  connect(add1.y, swi.u3)
    annotation (Line(points={{-19,20},{8,20},{8,42},{18,42}}, color={0,0,127}));
  connect(swi.y, dowSet.f2)
    annotation (Line(points={{41,50},{60,50},{60,-68},{78,-68}}, color={0,0,127}));
  connect(mulSum.y, dowSet.f1)
    annotation (Line(points={{-99,0},{-80,0},{-80,-56},{78,-56}}, color={0,0,127}));
  connect(uStaUp, byPasSet.u2)
    annotation (Line(points={{-280,180},{-220,180},{-220,160},{120,160},{120,40},{138,40}},
      color={255,0,255}));
  connect(and4.y, byPasSet1.u2)
    annotation (Line(points={{221,160},{240,160},{240,120},{180,120},{180,60},{198,60}},
      color={255,0,255}));
  connect(disChiMinFlo.y, add1.u1)
    annotation (Line(points={{-139,-80},{-60,-80},{-60,26},{-42,26}}, color={0,0,127}));
  connect(add3.y, add1.u2)
    annotation (Line(points={{-19,-20},{0,-20},{0,0},{-50,0},{-50,14},{-42,14}},
      color={0,0,127}));
  connect(swi2.y, mulSum.u)
    annotation (Line(points={{-139,0},{-122,0}}, color={0,0,127}));

annotation (
  defaultComponentName="minChiFloSet",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
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
          extent={{8,38},{34,32}},
          lineColor={28,108,200},
          textString="Min flow"),
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
Block that output chilled water minimum flow flow setpoint for primary-only
plants with a minimum flow bypass valve, 
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 4 on January 7, 2019), 
section 5.2.8 Chilled water minimum flow bypass valve.
</p>
<ul>
<li>
Bypass valve shall modulate to maintain minimum flow <code>yChiWatMinFloSet</code>
at a setpoint equal to the sum of the minimum chilled water flowrate of the chillers
commanded on in each stage.
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
