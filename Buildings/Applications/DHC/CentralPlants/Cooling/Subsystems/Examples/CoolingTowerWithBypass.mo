within Buildings.Applications.DHC.CentralPlants.Cooling.Subsystems.Examples;
model CoolingTowerWithBypass
  "Example model for parallel cooling towers with bypass valve"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model for water";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1
    "Design water flow rate";

  parameter Modelica.SIunits.Temperature TMin=273.15 + 10
    "Minimum allowed water temperature entering chiller";

  Buildings.Applications.DHC.CentralPlants.Cooling.Subsystems.CoolingTowerWithBypass
    cooTowPar(
    use_inputFilter=false,
    show_T=true,
    m_flow_nominal=m_flow_nominal/2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal=60000,
    TAirInWB_nominal=273.15 + 25.55,
    TWatIn_nominal=273.15 + 35,
    dT_nominal=5.56,
    PFan_nominal=4800,
    TMin=TMin,
    controllerType=Modelica.Blocks.Types.SimpleController.PI)
    "Parallel cooling towers"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    final computeWetBulbTemperature=true, filNam=
        ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  Modelica.Blocks.Logical.OnOffController onOffCon(
    bandwidth=2,
    reference(unit="K", displayUnit="degC"),
    u(unit="K", displayUnit="degC"))
    "On/off controller"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));

  Modelica.Blocks.Logical.Switch swi "Control switch for chilled water pump"
    annotation (Placement(transformation(extent={{30,-90},{50,-70}})));

  Modelica.Blocks.Sources.Constant TSwi(k=273.15 + 14)
    "Switch temperature for switching tower pump on"
    annotation (Placement(transformation(extent={{-60,-96},{-40,-76}})));

  Modelica.Blocks.Sources.Constant zer(k=0) "Zero flow rate"
    annotation (Placement(transformation(extent={{-10,-120},{10,-100}})));

  Modelica.Blocks.Sources.Constant m_flow(k=m_flow_nominal)
    "Water flow rate"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    nPorts=3,
    redeclare final package Medium = Medium,
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
    redeclare final package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nominalValuesDefineDefaultPressureCurve=true)
    "Pump for chilled water loop"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTCWLvg(
    redeclare final package Medium = Medium,
    m_flow_nominal=m_flow_nominal)
    "Sensor for leaving conderser water temperature"
    annotation (Placement(transformation(extent={{30,40},{50,60}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

  Modelica.Blocks.Math.BooleanToReal booToRea(
    final realTrue=1, final realFalse=0)
    "Boolean to real (if true then 1 else 0)"
    annotation (Placement(transformation(extent={{-110,40},{-90,60}})));
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
  connect(exp.ports[1],vol. ports[3]) annotation (Line(points={{80,-20},{
          32.6667,-20}},                                                                 color={0,127,255}));
  connect(pum.port_b, cooTowPar.port_a) annotation (Line(points={{-20,50},{0,50}}, color={0,127,255}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-80,90},{-70,90}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TWetBul, cooTowPar.TWetBul) annotation (Line(
      points={{-70,90},{-70,30},{-10,30},{-10,48},{-2,48}},
      color={255,204,51},
      thickness=0.5));
  connect(cooTowPar.port_b, senTCWLvg.port_a)  annotation (Line(points={{20,50},{30,50}}, color={0,127,255}));
  connect(senTCWLvg.port_b, vol.ports[2]) annotation (Line(points={{50,50},{60,50},
          {60,-20},{30,-20}}, color={0,127,255}));
  connect(onOffCon.y, booToRea.u) annotation (Line(points={{11,-80},{20,-80},{20,
          -134},{-118,-134},{-118,50},{-112,50}}, color={255,0,255}));
  connect(booToRea.y, cooTowPar.on[1]) annotation (Line(points={{-89,50},{-84,50},
          {-84,72},{-10,72},{-10,54},{-2,54}}, color={0,0,127}));
  connect(booToRea.y, cooTowPar.on[2]) annotation (Line(points={{-89,50},{-84,50},
          {-84,72},{-10,72},{-10,54},{-2,54}}, color={0,0,127}));
  connect(swi.y, pum.m_flow_in) annotation (Line(points={{51,-80},{60,-80},{60,
          -128},{-80,-128},{-80,68},{-30,68},{-30,62}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
            Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-140},{120,120}})),
    experiment(
      StartTime=10368000,
      StopTime=10540800,
      Tolerance=1e-06),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Applications/DHC/CentralPlants/Cooling/Subsystems/Examples/CoolingTowerWithBypass.mos"
        "Simulate and Plot"),
    Documentation(revisions="<html>
<ul>
<li>
August 6, 2020 by Jing Wang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>This model validates the parallel connected cooling tower subsystem in <a href=\"modelica://Buildings.Applications.DHC.CentralPlants.Cooling.Subsystems.CoolingTowerWithBypass\">Buildings.Applications.DHC.CentralPlants.Cooling.Subsystems.CoolingTowerWithBypass</a>.</p>
</html>"));
end CoolingTowerWithBypass;
