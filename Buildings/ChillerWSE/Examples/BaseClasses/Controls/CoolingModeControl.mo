within Buildings.ChillerWSE.Examples.BaseClasses.Controls;
model CoolingModeControl
  "Mode controller for integrated waterside economizer and chiller"

  parameter Modelica.SIunits.Time tWai "Waiting time";
  parameter Modelica.SIunits.TemperatureDifference deaBan1
    "Dead band width 1 for switching waterside economizer off ";
  parameter Modelica.SIunits.TemperatureDifference deaBan2
    "Dead band width 2 for switching waterside economizer on";
  parameter Modelica.SIunits.TemperatureDifference deaBan3
    "Dead band width 1 for switching waterside economizer off ";
  parameter Modelica.SIunits.TemperatureDifference deaBan4
    "Dead band width 2 for switching waterside economizer on";

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
    "Cooling mode signal, integer value of Buildings.Applications.DataCenters.Examples.BaseClasses.Types.CoolingMode"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.StateGraph.Transition con1(
    enableTimer=true,
    waitTime=tWai,
    condition=TCHWSupWSE > TCHWSupSet + deaBan3)
    "Fire condition 1: free cooling to partially mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,32})));
  Modelica.StateGraph.StepWithSignal parMecCoo(nIn=2, nOut=2)
    "Partial mechanical cooling mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={0,8})));
  Modelica.StateGraph.InitialStepWithSignal freCoo(nIn=1) "Free cooling mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={0,58})));
  Modelica.StateGraph.StepWithSignal fulMecCoo "Fully mechanical cooling mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={0,-78})));
  Modelica.StateGraph.Transition con2(
    enableTimer=true,
    waitTime=tWai,
    condition=TCHWSupWSE > TCHWRetWSE - deaBan2)
    "Fire condition 2: partially mechanical cooling to fully mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,-42})));
  Modelica.StateGraph.Transition con3(
    enableTimer=true,
    waitTime=tWai,
    condition=TCHWRetWSE > TWetBul + TApp + deaBan1)
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
        origin={50,20})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-48,72},{-28,92}})));
  Modelica.Blocks.Interfaces.RealInput TWetBul(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Wet bulb temperature of outdoor air"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.MathInteger.MultiSwitch swi(
    y_default=0,
    nu=3,
    expr={Integer(Buildings.Applications.DataCenters.Examples.BaseClasses.Types.CoolingModes.FreeCooling),
        Integer(Buildings.Applications.DataCenters.Examples.BaseClasses.Types.CoolingModes.PartialMechanical),
        Integer(Buildings.Applications.DataCenters.Examples.BaseClasses.Types.CoolingModes.FullMechanical)})
    "Switch boolean signals to real signal"
    annotation (Placement(transformation(extent={{64,-6},{88,6}})));


equation
  connect(freCoo.outPort[1], con1.inPort)
    annotation (Line(
      points={{0,47.5},{0,47.5},{0,46},{0,42},{-40,42},{-40,36}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con1.outPort, parMecCoo.inPort[1])
    annotation (Line(
      points={{-40,30.5},{-40,26},{-0.5,26},{-0.5,19}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con2.inPort, parMecCoo.outPort[1])
    annotation (Line(
      points={{-40,-38},{-40,-10},{-0.25,-10},{-0.25,-2.5}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con2.outPort, fulMecCoo.inPort[1])
    annotation (Line(
      points={{-40,-43.5},{-40,-43.5},{-40,-60},{0,-60},{0,-67}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(fulMecCoo.outPort[1], con3.inPort)
    annotation (Line(
      points={{0,-88.5},{0,-98},{24,-98},{24,-44}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con4.outPort, freCoo.inPort[1])
    annotation (Line(
      points={{50,21.5},{50,21.5},{50,78},{0,78},{0,69}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con3.outPort, parMecCoo.inPort[2])
    annotation (Line(
      points={{24,-38.5},{24,-38.5},{24,26},{0.5,26},{0.5,19}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con4.inPort, parMecCoo.outPort[2])
    annotation (Line(
      points={{50,16},{50,-10},{0.25,-10},{0.25,-2.5}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(swi.y, y)
    annotation (Line(points={{88.6,0},{110,0}}, color={255,127,0}));
  connect(freCoo.active, swi.u[1])
    annotation (Line(points={{11,58},{38,58},{40,
          58},{40,1.2},{64,1.2}}, color={255,0,255}));
  connect(parMecCoo.active, swi.u[2])
    annotation (Line(points={{11,8},{40,8},{40,0},{64,0}}, color={255,0,255}));
  connect(fulMecCoo.active, swi.u[3])
    annotation (Line(points={{11,-78},{26,-78},
          {40,-78},{40,-1.2},{64,-1.2}}, color={255,0,255}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(
        graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{128,114},{-128,166}},
          lineColor={0,0,255},
          textString="%name")}),
    Documentation(info="<html>
<p>This component decides if the chilled water system is in Free Cooling (FC) mode, 
Partially Mechanical Cooling (PMC) mode or Fully Mechanical Cooling (FMC) mode. 
</p>
<p>The waterside economizer is enabled when </p>
<ol>
<li>The waterside economizer has been disabled for at least 20 minutes, and</li>
<li><i>T<sub>CHWR</sub> &gt; T<sub>WetBul</sub> + T<sub>TowApp</sub> + deaBan1 </i></li>
</ol>
<p>The waterside economizer is disabled when </p>
<ol>
<li>The waterside economizer has been enabled for at least 20 minutes, and</li>
<li><i>T<sub>WSE_CHWST</sub> &gt; T<sub>WSE_CHWRT</sub> - deaBan2</i></li>
</ol>
<p>The chiller is enabled when </p>
<ol>
<li>The chiller has been disabled for at leat 20 minutes, and </li>
<li><i>T<sub>WSE_CHWST</sub> &gt; T<sub>CHWSTSet</sub> + deaBan3 </i></li>
</ol>
<p>The chiller is disabled when </p>
<ol>
<li>The chiller has been enabled for at leat 20 minutes, and </li>
<li><i>T<sub>WSE_CHWST</sub> &le; T<sub>CHWSTSet</sub> + deaBan4 </i></li>
</ol>
<p>where <i>T<sub>WSE_CHWST</i></sub> is the chilled water supply temperature for the WSE, 
<i>T<sub>WetBul</i></sub> is the wet bulb temperature, 
<i>T<sub>TowApp</i></sub> is the cooling tower approach, <i>T<sub>WSE_CHWRT</i></sub> 
is the chilled water return temperature for the WSE, and <i>T<sub>CHWSTSet</i></sub> 
is the chilled water supply temperature setpoint for the system.
<i>deaBan 1-4</i> are deadband width for each switching point. </p>
<h4>References</h4>
<ul>
<li>Stein, Jeff. Waterside Economizing in Data Centers: Design and Control Considerations. ASHRAE Transactions 115.2 (2009). </li>
</ul>
</html>
",        revisions="<html>
<ul>
<li>
July 24, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
<ul>
</html>"));
end CoolingModeControl;
