within Buildings.Fluid.Sensors.Examples;
model HeatMeter
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water
    "Medium model";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 10 "Nominal mass flow rate";

  Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    m_flow=m_flow_nominal,
    nPorts=1) "Mass flow source"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=1)
    "Sink"
    annotation (Placement(transformation(extent={{70,-10},{50,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow heaFloRat(Q_flow=
        m_flow_nominal*10*4200) "Heat flow rate"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal,
    V=0.1,
    nPorts=2)
    "Mixing volume"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  TemperatureTwoPort senT(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Fluid.Sensors.HeatMeter senHeaFlo(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
equation
  connect(sou.ports[1], senT.port_a)
    annotation (Line(points={{-50,0},{-30,0}},   color={0,127,255}));
  connect(senT.port_b, vol.ports[1]) annotation (Line(points={{-10,0},{-2,0},{
          -2,30},{-1,30}},    color={0,127,255}));
  connect(vol.ports[2], senHeaFlo.port_a) annotation (Line(points={{1,30},{2,30},
          {2,0},{10,0}},       color={0,127,255}));
  connect(senHeaFlo.port_b, sin.ports[1])
    annotation (Line(points={{30,0},{50,0}},   color={0,127,255}));
  connect(senT.T, senHeaFlo.TExt) annotation (Line(points={{-20,11},{-20,18},{
          -6,18},{-6,6},{8,6}},     color={0,0,127}));
  connect(heaFloRat.port, vol.heatPort)
    annotation (Line(points={{-30,40},{-10,40}}, color={191,0,0}));
    annotation (
experiment(Tolerance=1e-6, StopTime=60),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Sensors/Examples/HeatMeter.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example tests the heat meter sensor for the situation where heat is exchanged with a control volume.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 1, 2024, by Michael Wetter:<br/>
Revised implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1831\">IBPSA, #1831</a>.
</li>
<li>
February 1, 2024, by Jan Gall:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1831\">IBPSA, #1831</a>.
</li>
</ul>
</html>"));
end HeatMeter;
