within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples;
model SpaceCooling "Space cooling with DX coils"
  extends Modelica.Icons.Example;
  replaceable package Medium =
      Buildings.Media.Air;

  parameter Modelica.Units.SI.Volume V=6*10*3 "Room volume";
  //////////////////////////////////////////////////////////
  // Heat recovery effectiveness
  parameter Real eps = 0.8 "Heat recovery effectiveness";

  /////////////////////////////////////////////////////////
  // Air temperatures at design conditions
  parameter Modelica.Units.SI.Temperature TASup_nominal=273.15 + 18
    "Nominal air temperature supplied to room";
  parameter Modelica.Units.SI.Temperature TRooSet=273.15 + 24
    "Nominal room air temperature";
  parameter Modelica.Units.SI.Temperature TOut_nominal=273.15 + 30
    "Design outlet air temperature";
  parameter Modelica.Units.SI.Temperature THeaRecLvg=TOut_nominal - eps*(
      TOut_nominal - TRooSet) "Air temperature leaving the heat recovery";

  /////////////////////////////////////////////////////////
  // Cooling loads and air mass flow rates
  parameter Modelica.Units.SI.HeatFlowRate QRooInt_flow=1000
    "Internal heat gains of the room";
  parameter Modelica.Units.SI.HeatFlowRate QRooC_flow_nominal=-QRooInt_flow -
      10E3/30*(TOut_nominal - TRooSet) "Nominal cooling load of the room";
  parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal=1.3*
      QRooC_flow_nominal/1006/(TASup_nominal - TRooSet)
    "Nominal air mass flow rate, increased by factor 1.3 to allow for recovery after temperature setback";
  parameter Modelica.Units.SI.TemperatureDifference dTFan=2
    "Estimated temperature raise across fan that needs to be made up by the cooling coil";
  parameter Modelica.Units.SI.HeatFlowRate QCoiC_flow_nominal=(
      QRooC_flow_nominal + mA_flow_nominal*(TASup_nominal - THeaRecLvg - dTFan)
      *1006)
    "Cooling load of coil, taking into account economizer, and increased due to latent heat removal";

  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium = Medium,
    m_flow_nominal=mA_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Supply air fan"
    annotation (Placement(transformation(extent={{100,-74},{120,-54}})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=mA_flow_nominal,
    m2_flow_nominal=mA_flow_nominal,
    dp1_nominal=200,
    dp2_nominal=200,
    eps=eps) "Heat recovery"
    annotation (Placement(transformation(extent={{-110,-80},{-90,-60}})));
  Buildings.Fluid.Sources.Outside out(nPorts=6, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-174,-76},{-154,-56}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    TDryBul=TOut_nominal,
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.File)
    "Weather data reader"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));
  BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-138,60},{-118,80}})));
  Modelica.Blocks.Sources.Constant mAir_flow(k=mA_flow_nominal)
    "Fan air flow rate"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHXEvaOut(redeclare package
      Medium =
        Medium, m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for heat recovery outlet on supply side"
    annotation (Placement(transformation(extent={{-76,-70},{-64,-58}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupAir(redeclare package
      Medium =
        Medium, m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for supply air"
    annotation (Placement(transformation(extent={{66,-70},{78,-58}})));
  Modelica.Blocks.Logical.OnOffController con(bandwidth=1, pre_y_start=true)
    "Controller for coil water flow rate"
    annotation (Placement(transformation(extent={{-72,2},{-52,22}})));
  Modelica.Blocks.Sources.Constant TRooSetPoi(k=TRooSet)
    "Room temperature set point"
    annotation (Placement(transformation(extent={{-120,8},{-100,28}})));
  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeedDXCooling
    sinSpeDX(
    redeclare package Medium = Medium,
    datCoi=datCoi,
    dp_nominal=400,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-2,-74},{18,-54}})));

  SimpleRoom rooSinSpe(
    redeclare package Medium = Medium,
    nPorts=2,
    QRooInt_flow=QRooInt_flow,
    mA_flow_nominal=mA_flow_nominal)
    "Room model connected to single speed coil"
                                     annotation (Placement(transformation(
          extent={{120,40},{140,60}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan1(
    redeclare package Medium = Medium,
    m_flow_nominal=mA_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Supply air fan"
    annotation (Placement(transformation(extent={{100,-174},{120,-154}})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex1(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=mA_flow_nominal,
    m2_flow_nominal=mA_flow_nominal,
    dp1_nominal=200,
    dp2_nominal=200,
    eps=eps) "Heat recovery"
    annotation (Placement(transformation(extent={{-110,-180},{-90,-160}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHXEvaOut1(
    redeclare package Medium = Medium,
    m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for heat recovery outlet on supply side"
    annotation (Placement(transformation(extent={{-76,-170},{-64,-158}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupAir1(
    redeclare package Medium = Medium,
     m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for supply air"
    annotation (Placement(transformation(extent={{66,-170},{78,-158}})));
  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.MultiStageCooling mulStaDX(
    redeclare package Medium = Medium,
    dp_nominal=400,
    datCoi=datCoiMulSpe,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Multi-speed DX coil"
    annotation (Placement(transformation(extent={{-2,-174},{18,-154}})));
  SimpleRoom rooMulSpe(
    redeclare package Medium = Medium,
    nPorts=2,
    QRooInt_flow=QRooInt_flow,
    mA_flow_nominal=mA_flow_nominal) "Room model connected to multi stage coil"
     annotation (Placement(transformation(extent={{180,40},{200,60}})));

  parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil
    datCoi(sta={Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=QCoiC_flow_nominal,
          COP_nominal=3,
          SHR_nominal=0.7,
          m_flow_nominal=mA_flow_nominal),
        perCur=PerformanceCurves.Curve_I())}, nSta=1)
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil
    datCoiMulSpe(nSta=2, sta={Data.Generic.BaseClasses.Stage(
        spe=900/60,
        nomVal=Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=QCoiC_flow_nominal*900/2400,
          COP_nominal=3,
          SHR_nominal=0.7,
          m_flow_nominal=mA_flow_nominal*900/2400),
        perCur=PerformanceCurves.Curve_I()),Data.Generic.BaseClasses.Stage(
        spe=2400/60,
        nomVal=Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=QCoiC_flow_nominal,
          COP_nominal=3,
          SHR_nominal=0.7,
          m_flow_nominal=mA_flow_nominal),
        perCur=PerformanceCurves.Curve_III())}) "Coil data"
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));
  ControllerTwoStage mulSpeCon "Controller for multi-stage coil"
                               annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));
  SimpleRoom rooVarSpe(
    redeclare package Medium = Medium,
    nPorts=2,
    QRooInt_flow=QRooInt_flow,
    mA_flow_nominal=mA_flow_nominal)
    "Room model connected to variable speed coil"
                                     annotation (Placement(transformation(
          extent={{240,40},{260,60}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan2(
    redeclare package Medium = Medium,
    m_flow_nominal=mA_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Supply air fan"
    annotation (Placement(transformation(extent={{98,-250},{118,-230}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupAir2(
                                                redeclare package Medium =
        Medium, m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for supply air"
    annotation (Placement(transformation(extent={{64,-246},{76,-234}})));
  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.VariableSpeedDXCooling
    varSpeDX(
    redeclare package Medium = Medium,
    dp_nominal=400,
    datCoi=datCoiMulSpe,
    minSpeRat=0.2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Variable-speed DX coil"
    annotation (Placement(transformation(extent={{-4,-250},{16,-230}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHXEvaOut2(
                                               redeclare package Medium =
        Medium, m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for heat recovery outlet on supply side"
    annotation (Placement(transformation(extent={{-78,-246},{-66,-234}})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex2(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=mA_flow_nominal,
    m2_flow_nominal=mA_flow_nominal,
    dp1_nominal=200,
    dp2_nominal=200,
    eps=eps) "Heat recovery"
    annotation (Placement(transformation(extent={{-112,-256},{-92,-236}})));
  Modelica.Blocks.Continuous.Integrator sinSpePow(y(unit="J"))
    "Power consumed by single speed coil"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Modelica.Blocks.Continuous.Integrator mulSpePow(y(unit="J"))
    "Power consumed by multi-stage coil"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Modelica.Blocks.Continuous.Integrator varSpePow(y(unit="J"))
    "Power consumed by multi-stage coil"
    annotation (Placement(transformation(extent={{40,-220},{60,-200}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{-38,2},{-18,22}})));
  Buildings.Controls.Continuous.LimPID conVarSpe(
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    Ti=1,
    Td=1,
    reverseActing=false) "Controller for variable speed DX coil"
    annotation (Placement(transformation(extent={{-60,-220},{-40,-200}})));
equation
  connect(out.ports[1], hex.port_a1) annotation (Line(
      points={{-154,-62.6667},{-125,-62.6667},{-125,-64},{-110,-64}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(out.ports[2], hex.port_b2) annotation (Line(
      points={{-154,-64},{-110,-64},{-110,-76}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(weaDat.weaBus, out.weaBus) annotation (Line(
      points={{-140,70},{-128,70},{-128,-40},{-180,-40},{-180,-66},{-174,-66},{-174,
          -66},{-174,-66},{-174,-66},{-174,-65.8}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-140,70},{-128,70}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(fan.m_flow_in, mAir_flow.y) annotation (Line(
      points={{110,-52},{110,-44},{92,-44},{92,10},{81,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hex.port_b1, senTemHXEvaOut.port_a) annotation (Line(
      points={{-90,-64},{-76,-64}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemSupAir.port_b, fan.port_a) annotation (Line(
      points={{78,-64},{100,-64}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemHXEvaOut.port_b, sinSpeDX.port_a) annotation (Line(
      points={{-64,-64},{-2,-64}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sinSpeDX.port_b, senTemSupAir.port_a) annotation (Line(
      points={{18,-64},{66,-64}},
      color={0,127,255},
      smooth=Smooth.None));
public
  model SimpleRoom "Simple model of a room"

    replaceable package Medium =
          Modelica.Media.Interfaces.PartialMedium "Medium in the room"
          annotation (choicesAllMatching = true);

    Buildings.Fluid.MixingVolumes.MixingVolume vol(
      redeclare package Medium = Medium,
      m_flow_nominal=mA_flow_nominal,
      V=V,
      nPorts=2,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
      annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(
      G=10000/30,
      port_a(T(start=Medium.T_default))) "Thermal conductance with the ambient"
      annotation (Placement(transformation(extent={{-58,-20},{-38,0}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut(
      port(T(start=Medium.T_default))) "Outside temperature"
      annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
    Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea(
      Q_flow=QRooInt_flow) "Prescribed heat flow"
      annotation (Placement(transformation(extent={{-58,10},{-38,30}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemRoo
      "Room temperature sensor"
      annotation (Placement(transformation(extent={{0,30},{20,50}})));
    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCap(C=2*V*1.2*1006)
      "Heat capacity for furniture and walls"
      annotation (Placement(transformation(extent={{-10,10},{10,30}})));

    parameter Integer nPorts=0 "Number of ports"
      annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
    final parameter Modelica.Units.SI.Volume V=6*10*3 "Room volume";
    parameter Modelica.Units.SI.HeatFlowRate QRooInt_flow
      "Internal heat gains of the room";

    parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal
      "Nominal air mass flow rate";

    Modelica.Blocks.Interfaces.RealInput TOutDryBul
      "Outdoor drybulb temperature"
      annotation (Placement(transformation(extent={{-209,-13},{-179,13}})));
    Modelica.Blocks.Interfaces.RealOutput TRoo(unit="K") "Room temperature"
      annotation (Placement(transformation(extent={{119,-13},{149,13}})));
    Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](redeclare
        each package Medium =
                         Medium) annotation (Placement(transformation(extent={{-50,-170},{47,-147}})));
  equation
    connect(theCon.port_b,vol. heatPort) annotation (Line(
        points={{-38,-10},{-10,-10}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(preHea.port,vol. heatPort) annotation (Line(
        points={{-38,20},{-20,20},{-20,-10},{-10,-10}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(TOut.port,theCon. port_a) annotation (Line(
        points={{-80,-10},{-58,-10}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(vol.heatPort,senTemRoo. port) annotation (Line(
        points={{-10,-10},{-20,-10},{-20,40},{-5.55112e-16,40}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(heaCap.port,vol. heatPort) annotation (Line(
        points={{6.10623e-16,10},{-20,10},{-20,-10},{-10,-10}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(TRoo, senTemRoo.T) annotation (Line(points={{134,4.44089e-16},{35,
            4.44089e-16},{35,40},{20,40}},
                              color={0,0,127}));
    connect(ports, vol.ports) annotation (Line(points={{-1.5,-158.5},{-21,
            -158.5},{-21,-20},{7.77156e-16,-20}},
                                          color={0,127,255}));
    connect(TOut.T, TOutDryBul) annotation (Line(
        points={{-102,-10},{-135,-10},{-135,4.44089e-16},{-194,4.44089e-16}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(extent={{-180,-160},{120,100}},
            preserveAspectRatio=true), graphics), Icon(coordinateSystem(extent={{-180,
              -160},{120,100}})));
  end SimpleRoom;
equation

  connect(sinSpeDX.TOut, weaBus.TDryBul) annotation (Line(
      points={{-3,-61},{-56,-61},{-56,-50},{-128,-50},{-128,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fan.port_b, rooSinSpe.ports[1])
                                    annotation (Line(
      points={{120,-64},{130.283,-64},{130.283,40.1154}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(rooSinSpe.ports[2], hex.port_a2)
                                     annotation (Line(
      points={{133.517,40.1154},{133.517,-80},{-20,-80},{-20,-76},{-90,-76}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(hex1.port_b1, senTemHXEvaOut1.port_a)
                                           annotation (Line(
      points={{-90,-164},{-76,-164}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemSupAir1.port_b, fan1.port_a)
                                           annotation (Line(
      points={{78,-164},{100,-164}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemHXEvaOut1.port_b, mulStaDX.port_a)
                                               annotation (Line(
      points={{-64,-164},{-2,-164}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mulStaDX.port_b, senTemSupAir1.port_a)
                                                annotation (Line(
      points={{18,-164},{66,-164}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mulStaDX.TOut, weaBus.TDryBul) annotation (Line(
      points={{-3,-161},{-62,-161},{-62,-150},{-128,-150},{-128,70}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(fan1.port_b, rooMulSpe.ports[1]) annotation (Line(
      points={{120,-164},{190.283,-164},{190.283,40.1154}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(rooMulSpe.ports[2], hex1.port_a2) annotation (Line(
      points={{193.517,40.1154},{193.517,-180},{-20,-180},{-20,-176},{-90,-176}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(rooMulSpe.TOutDryBul, weaBus.TDryBul) annotation (Line(
      points={{179.067,52.3077},{164,52.3077},{164,70},{-128,70}},
      color={0,0,127},
      smooth=Smooth.None));
public
  model ControllerTwoStage "Controller for two stage coil"
    parameter Real bandwidth=1 "Bandwidth around reference signal";
    extends Buildings.BaseClasses.BaseIcon;
    Modelica.Blocks.Logical.OnOffController con1(bandwidth=bandwidth/2,
        pre_y_start=true) "Controller for coil water flow rate"
      annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
    Modelica.Blocks.Logical.OnOffController con2(bandwidth=bandwidth/2,
        pre_y_start=true) "Controller for coil water flow rate"
      annotation (Placement(transformation(extent={{-20,-150},{0,-130}})));
    Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(
            extent={{-206,-133},{-180,-106}})));
    Modelica.Blocks.Interfaces.RealInput reference
      "Connector of Real input signal used as reference signal"
      annotation (Placement(transformation(extent={{-220,20},{-180,60}})));
    Modelica.Blocks.Math.Add add(k2=-1)
      annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));
    Modelica.Blocks.Sources.Constant const(k=bandwidth/2)
      annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));

    Modelica.Blocks.Math.Add add1
      annotation (Placement(transformation(extent={{-120,-180},{-100,-160}})));
    Modelica.Blocks.MathInteger.MultiSwitch multiSwitch1(
      expr={2,1},
      y_default=0,
      use_pre_as_default=false,
      nu=2) annotation (Placement(transformation(extent={{140,-50},{180,-30}})));
    Modelica.Blocks.Interfaces.IntegerOutput stage "Coil stage control signal"
      annotation (Placement(transformation(extent={{218,-50},{238,-30}})));
    Modelica.Blocks.Logical.Not not1
      annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
    Modelica.Blocks.Logical.Not not2
      annotation (Placement(transformation(extent={{40,-160},{60,-140}})));
  equation
    connect(con1.reference, reference) annotation (Line(
        points={{-22,-104},{-40,-104},{-40,40},{-200,40}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(const.y, add.u2) annotation (Line(
        points={{-139,-150},{-130,-150},{-130,-136},{-122,-136}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(const.y, add1.u1) annotation (Line(
        points={{-139,-150},{-132,-150},{-132,-164},{-122,-164}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(add.u1, u) annotation (Line(
        points={{-122,-124},{-154,-124},{-154,-119.5},{-193,-119.5}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(add1.u2, u) annotation (Line(
        points={{-122,-176},{-172,-176},{-172,-119.5},{-193,-119.5}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(add.y, con1.u) annotation (Line(
        points={{-99,-130},{-60,-130},{-60,-116},{-22,-116}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(add1.y, con2.u) annotation (Line(
        points={{-99,-170},{-61.5,-170},{-61.5,-146},{-22,-146}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(reference, con2.reference) annotation (Line(
        points={{-200,40},{-40,40},{-40,-134},{-22,-134}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(multiSwitch1.y, stage) annotation (Line(
        points={{181,-40},{228,-40}},
        color={255,127,0},
        smooth=Smooth.None));
    connect(not2.y, multiSwitch1.u[1]) annotation (Line(
        points={{61,-150},{120,-150},{120,-38.5},{140,-38.5}},
        color={255,0,255},
        smooth=Smooth.None));
    connect(not1.y, multiSwitch1.u[2]) annotation (Line(
        points={{61,-110},{116,-110},{116,-41.5},{140,-41.5}},
        color={255,0,255},
        smooth=Smooth.None));
    connect(con1.y, not1.u) annotation (Line(
        points={{1,-110},{38,-110}},
        color={255,0,255},
        smooth=Smooth.None));
    connect(con2.y, not2.u) annotation (Line(
        points={{1,-140},{20,-140},{20,-150},{38,-150}},
        color={255,0,255},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(extent={{-180,-200},{220,100}},
            preserveAspectRatio=true), graphics),                          Icon(
          coordinateSystem(extent={{-180,-200},{220,100}}, preserveAspectRatio=
              true), graphics={Rectangle(
            extent={{-180,100},{220,-200}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}));
  end ControllerTwoStage;
equation
  connect(mulSpeCon.stage, mulStaDX.stage) annotation (Line(
      points={{-39.6,-129.333},{-20,-129.333},{-20,-156},{-3,-156}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(rooVarSpe.TOutDryBul, weaBus.TDryBul) annotation (Line(
      points={{239.067,52.3077},{230,52.3077},{230,52},{230,52},{230,70},{-128,
          70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTemSupAir2.port_b,fan2. port_a)
                                           annotation (Line(
      points={{76,-240},{98,-240}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(varSpeDX.port_b, senTemSupAir2.port_a)
                                                annotation (Line(
      points={{16,-240},{64,-240}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemHXEvaOut2.port_b, varSpeDX.port_a)
                                               annotation (Line(
      points={{-66,-240},{-4,-240}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(varSpeDX.TOut, weaBus.TDryBul) annotation (Line(
      points={{-5,-237},{-64,-237},{-64,-226},{-128,-226},{-128,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hex2.port_b1,senTemHXEvaOut2. port_a)
                                           annotation (Line(
      points={{-92,-240},{-78,-240}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(out.ports[3], hex1.port_a1) annotation (Line(
      points={{-154,-65.3333},{-136,-65.3333},{-136,-164},{-110,-164}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(out.ports[4], hex1.port_b2) annotation (Line(
      points={{-154,-66.6667},{-140,-66.6667},{-140,-176},{-110,-176}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(out.ports[5], hex2.port_a1) annotation (Line(
      points={{-154,-68},{-146,-68},{-146,-240},{-130,-240},{-130,-240},{-112,
          -240}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(out.ports[6], hex2.port_b2) annotation (Line(
      points={{-154,-69.3333},{-150,-69.3333},{-150,-252},{-112,-252}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan2.port_b, rooVarSpe.ports[1]) annotation (Line(
      points={{118,-240},{250.283,-240},{250.283,40.1154}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(rooVarSpe.ports[2], hex2.port_a2) annotation (Line(
      points={{253.517,40.1154},{253.517,-260},{-80,-260},{-80,-252},{-92,-252}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(mAir_flow.y, fan1.m_flow_in) annotation (Line(
      points={{81,10},{92,10},{92,-140},{110,-140},{110,-152}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mAir_flow.y, fan2.m_flow_in) annotation (Line(
      points={{81,10},{92,10},{92,-212},{108,-212},{108,-228}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rooSinSpe.TOutDryBul, weaBus.TDryBul) annotation (Line(
      points={{119.067,52.3077},{100,52.3077},{100,70},{-128,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sinSpePow.u, sinSpeDX.P) annotation (Line(
      points={{38,-30},{30,-30},{30,-55},{19,-55}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mulSpePow.u, mulStaDX.P) annotation (Line(
      points={{38,-130},{30,-130},{30,-156},{19,-156},{19,-155}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(varSpeDX.P, varSpePow.u) annotation (Line(
      points={{17,-231},{30,-231},{30,-210},{38,-210}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRooSetPoi.y, con.reference) annotation (Line(
      points={{-99,18},{-74,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rooSinSpe.TRoo, con.u) annotation (Line(
      points={{140.933,52.3077},{152,52.3077},{152,32},{-80,32},{-80,6},{-74,6}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(not1.u, con.y) annotation (Line(
      points={{-40,12},{-51,12}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(not1.y, sinSpeDX.on) annotation (Line(
      points={{-17,12},{-10,12},{-10,-56},{-3,-56}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(mulSpeCon.reference, TRooSetPoi.y) annotation (Line(
      points={{-61,-124},{-86,-124},{-86,18},{-99,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rooMulSpe.TRoo, mulSpeCon.u) annotation (Line(
      points={{200.933,52.3077},{220,52.3077},{220,-100},{-70,-100},{-70,
          -134.633},{-60.65,-134.633}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRooSetPoi.y, conVarSpe.u_s) annotation (Line(
      points={{-99,18},{-86,18},{-86,-210},{-62,-210}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conVarSpe.u_m, rooVarSpe.TRoo) annotation (Line(
      points={{-50,-222},{-50,-280},{280,-280},{280,52.3077},{260.933,52.3077}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(conVarSpe.y, varSpeDX.speRat) annotation (Line(
      points={{-39,-210},{-20,-210},{-20,-232},{-5,-232}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Documentation(info="<html>
<p>
This model illustrates the use of the air source DX coil models with
single speed compressor, multi-stage compressor, and variable
speed compressor.
The three systems all have the same simple model for a room,
and the same HVAC components, except for the coil.
The top system has a DX coil with single speed compressor
and on/off control with dead-band.
The middle system has a DX coil with two stages, each
representing a different compressor speed.
The bottom system has a DX coil with variable speed control
for the compressor.
</p>
<p>
All coils are controlled based on the respective room air temperature.
The plot below shows how room air temperatures and humidity levels
are controlled with the respective coils.
The single speed coil has the highest room air humidity level because
during its off-time, water that accumulated on the coil evaporates
into the air stream.
This effect is smaller for the coil with two compressor stages
and for the coil with variable compressor speed, as both of these coils
switch off less frequent.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/DXCoils/AirSource/Examples/SpaceCooling.png\" />
</p>
<h4>Implementation</h4>
<p>
The model is based on
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 19, 2023 by Xing Lu and Karthik Devaprasad:<br/>
Updated instance classes for <code>sinSpeDX</code> and </code>varSpeDX</code>.
</li>
<li>
September 24, 2015 by Michael Wetter:<br/>
Set <code>start</code> attributes in <code>SimpleRoom</code> so
that the model translates when using the pedantic mode in Dymola 2016.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">#426</a>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
September 13, 2013, by Michael Wetter:<br/>
Changed control implementation of variable speed coil
to use a proportional controller.
</li>
<li>
January 11, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-200,-300},{300,
            100}}), graphics),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/AirSource/Examples/SpaceCooling.mos"
        "Simulate and plot"),
    experiment(StartTime=1.58112e+07,
               Tolerance=1e-6, StopTime=1.6416e+07));
end SpaceCooling;
