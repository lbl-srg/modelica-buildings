within Buildings.ChillerWSE.Examples.BaseClasses.Controls;
model CoolingModeControlNonIntegrated
  "Cooling mode controller in the chilled water system with a non-integrated  waterside economizer"
  parameter Modelica.SIunits.TemperatureDifference deaBan "Dead band width for switching waterside economizer off ";
  parameter Modelica.SIunits.Temperature wseTra "Temperature transition to free cooling mode";
  parameter Modelica.SIunits.Time tWai "Waiting time";

  Modelica.StateGraph.InitialStepWithSignal freCoo(nIn=1) "Free cooling mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={0,58})));
  Modelica.StateGraph.StepWithSignal fulMecCoo "Fully mechanical cooling mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={0,-30})));
  Modelica.StateGraph.Transition con1(
    enableTimer=true,
    waitTime=tWai,
    condition=TWetBul > wseTra or CHWST > CHWSTSet + deaBan)
    "Fire condition 1: free cooling to fully mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,20})));
  Modelica.Blocks.Math.MultiSwitch swi(
    nu=2,
    y_default=0,
    expr={0,2})
    "Switch boolean signals to real signal"
    annotation (Placement(transformation(extent={{64,-6},{88,6}})));
  Modelica.Blocks.Interfaces.RealOutput cooMod
    "Cooling mode signal (0: free cooling mode, 2: fully mechanical cooling)"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.StateGraph.Transition con2(
    enableTimer=true,
    waitTime=tWai,
    condition=TWetBul <= wseTra and numOnChi < 2)
    "Fire condition 2: fully mechanical cooling to free cooling"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={30,20})));
  Modelica.Blocks.Interfaces.RealInput numOnChi
    "Number of running chillers"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput TWetBul(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Wet bulb temperature of outdoor air"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Modelica.Blocks.Interfaces.RealInput CHWST(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Temperature of leaving chilled water "
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Interfaces.RealInput CHWSTSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Temperature setpoint of leaving chilled water "
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
equation
  connect(freCoo.outPort[1],con1. inPort)
    annotation (Line(
      points={{0,47.5},{0,47.5},{0,40},{-40,40},{-40,24}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con1.outPort,fulMecCoo. inPort[1])
    annotation (Line(
      points={{-40,18.5},{-40,0},{1.9984e-15,0},{1.9984e-15,-19}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(fulMecCoo.outPort[1], con2.inPort)
    annotation (Line(points={{0,-40.5},
          {0,-60},{30,-60},{30,16}}, color={0,0,0}));
  connect(con2.outPort, freCoo.inPort[1])
    annotation (Line(points={{30,21.5},{30,80},{0,80},{0,69}}, color={0,0,0}));
  connect(freCoo.active, swi.u[1])
    annotation (Line(points={{11,58},{54,58},{54,
          0.9},{64,0.9}}, color={255,0,255}));
  connect(fulMecCoo.active, swi.u[2])
    annotation (Line(points={{11,-30},{34,-30},
          {54,-30},{54,-0.9},{64,-0.9}}, color={255,0,255}));
  connect(swi.y, cooMod)
    annotation (Line(points={{88.6,0},{110,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,127}),
        Text(
          extent={{128,114},{-128,166}},
          lineColor={0,0,255},
          textString="%name")}),
      Diagram(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{128,114},{-128,166}},
          lineColor={0,0,255},
          textString="%name")}),
    Documentation(info="<html>
<p>Chilled water plant with a non-integrated waterside economizer (WSE) have two cooling modes: 
free cooling (FC) mode and fully mechanical cooling (FMC) mode. This model determines when to 
activate FC or FMC.
</p>
<p>
The FMC mode is activated when
</p>
<ul>
<li>
<i>T<sub>WetBulb</sub>&ge; T<sub>WetBulb,tran</sub></i>
</li>
<li>
<i><b>or</b> T<sub>CHWST</sub>&ge;T<sub>CHWSTSet</sub> + DeaBan </i>
</li>
</ul>
<p>The FC mode is activated when
</p>
<ul>
<li>
<i>T<sub>WetBulb</sub>&lt; T<sub>WetBulb,tran</sub></i>
</li>
<li>
<i><b>and</b> numOnChi&lt;2 </i>
</li>
</ul>
<p>
Where <i>T<sub>WetBulb</sub></i> is the wet bulb temperature of the outdoor air,
<i>T<sub>WetBulb,tran</sub></i> is the wet bulb temperature transition point 
for switching between FC and FMC,
<i>T<sub>CHWST</sub></i> is the chilled water supply temperature, <i>T<sub>CHWSTSet</sub></i> is
the chilled water supply temperature setpoint,and <i>numOnChi</i> is the number of running chillers.
</p>
</html>", revisions="<html>
<ul>
<li>
July 30, 2017, by Yangyang Fu:<br>
First implementation.
</li>
</ul>
</html>"));
end CoolingModeControlNonIntegrated;
