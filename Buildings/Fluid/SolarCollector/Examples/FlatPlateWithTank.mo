within Buildings.Fluid.SolarCollector.Examples;
model FlatPlateWithTank "Example showing use of the flat plate solar collector"
  import Buildings;
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.ConstantPropertyLiquidWater;
  replaceable package Medium_2 =
      Buildings.Media.ConstantPropertyLiquidWater;
  Buildings.Fluid.SolarCollector.FlatPlate          solCol(
    nSeg=3,
    Cp=4189,
    shaCoe=0,
    I_nominal=800,
    redeclare package Medium = Medium_2,
    lat=0.73097781993588,
    azi=0.3,
    til=0.78539816339745,
    TEnv_nominal=283.15,
    per=Buildings.Fluid.SolarCollector.Data.GlazedFlatPlate.SRCC2002001J(),
    TIn_nominal=293.15)
             annotation (Placement(transformation(extent={{-2,46},{18,66}})));
  BoundaryConditions.WeatherData.ReaderTMY3           weaDat(filNam="Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos",
      computeWetBulbTemperature=false)
    annotation (Placement(transformation(extent={{-30,80},{-10,100}})));
  inner Modelica.Fluid.System system(p_ambient=101325) annotation (Placement(
        transformation(extent={{70,68},{90,88}}, rotation=0)));
  Sensors.TemperatureTwoPort                 TOut(
    T_start(displayUnit="K"),
    m_flow_nominal=solCol.m_flow_nominal,
    redeclare package Medium = Medium_2) "Temperature sensor"
    annotation (Placement(transformation(extent={{30,46},{50,66}})));
  Sensors.TemperatureTwoPort                 TIn(
                m_flow_nominal=solCol.m_flow_nominal, redeclare package Medium
      = Medium_2) "Temperature sensor"
    annotation (Placement(transformation(extent={{-34,46},{-14,66}})));
  Buildings.Fluid.Storage.StratifiedEnhancedInternalHX
                             tan(
    nSeg=4,
    redeclare package Medium = Medium,
    hTan=1,
    m_flow_nominal=0.1,
    VTan=1.5,
    dIns=0.07,
    redeclare package Medium_2 = Medium_2,
    TopHXSeg=4,
    C=200,
    VolHX=0.01,
    m_flow_nominal_HX=0.1,
    m_flow_nominal_tank=0.1,
    BotHXSeg=2,
    UA_nominal=300,
    ASurHX=0.199,
    dHXExt=0.01905,
    T_start=293.15,
    HXTopHeight=0.9,
    HXBotHeight=0.65)
                 annotation (Placement(transformation(
        extent={{-15,-15},{15,15}},
        rotation=180,
        origin={27,-33})));
  Buildings.Fluid.SolarCollector.Controls.SolarPumpController
                                                     pumCon(
    per=Buildings.Fluid.SolarCollector.Data.GlazedFlatPlate.SRCC2001002B(), conDel=
       0.0001) "Pump controller"                                                              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-88,50})));
  Modelica.Blocks.Sources.Constant TRoo(k=273.15 + 20) "Room temperature"
    annotation (Placement(transformation(extent={{-72,-92},{-52,-72}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature rooT
    annotation (Placement(transformation(extent={{-40,-92},{-20,-72}})));
  Modelica.Blocks.Math.Gain gain(k=0.04)
                                 annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=270,
        origin={-88,10})));
  Buildings.Fluid.Sources.Boundary_pT bou(nPorts=1, redeclare package Medium =
        Medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,6})));
  Buildings.Fluid.Sources.MassFlowSource_T bou1(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    m_flow=0.01,
    T=288.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={44,6})));
  Buildings.Fluid.Movers.FlowMachine_m_flow pum(redeclare package Medium =
        Medium_2, m_flow_nominal=0.1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-6})));
  Buildings.Fluid.Storage.ExpansionVessel exp(redeclare package Medium =
        Medium_2, VTot=0.1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-48})));
equation
  connect(solCol.port_b,TOut. port_a) annotation (Line(
      points={{18,56},{30,56}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TIn.port_b,solCol. port_a) annotation (Line(
      points={{-14,56},{-2,56}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus,solCol. weaBus) annotation (Line(
      points={{-10,90},{10.6,90},{10.6,66}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(TIn.T, pumCon.TIn) annotation (Line(
      points={{-24,67},{-24,78},{-92,78},{-92,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, pumCon.weaBus) annotation (Line(
      points={{-10,90},{-6,90},{-6,72},{-82,72},{-82,60.2}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(TRoo.y, rooT.T)                  annotation (Line(
      points={{-51,-82},{-42,-82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rooT.port, tan.heaPorTop)                  annotation (Line(
      points={{-20,-82},{24,-82},{24,-44.1}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rooT.port, tan.heaPorSid)                  annotation (Line(
      points={{-20,-82},{18.6,-82},{18.6,-33}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pumCon.conSig, gain.u) annotation (Line(
      points={{-88,38.2},{-88,19.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bou.ports[1], tan.port_b) annotation (Line(
      points={{-1.33227e-15,-4},{-1.33227e-15,-16},{0,-16},{0,-33},{12,-33}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou1.ports[1], tan.port_a) annotation (Line(
      points={{44,-4},{46,-4},{46,-33},{42,-33}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(gain.y, pum.m_flow_in) annotation (Line(
      points={{-88,1.2},{-88,-6.2},{-62,-6.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pum.port_b, TIn.port_a) annotation (Line(
      points={{-50,4},{-50,56},{-34,56}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum.port_a, exp.port_a) annotation (Line(
      points={{-50,-16},{-50,-48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(exp.port_a, tan.port_b1) annotation (Line(
      points={{-50,-48},{13.5,-48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.port_b, tan.port_a1) annotation (Line(
      points={{50,56},{62,56},{62,-48},{40.5,-48}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Commands(file=
          "Resources/Scripts/Dymola/Fluid/SolarCollector/Examples/FlatPlateWithTank.mos"
        "Simulate and Plot"));
end FlatPlateWithTank;
