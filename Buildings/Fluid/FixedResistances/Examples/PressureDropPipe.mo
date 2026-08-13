within Buildings.Fluid.FixedResistances.Examples;
model PressureDropPipe
  "Example model for selectable pipe pressure drop calculation"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water
    "Medium model";

  Modelica.Blocks.Sources.Ramp mFlo(
    duration=1,
    height=0.4,
    offset=-0.2)
    "Ramp mass flow rate"
    annotation (Placement(transformation(extent={{-92,-2},{-72,18}})));

  Buildings.Fluid.Sources.MassFlowSource_T souLos(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=293.15,
    nPorts=1)
    "Mass flow source for lossless pipe"
    annotation (Placement(transformation(extent={{-50,32},{-30,52}})));

  Buildings.Fluid.Sources.MassFlowSource_T souNom(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=293.15,
    nPorts=1)
    "Mass flow source for nominal pressure drop pipe"
    annotation (Placement(transformation(extent={{-50,-8},{-30,12}})));

  Buildings.Fluid.Sources.MassFlowSource_T souDet(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=293.15,
    nPorts=1)
    "Mass flow source for detailed pressure drop pipe"
    annotation (Placement(transformation(extent={{-50,-48},{-30,-28}})));

  Buildings.Fluid.Sources.Boundary_pT sinLos(
    redeclare package Medium = Medium,
    T=293.15,
    p(displayUnit="Pa") = 300000,
    nPorts=1)
    "Pressure boundary condition for lossless pipe"
    annotation (Placement(transformation(extent={{50,32},{30,52}})));

  Buildings.Fluid.Sources.Boundary_pT sinNom(
    redeclare package Medium = Medium,
    T=293.15,
    p(displayUnit="Pa") = 300000,
    nPorts=1)
    "Pressure boundary condition for nominal pressure drop pipe"
    annotation (Placement(transformation(extent={{50,-8},{30,12}})));

  Buildings.Fluid.Sources.Boundary_pT sinDet(
    redeclare package Medium = Medium,
    T=293.15,
    p(displayUnit="Pa") = 300000,
    nPorts=1)
    "Pressure boundary condition for detailed pressure drop pipe"
    annotation (Placement(transformation(extent={{50,-48},{30,-28}})));

  Buildings.Fluid.FixedResistances.PressureDropPipe resLos(
    redeclare package Medium = Medium,
    m_flow_nominal=0.2,
    computePressureDrop=false,
    use_detailedPressureDrop=false,
    dp_nominal=0,
    length=1,
    dh=0.027, 
    roughness=0.001e-3,
    kMinor=0,
    fluidProperties=Buildings.Fluid.Types.FluidProperties.DefaultTemperature,
    T_ref=293.15)
    "Lossless pipe option"
    annotation (Placement(transformation(extent={{-10,32},{10,52}})));

  Buildings.Fluid.FixedResistances.PressureDropPipe resNom(
    redeclare package Medium = Medium,
    m_flow_nominal=0.2,
    computePressureDrop=true,
    use_detailedPressureDrop=false,
    dp_nominal=80,
    n=2,
    from_dp=false,
    linearized=false,
    length=1,
    dh=0.027, 
    roughness=0.001e-3,
    kMinor=0,
    fluidProperties=Buildings.Fluid.Types.FluidProperties.DefaultTemperature,
    T_ref=293.15)
    "Nominal pressure drop option"
    annotation (Placement(transformation(extent={{-10,-8},{10,12}})));

  Buildings.Fluid.FixedResistances.PressureDropPipe resDet(
    redeclare package Medium = Medium,
    m_flow_nominal=0.2,
    computePressureDrop=true,
    use_detailedPressureDrop=true,
    dp_nominal=0,
    length=1,
    dh=0.027, 
    roughness=0.001e-3,
    kMinor=0,
    fluidProperties=Buildings.Fluid.Types.FluidProperties.DefaultTemperature,
    T_ref=293.15)
    "Detailed Darcy-Weisbach pressure drop option"
    annotation (Placement(transformation(extent={{-10,-48},{10,-28}})));

equation
  connect(mFlo.y, souLos.m_flow_in)
    annotation (Line(points={{-71,8},{-62,8},{-62,50},{-52,50}},
                    color={0,0,127}));

  connect(mFlo.y, souNom.m_flow_in)
    annotation (Line(points={{-71,8},{-62,8},{-62,10},{-52,10}},
                    color={0,0,127}));

  connect(mFlo.y, souDet.m_flow_in)
    annotation (Line(points={{-71,8},{-62,8},{-62,-30},{-52,-30}},
                    color={0,0,127}));

  connect(souLos.ports[1], resLos.port_a)
    annotation (Line(points={{-30,42},{-10,42}},
                    color={0,127,255}));

  connect(resLos.port_b, sinLos.ports[1])
    annotation (Line(points={{10,42},{30,42}},
                    color={0,127,255}));

  connect(souNom.ports[1], resNom.port_a)
    annotation (Line(points={{-30,2},{-10,2}},
                    color={0,127,255}));

  connect(resNom.port_b, sinNom.ports[1])
    annotation (Line(points={{10,2},{30,2}},
                    color={0,127,255}));

  connect(souDet.ports[1], resDet.port_a)
    annotation (Line(points={{-30,-38},{-10,-38}},
                    color={0,127,255}));

  connect(resDet.port_b, sinDet.ports[1])
    annotation (Line(points={{10,-38},{30,-38}},
                    color={0,127,255}));

  annotation (
    experiment(Tolerance=1e-6, StopTime=1.0),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Examples/PressureDropPipe.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example model for
<a href=\"modelica://Buildings.Fluid.FixedResistances.PressureDropPipe\">
Buildings.Fluid.FixedResistances.PressureDropPipe</a>.
</p>
<p>
The example compares the three pressure drop options available in the wrapper:
</p>
<ul>
<li>
<code>resLos</code> uses the lossless option by setting
<code>computePressureDrop=false</code>.
</li>
<li>
<code>resNom</code> uses the nominal pressure drop option by setting
<code>use_detailedPressureDrop=false</code> and specifying
<code>dp_nominal</code>.
</li>
<li>
<code>resDet</code> uses the detailed Darcy-Weisbach pressure drop option by
setting <code>use_detailedPressureDrop=true</code> and specifying the pipe
geometry.
</li>
</ul>
<p>
All three components are driven by the same prescribed mass flow rate. This
allows direct comparison of the resulting pressure drops.
</p>
<p>
The plotted variables show the imposed mass flow rate, the resulting total
pressure drop, the major and minor pressure drop contributions, and the Reynolds
number. For the lossless option, the pressure drop, major pressure drop, minor
pressure drop, and Reynolds number are zero.
</p>
</html>", revisions="<html>
<ul>
<li>
August 7, 2026, by Lone Meertens:<br/>
First implementation for validating the selectable pipe pressure drop wrapper.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4687\">Buildings, #4687</a>.
</li>
</ul>
</html>"));
end PressureDropPipe;
