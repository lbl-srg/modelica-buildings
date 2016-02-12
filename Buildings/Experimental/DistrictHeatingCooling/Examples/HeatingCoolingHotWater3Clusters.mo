within Buildings.Experimental.DistrictHeatingCooling.Examples;
model HeatingCoolingHotWater3Clusters
  "Validation model for a system with three clusters of buildings"
  extends Modelica.Icons.Example;
    package Medium = Buildings.Media.Water "Fluid in the pipes";

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 2.5E6
    "Nominal heat flow rate, positive for heating, negative for cooling";

  parameter Modelica.SIunits.Temperature TSetHeaLea = 273.15+12
    "Set point for leaving fluid temperature warm supply"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.Temperature TSetCooLea = 273.15+16
    "Set point for leaving fluid temperature cold supply"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa")=30000
    "Pressure difference at nominal flow rate"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.TemperatureDifference dT_nominal(
    min=0.5,
    displayUnit="K") = TSetCooLea-TSetHeaLea
    "Temperature difference between warm and cold pipe"
    annotation(Dialog(group="Design parameter"));

  parameter Real R_nominal(unit="Pa/m") = 100
    "Pressure drop per meter at nominal flow rate";

  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal = Q_flow_nominal/4200/dT_nominal
    "Nominal mass flow rate";
  Plants.HeatingCoolingCarnot_T
                 pla(
    redeclare package Medium = Medium,
    show_T=true,
    m_flow_nominal = m_flow_nominal) "Heating and cooling plant"
    annotation (Placement(transformation(extent={{-510,100},{-490,120}})));
  Buildings.Fluid.Sources.Boundary_pT pSet(redeclare package Medium = Medium,
      nPorts=1) "Model to set the reference pressure"
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-562,110})));
  Buildings.Fluid.FixedResistances.Pipe pip(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-380,130},{-360,150}})));
  Buildings.Fluid.FixedResistances.Pipe pip1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-362,10},{-382,30}})));
  Buildings.Fluid.FixedResistances.Pipe pip2(
    redeclare package Medium = Medium,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal/3)
    annotation (Placement(transformation(extent={{140,130},{160,150}})));
  Buildings.Fluid.FixedResistances.Pipe pip3(
    redeclare package Medium = Medium,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal/3)
    annotation (Placement(transformation(extent={{160,10},{140,30}})));
  Buildings.Fluid.FixedResistances.Pipe pip4(
    redeclare package Medium = Medium,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal/3)
    annotation (Placement(transformation(extent={{140,-90},{160,-70}})));
  Buildings.Fluid.FixedResistances.Pipe pip5(
    redeclare package Medium = Medium,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal/3)
    annotation (Placement(transformation(extent={{160,-210},{140,-190}})));

  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT larOff1(
    redeclare package Medium = Medium,
    filNam=
        "modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgLargeOfficeNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos",
    TOut_nominal=273.15)
    "Large office"
    annotation (Placement(transformation(extent={{-300,60},{-260,100}})));

  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT ret1(
    redeclare package Medium = Medium,
    filNam=
        "modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgStand-aloneRetailNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos",
    TOut_nominal=273.15) "Retail"
    annotation (Placement(transformation(extent={{-180,60},{-140,100}})));

  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT larOff2(
      redeclare package Medium = Medium,
      filNam="modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgLargeOfficeNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos",
    TOut_nominal=273.15)
    "Large office"
    annotation (Placement(transformation(extent={{-60,60},{-20,100}})));
  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT apa1(
    redeclare package Medium = Medium,
    filNam=
        "modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgMidriseApartmentNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos",
    TOut_nominal=273.15)
    "Midrise apartment"
    annotation (Placement(transformation(extent={{220,60},{260,100}})));

  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT larOff3(
    redeclare package Medium = Medium,
    filNam="modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgLargeOfficeNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos",
    TOut_nominal=273.15)
    "Large office"
    annotation (Placement(transformation(extent={{360,60},{400,100}})));

  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT larOff4(
    redeclare package Medium = Medium,
    filNam=
        "modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgLargeOfficeNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos",
    show_T=true,
    TOut_nominal=273.15)
    "Large office"
    annotation (Placement(transformation(extent={{500,60},{540,100}})));

  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT apa2(
    redeclare package Medium = Medium,
    filNam=
        "modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgMidriseApartmentNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos",
    TOut_nominal=273.15)
    "Midrise apartment"
    annotation (Placement(transformation(extent={{220,-160},{260,-120}})));

  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT ret2(
    redeclare package Medium = Medium,
    filNam=
        "modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgStand-aloneRetailNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos",
    TOut_nominal=273.15) "Retail"
    annotation (Placement(transformation(extent={{360,-160},{400,-120}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos",
      computeWetBulbTemperature=false) "File reader that reads weather data"
    annotation (Placement(transformation(extent={{-400,180},{-380,200}})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM splSup1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{-330,130},{-310,150}})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM splRet1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{-250,30},{-230,10}})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM splSup2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{-210,130},{-190,150}})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM splRet2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{-130,30},{-110,10}})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM splSup3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{-90,130},{-70,150}})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM splRet3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{-10,30},{10,10}})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM splSup5(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{190,130},{210,150}})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM splRet5(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{270,30},{290,10}})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM splSup6(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{330,130},{350,150}})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM splRet6(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{410,30},{430,10}})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM splSup4(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{50,130},{70,150}})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM splRet4(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{90,10},{110,30}})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM splSup7(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{180,-90},{200,-70}})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM splRet7(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{270,-190},{290,-210}})));
