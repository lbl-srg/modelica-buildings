within Buildings.Applications.DataCenters.ChillerCooled.Controls;
model ConstantSpeedPumpStage "Staging control for constant speed pumps"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.SI.Time tWai "Waiting time";

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
     cooMod == Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FreeCooling)
       or
     cooMod == Integer(Buildings.Applications.DataCenters.Types.CoolingModes.PartialMechanical)
       or
     cooMod == Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FullMechanical))
    "Fire condition 1: free cooling to partially mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,40})));
  Modelica.StateGraph.StepWithSignal oneOn(nIn=2, nOut=2)
    "One chiller is commanded on" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-40,10})));
  Modelica.StateGraph.InitialStep off(nIn=1, nOut=1)
                                             "Free cooling mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-40,70})));
  Modelica.StateGraph.StepWithSignal twoOn(nIn=1, nOut=1)
                                           "Two chillers are commanded on"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-40,-80})));
  Modelica.StateGraph.Transition con2(
    enableTimer=true,
    waitTime=tWai,
    condition=
      cooMod == Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FreeCooling)
        or
      cooMod == Integer(Buildings.Applications.DataCenters.Types.CoolingModes.PartialMechanical)
        or
      (cooMod == Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FullMechanical) and numOnChi > 1))
    "Fire condition 2: partially mechanical cooling to fully mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,-40})));
  Modelica.StateGraph.Transition con3(
    enableTimer=true,
    waitTime=tWai,
    condition=cooMod == Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FullMechanical)
    and numOnChi < 2)
    "Fire condition 3: fully mechanical cooling to partially mechanical cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-10,-40})));
  Modelica.StateGraph.Transition con4(
    enableTimer=true,
    waitTime=tWai,
    condition=cooMod == Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FreeCooling))
    "Fire condition 4: partially mechanical cooling to free cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-8,70})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table=[0,0,0; 1,1,0; 2,1,1])
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt(
    final integerTrue=1,
    final integerFalse=0)
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1(
    final integerFalse=0, final integerTrue=2)
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

equation
  connect(off.outPort[1], con1.inPort)
    annotation (Line(
      points={{-40,59.5},{-40,44}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con1.outPort, oneOn.inPort[1])
    annotation (Line(
      points={{-40,38.5},{-40,26},{-40.5,26},{-40.5,21}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con2.inPort, oneOn.outPort[1])
    annotation (Line(
      points={{-40,-36},{-40,-10},{-40.25,-10},{-40.25,-0.5}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con2.outPort, twoOn.inPort[1])
    annotation (Line(
      points={{-40,-41.5},{-40,-69}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(twoOn.outPort[1], con3.inPort)
    annotation (Line(
      points={{-40,-90.5},{-40,-98},{-10,-98},{-10,-44}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con4.outPort, off.inPort[1])
    annotation (Line(
      points={{-8,71.5},{-8,94},{-40,94},{-40,81}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con3.outPort, oneOn.inPort[2])
    annotation (Line(
      points={{-10,-38.5},{-10,26},{-39.5,26},{-39.5,21}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con4.inPort, oneOn.outPort[2])
    annotation (Line(
      points={{-8,66},{-8,-10},{-39.75,-10},{-39.75,-0.5}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(combiTable1Ds.y, y)
    annotation (Line(points={{91,0},{91,0},{110,0}},
                                              color={0,0,127}));
  connect(oneOn.active, booToInt.u) annotation (Line(points={{-29,10},{12,10},{
          12,-40},{18,-40}},         color={255,0,255}));
  connect(twoOn.active, booToInt1.u)
    annotation (Line(points={{-29,-80},{18,-80}},          color={255,0,255}));
  connect(booToInt.y, addInt.u1) annotation (Line(points={{41,-40},{48,-40},{48,
          -54},{58,-54}}, color={255,127,0}));
  connect(booToInt1.y, addInt.u2) annotation (Line(points={{41,-80},{48,-80},{
          48,-66},{58,-66}}, color={255,127,0}));
  connect(intToRea.y, combiTable1Ds.u)
    annotation (Line(points={{61,0},{68,0}}, color={0,0,127}));
  connect(addInt.y, intToRea.u) annotation (Line(points={{81,-60},{88,-60},{88,
          -20},{30,-20},{30,0},{38,0}}, color={255,127,0}));
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
September 11, 2017, by Michael Wetter:<br/>
Revised switch that selects the operation mode for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/921\">issue 921</a>
</li>
<li>
September 2, 2017, by Michael Wetter:<br/>
Changed implementation to use
<a href=\"modelica://Buildings.Applications.DataCenters.Types.CoolingModes\">
Buildings.Applications.DataCenters.Types.CoolingModes</a>.
</li>
<li>
July 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConstantSpeedPumpStage;
