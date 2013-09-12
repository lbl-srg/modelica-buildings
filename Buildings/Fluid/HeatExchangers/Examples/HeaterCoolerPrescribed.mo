within Buildings.Fluid.HeatExchangers.Examples;
model HeaterCoolerPrescribed "Model that demonstrates the ideal heater model"
  import Buildings;
  extends Modelica.Icons.Example;
 // fixme: revert model to the one from master prior to merging the branch
  package Medium = Buildings.Media.ConstantPropertyLiquidWater;

  inner Modelica.Fluid.System system(m_flow_start=0, energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
     3000/1000/20 "Nominal mass flow rate";

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    p(displayUnit="Pa") = 101500,
    T=293.15) "Source" annotation (Placement(transformation(extent={{-60,90},{-40,
            110}},rotation=0)));
  Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed heaSte(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=6000,
    Q_flow_nominal=3000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Steady-state model of the heater"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem1(redeclare package Medium
      = Medium, m_flow_nominal=m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Modelica.Blocks.Sources.TimeTable TSet(table=[0, 273.15 + 20; 120, 273.15 +
        20; 120, 273.15 + 30; 1200, 273.15 + 30]) "Setpoint"
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
  Buildings.Controls.Continuous.LimPID con1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Td=1,
    k=1,
    Ti=10) "Controller"
    annotation (Placement(transformation(extent={{40,140},{60,160}})));
  Buildings.Fluid.Sources.Boundary_pT sou1(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    p(displayUnit="Pa") = 101325,
    T=293.15) "Source" annotation (Placement(transformation(extent={{-10,-10},{10,
            10}}, rotation=180,
        origin={110,100})));
equation
  connect(senTem1.T, con1.u_m) annotation (Line(
      points={{50,111},{50,138}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet.y, con1.u_s) annotation (Line(
      points={{-39,150},{38,150}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con1.y, heaSte.u) annotation (Line(
      points={{61,150},{70,150},{70,130},{-10,130},{-10,106},{-2,106}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[1], heaSte.port_a) annotation (Line(
      points={{-40,100},{-5.55112e-16,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heaSte.port_b, senTem1.port_a) annotation (Line(
      points={{20,100},{40,100}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(sou1.ports[1], senTem1.port_b) annotation (Line(
      points={{100,100},{60,100}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{200,
            200}}), graphics),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/HeaterCoolerPrescribed.mos"
        "Simulate and plot"),
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
July 11, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=1200,
      Tolerance=1e-05));
end HeaterCoolerPrescribed;
