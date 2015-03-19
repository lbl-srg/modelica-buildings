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
    nPorts=2,
    m_flow_nominal=0.001,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Room A"
                       annotation (Placement(transformation(extent={{-80,0},{-60,
            20}})));
  Buildings.Fluid.MixingVolumes.MixingVolume rooB(
    V=volB,
    redeclare package Medium = Medium,
    X_start={0.01,0.99},
    T_start=293.15,
    nPorts=2,
    m_flow_nominal=0.001,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Room B"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Modelica.Blocks.Sources.Constant ACS_con(k=5/3600) annotation (Placement(
        transformation(extent={{-98,48},{-78,68}})));
  ZonalFlow_ACS zonFlo(redeclare package Medium = Medium, V=min(volA, volB))
    annotation (Placement(transformation(extent={{-10,-22},{10,-2}})));
equation
  connect(rooA.ports[1], zonFlo.port_a1) annotation (Line(
      points={{-72,-5.55112e-16},{-72,-6},{-10,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zonFlo.port_b1, rooB.ports[1]) annotation (Line(
      points={{10,-6},{48,-6},{48,-5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zonFlo.port_b2, rooA.ports[2]) annotation (Line(
      points={{-10,-18},{-68,-18},{-68,-5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zonFlo.port_a2, rooB.ports[2]) annotation (Line(
      points={{10,-18},{52,-18},{52,-5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zonFlo.ACS, ACS_con.y) annotation (Line(
      points={{-11,-2},{-20,-2},{-20,58},{-77,58}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
experiment(StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Examples/ZonalFlow.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example illustrates the use of the model that
exchanges a prescribed air exchange rate between the
volumes that are attached to it.
The constant block prescribes the air exchange rate to
5 air changes per hour.
This amount of air flows from
<code>rooA</code> to <code>rooB</code>, and
from <code>rooB</code> to <code>rooA</code>.
</p>
</html>", revisions="<html>
<ul>
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
