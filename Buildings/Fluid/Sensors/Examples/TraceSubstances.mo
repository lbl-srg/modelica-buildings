within Buildings.Fluid.Sensors.Examples;
model TraceSubstances "Test model for the extra property sensor"
  extends Modelica.Icons.Example;
 package Medium = Buildings.Media.GasesPTDecoupled.SimpleAir(extraPropertiesNames={"CO2"})
    "Medium model";

 parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 15*1.2/3600
    "Mass flow rate into and out of the volume";

  MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    V=2*3*3,
    m_flow_nominal=1E-6,
    nPorts=4,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Mixing volume"
    annotation (Placement(transformation(extent={{74,50}, {94,70}}, rotation=0)));
  Sources.TraceSubstancesFlowSource sou(
    redeclare package Medium = Medium,
    nPorts=2,
    use_m_flow_in=true) "CO2 mass flow source"
    annotation (Placement(transformation(extent={{-2,30},{18,50}}, rotation=0)));
  Modelica.Blocks.Sources.Constant step(k=8.18E-6) "CO2 mass flow rate"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}}, rotation=0)));
  Buildings.Fluid.Sensors.TraceSubstances senVol(
    redeclare package Medium = Medium) "Sensor at volume"
    annotation (Placement(transformation(extent={{100,50},{120,70}}, rotation=0)));
  Buildings.Fluid.Sensors.TraceSubstances senSou(
    redeclare package Medium = Medium,
    substanceName="CO2") "Sensor at source"
    annotation (Placement(transformation(extent={{24,90},{44,110}}, rotation=0)));
  Modelica.Blocks.Sources.Constant m_flow(k=m_flow_nominal)
    "Fresh air mass flow rate"
    annotation (Placement(transformation(extent={{-80,-14},{-60,6}}, rotation=0)));
  Buildings.Fluid.Sources.MassFlowSource_T mSou(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Fresh air supply"
    annotation (Placement(transformation(extent={{0,-22},{20,-2}}, rotation=0)));
  Sources.FixedBoundary mSin(
    redeclare package Medium = Medium,
    nPorts=1) "Exhaust air"
    annotation (Placement(transformation(extent={{0,-62},{20,-42}},
          rotation=0)));
  Buildings.Fluid.Sensors.Conversions.To_VolumeFraction masFraSou(
    MMMea=Modelica.Media.IdealGases.Common.SingleGasesData.CO2.MM)
    "Conversion of mass ratio to volume ratio"
    annotation (Placement(transformation(extent={{140,90},{160,110}},  rotation=
           0)));
  Buildings.Fluid.Sensors.Conversions.To_VolumeFraction masFraVol(
    MMMea=Modelica.Media.IdealGases.Common.SingleGasesData.CO2.MM)
    "Conversion of mass ratio to volume ratio"
    annotation (Placement(transformation(extent={{140,50},{160,70}}, rotation=0)));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort senTraSub(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal) "Sensor at exhaust air"
    annotation (Placement(transformation(extent={{50,-62},{30,-42}})));

  inner Modelica.Fluid.System system   annotation (Placement(transformation(
          extent={{-100,-100},{-80,-80}}, rotation=0)));

  FixedResistances.FixedResistanceDpM res(
    redeclare package Medium = Medium,
    dp_nominal=10,
    m_flow_nominal=0.005,
    linearized=true)
    annotation (Placement(transformation(extent={{60,-62},{80,-42}})));
equation
  connect(m_flow.y, mSou.m_flow_in) annotation (Line(points={{-59,-4},{0,-4}}, color={0,0,127}));
  connect(senSou.C, masFraSou.m) annotation (Line(points={{45,100},{45,100},{139,
          100}}, color={0,0,127}));
  connect(senVol.C, masFraVol.m) annotation (Line(points={{121,60},{139,60}},
        color={0,0,127}));
  connect(sou.ports[1], senSou.port) annotation (Line(
      points={{18,42},{34,42},{34,90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(step.y, sou.m_flow_in) annotation (Line(
      points={{-59,40},{-4.1,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mSin.ports[1], senTraSub.port_b) annotation (Line(
      points={{20,-52},{30,-52}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[2], vol.ports[1]) annotation (Line(
      points={{18,38},{81,38},{81,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mSou.ports[1], vol.ports[2]) annotation (Line(
      points={{20,-12},{83,-12},{83,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res.port_a, senTraSub.port_a) annotation (Line(
      points={{60,-52},{50,-52}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res.port_b, vol.ports[3]) annotation (Line(
      points={{80,-52},{85,-52},{85,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senVol.port, vol.ports[4]) annotation (Line(
      points={{110,50},{110,40},{87,40},{87,50}},
      color={0,127,255},
      smooth=Smooth.None));
    annotation (
experiment(StopTime=7200),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Sensors/Examples/TraceSubstances.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{180,
            180}}), graphics),
    Documentation(info="<html>
<p>
This example tests the sensors that measure trace substances.
A CO<sub>2</sub> mass flow rate of <i>8.18E-8</i> kg/kg is added to the
volume. The volume also has a fresh air mass flow rate and
an exhaust air mass flow rate. The initial CO<sub>2</sub> concentration
of the volume is <i>0</i> kg/kg.
Note that the fresh air supply has zero carbon dioxide concentration.
Therefore, if it were outside air, then all concentrations are relative
to the outside air concentration.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 8, 2014, by Michael Wetter:<br/>
Added a pressure drop element, as otherwise the initialization problem 
is overspecified for incompressible media.
</li>
<li>
November 27, 2013 by Michael Wetter:<br/>
Changed sink model from a prescribed flow source to a pressure 
boundary condition. This is required for the new air model,
which is incompressible. Otherwise, there will be no pressure reference
in the system.
</li>
<li>
September 10, 2013 by Michael Wetter:<br/>
Changed initialization of volume to fixed initial values to avoid
a translation warning in OpenModelica.
</li>
<li>
August 30, 2013 by Michael Wetter:<br/>
Renamed example and added an instance of 
<a href=\"modelica://Buildings.Fluid.Sensors.TraceSubstancesTwoPort\">
Buildings.Fluid.Sensors.TraceSubstancesTwoPort</a>.
</li>
<li>
September 29, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TraceSubstances;
