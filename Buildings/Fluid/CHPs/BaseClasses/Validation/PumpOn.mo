within Buildings.Fluid.CHPs.BaseClasses.Validation;
model PumpOn "Validate model PumpOn"

  parameter Buildings.Fluid.CHPs.Data.ValidationData1 per
    "CHP performance data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable mWat_flow(
    table=[0,0; 120,0; 121,0.05; 240,0.05; 241,0.5; 600,0.5],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    "Water flow rate"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Fluid.CHPs.BaseClasses.Types.Mode actMod "Mode indicator";
  Buildings.Fluid.CHPs.BaseClasses.PumpOn pumOn
    "Operating mode in which the water pump starts to run"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.StateGraph.TransitionWithSignal transition2(
    final enableTimer=true,
    final waitTime=60) "Pump on to warm up mode"
    annotation (Placement(transformation(extent={{10,20},{30,40}})));

protected
  Modelica.StateGraph.InitialStep off(nIn=1) "Off mode"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.StateGraph.Step warUp(nIn=1, nOut=1) "Warm-up mode"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Modelica.StateGraph.Transition transition1(
    final condition=true,
    final enableTimer=true,
    final waitTime=120) "Off to pump on mode"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Modelica.StateGraph.Transition transition3(
    final condition=true,
    final enableTimer=true,
    final waitTime=120) "Warm up to off mode"
    annotation (Placement(transformation(extent={{70,20},{90,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minWatFlo(
    final k=per.mWatMin)
    "Minimum water flow rate"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater minWatFlo1
    "Check if water flow rate is higher than the minimum"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

equation
  if off.active then
    actMod = CHPs.BaseClasses.Types.Mode.Off;
  elseif pumOn.active then
    actMod = CHPs.BaseClasses.Types.Mode.PumpOn;
  else
    actMod = CHPs.BaseClasses.Types.Mode.WarmUp;
  end if;
  connect(off.outPort[1], transition1.inPort)
    annotation (Line(points={{-59.5,30},{-44,30}}, color={0,0,0}));
  connect(pumOn.inPort, transition1.outPort)
    annotation (Line(points={{-20.6667,30},{-38.5,30}}, color={0,0,0}));
  connect(pumOn.outPort, transition2.inPort)
    annotation (Line(points={{0.33333,30},{16,30}}, color={0,0,0}));
  connect(transition2.outPort, warUp.inPort[1])
    annotation (Line(points={{21.5,30},{39,30}}, color={0,0,0}));
  connect(warUp.outPort[1], transition3.inPort)
    annotation (Line(points={{60.5,30},{76,30}}, color={0,0,0}));
  connect(transition3.outPort, off.inPort[1]) annotation (Line(points={{81.5,30},
          {92,30},{92,0},{-88,0},{-88,30},{-81,30}}, color={0,0,0}));
  connect(mWat_flow.y[1], minWatFlo1.u1)
    annotation (Line(points={{-58,-30},{-22,-30}}, color={0,0,127}));
  connect(minWatFlo.y, minWatFlo1.u2) annotation (Line(points={{-58,-70},{-40,-70},
          {-40,-38},{-22,-38}}, color={0,0,127}));
  connect(minWatFlo1.y, transition2.condition)
    annotation (Line(points={{2,-30},{20,-30},{20,18}}, color={255,0,255}));

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
