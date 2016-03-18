within Buildings.Fluid.MixingVolumes.Validation.BaseClasses;
model MoistureMixingConservation
  "Partial for checking conservation of mass for independent mass fraction"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air;
  Buildings.Fluid.Sources.MassFlowSource_h sou1(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=2,
    X={0,1}) "Air source"
    annotation (Placement(transformation(extent={{-100,40},{-80,20}})));
  Buildings.Fluid.Sources.MassFlowSource_h sou2(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=1,
    X={0,1}) "Air source"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-50}})));
  Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol(
    redeclare package Medium = Medium,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=1,
    V=1,
    nPorts=2,
    allowFlowReversal=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Mixing volume for adding water"
              annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol1(
    redeclare package Medium = Medium,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=1,
    V=1,
    nPorts=2,
    allowFlowReversal=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Mixing volume for adding water"
              annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sin(redeclare package Medium = Medium,
      nPorts=1) "Air sink"
    annotation (Placement(transformation(extent={{100,20},{80,40}})));
  Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol2(
    redeclare package Medium = Medium,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=1,
    V=1,
    nPorts=2,
    allowFlowReversal=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Mixing volume for removing water"
              annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Modelica.Blocks.Sources.Constant mWatFlo1(k=0.001) "Water mass flow rate 1"
    annotation (Placement(transformation(extent={{-100,52},{-84,68}})));
  Modelica.Blocks.Sources.Constant TWat(k=273.15) "Watter supply temperature"
    annotation (Placement(transformation(extent={{-100,82},{-84,98}})));
  Modelica.Blocks.Sources.Constant mWatFlo3(k=-(mWatFlo1.k + mWatFlo2.k))
    "Withdrawn water rate"
    annotation (Placement(transformation(extent={{-40,52},{-24,68}})));
  Modelica.Blocks.Sources.Constant mWatFlo2(k=0.003) "Water mass flow rate 2"
    annotation (Placement(transformation(extent={{-100,-18},{-84,-2}})));
  Buildings.Utilities.Diagnostics.AssertEquality assMasFra(
      message="Water vapor mass is not conserved", threShold=1E-8)
    "Assert for checking water conservation"
    annotation (Placement(transformation(extent={{84,-22},{98,-36}})));
  Buildings.Fluid.Sensors.MassFractionTwoPort senMasFra(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    tau=0,
    allowFlowReversal=false) "Sensor for measuring water content"
    annotation (Placement(transformation(extent={{58,40},{78,20}})));

  Modelica.Blocks.Sources.Constant mWatFloSol "Solution mass fraction water"
    annotation (Placement(transformation(extent={{60,-38},{70,-28}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
        Medium, allowFlowReversal=false) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{34,40},{54,20}})));
  Buildings.Utilities.Diagnostics.AssertEquality assMasFlo(
    threShold=1E-8,
    message="Total air mass is not conserved")
    "Assert for checking conservation of mass"
    annotation (Placement(transformation(extent={{84,-52},{98,-66}})));
  Modelica.Blocks.Sources.Constant mFloSol "Solution mass flow rate"
    annotation (Placement(transformation(extent={{60,-68},{70,-58}})));
  Sensors.EnthalpyFlowRate senSpeEnt(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=1,
    tau=0) "Specific enthalpy flow rate sensor"
    annotation (Placement(transformation(extent={{10,40},{30,20}})));
  Buildings.Utilities.Diagnostics.AssertEquality assSpeEnt(
    threShold=1E-5,
    message="Enthalpy is not conserved")
    "Assert for checking conservation of energy"
    annotation (Placement(transformation(extent={{84,-84},{98,-98}})));
  Modelica.Blocks.Sources.Constant hSol "Solution mass flow rate"
    annotation (Placement(transformation(extent={{60,-100},{70,-90}})));

protected
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
  redeclare package Medium = Medium)
    "Fluid port for using fluid stream mixing implementation"
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
equation
  connect(sou1.ports[1], vol.ports[1]) annotation (Line(
      points={{-80,30},{-52,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou2.ports[1], vol1.ports[1]) annotation (Line(
      points={{-80,-40},{-52,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mWatFlo1.y, vol.mWat_flow) annotation (Line(
      points={{-83.2,60},{-62,60},{-62,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vol1.TWat,TWat. y) annotation (Line(
      points={{-62,-25.2},{-62,90},{-83.2,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vol.TWat,TWat. y) annotation (Line(
      points={{-62,44.8},{-60,44.8},{-60,42},{-62,42},{-62,90},{-83.2,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWatFlo3.y, vol2.mWat_flow) annotation (Line(
      points={{-23.2,60},{-12,60},{-12,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vol2.TWat,TWat. y) annotation (Line(
      points={{-12,44.8},{-12,90},{-83.2,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWatFlo2.y, vol1.mWat_flow) annotation (Line(
      points={{-83.2,-10},{-62,-10},{-62,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vol1.ports[2], port_a) annotation (Line(
      points={{-48,-40},{-20,-40},{-20,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[2], port_a) annotation (Line(
      points={{-48,30},{-20,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a, vol2.ports[1]) annotation (Line(
      points={{-20,30},{-2,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mWatFloSol.y, assMasFra.u1) annotation (Line(
      points={{70.5,-33},{74,-33},{74,-33.2},{82.6,-33.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senMasFlo.port_b, senMasFra.port_a) annotation (Line(
      points={{54,30},{58,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol2.ports[2], senSpeEnt.port_a) annotation (Line(
      points={{2,30},{10,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senSpeEnt.port_b, senMasFlo.port_a) annotation (Line(
      points={{30,30},{34,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hSol.y, assSpeEnt.u1) annotation (Line(
      points={{70.5,-95},{74,-95},{74,-95.2},{82.6,-95.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mFloSol.y, assMasFlo.u1) annotation (Line(
      points={{70.5,-63},{76.25,-63},{76.25,-63.2},{82.6,-63.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senMasFra.port_b, sin.ports[1]) annotation (Line(
      points={{78,30},{80,30}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (                   Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics),
    experiment(Tolerance=1e-08),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>
May 22 2015 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end MoistureMixingConservation;
