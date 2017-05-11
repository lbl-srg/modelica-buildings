within Buildings.Fluid.Interfaces.Examples;
model PrescribedOutletState_TX
  "Test model for prescribed outlet state: temperature and humidity"
  import Buildings;
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air;

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.1
    "Nominal mass flow rate";

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_T_in=false,
    p(displayUnit="Pa"),
    T=293.15,
    nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=180,origin={100,0})));
  Buildings.Fluid.Interfaces.PrescribedOutletState_TX
                                                   heaHigPow(
    redeclare package Medium = Medium,
    Q_flow_maxHeat=1.0e10,
    m_flow_small=1E-4*abs(m_flow_nominal),
    show_T=true,
    m_flow_nominal=m_flow_nominal)
    "Steady-state model of the heater with high capacity"
    annotation (Placement(transformation(extent={{-10,76},{10,96}})));
  Modelica.Blocks.Sources.TimeTable TSetHeat(table=[0,273.15 + 30.0; 120,273.15
         + 30.0; 120,273.15 + 30.0; 500,273.15 + 30.0; 500,273.15 + 30.0; 1200,
        273.15 + 30.0])
    "Setpoint heating"
    annotation (Placement(transformation(extent={{-60,126},{-40,146}})));
  Modelica.Blocks.Sources.Ramp m_flow(
    height=-2*m_flow_nominal,
    duration=100,
    offset=m_flow_nominal,
    startTime=1000) "Mass flow rate"
    annotation (Placement(transformation(extent={{-130,-2},{-110,18}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=293.15,
    nPorts=1) "Flow source"
    annotation (Placement(transformation(extent={{-90,76},{-70,96}})));
  Modelica.Blocks.Sources.RealExpression masFra[Medium.nXi](y=0.015)
    annotation (Placement(transformation(extent={{-60,52},{-40,72}})));
equation

  connect(TSetHeat.y,heaHigPow. TSet) annotation (Line(
      points={{-39,136},{-30,136},{-30,94},{-12,94}},
      color={0,0,127}));
  connect(m_flow.y, sou1.m_flow_in) annotation (Line(
      points={{-109,8},{-100,8},{-100,94},{-90,94}},
      color={0,0,127}));
  connect(sou1.ports[1], heaHigPow.port_a) annotation (Line(
      points={{-70,86},{-10,86}},
      color={0,127,255}));
  connect(masFra.y, heaHigPow.XiSet) annotation (Line(points={{-39,62},{-30,62},
          {-30,90},{-12,90}}, color={0,0,127}));
  connect(sin.ports[1], heaHigPow.port_b) annotation (Line(points={{90,0},{52,0},
          {52,86},{10,86}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -120},{120,160}})),
    experiment(Tolerance=1e-6, StopTime=1200),
__Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Interfaces/Examples/PrescribedOutletState.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Model that demonstrates the use of an ideal heater and an ideal cooler.
</p>
<p>
The heater model has an almost unlimited positive capacity (<code>Q_flow_nominal = 1.0e10</code> Watts),
and hence its outlet temperature always reaches the set point temperatures.
</p>
<p>
The cooler model has a limited negative capacitiy (<code>Q_flow_nominal = 1000</code> Watts), and hence
its outlet temperature reaches only a limited value corresponding to its
maximum negative capacity.
</p>
<p>
There is also a heater and cooler with unlimited capacity.
</p>
<p>
At <i>t=1000</i> second, the flow reverses its direction.
</p>
<p>
Each flow leg has the same mass flow rate. There are three mass flow sources
as using one source only would yield a nonlinear system of equations that
needs to be solved to determine the mass flow rate distribution.
</p>
<p>
The heater and cooler models have the parameter <code>show_T</code> set to <code>true</code>
to allow inspecting the temperatures at their ports.
</p>
</html>", revisions="<html>
<ul>
<li>
November 11, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PrescribedOutletState_TX;
