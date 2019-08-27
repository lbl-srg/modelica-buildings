within Buildings.Fluid.CHPs.BaseClasses.Validation;
model PumpOn "Validate model PumpOn"
  parameter Buildings.Fluid.CHPs.Data.ValidationData1 per
    annotation (Placement(transformation(extent={{-98,-98},{-78,-78}})));
  Controls.OBC.CDL.Continuous.Sources.TimeTable
                                    mWat_flow(table=[0,0; 120,0; 121,0.05; 240,0.05;
        241,0.5; 600,0.5], smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
                           "Water flow rate"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  CHPs.BaseClasses.Types.Mode actMod "Mode indicator";
  Buildings.Fluid.CHPs.BaseClasses.PumpOn pumOn
    "Operating mode in which the water pump starts to run"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
protected
  Modelica.StateGraph.InitialStep off(nIn=1)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.StateGraph.Step warUp(nIn=1, nOut=1) "Warm-up mode"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-80,-81},{-60,-61}})));
  Modelica.StateGraph.Transition transition1(
    condition=true,
    enableTimer=true,
    waitTime=120)
    annotation (Placement(transformation(extent={{-48,0},{-28,20}})));
  Modelica.StateGraph.TransitionWithSignal transition2(enableTimer=true,
      waitTime=60)
    annotation (Placement(transformation(extent={{12,0},{32,20}})));
  Modelica.StateGraph.Transition transition3(
    condition=true,
    enableTimer=true,
    waitTime=120) annotation (Placement(transformation(extent={{72,0},{92,20}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=mWat_flow.y[1]
         > per.mWatMin)    "Check if water flow rate is higher than the minimum"
    annotation (Placement(transformation(extent={{-18,-20},{10,-4}})));
equation
  if off.active then
    actMod = CHPs.BaseClasses.Types.Mode.Off;
  elseif pumOn.active then
    actMod = CHPs.BaseClasses.Types.Mode.PumpOn;
  else
    actMod = CHPs.BaseClasses.Types.Mode.WarmUp;
  end if;
  connect(off.outPort[1], transition1.inPort)
    annotation (Line(points={{-59.5,10},{-42,10}}, color={0,0,0}));
  connect(pumOn.inPort, transition1.outPort)
    annotation (Line(points={{-20.6667,10},{-36.5,10}}, color={0,0,0}));
  connect(pumOn.outPort, transition2.inPort)
    annotation (Line(points={{0.33333,10},{18,10}}, color={0,0,0}));
  connect(transition2.outPort, warUp.inPort[1])
    annotation (Line(points={{23.5,10},{39,10}}, color={0,0,0}));
  connect(warUp.outPort[1], transition3.inPort)
    annotation (Line(points={{60.5,10},{78,10}}, color={0,0,0}));
  connect(transition3.outPort, off.inPort[1]) annotation (Line(points={{83.5,10},
          {92,10},{92,-20},{-88,-20},{-88,10},{-81,10}}, color={0,0,0}));
  connect(booleanExpression.y, transition2.condition)
    annotation (Line(points={{11.4,-12},{22,-12},{22,-2}}, color={255,0,255}));
  annotation (
    experiment(StopTime=600, Tolerance=1e-6),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/PumpOn.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.PumpOn\">
Buildings.Fluid.CHPs.BaseClasses.PumpOn</a>
for defining the operating mode in which the water pump starts to run.
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
end PumpOn;
