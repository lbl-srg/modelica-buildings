within Buildings.Applications.DataCenters.ChillerCooled.Controls;
model CoolingModeNonIntegrated
  "Cooling mode controller in the chilled water system with a non-integrated  waterside economizer"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.SI.TemperatureDifference deaBan
    "Dead band width for switching waterside economizer off ";
  parameter Modelica.Units.SI.Temperature TSwi
    "Temperature transition to free cooling mode";
  parameter Modelica.Units.SI.Time tWai "Waiting time";

  Modelica.Blocks.Interfaces.IntegerInput numOnChi
    "Number of running chillers"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput TWetBul(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Wet bulb temperature of outdoor air"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput TCHWSup(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Temperature of leaving chilled water "
    annotation (Placement(transformation(extent={{-140,-58},{-100,-18}})));
  Modelica.Blocks.Interfaces.RealInput TCHWSupSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Temperature setpoint of leaving chilled water "
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.IntegerOutput y
    "Cooling mode signal (1: free cooling mode, 3: fully mechanical cooling)"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.StateGraph.InitialStepWithSignal freCoo(nIn=1, nOut=1)
    "Free cooling mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-20,58})));
  Modelica.StateGraph.StepWithSignal fulMecCoo(nIn=1, nOut=1)
    "Fully mechanical cooling mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-20,-30})));
  Modelica.StateGraph.Transition con1(
    enableTimer=true,
    waitTime=tWai,
    condition=TWetBul > TSwi + deaBan or TCHWSup > TCHWSupSet + deaBan)
    "Fire condition 1: free cooling to fully mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,20})));
  Modelica.Blocks.MathInteger.MultiSwitch swi(
    nu=2,
    y_default=0,
    expr={Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FreeCooling),
        Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FullMechanical)})
    "Switch boolean signals to real signal"
    annotation (Placement(transformation(extent={{64,-6},{88,6}})));
  Modelica.StateGraph.Transition con2(
    enableTimer=true,
    waitTime=tWai,
    condition=TWetBul <= TSwi - deaBan and numOnChi == 1)
    "Fire condition 2: fully mechanical cooling to free cooling"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={30,20})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
equation
  connect(freCoo.outPort[1],con1. inPort)
    annotation (Line(
      points={{-20,47.5},{-20,47.5},{-20,38},{-20,38},{-20,24}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con1.outPort,fulMecCoo. inPort[1])
    annotation (Line(
      points={{-20,18.5},{-20,18.5},{-20,-19}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(fulMecCoo.outPort[1], con2.inPort)
    annotation (Line(points={{-20,-40.5},{-20,-60},{30,-60},{30,16}},
                                     color={0,0,0}));
  connect(con2.outPort, freCoo.inPort[1])
    annotation (Line(points={{30,21.5},{30,80},{-20,80},{-20,69}},
                                                               color={0,0,0}));
  connect(freCoo.active, swi.u[1])
    annotation (Line(points={{-9,58},{54,58},{54,0.9},{64,0.9}},
                          color={255,0,255}));
  connect(fulMecCoo.active, swi.u[2])
    annotation (Line(points={{-9,-30},{-9,-30},{54,-30},{54,-0.9},{64,-0.9}},
                                         color={255,0,255}));
  connect(swi.y, y)
    annotation (Line(points={{88.6,0},{110,0}}, color={0,0,127}));
  annotation (      Diagram(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{128,114},{-128,166}},
          textColor={0,0,255},
          textString="%name")}),
    Documentation(info="<html>
<p>Chilled water plant with a non-integrated waterside economizer (WSE) have two cooling modes:
free cooling (FC) mode and fully mechanical cooling (FMC) mode. This model determines when to
activate FC or FMC for a chilled water system with 2 chillers and 1 waterside economizer.
</p>
<p>
The FMC mode is activated when
</p>
<ul>
<li>
<i>T<sub>WetBulb</sub>&ge; T<sub>WetBulb,tran</sub></i>, or
</li>
<li>
<i>T<sub>CHWST</sub>&ge;T<sub>CHWSTSet</sub> + deaBan,</i>
</li>
</ul>
<p>and the FC mode is activated when
</p>
<ul>
<li>
<i>T<sub>WetBulb</sub>&lt; T<sub>WetBulb,tran</sub></i>, and
</li>
<li>
<i>numOnChi&lt;2,</i>
</li>
</ul>
<p>
where <i>T<sub>WetBulb</sub></i> is the wet bulb temperature of the outdoor air,
<i>T<sub>WetBulb,tran</sub></i> is the wet bulb temperature transition point
for switching between FC and FMC,
<i>T<sub>CHWST</sub></i> is the chilled water supply temperature, <i>T<sub>CHWSTSet</sub></i> is
the chilled water supply temperature setpoint,and <i>numOnChi</i> is the number of running chillers.
</p>
</html>", revisions="<html>
<ul>
<li>
July 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingModeNonIntegrated;
