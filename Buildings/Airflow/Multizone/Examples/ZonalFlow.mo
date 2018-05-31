within Buildings.Airflow.Multizone.Examples;
model ZonalFlow "Model with prescribed air exchange between two volumes"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air;
  parameter Modelica.SIunits.Volume volA=100 "Volume of room A";
  parameter Modelica.SIunits.Volume volB=1 "Volume of room B";
  Buildings.Fluid.MixingVolumes.MixingVolume rooA(
    V=volA,
    redeclare package Medium = Medium,
    X_start={0.015,0.985},
    T_start=303.15,
    nPorts=4,
    m_flow_nominal=0.001,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Room A"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Fluid.MixingVolumes.MixingVolume rooB(
    V=volB,
    redeclare package Medium = Medium,
    X_start={0.01,0.99},
    T_start=293.15,
    nPorts=4,
    m_flow_nominal=0.001,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Room B"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Modelica.Blocks.Sources.Constant ACS(k=5/3600) "Air change rate per second"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  ZonalFlow_ACS zonFlo(
    redeclare package Medium = Medium,
    V=min(volA, volB))
    "Model for prescribed flow exchange between two volume with air change per second as input"
    annotation (Placement(transformation(extent={{-10,-2},{10,18}})));
  Modelica.Blocks.Sources.Constant m_flow(k=0.02) "Exchange mass flow rate"
    annotation (Placement(transformation(extent={{-48,-32},{-28,-12}})));
  ZonalFlow_m_flow floExc(redeclare package Medium = Medium)
    "Model for prescribed flow exchange between two volumes with mass flow rate as inputs"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
equation
  connect(rooA.ports[1], zonFlo.port_a1) annotation (Line(
      points={{-73,20},{-73,14},{-10,14}},
      color={0,127,255}));
  connect(zonFlo.port_b1, rooB.ports[1]) annotation (Line(
      points={{10,14},{47,14},{47,20}},
      color={0,127,255}));
  connect(zonFlo.port_b2, rooA.ports[2]) annotation (Line(
      points={{-10,2},{-71,2},{-71,20}},
      color={0,127,255}));
  connect(zonFlo.port_a2, rooB.ports[2]) annotation (Line(
      points={{10,2},{49,2},{49,20}},
      color={0,127,255}));
  connect(zonFlo.ACS, ACS.y) annotation (Line(points={{-11,18},{-20,18},{-20,40},
          {-29,40}}, color={0,0,127}));
  connect(floExc.mAB_flow, m_flow.y) annotation (Line(points={{-11,-40},{-20,-40},
          {-20,-22},{-27,-22}}, color={0,0,127}));
  connect(m_flow.y, floExc.mBA_flow) annotation (Line(points={{-27,-22},{20,-22},
          {20,-60},{11,-60}}, color={0,0,127}));
  connect(floExc.port_a1, rooA.ports[3]) annotation (Line(points={{-10,-44},{-69,
          -44},{-69,20}}, color={0,127,255}));
  connect(floExc.port_b1, rooB.ports[3])
    annotation (Line(points={{10,-44},{51,-44},{51,20}}, color={0,127,255}));
  connect(floExc.port_a2, rooB.ports[4])
    annotation (Line(points={{10,-56},{53,-56},{53,20}}, color={0,127,255}));
  connect(floExc.port_b2, rooA.ports[4]) annotation (Line(points={{-10,-56},{-67,
          -56},{-67,20}}, color={0,127,255}));
  annotation (
experiment(Tolerance=1e-06, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Examples/ZonalFlow.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example illustrates the use of the models that
exchange a prescribed flow rate between the
volumes that are attached to it.
The block <code>ACS</code> prescribes the air exchange rate to
5 air changes per hour.
The instance <code>zonFlo</code> takes as an input the air change per seconds,
and the instance <code>floExc</code> takes as inputs the mass flow rate.
For both instances, the air flows from
<code>rooA</code> to <code>rooB</code>, and
from <code>rooB</code> to <code>rooA</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 30, 2018, by Michael Wetter:<br/>
Added example for instace of
<a href=\"modelica://Buildings.Airflow.Multizone.ZonalFlow_m_flow\">Buildings.Airflow.Multizone.ZonalFlow_m_flow</a>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
November 10, 2011, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end ZonalFlow;
