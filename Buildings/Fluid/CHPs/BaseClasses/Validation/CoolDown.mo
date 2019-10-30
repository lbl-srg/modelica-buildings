within Buildings.Fluid.CHPs.BaseClasses.Validation;
model CoolDown "Validate model CoolDown"

  parameter Buildings.Fluid.CHPs.Data.ValidationData1 per
    "CHP performance data"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));

  Buildings.Fluid.CHPs.BaseClasses.Types.Mode actMod "Mode indicator";
  Buildings.Fluid.CHPs.BaseClasses.CoolDown cooDow(final per=per) "Cool-down mode"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.BooleanTable runSig(
    final startValue=true,
    table={300,600,660,690}) "Plant run signal"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Not notRun "Plant does not run"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Plant run and cool down is optional"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant cooDowOpt(
    final k=per.coolDownOptional)
    "Cool down is optional"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));

protected
  Modelica.StateGraph.InitialStep norm(final nIn=2, final nOut=2)
    "Normal operation mode"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  Modelica.StateGraph.TransitionWithSignal transition2 "Cool down to off mode"
    annotation (Placement(transformation(extent={{10,40},{30,60}})));
  Modelica.StateGraph.TransitionWithSignal transition1
    "Normal to cool down mode"
    annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
  Modelica.StateGraph.TransitionWithSignal transition4
    "Cool down to normal mode"
    annotation (Placement(transformation(extent={{-30,-10},{-50,10}})));
  Modelica.StateGraph.Step off(final nIn=1, final nOut=1) "Off mode"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Modelica.StateGraph.TransitionWithSignal transition3 "Off to normal mode"
    annotation (Placement(transformation(extent={{70,40},{90,60}})));
  Modelica.StateGraph.Transition transition5(
    final condition=false,
    final waitTime=0)
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

equation
  if norm.active then
    actMod = CHPs.BaseClasses.Types.Mode.Normal;
  elseif cooDow.active then
    actMod = CHPs.BaseClasses.Types.Mode.CoolDown;
  else
    actMod = CHPs.BaseClasses.Types.Mode.Off;
  end if;
  connect(transition4.outPort, norm.inPort[1]) annotation (Line(points={{-41.5,0},
          {-90,0},{-90,50.5},{-81,50.5}}, color={0,0,0}));
  connect(transition1.inPort, norm.outPort[1]) annotation (Line(points={{-44,70},
          {-52,70},{-52,50.25},{-59.5,50.25}}, color={0,0,0}));
  connect(transition4.inPort, cooDow.suspend[1]) annotation (Line(points={{-36,0},
          {-16,0},{-16,39.6667},{-15,39.6667}}, color={0,0,0}));
  connect(off.inPort[1], transition2.outPort) annotation (Line(points={{39,50},
          {21.5,50}}, color={0,0,0}));
  connect(transition2.inPort, cooDow.outPort) annotation (Line(points={{16,50},
          {0.333333,50}}, color={0,0,0}));
  connect(off.outPort[1], transition3.inPort) annotation (Line(points={{60.5,50},
          {76,50}}, color={0,0,0}));
  connect(transition3.outPort, norm.inPort[2]) annotation (Line(points={{81.5,50},
          {90,50},{90,-20},{-90,-20},{-90,49.5},{-81,49.5}}, color={0,0,0}));
  connect(transition5.inPort, norm.outPort[2]) annotation (Line(points={{-44,30},
          {-52,30},{-52,49.75},{-59.5,49.75}},color={0,0,0}));
  connect(transition1.outPort, cooDow.inPort1) annotation (Line(points={{-38.5,
          70},{-30,70},{-30,54},{-20.6667,54}},
                                            color={0,0,0}));
  connect(transition5.outPort, cooDow.inPort) annotation (Line(points={{-38.5,
          30},{-30,30},{-30,50},{-20.6667,50}},
                                           color={0,0,0}));
  connect(runSig.y, notRun.u) annotation (Line(points={{-59,-100},{-22,-100}},
          color={255,0,255}));
  connect(notRun.y, transition1.condition) annotation (Line(points={{2,-100},{40,
          -100},{40,-10},{-26,-10},{-26,52},{-40,52},{-40,58}}, color={255,0,255}));
  connect(cooDowOpt.y, and1.u1) annotation (Line(points={{-58,-60},{-22,-60}},
          color={255,0,255}));
  connect(runSig.y, and1.u2) annotation (Line(points={{-59,-100},{-40,-100},{-40,
          -68},{-22,-68}}, color={255,0,255}));
  connect(runSig.y, transition3.condition) annotation (Line(points={{-59,-100},{
          -40,-100},{-40,-40},{80,-40},{80,38}}, color={255,0,255}));
  connect(and1.y, transition4.condition) annotation (Line(points={{2,-60},{20,-60},
          {20,-30},{-40,-30},{-40,-12}}, color={255,0,255}));
  connect(cooDow.y, transition2.condition) annotation (Line(points={{0.666667,
          46.6667},{10,46.6667},{10,30},{20,30},{20,38}},
                                                 color={255,0,255}));

annotation (
    experiment(StopTime=900, Tolerance=1e-6),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/CoolDown.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.CoolDown\">
Buildings.Fluid.CHPs.BaseClasses.CoolDown</a>
for defining the cool-down operating mode. 
</p>
</html>", revisions="<html>
<ul>
<li>
July 01 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"),
   Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
        graphics={Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-100,-120},{100,120}})));
end CoolDown;
