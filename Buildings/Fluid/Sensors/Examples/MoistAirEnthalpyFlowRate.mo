within Buildings.Fluid.Sensors.Examples;
model MoistAirEnthalpyFlowRate
  "Test model for the sensible and latent enthalpy flow rate sensors"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air;

  Buildings.Fluid.Sensors.EnthalpyFlowRate senH_flow(
    redeclare package Medium = Medium,
    m_flow_nominal=1) "Sensor for enthalpy flow rate"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1,
    T=293.15) "Flow boundary condition"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
     redeclare package Medium = Medium,
    nPorts=1,
    X={0.02,0.98},
    T=313.15) "Flow boundary condition"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-70})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-2,
    offset=1,
    duration=60)
    annotation (Placement(transformation(extent={{-90,18},{-70,38}})));

  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort senH(
    redeclare package Medium = Medium,
    m_flow_nominal=1) "Specific enthalpy sensor"
                annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare package Medium = Medium) "Mass flow rate sensor"
                annotation (Placement(transformation(extent={{28,10},{48,30}})));
  Modelica.Blocks.Math.Product pro "Product to compute enthalpy flow rate"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.Fluid.Sensors.LatentEnthalpyFlowRate senHLat_flow(
    redeclare package Medium = Medium,
    m_flow_nominal=1) "Latent enthalpy flow rate sensor"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Fluid.Sensors.SensibleEnthalpyFlowRate senHSen_flow(
    redeclare package Medium = Medium, m_flow_nominal=1)
    "Sensible enthalpy flow rate sensor"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Modelica.Blocks.Math.Add add
    "Outputs the sensible plus latent enthalpy flow rate"
    annotation (Placement(transformation(extent={{20,-46},{40,-26}})));
equation
  connect(ramp.y, sou.m_flow_in) annotation (Line(
      points={{-69,28},{-62,28},{-62,28}},
      color={0,0,127}));
  connect(sou.ports[1], senH_flow.port_a) annotation (Line(
      points={{-40,20},{-30,20}},
      color={0,127,255}));
  connect(senH_flow.port_b, senH.port_a) annotation (Line(
      points={{-10,20},{-5.55112e-16,20}},
      color={0,127,255}));
  connect(senH.port_b, senMasFlo.port_a) annotation (Line(
      points={{20,20},{28,20}},
      color={0,127,255}));
  connect(senH.h_out, pro.u1) annotation (Line(points={{10,31},{10,38},{10,76},
          {58,76}},          color={0,0,127}));
  connect(senMasFlo.m_flow, pro.u2) annotation (Line(points={{38,31},{38,48},{
          38,64},{58,64}},       color={0,0,127}));
  connect(senHLat_flow.H_flow, add.u1) annotation (Line(
      points={{-50,-59},{-50,-30},{18,-30}},
      color={0,0,127}));
  connect(senHSen_flow.H_flow, add.u2) annotation (Line(
      points={{-10,-59},{-10,-42},{18,-42}},
      color={0,0,127}));
  connect(senMasFlo.port_b, senHLat_flow.port_a) annotation (Line(
      points={{48,20},{60,20},{60,0},{-70,0},{-70,-70},{-60,-70}},
      color={0,127,255}));
  connect(senHLat_flow.port_b, senHSen_flow.port_a)
    annotation (Line(
      points={{-40,-70},{-20,-70}},
      color={0,127,255}));
  connect(senHSen_flow.port_b, sin.ports[1]) annotation (Line(
      points={{5.55112e-16,-70},{60,-70}},
      color={0,127,255}));
    annotation (
experiment(Tolerance=1e-6, StopTime=60),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Sensors/Examples/MoistAirEnthalpyFlowRate.mos"
        "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This example tests the sensible and latent enthalpy sensors.
It compares the output from the enthalpy sensor with the sum of the
sensible and latent enthalpy sensors.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 2, 2016, by Michael Wetter:<br/>
Removed assertion and added the enthalpy flow rates instead
to the plot window so that they become part of the regression tests.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/564\">issue 564</a>.
</li>
<li>
January 23 2013, by Michael Wetter:<br/>
Changed time constant of <code>senH</code> so that it has
the same transient response model as <code>senH_flow</code>.
</li>
</ul>
</html>"));
end MoistAirEnthalpyFlowRate;
