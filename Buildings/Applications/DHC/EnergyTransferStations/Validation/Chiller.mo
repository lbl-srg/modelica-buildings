within Buildings.Applications.DHC.EnergyTransferStations.Validation;
model Chiller
  "Validation of the ETS model with heat recovery chiller"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";
  parameter Fluid.Chillers.Data.ElectricEIR.Generic datChi(
    QEva_flow_nominal=-1E6,
    COP_nominal=3,
    PLRMax=1,
    PLRMinUnl=0.3,
    PLRMin=0.3,
    etaMotor=1,
    mEva_flow_nominal=30,
    mCon_flow_nominal=30,
    TEvaLvg_nominal=280.15,
    capFunT={1,0,0,0,0,0},
    EIRFunT={1,0,0,0,0,0},
    EIRFunPLR={1,0,0},
    TEvaLvgMin=275.15,
    TEvaLvgMax=288.15,
    TConEnt_nominal=313.15,
    TConEntMin=303.15,
    TConEntMax=333.15) "Chiller performance data"
    annotation (Placement(transformation(extent={{-220,180},{-200,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupSet(
    k=45 + 273.15,
    y(final unit="K", displayUnit="degC"))
    "Heating water supply temperature set-point"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Fluid.Sources.Boundary_pT chiWat(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=2) "Chilled water boundary conditions"
    annotation (Placement(
      transformation(
      extent={{10,-10},{-10,10}},
      rotation=0,
      origin={130,0})));
  Fluid.Sources.Boundary_pT heaWat(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=2) "Heating water boundary conditions"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,0})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatSupSet(
    k=7 + 273.15,
    y(final unit="K", displayUnit="degC"))
    "Chilled water supply temperature set-point"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TChiWatRet(
    offset=9 + 273.15,
    y(final unit="K", displayUnit="degC"),
    height=5,
    duration=1000,
    startTime=1000) "Chilled water return temperature"
    annotation (Placement(transformation(extent={{220,-30},{200,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp THeaWatRet(
    offset=44 + 273.15,
    y(final unit="K", displayUnit="degC"),
    height=-10,
    duration=1000,
    startTime=2000) "Heating water return temperature"
    annotation (Placement(transformation(extent={{-220,-30},{-200,-10}})));
  Fluid.Sensors.TemperatureTwoPort senTHeaWatSup(redeclare final package Medium =
        Medium, m_flow_nominal=datChi.mCon_flow_nominal)
    "Heating water supply temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-80,40})));
  Fluid.Sensors.TemperatureTwoPort senTChiWatSup(redeclare final package Medium =
        Medium, m_flow_nominal=datChi.mEva_flow_nominal)
    "Chilled water supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,40})));
  Fluid.Sensors.TemperatureTwoPort senTHeaWatRet(redeclare final package Medium =
        Medium, m_flow_nominal=datChi.mCon_flow_nominal)
    "Heating water return temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,-40})));
  Fluid.Sensors.TemperatureTwoPort senTChiWatRet(redeclare final package Medium =
        Medium, m_flow_nominal=datChi.mEva_flow_nominal)
    "Chilled water return temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={70,-40})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp dTChiWatRet(
    offset=0,
    y(final unit="K", displayUnit="degC"),
    height=-3,
    duration=1000,
    startTime=3000) "Chilled water return additional deltaT"
    annotation (Placement(transformation(extent={{220,10},{200,30}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=2)
    "Sum T and deltaT"
    annotation (Placement(transformation(extent={{170,-10},{150,10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(nin=2)
    "Sum T and deltaT"
    annotation (Placement(transformation(extent={{-172,-10},{-152,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp dTHeaWatRet(
    y(final unit="K", displayUnit="degC"),
    height=-20,
    duration=500,
    startTime=4500) "Heating water return additional deltaT"
    annotation (Placement(transformation(extent={{-220,10},{-200,30}})));
  FifthGeneration.Chiller ets(
    redeclare final package MediumBui = Medium,
    redeclare final package MediumDis = Medium,
    QChiWat_flow_nominal=datChi.QEva_flow_nominal,
    QHeaWat_flow_nominal=-datChi.QEva_flow_nominal*(1 + 1/datChi.COP_nominal),
    dp1Hex_nominal=10E3,
    dp2Hex_nominal=10E3,
    QHex_flow_nominal=-datChi.QEva_flow_nominal,
    T_a1Hex_nominal=281.15,
    T_b1Hex_nominal=277.15,
    T_a2Hex_nominal=275.15,
    T_b2Hex_nominal=279.15,
    dpCon_nominal=15E3,
    dpEva_nominal=15E3,
    datChi=datChi,
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
      origin={-110,-140})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TDisWatSup(
    k=10 + 273.15,
    y(final unit="K", displayUnit="degC"))
    "District water supply temperature"
    annotation (Placement(transformation(extent={{-160,-150},{-140,-130}})));
equation
  connect(senTHeaWatSup.port_b,heaWat. ports[1]) annotation (Line(points={{-90,40},
          {-120,40},{-120,2}},         color={0,127,255}));
  connect(chiWat.ports[1], senTChiWatSup.port_b) annotation (Line(points={{120,2},
          {120,40},{80,40}},        color={0,127,255}));
  connect(heaWat.ports[2], senTHeaWatRet.port_a) annotation (Line(points={{-120,-2},
          {-120,-40},{-90,-40}},      color={0,127,255}));
  connect(senTChiWatRet.port_a,chiWat. ports[2]) annotation (Line(points={{80,-40},
          {120,-40},{120,-2}},       color={0,127,255}));
  connect(mulSum.y,chiWat. T_in) annotation (Line(points={{148,0},{146,0},{146,4},
          {142,4}},            color={0,0,127}));
  connect(dTChiWatRet.y, mulSum.u[1]) annotation (Line(points={{198,20},{180,20},
          {180,1},{172,1}},          color={0,0,127}));
  connect(TChiWatRet.y, mulSum.u[2]) annotation (Line(points={{198,-20},{180,-20},
          {180,-1},{172,-1}},        color={0,0,127}));
  connect(THeaWatRet.y, mulSum1.u[1]) annotation (Line(points={{-198,-20},{-180,
          -20},{-180,1},{-174,1}},
                            color={0,0,127}));
  connect(mulSum1.y,heaWat. T_in) annotation (Line(points={{-150,0},{-148,0},{-148,
          4},{-142,4}},           color={0,0,127}));
  connect(dTHeaWatRet.y, mulSum1.u[2]) annotation (Line(points={{-198,20},{-180,
          20},{-180,-1},{-174,-1}},         color={0,0,127}));
  connect(senTHeaWatRet.port_b, ets.ports_aHeaWat[1]) annotation (Line(points={{
          -70,-40},{-60,-40},{-60,-28},{-30,-28}}, color={0,127,255}));
  connect(ets.ports_bHeaWat[1], senTHeaWatSup.port_a) annotation (Line(points={{
          30,-28},{40,-28},{40,40},{-70,40}}, color={0,127,255}));
  connect(ets.ports_bChiWat[1], senTChiWatSup.port_a) annotation (Line(points={{
          30,-38},{44,-38},{44,40},{60,40}}, color={0,127,255}));
  connect(ets.ports_aChiWat[1], senTChiWatRet.port_b) annotation (Line(points={{
          -30,-38},{-40,-38},{-40,0},{50,0},{50,-40},{60,-40}}, color={0,127,255}));
  connect(TChiWatSupSet.y, ets.TChiWatSupSet) annotation (Line(points={{-98,60},
          {-52,60},{-52,-70},{-34,-70}}, color={0,0,127}));
  connect(THeaWatSupSet.y, ets.THeaWatSupSet) annotation (Line(points={{-98,100},
          {-48,100},{-48,-54},{-34,-54}}, color={0,0,127}));
  connect(disWat.ports[1], ets.port_aDis) annotation (Line(points={{-100,-138},{
          -100,-80},{-30,-80}}, color={0,127,255}));
  connect(ets.port_bDis, disWat.ports[2]) annotation (Line(points={{30,-80},{100,
          -80},{100,-180},{-100,-180},{-100,-142}}, color={0,127,255}));
  connect(TDisWatSup.y, disWat.T_in) annotation (Line(points={{-138,-140},{-130,
          -140},{-130,-136},{-122,-136}}, color={0,0,127}));
  annotation (Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-240,-220},{240,220}})),
  __Dymola_Commands(file=
    "Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Validation/Chiller.mos"
    "Simulate and plot"));
end Chiller;
