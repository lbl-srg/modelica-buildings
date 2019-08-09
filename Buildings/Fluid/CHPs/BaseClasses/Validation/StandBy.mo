within Buildings.Fluid.CHPs.BaseClasses.Validation;
model StandBy "Validate model StandBy"

  parameter Buildings.Fluid.CHPs.Data.ValidationData1 per
    annotation (Placement(transformation(extent={{-98,-98},{-78,-78}})));

  Modelica.Blocks.Sources.Constant mWat_flow(k=0.5) "Water flow rate"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.BooleanTable avaSig(table={300,600,900,1260})
    "Plant availability signal"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Sources.BooleanTable runSig(table={1200,1260})
    "Plant run signal"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  CHPs.BaseClasses.Types.Mode actMod "Mode indicator";
  Buildings.Fluid.CHPs.BaseClasses.PumpOn pumOn
    "Operating mode in which the water pump starts to run"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Fluid.CHPs.BaseClasses.StandBy staBy "Stand-by operating mode"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

protected
  Modelica.StateGraph.InitialStep off(nIn=2)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-80,-81},{-60,-61}})));
  Modelica.StateGraph.TransitionWithSignal transition3(enableTimer=true,
      waitTime=60)
    annotation (Placement(transformation(extent={{72,0},{92,20}})));

  Modelica.StateGraph.Transition transition1(condition=avaSig.y)
    annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
  Modelica.StateGraph.Transition transition2(condition=runSig.y)
    annotation (Placement(transformation(extent={{12,0},{32,20}})));
  Modelica.StateGraph.Transition transition4(condition=not avaSig.y)
    annotation (Placement(transformation(extent={{-30,-40},{-50,-20}})));

  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=mWat_flow.y >
        per.mWatMin)       "Check if water flow rate is higher than the minimum"
    annotation (Placement(transformation(extent={{42,-22},{70,-6}})));
equation
  if off.active then
    actMod = CHPs.BaseClasses.Types.Mode.Off;
  elseif staBy.active then
    actMod = CHPs.BaseClasses.Types.Mode.StandBy;
  else
    actMod = CHPs.BaseClasses.Types.Mode.PumpOn;
  end if;

  connect(pumOn.outPort, transition3.inPort)
    annotation (Line(points={{60.3333,10},{78,10}}, color={0,0,0}));
  connect(transition1.inPort, off.outPort[1])
    annotation (Line(points={{-44,10},{-59.5,10}}, color={0,0,0}));
  connect(transition1.outPort, staBy.inPort)
    annotation (Line(points={{-38.5,10},{-20.6667,10}}, color={0,0,0}));
  connect(transition2.inPort, staBy.outPort)
    annotation (Line(points={{18,10},{0.333333,10}}, color={0,0,0}));
  connect(transition2.outPort, pumOn.inPort)
    annotation (Line(points={{23.5,10},{39.3333,10}}, color={0,0,0}));
  connect(transition4.inPort, staBy.suspend[1]) annotation (Line(points={{-36,-30},
          {-14,-30},{-14,-0.333333},{-15,-0.333333}}, color={0,0,0}));
  connect(transition4.outPort, off.inPort[1]) annotation (Line(points={{-41.5,-30},
          {-90,-30},{-90,10.5},{-81,10.5}}, color={0,0,0}));
  connect(transition3.outPort, off.inPort[2]) annotation (Line(points={{83.5,10},
          {92,10},{92,-48},{-90,-48},{-90,9.5},{-81,9.5}}, color={0,0,0}));
  connect(booleanExpression.y, transition3.condition)
    annotation (Line(points={{71.4,-14},{82,-14},{82,-2}}, color={255,0,255}));
  annotation (
    experiment(StopTime=1500, Tolerance=1e-6),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/StandBy.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.StandBy\">
Buildings.Fluid.CHPs.BaseClasses.StandBy</a>
for defining the stand-by operating mode.
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
end StandBy;
