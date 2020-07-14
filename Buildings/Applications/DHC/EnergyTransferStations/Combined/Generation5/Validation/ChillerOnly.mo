within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Validation;
model ChillerOnly
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
    COP_nominal=2,
    PLRMax=1,
    PLRMinUnl=0.3,
    PLRMin=0.3,
    etaMotor=1,
    mEva_flow_nominal=1e6 / 5 / 4186,
    mCon_flow_nominal=1e6*(1 + 1/2)/5/4186,
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
  Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.ChillerBorefield
    ets(
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
    nPorts_aChiWat=1) "ETS"
    annotation (Placement(transformation(extent={{-10,-84},{50,-24}})));
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
    annotation (Placement(transformation(extent={{-250,-150},{-230,-130}})));
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
    annotation (Placement(transformation(extent={{50,70},{30,90}})));
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
  Buildings.Controls.OBC.CDL.Continuous.Gain gai3(final k=-ets.QHeaWat_flow_nominal)
    "Scale to nominal heat flow rate"
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
  Buildings.Controls.OBC.CDL.Continuous.Gain gai4(final k=-ets.QChiWat_flow_nominal)
    "Scale to nominal heat flow rate"
    annotation (Placement(transformation(extent={{220,50},{200,70}})));
  HeatTransfer.Sources.PrescribedHeatFlow loaCoo
    "Cooling load as prescribed heat flow rate"
    annotation (Placement(transformation(extent={{182,50},{162,70}})));
  Modelica.Blocks.Sources.TimeTable loaHeaRat(table=[0,0.1; 2,1; 3,1; 7,0.2; 9,
        0.5; 10,0; 11,0],
               timeScale=1000)
                    "Heating load (ratio to nominal)"
    annotation (Placement(transformation(extent={{-260,110},{-240,130}})));
  Modelica.Blocks.Sources.TimeTable loaCooRat(table=[0,0; 3,0; 4,1; 5,1; 15,0.5;
        16,0.5],         timeScale=1000)
                      "Cooling load (ratio to nominal)"
    annotation (Placement(transformation(extent={{280,50},{260,70}})));
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
equation
  connect(senTHeaWatRet.port_b, ets.ports_aHeaWat[1]) annotation (Line(points={{-50,-40},
          {-40,-40},{-40,-28},{-10,-28}},          color={0,127,255}));
  connect(ets.ports_bChiWat[1], senTChiWatSup.port_a) annotation (Line(points={{50,-38},
          {64,-38},{64,40},{80,40}},         color={0,127,255}));
  connect(ets.ports_aChiWat[1], senTChiWatRet.port_b) annotation (Line(points={{-10,-38},
          {-20,-38},{-20,0},{70,0},{70,-40},{80,-40}},          color={0,127,255}));
  connect(TChiWatSupSet.y, ets.TChiWatSupSet) annotation (Line(points={{-118,
          100},{-32,100},{-32,-70},{-14,-70}},
                                         color={0,0,127}));
  connect(THeaWatSupSet.y, ets.THeaWatSupSet) annotation (Line(points={{-118,
          140},{-28,140},{-28,-62},{-14,-62}},
                                          color={0,0,127}));
  connect(disWat.ports[1], ets.port_aDis) annotation (Line(points={{-100,-138},
          {-100,-80},{-10,-80}},color={0,127,255}));
  connect(ets.port_bDis, disWat.ports[2]) annotation (Line(points={{50,-80},{
          160,-80},{160,-180},{-100,-180},{-100,-142}},
                                                    color={0,127,255}));
  connect(TDisWatSup.y, disWat.T_in) annotation (Line(points={{-228,-140},{-172,
          -140},{-172,-136},{-122,-136}}, color={0,0,127}));
  connect(pumChiWat.port_a, senTChiWatSup.port_b)
    annotation (Line(points={{110,40},{100,40}},color={0,127,255}));
  connect(gai2.y, pumChiWat.m_flow_in)
    annotation (Line(points={{114,80},{120,80},{120,52}}, color={0,0,127}));
  connect(ets.ports_bHeaWat[1], pumHeaWat.port_a) annotation (Line(points={{50,-28},
          {60,-28},{60,40},{30,40}},  color={0,127,255}));
  connect(pumHeaWat.port_b, senTHeaWatSup.port_a)
    annotation (Line(points={{10,40},{-50,40}},  color={0,127,255}));
  connect(gai1.y, pumHeaWat.m_flow_in)
    annotation (Line(points={{28,80},{20,80},{20,52}},    color={0,0,127}));
  connect(gai3.y, loaHea.Q_flow)
    annotation (Line(points={{-158,60},{-140,60}}, color={0,0,127}));
  connect(loaHea.port, volHeaWat.heatPort) annotation (Line(points={{-120,60},{
          -112,60},{-112,10},{-111,10}},
                                    color={191,0,0}));
  connect(pumChiWat.port_b, volChiWat.ports[1])
    annotation (Line(points={{130,40},{139,40},{139,2}}, color={0,127,255}));
  connect(volChiWat.ports[2], senTChiWatRet.port_a)
    annotation (Line(points={{139,-2},{139,-40},{100,-40}},color={0,127,255}));
  connect(senTHeaWatSup.port_b, volHeaWat.ports[1])
    annotation (Line(points={{-70,40},{-101,40},{-101,2}}, color={0,127,255}));
  connect(gai4.y, loaCoo.Q_flow)
    annotation (Line(points={{198,60},{182,60}}, color={0,0,127}));
  connect(loaCoo.port, volChiWat.heatPort)
    annotation (Line(points={{162,60},{149,60},{149,10}}, color={191,0,0}));
  connect(volHeaWat.ports[2], senTHeaWatRet.port_a) annotation (Line(points={{-101,-2},
          {-101,-40},{-70,-40}},          color={0,127,255}));
  connect(heaWat.ports[1], pumHeaWat.port_a)
    annotation (Line(points={{40,24},{40,40},{30,40}}, color={0,127,255}));
  connect(loaHeaRat.y, gai3.u)
    annotation (Line(points={{-239,120},{-220,120},{-220,60},{-182,60}},
                                                   color={0,0,127}));
  connect(loaCooRat.y, gai4.u)
    annotation (Line(points={{259,60},{222,60}}, color={0,0,127}));
  connect(reqHea.y, ets.uHea) annotation (Line(points={{-128,-20},{-120,-20},{
          -120,-46},{-14,-46}}, color={255,0,255}));
  connect(reqCoo.y, ets.uCoo) annotation (Line(points={{-128,-100},{-120,-100},
          {-120,-54},{-14,-54}},color={255,0,255}));
  connect(loaHeaRat.y, noLoaHea.u) annotation (Line(points={{-239,120},{-220,
          120},{-220,-20},{-212,-20}}, color={0,0,127}));
  connect(loaCooRat.y, noLoaCoo.u) annotation (Line(points={{259,60},{240,60},{
          240,-120},{-220,-120},{-220,-100},{-214,-100}}, color={0,0,127}));
  connect(reqHea.u, truDelHea.y)
    annotation (Line(points={{-152,-20},{-158,-20}}, color={255,0,255}));
  connect(noLoaHea.y, truDelHea.u)
    annotation (Line(points={{-188,-20},{-182,-20}}, color={255,0,255}));
  connect(reqCoo.u, truDelCoo.y)
    annotation (Line(points={{-152,-100},{-158,-100}}, color={255,0,255}));
  connect(noLoaCoo.y, truDelCoo.u)
    annotation (Line(points={{-190,-100},{-182,-100}}, color={255,0,255}));
  connect(loaHeaRat.y, gai1.u) annotation (Line(points={{-239,120},{60,120},{60,
          80},{52,80}}, color={0,0,127}));
  connect(loaCooRat.y, gai2.u) annotation (Line(points={{259,60},{240,60},{240,
          120},{80,120},{80,80},{90,80}}, color={0,0,127}));
  annotation (Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-300,-220},{300,220}})),
  __Dymola_Commands(file=
"modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Combined/Generation5/Validation/ChillerOnly.mos"
"Simulate and plot"),
    experiment(
      StopTime=20000,
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
end ChillerOnly;
