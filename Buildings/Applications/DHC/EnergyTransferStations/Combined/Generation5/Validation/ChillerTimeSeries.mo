within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Validation;
model ChillerTimeSeries
  "Validation of the ETS model with heat recovery chiller"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";
  parameter String filNam=
    "modelica://Buildings/Applications/DHC/Loads/Examples/Resources/SwissResidential_20190916.mos"
    "File name with thermal loads as time series";
  parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal(
    max=-Modelica.Constants.eps)=
    Buildings.Experimental.DistrictHeatingCooling.SubStations.VaporCompression.BaseClasses.getPeakLoad(
    string="#Peak space cooling load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Design cooling heat flow rate (<=0)"
    annotation (Dialog(group="Design parameter"));
  parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(
    min=Modelica.Constants.eps)=
    Buildings.Experimental.DistrictHeatingCooling.SubStations.VaporCompression.BaseClasses.getPeakLoad(
    string="#Peak space heating load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Design parameter"));
  parameter Modelica.SIunits.MassFlowRate mHeaWat_flow_nominal=
    0.9 * datChi.mCon_flow_nominal
    "Nominal heating water mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mChiWat_flow_nominal=
    0.9 * datChi.mEva_flow_nominal
    "Nominal chilled water mass flow rate";
  parameter Fluid.Chillers.Data.ElectricEIR.Generic datChi(
    QEva_flow_nominal=QCoo_flow_nominal,
    COP_nominal=2,
    PLRMax=1,
    PLRMinUnl=0.3,
    PLRMin=0.3,
    etaMotor=1,
    mEva_flow_nominal=-QCoo_flow_nominal/5/4186,
    mCon_flow_nominal=-QCoo_flow_nominal*(1 + 1/2)/5/4186,
    TEvaLvg_nominal=275.15,
    capFunT={1,0,0,0,0,0},
    EIRFunT={0.34,-0.02,0,+0.02,0,0},
    EIRFunPLR={1,0,0},
    TEvaLvgMin=275.15,
    TEvaLvgMax=288.15,
    TConEnt_nominal=313.15,
    TConEntMin=303.15,
    TConEntMax=333.15) "Chiller performance data"
    annotation (Placement(transformation(extent={{-200,180},{-180,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupSet(
    k=45 + 273.15,
    y(final unit="K", displayUnit="degC"))
    "Heating water supply temperature set-point"
    annotation (Placement(transformation(extent={{-140,128},{-120,148}})));
  Fluid.Sources.Boundary_pT heaWat(
    redeclare package Medium = Medium, nPorts=1)
              "Heating water boundary conditions"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,12})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatSupSet(
    k=7 + 273.15,
    y(final unit="K", displayUnit="degC"))
    "Chilled water supply temperature set-point"
    annotation (Placement(transformation(extent={{-140,88},{-120,108}})));
  Fluid.Sensors.TemperatureTwoPort senTHeaWatSup(redeclare final package Medium =
        Medium, m_flow_nominal=datChi.mCon_flow_nominal)
    "Heating water supply temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-60,38})));
  Fluid.Sensors.TemperatureTwoPort senTChiWatSup(redeclare final package Medium =
        Medium, m_flow_nominal=datChi.mEva_flow_nominal)
    "Chilled water supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,38})));
  Fluid.Sensors.TemperatureTwoPort senTHeaWatRet(redeclare final package Medium =
        Medium, m_flow_nominal=datChi.mCon_flow_nominal)
    "Heating water return temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,-42})));
  Fluid.Sensors.TemperatureTwoPort senTChiWatRet(redeclare final package Medium =
        Medium, m_flow_nominal=datChi.mEva_flow_nominal)
    "Chilled water return temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={90,-42})));
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
    nPorts_aHeaWat=1,
    nPorts_bHeaWat=1,
    nPorts_bChiWat=1,
    nPorts_aChiWat=1)
    annotation (Placement(transformation(extent={{-10,-86},{50,-26}})));
  Fluid.Sources.Boundary_pT disWat(
    redeclare final package Medium = Medium,
    use_T_in=true,
    nPorts=2)
    "District water boundary conditions"
    annotation (Placement(
      transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-110,-142})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TDisWatSup(k=9 + 273.15,
    y(final unit="K", displayUnit="degC"))
    "District water supply temperature"
    annotation (Placement(transformation(extent={{-260,-152},{-240,-132}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow
    pumChiWat(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mChiWat_flow_nominal,
    dp_nominal=100E3) "Chilled water distribution pump"
    annotation (Placement(transformation(extent={{110,28},{130,48}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai2(final k=mChiWat_flow_nominal)
    "Scale to nominal mass flow rate"
    annotation (Placement(transformation(extent={{92,68},{112,88}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(final k=mHeaWat_flow_nominal)
    "Scale to nominal mass flow rate"
    annotation (Placement(transformation(extent={{68,68},{48,88}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow
    pumHeaWat(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal,
    dp_nominal=100E3) "Heating water distribution pump"
    annotation (Placement(transformation(extent={{30,28},{10,48}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPum(k=1)
    "Distribution pump control signal"
    annotation (Placement(transformation(extent={{40,108},{60,128}})));
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
        origin={-111,-2})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai3(final k=-1) "Opposite"
    annotation (Placement(transformation(extent={{-180,48},{-160,68}})));
  HeatTransfer.Sources.PrescribedHeatFlow loaHea
    "Heating load as prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-140,48},{-120,68}})));
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
        origin={149,-2})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai4(final k=-1) "Opposite"
    annotation (Placement(transformation(extent={{220,48},{200,68}})));
  HeatTransfer.Sources.PrescribedHeatFlow loaCoo
    "Cooling load as prescribed heat flow rate"
    annotation (Placement(transformation(extent={{182,48},{162,68}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold noLoaHea(threshold=0.01)
    "No heating load"
    annotation (Placement(transformation(extent={{-210,-32},{-190,-12}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold noLoaCoo(threshold=0.01)
    "No cooling load"
    annotation (Placement(transformation(extent={{-212,-112},{-192,-92}})));
  Buildings.Controls.OBC.CDL.Logical.Not reqHea "Heating request"
    annotation (Placement(transformation(extent={{-150,-32},{-130,-12}})));
  Buildings.Controls.OBC.CDL.Logical.Not reqCoo "Cooling request"
    annotation (Placement(transformation(extent={{-150,-112},{-130,-92}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDelHea(delayTime=120)
    "Delay signal indicating no load"
    annotation (Placement(transformation(extent={{-180,-32},{-160,-12}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDelCoo(delayTime=120)
    "Delay signal indicating no load"
    annotation (Placement(transformation(extent={{-180,-112},{-160,-92}})));
  Modelica.Blocks.Sources.CombiTimeTable loa(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(filNam),
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(each unit="W"),
    offset={0,0,0},
    columns={2,3,4},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "Reader for thermal loads (y[1] is cooling load, y[2] is heating load)"
    annotation (Placement(transformation(extent={{-260,88},{-240,108}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai5(final k=1/ets.QHeaWat_flow_nominal)
    "Normalize by nominal heat flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-226,28})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai6(final k=1/ets.QChiWat_flow_nominal)
    "Normalize by nominal heat flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-220,-72})));
equation
  connect(senTHeaWatRet.port_b, ets.ports_aHeaWat[1]) annotation (Line(points={{-50,-42},
          {-40,-42},{-40,-30},{-10,-30}},          color={0,127,255}));
  connect(ets.ports_bChiWat[1], senTChiWatSup.port_a) annotation (Line(points={{50,-40},
          {64,-40},{64,38},{80,38}},         color={0,127,255}));
  connect(ets.ports_aChiWat[1], senTChiWatRet.port_b) annotation (Line(points={{-10,-40},
          {-20,-40},{-20,-2},{70,-2},{70,-42},{80,-42}},        color={0,127,255}));
  connect(TChiWatSupSet.y, ets.TChiWatSupSet) annotation (Line(points={{-118,98},
          {-32,98},{-32,-72},{-14,-72}}, color={0,0,127}));
  connect(THeaWatSupSet.y, ets.THeaWatSupSet) annotation (Line(points={{-118,
          138},{-28,138},{-28,-63.6},{-14,-63.6}},
                                          color={0,0,127}));
  connect(disWat.ports[1], ets.port_aDis) annotation (Line(points={{-100,-140},
          {-100,-82},{-10,-82}},color={0,127,255}));
  connect(ets.port_bDis, disWat.ports[2]) annotation (Line(points={{50,-82},{
          160,-82},{160,-182},{-100,-182},{-100,-144}},
                                                    color={0,127,255}));
  connect(TDisWatSup.y, disWat.T_in) annotation (Line(points={{-238,-142},{-172,
          -142},{-172,-138},{-122,-138}}, color={0,0,127}));
  connect(pumChiWat.port_a, senTChiWatSup.port_b)
    annotation (Line(points={{110,38},{100,38}},color={0,127,255}));
  connect(gai2.y, pumChiWat.m_flow_in)
    annotation (Line(points={{114,78},{120,78},{120,50}}, color={0,0,127}));
  connect(ets.ports_bHeaWat[1], pumHeaWat.port_a) annotation (Line(points={{50,-30},
          {60,-30},{60,38},{30,38}},  color={0,127,255}));
  connect(pumHeaWat.port_b, senTHeaWatSup.port_a)
    annotation (Line(points={{10,38},{-50,38}},  color={0,127,255}));
  connect(gai1.y, pumHeaWat.m_flow_in)
    annotation (Line(points={{46,78},{20,78},{20,50}},    color={0,0,127}));
  connect(yPum.y, gai1.u) annotation (Line(points={{62,118},{80,118},{80,78},{
          70,78}},
                color={0,0,127}));
  connect(yPum.y, gai2.u) annotation (Line(points={{62,118},{80,118},{80,78},{
          90,78}},
                color={0,0,127}));
  connect(loaHea.port, volHeaWat.heatPort) annotation (Line(points={{-120,58},{
          -112,58},{-112,8},{-111,8}},
                                    color={191,0,0}));
  connect(pumChiWat.port_b, volChiWat.ports[1])
    annotation (Line(points={{130,38},{139,38},{139,0}}, color={0,127,255}));
  connect(volChiWat.ports[2], senTChiWatRet.port_a)
    annotation (Line(points={{139,-4},{139,-42},{100,-42}},color={0,127,255}));
  connect(senTHeaWatSup.port_b, volHeaWat.ports[1])
    annotation (Line(points={{-70,38},{-101,38},{-101,0}}, color={0,127,255}));
  connect(loaCoo.port, volChiWat.heatPort)
    annotation (Line(points={{162,58},{149,58},{149,8}},  color={191,0,0}));
  connect(volHeaWat.ports[2], senTHeaWatRet.port_a) annotation (Line(points={{-101,-4},
          {-101,-42},{-70,-42}},          color={0,127,255}));
  connect(heaWat.ports[1], pumHeaWat.port_a)
    annotation (Line(points={{40,22},{40,38},{30,38}}, color={0,127,255}));
  connect(reqHea.y, ets.uHea) annotation (Line(points={{-128,-22},{-120,-22},{
          -120,-48},{-14,-48}},
                           color={255,0,255}));
  connect(reqCoo.y, ets.uCoo) annotation (Line(points={{-128,-102},{-120,-102},
          {-120,-56},{-14,-56}},color={255,0,255}));
  connect(reqHea.u, truDelHea.y)
    annotation (Line(points={{-152,-22},{-158,-22}}, color={255,0,255}));
  connect(noLoaHea.y, truDelHea.u)
    annotation (Line(points={{-188,-22},{-182,-22}}, color={255,0,255}));
  connect(reqCoo.u, truDelCoo.y)
    annotation (Line(points={{-152,-102},{-158,-102}}, color={255,0,255}));
  connect(noLoaCoo.y, truDelCoo.u)
    annotation (Line(points={{-190,-102},{-182,-102}}, color={255,0,255}));
  connect(gai3.y, loaHea.Q_flow) annotation (Line(points={{-158,58},{-140,58}},
                          color={0,0,127}));
  connect(loa.y[2], gai5.u) annotation (Line(points={{-239,98},{-226,98},{-226,
          40}}, color={0,0,127}));
  connect(loa.y[2], gai3.u) annotation (Line(points={{-239,98},{-220,98},{-220,
          58},{-182,58}}, color={0,0,127}));
  connect(loa.y[1], gai6.u) annotation (Line(points={{-239,98},{-220,98},{-220,
          -60}}, color={0,0,127}));
  connect(gai6.y, noLoaCoo.u) annotation (Line(points={{-220,-84},{-220,-102},{
          -214,-102}},
                  color={0,0,127}));
  connect(gai5.y, noLoaHea.u) annotation (Line(points={{-226,16},{-226,-22},{
          -212,-22}},
                 color={0,0,127}));
  connect(gai4.y, loaCoo.Q_flow)
    annotation (Line(points={{198,58},{182,58}}, color={0,0,127}));
  connect(loa.y[1], gai4.u) annotation (Line(points={{-239,98},{-160,98},{-160,
          158},{240,158},{240,58},{222,58}}, color={0,0,127}));
  annotation (Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-300,-220},{300,220}})),
  __Dymola_Commands(file=
"modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Combined/Generation5/Validation/ChillerTimeSeries.mos"
"Simulate and plot"),
    experiment(
      StartTime=10000000,
      StopTime=20000000,
      __Dymola_NumberOfIntervals=5000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end ChillerTimeSeries;
