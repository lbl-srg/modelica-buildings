within Buildings.Fluid.HeatExchangers.Validation;
model HeaterCooler_u "Model that demonstrates the ideal heater model"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air;


  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=3000/1000/20
    "Nominal mass flow rate";

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_T_in=false,
    p(displayUnit="Pa"),
    T=293.15,
    nPorts=2)
    "Sink"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=180,origin={130,50})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaSte(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=6000,
    Q_flow_nominal=3000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Steady-state model of the heater"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Modelica.Blocks.Sources.TimeTable TSet(table=[0, 273.15 + 20; 120, 273.15
    +20; 120, 273.15 + 30; 1200, 273.15 + 30])
    "Setpoint"
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
  Buildings.Controls.Continuous.LimPID con1(
    Td=1,
    k=1,
    Ti=10)
    "Controller"
    annotation (Placement(transformation(extent={{40,140},{60,160}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaDyn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=6000,
    Q_flow_nominal=3000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    "Dynamic model of the heater"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));

  Buildings.Controls.Continuous.LimPID con2(
    Td=1,
    Ti=10,
    k=0.1)
    "Controller"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));

  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    use_T_in=false,
    nPorts=2,
    m_flow=2*m_flow_nominal,
    T=293.15) "Source" annotation (Placement(transformation(extent={{-80,40},{
            -60,60}})));
equation
  connect(senTem1.T, con1.u_m) annotation (Line(
      points={{50,111},{50,138}},
      color={0,0,127}));
  connect(TSet.y, con1.u_s) annotation (Line(
      points={{-39,150},{38,150}},
      color={0,0,127}));
  connect(con1.y, heaSte.u) annotation (Line(
      points={{61,150},{70,150},{70,130},{-10,130},{-10,106},{-2,106}},
      color={0,0,127}));
  connect(heaSte.port_b, senTem1.port_a) annotation (Line(
      points={{20,100},{40,100}},
      color={0,127,255}));
  connect(senTem2.T, con2.u_m) annotation (Line(
      points={{50,1},{50,28}},
      color={0,0,127}));
  connect(TSet.y, con2.u_s) annotation (Line(
      points={{-39,150},{-14,150},{-14,40},{38,40}},
      color={0,0,127}));
  connect(con2.y, heaDyn.u) annotation (Line(
      points={{61,40},{70,40},{70,20},{-10,20},{-10,-4},{-2,-4}},
      color={0,0,127}));
  connect(heaDyn.port_b, senTem2.port_a) annotation (Line(
      points={{20,-10},{40,-10}},
      color={0,127,255}));

  connect(heaSte.port_a, sou.ports[1]) annotation (Line(
      points={{0,100},{-40,100},{-40,52},{-60,52}},
      color={0,127,255}));
  connect(sou.ports[2], heaDyn.port_a) annotation (Line(
      points={{-60,48},{-40,48},{-40,-10},{0,-10}},
      color={0,127,255}));
  connect(senTem2.port_b, sin.ports[1]) annotation (Line(
      points={{60,-10},{100,-10},{100,48},{120,48}},
      color={0,127,255}));
  connect(senTem1.port_b, sin.ports[2]) annotation (Line(
      points={{60,100},{100,100},{100,52},{120,52}},
      color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{200,
            200}}), graphics),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Validation/HeaterCooler_u.mos" "Simulate and plot"),
    Documentation(info="<html>
<p>
Model that demonstrates the use of an ideal heater.
Both heater models are identical, except that one model is configured
as a steady-state model, whereas the other is configured as a dynamic model.
Both heaters add heat to the medium to track a set-point for the outlet
temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
September 11, 2014, by Christoph Nytsch-Geusen:<br/>
Rename experiment to HetaterColler_u
in the Annex 60 library.
</li>
<li>
September 19, 2013, by Michael Wetter:<br/>
Removed fan with a prescribed mass flow source for inclusion of the test model
in the Annex 60 library.
</li>
<li>
July 11, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=1200,
      Tolerance=1e-6));
end HeaterCooler_u;
