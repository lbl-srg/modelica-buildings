within Buildings.Fluid.CHPs.BaseClasses;
model Controller
  extends Modelica.Blocks.Icons.Block;
  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-98,-118},{-78,-98}})));

  Modelica.Blocks.Interfaces.BooleanInput avaSig annotation (Placement(
        transformation(extent={{-130,166},{-100,196}}), iconTransformation(
          extent={{-120,50},{-100,70}})));
  Modelica.Blocks.Interfaces.BooleanInput runSig annotation (Placement(
        transformation(extent={{-130,146},{-100,176}}), iconTransformation(
          extent={{-120,10},{-100,30}})));
  Modelica.Blocks.Interfaces.RealInput mWat_flow(unit="kg/s")
    "Cooling water flow rate" annotation (Placement(transformation(
        origin={-110,140},
        extent={{10,-10},{-10,10}},
        rotation=180), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,-20})));
  Modelica.Blocks.Interfaces.RealInput TEng(unit="K") "Engine temperature"
    annotation (Placement(transformation(
        origin={-110,120},
        extent={{10,-10},{-10,10}},
        rotation=180), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,-60})));
  CHPs.BaseClasses.Interfaces.ModeTypeOutput opeMod
    "Type of the operation mode" annotation (Placement(transformation(extent={{
            220,10},{240,30}}), iconTransformation(extent={{100,-10},{120,10}})));

  parameter Modelica.SIunits.Time waitTime=60
    "Wait time before transition from pump-on mode fires" annotation (Dialog(tab="Dynamics"));

