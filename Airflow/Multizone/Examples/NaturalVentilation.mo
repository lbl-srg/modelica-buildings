within Buildings.Airflow.Multizone.Examples;
model NaturalVentilation
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.IdealGases.SimpleAir;

  Buildings.Fluid.MixingVolumes.MixingVolume volA(
    redeclare package Medium = Medium,
    V=2.5*10*5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 18,
    nPorts=2,
    m_flow_nominal=0.001)
    annotation (Placement(transformation(extent={{-10,-20},{10,0}},
                                                                  rotation=0)));

  Buildings.Airflow.Multizone.Orifice oriOutBot(
    redeclare package Medium = Medium,
    A=0.1,
    m=0.5,
    dp_turbulent=0.1) annotation (Placement(transformation(extent={{20,-30},{40,
            -10}}, rotation=0)));
  Buildings.Airflow.Multizone.MediumColumn colOut(
    redeclare package Medium = Medium,
    h=3,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{71,10},{91,30}},  rotation=0)));
  Buildings.Airflow.Multizone.Orifice oriOutTop(
    redeclare package Medium = Medium,
    A=0.1,
    m=0.5,
    dp_turbulent=0.1) annotation (Placement(transformation(extent={{23,40},{43,60}},
                  rotation=0)));
  Buildings.Airflow.Multizone.MediumColumn colRooTop(
    redeclare package Medium = Medium,
    h=3,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{-30,10},{-9,30}},rotation=0)));
  Buildings.Fluid.MixingVolumes.MixingVolume volOut(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V=1E10,
    T_start=273.15 + 20,
    nPorts=2,
    m_flow_nominal=0.001)
              annotation (Placement(transformation(extent={{53,-20},{73,0}},
          rotation=0)));

  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    annotation (Placement(transformation(extent={{-49,-20},{-29,0}}, rotation=0)));
  Modelica.Blocks.Sources.Step q_flow(
    height=-100,
    offset=100,
    startTime=3600) annotation (Placement(transformation(extent={{-84,-20},{-64,
            0}}, rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
equation
  connect(q_flow.y, preHeaFlo.Q_flow)
    annotation (Line(points={{-63,-10},{-49,-10}}, color={0,0,255}));
  connect(oriOutBot.port_b, volOut.ports[1]) annotation (Line(
      points={{40,-20},{61,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(preHeaFlo.port, volA.heatPort) annotation (Line(
      points={{-29,-10},{-10,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(volA.ports[1], oriOutBot.port_a) annotation (Line(
      points={{-2,-20},{20,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volA.ports[2], colRooTop.port_b) annotation (Line(
      points={{2,-20},{-20,-20},{-20,10},{-19.5,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colRooTop.port_a, oriOutTop.port_a) annotation (Line(
      points={{-19.5,30},{-20,30},{-20,50},{23,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volOut.ports[2], colOut.port_b) annotation (Line(
      points={{65,-20},{81,-20},{81,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colOut.port_a, oriOutTop.port_b) annotation (Line(
      points={{81,30},{82,30},{82,50},{43,50}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{200,
            100}})),
experiment(StopTime=7200),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Examples/NaturalVentilation.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model illustrates buoyancy-driven natural ventilation between 
two volumes of air.
The volume <code>volA</code> can be considered as the volume of a room,
and the volume <code>volOut</code> is parameterized to be very large to emulate
outside air.
The outside air is <i>20</i>&deg;C and at initial time, the room air is
<i>18</i>&deg;C.
This induces an airflow in counter clock-wise direction. Since
heat is added to the room air volume, its temperature raises above the temperature of the outside, which causes the air flow to reverse its direction.
</p>
</html>", revisions="<html>
<ul>
<li>
November 10, 2011, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end NaturalVentilation;
