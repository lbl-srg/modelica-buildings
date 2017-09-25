within Buildings.Fluid.MixingVolumes.Validation;
model MixingVolumeTraceSubstance
  "Test model for mixing volume with trace substance input"
  extends Modelica.Icons.Example;
 package Medium = Buildings.Media.Air(extraPropertiesNames={"CO2"})
    "Medium model";

  parameter Modelica.SIunits.Pressure dp_nominal = 10 "Nominal pressure drop";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 0.5
    "Nominal mass flow rate";

  Modelica.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=false,
    m_flow=m_flow_nominal,
    T=313.15) "Flow source and sink"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    T=303.15,
    nPorts=2) "Boundary condition"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,-20})));
  Buildings.Fluid.MixingVolumes.MixingVolume volDyn(
    redeclare package Medium = Medium,
    V=1,
    nPorts=2,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_C_flow=true) "Volume with dynamic balance"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  Modelica.Blocks.Sources.Constant C_flow(k=m_flow_nominal/1000)
    "Trace substance mass flow rate"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Modelica.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=false,
    m_flow=m_flow_nominal,
    T=313.15) "Flow source and sink"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volSte(
    redeclare package Medium = Medium,
    V=1,
    nPorts=2,
    m_flow_nominal=m_flow_nominal,
    use_C_flow=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false) "Volume with steady-state balance"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
  connect(sou.ports[1], volDyn.ports[1]) annotation (Line(points={{-40,6.66134e-16},
          {-26,6.66134e-16},{-26,-5.55112e-16},{-2,-5.55112e-16}}, color={0,127,
          255}));
  connect(C_flow.y, volDyn.C_flow[1]) annotation (Line(points={{-39,40},{-30,40},
          {-30,4},{-12,4}}, color={0,0,127}));
  connect(sou1.ports[1], volSte.ports[1])
    annotation (Line(points={{-40,-50},{-2,-50}},          color={0,127,255}));
  connect(C_flow.y, volSte.C_flow[1]) annotation (Line(points={{-39,40},{-30,40},
          {-30,-46},{-12,-46}}, color={0,0,127}));
  connect(volSte.ports[2], bou.ports[1]) annotation (Line(points={{2,-50},{2,-60},
          {20,-60},{20,-22},{40,-22}}, color={0,127,255}));
  connect(volDyn.ports[2], bou.ports[2]) annotation (Line(points={{2,0},{2,-10},
          {20,-10},{20,-18},{40,-18}}, color={0,127,255}));
  annotation (Documentation(
        info="<html>
<p>
This model demonstrates the use of the mixing volume with air flowing into and out of the volume
and trace substances added to the volume.
</p>
<p>
The model <code>volDyn</code> uses a dynamic balance,
whereas the model <code>volSte</code> uses a steady-state balance.
</p>
</html>", revisions="<html>
<ul>
<li>
January 19, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/MixingVolumes/Validation/MixingVolumeTraceSubstance.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=10));
end MixingVolumeTraceSubstance;