protected
  CHPs.BaseClasses.AssertWatMas assWatMas(per=per)
    "Assert if water flow rate is outside boundaries"
    annotation (Placement(transformation(extent={{200,134},{220,154}})));
  CHPs.BaseClasses.Types.Mode actMod "Mode indicator";
  PumpOn pumpOn
    annotation (Placement(transformation(extent={{40,82},{60,102}})));
  Modelica.StateGraph.Transition transition1(condition=avaSig)
    annotation (Placement(transformation(extent={{-52,82},{-32,102}})));
  Modelica.StateGraph.Transition transition2(condition=runSig)
    annotation (Placement(transformation(extent={{8,82},{28,102}})));
  Modelica.StateGraph.Step normal(nIn=1, nOut=1)
    annotation (Placement(transformation(extent={{160,82},{180,102}})));
  Modelica.StateGraph.Transition transition8(condition=noGoSig.y)
    annotation (Placement(transformation(extent={{188,82},{208,102}})));
  Modelica.StateGraph.Transition transition7(condition=noGoSig.y)
  annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={78,28})));
  CHPs.BaseClasses.StandBy standBy(nResume=1)
    annotation (Placement(transformation(extent={{-20,82},{0,102}})));
  Modelica.StateGraph.Transition transition3(condition=not avaSig)
    annotation (Placement(transformation(extent={{-68,20},{-88,40}})));
  CHPs.BaseClasses.WarmUp warmUp(per=per)
    annotation (Placement(transformation(extent={{100,82},{120,102}})));
  CHPs.BaseClasses.CoolDown coolDown(per=per)
    annotation (Placement(transformation(extent={{0,-20},{-20,0}})));
  Modelica.StateGraph.TransitionWithSignal transition9
    annotation (Placement(transformation(extent={{-68,-20},{-88,0}})));
  Modelica.StateGraph.Transition transition10(condition=goSig.y and per.coolDownOptional) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={18,-50})));
  Modelica.StateGraph.TransitionWithSignal transition6
    annotation (Placement(transformation(extent={{130,82},{150,102}})));
  Modelica.StateGraph.InitialStep plantOff(nIn=3)
    annotation (Placement(transformation(extent={{-80,82},{-60,102}})));

  Modelica.StateGraph.TransitionWithSignal transition4(enableTimer=true, waitTime=
       waitTime)
    annotation (Placement(transformation(extent={{68,82},{88,102}})));
  Modelica.StateGraph.Transition transition5(condition=not avaSig or not
        runSig)
    annotation (Placement(transformation(extent={{28,20},{8,40}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=goSig.y)
    "Check if water flow rate is higher than the minimum"
    annotation (Placement(transformation(extent={{46,60},{78,80}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression2(y=noGoSig.y)
    annotation (Placement(transformation(extent={{-12,-66},{-40,-50}})));
  Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{-50,-44},{-64,-58}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression1(y=goSig.y)
    annotation (Placement(transformation(extent={{108,28},{136,44}})));
  Controls.OBC.CDL.Logical.And and1
    annotation (Placement(transformation(extent={{144,48},{158,34}})));
  Modelica.Blocks.Sources.BooleanExpression goSig(y=runSig and (mWat_flow >=
        per.mWatMin) and (mWat_flow > 0.001))
    "Check if water flow rate is higher than the minimum when runSig = true"
    annotation (Placement(transformation(extent={{8,168},{54,198}})));
  Modelica.Blocks.Sources.BooleanExpression noGoSig(y=not runSig or (mWat_flow <
        (1 - 0.05)*per.mWatMin) or (mWat_flow < 0.001))
    "Check if water flow rate is lower than the minimum or if runSig = false"
    annotation (Placement(transformation(extent={{8,146},{54,176}})));
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
    annotation (Line(points={{180.5,92},{194,92}}, color={0,0,0}));
  connect(standBy.outPort, transition2.inPort)
    annotation (Line(points={{0.33333,92},{14,92}}, color={0,0,0}));
  connect(TEng,warmUp.TEng)  annotation (Line(points={{-110,120},{96,120},{96,
          97.3333},{99.3333,97.3333}},
                              color={0,0,127}));
  connect(coolDown.outPort, transition9.inPort)
    annotation (Line(points={{-20.3333,-10},{-74,-10}},
                                                      color={0,0,0}));
  connect(coolDown.suspend[1], transition10.inPort) annotation (Line(points={{-5,
          -20.3333},{-6,-20.3333},{-6,-50},{14,-50}},
                                                    color={0,0,0}));
  connect(transition1.outPort, standBy.inPort)
    annotation (Line(points={{-40.5,92},{-20.6667,92}}, color={0,0,0}));
  connect(transition8.outPort, coolDown.inPort) annotation (Line(points={{199.5,
          92},{210,92},{210,-10},{0.66667,-10}},color={0,0,0}));
  connect(transition7.outPort, coolDown.inPort1) annotation (Line(points={{76.5,28},
          {60,28},{60,-6},{0.66667,-6}},      color={0,0,0}));
  connect(standBy.suspend[1], transition3.inPort)
    annotation (Line(points={{-15,81.6667},{-15,30},{-74,30}}, color={0,0,0}));
  connect(transition10.outPort, warmUp.inPort1) annotation (Line(points={{19.5,
          -50},{94,-50},{94,86.6667},{99.3333,86.6667}},
                                                    color={0,0,0}));
  connect(warmUp.outPort, transition6.inPort)
    annotation (Line(points={{120.333,92},{136,92}}, color={0,0,0}));
  connect(plantOff.outPort[1], transition1.inPort)
    annotation (Line(points={{-59.5,92},{-46,92}}, color={0,0,0}));
  connect(transition2.outPort, pumpOn.inPort)
    annotation (Line(points={{19.5,92},{39.3333,92}}, color={0,0,0}));
  connect(pumpOn.outPort, transition4.inPort)
    annotation (Line(points={{60.3333,92},{74,92}}, color={0,0,0}));
  connect(pumpOn.suspend[1], transition5.inPort)
    annotation (Line(points={{45,81.6667},{45,30},{22,30}}, color={0,0,0}));
  connect(transition4.outPort, warmUp.inPort)
    annotation (Line(points={{79.5,92},{99.3333,92}}, color={0,0,0}));
  connect(transition6.outPort, normal.inPort[1])
    annotation (Line(points={{141.5,92},{159,92}}, color={0,0,0}));
  connect(transition3.outPort, plantOff.inPort[1]) annotation (Line(points={{-79.5,
          30},{-90,30},{-90,92.6667},{-81,92.6667}}, color={0,0,0}));
  connect(transition5.outPort, plantOff.inPort[2]) annotation (Line(points={{16.5,30},
          {-90,30},{-90,92},{-81,92}},     color={0,0,0}));
  connect(transition9.outPort, plantOff.inPort[3]) annotation (Line(points={{-79.5,
          -10},{-90,-10},{-90,91.3333},{-81,91.3333}},
                                                     color={0,0,0}));
  connect(runSig, assWatMas.runSig) annotation (Line(points={{-115,161},{-7.5,161},
          {-7.5,148},{198,148}},           color={255,0,255}));
  connect(booleanExpression.y, transition4.condition)
    annotation (Line(points={{79.6,70},{78,70},{78,80}}, color={255,0,255}));
  connect(assWatMas.mWat_flow, mWat_flow)
    annotation (Line(points={{198,140},{-110,140}}, color={0,0,127}));
  connect(coolDown.y, and2.u2) annotation (Line(points={{-20.6667,-13.3333},{
          -20.6667,-14},{-44,-14},{-44,-45.4},{-48.6,-45.4}},
                                          color={255,0,255}));
  connect(booleanExpression2.y, and2.u1) annotation (Line(points={{-41.4,-58},{-44,
          -58},{-44,-51},{-48.6,-51}}, color={255,0,255}));
  connect(and2.y, transition9.condition) annotation (Line(points={{-64.7,-51},{-78,
          -51},{-78,-22}},     color={255,0,255}));
  connect(transition7.inPort, warmUp.suspend[1]) annotation (Line(points={{82,28},
          {104,28},{104,81.6667},{105,81.6667}}, color={0,0,0}));
  connect(warmUp.y, and1.u2) annotation (Line(points={{120.667,86.8},{120.667,
          46.6},{142.6,46.6}},
                         color={255,0,255}));
  connect(booleanExpression1.y, and1.u1) annotation (Line(points={{137.4,36},{140,
          36},{140,41},{142.6,41}}, color={255,0,255}));
  connect(and1.y, transition6.condition) annotation (Line(points={{158.7,41},{158.7,
          59.5},{140,59.5},{140,80}}, color={255,0,255}));
  annotation (
    defaultComponentName="conMai",
    Diagram(coordinateSystem(extent={{-100,-120},{220,200}})),
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