protected
  Modelica.Blocks.Sources.Constant TSetC(k=TSetCooLea)
    "Set point temperature for leaving water"
    annotation (Placement(transformation(extent={{-560,160},{-540,180}})));
protected
  Modelica.Blocks.Sources.Constant TSetH(k=TSetHeaLea)
    "Set point temperature for leaving water"
    annotation (Placement(transformation(extent={{-560,190},{-540,210}})));
public
  Plants.LakeWaterHeatExchanger_T bayWatHex(
    dp_nominal=0,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal) "Bay water heat exchanger"
    annotation (Placement(transformation(extent={{-440,80},{-420,104}})));
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-348,182},{-332,198}}), iconTransformation(
          extent={{-328,64},{-308,84}})));

  Modelica.Blocks.Math.MultiSum PHea(nu=17)
    "Electrical energy use for space heating and hot water"
    annotation (Placement(transformation(extent={{604,364},{616,376}})));
  Modelica.Blocks.Math.MultiSum PCoo(nu=9) "Electrical energy use for cooling"
    annotation (Placement(transformation(extent={{604,324},{616,336}})));
  Modelica.Blocks.Continuous.Integrator EEleHea(y(unit="J"))
    "Electrical energy for space heating and hot water"
    annotation (Placement(transformation(extent={{640,360},{660,380}})));
  Modelica.Blocks.Continuous.Integrator EEleCoo(y(unit="J"))
    "Electrical energy for cooling"
    annotation (Placement(transformation(extent={{640,320},{660,340}})));
  Modelica.Blocks.Math.MultiSum QHea(nu=8)
    "Thermal energy use for space heating"
    annotation (Placement(transformation(extent={{604,284},{616,296}})));
  Modelica.Blocks.Math.MultiSum QHotWat(nu=8)
    "Thermal energy use for hot water"
    annotation (Placement(transformation(extent={{604,244},{616,256}})));
  Modelica.Blocks.Math.MultiSum QCoo(nu=8) "Thermal energy use for cooling"
    annotation (Placement(transformation(extent={{604,204},{616,216}})));
  Modelica.Blocks.Continuous.Integrator ETheHea(y(unit="J"))
    "Thermal energy for space heating"
    annotation (Placement(transformation(extent={{640,280},{660,300}})));
  Modelica.Blocks.Continuous.Integrator ETheHotWat(y(unit="J"))
    "Thermal energy for hot water"
    annotation (Placement(transformation(extent={{640,240},{660,260}})));
  Modelica.Blocks.Continuous.Integrator ETheCoo(y(unit="J"))
    "Thermal energy for cooling"
    annotation (Placement(transformation(extent={{640,200},{660,220}})));

  Modelica.Blocks.Sources.RealExpression SPFHea(y=(ETheHea.y + ETheHotWat.y)/
        max(1, EEleHea.y)) "Seasonal performance factor for heating"
    annotation (Placement(transformation(extent={{700,340},{720,360}})));
  Modelica.Blocks.Sources.RealExpression SPFCoo(y=-ETheCoo.y/max(1, EEleCoo.y))
    "Seasonal performance factor for cooling"
    annotation (Placement(transformation(extent={{700,280},{720,300}})));
