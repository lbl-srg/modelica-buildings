within Buildings.Fluid.Sensors.Conversions.Examples;
model To_VolumeFraction "Example problem for conversion model"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air(extraPropertiesNames={"CO2"});

  Buildings.Fluid.Sensors.Conversions.To_VolumeFraction conMasVolFra(MMMea=
        Modelica.Media.IdealGases.Common.SingleGasesData.CO2.MM)
    "Conversion from mass fraction CO2 to volume fraction CO2"
    annotation (Placement(transformation(extent={{148,0},{168,20}})));
  Modelica.Blocks.Sources.Constant volFra(k=1000E-6)
    "Set point for volume fraction of 700PPM CO2"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  Buildings.Controls.Continuous.LimPID limPID(
    reverseActing=false,
    Ti=600,
    k=2,
    Td=1)
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Buildings.Fluid.Sensors.TraceSubstances senCO2(
    redeclare package Medium = Medium,
    substanceName="CO2",
    warnAboutOnePortConnection = false) "CO2 sensor"
    annotation (Placement(transformation(extent={{120,0},{140,20}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    nPorts=4,
    redeclare package Medium = Medium,
    V=4*4*2.7,
    C_start={300E-6}*44.009544/28.9651159,
    m_flow_nominal=0.1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Volume of air"
    annotation (Placement(transformation(extent={{90,60},{110,80}})));
  Buildings.Fluid.Sources.TraceSubstancesFlowSource souCO2(
    use_m_flow_in=true,
    redeclare package Medium = Medium,
    nPorts=1) "CO2 source"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Math.Gain CO2Per(k=15/1000/3600*1.977)
    "CO2 emission per person"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    use_m_flow_in=true,
    redeclare package Medium = Medium,
    C={300E-6}*44.009544/28.9651159,
    nPorts=1) "Source of fresh air with 300 PPM CO2"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Modelica.Blocks.Math.Gain gai(k=50/3600) "Gain for mass flow rate"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.Constant nPeo(k=1) "Number of people"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Fluid.Sensors.VolumeFlowRate senVolFlo(
    redeclare package Medium = Medium,
    m_flow_nominal=0.1)
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Modelica.Blocks.Math.Gain norSet(k=1/1000E-6)
    "Normalization for set point (to scale control input)"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Modelica.Blocks.Math.Gain norMea(k=1/1000E-6)
    "Normalization for measured concentration (to scale control input)"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
  Modelica.Blocks.Math.Gain conVolFlo(k=3600, y(unit="m3/h"))
    "Conversion from m3/s to m3/h"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort senTraSubPeo(m_flow_nominal=0.1,
    redeclare package Medium = Medium,
    C_start=0,
    initType=Modelica.Blocks.Types.Init.InitialState)
    "CO2 concentration in absorptance from people"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort senTraSubFre(m_flow_nominal=0.1,
    redeclare package Medium = Medium,
    C_start=0,
    initType=Modelica.Blocks.Types.Init.InitialState)
    "CO2 concentration in fresh air supply"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    dp_nominal=10,
    m_flow_nominal=50/3600)
    "Pressure drop to decouple the state of the volume from the state of the boundary condition"
    annotation (Placement(transformation(extent={{122,30},{142,50}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    C={300E-6}*44.009544/28.9651159,
    p=100000,
    nPorts=1) "Sink for exhaust air"
    annotation (Placement(transformation(extent={{180,30},{160,50}})));

equation
  connect(souCO2.m_flow_in, CO2Per.y) annotation (Line(
      points={{-22.1,70},{-39,70}},
      color={0,0,127}));
  connect(gai.y, sou.m_flow_in) annotation (Line(
      points={{-39,-10},{-30,-10},{-30,-2},{-22,-2}},
      color={0,0,127}));
  connect(limPID.y, gai.u) annotation (Line(
      points={{-79,-10},{-62,-10}},
      color={0,0,127}));
  connect(nPeo.y, CO2Per.u) annotation (Line(
      points={{-79,70},{-62,70}},
      color={0,0,127}));
  connect(sou.ports[1], senVolFlo.port_a) annotation (Line(
      points={{5.55112e-16,-10},{20,-10}},
      color={0,127,255}));
  connect(senCO2.C, conMasVolFra.m) annotation (Line(
      points={{141,10},{147,10}},
      color={0,0,127}));
  connect(conMasVolFra.V, norMea.u) annotation (Line(
      points={{169,10},{180,10},{180,-80},{-152,-80},{-152,-50},{-142,-50}},
      color={0,0,127}));
  connect(norMea.y, limPID.u_m) annotation (Line(
      points={{-119,-50},{-90,-50},{-90,-22}},
      color={0,0,127}));
  connect(volFra.y, norSet.u) annotation (Line(
      points={{-159,-10},{-142,-10}},
      color={0,0,127}));
  connect(norSet.y, limPID.u_s) annotation (Line(
      points={{-119,-10},{-102,-10}},
      color={0,0,127}));
  connect(conVolFlo.u, senVolFlo.V_flow) annotation (Line(
      points={{38,30},{30,30},{30,1}},
      color={0,0,127}));
  connect(souCO2.ports[1], senTraSubPeo.port_a) annotation (Line(
      points={{5.55112e-16,70},{40,70}},
      color={0,127,255}));
  connect(senTraSubPeo.port_b, vol.ports[1]) annotation (Line(
      points={{60,70},{82,70},{82,50},{97,50},{97,60}},
      color={0,127,255}));
  connect(senVolFlo.port_b, senTraSubFre.port_a) annotation (Line(
      points={{40,-10},{60,-10}},
      color={0,127,255}));
  connect(senTraSubFre.port_b, vol.ports[2]) annotation (Line(
      points={{80,-10},{99,-10},{99,60}},
      color={0,127,255}));
  connect(vol.ports[3], senCO2.port) annotation (Line(
      points={{101,60},{101,-10},{130,-10},{130,-5.55112e-16}},
      color={0,127,255}));
  connect(vol.ports[4], res.port_a) annotation (Line(
      points={{103,60},{102,60},{102,38},{122,38},{122,40}},
      color={0,127,255}));
  connect(sin.ports[1], res.port_b)
    annotation (Line(points={{160,40},{142,40}}, color={0,127,255}));
  annotation (
experiment(Tolerance=1e-8, StopTime=36000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Sensors/Conversions/Examples/To_VolumeFraction.mos"
        "Simulate and plot"),
  Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-200,-100},{200,100}})),
    Documentation(info="<html>
This example demonstrates the modeling of a room with one person and CO<sub>2</sub> control.
The room has a volume of <i>4*4*2.7 m<sup>3</sup></i>, and the CO<sub>2</sub> inflow is from
one person.
A control system regulates the outside air to maintain a CO<sub>2</sub> concentration of 1000 PPM
in the room. The outside air has a CO<sub>2</sub> concentration of 300 PPM.
Note that for simplicity, we allow zero outside air flow rate if the CO<sub>2</sub> concentration is below
the setpoint, which does not comply with ASHRAE regulations.
</html>", revisions="<html>
<ul>
<li>
March 26, 2024, by Michael Wetter:<br/>
Configured the sensor parameter to suppress the warning about being a one-port connection.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1857\">IBPSA, #1857</a>.
</li>
<li>
May 2, 2019, by Jianjun Hu:<br/>
Replaced fluid source. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1072\"> #1072</a>.
</li>
<li>
April 25, 2017 by Filip Jorissen:<br/>
Increased model tolerance for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/750\">#750</a>.
</li>
<li>
March 27, 2013 by Michael Wetter:<br/>
Added a flow resistance between the volume and the ambient to decouple the
state of the volume from the boundary conditions. This is needed to allow
a pedantic model check in Dymola 2014, as otherwise, the initial conditions of
the volume could not be specified without introducing redundant equations.
</li>
<li>
February 13, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end To_VolumeFraction;
