within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Validation;
model Chiller
  "Validation of the ETS model with heat recovery chiller"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";
  parameter Modelica.SIunits.MassFlowRate mHeaWat_flow_nominal=
    0.9 * datChi.mCon_flow_nominal
    "Nominal heating water mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mChiWat_flow_nominal=
    0.9 * datChi.mEva_flow_nominal
    "Nominal chilled water mass flow rate";
  parameter Fluid.Chillers.Data.ElectricEIR.Generic datChi(
    QEva_flow_nominal=-1e6,
    COP_nominal=3,
    PLRMax=1,
    PLRMinUnl=0.3,
    PLRMin=0.3,
    etaMotor=1,
    mEva_flow_nominal=1e6 / 5 / 4186,
    mCon_flow_nominal=1e6 * (1 + 1/3) / 5 / 4186,
    TEvaLvg_nominal=280.15,
    capFunT={1,0,0,0,0,0},
    EIRFunT={0.34,-0.02,0,+0.02,0,0},
    EIRFunPLR={1,0,0},
    TEvaLvgMin=275.15,
    TEvaLvgMax=288.15,
    TConEnt_nominal=313.15,
    TConEntMin=303.15,
    TConEntMax=333.15) "Chiller performance data"
    annotation (Placement(transformation(extent={{-220,182},{-200,202}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupSet(
    k=45 + 273.15,
    y(final unit="K", displayUnit="degC"))
    "Heating water supply temperature set-point"
    annotation (Placement(transformation(extent={{-160,130},{-140,150}})));
  Fluid.Sources.Boundary_pT heaWat(
    redeclare package Medium = Medium, nPorts=1)
              "Heating water boundary conditions"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,14})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatSupSet(
    k=7 + 273.15,
    y(final unit="K", displayUnit="degC"))
    "Chilled water supply temperature set-point"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));
  Fluid.Sensors.TemperatureTwoPort senTHeaWatSup(redeclare final package
      Medium =
        Medium, m_flow_nominal=datChi.mCon_flow_nominal)
    "Heating water supply temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-80,40})));
  Fluid.Sensors.TemperatureTwoPort senTChiWatSup(redeclare final package
      Medium =
        Medium, m_flow_nominal=datChi.mEva_flow_nominal)
    "Chilled water supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,40})));
  Fluid.Sensors.TemperatureTwoPort senTHeaWatRet(redeclare final package
      Medium =
        Medium, m_flow_nominal=datChi.mCon_flow_nominal)
    "Heating water return temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,-40})));
  Fluid.Sensors.TemperatureTwoPort senTChiWatRet(redeclare final package
      Medium =
        Medium, m_flow_nominal=datChi.mEva_flow_nominal)
    "Chilled water return temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={70,-40})));
  EnergyTransferStations.Combined.Generation5.Chiller ets(
    redeclare final package MediumBui = Medium,
    redeclare final package MediumDis = Medium,
    QChiWat_flow_nominal=datChi.QEva_flow_nominal,
    QHeaWat_flow_nominal=-datChi.QEva_flow_nominal*(1 + 1/datChi.COP_nominal),
    dp1Hex_nominal=20E3,
    dp2Hex_nominal=20E3,
    QHex_flow_nominal=-datChi.QEva_flow_nominal,
    T_a1Hex_nominal=282.15,
    T_b1Hex_nominal=277.15,
    T_a2Hex_nominal=275.15,
    T_b2Hex_nominal=280.15,
    dpCon_nominal=15E3,
    dpEva_nominal=15E3,
    datChi=datChi,
    dTHys=2,
    dTDea=0,
    nPorts_aHeaWat=1,
    nPorts_bHeaWat=1,
    nPorts_bChiWat=1,
    nPorts_aChiWat=1)
    annotation (Placement(transformation(extent={{-30,-84},{30,-24}})));
  Fluid.Sources.Boundary_pT disWat(
    redeclare final package Medium = Medium,
    use_T_in=true,
    nPorts=2)
    "District water boundary conditions"
    annotation (Placement(
      transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-150,-140})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TDisWatSup(k=9 + 273.15,
    y(final unit="K", displayUnit="degC"))
    "District water supply temperature"
    annotation (Placement(transformation(extent={{-260,-150},{-240,-130}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow
    pumChiWat(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mChiWat_flow_nominal,
    dp_nominal=100E3) "Chilled water distribution pump"
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai2(final k=mChiWat_flow_nominal)
    "Scale to nominal mass flow rate"
    annotation (Placement(transformation(extent={{72,70},{92,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(final k=mHeaWat_flow_nominal)
    "Scale to nominal mass flow rate"
    annotation (Placement(transformation(extent={{48,70},{28,90}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow
    pumHeaWat(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal,
    dp_nominal=100E3) "Heating water distribution pump"
    annotation (Placement(transformation(extent={{10,30},{-10,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPum(k=1)
    "Distribution pump control signal"
    annotation (Placement(transformation(extent={{20,110},{40,130}})));
  Fluid.MixingVolumes.MixingVolume volHeaWat(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=45 + 273.15,
    final prescribedHeatFlowRate=true,
    redeclare final package Medium = Medium,
    V=10,
    final mSenFac=1,
    final m_flow_nominal=mHeaWat_flow_nominal,
    nPorts=2) "Volume for heating water distribution circuit" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-131,0})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai3(final k=-ets.QHeaWat_flow_nominal)
    "Scale to nominal heat flow rate"
    annotation (Placement(transformation(extent={{-200,50},{-180,70}})));
  HeatTransfer.Sources.PrescribedHeatFlow loaHea
    "Heating load as prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  Fluid.MixingVolumes.MixingVolume volChiWat(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=7 + 273.15,
    final prescribedHeatFlowRate=true,
    redeclare final package Medium = Medium,
    V=10,
    final mSenFac=1,
    final m_flow_nominal=mChiWat_flow_nominal,
    nPorts=2) "Volume for chilled water distribution circuit" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={129,0})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai4(final k=-ets.QChiWat_flow_nominal)
    "Scale to nominal heat flow rate"
    annotation (Placement(transformation(extent={{200,50},{180,70}})));
  HeatTransfer.Sources.PrescribedHeatFlow loaCoo
    "Cooling load as prescribed heat flow rate"
    annotation (Placement(transformation(extent={{162,50},{142,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uHeaCoo[2](k=fill(true, 2))
    "Heating / cooling enabled signal"
    annotation (Placement(transformation(extent={{-200,-70},{-180,-50}})));
  Modelica.Blocks.Sources.TimeTable loaHeaRat(table=[0,0; 1,0; 2,1; 6,1; 7,0.5;
        9,0.5; 10,0; 11,0],
               timeScale=1000)
                    "Heating load (ratio to nominal)"
    annotation (Placement(transformation(extent={{-240,50},{-220,70}})));
  Modelica.Blocks.Sources.TimeTable loaCooRat(table=[0,0; 3,0; 4,1; 14,1; 15,
        0.5; 16,0.5],    timeScale=1000)
                      "Cooling load (ratio to nominal)"
    annotation (Placement(transformation(extent={{240,52},{220,72}})));
equation
  connect(senTHeaWatRet.port_b, ets.ports_aHeaWat[1]) annotation (Line(points={{
          -70,-40},{-60,-40},{-60,-28},{-30,-28}}, color={0,127,255}));
  connect(ets.ports_bChiWat[1], senTChiWatSup.port_a) annotation (Line(points={{
          30,-38},{44,-38},{44,40},{60,40}}, color={0,127,255}));
  connect(ets.ports_aChiWat[1], senTChiWatRet.port_b) annotation (Line(points={{
          -30,-38},{-40,-38},{-40,0},{50,0},{50,-40},{60,-40}}, color={0,127,255}));
  connect(TChiWatSupSet.y, ets.TChiWatSupSet) annotation (Line(points={{-138,100},
          {-52,100},{-52,-70},{-34,-70}},color={0,0,127}));
  connect(THeaWatSupSet.y, ets.THeaWatSupSet) annotation (Line(points={{-138,
          140},{-48,140},{-48,-61.6},{-34,-61.6}},
                                          color={0,0,127}));
  connect(disWat.ports[1], ets.port_aDis) annotation (Line(points={{-140,-138},
          {-140,-80},{-30,-80}},color={0,127,255}));
  connect(ets.port_bDis, disWat.ports[2]) annotation (Line(points={{30,-80},{
          140,-80},{140,-180},{-140,-180},{-140,-142}},
                                                    color={0,127,255}));
  connect(TDisWatSup.y, disWat.T_in) annotation (Line(points={{-238,-140},{-192,
          -140},{-192,-136},{-162,-136}}, color={0,0,127}));
  connect(pumChiWat.port_a, senTChiWatSup.port_b)
    annotation (Line(points={{90,40},{80,40}},  color={0,127,255}));
  connect(gai2.y, pumChiWat.m_flow_in)
    annotation (Line(points={{94,80},{100,80},{100,52}},  color={0,0,127}));
  connect(ets.ports_bHeaWat[1], pumHeaWat.port_a) annotation (Line(points={{30,-28},
          {40,-28},{40,40},{10,40}},  color={0,127,255}));
  connect(pumHeaWat.port_b, senTHeaWatSup.port_a)
    annotation (Line(points={{-10,40},{-70,40}}, color={0,127,255}));
  connect(gai1.y, pumHeaWat.m_flow_in)
    annotation (Line(points={{26,80},{0,80},{0,52}},      color={0,0,127}));
  connect(yPum.y, gai1.u) annotation (Line(points={{42,120},{60,120},{60,80},{50,
          80}}, color={0,0,127}));
  connect(yPum.y, gai2.u) annotation (Line(points={{42,120},{60,120},{60,80},{70,
          80}}, color={0,0,127}));
  connect(gai3.y, loaHea.Q_flow)
    annotation (Line(points={{-178,60},{-160,60}}, color={0,0,127}));
  connect(loaHea.port, volHeaWat.heatPort) annotation (Line(points={{-140,60},{
          -132,60},{-132,10},{-131,10}},
                                    color={191,0,0}));
  connect(pumChiWat.port_b, volChiWat.ports[1])
    annotation (Line(points={{110,40},{119,40},{119,2}}, color={0,127,255}));
  connect(volChiWat.ports[2], senTChiWatRet.port_a)
    annotation (Line(points={{119,-2},{119,-40},{80,-40}}, color={0,127,255}));
  connect(senTHeaWatSup.port_b, volHeaWat.ports[1])
    annotation (Line(points={{-90,40},{-121,40},{-121,2}}, color={0,127,255}));
  connect(gai4.y, loaCoo.Q_flow)
    annotation (Line(points={{178,60},{162,60}}, color={0,0,127}));
  connect(loaCoo.port, volChiWat.heatPort)
    annotation (Line(points={{142,60},{129,60},{129,10}}, color={191,0,0}));
  connect(volHeaWat.ports[2], senTHeaWatRet.port_a) annotation (Line(points={{
          -121,-2},{-121,-40},{-90,-40}}, color={0,127,255}));
  connect(heaWat.ports[1], pumHeaWat.port_a)
    annotation (Line(points={{20,24},{20,40},{10,40}}, color={0,127,255}));
  connect(uHeaCoo[1].y, ets.uHea) annotation (Line(points={{-178,-60},{-60,-60},
          {-60,-46},{-34,-46}}, color={255,0,255}));
  connect(uHeaCoo[2].y, ets.uCoo) annotation (Line(points={{-178,-60},{-60,-60},
          {-60,-54},{-34,-54}}, color={255,0,255}));
  connect(loaHeaRat.y, gai3.u)
    annotation (Line(points={{-219,60},{-202,60}}, color={0,0,127}));
  connect(loaCooRat.y, gai4.u)
    annotation (Line(points={{219,62},{210,62},{210,60},{202,60}},
                                                 color={0,0,127}));
  annotation (Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-280,-220},{280,220}})),
  __Dymola_Commands(file=
"modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Combined/Generation5/Validation/Chiller.mos"
"Simulate and plot"),
    experiment(StopTime=10000, __Dymola_Algorithm="Dassl"));
end Chiller;
