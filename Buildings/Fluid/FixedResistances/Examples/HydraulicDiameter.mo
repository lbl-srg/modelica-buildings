within Buildings.Fluid.FixedResistances.Examples;
model HydraulicDiameter
  "Example model for flow resistance with hydraulic diameter as parameter"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  Modelica.Blocks.Sources.Ramp P(
    duration=1,
    height=4000,
    offset=300000 - 2000)
    "Ramp pressure signal"
    annotation (Placement(transformation(extent={{-92,-2},{-72,18}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    T=273.15 + 20,
    use_p_in=true,
    nPorts=3)
    "Pressure boundary condition"
    annotation (Placement(transformation(
          extent={{-50,-10},{-30,10}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    nPorts=3,
    p(displayUnit="Pa") = 300000)
    "Pressure boundary condition"
    annotation (Placement(transformation(
          extent={{50,-10},{30,10}})));

  Buildings.Fluid.FixedResistances.HydraulicDiameter resCon(
    redeclare package Medium = Medium,
    m_flow_nominal=0.2,
    length=1,
    dh=0.027, 
    roughness=0.001e-3,
    kMinor=0,
    fluidProperties=Buildings.Fluid.Types.FluidProperties.Constant,
    rhoMed=998.2,
    muMed=1.002e-3,computePressureDrop = true)
    "Resistance with user-specified constant fluid properties"
    annotation (Placement(transformation(extent={{-10,32},{10,52}})));

  Buildings.Fluid.FixedResistances.HydraulicDiameter resDefT(
    redeclare package Medium = Medium,
    m_flow_nominal=0.2,
    length=1,
    dh=0.027,   
    roughness=0.001e-3,
    kMinor=0,
    fluidProperties=Buildings.Fluid.Types.FluidProperties.DefaultTemperature,
    T_ref=293.15)
    "Resistance with fluid properties evaluated at a fixed reference temperature"
    annotation (Placement(transformation(extent={{-10.0,-10.0},{10.0,10.0}},rotation = 0.0,origin = {0.0,0.0})));

  Buildings.Fluid.FixedResistances.HydraulicDiameter resActT(
    redeclare package Medium = Medium,
    m_flow_nominal=0.2,
    length=1,
    dh=0.027, 
    roughness=0.001e-3,
    kMinor=0,
    fluidProperties=Buildings.Fluid.Types.FluidProperties.ActualTemperature)
    "Resistance with fluid properties evaluated from the current fluid temperature"
    annotation (Placement(transformation(extent={{-10,-48},{10,-28}})));

equation
  connect(P.y, sou.p_in)
    annotation (Line(points={{-71,8},{-62,8},{-52,8}},
                    color={0,0,127}));

  connect(sou.ports[1], resCon.port_a)
    annotation (Line(points={{-30,2},{-20,2},{-20,42},{-10,42}},
                    color={0,127,255}));
  connect(resCon.port_b, sin.ports[1])
    annotation (Line(points={{10,42},{20,42},{20,2},{30,2}},
                    color={0,127,255}));

  connect(sou.ports[2], resDefT.port_a)
    annotation (Line(points={{-30,0},{-10,0}},
                    color={0,127,255}));
  connect(resDefT.port_b, sin.ports[2])
    annotation (Line(points={{10,0},{30,0}},
                    color={0,127,255}));

  connect(sou.ports[3], resActT.port_a)
    annotation (Line(points={{-30,-2},{-20,-2},{-20,-38},{-10,-38}},
                    color={0,127,255}));
  connect(resActT.port_b, sin.ports[3])
    annotation (Line(points={{10,-38},{20,-38},{20,-2},{30,-2}},
                    color={0,127,255}));

  annotation (
    experiment(Tolerance=1e-6, StopTime=1.0),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Examples/HydraulicDiameter.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example model for a fixed resistance that computes the pressure drop from pipe
geometry using a Darcy-Weisbach pressure loss calculation.
</p>
<p>
The example compares three options for evaluating the fluid properties used in
the pressure drop calculation:
</p>
<ul>
<li>
<code>resCon</code> uses user-specified constant density and dynamic viscosity.
</li>
<li>
<code>resDefT</code> evaluates density and dynamic viscosity at the fixed
reference temperature <code>T_ref</code>.
</li>
<li>
<code>resActT</code> evaluates density and dynamic viscosity from the current
fluid temperature.
</li>
</ul>
<p>
All three resistances use the same pipe geometry and are connected between the
same pressure boundaries. The source pressure is ramped so that the pressure
difference changes sign during the simulation.
</p>
</html>", revisions="<html>
<ul>
<li>
August 7, 2026, by Lone Meertens:<br/>
Updated the example for the Darcy-Weisbach implementation.
The example now compares the available fluid-property evaluation options.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4687\">Buildings, #4687</a>.
</li>
<li>
September 21, 2018, by Michael Wetter:<br/>
Updated example to add a large diameter pipe, and to use water.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1026\">#1026</a>.
</li>
<li>
December 1, 2016, by Michael Wetter:<br/>
First implementation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/480\">#480</a>.
</li>
</ul>
</html>"));
end HydraulicDiameter;
