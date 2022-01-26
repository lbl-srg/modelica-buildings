within Buildings.Fluid.FixedResistances.Validation;
model PressureDropsSeries "Test of multiple resistances in series"
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.Air "Medium model";

   parameter Integer nRes(min=2) = 10 "Number of resistances";

  parameter Modelica.Units.SI.PressureDifference dp_nominal=5
    "Nominal pressure drop for each resistance";

   Modelica.Blocks.Sources.Ramp P(
    duration=1,
    height=2*dp_nominal*nRes,
    offset=101325 - dp_nominal*nRes) "Signal source"
                 annotation (Placement(transformation(extent={{-80,28},{-60,48}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    T=273.15 + 20,
    use_p_in=true,
    nPorts=1) "Pressure boundary condition"
      annotation (Placement(transformation(
          extent={{-40,20},{-20,40}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    nPorts=1,
    p(displayUnit="Pa") = 101325) "Pressure boundary condition"
      annotation (Placement(transformation(
          extent={{56,20},{36,40}})));

  Buildings.Fluid.FixedResistances.PressureDrop[nRes] res(
    redeclare each package Medium = Medium,
    each dp_nominal=dp_nominal,
    each from_dp=false,
    each m_flow_nominal=2) "Flow resistance"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

equation
  for i in 1:nRes-1 loop
    connect(res[i].port_b, res[i+1].port_a) annotation (Line(points={{20,30},{26,
            30},{26,10},{-8,10},{-8,30},{-5.55112e-16,30}},  color={0,127,255}));
  end for;
  connect(P.y, sou.p_in) annotation (Line(points={{-59,38},{-52,38},{-42,38}},
                    color={0,0,127}));
  connect(sin.ports[1], res[nRes].port_b) annotation (Line(
      points={{36,30},{20,30}},
      color={0,127,255}));
  connect(sou.ports[1], res[1].port_a) annotation (Line(
      points={{-20,30},{-5.55112e-16,30}},
      color={0,127,255}));
  annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Validation/PressureDropsSeries.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model tests multiple resistances in series.
</p>
</html>", revisions="<html>
<ul>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PressureDropsSeries;