equation
  connect(weaBus, larOff1.weaBus) annotation (Line(
      points={{-340,190},{-340,190},{-280,190},{-280,96.7143}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, ret1.weaBus) annotation (Line(
      points={{-340,190},{-340,190},{-160,190},{-160,96.7143}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus,larOff2. weaBus) annotation (Line(
      points={{-340,190},{-340,190},{-40,190},{-40,96.7143}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, apa1.weaBus) annotation (Line(
      points={{-340,190},{-340,190},{240,190},{240,96.7143}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, larOff3.weaBus) annotation (Line(
      points={{-340,190},{380,190},{380,96.7143}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus,larOff4. weaBus) annotation (Line(
      points={{-340,190},{-340,190},{520,190},{520,96.7143}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, apa2.weaBus) annotation (Line(
      points={{-340,190},{-340,190},{120,190},{120,-44},{240,-44},{240,-123.286}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, ret2.weaBus) annotation (Line(
      points={{-340,190},{-340,190},{120,190},{120,-44},{380,-44},{380,-123.286}},
      color={255,204,51},
      thickness=0.5));
  connect(splSup1.port_2, splSup2.port_1) annotation (Line(points={{-310,140},{-260,
          140},{-210,140}}, color={0,127,255}));
  connect(splSup2.port_2, splSup3.port_1) annotation (Line(points={{-190,140},{-140,
          140},{-90,140}}, color={0,127,255}));
  connect(splSup1.port_3, larOff1.port_a) annotation (Line(points={{-320,130},{-320,
          130},{-320,84},{-320,80},{-300,80}}, color={0,127,255}));
  connect(larOff1.port_b, splRet1.port_3) annotation (Line(points={{-260.143,80},
          {-240,80},{-240,30}}, color={0,127,255}));
  connect(splSup2.port_3, ret1.port_a) annotation (Line(points={{-200,130},{-200,
          130},{-200,94},{-200,80},{-180,80}}, color={0,127,255}));
  connect(splSup3.port_3, larOff2.port_a) annotation (Line(points={{-80,130},{-80,
          130},{-80,80},{-60,80}}, color={0,127,255}));
  connect(ret1.port_b, splRet2.port_3) annotation (Line(points={{-140.143,80},{
          -120,80},{-120,30}},
                          color={0,127,255}));
  connect(splRet1.port_2, splRet2.port_1) annotation (Line(points={{-230,20},{-180,
          20},{-130,20}}, color={0,127,255}));
  connect(splRet2.port_2, splRet3.port_1)
    annotation (Line(points={{-110,20},{-60,20},{-10,20}}, color={0,127,255}));
  connect(larOff2.port_b, splRet3.port_3)
    annotation (Line(points={{-20.1429,80},{0,80},{0,30}}, color={0,127,255}));
  connect(pip2.port_b, splSup5.port_1) annotation (Line(points={{160,140},{175,140},
          {190,140}}, color={0,127,255}));
  connect(splSup5.port_2, splSup6.port_1)
    annotation (Line(points={{210,140},{330,140}}, color={0,127,255}));
  connect(splSup5.port_3, apa1.port_a) annotation (Line(points={{200,130},{200,130},
          {200,90},{200,80},{220,80}}, color={0,127,255}));
  connect(splSup6.port_3, larOff3.port_a) annotation (Line(points={{340,130},{340,
          130},{340,82},{340,80},{360,80}}, color={0,127,255}));
  connect(splSup6.port_2,larOff4. port_a) annotation (Line(points={{350,140},{408,
          140},{480,140},{480,80},{500,80}}, color={0,127,255}));
  connect(pip3.port_a, splRet5.port_1)
    annotation (Line(points={{160,20},{270,20}}, color={0,127,255}));
  connect(splRet5.port_2, splRet6.port_1)
    annotation (Line(points={{290,20},{410,20}}, color={0,127,255}));
  connect(apa1.port_b, splRet5.port_3) annotation (Line(points={{259.857,80},{
          259.857,80},{280,80},{280,30}},
                                  color={0,127,255}));
  connect(larOff3.port_b, splRet6.port_3) annotation (Line(points={{399.857,80},
          {420,80},{420,30}}, color={0,127,255}));
  connect(splRet6.port_2,larOff4. port_b) annotation (Line(points={{430,20},{
          482,20},{560,20},{560,80},{539.857,80}},
                                               color={0,127,255}));
  connect(splSup3.port_2, splSup4.port_1)
    annotation (Line(points={{-70,140},{50,140},{50,140}}, color={0,127,255}));
  connect(splSup4.port_2, pip2.port_a) annotation (Line(points={{70,140},{140,140},
          {140,140}}, color={0,127,255}));
  connect(splSup4.port_3, pip4.port_a) annotation (Line(points={{60,130},{60,130},
          {60,-26},{60,-80},{140,-80}}, color={0,127,255}));
  connect(splRet3.port_2, splRet4.port_1)
    annotation (Line(points={{10,20},{90,20}}, color={0,127,255}));
  connect(splRet4.port_2, pip3.port_b)
    annotation (Line(points={{110,20},{110,20},{140,20}}, color={0,127,255}));
  connect(splRet4.port_3, pip5.port_b) annotation (Line(points={{100,10},{100,10},
          {100,-200},{140,-200}}, color={0,127,255}));
  connect(pip4.port_b, splSup7.port_1) annotation (Line(points={{160,-80},{170,-80},
          {170,-80},{180,-80}}, color={0,127,255}));
  connect(splSup7.port_3, apa2.port_a) annotation (Line(points={{190,-90},{190,-90},
          {190,-140},{220,-140}}, color={0,127,255}));
  connect(apa2.port_b, splRet7.port_3) annotation (Line(points={{259.857,-140},
          {280,-140},{280,-190}},color={0,127,255}));
  connect(splSup7.port_2, ret2.port_a) annotation (Line(points={{200,-80},{252,-80},
          {340,-80},{340,-140},{360,-140}}, color={0,127,255}));
  connect(pip5.port_a, splRet7.port_1) annotation (Line(points={{160,-200},{216,
          -200},{270,-200}}, color={0,127,255}));
  connect(splRet7.port_2, ret2.port_b) annotation (Line(points={{290,-200},{342,
          -200},{420,-200},{420,-140},{399.857,-140}}, color={0,127,255}));
  connect(pip.port_b, splSup1.port_1)
    annotation (Line(points={{-360,140},{-330,140}}, color={0,127,255}));
  connect(pip1.port_a, splRet1.port_1)
    annotation (Line(points={{-362,20},{-250,20}}, color={0,127,255}));
  connect(pla.TSetHea, TSetH.y) annotation (Line(points={{-512,118},{-512,118},
          {-530,118},{-530,200},{-539,200}},           color={0,0,127}));
  connect(TSetC.y, pla.TSetCoo) annotation (Line(points={{-539,170},{-534,170},
          {-534,114},{-512,114}},color={0,0,127}));
  connect(bayWatHex.TSetHea, TSetH.y) annotation (Line(points={{-442,97.3333},{
          -470,97.3333},{-470,200},{-539,200}},
                                      color={0,0,127}));
  connect(TSetC.y,bayWatHex. TSetCoo) annotation (Line(points={{-539,170},{-476,
          170},{-476,94},{-448,94},{-448,93.3333},{-442,93.3333}},
                                            color={0,0,127}));
  connect(bayWatHex.port_b1, pip.port_a) annotation (Line(points={{-420,90.6667},
          {-410,90.6667},{-410,92},{-400,92},{-400,140},{-380,140}}, color={0,
          127,255}));
  connect(bayWatHex.port_a2, pip1.port_b) annotation (Line(points={{-420,
          82.6667},{-400,82.6667},{-400,20},{-382,20}}, color={0,127,255}));
  connect(bayWatHex.port_b2, pla.port_a) annotation (Line(points={{-440,82.6667},
          {-488,82.6667},{-488,84},{-540,84},{-540,110},{-510,110}}, color={0,
          127,255}));
  connect(pla.port_b, bayWatHex.port_a1) annotation (Line(points={{-490,110},{
          -490,110},{-480,110},{-480,90.6667},{-440,90.6667}}, color={0,127,255}));
  connect(pSet.ports[1], pla.port_a) annotation (Line(points={{-552,110},{-552,
          110},{-510,110}}, color={0,127,255}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-380,190},{-340,190},{-340,190}},
      color={255,204,51},
      thickness=0.5));
  connect(pla.TSink, weaBus.TDryBul) annotation (Line(points={{-512,104},{-520,
          104},{-520,160},{-340,160},{-340,190}}, color={0,0,127}));
  connect(PHea.y, EEleHea.u) annotation (Line(points={{617.02,370},{627.51,370},
          {638,370}}, color={0,0,127}));
  connect(PCoo.y, EEleCoo.u) annotation (Line(points={{617.02,330},{627.51,330},
          {638,330}}, color={0,0,127}));

  connect(pla.PComHea, PHea.u[1]) annotation (Line(points={{-489,119},{-480,119},
          {-480,373.953},{604,373.953}}, color={0,0,127}));
  connect(larOff1.PHea, PHea.u[2]) annotation (Line(points={{-259.286,100},{
          -250,100},{-250,373.459},{604,373.459}},
                                              color={0,0,127}));
  connect(ret1.PHea, PHea.u[3]) annotation (Line(points={{-139.286,100},{-130,
          100},{-130,372.965},{604,372.965}},
                                     color={0,0,127}));
  connect(larOff2.PHea, PHea.u[4]) annotation (Line(points={{-19.2857,100},{-10,
          100},{-10,372.471},{604,372.471}}, color={0,0,127}));
  connect(apa1.PHea, PHea.u[5]) annotation (Line(points={{260.714,100},{260.714,
          100},{270,100},{270,371.976},{604,371.976}}, color={0,0,127}));
  connect(larOff3.PHea, PHea.u[6]) annotation (Line(points={{400.714,100},{412,
          100},{412,371.482},{604,371.482}},
                                color={0,0,127}));
  connect(larOff4.PHea, PHea.u[7]) annotation (Line(points={{540.714,100},{552,
          100},{552,370.988},{604,370.988}},
                                        color={0,0,127}));
  connect(apa2.PHea, PHea.u[8]) annotation (Line(points={{260.714,-120},{
          260.714,-120},{280,-120},{280,-20},{572,-20},{572,370.494},{604,
          370.494}},
        color={0,0,127}));
  connect(ret2.PHea, PHea.u[9]) annotation (Line(points={{400.714,-120},{410,
          -120},{410,-20},{572,-20},{572,370},{604,370}},
                                                        color={0,0,127}));

  connect(larOff1.PHotWat, PHea.u[10]) annotation (Line(points={{-259.286,
          97.1429},{-250,97.1429},{-250,369.506},{604,369.506}},
                                              color={0,0,127}));
  connect(ret1.PHotWat, PHea.u[11]) annotation (Line(points={{-139.286,97.1429},
          {-130,97.1429},{-130,369.012},{604,369.012}},
                                     color={0,0,127}));
  connect(larOff2.PHotWat, PHea.u[12]) annotation (Line(points={{-19.2857,
          97.1429},{-10,97.1429},{-10,368.518},{604,368.518}},
                                             color={0,0,127}));
  connect(apa1.PHotWat, PHea.u[13]) annotation (Line(points={{260.714,97.1429},
          {260.714,97.1429},{270,97.1429},{270,368.024},{604,368.024}},
                                                       color={0,0,127}));
  connect(larOff3.PHotWat, PHea.u[14]) annotation (Line(points={{400.714,
          97.1429},{412,97.1429},{412,367.529},{604,367.529}},
                                color={0,0,127}));
  connect(larOff4.PHotWat, PHea.u[15]) annotation (Line(points={{540.714,
          97.1429},{552,97.1429},{552,367.035},{604,367.035}},
                                        color={0,0,127}));
  connect(apa2.PHotWat, PHea.u[16]) annotation (Line(points={{260.714,-122.857},
          {270,-122.857},{270,-122},{280,-122},{280,-120},{280,-20},{572,-20},{
          572,366.541},{604,366.541}},
        color={0,0,127}));
  connect(ret2.PHotWat, PHea.u[17]) annotation (Line(points={{400.714,-122.857},
          {410,-122.857},{410,-20},{572,-20},{572,366.047},{604,366.047}},
                                                        color={0,0,127}));

  connect(pla.PComCoo, PCoo.u[1]) annotation (Line(points={{-489,117},{-480,117},
          {-480,333.733},{604,333.733}}, color={0,0,127}));
  connect(larOff1.PCoo, PCoo.u[2]) annotation (Line(points={{-259.286,94.2857},
          {-250,94.2857},{-250,332.8},{604,332.8}},
                                              color={0,0,127}));
  connect(ret1.PCoo, PCoo.u[3]) annotation (Line(points={{-139.286,94.2857},{
          -130,94.2857},{-130,331.867},{604,331.867}},
                                     color={0,0,127}));
  connect(larOff2.PCoo, PCoo.u[4]) annotation (Line(points={{-19.2857,94.2857},
          {-10,94.2857},{-10,330.933},{604,330.933}},
                                             color={0,0,127}));
  connect(apa1.PCoo, PCoo.u[5]) annotation (Line(points={{260.714,94.2857},{
          260.714,94.2857},{270,94.2857},{270,330},{604,330}},
                                                       color={0,0,127}));
  connect(larOff3.PCoo, PCoo.u[6]) annotation (Line(points={{400.714,94.2857},{
          412,94.2857},{412,329.067},{604,329.067}},
                                color={0,0,127}));
  connect(larOff4.PCoo, PCoo.u[7]) annotation (Line(points={{540.714,94.2857},{
          552,94.2857},{552,328.133},{604,328.133}},
                                        color={0,0,127}));
  connect(apa2.PCoo, PCoo.u[8]) annotation (Line(points={{260.714,-125.714},{
          270,-125.714},{270,-126},{280,-126},{280,-120},{280,-20},{572,-20},{
          572,327.2},{604,327.2}},
        color={0,0,127}));
  connect(ret2.PCoo, PCoo.u[9]) annotation (Line(points={{400.714,-125.714},{
          410,-125.714},{410,-20},{572,-20},{572,326.267},{604,326.267}},
                                                        color={0,0,127}));

  connect(QHea.y, ETheHea.u) annotation (Line(points={{617.02,290},{627.51,290},
          {638,290}}, color={0,0,127}));
  connect(QCoo.y, ETheCoo.u) annotation (Line(points={{617.02,210},{627.51,210},
          {638,210}}, color={0,0,127}));

  connect(larOff1.QHea_flow, QHea.u[1]) annotation (Line(points={{-259.286,90},
          {-259.286,90},{-240,90},{-240,293.675},{604,293.675}},
                                                            color={0,0,127}));
  connect(ret1.QHea_flow, QHea.u[2]) annotation (Line(points={{-139.286,90},{
          -120,90},{-120,292.625},{604,292.625}},
                                             color={0,0,127}));
  connect(larOff2.QHea_flow, QHea.u[3]) annotation (Line(points={{-19.2857,90},
          {0,90},{0,291.575},{604,291.575}},color={0,0,127}));
  connect(apa1.QHea_flow, QHea.u[4]) annotation (Line(points={{260.714,90},{280,
          90},{280,290.525},{604,290.525}},
                                    color={0,0,127}));
  connect(larOff3.QHea_flow, QHea.u[5]) annotation (Line(points={{400.714,90},{
          400.714,90},{420,90},{420,289.475},{604,289.475}},  color={0,0,127}));
  connect(larOff4.QHea_flow, QHea.u[6]) annotation (Line(points={{540.714,90},{
          560,90},{560,288.425},{604,288.425}},
                                            color={0,0,127}));
  connect(apa2.QHea_flow, QHea.u[7]) annotation (Line(points={{260.714,-130},{
          290,-130},{290,-30},{580,-30},{580,287.375},{604,287.375}},
                                                              color={0,0,127}));
  connect(ret2.QHea_flow, QHea.u[8]) annotation (Line(points={{400.714,-130},{
          420,-130},{420,-30},{580,-30},{580,286.325},{604,286.325}},
                                                                  color={0,0,127}));

//////

  connect(larOff1.QHotWat_flow, QHotWat.u[1]) annotation (Line(points={{
          -259.286,87.1429},{-259.286,87.1429},{-240,87.1429},{-240,253.675},{
          604,253.675}},                                    color={0,0,127}));
  connect(ret1.QHotWat_flow, QHotWat.u[2]) annotation (Line(points={{-139.286,
          87.1429},{-120,87.1429},{-120,252.625},{604,252.625}},
                                             color={0,0,127}));
  connect(larOff2.QHotWat_flow, QHotWat.u[3]) annotation (Line(points={{
          -19.2857,87.1429},{0,87.1429},{0,251.575},{604,251.575}},
                                            color={0,0,127}));
  connect(apa1.QHotWat_flow, QHotWat.u[4]) annotation (Line(points={{260.714,
          87.1429},{280,87.1429},{280,250.525},{604,250.525}},
                                    color={0,0,127}));
  connect(larOff3.QHotWat_flow, QHotWat.u[5]) annotation (Line(points={{400.714,
          87.1429},{410,87.1429},{410,90},{420,90},{420,249.475},{604,249.475}},
                                                              color={0,0,127}));
  connect(larOff4.QHotWat_flow, QHotWat.u[6]) annotation (Line(points={{540.714,
          87.1429},{560,87.1429},{560,248.425},{604,248.425}},
                                            color={0,0,127}));
  connect(apa2.QHotWat_flow, QHotWat.u[7]) annotation (Line(points={{260.714,
          -132.857},{290,-132.857},{290,-30},{580,-30},{580,247.375},{604,
          247.375}},                                          color={0,0,127}));
  connect(ret2.QHotWat_flow, QHotWat.u[8]) annotation (Line(points={{400.714,
          -132.857},{420,-132.857},{420,-30},{580,-30},{580,246.325},{604,
          246.325}},                                              color={0,0,127}));

////
  connect(larOff1.QCoo_flow, QCoo.u[1]) annotation (Line(points={{-259.286,
          84.2857},{-259.286,84.2857},{-240,84.2857},{-240,213.675},{604,
          213.675}},                                        color={0,0,127}));
  connect(ret1.QCoo_flow, QCoo.u[2]) annotation (Line(points={{-139.286,84.2857},
          {-120,84.2857},{-120,212.625},{604,212.625}},
                                             color={0,0,127}));
  connect(larOff2.QCoo_flow, QCoo.u[3]) annotation (Line(points={{-19.2857,
          84.2857},{0,84.2857},{0,211.575},{604,211.575}},
                                            color={0,0,127}));
  connect(apa1.QCoo_flow, QCoo.u[4]) annotation (Line(points={{260.714,84.2857},
          {280,84.2857},{280,210.525},{604,210.525}},
                                    color={0,0,127}));
  connect(larOff3.QCoo_flow, QCoo.u[5]) annotation (Line(points={{400.714,
          84.2857},{410,84.2857},{410,90},{420,90},{420,209.475},{604,209.475}},
                                                              color={0,0,127}));
  connect(larOff4.QCoo_flow, QCoo.u[6]) annotation (Line(points={{540.714,
          84.2857},{560,84.2857},{560,208.425},{604,208.425}},
                                            color={0,0,127}));
  connect(apa2.QCoo_flow, QCoo.u[7]) annotation (Line(points={{260.714,-135.714},
          {290,-135.714},{290,-30},{580,-30},{580,207.375},{604,207.375}},
                                                              color={0,0,127}));
  connect(ret2.QCoo_flow, QCoo.u[8]) annotation (Line(points={{400.714,-135.714},
          {420,-135.714},{420,-30},{580,-30},{580,206.325},{604,206.325}},
                                                                  color={0,0,127}));

  connect(QHotWat.y, ETheHotWat.u) annotation (Line(points={{617.02,250},{
          627.51,250},{638,250}}, color={0,0,127}));
  annotation(experiment(Tolerance=1E-6, StopTime=31536000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DistrictHeatingCooling/Examples/HeatingCoolingHotWater3Clusters.mos"
        "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This model validates a small ideal anergy heating and cooling network.
The heating and cooling heat flow rates extracted from the district supply
are prescribed by time series.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 20, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-580,-260},{780,
            400}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end HeatingCoolingHotWater3Clusters;
