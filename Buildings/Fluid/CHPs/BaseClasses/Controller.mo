within Buildings.Fluid.CHPs.BaseClasses;
model Controller "Define current operation mode"
  extends Modelica.Blocks.Icons.Block;

  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{200,158},{220,178}})));
  parameter Modelica.Units.SI.Time waitTime=60
    "Wait time before transition from pump-on mode fires"
    annotation (Dialog(tab="Dynamics"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput avaSig
    "True when the plant is available"
    annotation (Placement(transformation(extent={{-300,160},{-260,200}}),
      iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput runSig
    "True when plant should run"
    annotation (Placement(transformation(extent={{-300,100},{-260,140}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mWat_flow(
    final unit="kg/s")
    "Cooling water mass flow rate"
    annotation (Placement(transformation(extent={{-300,20},{-260,60}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEng(
    final unit="K",
    final displayUnit="degC") if not per.warmUpByTimeDelay
    "Engine temperature"
    annotation (Placement(transformation(extent={{-300,-20},{-260,20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PEleNet(final unit="W")
 if not per.warmUpByTimeDelay
    "Net power output"
    annotation (Placement(transformation(extent={{-300,-60},{-260,-20}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PEle(final unit="W")
 if not per.warmUpByTimeDelay
    "Power demand"
    annotation (Placement(transformation(extent={{-300,-100},{-260,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Fluid.CHPs.BaseClasses.Interfaces.ModeTypeOutput opeMod
    "Type of operating mode"
    annotation (Placement(transformation(extent={{260,-20},{300,20}}),
      iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.StateGraph.Step staBy(nOut=2, nIn=1)
    "Standby step"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.StateGraph.Step pumOn(nOut=2, nIn=1)
    "Pump on step"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.StateGraph.StepWithSignal warUp(nIn=2, nOut=2)
    "Warm-up step"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.StateGraph.StepWithSignal cooDow(nIn=2, nOut=2)
    "Cool-down step"
    annotation (Placement(transformation(extent={{160,-90},{180,-70}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minWatFlo(
    final k=per.mWatMin_flow) "Minimum water mass flow rate"
    annotation (Placement(transformation(extent={{-220,190},{-200,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0.001) "Constant value"
    annotation (Placement(transformation(extent={{-220,150},{-200,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max
    "Maximum between minimum flow rate and 0.001"
    annotation (Placement(transformation(extent={{-160,170},{-140,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
    "Mass flow rate difference between actual and minimum value"
    annotation (Placement(transformation(extent={{-100,170},{-80,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=0.01*per.mWatMin_flow - 1e-6,
    final uHigh=0.015*per.mWatMin_flow)
    "Check if actual mass flow rate is larger than the minimum value"
    annotation (Placement(transformation(extent={{-60,170},{-40,190}})));
  Buildings.Controls.OBC.CDL.Logical.And goSig
    "Check if water flow rate is higher than the minimum when runSig = true"
    annotation (Placement(transformation(extent={{-20,170},{0,190}})));
  Buildings.Controls.OBC.CDL.Logical.Not notRunSig "Plant is not running"
    annotation (Placement(transformation(extent={{-220,70},{-200,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not notAvaSig "Plant is not available"
    annotation (Placement(transformation(extent={{-220,-190},{-200,-170}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Warm-up mode is done and the plant could run"
    annotation (Placement(transformation(extent={{120,-30},{140,-10}})));
  Modelica.StateGraph.TransitionWithSignal transition3 "Plant should be off"
    annotation (Placement(transformation(extent={{-30,-90},{-10,-70}})));
  Modelica.StateGraph.TransitionWithSignal transition5 "Plant should be off"
    annotation (Placement(transformation(extent={{30,-90},{50,-70}})));
  Modelica.StateGraph.TransitionWithSignal transition9 "Run in cool-down mode"
    annotation (Placement(transformation(extent={{80,-90},{100,-70}})));
  Modelica.StateGraph.TransitionWithSignal transition7 "Run in warm-up mode"
    annotation (Placement(transformation(extent={{210,-90},{230,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Plant could run and cool-down mode is optional"
    annotation (Placement(transformation(extent={{100,-150},{120,-170}})));
  Modelica.StateGraph.TransitionWithSignal transition10 "Plant should be off"
    annotation (Placement(transformation(extent={{230,-70},{250,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Plant could run and cool-down mode is optional"
    annotation (Placement(transformation(extent={{208,-210},{228,-190}})));
  Buildings.Fluid.CHPs.BaseClasses.AssertWaterFlow assWatMas(
    final mWatMin_flow=per.mWatMin_flow)
    "Assert if water flow rate is outside boundaries"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Fluid.CHPs.BaseClasses.Types.Mode actMod "Mode indicator";
  Modelica.StateGraph.TransitionWithSignal transition1
    "Plant becomes available"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Modelica.StateGraph.TransitionWithSignal transition2 "Run plant"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Modelica.StateGraph.Step nor(final nIn=1, final nOut=1)
    "Plant is in normal mode"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  Modelica.StateGraph.TransitionWithSignal transition8 "Run in cool-down mode"
    annotation (Placement(transformation(extent={{210,10},{230,-10}})));
  Buildings.Fluid.CHPs.BaseClasses.WarmUpLeaving warUpCtr(
    final timeDelayStart=per.timeDelayStart,
    final TEngNom=per.TEngNom,
    final PEleMax=per.PEleMax,
    final warmUpByTimeDelay=per.warmUpByTimeDelay)
    "Warm-up control sequence"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Modelica.StateGraph.TransitionWithSignal transition6 "Run in normal mode"
    annotation (Placement(transformation(extent={{150,-10},{170,10}})));
  Modelica.StateGraph.InitialStep plaOff(final nIn=3, nOut=1)
    "Plant is off"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Modelica.StateGraph.TransitionWithSignal transition4(
    final enableTimer=true,
    final waitTime=waitTime) "Run in warm-up mode"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant optCooDow(
    final k=per.coolDownOptional) "Check if cool-down mode is optional"
    annotation (Placement(transformation(extent={{60,-190},{80,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timer(
    final t=per.timeDelayCool)
    "Check if the time of  plant in cool-down mode has been longer than the specified delay time"
    annotation (Placement(transformation(extent={{152,-190},{172,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Not noGo "Plant should not run"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));

equation
  if plaOff.active then
    actMod = CHPs.BaseClasses.Types.Mode.Off;
  elseif staBy.active then
    actMod = CHPs.BaseClasses.Types.Mode.StandBy;
  elseif pumOn.active then
    actMod = CHPs.BaseClasses.Types.Mode.PumpOn;
  elseif warUp.active then
    actMod = CHPs.BaseClasses.Types.Mode.WarmUp;
  elseif nor.active then
    actMod = CHPs.BaseClasses.Types.Mode.Normal;
  else
    actMod = CHPs.BaseClasses.Types.Mode.CoolDown;
  end if;
  opeMod = actMod;
  connect(nor.outPort[1], transition8.inPort)
    annotation (Line(points={{200.5,0},{216,0}}, color={0,0,0}));
  connect(TEng, warUpCtr.TEng) annotation (Line(points={{-280,0},{-220,0},{-220,
          -38},{88,-38}},                  color={0,0,127}));
  connect(plaOff.outPort[1], transition1.inPort)
    annotation (Line(points={{-99.5,0},{-84,0}}, color={0,0,0}));
  connect(transition6.outPort, nor.inPort[1])
    annotation (Line(points={{161.5,0},{179,0}}, color={0,0,0}));
  connect(assWatMas.mWat_flow, mWat_flow) annotation (Line(points={{38,36},{-120,
          36},{-120,40},{-280,40}},color={0,0,127}));
  connect(minWatFlo.y, max.u1) annotation (Line(points={{-198,200},{-180,200},{-180,
          186},{-162,186}}, color={0,0,127}));
  connect(con.y, max.u2) annotation (Line(points={{-198,160},{-180,160},{-180,174},
          {-162,174}}, color={0,0,127}));
  connect(sub1.y, hys.u) annotation (Line(points={{-78,180},{-62,180}},
          color={0,0,127}));
  connect(hys.y, goSig.u1) annotation (Line(points={{-38,180},{-22,180}},
          color={255,0,255}));
  connect(runSig, goSig.u2) annotation (Line(points={{-280,120},{-30,120},{-30,172},
          {-22,172}}, color={255,0,255}));
  connect(runSig, notRunSig.u) annotation (Line(points={{-280,120},{-240,120},{-240,
          80},{-222,80}},        color={255,0,255}));
  connect(runSig, assWatMas.runSig) annotation (Line(points={{-280,120},{-240,120},
          {-240,44},{38,44}},      color={255,0,255}));
  connect(avaSig, transition1.condition) annotation (Line(points={{-280,180},{
          -250,180},{-250,-20},{-80,-20},{-80,-12}}, color={255,0,255}));
  connect(runSig, transition2.condition) annotation (Line(points={{-280,120},{-240,
          120},{-240,-24},{-20,-24},{-20,-12}}, color={255,0,255}));
  connect(avaSig, notAvaSig.u) annotation (Line(points={{-280,180},{-250,180},{-250,
          -180},{-222,-180}},      color={255,0,255}));
  connect(goSig.y, transition4.condition) annotation (Line(points={{2,180},{20,
          180},{20,56},{-140,56},{-140,-28},{40,-28},{40,-12}}, color={255,0,255}));
  connect(and1.y, transition6.condition) annotation (Line(points={{142,-20},{
          160,-20},{160,-12}}, color={255,0,255}));
  connect(notAvaSig.y, transition3.condition) annotation (Line(points={{-198,-180},
          {-20,-180},{-20,-92}},       color={255,0,255}));
  connect(and3.y, transition7.condition) annotation (Line(points={{122,-160},{
          220,-160},{220,-92}}, color={255,0,255}));
  connect(and4.y, transition10.condition) annotation (Line(points={{230,-200},{240,
          -200},{240,-72}}, color={255,0,255}));
  connect(transition3.outPort, plaOff.inPort[1]) annotation (Line(points={{-18.5,
          -80},{0,-80},{0,-100},{-130,-100},{-130,0.666667},{-121,0.666667}},
        color={0,0,0}));
  connect(transition5.outPort, plaOff.inPort[2]) annotation (Line(points={{41.5,
          -80},{48,-80},{48,-102},{-132,-102},{-132,0},{-121,0}}, color={0,0,0}));
  connect(transition10.outPort, plaOff.inPort[3]) annotation (Line(points={{241.5,
          -60},{250,-60},{250,-104},{-134,-104},{-134,-0.666667},{-121,-0.666667}},
                       color={0,0,0}));
  connect(goSig.y, and3.u2) annotation (Line(points={{2,180},{20,180},{20,56},{
          -140,56},{-140,-152},{98,-152}}, color={255,0,255}));
  connect(optCooDow.y, and3.u1) annotation (Line(points={{82,-180},{90,-180},{90,
          -160},{98,-160}}, color={255,0,255}));
  connect(transition1.outPort, staBy.inPort[1])
    annotation (Line(points={{-78.5,0},{-61,0}}, color={0,0,0}));
  connect(staBy.outPort[1], transition2.inPort) annotation (Line(points={{-39.5,
          0.25},{-32,0.25},{-32,0},{-24,0}}, color={0,0,0}));
  connect(staBy.outPort[2], transition3.inPort) annotation (Line(points={{-39.5,
          -0.25},{-32,-0.25},{-32,-80},{-24,-80}}, color={0,0,0}));
  connect(transition2.outPort, pumOn.inPort[1])
    annotation (Line(points={{-18.5,0},{-1,0}}, color={0,0,0}));
  connect(pumOn.outPort[1], transition4.inPort)
    annotation (Line(points={{20.5,0.25},{28,0},{36,0}}, color={0,0,0}));
  connect(pumOn.outPort[2], transition5.inPort) annotation (Line(points={{20.5,-0.25},
          {26,-0.25},{26,-80},{36,-80}}, color={0,0,0}));
  connect(warUp.outPort[1], transition6.inPort) annotation (Line(points={{90.5,
          0.25},{110,0.25},{110,0},{156,0}}, color={0,0,0}));
  connect(warUp.outPort[2], transition9.inPort) annotation (Line(points={{90.5,
          -0.25},{96,-0.25},{96,-20},{66,-20},{66,-80},{86,-80}}, color={0,0,0}));
  connect(warUp.active, warUpCtr.actWarUp)
    annotation (Line(points={{80,-11},{80,-34},{88,-34}}, color={255,0,255}));
  connect(warUpCtr.y, and1.u2) annotation (Line(points={{112,-40},{114,-40},{
          114,-28},{118,-28}}, color={255,0,255}));
  connect(goSig.y, and1.u1) annotation (Line(points={{2,180},{100,180},{100,-20},
          {118,-20}}, color={255,0,255}));
  connect(transition4.outPort, warUp.inPort[1]) annotation (Line(points={{41.5,0},
          {50,0},{50,0.5},{69,0.5}}, color={0,0,0}));
  connect(transition7.outPort, warUp.inPort[2]) annotation (Line(points={{221.5,
          -80},{230,-80},{230,-120},{60,-120},{60,0},{69,0},{69,-0.5}}, color=
         {0,0,0}));
  connect(transition8.outPort, cooDow.inPort[1]) annotation (Line(points={{221.5,0},
          {240,0},{240,-40},{140,-40},{140,-79.5},{159,-79.5}},    color={0,0,0}));
  connect(transition9.outPort, cooDow.inPort[2]) annotation (Line(points={{91.5,
          -80},{140,-80},{140,-80.5},{159,-80.5}}, color={0,0,0}));
  connect(cooDow.outPort[1], transition10.inPort) annotation (Line(points={{180.5,
          -79.75},{200,-79.75},{200,-60},{236,-60}}, color={0,0,0}));
  connect(cooDow.outPort[2], transition7.inPort) annotation (Line(points={{180.5,
          -80.25},{182,-80.25},{182,-80},{216,-80}}, color={0,0,0}));
  connect(cooDow.active, timer.u) annotation (Line(points={{170,-91},{170,-140},
          {140,-140},{140,-180},{150,-180}}, color={255,0,255}));
  connect(PEleNet, warUpCtr.PEleNet) annotation (Line(points={{-280,-40},{80,
          -40},{80,-42},{88,-42}}, color={0,0,127}));
  connect(PEle, warUpCtr.PEle) annotation (Line(points={{-280,-80},{-40,-80},{
          -40,-46},{88,-46}}, color={0,0,127}));
  connect(notRunSig.y, transition5.condition) annotation (Line(points={{-198,80},
          {-180,80},{-180,-120},{40,-120},{40,-92}},       color={255,0,255}));
  connect(goSig.y, noGo.u) annotation (Line(points={{2,180},{20,180},{20,100},{38,
          100}}, color={255,0,255}));
  connect(noGo.y, transition8.condition)
    annotation (Line(points={{62,100},{220,100},{220,12}}, color={255,0,255}));
  connect(noGo.y, and4.u2) annotation (Line(points={{62,100},{80,100},{80,60},{-144,
          60},{-144,-208},{206,-208}}, color={255,0,255}));
  connect(noGo.y, transition9.condition) annotation (Line(points={{62,100},{80,100},
          {80,60},{-144,60},{-144,-140},{90,-140},{90,-92}}, color={255,0,255}));
  connect(timer.passed, and4.u1) annotation (Line(points={{174,-188},{200,-188},
          {200,-200},{206,-200}}, color={255,0,255}));
  connect(max.y, sub1.u2) annotation (Line(points={{-138,180},{-128,180},{-128,174},
          {-102,174}}, color={0,0,127}));
  connect(mWat_flow, sub1.u1) annotation (Line(points={{-280,40},{-120,40},{-120,
          186},{-102,186}}, color={0,0,127}));

annotation (
    defaultComponentName="conMai",
    Diagram(coordinateSystem(extent={{-260,-220},{260,220}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{50,34},{50,-18},{90,8},{90,8},{50,34}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-50,40},{10,-22}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(points={{10,8},{30,8}}, color={0,0,0}),
        Line(points={{-92,6},{-68,6}}, color={0,0,0}),
        Line(points={{-20,-44},{-20,-70}}, color={0,0,0}),
        Polygon(
          points={{-72,20},{-72,-8},{-50,6},{-72,20}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{28,22},{28,-6},{50,8},{28,22}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-11,14},{-11,-14},{11,0},{-11,14}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          origin={-21,-34},
          rotation=90)}),
    Documentation(info="<html>
<p>
The CHP plant switches between six possible operating modes depending on the current mode,
control signals and plant boundary conditions. The regular transition between them
is as follows:
</p>
<ul>
<li>
off
</li>
<li>
stand-by mode
</li>
<li>
pump-on mode
</li>
<li>
warm-up mode
</li>
<li>
normal operation
</li>
<li>
cool-down mode
</li>
<li>
off or stand-by mode
</li>
</ul>
<h4>Switching between operating modes</h4>
<p>
From the off mode:
</p>
<ul>
<li>
The transition from the off to the stand-by mode will occur when the plant availability
signal <code>avaSig</code> becomes true.
</li>
</ul>
<p>
From the stand-by mode:
</p>
<ul>
<li>
The transition from the stand-by to the pump-on mode will occur when the plant
running signal <code>runSig</code> becomes true.
</li>
<li>
If <code>avaSig</code> becomes false, the CHP will automatically change to the off mode.
</li>
</ul>
<p>
From the pump-on mode:
</p>
<ul>
<li>
The transition from the pump-on to stand-by mode will occur after the specified
time delay and if the water flow rate <code>mWat_flow</code> is greater than
the minimum <code>mWatMin_flow</code>.
</li>
<li>
If <code>runSig</code> becomes false, the CHP will automatically change to the off mode.
</li>
</ul>
<p>
From the warm-up mode:
</p>
<ul>
<li>
The transition from the warm-up mode to the normal operation will occur after the
specified time delay (if <code>warmUpByTimeDelay</code> is true)
or when the engine temperature <code>TEng</code> becomes higher than the
nominal temperature <code>TEngNom</code> (if <code>warmUpByTimeDelay</code>
is false).
</li>
<li>
If <code>runSig</code> becomes false or if the water flow rate <code>mWat_flow</code>
becomes less than the minimum <code>mWatMin_flow</code>, the CHP will automatically
change to the cool-down mode.
</li>
</ul>
<p>
From the normal mode:
</p>
<ul>
<li>
The transition from the normal operation to the cool-down mode will occur when
<code>runSig</code> becomes false or if the water flow rate <code>mWat_flow</code>
becomes less than the minimum <code>mWatMin_flow</code>.
</li>
</ul>
<p>
From the cool-down mode:
</p>
<ul>
<li>
The transition from the cool-down mode will occur after the specified time delay.
If <code>avaSig</code> is true, the CHP will change to the stand-by mode; else,
it will change to the off mode.
</li>
<li>
If the CHP has the mandatory cool-down configuration (if <code>coolDownOptional</code>
is false), the plant has to complete the cool-down period before it can be reactivated.
If the CHP has the optional cool-down configuration (if <code>coolDownOptional</code>
is true), the plant may imediatelly change to the warm-up mode if it gets reactivated
(<code>runSig= true</code>).
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
April 8, 2020, by Antoine Gautier:<br/>
Refactored implementation.
</li>
<li>
December 03, 2019, by Jianjun Hu:<br/>
Refactored implementation.
</li>
<li>
June 18, 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
