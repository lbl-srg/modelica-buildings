within Buildings.ChillerWSE.Examples.BaseClasses;
model CoolingModeControl
  "Mode controller for integrated waterside economizer and chiller"

parameter Modelica.SIunits.Time tWai "Waiting time";

parameter Modelica.SIunits.TemperatureDifference deaBan1 "Dead band width 1 for switching waterside economizer off ";

parameter Modelica.SIunits.TemperatureDifference deaBan2 "Dead band width 2 for switching waterside economizer on";

  Modelica.StateGraph.Transition con1(
    enableTimer=true,
    waitTime=tWai,
    condition=wseCHWST > CHWSTSet)
    "Fire condition 1: free cooling to partially mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,32})));
  Modelica.StateGraph.StepWithSignal parMecCoo(nIn=2, nOut=2)
    "Partial mechanical cooling mode" annotation (Placement(transformation(
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
    condition=wseCHWRT < wseCHWST + deaBan1)
    "Fire condition 2: partially mechanical cooling to fully mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,-42})));
  Modelica.StateGraph.Transition con3(
    enableTimer=true,
    waitTime=tWai,
    condition=wseCHWRT > TWetBul + towTApp + deaBan2)
    "Fire condition 3: fully mechanical cooling to partially mechanical cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={24,-40})));
  Modelica.StateGraph.Transition con4(
    enableTimer=true,
    waitTime=tWai,
    condition=wseCHWST <= CHWSTSet)
    "Fire condition 4: partially mechanical cooling to free cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={50,20})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-48,72},{-28,92}})));
  Modelica.Blocks.Math.MultiSwitch swi(
    nu=3,
    expr={0,1,2},
    y_default=0)
    "Switch boolean signals to real signal"
    annotation (Placement(transformation(extent={{64,-6},{88,6}})));
  Modelica.Blocks.Interfaces.RealOutput cooMod
    "Cooling mode signal (0: free cooling mode, 1: partially mechanical cooling, 2: fully mechanical cooling)"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput TWetBul(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Wet bulb temperature of outdoor air"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput wseCHWRT(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Temperature of entering chilled water that flows to waterside economizer "
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput wseCHWST(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Temperature of leaving chilled water that flows out from waterside economizer"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput CHWSTSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Supply chilled water temperature setpoint "
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput towTApp(
    final quantity="TemperatureDifference",
    final unit="K",
    displayUnit="degC") "Approach temperature in the cooling tower"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
equation
  connect(freCoo.outPort[1], con1.inPort) annotation (Line(
      points={{0,47.5},{0,47.5},{0,46},{0,42},{-40,42},{-40,36}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con1.outPort, parMecCoo.inPort[1]) annotation (Line(
      points={{-40,30.5},{-40,26},{-0.5,26},{-0.5,19}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con2.inPort, parMecCoo.outPort[1]) annotation (Line(
      points={{-40,-38},{-40,-10},{-0.25,-10},{-0.25,-2.5}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con2.outPort, fulMecCoo.inPort[1]) annotation (Line(
      points={{-40,-43.5},{-40,-43.5},{-40,-60},{0,-60},{0,-67}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(fulMecCoo.outPort[1], con3.inPort) annotation (Line(
      points={{0,-88.5},{0,-98},{24,-98},{24,-44}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con4.outPort, freCoo.inPort[1]) annotation (Line(
      points={{50,21.5},{50,21.5},{50,78},{0,78},{0,69}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con3.outPort, parMecCoo.inPort[2]) annotation (Line(
      points={{24,-38.5},{24,-38.5},{24,26},{0.5,26},{0.5,19}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con4.inPort, parMecCoo.outPort[2]) annotation (Line(
      points={{50,16},{50,-10},{0.25,-10},{0.25,-2.5}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(swi.u[1], freCoo.active) annotation (Line(
      points={{64,1.2},{64,0},{34,0},{34,58},{11,58}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(parMecCoo.active, swi.u[2]) annotation (Line(
      points={{11,8},{11,8},{34,8},{34,0},{64,0}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(fulMecCoo.active, swi.u[3]) annotation (Line(
      points={{11,-78},{34,-78},{34,-1.2},{64,-1.2}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(swi.y, cooMod)
    annotation (Line(points={{88.6,0},{110,0}},         color={0,0,127}));
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
The waterside economizer is enabled when 
</p>
<ol>
<li>The waterside economizer has been disabled for at least 20 minutes, and</li>
<li><i>
        T<sub>WSE_CHWST</sub> &GT; T<sub>WetBul</sub> + T<sub>TowApp</sub> + DeaBan1 
</i></li>
</ol>
<p>The waterside economizer is disabled when </p>
<ol>
<li>The waterside economizer has been enabled for at least 20 minutes, and</li>
<li><i>
  T<sub>WSE_CHWRT</sub> &LT; T<sub>WSE_CHWST</sub> + DeaBan2 
</i></li>
</ol>
<p>The chiller is enabled when </p>
<ol>
<li>The chiller has been disabled for at leat 20 minutes, and </li>
<li><i>
  T<sub>WSE_CHWST</sub> &GT; T<sub>CHWSTSet</sub> 
</i></li>
</ol>
<p>The chiller is disabled when </p>
<ol>
<li>The chiller has been enabled for at leat 20 minutes, and </li>
<li><i>
  T<sub>WSE_CHWST</sub> &le; T<sub>CHWSTSet</sub> 
</i></li>
</ol>
<p>where <i>T<sub>WSE_CHWST</i></sub> is the chilled water supply temperature for the WSE, 
<i>T<sub>WetBul</i></sub> is the wet bulb temperature, 
<i>T<sub>TowApp</i></sub> is the cooling tower approach, 
<i>T<sub>WSE_CHWRT</i></sub> is the chilled water return temperature for the WSE, and 
<i>T<sub>CHWSTSet</i></sub> is the chilled water supply temperature setpoint for the system. </p>
<h4>References</h4>
<ul>
<li>
Taylor, S. T. (2014). How to design & control waterside economizers. ASHRAE Journal, 56(6), 30-36.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
July 24, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
<ul>
</html>"));
end CoolingModeControl;
