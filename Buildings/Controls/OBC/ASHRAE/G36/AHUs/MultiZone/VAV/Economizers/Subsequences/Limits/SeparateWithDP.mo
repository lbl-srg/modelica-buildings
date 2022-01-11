within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits;
block SeparateWithDP
  "Outdoor air and return air damper position limits for units with separated minimum outdoor air damper and differential pressure control"

  parameter Real dpDesOutDam_min(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")
    "Design pressure difference across the minimum outdoor air damper";
  parameter Real minSpe(
     final unit="1",
     final min=0,
     final max=1)
     "Minimum supply fan speed";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController dpCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of differential pressure setpoint controller"
    annotation (Dialog(group="DP control"));
  parameter Real kDp(
    final unit="1")=1 "Gain of controller"
    annotation (Dialog(group="DP control"));
  parameter Real TiDp(
    final unit="s",
    final quantity="Time")=0.5 "Time constant of integrator block"
    annotation (Dialog(group="DP control",
      enable=dpCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
             dpCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdDp(
    final unit="s",
    final quantity="Time")=0.1 "Time constant of derivative block"
    annotation (Dialog(group="DP control",
      enable=dpCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
             dpCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real retDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1 "Physically fixed maximum position of the return air damper"
    annotation (Dialog(tab="Commissioning", group="Physical damper position limits"));
  parameter Real retDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the return air damper"
    annotation (Dialog(tab="Commissioning", group="Physical damper position limits"));
  parameter Real outDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the outdoor air damper"
    annotation (Dialog(tab="Commissioning", group="Physical damper position limits"));
  parameter Real outDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the outdoor air damper"
    annotation (Dialog(tab="Commissioning", group="Physical damper position limits"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpMinOutDam(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")
    "Measured pressure difference across the minimum outdoor air damper"
    annotation (Placement(transformation(extent={{-260,260},{-220,300}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOutMinSet_flow_normalized(
    final unit="1")
    "Effective minimum outdoor airflow setpoint, normalized by design minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{-260,220},{-220,260}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan
    "Supply fan status signal"
    annotation (Placement(transformation(extent={{-260,140},{-220,180}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta
    "Freeze protection status signal"
    annotation (Placement(transformation(extent={{-260,100},{-220,140}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-260,60},{-220,100}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPos(
    final min=0,
    final max=1,
    final unit="1") "Economizer outdoor air damper position"
    annotation (Placement(transformation(extent={{-260,0},{-220,40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSupFanSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Supply fan speed"
    annotation (Placement(transformation(extent={{-260,-60},{-220,-20}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yMinOutDam
    "Status of minimum outdoor air damper position, true means it's open"
    annotation (Placement(transformation(extent={{220,140},{260,180}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPosMin(
    final min=outDamPhyPosMin,
    final max=outDamPhyPosMax,
    final unit="1") "Physically minimum outdoor air damper position limit"
    annotation (Placement(transformation(extent={{220,-140},{260,-100}}),
        iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPosMax(
    final min=outDamPhyPosMin,
    final max=outDamPhyPosMax,
    final unit="1") "Physically maximum outdoor air damper position limit"
    annotation (Placement(transformation(extent={{220,-180},{260,-140}}),
        iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPosMin(
    final min=retDamPhyPosMin,
    final max=retDamPhyPosMax,
    final unit="1")
    "Minimum return air damper position limit"
    annotation (Placement(transformation(extent={{220,-220},{260,-180}}),
        iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPosMax(
    final min=retDamPhyPosMin,
    final max=retDamPhyPosMax,
    final unit="1")
    "Maximum return air damper position limit"
    annotation (Placement(transformation(extent={{220,-270},{260,-230}}),
        iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1")
    "Physical maximum return air damper position limit. Required as an input for the economizer enable disable sequence"
    annotation (Placement(transformation(extent={{220,-310},{260,-270}}),
        iconTransformation(extent={{100,-110},{140,-70}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minDesDp(
    final k=dpDesOutDam_min)
    "Design minimum outdoor air damper pressure difference"
    annotation (Placement(transformation(extent={{-160,190},{-140,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro "Square of the normalized minimum airflow"
    annotation (Placement(transformation(extent={{-160,230},{-140,250}})));
  Buildings.Controls.OBC.CDL.Continuous.Product minDp "Minimum pressure difference setpoint"
    annotation (Placement(transformation(extent={{-120,210},{-100,230}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final h=1)
    "Check if the minimum pressure difference setpoint is greater than zero"
    annotation (Placement(transformation(extent={{-80,190},{-60,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Less les(
    final h=0.05)
    "Check if economizer outdoor air damper is less than projected position"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(
    final k=1.1)
    "Projected position with a gain factor"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre(
    final h=0.05)
    "Check if the economizer outdoor air damper is greater than threshold"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Latch enaDis
    "Enable or disable return air damper minimum outdoor air control"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Buildings.Controls.OBC.CDL.Logical.And enaRetDamMin
    "Enable return air damper minimum outdoor air control"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Logical.Or disRetDamMin
    "Disable return air damper minimum outdoor air control"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Controls.OBC.CDL.Logical.Not disMinDam "Check if the minimum outdoor air damper is closed"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset maxRetDam(
    final controllerType=dpCon,
    final k=kDp,
    final Ti=TiDp,
    final Td=TdDp) "Maximum return air damper position"
    annotation (Placement(transformation(extent={{120,290},{140,310}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeProtectionStages.stage1)
    "Freeze protection stage 1"
    annotation (Placement(transformation(extent={{-200,90},{-180,110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Occupied mode index"
    annotation (Placement(transformation(extent={{-200,50},{-180,70}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check if operation mode is occupied"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqual intLesEqu
    "Check if freeze protection stage is stage 0"
    annotation (Placement(transformation(extent={{-160,110},{-140,130}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
  Buildings.Controls.OBC.CDL.Logical.And3 enaMinDam
    "Check if the minimum outdoor air damper should be enabled"
    annotation (Placement(transformation(extent={{-40,150},{-20,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(
    final k=1) "Design fan speed"
    annotation (Placement(transformation(extent={{-200,-80},{-180,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minFanSpe(
    final k=minSpe) "Minimum fan speed"
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0.05) "Constant"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=0.8) "Constant"
    annotation (Placement(transformation(extent={{-200,-20},{-180,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Line moaP(
    final limitBelow=true,
    final limitAbove=true)
    "Linear mapping of the supply fan speed to the control signal"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPhyPosMinSig(
    final k=outDamPhyPosMin)
    "Physically fixed minimum position of the outdoor air damper. This is the initial position of the economizer damper"
    annotation (Placement(transformation(extent={{-200,-130},{-180,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPhyPosMaxSig(
    final k=outDamPhyPosMax)
    "Physically fixed maximum position of the outdoor air damper."
    annotation (Placement(transformation(extent={{-200,-170},{-180,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamPhyPosMinSig(
    final k=retDamPhyPosMin)
    "Physically fixed minimum position of the return air damper"
    annotation (Placement(transformation(extent={{-200,-210},{-180,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamPhyPosMaxSig(
    final k=retDamPhyPosMax)
    "Physically fixed maximum position of the return air damper. This is the initial condition of the return air damper"
    annotation (Placement(transformation(extent={{-200,-250},{-180,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch retDamPosMaxSwi
    "A switch to deactivate the return air damper maximum outdoor airflow control"
    annotation (Placement(transformation(extent={{180,-260},{200,-240}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch retDamPosMinSwi
    "A switch to deactivate the return air damper minimal outdoor airflow control"
    annotation (Placement(transformation(extent={{180,-210},{200,-190}})));

equation
  connect(VOutMinSet_flow_normalized, pro.u1) annotation (Line(points={{-240,240},
          {-200,240},{-200,246},{-162,246}}, color={0,0,127}));
  connect(VOutMinSet_flow_normalized, pro.u2) annotation (Line(points={{-240,240},
          {-200,240},{-200,234},{-162,234}}, color={0,0,127}));
  connect(pro.y, minDp.u1) annotation (Line(points={{-138,240},{-130,240},{-130,
          226},{-122,226}}, color={0,0,127}));
  connect(minDesDp.y, minDp.u2) annotation (Line(points={{-138,200},{-130,200},{
          -130,214},{-122,214}}, color={0,0,127}));
  connect(uOpeMod, intEqu.u1)
    annotation (Line(points={{-240,80},{-162,80}},   color={255,127,0}));
  connect(conInt1.y, intEqu.u2) annotation (Line(points={{-178,60},{-170,60},{-170,
          72},{-162,72}},        color={255,127,0}));
  connect(uFreProSta, intLesEqu.u1)
    annotation (Line(points={{-240,120},{-162,120}}, color={255,127,0}));
  connect(conInt.y, intLesEqu.u2) annotation (Line(points={{-178,100},{-172,100},
          {-172,112},{-162,112}}, color={255,127,0}));
  connect(uSupFan, and2.u1)
    annotation (Line(points={{-240,160},{-122,160}}, color={255,0,255}));
  connect(intLesEqu.y, and2.u2) annotation (Line(points={{-138,120},{-130,120},{
          -130,152},{-122,152}}, color={255,0,255}));
  connect(minDp.y, greThr.u) annotation (Line(points={{-98,220},{-90,220},{-90,200},
          {-82,200}}, color={0,0,127}));
  connect(minFanSpe.y, moaP.x1) annotation (Line(points={{-138,-10},{-130,-10},{
          -130,-32},{-122,-32}}, color={0,0,127}));
  connect(con1.y, moaP.f1) annotation (Line(points={{-178,-10},{-170,-10},{-170,
          -36},{-122,-36}}, color={0,0,127}));
  connect(con.y, moaP.f2) annotation (Line(points={{-138,-70},{-130,-70},{-130,-48},
          {-122,-48}},color={0,0,127}));
  connect(one.y, moaP.x2) annotation (Line(points={{-178,-70},{-170,-70},{-170,-44},
          {-122,-44}},color={0,0,127}));
  connect(uSupFanSpe, moaP.u)
    annotation (Line(points={{-240,-40},{-122,-40}}, color={0,0,127}));
  connect(uOutDamPos, les.u1)
    annotation (Line(points={{-240,20},{-42,20}},  color={0,0,127}));
  connect(moaP.y, les.u2) annotation (Line(points={{-98,-40},{-90,-40},{-90,12},
          {-42,12}},  color={0,0,127}));
  connect(uOutDamPos, gre.u1) annotation (Line(points={{-240,20},{-60,20},{-60,-40},
          {-42,-40}},     color={0,0,127}));
  connect(gai.y, gre.u2) annotation (Line(points={{-58,-70},{-50,-70},{-50,-48},
          {-42,-48}}, color={0,0,127}));
  connect(moaP.y, gai.u) annotation (Line(points={{-98,-40},{-90,-40},{-90,-70},
          {-82,-70}},  color={0,0,127}));
  connect(enaMinDam.y, enaRetDamMin.u1) annotation (Line(points={{-18,160},{-10,
          160},{-10,60},{38,60}},    color={255,0,255}));
  connect(les.y, enaRetDamMin.u2) annotation (Line(points={{-18,20},{10,20},{10,
          52},{38,52}},    color={255,0,255}));
  connect(enaRetDamMin.y, enaDis.u)
    annotation (Line(points={{62,60},{78,60}},  color={255,0,255}));
  connect(enaMinDam.y, disMinDam.u) annotation (Line(points={{-18,160},{-10,160},
          {-10,-10},{-2,-10}},color={255,0,255}));
  connect(disMinDam.y, disRetDamMin.u1)
    annotation (Line(points={{22,-10},{38,-10}}, color={255,0,255}));
  connect(gre.y, disRetDamMin.u2) annotation (Line(points={{-18,-40},{30,-40},{30,
          -18},{38,-18}},color={255,0,255}));
  connect(disRetDamMin.y, enaDis.clr) annotation (Line(points={{62,-10},{70,-10},
          {70,54},{78,54}}, color={255,0,255}));
  connect(greThr.y, enaMinDam.u1) annotation (Line(points={{-58,200},{-50,200},{
          -50,168},{-42,168}}, color={255,0,255}));
  connect(and2.y, enaMinDam.u2)
    annotation (Line(points={{-98,160},{-42,160}},   color={255,0,255}));
  connect(intEqu.y, enaMinDam.u3) annotation (Line(points={{-138,80},{-60,80},{-60,
          152},{-42,152}}, color={255,0,255}));
  connect(minDp.y, maxRetDam.u_s) annotation (Line(points={{-98,220},{-90,220},{
          -90,300},{118,300}},  color={0,0,127}));
  connect(dpMinOutDam, maxRetDam.u_m)
    annotation (Line(points={{-240,280},{130,280},{130,288}}, color={0,0,127}));
  connect(enaDis.y, maxRetDam.trigger)
    annotation (Line(points={{102,60},{124,60},{124,288}},color={255,0,255}));
  connect(retDamPhyPosMaxSig.y, yRetDamPhyPosMax) annotation (Line(points={{-178,
          -240},{-140,-240},{-140,-290},{240,-290}}, color={0,0,127}));
  connect(enaDis.y, retDamPosMaxSwi.u2) annotation (Line(points={{102,60},{124,60},
          {124,-250},{178,-250}}, color={255,0,255}));
  connect(maxRetDam.y, retDamPosMaxSwi.u1) annotation (Line(points={{142,300},{160,
          300},{160,-242},{178,-242}}, color={0,0,127}));
  connect(retDamPosMaxSwi.y, yRetDamPosMax)
    annotation (Line(points={{202,-250},{240,-250}}, color={0,0,127}));
  connect(retDamPhyPosMaxSig.y, retDamPosMaxSwi.u3) annotation (Line(points={{-178,
          -240},{-140,-240},{-140,-258},{178,-258}}, color={0,0,127}));
  connect(enaDis.y, retDamPosMinSwi.u2) annotation (Line(points={{102,60},{124,60},
          {124,-200},{178,-200}}, color={255,0,255}));
  connect(retDamPhyPosMinSig.y, retDamPosMinSwi.u1) annotation (Line(points={{-178,
          -200},{-140,-200},{-140,-192},{178,-192}}, color={0,0,127}));
  connect(retDamPhyPosMaxSig.y, retDamPosMinSwi.u3) annotation (Line(points={{-178,
          -240},{-140,-240},{-140,-208},{178,-208}}, color={0,0,127}));
  connect(retDamPosMinSwi.y, yRetDamPosMin)
    annotation (Line(points={{202,-200},{240,-200}}, color={0,0,127}));
  connect(outDamPhyPosMinSig.y, yOutDamPosMin)
    annotation (Line(points={{-178,-120},{240,-120}}, color={0,0,127}));
  connect(outDamPhyPosMaxSig.y, yOutDamPosMax)
    annotation (Line(points={{-178,-160},{240,-160}}, color={0,0,127}));
  connect(enaMinDam.y, yMinOutDam)
    annotation (Line(points={{-18,160},{240,160}}, color={255,0,255}));

annotation (
  defaultComponentName="ecoLim",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
                 Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,98},{-48,82}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpMinOutDam"),
        Text(
          extent={{-98,70},{-30,52}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VOutMinSet_flow_normalized"),
        Text(
          extent={{-98,-50},{-42,-66}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uOutDamPos"),
        Text(
          extent={{-98,-82},{-42,-96}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uSupFanSpe"),
        Text(
          extent={{36,60},{98,42}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yOutDamPosMin"),
        Text(
          extent={{36,40},{98,22}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yOutDamPosMax"),
        Text(
          extent={{38,-40},{98,-58}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yRetDamPosMax"),
        Text(
          extent={{38,-20},{98,-38}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yRetDamPosMin"),
        Text(
          extent={{30,-78},{98,-96}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yRetDamPhyPosMax"),
        Text(
          extent={{-100,8},{-44,-6}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uFreProSta"),
        Text(
          extent={{-100,38},{-58,24}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uSupFan"),
        Text(
          extent={{-100,-22},{-50,-36}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{52,94},{98,70}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yMinOutDam")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-320},{220,320}})),
  Documentation(info="<html>
<p>
Block that outputs the position limits of the return and outdoor air damper for units
with a separated minimum outdoor air damper and differential pressure control.
It is implemented according to Section 5.16.4 of the ASHRAE Guideline 36, May 2020.
</p>
<h4>Differential pressure setpoint across the minimum outdoor air damper</h4>
<ul>
<li>
Per Section 3.2.1, designer should provide the design pressure difference across
the minimum outdoor air damper, <code>dpDesOutDam_min</code>.
</li>
<li>
Calculate the outdoor air set point with
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.AHU\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.AHU</a>.
</li>
<li>
The minimum outdoor air differential pressure set point shall be calculated per
Section 5.16.4.1.
</li>
</ul>
<h4>Open minimum outdoor air damper</h4>
<p>
Open minimum outdoor air damper when the supply air fan is proven ON and the system
is in occupied mode and the minimum differential pressure set point is greater
than zero. Damper shall be closed otherwise.
</p>
<h4>Return air damper</h4>
<ul>
<li>
Return air damper minimum outdoor air control is enabled when the minimum outdoor
air damper is open and the economizer outdoor air damper is less than a projected
position limit, which is 5% when supply fan speed is at 100% design speed proportionally
up to 80% when the fan is at minimum speed.
</li>
<li>
Return air damper minimum outdoor air control is disabled when the minimum outdoor
air damper is closed or the economizer outdoor air damper is 10% above the projected
position limit as determined above.
</li>
<li>
When enabled, the maximum return air damper set point is modulated from 100% to 0%
to maintain the differential pressure across the minimum outdoor air damper at set
point.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SeparateWithDP;
