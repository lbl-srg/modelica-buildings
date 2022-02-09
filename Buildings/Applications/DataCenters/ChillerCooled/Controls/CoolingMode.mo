within Buildings.Applications.DataCenters.ChillerCooled.Controls;
model CoolingMode
  "Mode controller for integrated waterside economizer and chiller"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.SI.Time tWai "Waiting time";
  parameter Modelica.Units.SI.TemperatureDifference deaBan1
    "Dead band width 1 for switching chiller on ";
  parameter Modelica.Units.SI.TemperatureDifference deaBan2
    "Dead band width 2 for switching waterside economizer off";
  parameter Modelica.Units.SI.TemperatureDifference deaBan3
    "Dead band width 3 for switching waterside economizer on ";
  parameter Modelica.Units.SI.TemperatureDifference deaBan4
    "Dead band width 4 for switching chiller off";

  Modelica.Blocks.Interfaces.RealInput TCHWRetWSE(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Temperature of entering chilled water that flows to waterside economizer "
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput TCHWSupWSE(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Temperature of leaving chilled water that flows out from waterside economizer"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput TCHWSupSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Supply chilled water temperature setpoint "
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput TApp(
    final quantity="TemperatureDifference",
    final unit="K",
    displayUnit="degC") "Approach temperature in the cooling tower"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.IntegerOutput y
    "Cooling mode signal, integer value of Buildings.Applications.DataCenters.Types.CoolingMode"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.StateGraph.Transition con1(
    enableTimer=true,
    waitTime=tWai,
    condition=TCHWSupWSE > TCHWSupSet + deaBan1)
    "Fire condition 1: free cooling to partially mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,40})));
  Modelica.StateGraph.StepWithSignal parMecCoo(nIn=2, nOut=2)
    "Partial mechanical cooling mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-10,8})));
  Modelica.StateGraph.InitialStepWithSignal freCoo(nIn=1, nOut=1)
                                                          "Free cooling mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-10,70})));
  Modelica.StateGraph.StepWithSignal fulMecCoo(nIn=1, nOut=1)
                                               "Fully mechanical cooling mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-10,-80})));
  Modelica.StateGraph.Transition con2(
    enableTimer=true,
    waitTime=tWai,
    condition=TCHWRetWSE < TCHWSupWSE + deaBan2)
    "Fire condition 2: partially mechanical cooling to fully mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,-34})));
  Modelica.StateGraph.Transition con3(
    enableTimer=true,
    waitTime=tWai,
    condition=TCHWRetWSE > TWetBul + TApp + deaBan3)
    "Fire condition 3: fully mechanical cooling to partially mechanical cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={24,-40})));
  Modelica.StateGraph.Transition con4(
    enableTimer=true,
    waitTime=tWai,
    condition=TCHWSupWSE <= TCHWSupSet + deaBan4)
    "Fire condition 4: partially mechanical cooling to free cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={20,50})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Interfaces.RealInput TWetBul(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Wet bulb temperature of outdoor air"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.MathInteger.MultiSwitch swi(
    y_default=0,
    nu=3,
    expr={Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FreeCooling),
          Integer(Buildings.Applications.DataCenters.Types.CoolingModes.PartialMechanical),
          Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FullMechanical)})
    "Switch boolean signals to real signal"
    annotation (Placement(transformation(extent={{64,-6},{88,6}})));

equation
  connect(freCoo.outPort[1], con1.inPort)
    annotation (Line(
      points={{-10,59.5},{-10,44}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con1.outPort, parMecCoo.inPort[1])
    annotation (Line(
      points={{-10,38.5},{-10,26},{-10.5,26},{-10.5,19}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con2.inPort, parMecCoo.outPort[1])
    annotation (Line(
      points={{-10,-30},{-10,-10},{-10.25,-10},{-10.25,-2.5}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con2.outPort, fulMecCoo.inPort[1])
    annotation (Line(
      points={{-10,-35.5},{-10,-69}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(fulMecCoo.outPort[1], con3.inPort)
    annotation (Line(
      points={{-10,-90.5},{-10,-98},{24,-98},{24,-44}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con4.outPort, freCoo.inPort[1])
    annotation (Line(
      points={{20,51.5},{20,90},{-10,90},{-10,81}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con3.outPort, parMecCoo.inPort[2])
    annotation (Line(
      points={{24,-38.5},{24,26},{-9.5,26},{-9.5,19}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con4.inPort, parMecCoo.outPort[2])
    annotation (Line(
      points={{20,46},{20,-10},{-9.75,-10},{-9.75,-2.5}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(swi.y, y)
    annotation (Line(points={{88.6,0},{110,0}}, color={255,127,0}));
  connect(freCoo.active, swi.u[1])
    annotation (Line(points={{1,70},{40,70},{40,1.2},{64,1.2}},
                                  color={255,0,255}));
  connect(parMecCoo.active, swi.u[2])
    annotation (Line(points={{1,8},{38,8},{38,0},{64,0}},  color={255,0,255}));
  connect(fulMecCoo.active, swi.u[3])
    annotation (Line(points={{1,-80},{40,-80},{40,-1.2},{64,-1.2}},
                                         color={255,0,255}));
  annotation (    Documentation(info="<html>
<p>
Controller that outputs if the chilled water system is in Free Cooling (FC) mode,
Partially Mechanical Cooling (PMC) mode or Fully Mechanical Cooling (FMC) mode.
</p>
<p>The waterside economizer is enabled when </p>
<ol>
 <li>
    The waterside economizer has been disabled for at least 20 minutes, and
 </li>
 <li>
    <i>T<sub>CHWR</sub> &gt; T<sub>WetBul</sub> + T<sub>TowApp</sub> + deaBan1 </i>
 </li>
</ol>
<p>The waterside economizer is disabled when </p>
<ol>
  <li>
    The waterside economizer has been enabled for at least 20 minutes, and
  </li>
  <li>
    <i>T<sub>WSE_CHWST</sub> &gt; T<sub>WSE_CHWRT</sub> - deaBan2 </i>
  </li>
</ol>
<p>The chiller is enabled when </p>
<ol>
  <li>
    The chiller has been disabled for at leat 20 minutes, and
  </li>
  <li>
    <i>T<sub>WSE_CHWST</sub> &gt; T<sub>CHWSTSet</sub> + deaBan3 </i>
  </li>
</ol>
<p>The chiller is disabled when </p>
<ol>
  <li>
    The chiller has been enabled for at leat 20 minutes, and
  </li>
  <li>
    <i>T<sub>WSE_CHWST</sub> &le; T<sub>CHWSTSet</sub> + deaBan4 </i>
  </li>
</ol>
<p>
where <i>T<sub>WSE_CHWST</sub></i> is the chilled water supply temperature for the WSE,
<i>T<sub>WetBul</sub></i> is the wet bulb temperature,
<i>T<sub>TowApp</sub></i> is the cooling tower approach, <i>T<sub>WSE_CHWRT</sub></i>
is the chilled water return temperature for the WSE, and <i>T<sub>CHWSTSet</sub></i>
is the chilled water supply temperature setpoint for the system.
<i>deaBan 1-4</i> are deadbands for each switching point.
</p>
<h4>References</h4>
<ul>
  <li>
    Stein, Jeff. Waterside Economizing in Data Centers: Design and Control Considerations.
    ASHRAE Transactions 115.2 (2009).
  </li>
</ul>
</html>",        revisions="<html>
<ul>
<li>
July 24, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingMode;
