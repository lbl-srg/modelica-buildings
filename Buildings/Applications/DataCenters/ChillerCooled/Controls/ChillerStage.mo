within Buildings.Applications.DataCenters.ChillerCooled.Controls;
model ChillerStage "Chiller staging control logic"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.SI.Time tWai "Waiting time";
  parameter Modelica.Units.SI.Power QEva_nominal
    "Nominal cooling capaciaty(Negative means cooling)";
  parameter Modelica.Units.SI.Power criPoiLoa=0.55*QEva_nominal
    "Critical point of cooling load for switching one chiller on or off";
  parameter Modelica.Units.SI.Power dQ=0.25*QEva_nominal
    "Deadband for critical point of cooling load";
  parameter Modelica.Units.SI.Temperature criPoiTem=279.15
    "Critical point of temperature for switching one chiller on or off";
  parameter Modelica.Units.SI.TemperatureDifference dT=1
    "Deadband width for critical point of switching temperature";

  Modelica.Blocks.Interfaces.IntegerInput cooMod
    "Cooling mode signal, integer value of
    Buildings.Applications.DataCenters.Types.CoolingMode"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput QTot
    "Total cooling load in the chillers, negative"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y[2]
    "On/off signal for the chillers - 0: off; 1: on"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput TCHWSup(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Temperature of leaving chilled water "
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));

  Modelica.StateGraph.Transition con1(
    enableTimer=true,
    waitTime=tWai,
    condition=cooMod > Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FreeCooling))
    "Fire condition 1: free cooling to partially mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,42})));
  Modelica.StateGraph.StepWithSignal oneOn(nIn=2, nOut=2)
    "One chiller is commanded on"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-50,10})));
  Modelica.StateGraph.InitialStep off(nIn=1, nOut=1)
                                             "Free cooling mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-50,70})));
  Modelica.StateGraph.StepWithSignal twoOn(nIn=1, nOut=1)
                                           "Two chillers are commanded on"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-50,-80})));
  Modelica.StateGraph.Transition con2(
    enableTimer=true,
    waitTime=tWai,
    condition=cooMod == Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FullMechanical) and
    (-QTot > -(criPoiLoa + dQ) or TCHWSup > criPoiTem + dT))
    "Fire condition 2: partially mechanical cooling to fully mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,-40})));
  Modelica.StateGraph.Transition con3(
    enableTimer=true,
    waitTime=tWai,
    condition=(-QTot < -(criPoiLoa - dQ) or TCHWSup < criPoiTem - dT))
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
        origin={-20,52})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(
    table=[0,0,0;
           1,1,0;
           2,1,1])
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
      points={{-50,59.5},{-50,46}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con1.outPort, oneOn.inPort[1])
    annotation (Line(
      points={{-50,40.5},{-50,26},{-50.5,26},{-50.5,21}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con2.inPort, oneOn.outPort[1])
    annotation (Line(
      points={{-50,-36},{-50,-10},{-50.25,-10},{-50.25,-0.5}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con2.outPort, twoOn.inPort[1])
    annotation (Line(
      points={{-50,-41.5},{-50,-69}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(twoOn.outPort[1], con3.inPort)
    annotation (Line(
      points={{-50,-90.5},{-50,-98},{-10,-98},{-10,-44}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con4.outPort, off.inPort[1])
    annotation (Line(
      points={{-20,53.5},{-20,90},{-50,90},{-50,81}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con3.outPort, oneOn.inPort[2])
    annotation (Line(
      points={{-10,-38.5},{-10,26},{-49.5,26},{-49.5,21}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con4.inPort, oneOn.outPort[2])
    annotation (Line(
      points={{-20,48},{-20,-10},{-49.75,-10},{-49.75,-0.5}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(combiTable1Ds.y, y)
    annotation (Line(points={{91,0},{110,0}}, color={0,0,127}));
  connect(twoOn.active, booToInt1.u)
    annotation (Line(points={{-39,-80},{18,-80}},         color={255,0,255}));
  connect(oneOn.active, booToInt.u) annotation (Line(points={{-39,10},{10,10},{
          10,-40},{18,-40}},
                          color={255,0,255}));
  connect(booToInt.y, addInt.u1) annotation (Line(points={{41,-40},{50,-40},{50,
          -54},{58,-54}}, color={255,127,0}));
  connect(booToInt1.y, addInt.u2) annotation (Line(points={{41,-80},{50,-80},{50,
          -66},{58,-66}}, color={255,127,0}));
  connect(addInt.y, intToRea.u) annotation (Line(points={{81,-60},{88,-60},{88,-20},
          {30,-20},{30,0},{38,0}}, color={255,127,0}));
  connect(intToRea.y, combiTable1Ds.u)
    annotation (Line(points={{61,0},{68,0},{68,0}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This is a chiller staging control that works as follows:
</p>
<ul>
<li>
The chillers are all off when cooling mode is Free Cooling.
</li>
<li>
One chiller is commanded on when cooling mode is not Free Cooling.
</li>
<li>
Two chillers are commanded on when cooling mode is not Free Cooling
and the cooling load addressed by each chiller is larger than
a critical value.
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
end ChillerStage;
