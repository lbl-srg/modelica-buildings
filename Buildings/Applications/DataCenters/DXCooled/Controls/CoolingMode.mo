within Buildings.Applications.DataCenters.DXCooled.Controls;
model CoolingMode
  "Controller for the DX cooling system with an airside economizer"

  parameter Modelica.SIunits.Time tWai "Waiting time, set to avoid frequent switching";
  parameter Modelica.SIunits.TemperatureDifference dT(min=0.1) = 1.1 "Deadband";

  Modelica.Blocks.Interfaces.RealInput TOutDryBul(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Dry-bulb temperature of outdoor air"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput TRet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Return air temperature"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealInput TSupSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Supply air temperature setpoint "
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));

  Modelica.Blocks.Interfaces.IntegerOutput y
    "Cooling mode signal, integer value of Buildings.Applications.DataCenters.Examples.BaseClasses.Types.CoolingMode"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.StateGraph.Transition con1(
    enableTimer=true,
    waitTime=tWai,
    condition=TOutDryBul > TSupSet + dT)
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
    condition=TOutDryBul > TRet + dT)
    "Fire condition 2: partially mechanical cooling to fully mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,-42})));
  Modelica.StateGraph.Transition con3(
    enableTimer=true,
    waitTime=tWai,
    condition=TOutDryBul < TRet - dT)
    "Fire condition 3: fully mechanical cooling to partially mechanical cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={24,-40})));
  Modelica.StateGraph.Transition con4(
    enableTimer=true,
    waitTime=tWai,
    condition=TOutDryBul < TSupSet - dT)
    "Fire condition 4: partially mechanical cooling to free cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={50,20})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.MathInteger.MultiSwitch swi(
    nu=3,
    y_default=0,
    expr={Integer(Types.CoolingModes.FreeCooling),
          Integer(Types.CoolingModes.PartialMechanical),
          Integer(Types.CoolingModes.FullMechanical)})
    "Switch boolean signals to real signal"
    annotation (Placement(transformation(extent={{64,-6},{88,6}})));
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
  connect(y, swi.y)
    annotation (Line(points={{110,0},{88.6,0}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
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
<p>
This model implements a cooling mode controller for an air-cooled direct expansion (DX) cooling system
with an airside economizer. This controller is based on a simplified differential dry-bulb temperature
control strategy, as described in ASHRAE G36.
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
<i>T<sub>out</sub>&lt;T<sub>ret</sub></i>
</li>
</ul>
<p>
The airside economizer is disabled when:
</p>
<ul>
<li>
<i>T<sub>out</sub>&gt;T<sub>ret</sub></i>
</li>
</ul>
<p>
The DX coil is enabled when:
</p>
<ul>
<li>
<i>T<sub>out</sub>&gt;T<sub>sup,set</sub></i>
</li>
</ul>
<p>
The DX coil is disabled when:
</p>
<ul>
<li>
<i>T<sub>out</sub>&gt;T<sub>sup,set</sub></i>
</li>
</ul>
<p>
where
<i>T<sub>swi</sub></i> is the switching temperature,
subscript <i>set</i> means set point,
<i>out</i> means outdoor air, <i>ret</i> means return air,
and <i>sup</i> means supply air. A deadband <i>&delta;T</i> can be added to the above logics to
avoid frequent switching.
</p>
</html>", revisions="<html>
<ul>
<li>
August 16, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingMode;
