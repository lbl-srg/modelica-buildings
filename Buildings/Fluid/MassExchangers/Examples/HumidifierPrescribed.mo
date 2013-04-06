within Buildings.Fluid.MassExchangers.Examples;
model HumidifierPrescribed "Model that demonstrates the ideal humidifier model"
  import Buildings;
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.PerfectGases.MoistAirUnsaturated;

  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
     3000/1000/20 "Nominal mass flow rate";

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    nPorts=3,
    use_T_in=false,
    p(displayUnit="Pa"),
    T=303.15) "Source" annotation (Placement(transformation(extent={{-80,60},{-60,
            80}}, rotation=0)));
  Buildings.Fluid.MassExchangers.HumidifierPrescribed humSte(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=6000,
    tau=0,
    mWat_flow_nominal=m_flow_nominal*0.005,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Steady-state model of the humidifier"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem1(redeclare package Medium
      = Medium, m_flow_nominal=m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Modelica.Blocks.Sources.TimeTable TSet(table=[0, 273.15 + 30; 120, 273.15 +
        30; 120, 273.15 + 25; 1200, 273.15 + 25]) "Setpoint"
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
  Buildings.Controls.Continuous.LimPID con1(
    Td=1,
    k=1,
    Ti=10,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    reverseAction=true) "Controller"
    annotation (Placement(transformation(extent={{40,140},{60,160}})));
  Buildings.Fluid.Movers.FlowMachine_m_flow fan(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dynamicBalance=false) "Fan"
    annotation (Placement(transformation(extent={{140,-20},{160,0}})));
  Modelica.Blocks.Sources.Constant const(k=2*m_flow_nominal)
    "Mass flow rate signal for pump"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Buildings.Fluid.MassExchangers.HumidifierPrescribed humDyn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=6000,
    mWat_flow_nominal=m_flow_nominal*0.005,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    T_start=303.15) "Dynamic model of the humidifier"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem2(redeclare package Medium
      = Medium, m_flow_nominal=m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Controls.Continuous.LimPID con2(
    Td=1,
    Ti=10,
    k=0.1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    reverseAction=true) "Controller"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
equation
  connect(senTem1.T, con1.u_m) annotation (Line(
      points={{50,111},{50,138}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet.y, con1.u_s) annotation (Line(
      points={{-39,150},{38,150}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con1.y, humSte.u) annotation (Line(
      points={{61,150},{70,150},{70,130},{-10,130},{-10,106},{-2,106}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[1], humSte.port_a) annotation (Line(
      points={{-60,72.6667},{-30,72.6667},{-30,100},{-5.55112e-16,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(humSte.port_b, senTem1.port_a) annotation (Line(
      points={{20,100},{40,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem1.port_b, fan.port_a) annotation (Line(
      points={{60,100},{90,100},{90,-10},{140,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem2.T, con2.u_m) annotation (Line(
      points={{50,1},{50,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet.y, con2.u_s) annotation (Line(
      points={{-39,150},{-14,150},{-14,40},{38,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con2.y, humDyn.u) annotation (Line(
      points={{61,40},{70,40},{70,20},{-10,20},{-10,-4},{-2,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(humDyn.port_b, senTem2.port_a) annotation (Line(
      points={{20,-10},{40,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem2.port_b, fan.port_a) annotation (Line(
      points={{60,-10},{140,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[2], humDyn.port_a) annotation (Line(
      points={{-60,70},{-30,70},{-30,-10},{-5.55112e-16,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(const.y, fan.m_flow_in) annotation (Line(
      points={{121,10},{149.8,10},{149.8,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fan.port_b, sou.ports[3]) annotation (Line(
      points={{160,-10},{170,-10},{170,-40},{-40,-40},{-40,67.3333},{-60,
          67.3333}},
      color={0,127,255},
      smooth=Smooth.None));

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{200,
            200}})),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/MassExchangers/Examples/HumidifierPrescribed.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Model that demonstrates the use of an ideal humidifier.
Both humidifer models are identical, except that one model is configured
as a steady-state model, whereas the other is configured as a dynamic model.
Both humidifiers add water to the medium to track a set-point for the outlet
temperature using adiabatic cooling.
The temperature of the water that is added to the medium is determined by
the parameter <code>T</code> of the humidifier models.
</p>
</html>", revisions="<html>
<ul>
<li>
July 11, 2011, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=1200,
      Tolerance=1e-05));
end HumidifierPrescribed;
