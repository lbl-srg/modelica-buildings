within Buildings.Fluid.CHPs.BaseClasses.Validation;
model WarmUpTimDel "Validate model WarmUp if warm-up by time delay"

  parameter Buildings.Fluid.CHPs.Data.ValidationData1 per
    annotation (Placement(transformation(extent={{-98,-98},{-78,-78}})));

   Modelica.Blocks.Sources.BooleanTable runSig(table={300,330,600})
  "Plant run signal"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  CHPs.BaseClasses.Types.Mode actMod "Mode indicator";
  Buildings.Fluid.CHPs.BaseClasses.WarmUp warUp(per=per) "Warm-up mode"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

protected
  Modelica.Blocks.Sources.Constant TEng(k=273.15 + 100) "Engine temperature"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.StateGraph.InitialStep off(nIn=2, nOut=2) "Off mode"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-80,-81},{-60,-61}})));
  Modelica.StateGraph.TransitionWithSignal transition2
    annotation (Placement(transformation(extent={{10,20},{30,40}})));
  Modelica.StateGraph.Transition transition1(condition=runSig.y)
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Modelica.StateGraph.Transition transition4(condition=not runSig.y)
    annotation (Placement(transformation(extent={{-30,-40},{-50,-20}})));
  Modelica.StateGraph.Step nor(nIn=1, nOut=1) "Normal mode"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Modelica.StateGraph.Transition transition3(condition=not runSig.y)
    annotation (Placement(transformation(extent={{70,20},{90,40}})));
  Modelica.StateGraph.Transition transition5(condition=false, waitTime=0)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

equation
  if off.active then
    actMod = CHPs.BaseClasses.Types.Mode.Off;
  elseif warUp.active then
    actMod = CHPs.BaseClasses.Types.Mode.WarmUp;
  else
    actMod = CHPs.BaseClasses.Types.Mode.Normal;
  end if;

  connect(transition4.outPort, off.inPort[1]) annotation (Line(points={{-41.5,-30},
          {-90,-30},{-90,30.5},{-81,30.5}}, color={0,0,0}));
  connect(transition1.inPort, off.outPort[1])
    annotation (Line(points={{-44,30},{-52,30},{-52,30.25},{-59.5,30.25}},
                                                   color={0,0,0}));
  connect(transition4.inPort, warUp.suspend[1]) annotation (Line(points={{-36,-30},
          {-16,-30},{-16,19.6667},{-15,19.6667}}, color={0,0,0}));
  connect(nor.inPort[1], transition2.outPort)
    annotation (Line(points={{39,30},{21.5,30}}, color={0,0,0}));
  connect(transition2.inPort, warUp.outPort)
    annotation (Line(points={{16,30},{0.333333,30}}, color={0,0,0}));
  connect(warUp.y, transition2.condition) annotation (Line(points={{0.666667,24.8},
          {10.3333,24.8},{10.3333,18},{20,18}},color={255,0,255}));
  connect(TEng.y, warUp.TEng) annotation (Line(points={{-59,70},{-30,70},{-30,
          36},{-26,36},{-26,35.3333},{-20.6667,35.3333}},
                                                      color={0,0,127}));
  connect(nor.outPort[1],transition3. inPort)
    annotation (Line(points={{60.5,30},{76,30}}, color={0,0,0}));
  connect(transition3.outPort, off.inPort[2]) annotation (Line(points={{81.5,30},
          {90,30},{90,-50},{-90,-50},{-90,29.5},{-81,29.5}},
                                                           color={0,0,0}));
  connect(transition1.outPort, warUp.inPort)
    annotation (Line(points={{-38.5,30},{-20.6667,30}}, color={0,0,0}));
  connect(transition5.outPort, warUp.inPort1) annotation (Line(points={{-38.5,0},
          {-22,0},{-22,24.6667},{-20.6667,24.6667}}, color={0,0,0}));
  connect(transition5.inPort, off.outPort[2]) annotation (Line(points={{-44,0},{
          -52,0},{-52,29.75},{-59.5,29.75}}, color={0,0,0}));
  annotation (
    experiment(StopTime=900, Tolerance=1e-6),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/WarmUpTimDel.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.WarmUp\">
Buildings.Fluid.CHPs.BaseClasses.WarmUp</a>
for defining the warm-up operating mode. The example is for the warm-up period with the static time delay (e.g. CHPs with internal combustion engines). 
</p>
</html>", revisions="<html>
<ul>
<li>
July 01 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end WarmUpTimDel;
