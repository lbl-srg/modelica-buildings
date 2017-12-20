within Buildings.Applications.DataCenters.ChillerCooled.Controls;
model VariableSpeedPumpStage "Staging control for variable speed pumps"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.SIunits.Time tWai "Waiting time";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate of the identical variable-speed pumps";
  parameter Real minSpe(unit="1",min=0,max=1) = 0.05
    "Minimum speed ratio required by variable speed pumps";
  parameter Modelica.SIunits.MassFlowRate criPoiFlo = 0.7*m_flow_nominal
    "Critcal point of flowrate for switch pump on or off";
  parameter Modelica.SIunits.MassFlowRate deaBanFlo = 0.1*m_flow_nominal
    "Deadband for critical point of flowrate";
  parameter Real criPoiSpe = 0.5
    "Critical point of speed signal for switching on or off";
  parameter Real deaBanSpe = 0.3
    "Deadband for critical point of speed signal";

  Modelica.Blocks.Interfaces.RealInput masFloPum
    "Total mass flowrate in the variable speed pumps"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput speSig
    "Speed signal"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealOutput y[2]
    "On/off signal - 0: off; 1: on"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));


  Modelica.StateGraph.Transition con1(
    enableTimer=true,
    waitTime=tWai,
    condition=speSig > minSpe)
    "Fire condition 1: free cooling to partially mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,40})));
  Modelica.StateGraph.StepWithSignal oneOn(nIn=2, nOut=2)
    "One chiller is commanded on"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-50,10})));
  Modelica.StateGraph.InitialStep off(nIn=1)
    "Free cooling mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-50,70})));
  Modelica.StateGraph.StepWithSignal twoOn
    "Two chillers are commanded on"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-50,-70})));
  Modelica.StateGraph.Transition con2(
    enableTimer=true,
    waitTime=tWai,
    condition=speSig > criPoiSpe + deaBanSpe and
      masFloPum > criPoiFlo + deaBanFlo)
    "Fire condition 2: partially mechanical cooling to fully mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,-30})));
  Modelica.StateGraph.Transition con3(
    enableTimer=true,
    waitTime=tWai,
    condition=speSig < criPoiSpe - deaBanSpe
      or masFloPum < criPoiFlo - deaBanFlo)
    "Fire condition 3: fully mechanical cooling to partially mechanical cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-10,-40})));
  Modelica.StateGraph.Transition con4(
    enableTimer=true,
    waitTime=tWai,
    condition=speSig <= minSpe)
    "Fire condition 4: partially mechanical cooling to free cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-22,52})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(
    table=[0,0,0;
           1,1,0;
           2,1,1])
    "Determine which pump should be on - rotation control is not considered here"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt(
    final integerTrue=1,
    final integerFalse=0)
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1(
    final integerFalse=0, final integerTrue=2)
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt
    annotation (Placement(transformation(extent={{60,-56},{80,-36}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

equation
  connect(off.outPort[1], con1.inPort)
    annotation (Line(
      points={{-50,59.5},{-50,44}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con1.outPort, oneOn.inPort[1])
    annotation (Line(
      points={{-50,38.5},{-50,26},{-50.5,26},{-50.5,21}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con2.inPort, oneOn.outPort[1])
    annotation (Line(
      points={{-50,-26},{-50,-10},{-50.25,-10},{-50.25,-0.5}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con2.outPort, twoOn.inPort[1])
    annotation (Line(
      points={{-50,-31.5},{-50,-59}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(twoOn.outPort[1], con3.inPort)
    annotation (Line(
      points={{-50,-80.5},{-50,-92},{-10,-92},{-10,-44}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con4.outPort, off.inPort[1])
    annotation (Line(
      points={{-22,53.5},{-22,88},{-50,88},{-50,81}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con3.outPort, oneOn.inPort[2])
    annotation (Line(
      points={{-10,-38.5},{-10,26},{-49.5,26},{-49.5,21}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con4.inPort, oneOn.outPort[2])
    annotation (Line(
      points={{-22,48},{-22,-10},{-49.75,-10},{-49.75,-0.5}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(combiTable1Ds.y, y)
    annotation (Line(points={{91,0},{110,0}}, color={0,0,127}));
  connect(booToInt.u, oneOn.active) annotation (Line(points={{18,-40},{10,-40},
          {10,10},{-39,10}}, color={255,0,255}));
  connect(twoOn.active, booToInt1.u)
    annotation (Line(points={{-39,-70},{18,-70}},          color={255,0,255}));
  connect(booToInt.y, addInt.u1) annotation (Line(points={{41,-40},{58,-40}},
                          color={255,127,0}));
  connect(booToInt1.y, addInt.u2) annotation (Line(points={{41,-70},{48,-70},{
          48,-52},{58,-52}}, color={255,127,0}));
  connect(addInt.y, intToRea.u) annotation (Line(points={{81,-46},{90,-46},{90,
          -20},{30,-20},{30,0},{38,0}}, color={255,127,0}));
  connect(intToRea.y, combiTable1Ds.u)
    annotation (Line(points={{61,0},{68,0},{68,0}}, color={0,0,127}));
  annotation (                   Documentation(info="<html>
<p>This model implements a simple staging control logic for variable speed pumps.
</p>
<ul>
<li>
When the mass flowrate in each pump is greater than a threshold,
and the speed signal is greater
than a threshold, then activate one more pump;
</li>
<li>
When the mass flowrate in each pump is less than a threshold,
or the speed signal is smaller than a threshold,
then deactivate one more pump.
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
July 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end VariableSpeedPumpStage;
