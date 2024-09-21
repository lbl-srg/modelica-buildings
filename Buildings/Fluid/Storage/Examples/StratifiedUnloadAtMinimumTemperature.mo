within Buildings.Fluid.Storage.Examples;
model StratifiedUnloadAtMinimumTemperature
  "Example that demonstrates how to draw from a hot water tank at the minimum temperature"

  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.Volume VTan=3
  "Tank volume";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=3*1000/3600
    "Nominal mass flow rate";

  constant Integer nSeg=5
  "Number of volume segments";

  Buildings.Fluid.Storage.Stratified tan(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    VTan=VTan,
    hTan=2,
    dIns=0.2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nSeg=nSeg,
    T_start=353.15)
    "Hot water storage tank"
    annotation (Placement(transformation(extent={{-120,-128},{-100,-108}})));

  Buildings.Fluid.Sources.Boundary_pT loa(
  redeclare package Medium = Medium,
      nPorts=1)
    "Load (imposed by a constant pressure boundary condition and the flow of masSou)"
    annotation (Placement(transformation(extent={{242,-70},{222,-50}})));

  Buildings.Fluid.Sources.MassFlowSource_T masSou(
    nPorts=1,
    redeclare package Medium = Medium,
    m_flow=m_flow_nominal)
    "Mass flow rate into the tank"
    annotation (Placement(transformation(extent={{242,-130},{222,-110}})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valTop(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=3000,
    use_inputFilter=false)
    "Control valve at top"
    annotation (Placement(transformation(extent={{112,-30},{132,-10}})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valMid(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=3000,
    use_inputFilter=false)
    "Control valve at middle"
    annotation (Placement(transformation(extent={{132,-70},{152,-50}})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valBot(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=3000,
    use_inputFilter=false)
    "Control valve at bottom"
    annotation (Placement(transformation(extent={{150,-110},{170,-90}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TMid
    "Temperature tank middle"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TBot
    "Temperature tank bottom"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));

  Modelica.Blocks.Logical.Hysteresis onOffBot(uLow=273.15 + 40 - 0.05, uHigh=
        273.15 + 40 + 0.05)
    "Controller for valve at bottom"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0)
    "Outflowing temperature"
    annotation (Placement(transformation(extent={{190,-70},{210,-50}})));

  Modelica.Blocks.Logical.Hysteresis onOffMid(uLow=273.15 + 40 - 0.05, uHigh=
        273.15 + 40 + 0.05)
    "Controller for valve at middle of tank"
    annotation (Placement(transformation(extent={{-50,70},{-30,90}})));

  Modelica.Blocks.Logical.And and2
    "And block to compute control action for middle valve"
    annotation (Placement(transformation(extent={{10,70},{30,90}})));

  Modelica.Blocks.Math.BooleanToReal yMid
    "Boolean to real conversion for valve at middle"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));

  Modelica.Blocks.Math.BooleanToReal yTop
    "Boolean to real conversion for valve at top"
    annotation (Placement(transformation(extent={{80,110},{100,130}})));

  Modelica.Blocks.Logical.Nor nor
    "Nor block for top-most control valve"
    annotation (Placement(transformation(extent={{50,110},{70,130}})));

  Modelica.Blocks.Logical.Not not1
    "Not block to negate control action of upper level control"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow hea
    "Heat input at the bottom of the tank"
    annotation (Placement(transformation(extent={{-150,-134},{-130,-114}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TTop
    "Temperature tank top"
    annotation (Placement(transformation(extent={{-160,-100},{-180,-80}})));

  Modelica.Blocks.Logical.Hysteresis onOffHea(uLow=273.15 + 50 - 0.05, uHigh=
        273.15 + 50 + 0.05)
    "Controller for heater at bottom"
    annotation (Placement(transformation(extent={{-210,-134},{-190,-114}})));

  Modelica.Blocks.Math.BooleanToReal yHea(realFalse=150000)
    "Boolean to real for valve at bottom"
    annotation (Placement(transformation(extent={{-180,-134},{-160,-114}})));

  Modelica.Blocks.Math.BooleanToReal yBot
    "Boolean to real conversion for valve at bottom"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));

equation
  connect(masSou.ports[1], tan.port_b)
    annotation (Line(points={{222,-120},{56,-120},{56,-128},{-110,-128}},color={0,127,255}));

  connect(TMid.port, tan.heaPorVol[3])
    annotation (Line(points={{-100,80},{-100,-118},{-110,-118}},color={191,0,0}));

  connect(TBot.port, tan.heaPorVol[5])
    annotation (Line(points={{-100,40},{-100,-117.76},{-110,-117.76}},color={191,0,0}));

  connect(valTop.port_b, senTem.port_a)
    annotation (Line(points={{132,-20},{182,-20},{182,-60},{190,-60}},color={0,127,255}));

  connect(valMid.port_b, senTem.port_a)
    annotation (Line(points={{152,-60},{190,-60}},color={0,127,255}));

  connect(valBot.port_b, senTem.port_a)
    annotation (Line(points={{170,-100},{182,-100},{182,-60},{190,-60}},color={0,127,255}));

  connect(senTem.port_b,loa. ports[1])
    annotation (Line(points={{210,-60},{222,-60}},color={0,127,255}));

  connect(valTop.port_a, tan.fluPorVol[1])
    annotation (Line(points={{112,-20},{-116,-20},{-116,-118},{-115,-118},{-115,-119.6}},color={0,127,255}));

  connect(valMid.port_a, tan.fluPorVol[3])
    annotation (Line(points={{132,-60},{-116,-60},{-116,-118},{-115,-118}},color={0,127,255}));

  connect(valBot.port_a, tan.fluPorVol[5])
    annotation (Line(points={{150,-100},{-116,-100},{-116,-118},{-115,-118},{-115,-116.4}},color={0,127,255}));

  connect(onOffMid.y, and2.u1)
    annotation (Line(points={{-29,80},{8,80}},color={255,0,255}));

  connect(yMid.u, and2.y)
    annotation (Line(points={{78,80},{31,80}},color={255,0,255}));

  connect(yTop.u, nor.y)
    annotation (Line(points={{78,120},{71,120}},color={255,0,255}));

  connect(and2.y, nor.u1)
    annotation (Line(points={{31,80},{40,80},{40,120},{48,120}},color={255,0,255}));

  connect(onOffBot.y, nor.u2)
    annotation (Line(points={{-29,40},{46,40},{46,112},{48,112}},color={255,0,255}));

  connect(yTop.y, valTop.y)
    annotation (Line(points={{101,120},{122,120},{122,-8}},color={0,0,127}));

  connect(yMid.y, valMid.y)
    annotation (Line(points={{101,80},{142,80},{142,-48}},color={0,0,127}));

  connect(not1.u, onOffBot.y)
    annotation (Line(points={{-22,60},{-26,60},{-26,40},{-29,40}},color={255,0,255}));

  connect(not1.y, and2.u2)
    annotation (Line(points={{1,60},{4,60},{4,72},{8,72}},color={255,0,255}));

  connect(hea.port, tan.heaPorVol[5])
    annotation (Line(points={{-130,-124},{-110,-124},{-110,-117.76}},color={191,0,0}));

  connect(TTop.port, tan.heaPorVol[1])
    annotation (Line(points={{-160,-90},{-120,-90},{-120,-120},{-110,-120},{-110,-118.24}},color={191,0,0}));

  connect(onOffHea.u, TTop.T)
    annotation (Line(points={{-212,-124},{-230,-124},{-230,-90},{-181,-90}},color={0,0,127}));

  connect(onOffHea.y, yHea.u)
    annotation (Line(points={{-189,-124},{-182,-124}}, color={255,0,255}));

  connect(hea.Q_flow, yHea.y)
    annotation (Line(points={{-150,-124},{-159,-124}}, color={0,0,127}));

  connect(onOffBot.y, yBot.u)
    annotation (Line(points={{-29,40},{78,40}}, color={255,0,255}));

  connect(yBot.y, valBot.y)
    annotation (Line(points={{101,40},{160,40},{160,-88}}, color={0,0,127}));

  connect(TBot.T, onOffBot.u)
    annotation (Line(points={{-79,40},{-52,40}}, color={0,0,127}));

  connect(onOffMid.u, TMid.T)
    annotation (Line(points={{-52,80},{-79,80}}, color={0,0,127}));

  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-300,-140},{260,140}})),
       __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Examples/StratifiedUnloadAtMinimumTemperature.mos"
        "Simulate and plot"),
    experiment(
      StopTime=21600,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
Example for tank model that has three outlets, each with a valve.
The valve at the bottom opens when the temperature in that tank segment
is sufficiently warm to serve the load.
The tank in the middle also opens when its tank temperature is sufficiently high,
but only if the valve below is closed.
Finally, the valve at the top only opens if no other valve is open.
Hence, there is always exactly one valve open.
On the right-hand side of the model is a heater that adds heat to the bottom of the
tank if the top tank segment is below the set point temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
June 7, 2018 by Filip Jorissen:<br/>
Copied model from Buildings and update the model accordingly
by removing CDL blocks.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/314\">#314</a>.
</li>
<li>
June 1, 2018, by Michael Wetter:<br/>
First implementation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1182\">
issue 1182</a>.
</li>
</ul>
</html>"));
end StratifiedUnloadAtMinimumTemperature;
