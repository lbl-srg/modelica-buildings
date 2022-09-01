within Buildings.Airflow.Multizone.Examples;
model OneRoom
  "Model with one room for the validation of the multizone air exchange models"

  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air;

  Buildings.Fluid.MixingVolumes.MixingVolume volEas(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 20,
    V=2.5*5*5,
    nPorts=2,
    m_flow_nominal=0.001,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    "Control volume for room"                                      annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,-10})));

  Buildings.Airflow.Multizone.Orifice oriOutBot(
    redeclare package Medium = Medium,
    A=0.01,
    m=0.5) "Orifice at bottom"
           annotation (Placement(transformation(extent={{0,-72},{20,-52}})));
  Buildings.Airflow.Multizone.MediumColumn colOutTop(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    "Medium column to compute static pressure of air"
    annotation (Placement(transformation(extent={{31,10},{51,30}})));
  Buildings.Airflow.Multizone.Orifice oriOutTop(
    redeclare package Medium = Medium,
    A=0.01,
    m=0.5) "Orifice at top"
           annotation (Placement(transformation(extent={{1,30},{21,50}})));
  Buildings.Airflow.Multizone.MediumColumn colEasInTop(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    "Medium column to compute static pressure of air"
    annotation (Placement(transformation(extent={{-27,10},{-7,30}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volOut(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 10,
    V=1E12,
    p_start=Medium.p_default,
    nPorts=2,
    m_flow_nominal=0.001)
    "Control volume for outside"                             annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={51,-10})));

  Buildings.Airflow.Multizone.MediumColumn colEasInBot(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    "Medium column to compute static pressure of air"
    annotation (Placement(transformation(extent={{-28,-50},{-8,-30}})));
  Buildings.Airflow.Multizone.MediumColumn colOutBot(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    "Medium column to compute static pressure of air"
    annotation (Placement(transformation(extent={{32,-52},{52,-32}})));
equation
  connect(colEasInTop.port_a, oriOutTop.port_a) annotation (Line(
      points={{-17,30},{-18,30},{-18,40},{1,40}},
      color={0,127,255}));
  connect(colEasInTop.port_b, volEas.ports[1]) annotation (Line(
      points={{-17,10},{-18,10},{-18,-12},{-20,-12}},
      color={0,127,255}));
  connect(colEasInBot.port_a, volEas.ports[2]) annotation (Line(
      points={{-18,-30},{-18,-8},{-20,-8}},
      color={0,127,255}));
  connect(colEasInBot.port_b, oriOutBot.port_a) annotation (Line(
      points={{-18,-50},{-18,-62},{0,-62}},
      color={0,127,255}));
  connect(oriOutBot.port_b, colOutBot.port_b) annotation (Line(
      points={{20,-62},{42,-62},{42,-52}},
      color={0,127,255}));
  connect(colOutBot.port_a, volOut.ports[1]) annotation (Line(
      points={{42,-32},{42,-8},{41,-8}},
      color={0,127,255}));
  connect(colOutTop.port_b, volOut.ports[2]) annotation (Line(
      points={{41,10},{41,-12}},
      color={0,127,255}));
  connect(colOutTop.port_a, oriOutTop.port_b) annotation (Line(
      points={{41,30},{42,30},{42,40},{21,40}},
      color={0,127,255}));
  annotation (
    Diagram(graphics={Rectangle(
          extent={{-90,60},{10,-88}},
          lineColor={0,0,0},
          lineThickness=1)}),
experiment(Tolerance=1e-06, StopTime=1),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Examples/OneRoom.mos"
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
November 10, 2011, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end OneRoom;
