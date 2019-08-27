within Buildings.Fluid.CHPs.BaseClasses;
model Controller
  extends Modelica.Blocks.Icons.Block;
  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{122,-138},{138,-122}})));
  Modelica.Blocks.Interfaces.BooleanInput avaSig annotation (Placement(
        transformation(extent={{-200,130},{-160,170}}), iconTransformation(
          extent={{-120,50},{-100,70}})));
  Modelica.Blocks.Interfaces.BooleanInput runSig annotation (Placement(
        transformation(extent={{-200,100},{-160,140}}), iconTransformation(
          extent={{-120,10},{-100,30}})));
  Modelica.Blocks.Interfaces.RealInput mWat_flow(unit="kg/s")
    "Cooling water flow rate" annotation (Placement(transformation(
        origin={-180,90},
        extent={{20,20},{-20,-20}},
        rotation=180), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,-20})));
  Modelica.Blocks.Interfaces.RealInput TEng(unit="K") "Engine temperature"
    annotation (Placement(transformation(
        origin={-180,60},
        extent={{20,20},{-20,-20}},
        rotation=180), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,-60})));
  CHPs.BaseClasses.Interfaces.ModeTypeOutput opeMod
    "Type of the operation mode" annotation (Placement(transformation(extent={{160,-20},
            {200,20}}),         iconTransformation(extent={{100,-10},{120,10}})));
  parameter Modelica.SIunits.Time waitTime=60
    "Wait time before transition from pump-on mode fires" annotation (Dialog(tab="Dynamics"));
