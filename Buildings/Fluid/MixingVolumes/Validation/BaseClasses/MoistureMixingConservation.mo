within Buildings.Fluid.MixingVolumes.Validation.BaseClasses;
partial model MoistureMixingConservation
  "Partial for checking conservation of mass for independent mass fraction"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model";
  Buildings.Fluid.Sources.MassFlowSource_h sou1(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=2,
    X={0,1}) "Air source"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Fluid.Sources.MassFlowSource_h sou2(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=1,
    X={0,1}) "Air source"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    V=1,
    nPorts=2,
    allowFlowReversal=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Mixing volume for adding water"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol1(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    V=1,
    nPorts=2,
    allowFlowReversal=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Mixing volume for adding water"
    annotation (Placement(transformation(extent={{-60,-20},{-40,-40}})));
  Buildings.Fluid.Sources.Boundary_pT sin(redeclare package Medium = Medium,
      nPorts=1) "Air sink"
    annotation (Placement(transformation(extent={{160,10},{140,30}})));
  Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol2(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    V=1,
    nPorts=2,
    allowFlowReversal=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Mixing volume for removing water"
              annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Modelica.Blocks.Sources.Constant mWatFlo1(k=0.001) "Water mass flow rate 1"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Modelica.Blocks.Sources.Constant mWatFlo3(k=-(mWatFlo1.k + mWatFlo2.k))
    "Withdrawn water rate"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Sources.Constant mWatFlo2(k=0.003) "Water mass flow rate 2"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Modelica.Blocks.Math.Add cheMasFra(k2=-1)
    "Check for water conservation"
    annotation (Placement(transformation(extent={{140,-40},{160,-60}})));
  Buildings.Fluid.Sensors.MassFractionTwoPort senMasFra(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    tau=0,
    allowFlowReversal=false) "Sensor for measuring water content"
    annotation (Placement(transformation(extent={{100,30},{120,10}})));

  Modelica.Blocks.Sources.Constant mWatFloSol "Solution mass fraction water"
    annotation (Placement(transformation(extent={{140,-100},{120,-80}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
        Medium, allowFlowReversal=false) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{60,30},{80,10}})));
  Modelica.Blocks.Math.Add cheMasFlo(k2=-1)
    "Check for conservation of mass"
    annotation (Placement(transformation(extent={{140,-120},{160,-140}})));
  Modelica.Blocks.Sources.Constant mFloSol "Solution mass flow rate"
    annotation (Placement(transformation(extent={{140,-180},{120,-160}})));
  Sensors.EnthalpyFlowRate senSpeEnt(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=1,
    tau=0) "Specific enthalpy flow rate sensor"
    annotation (Placement(transformation(extent={{20,30},{40,10}})));
  Modelica.Blocks.Math.Add cheSpeEnt(k2=-1)
    "Check for conservation of energy"
    annotation (Placement(transformation(extent={{140,-200},{160,-220}})));
  Modelica.Blocks.Sources.Constant hSol "Solution mass flow rate"
    annotation (Placement(transformation(extent={{140,-260},{120,-240}})));

protected
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
  redeclare package Medium = Medium)
    "Fluid port for using fluid stream mixing implementation"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
equation
  connect(sou1.ports[1], vol.ports[1]) annotation (Line(
      points={{-80,20},{-52,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou2.ports[1], vol1.ports[1]) annotation (Line(
      points={{-80,-20},{-52,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mWatFlo1.y, vol.mWat_flow) annotation (Line(
      points={{-79,60},{-70,60},{-70,38},{-62,38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWatFlo3.y, vol2.mWat_flow) annotation (Line(
      points={{-79,90},{-30,90},{-30,38},{-12,38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWatFlo2.y, vol1.mWat_flow) annotation (Line(
      points={{-79,-50},{-74,-50},{-74,-38},{-62,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vol1.ports[2], port_a) annotation (Line(
      points={{-48,-20},{-20,-20},{-20,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[2], port_a) annotation (Line(
      points={{-48,20},{-20,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a, vol2.ports[1]) annotation (Line(
      points={{-20,20},{-2,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mWatFloSol.y,cheMasFra. u1) annotation (Line(
      points={{119,-90},{110,-90},{110,-56},{138,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senMasFlo.port_b, senMasFra.port_a) annotation (Line(
      points={{80,20},{100,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol2.ports[2], senSpeEnt.port_a) annotation (Line(
      points={{2,20},{20,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senSpeEnt.port_b, senMasFlo.port_a) annotation (Line(
      points={{40,20},{60,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hSol.y,cheSpeEnt. u1) annotation (Line(
      points={{119,-250},{110,-250},{110,-216},{138,-216}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mFloSol.y,cheMasFlo. u1) annotation (Line(
      points={{119,-170},{110.25,-170},{110.25,-136},{138,-136}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senMasFra.port_b, sin.ports[1]) annotation (Line(
      points={{120,20},{140,20}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-260},{160,100}})),
    Documentation(info="<html>
<p>
This is a partial model that is used in the validation tests
of the mixing volume.
</p>
</html>", revisions="<html>
<ul>
<li>
April 12, 2017, by Michael Wetter:<br/>
Removed temperature connection that is no longer needed.<br/>
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/704\">Buildings #704</a>.
</li>
<li>
November 15, 2016, by Michael Wetter:<br/>
Changed model to be <code>partial</code> and removed the <code>experiment</code> annotation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/590\">issue 590</a>.
</li>
<li>
November 2, 2016, by Michael Wetter:<br/>
Changed assertions to blocks that compute the difference.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/564\">issue 564</a>.
</li>
<li>
May 22 2015 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end MoistureMixingConservation;
