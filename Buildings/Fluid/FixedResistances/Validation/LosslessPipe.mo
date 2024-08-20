within Buildings.Fluid.FixedResistances.Validation;
model LosslessPipe "Validation model for lossless pipe"
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.Air "Medium model";

  Modelica.Blocks.Sources.Ramp m_flow(
    duration=1,
    offset=-1,
    height=2)  "Mass flow source"
    annotation (Placement(transformation(extent={{-92,-2},{-72,18}})));

  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=true,
    T=273.15 + 20)
    "Pressure boundary condition"
    annotation (Placement(transformation(
          extent={{-50,-10},{-30,10}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    nPorts=1,
    p(displayUnit="Pa") = 101325)
    "Pressure boundary condition"
    annotation (Placement(transformation(
          extent={{90,-10},{70,10}})));

  Buildings.Fluid.FixedResistances.LosslessPipe res(
    redeclare package Medium = Medium,
    show_T=true,
    m_flow_nominal=1)
    "Fixed resistance"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTemIn(
    redeclare final package Medium = Medium,
    m_flow_nominal=res.m_flow_nominal,
    tau=0) "Temperature sensor at the inlet"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemOut(
    redeclare final package Medium = Medium,
    m_flow_nominal=res.m_flow_nominal,
    tau=0) "Temperature sensor at the outlet"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(m_flow.y, sou.m_flow_in)
    annotation (Line(points={{-71,8},{-52,8},{-52,8}},   color={0,0,127}));
  connect(sou.ports[1], senTemIn.port_a)
    annotation (Line(points={{-30,0},{-20,0}}, color={0,127,255}));
  connect(senTemIn.port_b, res.port_a)
    annotation (Line(points={{0,0},{10,0}}, color={0,127,255}));
  connect(res.port_b, senTemOut.port_a)
    annotation (Line(points={{30,0},{40,0}}, color={0,127,255}));
  connect(senTemOut.port_b, sin.ports[1])
    annotation (Line(points={{60,0},{70,0}}, color={0,127,255}));
  annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Validation/LosslessPipe.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation model for a the pipe model with no friction and no heat loss.
</p>
</html>", revisions="<html>
<ul>
<li>
August 5, 2024, by Hongxiang Fu:<br/>
Added two-port temperature sensors to replace <code>sta_*.T</code>
in reference results. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1913\">IBPSA #1913</a>.
</li>
<li>
December 1, 2016, by Michael Wetter:<br/>
First implementation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/480\">#480</a>.
</li>
</ul>
</html>"));
end LosslessPipe;
