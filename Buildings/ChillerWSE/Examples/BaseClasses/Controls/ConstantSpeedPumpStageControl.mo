within Buildings.ChillerWSE.Examples.BaseClasses.Controls;
model ConstantSpeedPumpStageControl "Staging control for constant speed pumps"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.SIunits.Time tWai "Waiting time";

  Modelica.Blocks.Interfaces.IntegerInput cooMod
    "Cooling mode - 0:off,  1: free cooling mode; 2: partially mechanical cooling; 3: fully mechanical cooling"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Modelica.Blocks.Interfaces.IntegerInput numOnChi
    "The number of running chillers"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealOutput y[2] "On/off signal - 0: off; 1: on"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.StateGraph.Transition con1(
    enableTimer=true,
    waitTime=tWai,
    condition=
     cooMod == Integer(Buildings.Applications.DataCenters.Examples.BaseClasses.Types.CoolingModes.PartialMechanical)
       or
     cooMod == Integer(Buildings.Applications.DataCenters.Examples.BaseClasses.Types.CoolingModes.FullMechanical))
    "Fire condition 1: free cooling to partially mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,34})));
  Modelica.StateGraph.StepWithSignal oneOn(nIn=2, nOut=2)
    "One chiller is commanded on" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-30,10})));
  Modelica.StateGraph.InitialStepWithSignal off(nIn=1) "Free cooling mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-30,60})));
  Modelica.StateGraph.StepWithSignal twoOn "Two chillers are commanded on"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-30,-80})));
  Modelica.StateGraph.Transition con2(
    enableTimer=true,
    waitTime=tWai,
    condition=
      cooMod == Integer(Buildings.Applications.DataCenters.Examples.BaseClasses.Types.CoolingModes.FreeCooling)
        or
      cooMod == Integer(Buildings.Applications.DataCenters.Examples.BaseClasses.Types.CoolingModes.PartialMechanical)
        or
      (cooMod == Integer(Buildings.Applications.DataCenters.Examples.BaseClasses.Types.CoolingModes.FullMechanical) and numOnChi > 1))
    "Fire condition 2: partially mechanical cooling to fully mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,-40})));
  Modelica.StateGraph.Transition con3(
    enableTimer=true,
    waitTime=tWai,
    condition=cooMod == Integer(Buildings.Applications.DataCenters.Examples.BaseClasses.Types.CoolingModes.FullMechanical)
    and numOnChi < 2)
    "Fire condition 3: fully mechanical cooling to partially mechanical cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-10,-40})));
  Modelica.StateGraph.Transition con4(
    enableTimer=true,
    waitTime=tWai,
    condition=cooMod == Integer(Buildings.Applications.DataCenters.Examples.BaseClasses.Types.CoolingModes.FreeCooling))
    "Fire condition 4: partially mechanical cooling to free cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={18,70})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-80,72},{-60,92}})));
  Modelica.Blocks.Math.MultiSwitch swi(
    nu=3,
    expr={0,1,2},
    y_default=0)
    "Switch boolean signals to real signal"
    annotation (Placement(transformation(extent={{24,-6},{48,6}})));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table=[0,0,0; 1,1,0; 2,1,1])
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  connect(off.outPort[1], con1.inPort)
    annotation (Line(
      points={{-30,49.5},{-30,49.5},{-30,46},{-30,42},{-70,42},{-70,38}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con1.outPort, oneOn.inPort[1])
    annotation (Line(
      points={{-70,32.5},{-70,26},{-30.5,26},{-30.5,21}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con2.inPort, oneOn.outPort[1])
    annotation (Line(
      points={{-70,-36},{-70,-10},{-30.25,-10},{-30.25,-0.5}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con2.outPort, twoOn.inPort[1])
    annotation (Line(
      points={{-70,-41.5},{-70,-41.5},{-70,-60},{-30,-60},{-30,-69}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(twoOn.outPort[1], con3.inPort)
    annotation (Line(
      points={{-30,-90.5},{-30,-98},{-10,-98},{-10,-44}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con4.outPort, off.inPort[1])
    annotation (Line(
      points={{18,71.5},{18,71.5},{18,78},{-30,78},{-30,71}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con3.outPort, oneOn.inPort[2])
    annotation (Line(
      points={{-10,-38.5},{-10,-38.5},{-10,26},{-29.5,26},{-29.5,21}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con4.inPort, oneOn.outPort[2])
    annotation (Line(
      points={{18,66},{18,-10},{-29.75,-10},{-29.75,-0.5}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(swi.u[1], off.active)
    annotation (Line(
      points={{24,1.2},{24,0},{20,0},{20,60},{-19,60}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(oneOn.active, swi.u[2])
    annotation (Line(
      points={{-19,10},{-19,10},{14,10},{14,0},{24,0}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(twoOn.active, swi.u[3])
    annotation (Line(
      points={{-19,-80},{20,-80},{20,-1.2},{24,-1.2}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(swi.y, combiTable1Ds.u)
    annotation (Line(points={{48.6,0},{58,0}}, color={0,0,127}));
  connect(combiTable1Ds.y, y)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  annotation (                   Documentation(info="<html>
<p>
This model describes a simple staging control for two constant-speed pumps in
a chilled water plant with two chillers and a waterside economizer (WSE). The staging sequence
is shown as below.
</p>
<ul>
<li>
When WSE is enabled, all the constant speed pumps are commanded on.
</li>
<li>
When fully mechanical cooling (FMC) mode is enabled, the number of running constant speed pumps
equals to the number of running chillers.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 2, 2017, by Michael Wetter:<br/>
Changed implementation to use
<a href=\"modelica://Buildings.Applications.DataCenters.Examples.BaseClasses.Types.CoolingModes\">
Buildings.Applications.DataCenters.Examples.BaseClasses.Types.CoolingModes</a>.
</li>
<li>
July 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConstantSpeedPumpStageControl;
