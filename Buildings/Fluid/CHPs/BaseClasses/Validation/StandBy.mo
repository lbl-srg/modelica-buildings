within Buildings.Fluid.CHPs.BaseClasses.Validation;
model StandBy "Validate model StandBy"
  extends Modelica.Icons.Example;

  parameter Buildings.Fluid.CHPs.Data.ValidationData1 per
    "CHP performance data"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant mWat_flow(
    final k=0.5) "Water mass flow rate"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Fluid.CHPs.BaseClasses.Types.Mode actMod "Mode indicator";
  Modelica.StateGraph.TransitionWithSignal transition1 "Off to standby mode"
    annotation (Placement(transformation(extent={{-50,70},{-30,90}})));
  Modelica.StateGraph.TransitionWithSignal transition2
    "Standby to pump on mode"
    annotation (Placement(transformation(extent={{10,70},{30,90}})));

  Modelica.StateGraph.Step staBy(nOut=2) "Plant is in standby mode"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Modelica.StateGraph.Step pumOn "Plant pump is on"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
protected
  Modelica.Blocks.Sources.BooleanTable avaSig(table={300,600,900,1260})
    "Plant availability signal"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not notAva "Plant not available"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.BooleanTable runSig(table={1200,1260})
    "Plant run signal"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.StateGraph.InitialStep off(nIn=2) "Off mode"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Modelica.StateGraph.TransitionWithSignal transition3(
    final enableTimer=true,
    final waitTime=60) "Pump on to off mode"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Modelica.StateGraph.TransitionWithSignal transition4 "Standby to off mode"
    annotation (Placement(transformation(extent={{-30,30},{-50,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minWatFlo(
    final k=per.mWatMin_flow)
    "Minimum water mass flow rate"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater cheMinFlo
    "Check if water mass flow rate is higher than the minimum"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));

equation
  if off.active then
    actMod = CHPs.BaseClasses.Types.Mode.Off;
  elseif staBy.active then
    actMod = CHPs.BaseClasses.Types.Mode.StandBy;
  else
    actMod = CHPs.BaseClasses.Types.Mode.PumpOn;
  end if;
  connect(transition1.inPort, off.outPort[1])
    annotation (Line(points={{-44,80},{-59.5,80}}, color={0,0,0}));
  connect(transition4.outPort, off.inPort[1]) annotation (Line(points={{-41.5,40},
          {-90,40},{-90,80.5},{-81,80.5}}, color={0,0,0}));
  connect(transition3.outPort, off.inPort[2]) annotation (Line(points={{81.5,80},
          {92,80},{92,20},{-90,20},{-90,79.5},{-81,79.5}}, color={0,0,0}));
  connect(avaSig.y, transition1.condition) annotation (Line(points={{-59,-40},{-50,
          -40},{-50,60},{-40,60},{-40,68}}, color={255,0,255}));
  connect(avaSig.y, notAva.u) annotation (Line(points={{-59,-40},{-50,-40},{-50,
          -20},{-90,-20},{-90,0},{-82,0}}, color={255,0,255}));
  connect(notAva.y, transition4.condition)
    annotation (Line(points={{-58,0},{-40,0},{-40,28}}, color={255,0,255}));
  connect(runSig.y, transition2.condition)
    annotation (Line(points={{1,0},{20,0},{20,68}}, color={255,0,255}));
  connect(mWat_flow.y, cheMinFlo.u1)
    annotation (Line(points={{2,-40},{18,-40}}, color={0,0,127}));
  connect(minWatFlo.y, cheMinFlo.u2) annotation (Line(points={{2,-80},{10,-80},{
          10,-48},{18,-48}}, color={0,0,127}));
  connect(cheMinFlo.y, transition3.condition)
    annotation (Line(points={{42,-40},{80,-40},{80,68}}, color={255,0,255}));
  connect(pumOn.outPort[1], transition3.inPort) annotation (Line(points={{60.5,
          80.25},{68,80.25},{68,80},{76,80}}, color={0,0,0}));
  connect(transition2.outPort, pumOn.inPort[1])
    annotation (Line(points={{21.5,80},{39,80}}, color={0,0,0}));
  connect(staBy.outPort[1], transition2.inPort) annotation (Line(points={{0.5,
          80.25},{8,80.25},{8,80},{16,80}}, color={0,0,0}));
  connect(transition1.outPort, staBy.inPort[1])
    annotation (Line(points={{-38.5,80},{-21,80}}, color={0,0,0}));
  connect(staBy.outPort[2], transition4.inPort) annotation (Line(points={{0.5,
          79.75},{10,79.75},{10,40},{-36,40}}, color={0,0,0}));
annotation (
  experiment(StopTime=1500, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/StandBy.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates the transitions to and from the stand-by operating mode.
</p>
</html>", revisions="<html>
<ul>
<li>
October 31, 2019, by Jianjun Hu:<br/>
Refactored implementation.
</li>
<li>
July 01 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end StandBy;
