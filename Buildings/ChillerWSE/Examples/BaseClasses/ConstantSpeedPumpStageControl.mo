within Buildings.ChillerWSE.Examples.BaseClasses;
model ConstantSpeedPumpStageControl "Staging control for constant speed pumps"

  parameter Modelica.SIunits.Time tWai "Waiting time";
  parameter Modelica.SIunits.Power QEva_nominal=-1000*3.517*1000 "Nominal cooling capaciaty(Negative means cooling)";

  Modelica.Blocks.Interfaces.RealInput cooMod
    "Cooling mode - 0: free cooling mode; 1: partially mechanical cooling; 2: fully mechanical cooling"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput chiNumOn
    "The number of running chillers"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.StateGraph.Transition con1(
    enableTimer=true,
    waitTime=tWai,
    condition=cooMod >= 0)
    "Fire condition 1: free cooling to partially mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-72,34})));
  Modelica.StateGraph.StepWithSignal oneOn(nIn=2, nOut=2)
    "One chiller is commanded on" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-32,8})));
  Modelica.StateGraph.InitialStepWithSignal off(nIn=1) "Free cooling mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-32,58})));
  Modelica.StateGraph.StepWithSignal twoOn "Two chillers are commanded on"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-32,-78})));
  Modelica.StateGraph.Transition con2(
    enableTimer=true,
    waitTime=tWai,
    condition=cooMod < 1.5 or (cooMod >= 1.5 and chiNumOn > 1))
    "Fire condition 2: partially mechanical cooling to fully mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-72,-42})));
  Modelica.StateGraph.Transition con3(
    enableTimer=true,
    waitTime=tWai,
    condition=cooMod >= 1.5 and chiNumOn < 2)
    "Fire condition 3: fully mechanical cooling to partially mechanical cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-8,-40})));
  Modelica.StateGraph.Transition con4(
    enableTimer=true,
    waitTime=tWai,
    condition=cooMod < 0 or cooMod > 2)
    "Fire condition 4: partially mechanical cooling to free cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={18,20})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-80,72},{-60,92}})));
  Modelica.Blocks.Math.MultiSwitch swi(
    nu=3,
    expr={0,1,2},
    y_default=0)
    "Switch boolean signals to real signal"
    annotation (Placement(transformation(extent={{24,-6},{48,6}})));
  Modelica.Blocks.Interfaces.RealOutput y[2] "On/off signal - 0: off; 1: on"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table=[0,0,0; 1,1,0; 2,1,1])
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  connect(off.outPort[1], con1.inPort) annotation (Line(
      points={{-32,47.5},{-32,47.5},{-32,46},{-32,42},{-72,42},{-72,38}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con1.outPort, oneOn.inPort[1]) annotation (Line(
      points={{-72,32.5},{-72,26},{-32.5,26},{-32.5,19}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con2.inPort, oneOn.outPort[1]) annotation (Line(
      points={{-72,-38},{-72,-10},{-32.25,-10},{-32.25,-2.5}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con2.outPort, twoOn.inPort[1]) annotation (Line(
      points={{-72,-43.5},{-72,-43.5},{-72,-60},{-32,-60},{-32,-67}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(twoOn.outPort[1], con3.inPort) annotation (Line(
      points={{-32,-88.5},{-32,-98},{-8,-98},{-8,-44}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con4.outPort, off.inPort[1]) annotation (Line(
      points={{18,21.5},{18,21.5},{18,78},{-32,78},{-32,69}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con3.outPort, oneOn.inPort[2]) annotation (Line(
      points={{-8,-38.5},{-8,-38.5},{-8,26},{-31.5,26},{-31.5,19}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con4.inPort, oneOn.outPort[2]) annotation (Line(
      points={{18,16},{18,-10},{-31.75,-10},{-31.75,-2.5}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(swi.u[1], off.active) annotation (Line(
      points={{24,1.2},{24,0},{2,0},{2,58},{-21,58}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(oneOn.active, swi.u[2]) annotation (Line(
      points={{-21,8},{-21,8},{2,8},{2,0},{24,0}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(twoOn.active, swi.u[3]) annotation (Line(
      points={{-21,-78},{2,-78},{2,-1.2},{24,-1.2}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(swi.y, combiTable1Ds.u)
    annotation (Line(points={{48.6,0},{58,0}}, color={0,0,127}));
  connect(combiTable1Ds.y, y)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  annotation (Icon(graphics={
                  Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{132,116},{-124,168}},
          lineColor={0,0,255},
          textString="%name")}));
end ConstantSpeedPumpStageControl;
