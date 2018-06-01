within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences;
block Limits "Single zone VAV AHU minimum outdoor air control - damper position limits"

  parameter Real yFanMin(
    final min=0,
    final max=1,
    final unit="1") = 0.1 "Minimum supply fan operation speed"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real yFanMax(
    final min=0,
    final max=1,
    final unit="1") = 1 "Maximum supply fan operation speed"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real minVOutMinFansSpePos(
    final min=outDamPhyPosMin,
    final max=outDamPhyPosMax,
    final unit="1") = 0.4
    "OA damper position to supply minimum outdoor airflow at minimum fan speed"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real yDam_VOutMin_maxSpe(
    final min=outDamPhyPosMin,
    final max=outDamPhyPosMax,
    final unit="1") = 0.3
    "OA damper position to supply minimum outdoor airflow at maximum fan speed"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real yDam_VOutDes_minSpe(
    final min=minVOutMinFansSpePos,
    final max=outDamPhyPosMax,
    final unit="1") = 0.9
    "OA damper position to supply design outdoor airflow at minimum fan speed"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real yDam_VOutDes_maxSpe(
    final min=yDam_VOutMin_maxSpe,
    final max=outDamPhyPosMax,
    final unit="1") = 0.8
    "OA damper position to supply design outdoor airflow at maximum fan speed"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Modelica.SIunits.VolumeFlowRate VOutMin_flow
    "Calculated minimum outdoor airflow rate"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Modelica.SIunits.VolumeFlowRate VOutDes_flow
    "Calculated design outdoor airflow rate"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real outDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the outdoor air (OA) damper"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Physical damper position limits"));
  parameter Real outDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the outdoor air damper"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Physical damper position limits"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSupFanSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Supply fan speed"
    annotation (Placement(transformation(extent={{-200,90},{-160,130}}),
      iconTransformation(extent={{-120,28},{-100,48}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOutMinSet_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate",
    final min=VOutMin_flow,
    final max=VOutDes_flow)
    "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-200,160},{-160,200}}),
      iconTransformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-200,-180},{-160,-140}}),
      iconTransformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta
    "Freeze protection status signal"
    annotation (Placement(transformation(extent={{-200,-140},{-160,-100}}),
      iconTransformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan
    "Supply fan status signal"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
      iconTransformation(extent={{-120,-30},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPosMin(
    final min=outDamPhyPosMin,
    final max=outDamPhyPosMax,
    final unit="1")
    "Minimum outdoor air damper position limit"
    annotation (Placement(transformation(extent={{160,-50},{180,-30}}),
      iconTransformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPosMax(
    final min=outDamPhyPosMin,
    final max=outDamPhyPosMax,
    final unit="1")
    "Maximum outdoor air damper position limit"
    annotation (Placement(transformation(extent={{160,30},{180,50}}),
      iconTransformation(extent={{100,-50},{120,-30}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yFanMinSig(
    final k=yFanMin) "Minimum supply fan speed"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPhyPosMinSig(
    final k=outDamPhyPosMin)
    "Physically fixed minimum position of the outdoor air (OA) damper"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPhyPosMaxSig(
    final k=outDamPhyPosMax)
    "Physically fixed maximum position of the outdoor air (OA) damper"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yFanMaxSig(
    final k=yFanMax) "Maximum supply fan speed"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minVOutMinFansSpePosSig(final k=
        minVOutMinFansSpePos)
    "OA damper position to supply minimum outdoor airflow at minimum fan speed"
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yDam_VOutDes_minSpeSig(
    final k=yDam_VOutDes_minSpe)
    "OA damper position to supply design outdoor airflow at minimum fan speed"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yDam_VOutMin_maxSpeSig(
    final k=yDam_VOutMin_maxSpe)
    "OA damper position to supply minimum outdoor airflow at maximum fan speed"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yDam_VOutDes_maxSpeSig(
    final k=yDam_VOutDes_maxSpe)
    "OA damper position to supply design outdoor airflow at maximum fan speed"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minVOutSig(
    final k=VOutMin_flow) "Minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{16,170},{36,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desVOutSig(
    final k=VOutDes_flow) "Design outdoor airflow rate"
    annotation (Placement(transformation(extent={{16,90},{36,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Line yDam_VOutMin_curSpe(
    final limitBelow=true,
    final limitAbove=true)
    "Calculates OA damper position required to supply minimum outdoor airflow at current fan speed"
    annotation (Placement(transformation(extent={{16,130},{36,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Line yDam_VOutDes_curSpe(
    final limitBelow=true,
    final limitAbove=true)
    "Calculates OA damper position required to supply design outdoor airflow at current fan speed"
    annotation (Placement(transformation(extent={{16,40},{36,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Line minVOutSetCurFanSpePos(
    final limitBelow=true,
    final limitAbove=true)
    "Calculates OA damper position required to supply minimum outdoor airflow setpoint at current fan speed"
    annotation (Placement(transformation(extent={{100,110},{120,130}})));
  Buildings.Controls.OBC.CDL.Logical.Switch enaDis
    "Logical switch to enable damper position limit calculation or disable it (set min limit to physical minimum)"
    annotation (Placement(transformation(extent={{82,-120},{102,-100}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd and1(final nu=3) "Logical and block"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not block"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Switch enaDis1
    "Logical switch to enable damper position limit calculation or disable it (set max limit to physical minimum)"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage1)
    "Freeze protection stage 1"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  CDL.Integers.LessEqual intLesEqu
    "Check if freeze protection stage is stage 0"
    annotation (Placement(transformation(extent={{-100,-130},{-80,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "Occupied mode index"
    annotation (Placement(transformation(extent={{-140,-190},{-120,-170}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1 "Check if operation mode is occupied"
    annotation (Placement(transformation(extent={{-100,-170},{-80,-150}})));

equation
  connect(minVOutSig.y, minVOutSetCurFanSpePos.x1)
    annotation (Line(points={{37,180},{76,180},{76,128},{98,128}},color={0,0,127}));
  connect(desVOutSig.y, minVOutSetCurFanSpePos.x2)
    annotation (Line(points={{37,100},{66,100},{66,116},{98,116}},color={0,0,127}));
  connect(yDam_VOutMin_curSpe.y, minVOutSetCurFanSpePos.f1)
    annotation (Line(points={{37,140},{37,142},{66,142},{66,124},{98,124}}, color={0,0,127}));
  connect(yDam_VOutDes_curSpe.y, minVOutSetCurFanSpePos.f2)
    annotation (Line(points={{37,50},{76,50},{76,112},{98,112}}, color={0,0,127}));
  connect(enaDis.y, yOutDamPosMin)
    annotation (Line(points={{103,-110},{104,-110},{108,-110},{150,-110},{150,-40},{170,-40}},
    color={0,0,127}));
  connect(yDam_VOutDes_minSpeSig.y, yDam_VOutDes_curSpe.f1)
    annotation (Line(points={{-119,-20},{-100,-20},{-100,54},{14,54}}, color={0,0,127}));
  connect(yDam_VOutDes_maxSpeSig.y, yDam_VOutDes_curSpe.f2)
    annotation (Line(points={{-119,10},{-104,10},{-96,10},{-8,10},{-8,42},{14,42}}, color={0,0,127}));
  connect(minVOutMinFansSpePosSig.y, yDam_VOutMin_curSpe.f1) annotation (Line(
        points={{-119,130},{-120,130},{-118,130},{-28,130},{-28,144},{14,144}},
        color={0,0,127}));
  connect(yDam_VOutMin_maxSpeSig.y, yDam_VOutMin_curSpe.f2)
    annotation (Line(points={{-119,160},{-58,160},{-58,132},{14,132}}, color={0,0,127}));
  connect(uSupFanSpe, yDam_VOutMin_curSpe.u)
    annotation (Line(points={{-180,110},{-24,110},{-24,140},{14,140}}, color={0,0,127}));
  connect(yFanMaxSig.y, yDam_VOutMin_curSpe.x2)
    annotation (Line(points={{-119,90},{2,90},{2,136},{14,136}}, color={0,0,127}));
  connect(yFanMinSig.y, yDam_VOutMin_curSpe.x1)
    annotation (Line(points={{-119,60},{-8,60},{-8,148},{14,148}}, color={0,0,127}));
  connect(yFanMinSig.y, yDam_VOutDes_curSpe.x1)
    annotation (Line(points={{-119,60},{-8,60},{-8,58},{14,58}}, color={0,0,127}));
  connect(yFanMaxSig.y, yDam_VOutDes_curSpe.x2)
    annotation (Line(points={{-119,90},{-14,90},{-14,46},{14,46}}, color={0,0,127}));
  connect(VOutMinSet_flow, minVOutSetCurFanSpePos.u)
    annotation (Line(points={{-180,180},{-20,180},{-20,160},{60,160},{60,120},{98,120}}, color={0,0,127}));
  connect(uSupFanSpe, yDam_VOutDes_curSpe.u)
    annotation (Line(points={{-180,110},{-24,110},{-24,50},{14,50}}, color={0,0,127}));
  connect(and1.y,not1. u)
    annotation (Line(points={{-38.3,-70},{-22,-70}}, color={255,0,255}));
  connect(not1.y, enaDis.u2)
    annotation (Line(points={{1,-70},{2,-70},{2,-70},{0,-70},{40,-70},{40,-110},{80,-110}},color={255,0,255}));
  connect(outDamPhyPosMinSig.y, enaDis.u1)
    annotation (Line(points={{-19,-10},{68,-10},{68,-102},{80,-102}},color={0,0,127}));
  connect(minVOutSetCurFanSpePos.y, enaDis.u3)
    annotation (Line(points={{121,120},{130,120},{130,20},{60,20},{60,-118},{80,-118}},color={0,0,127}));
  connect(outDamPhyPosMinSig.y, enaDis1.u1)
    annotation (Line(points={{-19,-10},{40,-10},{40,-62},{78,-62}},color={0,0,127}));
  connect(outDamPhyPosMaxSig.y, enaDis1.u3)
    annotation (Line(points={{-59,-10},{-50,-10},{-50,-30},{20,-30},{20,-78},{78,-78}},color={0,0,127}));
  connect(enaDis1.y, yOutDamPosMax)
    annotation (Line(points={{101,-70},{140,-70},{140,40},{170,40}}, color={0,0,127}));
  connect(not1.y, enaDis1.u2)
    annotation (Line(points={{1,-70},{48,-70},{78,-70}}, color={255,0,255}));
  connect(uSupFan, and1.u[1])
    annotation (Line(points={{-180,-80},{-122,-80},{-122,-65.3333},{-62,
          -65.3333}},
      color={255,0,255}));
  connect(uOpeMod, intEqu1.u1)
    annotation (Line(points={{-180,-160},{-102,-160}}, color={255,127,0}));
  connect(conInt1.y, intEqu1.u2)
    annotation (Line(points={{-119,-180},{-112,-180},{-112,-168},{-102,-168}},
      color={255,127,0}));
  connect(intLesEqu.y, and1.u[2])
    annotation (Line(points={{-79,-120},{-74,-120},{-74,-70},{-62,-70}}, color={255,0,255}));
  connect(intEqu1.y, and1.u[3])
    annotation (Line(points={{-79,-160},{-68,-160},{-68,-74.6667},{-62,-74.6667}},
      color={255,0,255}));
  connect(intLesEqu.u2, conInt.y)
    annotation (Line(points={{-102,-128},{-110,-128},{-110,-140},{-119,-140}}, color={255,127,0}));
  connect(uFreProSta, intLesEqu.u1)
    annotation (Line(points={{-180,-120},{-102,-120}}, color={255,127,0}));
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
          lineColor={0,0,127},
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
          extent={{62,-152},{206,-234}},
          lineColor={0,0,0},
          fontSize=12,
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
          lineColor={0,0,0},
          fontSize=12,
          horizontalAlignment=TextAlignment.Left,
          textString="Values set at commissioning"),
        Rectangle(
          extent={{4,214},{152,-46}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                                   Text(
          extent={{54,212},{168,188}},
          lineColor={0,0,0},
          fontSize=12,
          horizontalAlignment=TextAlignment.Left,
          textString="Damper position limit
calculation and assignments")}),
    Documentation(info="<html>
<p>
This block implements the single zone VAV AHU minimum outdoor air control with a single
common damper for minimum outdoor air and economizer functions based on outdoor airflow
setpoint (<code>VOutMinSet_flow</code>) and supply fan speed (<code>uSupFanSpe</code>),
designed in line with ASHRAE Guidline 36, PART5.P.4.d.
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
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/AHUs/EconDamperLimitsStateMachineChartSingleZone.png\"/>
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
<code>minVOutMinFansSpePos</code> and
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
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/AHUs/EconDamperLimitsControlChartSingleZone.png\"/>
</p>
</html>", revisions="<html>
<ul>
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
