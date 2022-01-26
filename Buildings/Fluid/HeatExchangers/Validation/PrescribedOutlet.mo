within Buildings.Fluid.HeatExchangers.Validation;
model PrescribedOutlet
  "Model that demonstrates the ideal heater/cooler model for a prescribed outlet temperature, configured as steady-state"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.1
    "Nominal mass flow rate";
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_T_in=false,
    p(displayUnit="Pa"),
    T=293.15,
    nPorts=3) "Sink"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=180,origin={150,34})));
  Buildings.Fluid.HeatExchangers.PrescribedOutlet heaHigPow(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=6000,
    QMax_flow=1e4,
    use_X_wSet=false)
    "Steady-state model of the heater with high capacity"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort heaHigPowOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{78,110},{98,130}})));
  Modelica.Blocks.Sources.TimeTable TSetHeat(table=[0,273.15 + 20.0; 120,273.15
    + 20.0; 120,273.15 + 60.0; 500,273.15 + 60.0; 500,273.15 + 30.0; 1200,273.15 + 30.0])
    "Setpoint heating"
    annotation (Placement(transformation(extent={{-10,160},{10,180}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort cooLimPowOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{80,24},{100,44}})));
  Buildings.Fluid.HeatExchangers.PrescribedOutlet cooLimPow(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=6000,
    QMin_flow=-1000,
    use_X_wSet=false)
    "Steady-state model of the cooler with limited capacity"
    annotation (Placement(transformation(extent={{40,24},{60,44}})));
  Modelica.Blocks.Sources.TimeTable TSetCool(table=[0,273.15 + 20.0; 120,273.15
    + 20.0; 120,273.15 + 15.0; 500,273.15 + 15.0; 500,273.15 + 10.0; 1200,273.15 + 10.0])
    "Setpoint cooling"
    annotation (Placement(transformation(extent={{-8,70},{12,90}})));
  Buildings.Fluid.HeatExchangers.PrescribedOutlet heaCooUnl(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=6000,
    use_X_wSet=false)
    "Steady-state model of the heater or cooler with unlimited capacity"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Modelica.Blocks.Sources.TimeTable TSetCoolHeat(table=[0,273.15 + 20.0; 120,273.15
    + 20.0; 120,273.15 + 15.0; 500,273.15 + 15.0; 500,273.15 + 30.0; 1200,273.15
    + 30.0]) "Setpoint cooling"
    annotation (Placement(transformation(extent={{-8,-20},{12,0}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort heaCooUnlOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{78,-60},{98,-40}})));
  Modelica.Blocks.Sources.Ramp m_flow(
    height=-2*m_flow_nominal,
    duration=100,
    offset=m_flow_nominal,
    startTime=1000) "Mass flow rate"
    annotation (Placement(transformation(extent={{-80,32},{-60,52}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort heaHigPowIn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{-8,110},{12,130}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort cooLimPowIn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{-6,24},{14,44}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort heaCooUnlIn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{-8,-60},{12,-40}})));
  Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1,
    T=293.15) "Flow source"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Sources.MassFlowSource_T sou2(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1,
    T=293.15) "Flow source"
    annotation (Placement(transformation(extent={{-40,24},{-20,44}})));
  Sources.MassFlowSource_T sou3(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1,
    T=293.15) "Flow source"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
equation
  connect(heaHigPow.port_b, heaHigPowOut.port_a) annotation (Line(
      points={{60,120},{78,120}},
      color={0,127,255}));
  connect(TSetHeat.y, heaHigPow.TSet) annotation (Line(
      points={{11,170},{20,170},{20,128},{38,128}},
      color={0,0,127}));
  connect(cooLimPow.port_b, cooLimPowOut.port_a) annotation (Line(
      points={{60,34},{80,34}},
      color={0,127,255}));
  connect(TSetCool.y, cooLimPow.TSet) annotation (Line(
      points={{13,80},{28,80},{28,42},{38,42}},
      color={0,0,127}));
  connect(heaCooUnl.port_b, heaCooUnlOut.port_a) annotation (Line(
      points={{60,-50},{78,-50}},
      color={0,127,255}));
  connect(TSetCoolHeat.y, heaCooUnl.TSet) annotation (Line(
      points={{13,-10},{26,-10},{26,-42},{38,-42}},
      color={0,0,127}));
  connect(heaHigPowIn.port_b, heaHigPow.port_a) annotation (Line(
      points={{12,120},{40,120}},
      color={0,127,255}));
  connect(cooLimPowIn.port_b, cooLimPow.port_a) annotation (Line(
      points={{14,34},{40,34}},
      color={0,127,255}));
  connect(heaCooUnlIn.port_b, heaCooUnl.port_a) annotation (Line(
      points={{12,-50},{40,-50}},
      color={0,127,255}));
  connect(heaCooUnlOut.port_b, sin.ports[1]) annotation (Line(
      points={{98,-50},{120,-50},{120,31.3333},{140,31.3333}},
      color={0,127,255}));
  connect(cooLimPowOut.port_b, sin.ports[2]) annotation (Line(
      points={{100,34},{120,34},{120,34},{140,34}},
      color={0,127,255}));
  connect(heaHigPowOut.port_b, sin.ports[3]) annotation (Line(
      points={{98,120},{120,120},{120,36.6667},{140,36.6667}},
      color={0,127,255}));
  connect(m_flow.y, sou1.m_flow_in) annotation (Line(
      points={{-59,42},{-50,42},{-50,128},{-42,128}},
      color={0,0,127}));
  connect(sou1.ports[1], heaHigPowIn.port_a) annotation (Line(
      points={{-20,120},{-8,120}},
      color={0,127,255}));
  connect(m_flow.y, sou2.m_flow_in) annotation (Line(
      points={{-59,42},{-42,42}},
      color={0,0,127}));
  connect(m_flow.y, sou3.m_flow_in) annotation (Line(
      points={{-59,42},{-50,42},{-50,-42},{-42,-42}},
      color={0,0,127}));
  connect(sou2.ports[1], cooLimPowIn.port_a) annotation (Line(
      points={{-20,34},{-6,34}},
      color={0,127,255}));
  connect(sou3.ports[1], heaCooUnlIn.port_a) annotation (Line(
      points={{-20,-50},{-8,-50}},
      color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{200,200}}),                                                                    graphics),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Validation/PrescribedOutlet.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Model that demonstrates the use of an ideal heater and an ideal cooler.
</p>
<p>
The heater model has a capacity of <code>Q_flow_max = 1.0e4</code> Watts and
the cooler model has a capacitiy of <code>Q_flow_min = -1000</code> Watts.
Hence, both only track their set point of the outlet temperature during certain times.
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
</html>", revisions="<html>
<ul>
<li>
October 21, 2014, by Michael Wetter:<br/>
Revised example to test reverse flow and zero flow transition.
</li>
<li>
March 19, 2014, by Christoph Nytsch-Geusen:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=1200,
      Tolerance=1e-6));
end PrescribedOutlet;
