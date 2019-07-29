within Buildings.Fluid.CHPs.BaseClasses.Validation;
model CoolDown "Validate model CoolDown"

  parameter Buildings.Fluid.CHPs.Data.ValidationData1 per
    annotation (Placement(transformation(extent={{-98,-98},{-78,-78}})));

  CHPs.BaseClasses.Types.Mode actMod "Mode indicator";
  Buildings.Fluid.CHPs.BaseClasses.CoolDown cooDow(per=per) "Cool-down mode"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Sources.BooleanTable runSig(startValue=true, table={300,600,
        660,690})
              "Plant run signal"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
protected
  Modelica.StateGraph.InitialStep norm(nIn=2, nOut=2)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-80,-81},{-60,-61}})));
  Modelica.StateGraph.TransitionWithSignal transition2
    annotation (Placement(transformation(extent={{10,20},{30,40}})));
  Modelica.StateGraph.Transition transition1(condition=not runSig.y)
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  Modelica.StateGraph.Transition transition4(condition=runSig.y and per.coolDownOptional)
    annotation (Placement(transformation(extent={{-30,-40},{-50,-20}})));
  Modelica.StateGraph.Step off(nIn=1, nOut=1) "Off mode"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Modelica.StateGraph.Transition transition3(condition=runSig.y)
    annotation (Placement(transformation(extent={{70,20},{90,40}})));
  Modelica.StateGraph.Transition transition5(condition=false, waitTime=0)
    annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
equation
  if norm.active then
    actMod = CHPs.BaseClasses.Types.Mode.Normal;
  elseif cooDow.active then
    actMod = CHPs.BaseClasses.Types.Mode.CoolDown;
  else
    actMod = CHPs.BaseClasses.Types.Mode.Off;
  end if;

  connect(transition4.outPort, norm.inPort[1]) annotation (Line(points={{-41.5,-30},
          {-90,-30},{-90,30.5},{-81,30.5}}, color={0,0,0}));
  connect(transition1.inPort, norm.outPort[1]) annotation (Line(points={{-44,50},
          {-52,50},{-52,30.25},{-59.5,30.25}}, color={0,0,0}));
  connect(transition4.inPort, cooDow.suspend[1]) annotation (Line(points={{-36,-30},
          {-16,-30},{-16,19.6667},{-15,19.6667}}, color={0,0,0}));
  connect(off.inPort[1], transition2.outPort)
    annotation (Line(points={{39,30},{21.5,30}}, color={0,0,0}));
  connect(transition2.inPort, cooDow.outPort)
    annotation (Line(points={{16,30},{0.333333,30}}, color={0,0,0}));
  connect(off.outPort[1], transition3.inPort)
    annotation (Line(points={{60.5,30},{76,30}}, color={0,0,0}));
  connect(transition3.outPort, norm.inPort[2]) annotation (Line(points={{81.5,30},
          {90,30},{90,-50},{-90,-50},{-90,29.5},{-81,29.5}}, color={0,0,0}));
  connect(transition5.inPort, norm.outPort[2]) annotation (Line(points={{-44,10},
          {-52,10},{-52,29.75},{-59.5,29.75}},color={0,0,0}));
  connect(transition1.outPort, cooDow.inPort1) annotation (Line(points={{-38.5,
          50},{-30,50},{-30,34},{-20.6667,34}},
                                            color={0,0,0}));
  connect(transition5.outPort, cooDow.inPort) annotation (Line(points={{-38.5,
          10},{-30,10},{-30,30},{-20.6667,30}},
                                           color={0,0,0}));
  connect(cooDow.y, transition2.condition) annotation (Line(points={{0.666667,
          26.6667},{10.4,26.6667},{10.4,18},{20,18}},
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
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})));
end CoolDown;
