within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Validation;
model ChillerBorefieldTimeSeries
  "Validation of the ETS model with heat recovery chiller and borefield"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";
  parameter Integer nBorHol = 100
    "Number of boreholes (must be a square number)";
  parameter Modelica.SIunits.Distance dxy = 6
    "Distance in x-axis (and y-axis) between borehole axes";
  final parameter Modelica.SIunits.Distance cooBor[nBorHol,2]=
    EnergyTransferStations.BaseClasses.computeCoordinates(nBorHol, dxy)
    "Coordinates of boreholes";
  parameter String filNam=
    "modelica://Buildings/Applications/DHC/Loads/Examples/Resources/SwissResidential_shiftCooling.mos"
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
    annotation (Placement(transformation(extent={{20,180},{40,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupSet(
    k=45 + 273.15,
    y(final unit="K", displayUnit="degC"))
    "Heating water supply temperature set-point"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Fluid.Sources.Boundary_pT heaWat(
    redeclare package Medium = Medium, nPorts=1)
              "Heating water boundary conditions"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,14})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatSupSet(
    k=7 + 273.15,
    y(final unit="K", displayUnit="degC"))
    "Chilled water supply temperature set-point"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Fluid.Sensors.TemperatureTwoPort senTHeaWatSup(redeclare final package Medium =
        Medium, m_flow_nominal=datChi.mCon_flow_nominal)
    "Heating water supply temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-60,40})));
  Fluid.Sensors.TemperatureTwoPort senTChiWatSup(redeclare final package Medium =
        Medium, m_flow_nominal=datChi.mEva_flow_nominal)
    "Chilled water supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,40})));
  Fluid.Sensors.TemperatureTwoPort senTHeaWatRet(redeclare final package Medium =
        Medium, m_flow_nominal=datChi.mCon_flow_nominal)
    "Heating water return temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,-40})));
  Fluid.Sensors.TemperatureTwoPort senTChiWatRet(redeclare final package Medium =
        Medium, m_flow_nominal=datChi.mEva_flow_nominal)
    "Chilled water return temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={90,-40})));
  EnergyTransferStations.Combined.Generation5.ChillerBorefield ets(
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
    have_borFie=true,
    dpCon_nominal=15E3,
    dpEva_nominal=15E3,
    datChi=datChi,
    datBorFie=datBorFie,
    nPorts_aHeaWat=1,
    nPorts_bHeaWat=1,
    nPorts_bChiWat=1,
    nPorts_aChiWat=1) "ETS"
    annotation (Placement(transformation(extent={{-8,-84},{52,-24}})));
  Fluid.Sources.Boundary_pT disWat(
    redeclare final package Medium = Medium,
    use_T_in=true,
    nPorts=2)
    "District water boundary conditions"
    annotation (Placement(
      transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-110,-140})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TDisWatSup(k=9 + 273.15,
    y(final unit="K", displayUnit="degC"))
    "District water supply temperature"
    annotation (Placement(transformation(extent={{-280,-150},{-260,-130}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow
    pumChiWat(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mChiWat_flow_nominal,
    dp_nominal=100E3) "Chilled water distribution pump"
    annotation (Placement(transformation(extent={{110,30},{130,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai2(final k=mChiWat_flow_nominal)
    "Scale to nominal mass flow rate"
    annotation (Placement(transformation(extent={{92,70},{112,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(final k=mHeaWat_flow_nominal)
    "Scale to nominal mass flow rate"
    annotation (Placement(transformation(extent={{48,70},{28,90}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow
    pumHeaWat(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal,
    dp_nominal=100E3) "Heating water distribution pump"
    annotation (Placement(transformation(extent={{30,30},{10,50}})));
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
        origin={-111,0})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai3(final k=-1) "Opposite"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  HeatTransfer.Sources.PrescribedHeatFlow loaHea
    "Heating load as prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
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
        origin={149,0})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai4(final k=-1) "Opposite"
    annotation (Placement(transformation(extent={{220,50},{200,70}})));
  HeatTransfer.Sources.PrescribedHeatFlow loaCoo
    "Cooling load as prescribed heat flow rate"
    annotation (Placement(transformation(extent={{182,50},{162,70}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold noLoaHea(threshold=0.01)
    "No heating load"
    annotation (Placement(transformation(extent={{-210,-30},{-190,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold noLoaCoo(threshold=0.01)
    "No cooling load"
    annotation (Placement(transformation(extent={{-212,-110},{-192,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Not reqHea "Heating request"
    annotation (Placement(transformation(extent={{-150,-30},{-130,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not reqCoo "Cooling request"
    annotation (Placement(transformation(extent={{-150,-110},{-130,-90}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDelHea(delayTime=300)
    "Delay signal indicating no load"
    annotation (Placement(transformation(extent={{-180,-30},{-160,-10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDelCoo(delayTime=300)
    "Delay signal indicating no load"
    annotation (Placement(transformation(extent={{-180,-110},{-160,-90}})));
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
    annotation (Placement(transformation(extent={{-280,150},{-260,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain loaNorHea(
    final k=1/ets.QHeaWat_flow_nominal) "Normalize by nominal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-272,120})));
  Buildings.Controls.OBC.CDL.Continuous.Gain loaNorCoo(
    final k=1/ets.QChiWat_flow_nominal) "Normalize by nominal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-272,80})));
  parameter Fluid.Geothermal.Borefields.Data.Borefield.Example datBorFie(
    conDat=Fluid.Geothermal.Borefields.Data.Configuration.Example(
      cooBor=cooBor,
      dp_nominal=0))
    "Borefield design data"
    annotation (Placement(transformation(extent={{60,180},{80,200}})));
equation
  connect(senTHeaWatRet.port_b, ets.ports_aHeaWat[1]) annotation (
      Line(points={{-50,-40},{-40,-40},{-40,-28},{-8,-28}},  color={0,127,255}));
  connect(ets.ports_bChiWat[1], senTChiWatSup.port_a) annotation (
      Line(points={{52,-38},{64,-38},{64,40},{80,40}}, color={0,127,255}));
  connect(ets.ports_aChiWat[1], senTChiWatRet.port_b) annotation (
      Line(points={{-8,-38},{-20,-38},{-20,0},{70,0},{70,-40},{80,-40}},  color=
         {0,127,255}));
  connect(TChiWatSupSet.y, ets.TChiWatSupSet) annotation (Line(
        points={{-118,100},{-32,100},{-32,-70},{-12,-70}}, color={0,0,127}));
  connect(THeaWatSupSet.y, ets.THeaWatSupSet) annotation (Line(
        points={{-118,140},{-28,140},{-28,-62},{-12,-62}},     color={0,0,127}));
  connect(disWat.ports[1], ets.port_aDis) annotation (Line(points={{-100,-138},
          {-100,-80},{-8,-80}},              color={0,127,255}));
  connect(ets.port_bDis, disWat.ports[2]) annotation (Line(points={{52,-80},{
          160,-80},{160,-180},{-100,-180},{-100,-142}},           color={0,127,255}));
  connect(TDisWatSup.y, disWat.T_in) annotation (Line(points={{-258,-140},{-172,
          -140},{-172,-136},{-122,-136}}, color={0,0,127}));
  connect(pumChiWat.port_a, senTChiWatSup.port_b)
    annotation (Line(points={{110,40},{100,40}},color={0,127,255}));
  connect(gai2.y, pumChiWat.m_flow_in)
    annotation (Line(points={{114,80},{120,80},{120,52}}, color={0,0,127}));
  connect(ets.ports_bHeaWat[1], pumHeaWat.port_a) annotation (Line(
        points={{52,-28},{60,-28},{60,40},{30,40}}, color={0,127,255}));
  connect(pumHeaWat.port_b, senTHeaWatSup.port_a)
    annotation (Line(points={{10,40},{-50,40}},  color={0,127,255}));
  connect(gai1.y, pumHeaWat.m_flow_in)
    annotation (Line(points={{26,80},{20,80},{20,52}},    color={0,0,127}));
  connect(loaHea.port, volHeaWat.heatPort) annotation (Line(points={{-120,60},{
          -112,60},{-112,10},{-111,10}},
                                    color={191,0,0}));
  connect(pumChiWat.port_b, volChiWat.ports[1])
    annotation (Line(points={{130,40},{139,40},{139,2}}, color={0,127,255}));
  connect(volChiWat.ports[2], senTChiWatRet.port_a)
    annotation (Line(points={{139,-2},{139,-40},{100,-40}},color={0,127,255}));
  connect(senTHeaWatSup.port_b, volHeaWat.ports[1])
    annotation (Line(points={{-70,40},{-101,40},{-101,2}}, color={0,127,255}));
  connect(loaCoo.port, volChiWat.heatPort)
    annotation (Line(points={{162,60},{149,60},{149,10}}, color={191,0,0}));
  connect(volHeaWat.ports[2], senTHeaWatRet.port_a) annotation (Line(points={{-101,-2},
          {-101,-40},{-70,-40}},          color={0,127,255}));
  connect(heaWat.ports[1], pumHeaWat.port_a)
    annotation (Line(points={{40,24},{40,40},{30,40}}, color={0,127,255}));
  connect(reqHea.y, ets.uHea) annotation (Line(points={{-128,-20},{-120,-20},{
          -120,-46},{-12,-46}},            color={255,0,255}));
  connect(reqCoo.y, ets.uCoo) annotation (Line(points={{-128,-100},{-120,-100},
          {-120,-54},{-12,-54}},             color={255,0,255}));
  connect(reqHea.u, truDelHea.y)
    annotation (Line(points={{-152,-20},{-158,-20}}, color={255,0,255}));
  connect(noLoaHea.y, truDelHea.u)
    annotation (Line(points={{-188,-20},{-182,-20}}, color={255,0,255}));
  connect(reqCoo.u, truDelCoo.y)
    annotation (Line(points={{-152,-100},{-158,-100}}, color={255,0,255}));
  connect(noLoaCoo.y, truDelCoo.u)
    annotation (Line(points={{-190,-100},{-182,-100}}, color={255,0,255}));
  connect(gai3.y, loaHea.Q_flow) annotation (Line(points={{-158,60},{-140,60}},
                          color={0,0,127}));
  connect(loa.y[2], loaNorHea.u) annotation (Line(points={{-259,160},{-240,160},
          {-240,140},{-290,140},{-290,120},{-284,120}}, color={0,0,127}));
  connect(loa.y[2], gai3.u) annotation (Line(points={{-259,160},{-220,160},{
          -220,60},{-182,60}},
                          color={0,0,127}));
  connect(loa.y[1], loaNorCoo.u) annotation (Line(points={{-259,160},{-240,160},
          {-240,140},{-290,140},{-290,80},{-284,80}}, color={0,0,127}));
  connect(loaNorCoo.y, noLoaCoo.u) annotation (Line(points={{-260,80},{-252,80},
          {-252,-100},{-214,-100}}, color={0,0,127}));
  connect(loaNorHea.y, noLoaHea.u) annotation (Line(points={{-260,120},{-240,
          120},{-240,-20},{-212,-20}}, color={0,0,127}));
  connect(gai4.y, loaCoo.Q_flow)
    annotation (Line(points={{198,60},{182,60}}, color={0,0,127}));
  connect(loa.y[1], gai4.u) annotation (Line(points={{-259,160},{240,160},{240,
          60},{222,60}},                     color={0,0,127}));
  connect(loaNorHea.y, gai1.u) annotation (Line(points={{-260,120},{60,120},{60,
          80},{50,80}}, color={0,0,127}));
  connect(loaNorCoo.y, gai2.u) annotation (Line(points={{-260,80},{0,80},{0,100},
          {80,100},{80,80},{90,80}}, color={0,0,127}));
  annotation (Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-300,-220},{300,220}})),
  __Dymola_Commands(file=
"modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Combined/Generation5/Validation/ChillerBorefieldTimeSeries.mos"
"Simulate and plot"),
    experiment(
      StopTime=10000000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
 Documentation(
revisions="<html>
<ul>
<li>
July xx, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>"));
end ChillerBorefieldTimeSeries;
