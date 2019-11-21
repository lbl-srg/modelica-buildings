within Buildings.Fluid.CHPs.BaseClasses;
model Controller "Define current operation mode"
  extends Modelica.Blocks.Icons.Block;

  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{120,160},{140,180}})));
  parameter Modelica.SIunits.Time waitTime=60
    "Wait time before transition from pump-on mode fires"
    annotation (Dialog(tab="Dynamics"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput runSig
    "True when plant should run"
    annotation (Placement(transformation(extent={{-300,120},{-260,160}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mWat_flow(
    final unit="kg/s")
    annotation (Placement(transformation(extent={{-300,30},{-260,70}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEng(
    final unit="K",
    final quantity="ThermodynamicTemperature")  "Engine temperature"
    annotation (Placement(transformation(extent={{-300,0},{-260,40}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput avaSig
    "True when the plant is available"
    annotation (Placement(transformation(extent={{-300,-80},{-260,-40}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Fluid.CHPs.BaseClasses.Interfaces.ModeTypeOutput opeMod
    "Type of the operation mode"
    annotation (Placement(transformation(extent={{260,-20},{300,20}}),
      iconTransformation(extent={{100,-10},{120,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minWatFlo(
    final k=per.mWatMin) "Minimum water flow rate"
    annotation (Placement(transformation(extent={{-180,190},{-160,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0.001) "Constant value"
    annotation (Placement(transformation(extent={{-180,150},{-160,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max
    "Maximum between minimum flow rate and 0.001"
    annotation (Placement(transformation(extent={{-140,170},{-120,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k1=-1)
    "Flow rate difference between current rate and minimum rate"
    annotation (Placement(transformation(extent={{-100,170},{-80,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=0.01*per.mWatMin - 2e-6,
    final uHigh=0.015*per.mWatMin - 1e-6)
    "Check if current flow rate is larger than the minimum flow rate"
    annotation (Placement(transformation(extent={{-60,170},{-40,190}})));
  Buildings.Controls.OBC.CDL.Logical.And goSig
    "Check if water flow rate is higher than the minimum when runSig = true"
    annotation (Placement(transformation(extent={{-20,170},{0,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minWatFlo1(
    final k=0.95*per.mWatMin)
    "Minimum water flow rate"
    annotation (Placement(transformation(extent={{-180,80},{-160,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1
    "Maximum between minimum flow rate and 0.001"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(final k2=-1)
    "Flow rate difference between current rate and minimum rate"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=0.01*per.mWatMin - 2e-6,
    final uHigh=0.015*per.mWatMin - 1e-6)
    "Check if current flow rate is smaller than the minimum flow rate"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Buildings.Controls.OBC.CDL.Logical.Or noGoSig
    "Check if water flow rate is smaller than the minimum or if runSig = false"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Plant is not running"
    annotation (Placement(transformation(extent={{-220,110},{-200,130}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Plant is not running"
    annotation (Placement(transformation(extent={{-220,-110},{-200,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1 "Plant is not available or should not run"
    annotation (Placement(transformation(extent={{-180,-130},{-160,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Warm up mode is done and the plant could run"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Buildings.Fluid.CHPs.BaseClasses.CoolDown cooDow "Plant is in cool-down mode"
    annotation (Placement(transformation(extent={{120,-124},{140,-104}})));
  Modelica.StateGraph.TransitionWithSignal transition3 "Plant should be off"
    annotation (Placement(transformation(extent={{-30,-90},{-10,-70}})));
  Modelica.StateGraph.TransitionWithSignal transition5 "Plant should be off"
    annotation (Placement(transformation(extent={{10,-110},{30,-90}})));
  Modelica.StateGraph.TransitionWithSignal transition9 "Run in cool-down mode"
    annotation (Placement(transformation(extent={{70,-120},{90,-100}})));
  Modelica.StateGraph.TransitionWithSignal transition7 "Run in warm-up mode"
    annotation (Placement(transformation(extent={{130,-170},{150,-150}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Plant could run and cool down mode is optional"
    annotation (Placement(transformation(extent={{80,-190},{100,-170}})));
  Modelica.StateGraph.TransitionWithSignal transition10 "Plant should be off"
    annotation (Placement(transformation(extent={{210,-130},{230,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Plant could run and cool down mode is optional"
    annotation (Placement(transformation(extent={{180,-200},{200,-180}})));
  Buildings.Fluid.CHPs.BaseClasses.AssertWatMas assWatMas(
    final per=per)
    "Assert if water flow rate is outside boundaries"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Buildings.Fluid.CHPs.BaseClasses.Types.Mode actMod "Mode indicator";
  Buildings.Fluid.CHPs.BaseClasses.PumpOn pumpOn "Plant pump is on"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.StateGraph.TransitionWithSignal transition1
    "Plant becomes available"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Modelica.StateGraph.TransitionWithSignal transition2 "Run plant"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Modelica.StateGraph.Step normal(final nIn=1, final nOut=1)
    "Plant is in normal mode"
    annotation (Placement(transformation(extent={{160,-10},{180,10}})));
  Modelica.StateGraph.TransitionWithSignal transition8 "Run in cool-down mode"
    annotation (Placement(transformation(extent={{190,-10},{210,10}})));
  Buildings.Fluid.CHPs.BaseClasses.StandBy standBy(
    final nResume=1) "Plant is in standby mode"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.CHPs.BaseClasses.WarmUp warmUp(final per=per)
    "Plant is in warm up mode"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.StateGraph.TransitionWithSignal transition6 "Run in normal mode"
    annotation (Placement(transformation(extent={{130,-10},{150,10}})));
  Modelica.StateGraph.InitialStep plantOff(final nIn=3) "Plant is off"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Modelica.StateGraph.TransitionWithSignal transition4(
    final enableTimer=true,
    final waitTime=waitTime) "Run in warm-up mode"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant optCooDow(
    final k=per.coolDownOptional)
    "Check if cool down mode is optional"
    annotation (Placement(transformation(extent={{40,-170},{60,-150}})));

equation
  if plantOff.active then
    actMod = CHPs.BaseClasses.Types.Mode.Off;
  elseif standBy.active then
    actMod = CHPs.BaseClasses.Types.Mode.StandBy;
  elseif pumpOn.active then
    actMod = CHPs.BaseClasses.Types.Mode.PumpOn;
  elseif warmUp.active then
    actMod = CHPs.BaseClasses.Types.Mode.WarmUp;
  elseif normal.active then
    actMod = CHPs.BaseClasses.Types.Mode.Normal;
  else
    actMod = CHPs.BaseClasses.Types.Mode.CoolDown;
  end if;
  opeMod = actMod;
  connect(normal.outPort[1], transition8.inPort) annotation (Line(points={{180.5,
          0},{196,0}}, color={0,0,0}));
  connect(standBy.outPort, transition2.inPort) annotation (Line(points={{
          -39.6667,0},{-24,0}},
                       color={0,0,0}));
  connect(TEng,warmUp.TEng) annotation (Line(points={{-280,20},{50,20},{50,
          6.66667},{58.6667,6.66667}},
                              color={0,0,127}));
  connect(transition1.outPort, standBy.inPort) annotation (Line(points={{-78.5,0},
          {-60.6667,0}}, color={0,0,0}));
  connect(warmUp.outPort, transition6.inPort) annotation (Line(points={{80.3333,
          0},{136,0}}, color={0,0,0}));
  connect(plantOff.outPort[1], transition1.inPort) annotation (Line(points={{
          -99.5,0},{-84,0}}, color={0,0,0}));
  connect(transition2.outPort, pumpOn.inPort) annotation (Line(points={{-18.5,0},
          {-0.66667,0}}, color={0,0,0}));
  connect(pumpOn.outPort, transition4.inPort) annotation (Line(points={{20.3333,
          0},{36,0}}, color={0,0,0}));
  connect(transition4.outPort, warmUp.inPort) annotation (Line(points={{41.5,0},
          {59.3333,0}}, color={0,0,0}));
  connect(transition6.outPort, normal.inPort[1]) annotation (Line(points={{141.5,
          0},{159,0}}, color={0,0,0}));
  connect(assWatMas.mWat_flow, mWat_flow) annotation (Line(points={{78,36},
          {-110,36},{-110,50},{-280,50}}, color={0,0,127}));
  connect(minWatFlo.y, max.u1) annotation (Line(points={{-158,200},{-150,200},{-150,
          186},{-142,186}}, color={0,0,127}));
  connect(con.y, max.u2) annotation (Line(points={{-158,160},{-150,160},{-150,174},
          {-142,174}}, color={0,0,127}));
  connect(max.y, add2.u1) annotation (Line(points={{-118,180},{-106,180},{-106,186},
          {-102,186}},  color={0,0,127}));
  connect(add2.y, hys.u) annotation (Line(points={{-78,180},{-62,180}},
          color={0,0,127}));
  connect(hys.y, goSig.u1) annotation (Line(points={{-38,180},{-22,180}},
          color={255,0,255}));
  connect(max1.y, add1.u1) annotation (Line(points={{-118,90},{-106,90},{-106,96},
          {-102,96}}, color={0,0,127}));
  connect(add1.y, hys1.u) annotation (Line(points={{-78,90},{-62,90}},
          color={0,0,127}));
  connect(mWat_flow, add2.u2) annotation (Line(points={{-280,50},{-110,50},{-110,
          174},{-102,174}}, color={0,0,127}));
  connect(mWat_flow, add1.u2) annotation (Line(points={{-280,50},{-110,50},{-110,
          84},{-102,84}}, color={0,0,127}));
  connect(runSig, goSig.u2) annotation (Line(points={{-280,140},{-30,140},{-30,172},
          {-22,172}}, color={255,0,255}));
  connect(runSig, not1.u) annotation (Line(points={{-280,140},{-240,140},{-240,120},
          {-222,120}}, color={255,0,255}));
  connect(not1.y, noGoSig.u2) annotation (Line(points={{-198,120},{-30,120},{-30,
          82},{-22,82}}, color={255,0,255}));
  connect(hys1.y, noGoSig.u1) annotation (Line(points={{-38,90},{-22,90}},
          color={255,0,255}));
  connect(runSig, assWatMas.runSig) annotation (Line(points={{-280,140},{-240,140},
          {-240,44},{78,44}}, color={255,0,255}));
  connect(avaSig, transition1.condition) annotation (Line(points={{-280,-60},{-220,
          -60},{-220,-20},{-80,-20},{-80,-12}}, color={255,0,255}));
  connect(runSig, transition2.condition) annotation (Line(points={{-280,140},{-240,
          140},{-240,-24},{-20,-24},{-20,-12}}, color={255,0,255}));
  connect(avaSig, not2.u) annotation (Line(points={{-280,-60},{-240,-60},{-240,-100},
          {-222,-100}}, color={255,0,255}));
  connect(not1.y, or1.u1) annotation (Line(points={{-198,120},{-190,120},{-190,-120},
          {-182,-120}}, color={255,0,255}));
  connect(not2.y, or1.u2) annotation (Line(points={{-198,-100},{-194,-100},{-194,
          -128},{-182,-128}}, color={255,0,255}));
  connect(minWatFlo1.y, max1.u2) annotation (Line(points={{-158,90},{-150,90},{-150,
          84},{-142,84}}, color={0,0,127}));
  connect(con.y, max1.u1) annotation (Line(points={{-158,160},{-150,160},{-150,96},
          {-142,96}}, color={0,0,127}));
  connect(goSig.y, transition4.condition) annotation (Line(points={{2,180},{20,180},
          {20,60},{-140,60},{-140,-28},{40,-28},{40,-12}}, color={255,0,255}));
  connect(warmUp.y, and1.u1) annotation (Line(points={{80.6667,-5.2},{90,-5.2},
          {90,-20},{98,-20}}, color={255,0,255}));
  connect(goSig.y, and1.u2) annotation (Line(points={{2,180},{20,180},{20,60},{-140,
          60},{-140,-28},{98,-28}}, color={255,0,255}));
  connect(and1.y, transition6.condition) annotation (Line(points={{122,-20},{140,
          -20},{140,-12}}, color={255,0,255}));
  connect(noGoSig.y, transition8.condition) annotation (Line(points={{2,90},{16,
          90},{16,64},{-144,64},{-144,-32},{200,-32},{200,-12}}, color={255,0,255}));
  connect(transition8.outPort, cooDow.inPort) annotation (Line(points={{201.5,0},
          {220,0},{220,-80},{100,-80},{100,-114},{119.333,-114}},   color={0,0,0}));
  connect(or1.y, transition5.condition) annotation (Line(points={{-158,-120},{20,
          -120},{20,-112}}, color={255,0,255}));
  connect(not2.y, transition3.condition) annotation (Line(points={{-198,-100},{-20,
          -100},{-20,-92}}, color={255,0,255}));
  connect(standBy.suspend[1], transition3.inPort) annotation (Line(points={{-55,
          -10.3333},{-55,-80},{-24,-80}}, color={0,0,0}));
  connect(pumpOn.suspend[1], transition5.inPort) annotation (Line(points={{5,
          -10.3333},{5,-100},{16,-100}},
                               color={0,0,0}));
  connect(warmUp.suspend[1], transition9.inPort) annotation (Line(points={{65,
          -10.3333},{65,-110},{76,-110}},
                                color={0,0,0}));
  connect(noGoSig.y, transition9.condition) annotation (Line(points={{2,90},{16,
          90},{16,64},{-144,64},{-144,-130},{80,-130},{80,-122}}, color={255,0,255}));
  connect(transition9.outPort, cooDow.inPort1) annotation (Line(points={{81.5,
          -110},{119.333,-110}},
                           color={0,0,0}));
  connect(cooDow.suspend[1], transition7.inPort) annotation (Line(points={{125,
          -124.333},{125,-160},{136,-160}},
                                  color={0,0,0}));
  connect(transition7.outPort, warmUp.inPort1) annotation (Line(points={{141.5,
          -160},{160,-160},{160,-140},{50,-140},{50,-5.33333},{59.3333,-5.33333}},
                                                                              color={0,0,0}));
  connect(and3.y, transition7.condition) annotation (Line(points={{102,-180},{140,
          -180},{140,-172}}, color={255,0,255}));
  connect(cooDow.y, and4.u1) annotation (Line(points={{140.667,-117.333},{170,
          -117.333},{170,-190},{178,-190}},
                                  color={255,0,255}));
  connect(noGoSig.y, and4.u2) annotation (Line(points={{2,90},{16,90},{16,64},{-144,
          64},{-144,-198},{178,-198}}, color={255,0,255}));
  connect(cooDow.outPort, transition10.inPort) annotation (Line(points={{140.333,
          -114},{180,-114},{180,-120},{216,-120}}, color={0,0,0}));
  connect(and4.y, transition10.condition) annotation (Line(points={{202,-190},{220,
          -190},{220,-132}}, color={255,0,255}));
  connect(transition3.outPort, plantOff.inPort[1]) annotation (Line(points={{-18.5,
          -80},{0,-80},{0,-50},{-130,-50},{-130,0.666667},{-121,0.666667}},
          color={0,0,0}));
  connect(transition5.outPort, plantOff.inPort[2]) annotation (Line(points={{21.5,
          -100},{40,-100},{40,-50},{-130,-50},{-130,0},{-121,0}}, color={0,0,0}));
  connect(transition10.outPort, plantOff.inPort[3]) annotation (Line(points={{221.5,
          -120},{240,-120},{240,-50},{-130,-50},{-130,-0.666667},{-121,-0.666667}},
          color={0,0,0}));
  connect(goSig.y, and3.u2) annotation (Line(points={{2,180},{20,180},{20,60},{-140,
          60},{-140,-188},{78,-188}}, color={255,0,255}));
  connect(optCooDow.y, and3.u1) annotation (Line(points={{62,-160},{70,-160},{70,
          -180},{78,-180}}, color={255,0,255}));

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
From the off mode
</p>
<ul>
<li>
The transition from the off to the stand-by mode will occur when the plant availability 
signal <code>avaSig</code> becomes true. 
</li>
</ul>
<p>
From the stand-by mode
</p>
<ul>
<li>
The transition from the stand-by to the pump-on mode will occur when the plant 
running signal <code>runSig</code> becomes true. 
</li>
<li>
If <code>runSig</code> becomes false, the CHP will automatically change to the off mode.
</li>
</ul>
<p>
From the pump-on mode
</p>
<ul>
<li>
The transition from the pump-on to stand-by mode will occur after the specified 
time delay and if the water flow rate <code>mWat_flow</code> is greater than 
the minimum <code>per.mWatMin<code>. 
</li>
<li>
If <code>avaSig</code> becomes false or if <code>runSig</code> becomes false, 
the CHP will automatically change to the off mode.
</li>
</ul>
<p>
From the warm-up mode
</p>
<ul>
<li>
The transition from the warm-up mode to the normal operation will occur after the 
specified time delay (if <code>per.warmUpByTimeDelay</code> is true) 
or when the engine temperature <code>TEng</code> becomes higher than the 
nominal temperature <code>per.TEngNom</code> (if <code>per.warmUpByTimeDelay</code> 
is false). 
</li>
<li>
If <code>runSig</code> becomes false or if the water flow rate <code>mWat_flow</code> 
becomes less than the minimum <code>per.mWatMin<code>, the CHP will automatically 
change to the cool-down mode.
</li>
</ul>
<p>
From the normal mode
</p>
<ul>
<li>
The transition from the normal operation to the cool-down mode will occur when 
<code>runSig</code> becomes false or if the water flow rate <code>mWat_flow</code>
becomes less than the minimum <code>per.mWatMin<code>. 
</li>
</ul>
<p>
From the cool-down mode
</p>
<ul>
<li>
The transition from the cool-down mode will occur after the specified time delay. 
If <code>avaSig</code> is true, the CHP will change to the stand-by mode; else, 
it will change to the off mode. 
</li>
<li>
If the CHP has the mandatory cool-down configuration (if <code>per.coolDownOptional</code> 
is false), the plant has to complete the cool-down period before it can be reactivated.
If the CHP has the optional cool-down configuration (if <code>per.coolDownOptional</code> 
is true), the plant may imediatelly change to the warm-up mode if it gets reactivated 
(<code>runSig</code> = true).
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
October 31, 2019, by Jianjun Hu:<br/>
Refactored implementation.
</li>
<li>
June 18, 2019 by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
