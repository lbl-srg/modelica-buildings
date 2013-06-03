within Buildings.Airflow.Multizone.Examples;
model Validation1Room
  "Model with one room for the validation of the multizone air exchange models"

  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.IdealGases.SimpleAir;

  Buildings.Fluid.MixingVolumes.MixingVolume volEas(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 20,
    V=2.5*5*5,
    nPorts=2,
    m_flow_nominal=0.001,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={8,-10})));

  Buildings.Airflow.Multizone.Orifice oriOutBot(
    redeclare package Medium = Medium,
    A=0.01,
    m=0.5) annotation (Placement(transformation(extent={{38,-72},{58,-52}},
          rotation=0)));
  Buildings.Airflow.Multizone.MediumColumn colOutTop(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{69,10},{89,30}}, rotation=0)));
  Buildings.Airflow.Multizone.Orifice oriOutTop(
    redeclare package Medium = Medium,
    A=0.01,
    m=0.5) annotation (Placement(transformation(extent={{39,30},{59,50}},
          rotation=0)));
  Buildings.Airflow.Multizone.MediumColumn colEasInTop(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{11,10},{31,30}}, rotation=0)));
  Buildings.Fluid.MixingVolumes.MixingVolume volOut(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 10,
    V=1E12,
    p_start=Medium.p_default,
    nPorts=2,
    m_flow_nominal=0.001,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={89,-10})));

  Buildings.Airflow.Multizone.MediumColumn colEasInBot(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    annotation (Placement(transformation(extent={{10,-50},{30,-30}},rotation=0)));
  Buildings.Airflow.Multizone.MediumColumn colOutBot(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    annotation (Placement(transformation(extent={{70,-52},{90,-32}}, rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{160,60},{180,80}})));
equation
  connect(colEasInTop.port_a, oriOutTop.port_a) annotation (Line(
      points={{21,30},{20,30},{20,40},{39,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colEasInTop.port_b, volEas.ports[1]) annotation (Line(
      points={{21,10},{20,10},{20,-12},{18,-12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colEasInBot.port_a, volEas.ports[2]) annotation (Line(
      points={{20,-30},{20,-8},{18,-8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colEasInBot.port_b, oriOutBot.port_a) annotation (Line(
      points={{20,-50},{20,-62},{38,-62}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(oriOutBot.port_b, colOutBot.port_b) annotation (Line(
      points={{58,-62},{80,-62},{80,-52}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colOutBot.port_a, volOut.ports[1]) annotation (Line(
      points={{80,-32},{80,-8},{79,-8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colOutTop.port_b, volOut.ports[2]) annotation (Line(
      points={{79,10},{79,-12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colOutTop.port_a, oriOutTop.port_b) annotation (Line(
      points={{79,30},{80,30},{80,40},{59,40}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{200,
            100}}), graphics={Rectangle(
          extent={{-52,60},{48,-88}},
          lineColor={0,0,0},
          lineThickness=1)}),
experiment(StopTime=1),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Examples/Validation1Room.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model has been used to validate buoyancy-driven air flow between two volumes.
The volume <code>volEas</code> is at <i>20</i>&deg;C and the volume 
<code>volOut</code> is at <i>10</i>&deg;C.
This initial condition induces a clock-wise airflow between the two volumes.
</p>
</html>", revisions="<html>
<ul>
<li>
November 10, 2011, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end Validation1Room;
