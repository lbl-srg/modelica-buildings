within Buildings.Fluid.Interfaces.Examples;
model ConservationEquation "Model that tests the conservation equation"
extends Modelica.Icons.Example;
 package Medium = Buildings.Media.Water "Medium model";
  Buildings.Fluid.Interfaces.ConservationEquation dyn(redeclare package Medium =
        Medium, energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=2,
    fluidVolume=0.01) "Dynamic conservation equation"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));

  Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation ste(
    redeclare package Medium = Medium,
    m_flow_nominal=0.01,
    sensibleOnly=false,
    show_T=true) "Steady-state conservation equation"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));

  Modelica.Blocks.Sources.Constant mWat_flow(k=0)
    "Water mass flow rate added to the control volume"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.TimeTable QSen_flow(startTime=0, table=[
                                0,-100;
                                900,-100;
                                900,0;
                                1800,0;
                                1800,100])
    "Sensible heat flow rate added to the control volume"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    nPorts=2,
    use_p_in=false,
    redeclare package Medium = Medium,
    p=101325,
    T=283.15)
      annotation (Placement(
        transformation(extent={{80,-68},{60,-48}})));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res1(
    from_dp=true,
    redeclare package Medium = Medium,
    m_flow_nominal=0.01,
    dp_nominal=100) "Flow resistance"
      annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T bou(
    nPorts=2,
    redeclare package Medium = Medium,
    m_flow=0.01) "Boundary condition for mass flow rate"
    annotation (Placement(transformation(extent={{-80,-68},{-60,-48}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res2(
    from_dp=true,
    redeclare package Medium = Medium,
    m_flow_nominal=0.01,
    dp_nominal=100) "Flow resistance"
             annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

equation
  connect(QSen_flow.y, dyn.Q_flow) annotation (Line(
      points={{-59,70},{-48,70},{-48,46},{-12,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWat_flow.y, dyn.mWat_flow) annotation (Line(
      points={{-59,30},{-40,30},{-40,42},{-12,42}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(bou.ports[1], dyn.ports[1]) annotation (Line(
      points={{-60,-56},{-54,-56},{-54,20},{-2,20},{-2,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res1.port_b, sin.ports[1]) annotation (Line(
      points={{40,0},{52,0},{52,-56},{60,-56}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(QSen_flow.y, ste.Q_flow) annotation (Line(
      points={{-59,70},{-48,70},{-48,-52},{-12,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWat_flow.y, ste.mWat_flow) annotation (Line(
      points={{-59,30},{-40,30},{-40,-56},{-12,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(res2.port_b, sin.ports[2]) annotation (Line(
      points={{40,-60},{60,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ste.port_a, bou.ports[2]) annotation (Line(
      points={{-10,-60},{-60,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ste.port_b, res2.port_a) annotation (Line(
      points={{10,-60},{20,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dyn.ports[2], res1.port_a) annotation (Line(
      points={{2,30},{0,30},{0,0},{20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
  experiment(StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Interfaces/Examples/ConservationEquation.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
Model that tests the conservation equations that are used
for the heat and mass balance.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 11, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConservationEquation;
