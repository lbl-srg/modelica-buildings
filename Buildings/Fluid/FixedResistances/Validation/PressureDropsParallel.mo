within Buildings.Fluid.FixedResistances.Validation;
model PressureDropsParallel
   "Test with multiple resistances in parallel"
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.Water "Medium model";

    Modelica.Blocks.Sources.Ramp P(
      duration=1,
      height=20,
      offset=101315) "Signal source"
                 annotation (Placement(transformation(extent={{-92,36},{-72,56}})));

  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium,
    m_flow_nominal=5,
    dp_nominal=10,
    deltaM=0.3,
    linearized=false,
    from_dp=true) "Flow resistance"
    annotation (Placement(transformation(extent={{-28,30},{-8,50}})));

  Buildings.Fluid.Sources.Boundary_pT sou1(
    redeclare package Medium = Medium,
    nPorts=2,
    use_p_in=true,
    T=293.15) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{-60,28},
            {-40,48}})));

  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium,
    nPorts=2,
    p(displayUnit="Pa") = 101325,
    T=283.15) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{80,28},
            {60,48}})));

  Buildings.Fluid.FixedResistances.PressureDrop res2(
    redeclare package Medium = Medium,
    m_flow_nominal=5,
    dp_nominal=10,
    deltaM=0.3,
    linearized=false,
    from_dp=true) "Flow resistance"
    annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));

  Buildings.Fluid.Sensors.MassFlowRate masFlo2(redeclare package Medium = Medium)
    "Mass flow rate sensor" annotation (Placement(transformation(extent={{0,-10},
            {20,10}})));
  Buildings.Utilities.Diagnostics.AssertEquality assEqu(
    message="Inputs differ, check that lossless pipe is correctly implemented.",
      threShold=1E-4)
    "Assert equality of the two mass flow rates"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Buildings.Fluid.Sensors.MassFlowRate masFlo1(redeclare package Medium = Medium)
    "Mass flow rate sensor" annotation (Placement(transformation(extent={{20,30},
            {40,50}})));

equation
  connect(P.y, sou1.p_in) annotation (Line(points={{-71,46},{-62,46}},
                    color={0,0,127}));
  connect(res2.port_b, masFlo2.port_a) annotation (Line(points={{-8,6.10623e-16},
          {-4,-3.36456e-22},{-4,6.10623e-16},{-5.55112e-16,6.10623e-16}},
                          color={0,127,255}));
  connect(res1.port_b, masFlo1.port_a)
    annotation (Line(points={{-8,40},{20,40}},color={0,127,255}));
  connect(sou1.ports[1], res1.port_a) annotation (Line(
      points={{-40,40},{-28,40}},
      color={0,127,255}));
  connect(sou1.ports[2], res2.port_a) annotation (Line(
      points={{-40,36},{-34,36},{-34,6.10623e-16},{-28,6.10623e-16}},
      color={0,127,255}));
  connect(sin1.ports[1], masFlo1.port_b) annotation (Line(
      points={{60,40},{40,40}},
      color={0,127,255}));
  connect(sin1.ports[2], masFlo2.port_b) annotation (Line(
      points={{60,36},{52,36},{52,6.10623e-16},{20,6.10623e-16}},
      color={0,127,255}));
  connect(masFlo2.m_flow, assEqu.u1) annotation (Line(
      points={{10,11},{10,76},{38,76}},
      color={0,0,127}));
  connect(masFlo1.m_flow, assEqu.u2) annotation (Line(
      points={{30,51},{30,64},{38,64}},
      color={0,0,127}));

annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Validation/PressureDropsParallel.mos" "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests two resistances in parallel.
</p>
</html>", revisions="<html>
<ul>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PressureDropsParallel;
