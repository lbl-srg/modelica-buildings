within Buildings.Fluid.AirFilters.BaseClasses.Validation;
model PressureDropWithVaryingFlowCoefficient
  "Validation model for flow resistances with a varying flow coefficient"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air
    "Air";
  Modelica.Blocks.Sources.Ramp P(
    duration=1,
    height=20,
    offset=101325 - 10)
    "Ramp pressure signal"
    annotation (Placement(transformation(extent={{-92,-2},{-72,18}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    T=273.15 + 20,
    use_p_in=true,
    nPorts=2)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    nPorts=2,
    p(displayUnit="Pa") = 101325)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{50,-10},{30,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop resFixed(
    redeclare package Medium = Medium,
    m_flow_nominal=0.2,
    from_dp=true,
    dp_nominal=10)
    "Fixed resistance"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.AirFilters.BaseClasses.PressureDropWithVaryingFlowCoefficient
    resVarying(
    redeclare package Medium = Medium,
    m_flow_nominal=0.2,
    dp_nominal=10)
    "Varying resistance"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Modelica.Blocks.Sources.Pulse kCor(
    width=100,
    period=0.5,
    offset=1,
    startTime=0.5)
    "Flow coefficient correction factor"
    annotation (Placement(transformation(extent={{-80,62},{-60,82}})));
equation
  connect(P.y, sou.p_in)
    annotation (Line(points={{-71,8},{-62,8},{-52,8}},color={0,0,127}));
  connect(sou.ports[1], resFixed.port_a)
    annotation (Line(points={{-30,-1},{-20,-1},{-20,0},{-10,0}}, color={0,127,255}));
  connect(resFixed.port_b, sin.ports[1])
    annotation (Line(points={{10,0},{10,-1},{30,-1}}, color={0,127,255}));
  connect(resVarying.port_a, sou.ports[2])
    annotation (Line(points={{-10,40},{-20,40},{-20,1},{-30,1}}, color={0,127,255}));
  connect(resVarying.port_b, sin.ports[2])
    annotation (Line(points={{10,40},{18,40},{18,1},{30,1}}, color={0,127,255}));
  connect(kCor.y, resVarying.kCor)
    annotation (Line(points={{-59,72},{0,72},{0,52}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/AirFilters/BaseClasses/Validation/PressureDropWithVaryingFlowCoefficient.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Before 0.5 seconds, the flow rates of the <code>resFixed</code> (pressure
resistance with a constant flow coefficient) and the <code>resVarying</code>
(pressure resistance with a varying flow coefficient) are the same with the
identical pressure drop.
</p>
<p>
After 0.5 seconds, the flow rate of the <code>resVarying</code> is lower than
that of <code>resFixed</code> as the flow coefficient 
of the former decreases by &radic;<span style=\"text-decoration:overline;\">2</span>.      
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end PressureDropWithVaryingFlowCoefficient;