protected
  CHPs.BaseClasses.AssertWatMas assWatMas(per=per)
    "Assert if water flow rate is outside boundaries"
    annotation (Placement(transformation(extent={{120,100},{140,120}})));
  CHPs.BaseClasses.Types.Mode actMod "Mode indicator";
  PumpOn pumpOn
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.StateGraph.Transition transition1(condition=avaSig)
    annotation (Placement(transformation(extent={{-110,20},{-90,40}})));
  Modelica.StateGraph.Transition transition2(condition=runSig)
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Modelica.StateGraph.Step normal(nIn=1, nOut=1)
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  Modelica.StateGraph.Transition transition8(condition=noGoSig.y)
    annotation (Placement(transformation(extent={{130,20},{150,40}})));
  Modelica.StateGraph.Transition transition7(condition=noGoSig.y)
  annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-40,-60})));
  CHPs.BaseClasses.StandBy standBy(nResume=1)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.StateGraph.Transition transition3(condition=not avaSig)
    annotation (Placement(transformation(extent={{-130,-10},{-150,10}})));
  CHPs.BaseClasses.WarmUp warmUp(per=per)
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  CHPs.BaseClasses.CoolDown coolDown(per=per)
    annotation (Placement(transformation(extent={{-80,-90},{-100,-70}})));
  Modelica.StateGraph.TransitionWithSignal transition9
    annotation (Placement(transformation(extent={{-130,-90},{-150,-70}})));
  Modelica.StateGraph.Transition transition10(condition=goSig.y and per.coolDownOptional) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-40,-100})));
  Modelica.StateGraph.TransitionWithSignal transition6
    annotation (Placement(transformation(extent={{70,20},{90,40}})));
  Modelica.StateGraph.InitialStep plantOff(nIn=3)
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Modelica.StateGraph.TransitionWithSignal transition4(enableTimer=true, waitTime=
       waitTime)
    annotation (Placement(transformation(extent={{10,20},{30,40}})));
  Modelica.StateGraph.Transition transition5(condition=not avaSig or not
        runSig)
    annotation (Placement(transformation(extent={{-30,-30},{-50,-10}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=goSig.y)
    "Check if water flow rate is higher than the minimum"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression2(y=noGoSig.y)
    annotation (Placement(transformation(extent={{-60,-150},{-80,-130}})));
  Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{-100,-130},{-120,-110}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression1(y=goSig.y)
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Controls.OBC.CDL.Logical.And and1
    annotation (Placement(transformation(extent={{100,-10},{120,-30}})));
  Modelica.Blocks.Sources.BooleanExpression goSig(y=runSig and (mWat_flow >=
        per.mWatMin) and (mWat_flow > 0.001))
    "Check if water flow rate is higher than the minimum when runSig = true"
    annotation (Placement(transformation(extent={{-140,120},{-100,160}})));
  Modelica.Blocks.Sources.BooleanExpression noGoSig(y=not runSig or (mWat_flow <
        (1 - 0.05)*per.mWatMin) or (mWat_flow < 0.001))
    "Check if water flow rate is lower than the minimum or if runSig = false"
    annotation (Placement(transformation(extent={{-80,120},{-40,160}})));
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
  connect(normal.outPort[1], transition8.inPort)
    annotation (Line(points={{120.5,30},{136,30}}, color={0,0,0}));
  connect(standBy.outPort, transition2.inPort)
    annotation (Line(points={{-59.6667,30},{-44,30}},
                                                    color={0,0,0}));
  connect(TEng,warmUp.TEng)  annotation (Line(points={{-180,60},{30,60},{30,
          35.3333},{39.3333,35.3333}},
                              color={0,0,127}));
  connect(coolDown.outPort, transition9.inPort)
    annotation (Line(points={{-100.333,-80},{-136,-80}},
                                                      color={0,0,0}));
  connect(transition1.outPort, standBy.inPort)
    annotation (Line(points={{-98.5,30},{-80.6667,30}}, color={0,0,0}));
  connect(transition8.outPort, coolDown.inPort) annotation (Line(points={{141.5,
          30},{150,30},{150,-80},{-79.3333,-80}},
                                                color={0,0,0}));
  connect(transition7.outPort, coolDown.inPort1) annotation (Line(points={{-41.5,
          -60},{-60,-60},{-60,-76},{-79.3333,-76}},
                                              color={0,0,0}));
  connect(standBy.suspend[1], transition3.inPort)
    annotation (Line(points={{-75,19.6667},{-75,0},{-136,0}},  color={0,0,0}));
  connect(transition10.outPort, warmUp.inPort1) annotation (Line(points={{-38.5,
          -100},{30,-100},{30,24.6667},{39.3333,24.6667}},
                                                    color={0,0,0}));
  connect(warmUp.outPort, transition6.inPort)
    annotation (Line(points={{60.3333,30},{76,30}},  color={0,0,0}));
  connect(plantOff.outPort[1], transition1.inPort)
    annotation (Line(points={{-119.5,30},{-104,30}},
                                                   color={0,0,0}));
  connect(transition2.outPort, pumpOn.inPort)
    annotation (Line(points={{-38.5,30},{-20.6667,30}},
                                                      color={0,0,0}));
  connect(pumpOn.outPort, transition4.inPort)
    annotation (Line(points={{0.33333,30},{16,30}}, color={0,0,0}));
  connect(pumpOn.suspend[1], transition5.inPort)
    annotation (Line(points={{-15,19.6667},{-15,-20},{-36,-20}},
                                                            color={0,0,0}));
  connect(transition4.outPort, warmUp.inPort)
    annotation (Line(points={{21.5,30},{39.3333,30}}, color={0,0,0}));
  connect(transition6.outPort, normal.inPort[1])
    annotation (Line(points={{81.5,30},{99,30}},   color={0,0,0}));
  connect(transition3.outPort, plantOff.inPort[1]) annotation (Line(points={{-141.5,
          0},{-150,0},{-150,30.6667},{-141,30.6667}},color={0,0,0}));
  connect(transition5.outPort, plantOff.inPort[2]) annotation (Line(points={{-41.5,
          -20},{-150,-20},{-150,30},{-141,30}},
                                           color={0,0,0}));
  connect(transition9.outPort, plantOff.inPort[3]) annotation (Line(points={{-141.5,
          -80},{-150,-80},{-150,29.3333},{-141,29.3333}},
                                                     color={0,0,0}));
  connect(runSig, assWatMas.runSig) annotation (Line(points={{-180,120},{-120,
          120},{-120,114},{118,114}},      color={255,0,255}));
  connect(booleanExpression.y, transition4.condition)
    annotation (Line(points={{1,-40},{20,-40},{20,18}},  color={255,0,255}));
  connect(assWatMas.mWat_flow, mWat_flow)
    annotation (Line(points={{118,106},{-120,106},{-120,90},{-180,90}},
                                                    color={0,0,127}));
  connect(and2.y, transition9.condition) annotation (Line(points={{-122,-120},{-140,
          -120},{-140,-92}},   color={255,0,255}));
  connect(coolDown.suspend[1], transition10.inPort) annotation (Line(points={{-85,
          -90.3333},{-85,-100},{-44,-100}},color={0,0,0}));
  connect(booleanExpression1.y, and1.u1) annotation (Line(points={{81,-40},{90,-40},
          {90,-20},{98,-20}},        color={255,0,255}));
  connect(warmUp.y, and1.u2) annotation (Line(points={{60.6667,24.8},{70,24.8},
          {70,-12},{98,-12}},   color={255,0,255}));
  connect(and1.y, transition6.condition) annotation (Line(points={{122,-20},{130,
          -20},{130,0},{80,0},{80,18}},   color={255,0,255}));
  connect(warmUp.suspend[1], transition7.inPort) annotation (Line(points={{45,
          19.6667},{45,-60},{-36,-60}},
                               color={0,0,0}));
  connect(and2.u2, booleanExpression2.y) annotation (Line(points={{-98,-128},{-90,
          -128},{-90,-140},{-81,-140}}, color={255,0,255}));
  connect(coolDown.y, and2.u1) annotation (Line(points={{-100.667,-83.3333},{
          -110,-83.3333},{-110,-100},{-90,-100},{-90,-120},{-98,-120}},
                                                                  color={255,0,255}));
  annotation (
    defaultComponentName="conMai",
    Diagram(coordinateSystem(extent={{-160,-160},{160,160}})),
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
The CHP plant switches between six possible operating modes depending on the current mode, control signals and plant boundary conditions. 
The regular transition between them is as follows:
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
The transition from the off to the stand-by mode will occur when the plant availability signal becomes true (<i>avaSig = true</i>). 
</li>
</ul>

<p>
From the stand-by mode
</p>
<ul>
<li>
The transition from the stand-by to the pump-on mode will occur when the plant running signal becomes true (<i>runSig = true</i>). 
</li>
<li>
If <i>avaSig</i> becomes false, the CHP will automatically transition to the off mode.
</li>
</ul>

<p>
From the pump-on mode
</p>
<ul>
<li>
The transition from the pump-on to stand-by mode will occur after the specified time delay and if the water flow rate is greater than the minimum. 
</li>
<li>
If <i>avaSig</i> becomes false or if <i>runSig</i> becomes false, the CHP will automatically transition to the off mode.
</li>
</ul>

<p>
From the warm-up mode
</p>
<ul>
<li>
The transition from the warm-up mode to the normal operation will occur after the specified time delay (if <i>per.warmUpByTimeDelay = true</i>) 
or when the engine temperature <i>TEng</i> becomes higher than the nominal temperature <i>per.TEngNom</i> (if <i>per.warmUpByTimeDelay = false</i>). 
</li>
<li>
If <i>runSig</i> becomes false or if the water flow rate becomes less than the minimum, the CHP will automatically transition to the cool-down mode.
</li>
</ul>

<p>
From the normal mode
</p>
<ul>
<li>
The transition from the normal operation to the cool-down mode will occur when <i>runSig</i> becomes false or if the water flow rate becomes less than the minimum. 
</li>
</ul>

<p>
From the cool-down mode
</p>
<ul>
<li>
The transition from the cool-down mode will occur after the specified time delay. If <i>avaSig</i> is true, the CHP will transition to the stand-by mode; else, it will transition to the off mode. 
</li>
<li>
If the CHP has the mandatory cool-down configuration (if <i>coolDownOptional = false</i>), the plant has to complete the cool-down period before it can be reactivated.
If the CHP has the optional cool-down configuration (if <i>coolDownOptional = true</i>), the plant may imediatelly switch to the warm-up mode if it gets reactivated (<i>runSig</i> = true)
</li>
</ul>


</html>", revisions="<html>
<ul>
<li>
June 18, 2019 by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
