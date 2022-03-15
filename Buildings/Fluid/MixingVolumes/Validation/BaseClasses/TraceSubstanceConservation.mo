within Buildings.Fluid.MixingVolumes.Validation.BaseClasses;
model TraceSubstanceConservation
  "This test checks if trace substance mass flow rates are conserved"
  extends Modelica.Icons.Example;
  constant String substanceName="CO2";
  package Medium = Buildings.Media.Air(extraPropertiesNames={substanceName});
  Buildings.Fluid.Sources.MassFlowSource_h sou(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=1,
    X={0.01,0.99},
    C=fill(0.001, Medium.nC)) "Air source with moisture and trace substances"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    V=1,
    nPorts=2,
    allowFlowReversal=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Mixing volume for adding moisture"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Modelica.Blocks.Sources.Constant mWatFlo(k=0.001) "Water mass flow rate "
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort senTraSubIn(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    tau=0,
    allowFlowReversal=false,
    substanceName=substanceName) "Measured inlet trace substance concentration"
    annotation (Placement(transformation(extent={{-70,10},{-50,-10}})));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort senTraSubOut(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    tau=0,
    allowFlowReversal=false,
    substanceName=substanceName)
    "Measured outlet trace substance concentration"
    annotation (Placement(transformation(extent={{20,10},{40,-10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(redeclare package Medium = Medium,
      nPorts=1) "Air sink"
    annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  Sensors.MassFlowRate senMasFloIn(redeclare package Medium = Medium,
      allowFlowReversal=false) "Fluid mass flow rate at inlet"
    annotation (Placement(transformation(extent={{-40,10},{-20,-10}})));
  Sensors.MassFlowRate senMasFloOut(redeclare package Medium = Medium,
      allowFlowReversal=false) "Fluid mass flow rate at outlet"
    annotation (Placement(transformation(extent={{50,10},{70,-10}})));
  Modelica.Blocks.Math.Product CfloIn "Trace substance mass flow rate at inlet"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-46,-30})));
  Modelica.Blocks.Math.Product CfloOut
    "Trace substance mass flow rate at outlet" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={46,-30})));
equation
  connect(mWatFlo.y, vol.mWat_flow) annotation (Line(
      points={{-59,70},{-30,70},{-30,18},{-12,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[1], senTraSubIn.port_a) annotation (Line(
      points={{-80,0},{-70,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTraSubIn.port_b, senMasFloIn.port_a) annotation (Line(
      points={{-50,0},{-40,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFloIn.port_b, vol.ports[1]) annotation (Line(
      points={{-20,0},{-2,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin.ports[1], senMasFloOut.port_b) annotation (Line(
      points={{80,0},{70,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFloOut.port_a, senTraSubOut.port_b) annotation (Line(
      points={{50,0},{40,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(CfloIn.u2, senTraSubIn.C) annotation (Line(
      points={{-52,-18},{-60,-18},{-60,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(CfloIn.u1, senMasFloIn.m_flow) annotation (Line(
      points={{-40,-18},{-30,-18},{-30,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(CfloOut.u1, senMasFloOut.m_flow) annotation (Line(
      points={{52,-18},{60,-18},{60,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(CfloOut.u2, senTraSubOut.C) annotation (Line(
      points={{40,-18},{30,-18},{30,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vol.ports[2], senTraSubOut.port_a) annotation (Line(
      points={{2,0},{20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (    Documentation(info="<html>
<p>
This model is reconfigured to a steady state or
dynamic check for conservation of trace substances.
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
May 22 2015 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end TraceSubstanceConservation;
