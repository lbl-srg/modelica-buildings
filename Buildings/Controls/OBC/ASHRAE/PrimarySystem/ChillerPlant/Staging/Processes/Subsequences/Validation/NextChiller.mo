within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.Validation;
model NextChiller
  "Validate sequence of identifying next enable or disable chillers"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.NextChiller
    nexChi
    "Identify next enabling and disabling chiller during the staging up process"
    annotation (Placement(transformation(extent={{-60,170},{-40,190}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.NextChiller
    nexChi1 "Identify next enabling during the staging up process"
    annotation (Placement(transformation(extent={{240,170},{260,190}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.NextChiller
    nexChi2
    "Identify next enabling and disabling chiller during the staging down process"
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.NextChiller
    nexChi3 "Identify next disabling chiller during the staging down process"
    annotation (Placement(transformation(extent={{240,-150},{260,-130}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Switch chiSet[2]
    "Chiller status setpoint"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch inPro
    "Check if it is in the staging process"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiSet1[2]
    "Chiller status setpoint"
    annotation (Placement(transformation(extent={{160,90},{180,110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch inPro1
    "Check if it is in the staging process"
    annotation (Placement(transformation(extent={{160,30},{180,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiSet2[2]
    "Chiller status setpoint"
    annotation (Placement(transformation(extent={{-140,-230},{-120,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Switch inPro2
    "Check if it is in the staging process"
    annotation (Placement(transformation(extent={{-140,-290},{-120,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiSet3[2]
    "Chiller status setpoint"
    annotation (Placement(transformation(extent={{160,-230},{180,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Switch inPro3
    "Check if it is in the staging process"
    annotation (Placement(transformation(extent={{160,-290},{180,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.15,
    final period=120) "Boolean pulse"
    annotation (Placement(transformation(extent={{-260,150},{-240,170}})));
  Buildings.Controls.OBC.CDL.Logical.Not staUp "Stage up command"
    annotation (Placement(transformation(extent={{-220,150},{-200,170}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staOneChi[2](
    final k={true,false}) "Vector of chillers status setpoint at stage one"
    annotation (Placement(transformation(extent={{-260,70},{-240,90}})));
  CDL.Integers.Sources.Constant                     upSta(
    final k=2) "Stage two"
    annotation (Placement(transformation(extent={{-260,230},{-240,250}})));
  CDL.Integers.Sources.Constant                     dowSta(
    final k=1) "Stage one"
    annotation (Placement(transformation(extent={{-260,190},{-240,210}})));
  CDL.Integers.Switch                     intSwi
                                              "Logical switch"
    annotation (Placement(transformation(extent={{-180,210},{-160,230}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staTwoChi[2](
    final k={false,true})
    "Vector of chillers status setpoint at stage two"
    annotation (Placement(transformation(extent={{-260,110},{-240,130}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=2)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul4(
    final width=0.5,
    final period=120) "Boolean pulse"
    annotation (Placement(transformation(extent={{-260,30},{-240,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant endPro(final k=true)
    "Not in the process"
    annotation (Placement(transformation(extent={{-220,10},{-200,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.15,
    final period=120) "Boolean pulse"
    annotation (Placement(transformation(extent={{40,150},{60,170}})));
  Buildings.Controls.OBC.CDL.Logical.Not staUp1  "Stage up command"
    annotation (Placement(transformation(extent={{80,150},{100,170}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staOneChi1[2](
    final k={true,false})
    "Vector of chillers status setpoint at stage one"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant upSta1(
    final k=2)
    "Stage two"
    annotation (Placement(transformation(extent={{40,230},{60,250}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant dowSta1(
    final k=1)
    "Stage one"
    annotation (Placement(transformation(extent={{40,190},{60,210}})));
  CDL.Integers.Switch                     intSwi3
                                               "Logical switch"
    annotation (Placement(transformation(extent={{120,210},{140,230}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staTwoChi1[2](
    final k={true,true})
    "Vector of chillers status setpoint at stage two"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=2)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{120,90},{140,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul5(
    final width=0.5,
    final period=120) "Boolean pulse"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant endPro1(final k=true)
    "Process is end"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final width=0.15,
    final period=120) "Boolean pulse"
    annotation (Placement(transformation(extent={{-260,-170},{-240,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Not staDow "Stage down command"
    annotation (Placement(transformation(extent={{-220,-170},{-200,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staOneChi2[2](
    final k={true,false})
    "Vector of chillers status setpoint at stage one"
    annotation (Placement(transformation(extent={{-260,-210},{-240,-190}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant upSta2(
    final k=2) "Stage two"
    annotation (Placement(transformation(extent={{-260,-130},{-240,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant dowSta2(
    final k=1) "Stage one"
    annotation (Placement(transformation(extent={{-260,-90},{-240,-70}})));
  CDL.Integers.Switch                     intSwi1
                                               "Logical switch"
    annotation (Placement(transformation(extent={{-180,-110},{-160,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staTwoChi2[2](
    final k={false,true})
    "Vector of chillers status setpoint at stage two"
    annotation (Placement(transformation(extent={{-260,-250},{-240,-230}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep2(
    final nout=2) "Replicate boolean input"
    annotation (Placement(transformation(extent={{-180,-230},{-160,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul6(
    final width=0.5,
    final period=120) "Boolean pulse"
    annotation (Placement(transformation(extent={{-260,-290},{-240,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant endPro2(final k=true)
    "Not in the process"
    annotation (Placement(transformation(extent={{-220,-310},{-200,-290}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3(
    final width=0.15,
    final period=120) "Boolean pulse"
    annotation (Placement(transformation(extent={{40,-170},{60,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Not staDow1 "Stage down command"
    annotation (Placement(transformation(extent={{80,-170},{100,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staOneChi3[2](
    final k={true,false})
    "Vector of chillers status setpoint at stage one"
    annotation (Placement(transformation(extent={{40,-210},{60,-190}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant upSta3(
    final k=2) "Stage two"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant dowSta3(
    final k=1) "Stage one"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi2
    "Logical switch"
    annotation (Placement(transformation(extent={{120,-110},{140,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staTwoChi3[2](
    final k={true,true})
    "Vector of chillers status setpoint at stage two"
    annotation (Placement(transformation(extent={{40,-250},{60,-230}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep3(
    final nout=2) "Replicate boolean input"
    annotation (Placement(transformation(extent={{120,-230},{140,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul7(
    final width=0.5,
    final period=120) "Boolean pulse"
    annotation (Placement(transformation(extent={{40,-290},{60,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant endPro3(final k=true)
    "Not in the process"
    annotation (Placement(transformation(extent={{80,-310},{100,-290}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{-220,50},{-200,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-220,-270},{-200,-250}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4 "Logical not"
    annotation (Placement(transformation(extent={{80,-270},{100,-250}})));
equation
  connect(booPul.y, staUp.u)
    annotation (Line(points={{-238,160},{-222,160}}, color={255,0,255}));
  connect(staUp.y, intSwi.u2) annotation (Line(points={{-198,160},{-190,160},{-190,
          220},{-182,220}}, color={255,0,255}));
  connect(staUp.y, booRep.u) annotation (Line(points={{-198,160},{-190,160},{-190,
          100},{-182,100}}, color={255,0,255}));
  connect(booRep.y, chiSet.u2)
    annotation (Line(points={{-158,100},{-142,100}}, color={255,0,255}));
  connect(staUp.y, inPro.u2) annotation (Line(points={{-198,160},{-190,160},{-190,
          40},{-142,40}}, color={255,0,255}));
  connect(chiSet.y, nexChi.uChiSet) annotation (Line(points={{-118,100},{-100,100},
          {-100,180},{-62,180}}, color={255,0,255}));
  connect(inPro.y,nexChi.endPro)  annotation (Line(points={{-118,40},{-80,40},{-80,
          173},{-62,173}}, color={255,0,255}));
  connect(booPul1.y, staUp1.u)
    annotation (Line(points={{62,160},{78,160}}, color={255,0,255}));
  connect(staUp1.y, intSwi3.u2) annotation (Line(points={{102,160},{110,160},{
          110,220},{118,220}}, color={255,0,255}));
  connect(dowSta1.y, intSwi3.u3) annotation (Line(points={{62,200},{80,200},{80,
          212},{118,212}}, color={0,0,127}));
  connect(upSta1.y, intSwi3.u1) annotation (Line(points={{62,240},{80,240},{80,
          228},{118,228}}, color={0,0,127}));
  connect(staUp1.y, booRep1.u) annotation (Line(points={{102,160},{110,160},{110,
          100},{118,100}}, color={255,0,255}));
  connect(booRep1.y, chiSet1.u2)
    annotation (Line(points={{142,100},{158,100}}, color={255,0,255}));
  connect(staUp1.y, inPro1.u2) annotation (Line(points={{102,160},{110,160},{110,
          40},{158,40}}, color={255,0,255}));
  connect(endPro1.y, inPro1.u3) annotation (Line(points={{102,20},{140,20},{140,
          32},{158,32}}, color={255,0,255}));
  connect(chiSet1.y, nexChi1.uChiSet) annotation (Line(points={{182,100},{200,100},
          {200,180},{238,180}}, color={255,0,255}));
  connect(inPro1.y,nexChi1.endPro)  annotation (Line(points={{182,40},{220,40},{
          220,173},{238,173}}, color={255,0,255}));
  connect(booPul2.y, staDow.u)
    annotation (Line(points={{-238,-160},{-222,-160}}, color={255,0,255}));
  connect(staDow.y, intSwi1.u2) annotation (Line(points={{-198,-160},{-190,-160},
          {-190,-100},{-182,-100}}, color={255,0,255}));
  connect(staDow.y, booRep2.u) annotation (Line(points={{-198,-160},{-190,-160},
          {-190,-220},{-182,-220}}, color={255,0,255}));
  connect(staOneChi2.y, chiSet2.u1) annotation (Line(points={{-238,-200},{-150,-200},
          {-150,-212},{-142,-212}}, color={255,0,255}));
  connect(booRep2.y, chiSet2.u2)
    annotation (Line(points={{-158,-220},{-142,-220}}, color={255,0,255}));
  connect(staTwoChi2.y, chiSet2.u3) annotation (Line(points={{-238,-240},{-148,-240},
          {-148,-228},{-142,-228}}, color={255,0,255}));
  connect(staDow.y, inPro2.u2) annotation (Line(points={{-198,-160},{-190,-160},
          {-190,-280},{-142,-280}}, color={255,0,255}));
  connect(endPro2.y, inPro2.u3) annotation (Line(points={{-198,-300},{-160,-300},
          {-160,-288},{-142,-288}}, color={255,0,255}));
  connect(chiSet2.y, nexChi2.uChiSet) annotation (Line(points={{-118,-220},{-100,
          -220},{-100,-140},{-62,-140}}, color={255,0,255}));
  connect(inPro2.y,nexChi2.endPro)  annotation (Line(points={{-118,-280},{-80,-280},
          {-80,-147},{-62,-147}}, color={255,0,255}));
  connect(dowSta2.y, intSwi1.u1) annotation (Line(points={{-238,-80},{-200,-80},
          {-200,-92},{-182,-92}}, color={0,0,127}));
  connect(upSta2.y, intSwi1.u3) annotation (Line(points={{-238,-120},{-200,-120},
          {-200,-108},{-182,-108}}, color={0,0,127}));
  connect(staTwoChi.y, chiSet.u1) annotation (Line(points={{-238,120},{-150,120},
          {-150,108},{-142,108}}, color={255,0,255}));
  connect(staOneChi.y, chiSet.u3) annotation (Line(points={{-238,80},{-150,80},{
          -150,92},{-142,92}}, color={255,0,255}));
  connect(staTwoChi1.y, chiSet1.u1) annotation (Line(points={{62,120},{150,120},
          {150,108},{158,108}}, color={255,0,255}));
  connect(staOneChi1.y, chiSet1.u3) annotation (Line(points={{62,80},{150,80},{150,
          92},{158,92}}, color={255,0,255}));
  connect(booPul3.y, staDow1.u)
    annotation (Line(points={{62,-160},{78,-160}}, color={255,0,255}));
  connect(staDow1.y, intSwi2.u2) annotation (Line(points={{102,-160},{110,-160},
          {110,-100},{118,-100}}, color={255,0,255}));
  connect(staDow1.y, booRep3.u) annotation (Line(points={{102,-160},{110,-160},{
          110,-220},{118,-220}}, color={255,0,255}));
  connect(staOneChi3.y, chiSet3.u1) annotation (Line(points={{62,-200},{150,-200},
          {150,-212},{158,-212}}, color={255,0,255}));
  connect(booRep3.y, chiSet3.u2)
    annotation (Line(points={{142,-220},{158,-220}}, color={255,0,255}));
  connect(staTwoChi3.y, chiSet3.u3) annotation (Line(points={{62,-240},{150,
          -240},{150,-228},{158,-228}},
                                  color={255,0,255}));
  connect(staDow1.y, inPro3.u2) annotation (Line(points={{102,-160},{110,-160},{
          110,-280},{158,-280}}, color={255,0,255}));
  connect(endPro3.y, inPro3.u3) annotation (Line(points={{102,-300},{140,-300},
          {140,-288},{158,-288}}, color={255,0,255}));
  connect(chiSet3.y, nexChi3.uChiSet) annotation (Line(points={{182,-220},{200,-220},
          {200,-140},{238,-140}}, color={255,0,255}));
  connect(inPro3.y,nexChi3.endPro)  annotation (Line(points={{182,-280},{220,-280},
          {220,-147},{238,-147}}, color={255,0,255}));
  connect(dowSta3.y, intSwi2.u1) annotation (Line(points={{62,-80},{100,-80},{
          100,-92},{118,-92}}, color={0,0,127}));
  connect(upSta3.y, intSwi2.u3) annotation (Line(points={{62,-120},{100,-120},{
          100,-108},{118,-108}}, color={0,0,127}));

  connect(intSwi.y, nexChi.uStaSet) annotation (Line(points={{-158,220},{-80,220},
          {-80,187},{-62,187}}, color={255,127,0}));
  connect(upSta.y, intSwi.u1) annotation (Line(points={{-238,240},{-220,240},{-220,
          228},{-182,228}}, color={255,127,0}));
  connect(dowSta.y, intSwi.u3) annotation (Line(points={{-238,200},{-220,200},{-220,
          212},{-182,212}}, color={255,127,0}));
  connect(intSwi3.y, nexChi1.uStaSet) annotation (Line(points={{142,220},{220,
          220},{220,187},{238,187}}, color={255,127,0}));
  connect(intSwi2.y, nexChi3.uStaSet) annotation (Line(points={{142,-100},{220,
          -100},{220,-133},{238,-133}}, color={255,127,0}));
  connect(intSwi1.y, nexChi2.uStaSet) annotation (Line(points={{-158,-100},{-80,
          -100},{-80,-133},{-62,-133}}, color={255,127,0}));
  connect(booPul4.y, not3.u) annotation (Line(points={{-238,40},{-230,40},{-230,
          60},{-222,60}}, color={255,0,255}));
  connect(endPro.y, inPro.u3) annotation (Line(points={{-198,20},{-160,20},{
          -160,32},{-142,32}}, color={255,0,255}));
  connect(not3.y, inPro.u1) annotation (Line(points={{-198,60},{-160,60},{-160,
          48},{-142,48}}, color={255,0,255}));
  connect(booPul5.y, not1.u) annotation (Line(points={{62,40},{70,40},{70,60},{
          78,60}}, color={255,0,255}));
  connect(not1.y, inPro1.u1) annotation (Line(points={{102,60},{140,60},{140,48},
          {158,48}}, color={255,0,255}));
  connect(booPul6.y, not2.u) annotation (Line(points={{-238,-280},{-230,-280},{
          -230,-260},{-222,-260}}, color={255,0,255}));
  connect(not2.y, inPro2.u1) annotation (Line(points={{-198,-260},{-160,-260},{
          -160,-272},{-142,-272}}, color={255,0,255}));
  connect(booPul7.y, not4.u) annotation (Line(points={{62,-280},{70,-280},{70,
          -260},{78,-260}}, color={255,0,255}));
  connect(not4.y, inPro3.u1) annotation (Line(points={{102,-260},{140,-260},{
          140,-272},{158,-272}}, color={255,0,255}));
annotation (
 experiment(StopTime=120, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Subsequences/Validation/NextChiller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.NextChiller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.NextChiller</a>.
</p>
<p>
It has four instances as below to demonstrate the process of identifying next
changing chiller(s) when the plant is in staging process.
</p>
<p>
The instance <code>nexChi</code> shows how the changing chillers being identified
in a staging up process that requires a large chiller being enabled and a small
chiller being disabled. The plant stages up from stage 1 that requires chiller 1
operating to stage 2 that requires chiller 2 operating.
</p>
<ul>
<li>
Before 18 seconds, the plant is in stage 1 and is not in the staging process
(<code>endPro=true</code>). Chiller 1 is enabled (<code>uChiSet[1]=true</code>)
and chiller 2 is not enabled (<code>uChiSet[2]=false</code>). The next enabling
and disabling chiller are the default 1.
</li>
<li>
At 18 seconds, the plant starts staging up (<code>endPro=false</code>,
<code>yUp=true</code>) and it requires one chiller being enabled and another
chiller being disabled (<code>yOnOff=true</code>). The next enabling chiller is
chiller 2 (<code>yNexEnaChi=2</code>) and the next disabling chiller is chiller 1
(<code>yDisSmaChi=1</code>). The chiller status setpoints are changed accordingly.
</li>
<li>
At 60 seconds, the staging process is done (<code>endPro=true</code>,
<code>yUp=false</code>, <code>yOnOff=false</code>).
</li>
</ul>

<p>
The instance <code>nexChi1</code> shows how the changing chillers being identified
in a staging up process that requires one additional chiller being enabled. The
plant stages up from stage 1 that requires chiller 1 operating to stage 2 that
requires both chiller 1 and chiller 2 operating.
</p>
<ul>
<li>
Before 18 seconds, the plant is in stage 1 and is not in the staging process
(<code>endPro=true</code>). Chiller 1 is enabled (<code>uChiSet[1]=true</code>)
and chiller 2 is not enabled (<code>uChiSet[2]=false</code>). The next enabling
and disabling chiller are the default 1.
</li>
<li>
At 18 seconds, the plant starts staging up (<code>endPro=false</code>,
<code>yUp=true</code>) and it does not require one chiller being enabled and
another chiller being disabled (<code>yOnOff=false</code>). The next additional
enabling chiller is chiller 2 (<code>yNexEnaChi=2</code>). The chiller status
setpoints are changed accordingly.
</li>
<li>
At 60 seconds, the staging process is done (<code>endPro=true</code>,
<code>yUp=false</code>, <code>yOnOff=false</code>).
</li>
</ul>

<p>
The instance <code>nexChi2</code> shows how the changing chillers being identified
in a staging down process that requires a large chiller being disabled and a small
chiller being enabled. The plant stages down from stage 2 that requires chiller 2
operating to stage 1 that requires chiller 1 operating.
</p>
<ul>
<li>
Before 18 seconds, the plant is in stage 2 and is not in the staging process
(<code>endPro=true</code>). Chiller 1 is disabled (<code>uChiSet[1]=false</code>)
and chiller 2 is enabled (<code>uChiSet[2]=true</code>). The next enabling and
disabling chiller are the default 1.
</li>
<li>
At 18 seconds, the plant starts staging down (<code>endPro=false</code>,
<code>yDow=true</code>) and it requires one chiller being disabled and another
chiller being enabled (<code>yOnOff=true</code>). The next disabling chiller is
chiller 2 (<code>yLasDisChi=2</code>) and the next enabling chiller is chiller 1
(<code>yEnaSmaChi=1</code>). The chiller status setpoints are changed accordingly.
</li>
<li>
At 60 seconds, the staging process is done (<code>endPro=true</code>,
<code>yDow=false</code>, <code>yOnOff=false</code>).
</li>
</ul>

<p>
The instance <code>nexChi3</code> shows how the changing chillers being identified
in a staging down process that requires one additional chiller being disabled. The
plant stages down from stage 2 that requires both chiller 1 and chiller 2 operating
to stage 1 that requires just chiller 1 operating.
</p>
<ul>
<li>
Before 18 seconds, the plant is in stage 2 and is not in the staging process
(<code>endPro=true</code>). Chiller 2 is enabled (<code>uChiSet[2]=true</code>) and
chiller 1 is not enabled (<code>uChiSet[1]=false</code>). The next enabling and
disabling chiller are the default 1.
</li>
<li>
At 18 seconds, the plant starts staging down (<code>endPro=false</code>,
<code>yDow=true</code>) and it does not require one chiller being disabled and
another chiller being enabled (<code>yOnOff=false</code>). The next additional
disabling chiller is chiller 2 (<code>yLasDisChi=2</code>) . The chiller status
setpoints are changed accordingly.
</li>
<li>
At 60 seconds, the staging process is done (<code>endPro=true</code>,
<code>yDow=false</code>, <code>yOnOff=false</code>).
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 26, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
     graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-280,-320},{280,320}}),
        graphics={
        Text(
          extent={{-258,292},{-146,280}},
          textColor={0,0,127},
          textString="In stage up process (stage 1 to 2),"),
        Text(
          extent={{-254,278},{-94,266}},
          textColor={0,0,127},
          textString="requires small chiller (1) off and large chiller (2) on."),
        Text(
          extent={{64,278},{228,268}},
          textColor={0,0,127},
          textString="add one more chiller (1) on top of current chiller (2)."),
        Text(
          extent={{62,292},{174,280}},
          textColor={0,0,127},
          textString="In stage up process (stage 2 to 3),"),
        Text(
          extent={{-256,-40},{-96,-52}},
          textColor={0,0,127},
          textString="requires large chiller (2) off and small chiller (1) on."),
        Text(
          extent={{-260,-26},{-140,-36}},
          textColor={0,0,127},
          textString="In stage down process (stage 2 to 1),"),
        Text(
          extent={{58,-42},{130,-52}},
          textColor={0,0,127},
          textString="disable chiller (2)."),
        Text(
          extent={{62,-28},{182,-38}},
          textColor={0,0,127},
          textString="In stage down process (stage 2 to 1),")}));
end NextChiller;
