within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences;
block Limits "Single zone VAV AHU minimum outdoor air control - damper position limits"

  parameter Real supFanSpe_min(
    final min=0,
    final max=1,
    final unit="1") = 0.1 "Minimum supply fan operation speed"
    annotation (__cdl(ValueInReference=False),
                Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real supFanSpe_max(
    final min=0,
    final max=1,
    final unit="1") = 1 "Maximum supply fan operation speed"
    annotation (__cdl(ValueInReference=False),
                Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real outDamMinFloMinSpe(
    final min=outDamPhy_min,
    final max=outDamPhy_max,
    final unit="1") = 0.4
    "OA damper position to supply minimum outdoor airflow at minimum fan speed"
    annotation (__cdl(ValueInReference=False),
                Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real outDamMinFloMaxSpe(
    final min=outDamPhy_min,
    final max=outDamPhy_max,
    final unit="1") = 0.3
    "OA damper position to supply minimum outdoor airflow at maximum fan speed"
    annotation (__cdl(ValueInReference=False),
                Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real outDamDesFloMinSpe(
    final min=outDamMinFloMinSpe,
    final max=outDamPhy_max,
    final unit="1") = 0.9
    "OA damper position to supply design outdoor airflow at minimum fan speed"
    annotation (__cdl(ValueInReference=False),
                Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real outDamDesFloMaxSpe(
    final min=outDamMinFloMaxSpe,
    final max=outDamPhy_max,
    final unit="1") = 0.8
    "OA damper position to supply design outdoor airflow at maximum fan speed"
    annotation (__cdl(ValueInReference=False),
                Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real VOutMin_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Calculated minimum outdoor airflow rate"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real VOutDes_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Calculated design outdoor airflow rate"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real outDamPhy_max(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the outdoor air damper"
    annotation (__cdl(ValueInReference=False),
                Dialog(tab="Commissioning", group="Physical damper position limits"));
  parameter Real outDamPhy_min(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the outdoor air damper"
    annotation (__cdl(ValueInReference=False),
                Dialog(tab="Commissioning", group="Physical damper position limits"));
  parameter Real floHys(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=0.01
    "Near zero flow rate, below which the flow rate or difference will be seen as zero"
    annotation (__cdl(ValueInReference=False),
                Dialog(tab="Commissioning", group="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSupFan_actual(
    final min=0,
    final max=1,
    final unit="1")
    "Actual supply fan speed"
    annotation (Placement(transformation(extent={{-200,90},{-160,130}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOutMinSet_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate",
    final min=VOutMin_flow,
    final max=VOutDes_flow)
    "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-200,160},{-160,200}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-200,-150},{-160,-110}}),
        iconTransformation(extent={{-140,-102},{-100,-62}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta
    "Freeze protection status signal"
    annotation (Placement(transformation(extent={{-200,-110},{-160,-70}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SupFan
    "Supply fan status signal"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDam_min(
    final min=outDamPhy_min,
    final max=outDamPhy_max,
    final unit="1") "Minimum outdoor air damper position limit"
    annotation (Placement(transformation(extent={{160,-60},{200,-20}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDam_max(
    final min=outDamPhy_min,
    final max=outDamPhy_max,
    final unit="1") "Maximum outdoor air damper position limit"
    annotation (Placement(transformation(extent={{160,22},{200,62}}),
        iconTransformation(extent={{100,40},{140,80}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yFanMinSig(
    final k=supFanSpe_min) "Minimum supply fan speed"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPhyPosMinSig(
    final k=outDamPhy_min)
    "Physically fixed minimum position of the outdoor air damper"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPhyPosMaxSig(
    final k=outDamPhy_max)
    "Physically fixed maximum position of the outdoor air damper"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yFanMaxSig(
    final k=supFanSpe_max) "Maximum supply fan speed"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yDam_VOutMin_minSpeSig(
    final k=outDamMinFloMinSpe)
    "OA damper position to supply minimum outdoor airflow at minimum fan speed"
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yDam_VOutDes_minSpeSig(
    final k=outDamDesFloMinSpe)
    "OA damper position to supply design outdoor airflow at minimum fan speed"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yDam_VOutMin_maxSpeSig(
    final k=outDamMinFloMaxSpe)
    "OA damper position to supply minimum outdoor airflow at maximum fan speed"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yDam_VOutDes_maxSpeSig(
    final k=outDamDesFloMaxSpe)
    "OA damper position to supply design outdoor airflow at maximum fan speed"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minVOutSig(
    final k=VOutMin_flow) "Minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{20,170},{40,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desVOutSig(
    final k=VOutDes_flow) "Design outdoor airflow rate"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Line yDam_VOutMin_curSpe(
    final limitBelow=true,
    final limitAbove=true)
    "Calculates OA damper position required to supply minimum outdoor airflow at current fan speed"
    annotation (Placement(transformation(extent={{40,130},{60,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Line yDam_VOutDes_curSpe(
    final limitBelow=true,
    final limitAbove=true)
    "Calculates OA damper position required to supply design outdoor airflow at current fan speed"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Line minVOutSetCurFanSpePos(
    final limitBelow=true,
    final limitAbove=true)
    "Calculates OA damper position required to supply minimum outdoor airflow setpoint at current fan speed"
    annotation (Placement(transformation(extent={{100,110},{120,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch enaDis
    "Logical switch to enable damper position limit calculation or disable it (set min limit to physical minimum)"
    annotation (Placement(transformation(extent={{80,-120},{100,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not block"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch enaDis1
    "Logical switch to enable damper position limit calculation or disable it (set max limit to physical minimum)"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeProtectionStages.stage1)
    "Freeze protection stage 1"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqual intLesEqu
    "Check if freeze protection stage is stage 0"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Occupied mode index"
    annotation (Placement(transformation(extent={{-140,-160},{-120,-140}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1 "Check if operation mode is occupied"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  Buildings.Controls.OBC.CDL.Logical.And3 and3 "Logical and"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch enaDis2
    "Zero minimum damper position when the min OA is near zero"
    annotation (Placement(transformation(extent={{120,-170},{140,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(
    final k=0)
    "Zero minimum damper position"
    annotation (Placement(transformation(extent={{80,-200},{100,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold noZerMin(
    final t=floHys,
    final h=0.5*floHys) "Check if the min OA is greater than zero"
    annotation (Placement(transformation(extent={{20,-170},{40,-150}})));

equation
  connect(minVOutSig.y, minVOutSetCurFanSpePos.x1)
    annotation (Line(points={{42,180},{90,180},{90,128},{98,128}},color={0,0,127}));
  connect(desVOutSig.y, minVOutSetCurFanSpePos.x2)
    annotation (Line(points={{62,100},{80,100},{80,116},{98,116}},color={0,0,127}));
  connect(yDam_VOutMin_curSpe.y, minVOutSetCurFanSpePos.f1)
    annotation (Line(points={{62,140},{80,140},{80,124},{98,124}}, color={0,0,127}));
  connect(yDam_VOutDes_curSpe.y, minVOutSetCurFanSpePos.f2)
    annotation (Line(points={{62,50},{90,50},{90,112},{98,112}}, color={0,0,127}));
  connect(yDam_VOutDes_minSpeSig.y, yDam_VOutDes_curSpe.f1)
    annotation (Line(points={{-118,-20},{-100,-20},{-100,54},{38,54}}, color={0,0,127}));
  connect(yDam_VOutDes_maxSpeSig.y, yDam_VOutDes_curSpe.f2)
    annotation (Line(points={{-118,20},{-80,20},{-80,42},{38,42}}, color={0,0,127}));
  connect(yDam_VOutMin_minSpeSig.y, yDam_VOutMin_curSpe.f1)
    annotation (Line(points={{-118,130},{-90,130},{-90,144},{38,144}}, color={0,0,127}));
  connect(yDam_VOutMin_maxSpeSig.y, yDam_VOutMin_curSpe.f2)
    annotation (Line(points={{-118,160},{-60,160},{-60,132},{38,132}}, color={0,0,127}));
  connect(uSupFan_actual, yDam_VOutMin_curSpe.u) annotation (Line(points={{-180,
          110},{-80,110},{-80,140},{38,140}}, color={0,0,127}));
  connect(yFanMaxSig.y, yDam_VOutMin_curSpe.x2)
    annotation (Line(points={{-118,90},{30,90},{30,136},{38,136}}, color={0,0,127}));
  connect(yFanMinSig.y, yDam_VOutMin_curSpe.x1)
    annotation (Line(points={{-118,60},{20,60},{20,148},{38,148}}, color={0,0,127}));
  connect(yFanMinSig.y, yDam_VOutDes_curSpe.x1)
    annotation (Line(points={{-118,60},{20,60},{20,58},{38,58}}, color={0,0,127}));
  connect(yFanMaxSig.y, yDam_VOutDes_curSpe.x2)
    annotation (Line(points={{-118,90},{30,90},{30,46},{38,46}},   color={0,0,127}));
  connect(VOutMinSet_flow, minVOutSetCurFanSpePos.u)
    annotation (Line(points={{-180,180},{-30,180},{-30,120},{98,120}}, color={0,0,127}));
  connect(uSupFan_actual, yDam_VOutDes_curSpe.u) annotation (Line(points={{-180,
          110},{-80,110},{-80,50},{38,50}}, color={0,0,127}));
  connect(not1.y, enaDis.u2)
    annotation (Line(points={{2,-70},{40,-70},{40,-110},{78,-110}}, color={255,0,255}));
  connect(outDamPhyPosMinSig.y, enaDis.u1)
    annotation (Line(points={{42,0},{68,0},{68,-102},{78,-102}}, color={0,0,127}));
  connect(minVOutSetCurFanSpePos.y, enaDis.u3)
    annotation (Line(points={{122,120},{130,120},{130,20},{60,20},{60,-118},{78,
          -118}}, color={0,0,127}));
  connect(outDamPhyPosMinSig.y, enaDis1.u1)
    annotation (Line(points={{42,0},{68,0},{68,-62},{78,-62}}, color={0,0,127}));
  connect(outDamPhyPosMaxSig.y, enaDis1.u3)
    annotation (Line(points={{42,-40},{50,-40},{50,-78},{78,-78}}, color={0,0,127}));
  connect(enaDis1.y, yOutDam_max) annotation (Line(points={{102,-70},{140,-70},{
          140,42},{180,42}}, color={0,0,127}));
  connect(not1.y, enaDis1.u2)
    annotation (Line(points={{2,-70},{78,-70}}, color={255,0,255}));
  connect(uOpeMod, intEqu1.u1)
    annotation (Line(points={{-180,-130},{-102,-130}}, color={255,127,0}));
  connect(conInt1.y, intEqu1.u2)
    annotation (Line(points={{-118,-150},{-112,-150},{-112,-138},{-102,-138}},
      color={255,127,0}));
  connect(intLesEqu.u2, conInt.y)
    annotation (Line(points={{-102,-98},{-110,-98},{-110,-110},{-118,-110}}, color={255,127,0}));
  connect(uFreProSta, intLesEqu.u1)
    annotation (Line(points={{-180,-90},{-102,-90}},   color={255,127,0}));
  connect(u1SupFan, and3.u1) annotation (Line(points={{-180,-40},{-80,-40},{-80,
          -62},{-62,-62}}, color={255,0,255}));
  connect(intLesEqu.y, and3.u2) annotation (Line(points={{-78,-90},{-74,-90},{-74,
          -70},{-62,-70}},      color={255,0,255}));
  connect(intEqu1.y, and3.u3) annotation (Line(points={{-78,-130},{-68,-130},{-68,
          -78},{-62,-78}},     color={255,0,255}));
  connect(and3.y, not1.u)
    annotation (Line(points={{-38,-70},{-22,-70}}, color={255,0,255}));
  connect(VOutMinSet_flow, noZerMin.u) annotation (Line(points={{-180,180},{-30,
          180},{-30,-160},{18,-160}}, color={0,0,127}));
  connect(noZerMin.y, enaDis2.u2)
    annotation (Line(points={{42,-160},{118,-160}}, color={255,0,255}));
  connect(enaDis.y, enaDis2.u1) annotation (Line(points={{102,-110},{110,-110},{
          110,-152},{118,-152}}, color={0,0,127}));
  connect(enaDis2.y, yOutDam_min) annotation (Line(points={{142,-160},{150,-160},
          {150,-40},{180,-40}}, color={0,0,127}));
  connect(zer.y, enaDis2.u3) annotation (Line(points={{102,-190},{110,-190},{110,
          -168},{118,-168}}, color={0,0,127}));

annotation (
    defaultComponentName = "damLim",
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-76,80},{-72,76}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-78,-56},{-74,-60}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{72,60},{76,56}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{72,-74},{76,-78}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-74,78},{72,58}},
          color={0,0,127},
          thickness=0.5),
        Line(
          points={{-74,-58},{74,-76}},
          color={0,0,127},
          thickness=0.5),
        Line(
          points={{-2,-66},{-2,70}},
          color={0,0,127},
          thickness=0.5),
        Rectangle(
          extent={{-4,-64},{0,-68}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,70},{0,66}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name"),
        Ellipse(
          extent={{-4,-10},{0,-14}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(extent={{-160,-220},{160,220}}), graphics={
        Rectangle(
          extent={{-154,-50},{154,-212}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-114,-172},{96,-210}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Enable/disable conditions
for damper position limits
control loop"),
        Rectangle(
          extent={{-154,218},{-6,-42}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                                   Text(
          extent={{-140,212},{-32,194}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Values set at commissioning"),
        Rectangle(
          extent={{6,218},{154,-42}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                                   Text(
          extent={{44,220},{122,204}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Damper position limit"),
        Text(
          extent={{46,206},{148,194}},
          textColor={0,0,0},
          textString="calculation and assignments")}),
    Documentation(info="<html>
<p>
This block implements the single zone VAV AHU minimum outdoor air control with a single
common damper for minimum outdoor air and economizer functions based on outdoor airflow
setpoint (<code>VOutMinSet_flow</code>) and supply fan speed (<code>uSupFanSpe_actual</code>),
designed in line with Section 5.18.6 of ASHRAE Guidline 36, May 2020.
</p>
<p>
The controller is enabled when the supply fan is proven on (<code>u1SupFan=true</code>),
the AHU operation mode <code>uOpeMod</code> is Occupied, and Freeze protection stage
<code>uFreProSta</code> is 1 or smaller. Otherwise the damper position limits are set to
their corresponding maximum and minimum physical or at commissioning fixed limits, as illustrated below:
<br/>
</p>
<p align=\"center\">
<img alt=\"Image of damper position limits state machine chart\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/AHUs/SingleZone/VAV/Economizers/Subsequences/LimitsStateMachine.png\"/>
</p>
<p>
If limit modulation is enabled, the outdoor air damper position <code>yOutDamPosMin</code> is computed as
follows:</p>
<ol>
<li>
Calculate outdoor air damper position <code>yDam_VOutMin_curSpe</code>
which ensures minimum outdoor airflow rate <code>VOutMin_flow</code>
at current supply fan speed <code>uSupFanSpe_actual</code> as a linear
interpolation between the following values set at commissioning:<br/>
<ul>
<li>minimum damper position at minimum fan speed for minimum outdoor airflow
<code>outDamMinFloMinSpe</code> and
</li>
<li>
minimum damper position at maximum fan speed for minimum outdoor airflow
<code>outDamMinFloMaxSpe</code>.
</li>
</ul>
</li>
<li>
Calculate outdoor air damper position <code>yDam_VOutDes_curSpe</code>
which ensures design outdoor airflow rate <code>VOutDes_flow</code> at
current supply fan speed <code>uSupFanSpe_actual</code>, as a linear
interpolation between the following values set at commissioning:<br/>
<ul>
<li>
minimum damper position at minimum fan speed for design outdoor airflow
<code>outDamDesFloMinSpe</code> and
</li>
<li>
minimum damper position at maximum fan speed for design outdoor airflow
<code>outDamDesFloMaxSpe</code>.
</li>
</ul>
</li>
<li>
Calculate outdoor air damper position <code>yOutDamPosMin</code>
which ensures outdoor airflow setpoint <code>VOutMinSet_flow</code>
at current supply fan speed <code>uSupFanSpe_actual</code> as a linear interpolation
between <code>yDam_VOutMin_curSpe</code> and <code>yDam_VOutDes_curSpe</code>, proportional to ratios of
<code>VOutMinSet_flow</code> to <code>VOutDes_flow</code> and <code>VOutMin_flow</code>.
</li>
<li>
If outdoor airflow setpoint <code>VOutMinSet_flow</code> is zero, <code>yOutDamPosMin</code>
should be zero.
</li>
</ol>
<p>
The chart below illustrates the OA damper position limit calculation:
<br/>
</p>
<p align=\"center\">
<img alt=\"Image of damper position limits control chart\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/AHUs/SingleZone/VAV/Economizers/Subsequences/LimitsControlChart.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
Updated according to ASHRAE G36, May 2020.
</li>
<li>
March 13, 2020, by Jianjun Hu:<br/>
Replaced multiAnd block with and3 block to avoid vector related implementation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1709\">#1709</a>.
</li>
<li>
July 06, 2017, by Milica Grahovac:<br/>
Refactored implementation.
</li>
<li>
April 15, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Limits;
