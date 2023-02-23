within Buildings.Fluid.MixingVolumes.Validation;
model MSLCombustionAir
  "Test model with medium for combustion air from the Modelica Standard Library"
    extends Modelica.Icons.Example;

  replaceable package Medium =
      Modelica.Media.IdealGases.MixtureGases.CombustionAir;

  parameter Modelica.Units.SI.PressureDifference dp_nominal=10
    "Nominal pressure drop";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=10
    "Nominal mass flow rate";

  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal)
    "Pressure drop"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T masFloSou(
    redeclare package Medium = Medium,
    m_flow=m_flow_nominal,
    nPorts=1) "Mass flow source"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    p=Medium.p_default + dp_nominal,
    nPorts=1)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal,
    V=1,
    nPorts=2)
    "Control volume"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
equation
  connect(res.port_b, bou.ports[1])
    annotation (Line(points={{20,0},{40,0}}, color={0,127,255}));
  connect(masFloSou.ports[1], vol.ports[1])
    annotation (Line(points={{-60,0},{-31,0},{-31,20}}, color={0,127,255}));
  connect(vol.ports[2], res.port_a) annotation (
    Line(points = {{-29, 20}, {-29, 0}, {0, 0}}, color = {0, 127, 255}));
  annotation (
  experiment(
    Tolerance=1E-6,
    StopTime=1),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/MixingVolumes/Validation/MSLCombustionAir.mos"
        "Simulate and plot"),
    Documentation(
info = "<html>
<p>
This model verifies that basic fluid flow components also
work with a medium model from the Modelica Standard Library
for combustion air.
</p>
<p>
This medium differs from media in the Buildings library in that it has no substance <code>water</code>
and it sets <code>reducedX=false</code>.
</p>
</html>",
revisions = "<html>
<ul>
<li>
October 24, 2022, by Michael Wetter:<br/>
First implementation.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1650\">#1650</a>.
</li>
</ul>
</html>"));
end MSLCombustionAir;
