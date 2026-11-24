within Buildings.Fluid.Storage.Validation;
model ExpansionVesselMassConservation
  "Validation model for mass conservation in a closed loop with two expansion vessels"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Specialized.Water.TemperatureDependentDensity
    "Medium model";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 0.5
    "Nominal mass flow rate in the loop";

  Buildings.Fluid.Storage.ExpansionVessel expVes1(
    redeclare package Medium = Medium,
    V_start=0.02,
    VTot=0.04,
    p_start=200000,
    T_start=293.15)
    "First expansion vessel"
    annotation (Placement(transformation(extent={{-30,40},{-10,60}})));

  Buildings.Fluid.Storage.ExpansionVessel expVes2(
    redeclare package Medium = Medium,
    V_start=0.03,
    VTot=0.06,
    p_start=220000,
    T_start=293.15)
    "Second expansion vessel"
    annotation (Placement(transformation(extent={{30,40},{50,60}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=60000,
    p_start=220000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    nominalValuesDefineDefaultPressureCurve=true)
    "Circulation pump"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));

  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=20000)
    "Flow resistance in supply branch"
    annotation (Placement(transformation(extent={{50,10},{70,30}})));

  Buildings.Fluid.FixedResistances.PressureDrop res2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=20000)
    "Flow resistance in return branch"
    annotation (Placement(transformation(extent={{-20,-70},{-40,-50}})));

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    V=1,
    nPorts=2,
    m_flow_nominal=m_flow_nominal,
    T_start=293.15,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Heated and cooled water volume"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));

  Modelica.Blocks.Sources.Pulse mPum_flow(
    amplitude=m_flow_nominal,
    period=1800,
    offset=0)
    "Pump mass flow rate schedule"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));

  Modelica.Blocks.Sources.Pulse pulse(
    amplitude=40,
    period=3600,
    offset=293.15)
    "Pulse signal for water heating and cooling"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Buildings.HeatTransfer.Sources.PrescribedTemperature preTem
    "Prescribed temperature source"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=10000)
    "Thermal conductor to heat and cool the water volume"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));

  Modelica.Units.SI.Mass mTot = vol.m + expVes1.m + expVes2.m
    "Total fluid mass in the closed system";

  Real dmTot(
    final quantity="Mass",
    final unit="kg") = mTot - mTot_start
    "Deviation of total fluid mass from initial value";

protected
  final parameter Modelica.Units.SI.Mass mTot_start =
    vol.V*Medium.density(Medium.setState_pTX(
      p=vol.p_start,
      T=vol.T_start,
      X=vol.X_start[1:Medium.nXi])) +
    expVes1.V_start*Medium.density(Medium.setState_pTX(
      p=expVes1.p_start,
      T=expVes1.T_start,
      X=expVes1.X_start[1:Medium.nXi])) +
    expVes2.V_start*Medium.density(Medium.setState_pTX(
      p=expVes2.p_start,
      T=expVes2.T_start,
      X=expVes2.X_start[1:Medium.nXi]))
    "Initial total fluid mass in the closed system";

equation
  assert(noEvent(abs(dmTot) < 1E-3),
    "Total mass in the closed loop is not conserved.");

  connect(mPum_flow.y, pum.m_flow_in)
    annotation (Line(points={{-39,80},{10,80},{10,32}}, color={0,0,127}));
  connect(pum.port_b, res1.port_a)
    annotation (Line(points={{20,20},{50,20}}, color={0,127,255}));
  connect(expVes2.port_a, pum.port_b)
    annotation (Line(points={{40,40},{40,20},{20,20}}, color={0,127,255}));
  connect(res1.port_b, vol.ports[1])
    annotation (Line(points={{70,20},{80,20},{80,-60},{49,-60},{49,-30}}, color={0,127,255}));
  connect(vol.ports[2], res2.port_a)
    annotation (Line(points={{51,-30},{51,-60},{-20,-60}},                 color={0,127,255}));
  connect(res2.port_b, pum.port_a)
    annotation (Line(points={{-40,-60},{-80,-60},{-80,20},{0,20}}, color={0,127,255}));
  connect(expVes1.port_a, pum.port_a)
    annotation (Line(points={{-20,40},{-20,20},{0,20}}, color={0,127,255}));
  connect(pulse.y, preTem.T)
    annotation (Line(points={{-39,-20},{-32,-20}},                     color={0,0,127}));
  connect(preTem.port, theCon.port_a)
    annotation (Line(points={{-10,-20},{0,-20}},   color={191,0,0}));
  connect(theCon.port_b, vol.heatPort)
    annotation (Line(points={{20,-20},{40,-20}},                color={191,0,0}));

  annotation (
    experiment(
      StopTime=7200,
      Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Validation/ExpansionVesselMassConservation.mos"
      "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(
      info="<html>
<p>
This validation model tests mass conservation in a closed hydronic loop that
contains two expansion vessels, <code>expVes1</code> and <code>expVes2</code>.
</p>
<p>
The two expansion vessels have different sizes and different initial pressures.
The circulation pump periodically starts and stops, which creates a pressure
difference between the two vessels. In addition, the water volume <code>vol</code>
is periodically heated and cooled with a temperature-dependent water density
model, which causes thermal expansion and contraction and varies the system
pressure.
</p>
<p>
The variable <code>mTot</code> sums the fluid masses in <code>vol</code>,
<code>expVes1</code>, and <code>expVes2</code>, and an assertion verifies that
its deviation <code>dmTot</code> from the initial total mass remains zero within
numerical tolerance throughout the simulation.
</p>
</html>",
      revisions="<html>
<ul>
<li>
November 23, 2026, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2220\">IBPSA, #2220</a>.
</li>
</ul>
</html>"));
end ExpansionVesselMassConservation;
