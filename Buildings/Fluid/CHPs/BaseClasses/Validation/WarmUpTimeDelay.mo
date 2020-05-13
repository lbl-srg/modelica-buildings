within Buildings.Fluid.CHPs.BaseClasses.Validation;
model WarmUpTimeDelay
  "Validate model WarmUp if warm-up by time delay"
  extends Modelica.Icons.Example;

  parameter Buildings.Fluid.CHPs.Data.ValidationData1 per
    "CHP performance data"
    annotation (Placement(transformation(extent={{60,62},{80,82}})));
  Modelica.Blocks.Sources.BooleanTable runSig(final table={300,330,600})
  "Plant run signal"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Buildings.Fluid.CHPs.BaseClasses.Types.Mode actMod "Mode indicator";
  Modelica.StateGraph.TransitionWithSignal transition1 "Off to warm-up mode"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Modelica.StateGraph.TransitionWithSignal transition2 "Warm-up to normal mode"
    annotation (Placement(transformation(extent={{10,20},{30,40}})));
  Modelica.StateGraph.TransitionWithSignal transition3 "Normal to off mode"
    annotation (Placement(transformation(extent={{70,20},{90,40}})));
  Modelica.StateGraph.StepWithSignal warUp(nIn=2, nOut=2)
    "Plant is in warm-up mode"
    annotation (Placement(transformation(extent={{-20,40},{0,20}})));
protected
  Modelica.StateGraph.InitialStep off(nIn=2, nOut=2) "Off mode"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Modelica.StateGraph.TransitionWithSignal transition4 "Warm-up to off mode"
    annotation (Placement(transformation(extent={{-30,-50},{-50,-30}})));
  Modelica.StateGraph.Step nor(nIn=1, nOut=1) "Normal mode"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Modelica.StateGraph.Transition transition5(
    final condition=false,
    final waitTime=0)
    annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));
  Buildings.Controls.OBC.CDL.Logical.Not notRun "Plant not run"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  WarmUpLeaving warUpCtr(
    final timeDelayStart=per.timeDelayStart,
    final TEngNom=per.TEngNom,
    final PEleMax=per.PEleMax,
    final warmUpByTimeDelay=per.warmUpByTimeDelay) "Warm-up control sequence"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
equation
  if off.active then
    actMod = CHPs.BaseClasses.Types.Mode.Off;
  elseif warUp.active then
    actMod = CHPs.BaseClasses.Types.Mode.WarmUp;
  else
    actMod = CHPs.BaseClasses.Types.Mode.Normal;
  end if;
  connect(transition4.outPort, off.inPort[1]) annotation (Line(points={{-41.5,-40},
          {-90,-40},{-90,30.5},{-81,30.5}}, color={0,0,0}));
  connect(transition1.inPort, off.outPort[1]) annotation (Line(points={{-44,30},
          {-52,30},{-52,30.25},{-59.5,30.25}}, color={0,0,0}));
  connect(nor.inPort[1], transition2.outPort) annotation (Line(points={{39,30},
          {21.5,30}}, color={0,0,0}));
  connect(nor.outPort[1], transition3.inPort) annotation (Line(points={{60.5,30},
          {76,30}}, color={0,0,0}));
  connect(transition3.outPort, off.inPort[2]) annotation (Line(points={{81.5,30},
          {90,30},{90,50},{-90,50},{-90,29.5},{-81,29.5}}, color={0,0,0}));
  connect(transition5.inPort, off.outPort[2]) annotation (Line(points={{-44,-10},
          {-52,-10},{-52,29.75},{-59.5,29.75}}, color={0,0,0}));
  connect(runSig.y, transition1.condition) annotation (Line(points={{-69,-80},{
          -60,-80},{-60,10},{-40,10},{-40,18}}, color={255,0,255}));
  connect(runSig.y, notRun.u) annotation (Line(points={{-69,-80},{-22,-80}},
          color={255,0,255}));
  connect(notRun.y, transition3.condition) annotation (Line(points={{2,-80},
          {80,-80},{80,18}}, color={255,0,255}));
  connect(notRun.y, transition4.condition) annotation (Line(points={{2,-80},{20,
          -80},{20,-60},{-40,-60},{-40,-52}}, color={255,0,255}));
  connect(warUpCtr.y, transition2.condition) annotation (Line(points={{22,80},{
          30,80},{30,0},{20,0},{20,18}}, color={255,0,255}));
  connect(warUp.active, warUpCtr.actWarUp)
    annotation (Line(points={{-10,41},{-10,86},{-2,86}}, color={255,0,255}));
  connect(transition1.outPort, warUp.inPort[1]) annotation (Line(points={{-38.5,
          30},{-30,30},{-30,29.5},{-21,29.5}}, color={0,0,0}));
  connect(warUp.outPort[1], transition2.inPort) annotation (Line(points={{0.5,
          29.75},{8,29.75},{8,30},{16,30}}, color={0,0,0}));
  connect(warUp.outPort[2], transition4.inPort) annotation (Line(points={{0.5,
          30.25},{10,30.25},{10,-40},{-36,-40}}, color={0,0,0}));
  connect(transition5.outPort, warUp.inPort[2]) annotation (Line(points={{-38.5,
          -10},{-30,-10},{-30,30},{-21,30},{-21,30.5}}, color={0,0,0}));
annotation (
    experiment(StopTime=900, Tolerance=1e-6),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/WarmUpTimeDelay.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.WarmUpLeaving\">
Buildings.Fluid.CHPs.BaseClasses.WarmUpLeaving</a>. 
The example is for the warm-up mode with the static time delay
(e.g. CHPs with internal combustion engines).
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
end WarmUpTimeDelay;
