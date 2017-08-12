within Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Examples.BaseClasses;
model CoolingModeController
  "Controller for the DX cooling system with an airside economizer"

  parameter Modelica.SIunits.Time tWai "Waiting time, set to avoid frequent switching";

  Modelica.StateGraph.Transition con1(
    enableTimer=true,
    waitTime=tWai,
    condition=OATDewPoi > 273.15 + 10 and OAT > SATSet + 1.1)
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
    condition=OATDewPoi > 273.15 + 11.11 or OAT > RAT + 1.1)
    "Fire condition 2: partially mechanical cooling to fully mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,-42})));
  Modelica.StateGraph.Transition con3(
    enableTimer=true,
    waitTime=tWai,
    condition=OATDewPoi < 273.15 + 10 and OAT < RAT)
    "Fire condition 3: fully mechanical cooling to partially mechanical cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={24,-40})));
  Modelica.StateGraph.Transition con4(
    enableTimer=true,
    waitTime=tWai,
    condition=OATDewPoi < 273.15 + 8.89 or OAT < SATSet - 1.1)
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
  Modelica.Blocks.Interfaces.RealInput OAT(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Dry-bulb temperature of outdoor air"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}})));
  Modelica.Blocks.Interfaces.RealInput RAT(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Return air temperature"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput OATDewPoi(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Dew point temperature of outdoor air"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealInput SATSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Supply air temperature setpoint "
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
equation
  connect(freCoo.outPort[1],con1. inPort) annotation (Line(
      points={{0,47.5},{0,47.5},{0,46},{0,42},{-40,42},{-40,36}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con1.outPort,parMecCoo. inPort[1]) annotation (Line(
      points={{-40,30.5},{-40,26},{-0.5,26},{-0.5,19}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con2.inPort,parMecCoo. outPort[1]) annotation (Line(
      points={{-40,-38},{-40,-10},{-0.25,-10},{-0.25,-2.5}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con2.outPort,fulMecCoo. inPort[1]) annotation (Line(
      points={{-40,-43.5},{-40,-43.5},{-40,-60},{0,-60},{0,-67}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(fulMecCoo.outPort[1],con3. inPort) annotation (Line(
      points={{0,-88.5},{0,-98},{24,-98},{24,-44}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con4.outPort,freCoo. inPort[1]) annotation (Line(
      points={{50,21.5},{50,21.5},{50,78},{0,78},{0,69}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con3.outPort,parMecCoo. inPort[2]) annotation (Line(
      points={{24,-38.5},{24,-38.5},{24,26},{0.5,26},{0.5,19}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con4.inPort,parMecCoo. outPort[2]) annotation (Line(
      points={{50,16},{50,-10},{0.25,-10},{0.25,-2.5}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(swi.u[1],freCoo. active) annotation (Line(
      points={{64,1.2},{64,0},{34,0},{34,58},{11,58}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(parMecCoo.active,swi. u[2]) annotation (Line(
      points={{11,8},{11,8},{34,8},{34,0},{64,0}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(fulMecCoo.active,swi. u[3]) annotation (Line(
      points={{11,-78},{34,-78},{34,-1.2},{64,-1.2}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(swi.y,cooMod)
    annotation (Line(points={{88.6,0},{110,0}},         color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                  Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{128,114},{-128,166}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model implements a cooling mode controller for an air-cooled direct expansion (DX) cooling system 
with an airside economizer. 
</p>
<p>
There are three cooling modes for this system: free cooling (FC) mode, 
partially mechanical cooling (PMC) mode and fully mechanical cooling (FMC) mode. The detailed switching 
logic is shown in the following:
</p>
<p>
The airside economizer is enabled when:
</p>
<ul>
<li>
<i>T<sub>dp,OA</sub>&lt;50<sup>o</sup>F and T<sub>OA</sub>&lt;T<sub>RA</sub></i>
</li>
</ul>
<p>
The airside economizer is disabled when:
</p>
<ul>
<li>
<i>T<sub>dp,OA</sub>&gt;50<sup>o</sup>F + 2<sup>o</sup>F or T<sub>OA</sub>&gt;T<sub>RA</sub> + 2<sup>o</sup>F
</i>
</li>
</ul>
<p>
The DX coil is enabled when:
</p>
<ul>
<li>
<i>T<sub>dp,OA</sub>&gt;50<sup>o</sup>F and T<sub>OA</sub>&gt;T<sub>SA,set</sub></i>
</li>
</ul>
<p>
The DX coil is disabled when:
</p>
<ul>
<li>
<i>T<sub>dp,OA</sub>&lt;50<sup>o</sup>F - 2<sup>o</sup>F or T<sub>OA</sub>&gt;T<sub>SA,set</sub> - 2<sup>o</sup>F</i>
</li>
</ul>
<p>
where <i>dp</i> means dew point temperature, <i>set</i> means set point, 
<i>OA</i> means outdoor air, <i>RA</i> means return air, and <i>SA</i> means supply air.
</p>
</html>", revisions="<html>
<ul>
<li>
August 16, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingModeController;
