within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences;
block Limits "Single zone VAV AHU minimum outdoor air control - damper position limits"

  parameter Real yFanMin(
    final min=0,
    final max=1,
    final unit="1") = 0.1 "Minimum supply fan operation speed"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real yFanMax(
    final min=0,
    final max=1,
    final unit="1") = 1 "Maximum supply fan operation speed"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real yDam_VOutMin_minSpe(
    final min=outDamPhyPosMin,
    final max=outDamPhyPosMax,
    final unit="1") = 0.4
    "OA damper position to supply minimum outdoor airflow at minimum fan speed"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real yDam_VOutMin_maxSpe(
    final min=outDamPhyPosMin,
    final max=outDamPhyPosMax,
    final unit="1") = 0.3
    "OA damper position to supply minimum outdoor airflow at maximum fan speed"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real yDam_VOutDes_minSpe(
    final min=yDam_VOutMin_minSpe,
    final max=outDamPhyPosMax,
    final unit="1") = 0.9
    "OA damper position to supply design outdoor airflow at minimum fan speed"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real yDam_VOutDes_maxSpe(
    final min=yDam_VOutMin_maxSpe,
    final max=outDamPhyPosMax,
    final unit="1") = 0.8
    "OA damper position to supply design outdoor airflow at maximum fan speed"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real VOutMin_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Calculated minimum outdoor airflow rate"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real VOutDes_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Calculated design outdoor airflow rate"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real outDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the outdoor air damper"
    annotation(Dialog(tab="Commissioning", group="Physical damper position limits"));
  parameter Real outDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the outdoor air damper"
    annotation(Dialog(tab="Commissioning", group="Physical damper position limits"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSupFanSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Supply fan speed"
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
    annotation (Placement(transformation(extent={{-200,-180},{-160,-140}}),
        iconTransformation(extent={{-140,-102},{-100,-62}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta
    "Freeze protection status signal"
    annotation (Placement(transformation(extent={{-200,-140},{-160,-100}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan
    "Supply fan status signal"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPosMin(
    final min=outDamPhyPosMin,
    final max=outDamPhyPosMax,
    final unit="1")
    "Minimum outdoor air damper position limit"
    annotation (Placement(transformation(extent={{160,-60},{200,-20}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPosMax(
    final min=outDamPhyPosMin,
    final max=outDamPhyPosMax,
    final unit="1")
    "Maximum outdoor air damper position limit"
    annotation (Placement(transformation(extent={{160,22},{200,62}}),
        iconTransformation(extent={{100,40},{140,80}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yFanMinSig(
    final k=yFanMin) "Minimum supply fan speed"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant outDamPhyPosMinSig(
    final k=outDamPhyPosMin)
    "Physically fixed minimum position of the outdoor air damper"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant outDamPhyPosMaxSig(
    final k=outDamPhyPosMax)
    "Physically fixed maximum position of the outdoor air damper"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yFanMaxSig(
    final k=yFanMax) "Maximum supply fan speed"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yDam_VOutMin_minSpeSig(
    final k=yDam_VOutMin_minSpe)
    "OA damper position to supply minimum outdoor airflow at minimum fan speed"
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yDam_VOutDes_minSpeSig(
    final k=yDam_VOutDes_minSpe)
    "OA damper position to supply design outdoor airflow at minimum fan speed"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yDam_VOutMin_maxSpeSig(
    final k=yDam_VOutMin_maxSpe)
    "OA damper position to supply minimum outdoor airflow at maximum fan speed"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yDam_VOutDes_maxSpeSig(
    final k=yDam_VOutDes_maxSpe)
    "OA damper position to supply design outdoor airflow at maximum fan speed"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minVOutSig(
    final k=VOutMin_flow) "Minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{16,170},{36,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant desVOutSig(
    final k=VOutDes_flow) "Design outdoor airflow rate"
    annotation (Placement(transformation(extent={{16,90},{36,110}})));
  Buildings.Controls.OBC.CDL.Reals.Line yDam_VOutMin_curSpe(
    final limitBelow=true,
    final limitAbove=true)
    "Calculates OA damper position required to supply minimum outdoor airflow at current fan speed"
    annotation (Placement(transformation(extent={{16,130},{36,150}})));
  Buildings.Controls.OBC.CDL.Reals.Line yDam_VOutDes_curSpe(
    final limitBelow=true,
    final limitAbove=true)
    "Calculates OA damper position required to supply design outdoor airflow at current fan speed"
    annotation (Placement(transformation(extent={{16,40},{36,60}})));
  Buildings.Controls.OBC.CDL.Reals.Line minVOutSetCurFanSpePos(
    final limitBelow=true,
    final limitAbove=true)
    "Calculates OA damper position required to supply minimum outdoor airflow setpoint at current fan speed"
    annotation (Placement(transformation(extent={{100,110},{120,130}})));
  Buildings.Controls.OBC.CDL.Reals.Switch enaDis
    "Logical switch to enable damper position limit calculation or disable it (set min limit to physical minimum)"
    annotation (Placement(transformation(extent={{82,-120},{102,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not block"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Switch enaDis1
    "Logical switch to enable damper position limit calculation or disable it (set max limit to physical minimum)"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage1)
    "Freeze protection stage 1"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqual intLesEqu
    "Check if freeze protection stage is stage 0"
    annotation (Placement(transformation(extent={{-100,-130},{-80,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "Occupied mode index"
    annotation (Placement(transformation(extent={{-140,-190},{-120,-170}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1 "Check if operation mode is occupied"
    annotation (Placement(transformation(extent={{-100,-170},{-80,-150}})));
  Buildings.Controls.OBC.CDL.Logical.And3 and3 "Logical and"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

equation
  connect(minVOutSig.y, minVOutSetCurFanSpePos.x1)
    annotation (Line(points={{38,180},{76,180},{76,128},{98,128}},color={0,0,127}));
  connect(desVOutSig.y, minVOutSetCurFanSpePos.x2)
    annotation (Line(points={{38,100},{66,100},{66,116},{98,116}},color={0,0,127}));
  connect(yDam_VOutMin_curSpe.y, minVOutSetCurFanSpePos.f1)
    annotation (Line(points={{38,140},{38,142},{66,142},{66,124},{98,124}}, color={0,0,127}));
  connect(yDam_VOutDes_curSpe.y, minVOutSetCurFanSpePos.f2)
    annotation (Line(points={{38,50},{76,50},{76,112},{98,112}}, color={0,0,127}));
  connect(enaDis.y, yOutDamPosMin)
    annotation (Line(points={{104,-110},{150,-110},{150,-40},{180,-40}},
    color={0,0,127}));
  connect(yDam_VOutDes_minSpeSig.y, yDam_VOutDes_curSpe.f1)
    annotation (Line(points={{-118,-20},{-100,-20},{-100,54},{14,54}}, color={0,0,127}));
  connect(yDam_VOutDes_maxSpeSig.y, yDam_VOutDes_curSpe.f2)
    annotation (Line(points={{-118,10},{-8,10},{-8,42},{14,42}}, color={0,0,127}));
  connect(yDam_VOutMin_minSpeSig.y, yDam_VOutMin_curSpe.f1)
    annotation (Line(points={{-118,130},{-118,130},{-118,130},{-28,130},{-28,144},
          {14,144}},       color={0,0,127}));
  connect(yDam_VOutMin_maxSpeSig.y, yDam_VOutMin_curSpe.f2)
    annotation (Line(points={{-118,160},{-58,160},{-58,132},{14,132}}, color={0,0,127}));
  connect(uSupFanSpe, yDam_VOutMin_curSpe.u)
    annotation (Line(points={{-180,110},{-24,110},{-24,140},{14,140}}, color={0,0,127}));
  connect(yFanMaxSig.y, yDam_VOutMin_curSpe.x2)
    annotation (Line(points={{-118,90},{2,90},{2,136},{14,136}}, color={0,0,127}));
  connect(yFanMinSig.y, yDam_VOutMin_curSpe.x1)
    annotation (Line(points={{-118,60},{-8,60},{-8,148},{14,148}}, color={0,0,127}));
  connect(yFanMinSig.y, yDam_VOutDes_curSpe.x1)
    annotation (Line(points={{-118,60},{-8,60},{-8,58},{14,58}}, color={0,0,127}));
  connect(yFanMaxSig.y, yDam_VOutDes_curSpe.x2)
    annotation (Line(points={{-118,90},{-14,90},{-14,46},{14,46}}, color={0,0,127}));
  connect(VOutMinSet_flow, minVOutSetCurFanSpePos.u)
    annotation (Line(points={{-180,180},{-20,180},{-20,160},{60,160},{60,120},{98,120}}, color={0,0,127}));
  connect(uSupFanSpe, yDam_VOutDes_curSpe.u)
    annotation (Line(points={{-180,110},{-24,110},{-24,50},{14,50}}, color={0,0,127}));
  connect(not1.y, enaDis.u2)
    annotation (Line(points={{2,-70},{2,-70},{2,-70},{0,-70},{40,-70},{40,-110},
          {80,-110}},                                                                      color={255,0,255}));
  connect(outDamPhyPosMinSig.y, enaDis.u1)
    annotation (Line(points={{-18,-10},{68,-10},{68,-102},{80,-102}},color={0,0,127}));
  connect(minVOutSetCurFanSpePos.y, enaDis.u3)
    annotation (Line(points={{122,120},{130,120},{130,20},{60,20},{60,-118},{80,
          -118}},                                                                      color={0,0,127}));
  connect(outDamPhyPosMinSig.y, enaDis1.u1)
    annotation (Line(points={{-18,-10},{40,-10},{40,-62},{78,-62}},color={0,0,127}));
  connect(outDamPhyPosMaxSig.y, enaDis1.u3)
    annotation (Line(points={{-58,-10},{-50,-10},{-50,-30},{20,-30},{20,-78},{78,
          -78}},                                                                       color={0,0,127}));
  connect(enaDis1.y, yOutDamPosMax)
    annotation (Line(points={{102,-70},{140,-70},{140,42},{180,42}}, color={0,0,127}));
  connect(not1.y, enaDis1.u2)
    annotation (Line(points={{2,-70},{78,-70}}, color={255,0,255}));
  connect(uOpeMod, intEqu1.u1)
    annotation (Line(points={{-180,-160},{-102,-160}}, color={255,127,0}));
  connect(conInt1.y, intEqu1.u2)
    annotation (Line(points={{-118,-180},{-112,-180},{-112,-168},{-102,-168}},
      color={255,127,0}));
  connect(intLesEqu.u2, conInt.y)
    annotation (Line(points={{-102,-128},{-110,-128},{-110,-140},{-118,-140}}, color={255,127,0}));
  connect(uFreProSta, intLesEqu.u1)
    annotation (Line(points={{-180,-120},{-102,-120}}, color={255,127,0}));
  connect(uSupFan, and3.u1) annotation (Line(points={{-180,-80},{-80,-80},{-80,
          -62},{-62,-62}}, color={255,0,255}));
  connect(intLesEqu.y, and3.u2) annotation (Line(points={{-78,-120},{-74,-120},
          {-74,-70},{-62,-70}}, color={255,0,255}));
  connect(intEqu1.y, and3.u3) annotation (Line(points={{-78,-160},{-68,-160},{
          -68,-78},{-62,-78}}, color={255,0,255}));
  connect(and3.y, not1.u)
    annotation (Line(points={{-38,-70},{-22,-70}}, color={255,0,255}));
annotation (Placement(transformation(extent={{-20,110},{0,130}})),
                Placement(transformation(extent={{-20,20},{0,40}})),
                Placement(transformation(extent={{60,90},{80,110}})),
                Placement(transformation(extent={{-140,130},{-120,150}})),
                Placement(transformation(extent={{-140,-30},{-120,-10}})),
                Placement(transformation(extent={{-140,160},{-120,180}})),
                Placement(transformation(extent={{-140,0},{-120,20}})),
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
          extent={{-124,146},{128,110}},
          textColor={0,0,127},
          textString="%name"),
        Ellipse(
          extent={{-4,-10},{0,-14}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(extent={{-160,-220},{160,220}}), graphics={
        Rectangle(
          extent={{-152,-52},{152,-214}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                                   Text(
          extent={{-52,-156},{158,-194}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Enable/disable conditions
for damper position limits
control loop"),
        Rectangle(
          extent={{-152,214},{-4,-46}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                                   Text(
          extent={{-140,212},{-32,194}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Values set at commissioning"),
        Rectangle(
          extent={{4,214},{152,-46}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                                   Text(
          extent={{48,212},{126,196}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Damper position limit"),
        Text(
          extent={{50,198},{152,186}},
          textColor={0,0,0},
          textString="calculation and assignments")}),
    Documentation(info="<html>
<p>
This block implements the single zone VAV AHU minimum outdoor air control with a single
common damper for minimum outdoor air and economizer functions based on outdoor airflow
setpoint (<code>VOutMinSet_flow</code>) and supply fan speed (<code>uSupFanSpe</code>),
designed in line with ASHRAE Guidline 36, PART 5.P.4.d.
</p>
<p>
The controller is enabled when the supply fan is proven on (<code>uSupFan=true</code>),
the AHU operation mode <code>uOpeMod</code> is Occupied, and Freeze protection stage
<code>uFreProSta</code> is 1 or smaller. Otherwise the damper position limits are set to
their corresponding maximum and minimum physical or at commissioning fixed limits, as illustrated below:
<br/>
</p>
<p align=\"center\">
<img alt=\"Image of damper position limits state machine chart\"
src=\"modelica://Buildings/Resources/Images/Obsolete/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/VAV/Economizers/Subsequences/LimitsStateMachine.png\"/>
</p>
<p>
If limit modulation is enabled, the outdoor air damper position <code>yOutDamPosMin</code> is computed as
follows:</p>
<ol>
<li>
Calculate outdoor air damper position <code>yDam_VOutMin_curSpe</code>
which ensures minimum outdoor airflow rate <code>VOutMin_flow</code>
at current supply fan speed <code>uSupFanSpe</code> as a linear
interpolation between the following values set at commissioning:<br/>
<ul>
<li>minimum damper position at minimum fan speed for minimum outdoor airflow
<code>yDam_VOutMin_minSpe</code> and
</li>
<li>
minimum damper position at maximum fan speed for minimum outdoor airflow
<code>yDam_VOutMin_maxSpe</code>.
</li>
</ul>
</li>
<li>
Calculate outdoor air damper position <code>yDam_VOutDes_curSpe</code>
which ensures design outdoor airflow rate <code>VOutDes_flow</code> at
current supply fan speed <code>uSupFanSpe</code>, as a linear
interpolation between the following values set at commissioning:<br/>
<ul>
<li>
minimum damper position at minimum fan speed for design outdoor airflow
<code>yDam_VOutDes_minSpe</code> and
</li>
<li>
minimum damper position at maximum fan speed for design outdoor airflow
<code>yDam_VOutDes_maxSpe</code>.
</li>
</ul>
</li>
<li>
Calculate outdoor air damper position <code>yOutDamPosMin</code>
which ensures outdoor airflow setpoint <code>VOutMinSet_flow</code>
at current supply fan speed <code>uSupFanSpe</code> as a linear interpolation
between <code>yDam_VOutMin_curSpe</code> and <code>yDam_VOutDes_curSpe</code>, proportional to ratios of
<code>VOutMinSet_flow</code> to <code>VOutDes_flow</code> and <code>VOutMin_flow</code>.
</li>
</ol>
<p>
The chart below illustrates the OA damper position limit calculation:
<br/>
</p>
<p align=\"center\">
<img alt=\"Image of damper position limits control chart\"
src=\"modelica://Buildings/Resources/Images/Obsolete/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/VAV/Economizers/Subsequences/LimitsControlChart.png\"/>
</p>
</html>", revisions="<html>
<ul>
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
