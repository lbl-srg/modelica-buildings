within Buildings.Airflow.Multizone.Examples;
model OneOpenDoor "Model with one open and one closed door"
  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Air.SimpleAir;

  Buildings.Airflow.Multizone.DoorDiscretizedOpen dooOpe(
    redeclare package Medium = Medium) "Discretized door"
    annotation (Placement(transformation(extent={{10,-8},{30,12}})));

  Buildings.Fluid.MixingVolumes.MixingVolume volA(
    redeclare package Medium = Medium,
    V=2.5*5*5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=4,
    m_flow_nominal=0.01) "Control volume"
    annotation (Placement(transformation(extent={{-32,14},{-12,34}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volB(
    redeclare package Medium = Medium,
    V=2.5*5*5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=4,
    m_flow_nominal=0.01) "Control volume"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    "Prescribed heat flow rate boundary condition"
    annotation (Placement(transformation(extent={{14,60},{34,80}})));
  Modelica.Blocks.Sources.Sine heaSou(f=1/3600)
    "Signal for heat flow rate boundary condition"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Math.Gain gai(k=100)
    "Gain for heat flow rate boundary condition"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Buildings.Airflow.Multizone.DoorDiscretizedOperable dooOpeClo(redeclare package
      Medium = Medium, LClo=20*1E-4) "Discretized door"
    annotation (Placement(transformation(extent={{10,-44},{30,-24}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=120,
    height=1,
    offset=0,
    startTime=1000) "Ramp signal for door opening"
                    annotation (Placement(transformation(extent={{-60,-44},{-40,
            -24}})));
equation
  connect(gai.y, preHeaFlo.Q_flow)
    annotation (Line(points={{1,70},{14,70}}, color={0,0,255}));
  connect(heaSou.y, gai.u)
    annotation (Line(points={{-39,70},{-39,70},{-22,70}}, color={0,0,255}));
  connect(ramp.y, dooOpeClo.y) annotation (Line(points={{-39,-34},{-39,-34},{9,-34}},
                              color={0,0,255}));
  connect(preHeaFlo.port, volB.heatPort) annotation (Line(
      points={{34,70},{60,70}},
      color={191,0,0}));
  connect(volA.ports[1], dooOpeClo.port_b2) annotation (Line(
      points={{-25,14},{-25,-40},{10,-40}},
      color={0,127,255}));
  connect(volA.ports[2], dooOpeClo.port_a1) annotation (Line(
      points={{-23,14},{-23,-28},{10,-28}},
      color={0,127,255}));
  connect(volA.ports[3], dooOpe.port_b2) annotation (Line(
      points={{-21,14},{-21,-4},{10,-4}},
      color={0,127,255}));
  connect(volA.ports[4], dooOpe.port_a1) annotation (Line(
      points={{-19,14},{-19,8},{10,8}},
      color={0,127,255}));
  connect(volB.ports[1], dooOpe.port_b1) annotation (Line(
      points={{67,60},{67,8},{30,8}},
      color={0,127,255}));
  connect(volB.ports[2], dooOpe.port_a2) annotation (Line(
      points={{69,60},{72,60},{72,-4},{30,-4}},
      color={0,127,255}));
  connect(volB.ports[3], dooOpeClo.port_b1) annotation (Line(
      points={{71,60},{68,60},{68,-28},{30,-28}},
      color={0,127,255}));
  connect(volB.ports[4], dooOpeClo.port_a2) annotation (Line(
      points={{73,60},{73,-40},{30,-40}},
      color={0,127,255}));
  annotation (
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Examples/OneOpenDoor.mos"
        "Simulate and plot"),
    experiment(
      StopTime=7200,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
This model consists of two doors with the same geometry.
For <i>t &le; 1000</i> seconds, the door <code>dooOpeClo</code>
is closed, and afterwards it is open. The door
<code>dooOpe</code> is always open.
Heat is added to the volume <code>volB</code>, which causes
a density difference between <code>volA</code> and <code>volB</code>.
This density difference induces a bi-directional airflow through both doors.
Both doors have exactly the same bi-directional airflow rates.
</p>
</html>", revisions="<html>
<ul>
<li>
March 26, 2021 by Michael Wetter:<br/>
Updated comments for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/515\">IBPSA, #515</a>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code>.
</li>
<li>
November 10, 2011, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end OneOpenDoor;
