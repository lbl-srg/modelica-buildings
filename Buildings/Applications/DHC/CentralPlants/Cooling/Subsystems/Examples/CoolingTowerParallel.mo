within Buildings.Applications.DHC.CentralPlants.Cooling.Subsystems.Examples;
model CoolingTowerParallel
  "Example model for parallel cooling tower model"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model for water";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1
    "Design water flow rate"
    annotation (Dialog(group="Nominal condition"));

  Buildings.Applications.DHC.CentralPlants.Cooling.Subsystems.CoolingTowerParellel
    cooTowPar(
    use_inputFilter=false,
    m_flow_nominal=m_flow_nominal/2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal=60000,
    TAirInWB_nominal=273.15 + 25.55,
    TWatIn_nominal=273.15 + 35,
    dT_nominal=5.56,
    PFan_nominal=4800) "Parallel cooling towers"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    final computeWetBulbTemperature=true,
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  Modelica.Blocks.Logical.OnOffController onOffCon(
    bandwidth=2,
    reference(unit="K", displayUnit="degC"),
    u(unit="K", displayUnit="degC"))
    "On/off controller"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));

  Modelica.Blocks.Logical.Switch swi "Control switch for chilled water pump"
    annotation (Placement(transformation(extent={{30,-90},{50,-70}})));

  Modelica.Blocks.Sources.Constant TSwi(k=273.15 + 22)
    "Switch temperature for switching tower pump on"
    annotation (Placement(transformation(extent={{-60,-96},{-40,-76}})));

  Modelica.Blocks.Sources.Constant zer(k=0) "Zero flow rate"
    annotation (Placement(transformation(extent={{-10,-120},{10,-100}})));

  Modelica.Blocks.Sources.Constant m_flow(k=m_flow_nominal)
    "Water flow rate"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    nPorts=3,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    V=0.5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));

  Buildings.Fluid.Sources.Boundary_pT exp(redeclare package Medium = Medium,
    nPorts=1) "Expansion vessel"
    annotation (Placement(transformation(extent={{100,-30},{80,-10}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixHeaFlo(
    Q_flow=0.5*m_flow_nominal*4200*5) "Fixed heat flow rate"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TVol
    "Water temperature"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nominalValuesDefineDefaultPressureCurve=true)
    "Pump for chilled water loop"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Buildings.Controls.OBC.CDL.Continuous.LimPID conFan(
    k=1,
    Ti=60,
    Td=10,
    reverseAction=true,
    u_s(unit="K", displayUnit="degC"),
    u_m(unit="K", displayUnit="degC"))
    "Controller for tower fan"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Modelica.Blocks.Sources.Constant TSetLea(k=273.15 + 18)
    "Setpoint for leaving temperature"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTCWLvg(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal)
    "Sensor for leaving conderser water temperature"
    annotation (Placement(transformation(extent={{30,40},{50,60}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

equation
  connect(onOffCon.y,swi. u2) annotation (Line(points={{11,-80},{28,-80}}, color={255,0,255}));
  connect(zer.y,swi. u3) annotation (Line(points={{11,-110},{18,-110},{18,-88},{28,-88}},
     color={0,0,127}));
  connect(m_flow.y,swi. u1) annotation (Line(points={{11,-40},{18,-40},{18,-72},{28,-72}},
     color={0,0,127}));
  connect(vol.ports[1],pum. port_a) annotation (Line(points={{27.3333,-20},{-60,
          -20},{-60,50},{-40,50}},
      color={0,127,255}));
  connect(fixHeaFlo.port,vol. heatPort) annotation (Line(points={{-20,10},{10,10},{10,-10},{20,-10}},
     color={191,0,0}));
  connect(vol.heatPort,TVol. port) annotation (Line(points={{20,-10},{-70,-10},{-70,-40},{-60,-40}},
      color={191,0,0}));
  connect(onOffCon.u,TSwi. y) annotation (Line(points={{-12,-86},{-39,-86}},  color={0,0,127}));
  connect(TVol.T,onOffCon. reference) annotation (Line(points={{-40,-40},{-30,-40},{-30,-74},{-12,-74}},
      color={0,0,127}));
  connect(swi.y,pum. m_flow_in) annotation (Line(points={{51,-80},{60,-80},{60,-128},
          {-80,-128},{-80,68},{-30,68},{-30,62}},
                                     color={0,0,127}));
  connect(exp.ports[1],vol. ports[3]) annotation (Line(points={{80,-20},{
          32.6667,-20}},                                                                 color={0,127,255}));
  connect(pum.port_b, cooTowPar.port_a) annotation (Line(points={{-20,50},{0,50}}, color={0,127,255}));
  connect(TSetLea.y, conFan.u_s) annotation (Line(points={{-39,90},{-22,90}}, color={0,0,127}));
  connect(senTCWLvg.T, conFan.u_m) annotation (Line(points={{40,61},{40,70},{-10,
          70},{-10,78}}, color={0,0,127}));
  connect(conFan.y, cooTowPar.speFan) annotation (Line(points={{2,90},{8,90},{8,
          60},{-8,60},{-8,52},{-2,52}}, color={0,0,127}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-80,90},{-70,90}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TWetBul, cooTowPar.TWetBul) annotation (Line(
      points={{-70,90},{-70,30},{-10,30},{-10,44},{-2,44}},
      color={255,204,51},
      thickness=0.5));
  connect(cooTowPar.port_b, senTCWLvg.port_a)  annotation (Line(points={{20,50},{30,50}}, color={0,127,255}));
  connect(senTCWLvg.port_b, vol.ports[2]) annotation (Line(points={{50,50},{60,50},
          {60,-20},{30,-20}}, color={0,127,255}));
  connect(swi.y, cooTowPar.on[1]) annotation (Line(points={{51,-80},{60,-80},{60,
          -128},{-80,-128},{-80,68},{-12,68},{-12,56},{-2,56}}, color={0,0,127}));
  connect(swi.y, cooTowPar.on[2]) annotation (Line(points={{51,-80},{60,-80},{60,
          -128},{-80,-128},{-80,68},{-12,68},{-12,56},{-2,56}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
            Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-140},{120,120}})),
    experiment(
      StartTime=15552000,
      StopTime=15724800,
      Tolerance=1e-06),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Applications/DHC/CentralPlants/Cooling/Subsystems/Examples/CoolingTowerParallel.mos"
        "Simulate and Plot"));
end CoolingTowerParallel;
