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
    annotation (Placement(transformation(extent={{-300,560},{-260,600}}),
      iconTransformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexEnaChi
    "Index of next enabling chiller"
    annotation (Placement(transformation(extent={{-300,460},{-260,500}}),
      iconTransformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexDisChi
    "Index of next disabling chiller"
    annotation (Placement(transformation(extent={{-300,320},{-260,360}}),
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

  CDL.Continuous.Division floRat[nChi] "Flow rate ratio through each chiller"
    annotation (Placement(transformation(extent={{-180,610},{-160,630}})));
  CDL.Logical.Switch swi1[nChi] "Flow rate ratio of operating chiller"
    annotation (Placement(transformation(extent={{-120,570},{-100,590}})));
  CDL.Continuous.MultiMax multiMax
    annotation (Placement(transformation(extent={{-80,570},{-60,590}})));
  CDL.Logical.Switch swi2[nChi] "Minimum flow rate of operating chiller"
    annotation (Placement(transformation(extent={{-120,530},{-100,550}})));
  CDL.Continuous.MultiSum mulSum
    annotation (Placement(transformation(extent={{-80,530},{-60,550}})));
  CDL.Continuous.MultiMax multiMax1
    annotation (Placement(transformation(extent={{-370,390},{-350,410}})));
  CDL.Routing.RealExtractor nexChiRat(nin=nChi)
    "Flow rate ratio of next enabling chiller"
    annotation (Placement(transformation(extent={{-120,490},{-100,510}})));
  CDL.Routing.RealExtractor nexChiMinFlo(nin=nChi)
    "Minimum flow rate of next enabling chiller"
    annotation (Placement(transformation(extent={{-120,450},{-100,470}})));
  CDL.Continuous.Max max
    annotation (Placement(transformation(extent={{-20,490},{0,510}})));
  CDL.Continuous.Add add2
    annotation (Placement(transformation(extent={{-20,450},{0,470}})));
  CDL.Continuous.Product pro
    annotation (Placement(transformation(extent={{40,550},{60,570}})));
  CDL.Continuous.Product pro1
    annotation (Placement(transformation(extent={{40,470},{60,490}})));
  CDL.Integers.Sources.Constant conInt[nChi](k=chiInd) "Chiller index vector"
    annotation (Placement(transformation(extent={{-240,370},{-220,390}})));

  CDL.Routing.IntegerReplicator intRep(nout=nChi) "Replicate integer input"
    annotation (Placement(transformation(extent={{-240,330},{-220,350}})));
  CDL.Integers.Equal intEqu[nChi] "Check equality of two integer inputs"
    annotation (Placement(transformation(extent={{-180,370},{-160,390}})));
protected
  final parameter Integer chiInd[nChi]={i for i in 1:nChi}
    "Chiller index, {1,2,...,n}";
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

protected
  CDL.Continuous.Sources.Constant                        minFlo[nChi](final k=
        minFloSet) "Minimum chilled water flow through each chiller"
    annotation (Placement(transformation(extent={{-240,630},{-220,650}})));
protected
  CDL.Continuous.Sources.Constant maxFlo[nChi](final k=maxFloSet)
    "Maximum chilled water flow through each chiller"
    annotation (Placement(transformation(extent={{-240,600},{-220,620}})));
protected
  CDL.Continuous.Sources.Constant zer[nChi](final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-240,550},{-220,570}})));
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
  connect(swi.y, dowSet.f2)
    annotation (Line(points={{41,50},{60,50},{60,-68},{78,-68}}, color={0,0,127}));
  connect(uStaUp, byPasSet.u2)
    annotation (Line(points={{-280,180},{-220,180},{-220,160},{120,160},{120,40},{138,40}},
      color={255,0,255}));
  connect(and4.y, byPasSet1.u2)
    annotation (Line(points={{221,160},{240,160},{240,120},{180,120},{180,60},{198,60}},
      color={255,0,255}));

  connect(minFlo.y, floRat.u1) annotation (Line(points={{-219,640},{-200,640},{-200,
          626},{-182,626}}, color={0,0,127}));
  connect(maxFlo.y, floRat.u2) annotation (Line(points={{-219,610},{-190,610},{-190,
          614},{-182,614}}, color={0,0,127}));
  connect(uChi, swi1.u2)
    annotation (Line(points={{-280,580},{-122,580}}, color={255,0,255}));
  connect(floRat.y, swi1.u1) annotation (Line(points={{-159,620},{-140,620},{-140,
          588},{-122,588}}, color={0,0,127}));
  connect(zer.y, swi1.u3) annotation (Line(points={{-219,560},{-160,560},{-160,572},
          {-122,572}}, color={0,0,127}));
  connect(uChi, swi2.u2) annotation (Line(points={{-280,580},{-180,580},{-180,540},
          {-122,540}}, color={255,0,255}));
  connect(zer.y, swi2.u3) annotation (Line(points={{-219,560},{-160,560},{-160,532},
          {-122,532}}, color={0,0,127}));
  connect(minFlo.y, swi2.u1) annotation (Line(points={{-219,640},{-200,640},{-200,
          548},{-122,548}}, color={0,0,127}));
  connect(nexEnaChi, nexChiRat.index) annotation (Line(points={{-280,480},{-110,
          480},{-110,488}}, color={255,127,0}));
  connect(floRat.y, nexChiRat.u) annotation (Line(points={{-159,620},{-140,620},
          {-140,500},{-122,500}}, color={0,0,127}));
  connect(minFlo.y, nexChiMinFlo.u) annotation (Line(points={{-219,640},{-200,640},
          {-200,460},{-122,460}}, color={0,0,127}));
  connect(nexEnaChi, nexChiMinFlo.index) annotation (Line(points={{-280,480},{-220,
          480},{-220,440},{-110,440},{-110,448}}, color={255,127,0}));
  connect(nexChiRat.y, max.u2) annotation (Line(points={{-99,500},{-60,500},{-60,
          494},{-22,494}}, color={0,0,127}));
  connect(multiMax.y, max.u1) annotation (Line(points={{-59,580},{-40,580},{-40,
          506},{-22,506}}, color={0,0,127}));
  connect(nexChiMinFlo.y, add2.u2) annotation (Line(points={{-99,460},{-60,460},
          {-60,454},{-22,454}}, color={0,0,127}));
  connect(mulSum.y, add2.u1) annotation (Line(points={{-59,540},{-44,540},{-44,466},
          {-22,466}}, color={0,0,127}));
  connect(multiMax.y, pro.u1) annotation (Line(points={{-59,580},{-40,580},{-40,
          566},{38,566}}, color={0,0,127}));
  connect(mulSum.y, pro.u2) annotation (Line(points={{-59,540},{-44,540},{-44,554},
          {38,554}}, color={0,0,127}));
  connect(max.y, pro1.u1) annotation (Line(points={{1,500},{20,500},{20,486},{38,
          486}}, color={0,0,127}));
  connect(add2.y, pro1.u2) annotation (Line(points={{1,460},{20,460},{20,474},{38,
          474}}, color={0,0,127}));
  connect(nexDisChi, intRep.u)
    annotation (Line(points={{-280,340},{-242,340}}, color={255,127,0}));
annotation (
  defaultComponentName="minChiFloSet",
  Icon(coordinateSystem(extent={{-260,-200},{260,660}}),
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
          extent={{-260,-200},{260,660}})),
  Documentation(info="<html>
<p>
Block that output chilled water minimum flow setpoint for primary-only
plants with a minimum flow bypass valve, 
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 4 on January 7, 2019), 
section 5.2.8 Chilled water minimum flow bypass valve.
</p>
<ul>
<li>
The chilled water minimum flow setpoint <code>yChiWatMinFloSet</code> equals to the 
sum of the minimum chilled water flowrates of the chillers
commanded to run in each stage.
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
