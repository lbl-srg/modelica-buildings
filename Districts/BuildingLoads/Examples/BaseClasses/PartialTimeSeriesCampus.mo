within Districts.BuildingLoads.Examples.BaseClasses;
partial model PartialTimeSeriesCampus
  "Partial model for the time series building load as part of a campus"

  parameter Modelica.SIunits.Voltage VACTra_nominal = 50e3
    "AC voltage of transmission grid";
  parameter Modelica.SIunits.Voltage VACDis_nominal = 12e3
    "AC voltage of the distribution grid";
  parameter Modelica.SIunits.Voltage VACBui_nominal = 480
    "AC voltage of the distribution grid";

  parameter Modelica.SIunits.Voltage VDCDis_nominal = 240
    "DC voltage of distribution";
  parameter Modelica.SIunits.Voltage VDCBui_nominal = 48
    "DC voltage in buildings";

  // Rated power that is used to size cables
  constant Real safetyMargin = 1.2 "Safety margin used for cable sizing";

  parameter Modelica.SIunits.Energy EBat = 7297200000 "Battery capacity";
  parameter Modelica.SIunits.Power PBat = EBat/10/3600 / (0.95-0.05)
    "Batter maximum power flow";

  final parameter Modelica.SIunits.Power PDCGen = PPVGen + PWinGen
    "Rated power for generated DC power";
  final parameter Modelica.SIunits.Power PPVGen = 437e3
    "Rated power for generated PV power";
  final parameter Modelica.SIunits.Power PWinGen = 50e3
    "Rated power for generated wind power";

  parameter Modelica.SIunits.Power PMaxAC_A = 1.6e5
    "Rated apparent load for sizing";
  parameter Modelica.SIunits.Power PMaxDC_A = 1.0e5 "Rated load for sizing";
  parameter Modelica.SIunits.Power PMaxAC_B = 2.5e5
    "Rated apparent load for sizing";
  parameter Modelica.SIunits.Power PMaxDC_B = 1.6e5 "Rated load for sizing";
  parameter Modelica.SIunits.Power PMaxAC_C = 1.8e5
    "Rated apparent load for sizing";
  parameter Modelica.SIunits.Power PMaxDC_C = 5.7e4 "Rated load for sizing";
  parameter Modelica.SIunits.Power PMaxAC_D = 3.7e5
    "Rated apparent load for sizing";
  parameter Modelica.SIunits.Power PMaxDC_D = 1.2e5 "Rated load for sizing";
  parameter Modelica.SIunits.Power PMaxAC_E = 2.9e5
    "Rated apparent load for sizing";
  parameter Modelica.SIunits.Power PMaxDC_E = 1.1e5 "Rated load for sizing";
  parameter Modelica.SIunits.Power PMaxAC=
    PMaxAC_A + PMaxAC_B + PMaxAC_C + PMaxAC_D + PMaxAC_E
    "Maximum AC rated load";
  parameter Modelica.SIunits.Power PMaxDC=
    PMaxDC_A + PMaxDC_B + PMaxDC_C + PMaxAC_D + PMaxDC_E
    "Maximum DC rated load, exclusive building D which has its own AC/DC converter";

  parameter Modelica.SIunits.Power P_a = max(PMaxAC_A*safetyMargin + PMaxDC, PDCGen)
    "Rated apparent power for sizing";
  parameter Modelica.SIunits.Power P_b = PMaxAC_B*safetyMargin
    "Rated apparent power for sizing";
  parameter Modelica.SIunits.Power P_c = PMaxAC_C*safetyMargin
    "Rated apparent power for sizing";
  parameter Modelica.SIunits.Power P_d = PMaxAC_D*safetyMargin
    "Rated apparent power for sizing";
  parameter Modelica.SIunits.Power P_e = PMaxAC_E*safetyMargin
    "Rated apparent power for sizing";
  final parameter Modelica.SIunits.Power PBuiTot = (P_a+P_b+P_c+P_d+P_e)/safetyMargin+PMaxDC
    "Rated apparent power for sizing";
  parameter Modelica.SIunits.Power P_bc = P_a  + P_b
    "Rated apparent power for sizing";
  parameter Modelica.SIunits.Power P_ce = P_bc + P_c
    "Rated apparent power for sizing";
  parameter Modelica.SIunits.Power P_de = P_ce + P_e
    "Rated apparent power for sizing";
  parameter Modelica.SIunits.Power P_dt = P_de + P_d
    "Rated apparent power for sizing";
  // Declaration of the line model
  // Set the instance 'line' either to 'DummyLine' or to 'Districts.Electrical.AC.AC3ph.Lines.Line'
  //replaceable model acLine = DummyLine "Line model";
  model acLine =
      Districts.Electrical.AC.ThreePhasesBalanced.Lines.Line (
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu50())
    "AC line model";

    model dcLine = Districts.Electrical.DC.Lines.Line (
    V_nominal=VDCDis_nominal,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cable(
    RCha=0.1*0.181e-003,
    XCha=0.1*0.072e-003,
    In=10*110)) "DC line model";

  //model line = resistiveLine "Line model";
  Districts.BuildingLoads.TimeSeries buiA(fileName="modelica://Districts/Resources/Data/BuildingLoads/Examples/buildingA.txt",
    final VACDis_nominal=VACDis_nominal,
    final VACBui_nominal=VACBui_nominal,
    final VDCDis_nominal=VDCDis_nominal,
    final VDCBui_nominal=VDCBui_nominal) "Building A"
    annotation (Placement(transformation(extent={{280,30},{300,50}})));
  Districts.BuildingLoads.TimeSeries buiB(fileName="modelica://Districts/Resources/Data/BuildingLoads/Examples/buildingB.txt",
    final VACDis_nominal=VACDis_nominal,
    final VACBui_nominal=VACBui_nominal,
    final VDCDis_nominal=VDCDis_nominal,
    final VDCBui_nominal=VDCBui_nominal) "Building B"
    annotation (Placement(transformation(extent={{220,30},{240,50}})));
  Districts.BuildingLoads.TimeSeries buiC(fileName="modelica://Districts/Resources/Data/BuildingLoads/Examples/buildingC.txt",
    final VACDis_nominal=VACDis_nominal,
    final VACBui_nominal=VACBui_nominal,
    final VDCDis_nominal=VDCDis_nominal,
    final VDCBui_nominal=VDCBui_nominal) "Building C"
    annotation (Placement(transformation(extent={{152,30},{172,50}})));
  Districts.BuildingLoads.TimeSeries buiD(fileName="modelica://Districts/Resources/Data/BuildingLoads/Examples/buildingD.txt",
    final VACDis_nominal=VACDis_nominal,
    final VACBui_nominal=VACBui_nominal,
    final VDCDis_nominal=VDCDis_nominal,
    final VDCBui_nominal=VDCBui_nominal) "Building D"
    annotation (Placement(transformation(extent={{-42,-80},{-22,-60}})));
  Districts.BuildingLoads.TimeSeries buiE(fileName="modelica://Districts/Resources/Data/BuildingLoads/Examples/buildingE.txt",
    final VACDis_nominal=VACDis_nominal,
    final VACBui_nominal=VACBui_nominal,
    final VDCDis_nominal=VDCDis_nominal,
    final VDCBui_nominal=VDCBui_nominal) "Building E"
    annotation (Placement(transformation(extent={{80,-90},{100,-70}})));

  Districts.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Districts/Resources/weatherdata/CZ10RV2.mos")
    annotation (Placement(transformation(extent={{-220,60},{-200,80}})));
  Districts.Electrical.AC.ThreePhasesBalanced.Sources.Grid gri(
    f=60,
    Phi=0,
    V=VACTra_nominal)
           annotation (Placement(transformation(extent={{-172,0},{-152,20}})));
  Districts.Electrical.AC.ThreePhasesBalanced.Conversion.ACACConverter
                                                         acac(eta=0.9,
      conversionFactor=VACDis_nominal/VACTra_nominal) "AC/AC converter"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  acLine linDT(
    P_nominal=P_dt,
    V_nominal=VACDis_nominal,
    l=40,
    wireMaterial=Districts.Electrical.Transmission.Materials.Material.Cu)
    "Distribution line"
    annotation (Placement(transformation(extent={{-84,-30},{-64,-10}})));
  acLine linDE(
    V_nominal=VACDis_nominal,
    wireMaterial=Districts.Electrical.Transmission.Materials.Material.Cu,
    P_nominal=P_de,
    l=400) "Distribution line"
    annotation (Placement(transformation(extent={{34,-30},{54,-10}})));
  acLine linD(
    V_nominal=VACDis_nominal,
    P_nominal=P_d,
    l=20,
    wireMaterial=Districts.Electrical.Transmission.Materials.Material.Cu)
    "Distribution line"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,-58})));
  acLine linE(
    V_nominal=VACDis_nominal,
    P_nominal=P_e,
    l=20,
    wireMaterial=Districts.Electrical.Transmission.Materials.Material.Cu)
    "Distribution line"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={120,-60})));
  acLine linCE(
    V_nominal=VACDis_nominal,
    P_nominal=P_ce,
    l=50,
    wireMaterial=Districts.Electrical.Transmission.Materials.Material.Cu)
    "Distribution line"
    annotation (Placement(transformation(extent={{150,-30},{170,-10}})));
  acLine linC(
    V_nominal=VACDis_nominal,
    P_nominal=P_c,
    l=60,
    wireMaterial=Districts.Electrical.Transmission.Materials.Material.Cu)
    "Distribution line"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={200,10})));
  acLine linBC(
    V_nominal=VACDis_nominal,
    P_nominal=P_bc,
    l=40,
    wireMaterial=Districts.Electrical.Transmission.Materials.Material.Cu)
    "Distribution line"
    annotation (Placement(transformation(extent={{210,-30},{230,-10}})));
  acLine linB(
    V_nominal=VACDis_nominal,
    P_nominal=P_b,
    l=20,
    wireMaterial=Districts.Electrical.Transmission.Materials.Material.Cu)
    "Distribution line"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={258,10})));
  acLine linA(
    V_nominal=VACDis_nominal,
    P_nominal=P_a,
    l=120,
    wireMaterial=Districts.Electrical.Transmission.Materials.Material.Cu)
    "Distribution line"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={290,-20})));

  Districts.Electrical.AC.ThreePhasesBalanced.Sensors.GeneralizedSensor
                                                          senDT
    "Sensor in DT line"
    annotation (Placement(transformation(extent={{-54,-30},{-34,-10}})));
  Districts.Electrical.AC.ThreePhasesBalanced.Sensors.GeneralizedSensor senA
    "Sensor in AC line at building A"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={330,10})));

  Districts.BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{260,190},{280,210}})));

  model resistiveLine
    extends Districts.Electrical.AC.ThreePhasesBalanced.Lines.TwoPortResistance(R=0.3e-3*l);
      parameter Modelica.SIunits.Distance l(min=0) "Length of the line";
      parameter Modelica.SIunits.Power P_nominal(min=0)
      "Nominal power of the line";
      parameter Modelica.SIunits.Voltage V_nominal
      "Nominal voltage of the line";
  parameter Districts.Electrical.Transmission.Materials.Material wireMaterial=
      Districts.Electrical.Transmission.Materials.Material.Cu
      "Material of the cable"
    annotation (choicesAllMatching=true,Dialog(tab="Tech. specification",
                enable=mode==Districts.Electrical.Types.CableMode.normative),
                Placement(transformation(extent={{60,60}, {80,80}})));

  end resistiveLine;

public
  Districts.Electrical.AC.ThreePhasesBalanced.Sensors.GeneralizedSensor senTra
    "Sensor in the transmission grid"
    annotation (Placement(transformation(extent={{-148,-30},{-128,-10}})));
  Districts.Electrical.AC.ThreePhasesBalanced.Conversion.ACDCConverter acdc(conversionFactor=
        VDCDis_nominal/VACDis_nominal, eta=0.9) "AC/DC converter"
    annotation (Placement(transformation(extent={{350,-30},{370,-10}})));
  Districts.Electrical.DC.Sources.PVSimple pv(A=10000) "PV array"
    annotation (Placement(transformation(extent={{426,90},{446,110}})));
  Modelica.Blocks.Math.Add G "Total irradiation on tilted surface"
    annotation (Placement(transformation(extent={{360,130},{380,150}})));
  Districts.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil(
    til=0.34906585039887,
    lat=0.65798912800186,
    azi=-0.78539816339745) "Diffuse irradiation on tilted surface"
    annotation (Placement(transformation(extent={{310,150},{330,170}})));
  Districts.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
    til=0.34906585039887,
    lat=0.65798912800186,
    azi=-0.78539816339745) "Direct irradiation on tilted surface"
    annotation (Placement(transformation(extent={{310,110},{330,130}})));
  Districts.Electrical.DC.Sources.WindTurbine tur(h=50, scale=PWinGen)
    "Wind turbine"
    annotation (Placement(transformation(extent={{430,170},{450,190}})));
  Districts.Electrical.DC.Storage.Battery bat(EMax(displayUnit="J") = EBat)
    "Battery"
    annotation (Placement(transformation(extent={{418,-30},{438,-10}})));
  Districts.Electrical.AC.ThreePhasesBalanced.Sensors.GeneralizedSensor senDE
    "Sensor in DE line"
    annotation (Placement(transformation(extent={{76,-30},{96,-10}})));
  Modelica.Blocks.Continuous.Integrator ETot "Total transmitted energy"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  Modelica.Blocks.Math.Gain vRel(k=1/VACDis_nominal)
    "Voltage, relative to design voltage"
    annotation (Placement(transformation(extent={{368,40},{388,60}})));
  dcLine linDC_D(
    P_nominal=PMaxDC_D, l=20 + 400) "DC line to building D"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={26,-50})));
  dcLine linDC_E(l=20, P_nominal=PMaxDC_E) "DC line to building E"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={140,-50})));
  dcLine linDC_CE(l=50, P_nominal=PMaxDC_D + PMaxDC_E)
    "DC line to building D and E"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={160,-40})));
  dcLine linDC_C(P_nominal=PMaxDC_C, l=60) "DC line to building C"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={180,10})));
  dcLine linDC_BC(P_nominal=PMaxDC_D + PMaxDC_E + PMaxDC_C, l=40)
    "DC line between building B and C"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={220,-40})));
  dcLine linDC_B(P_nominal=PMaxDC_B, l=20) "DC line to building B"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={246,10})));
  dcLine linDC_AB(l=120, P_nominal=PMaxDC_D + PMaxDC_E + PMaxDC_C + PMaxDC_B)
    "DC line between building A and B"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={290,-40})));
  dcLine linDC_A(l=20, P_nominal=PMaxDC_A) "DC line to building A"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={306,10})));
  dcLine linDC_Bui(P_nominal=PMaxDC_D + PMaxDC_E + PMaxDC_C + PMaxDC_B +
        PMaxDC_A, l=20) "DC line between substation and building A"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={380,-40})));
  dcLine linDC_PV(l=50, P_nominal=PDCGen + PWinGen)
    "DC line to PV panels and wind turbine"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={400,68})));
equation
  connect(weaDat.weaBus,buiA. weaBus)             annotation (Line(
      points={{-200,70},{270,70},{270,40},{280,40}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(linCE.terminal_p, linBC.terminal_n)
                                        annotation (Line(
      points={{170,-20},{210,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(linC.terminal_n, linCE.terminal_p)
                                       annotation (Line(
      points={{200,0},{200,-20},{170,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(linB.terminal_n, linBC.terminal_p)
                                       annotation (Line(
      points={{258,-4.44089e-16},{258,-20},{230,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(linB.terminal_p, buiB.terminal)
                                       annotation (Line(
      points={{258,20},{258,40},{240.4,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(linC.terminal_p, buiC.terminal)
                                       annotation (Line(
      points={{200,20},{200,40},{172.4,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(buiE.terminal, linE.terminal_n)
                                       annotation (Line(
      points={{100.4,-80},{120,-80},{120,-70}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(buiD.terminal, linD.terminal_n)
                                       annotation (Line(
      points={{-21.6,-70},{10,-70},{10,-68}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(weaDat.weaBus, buiB.weaBus) annotation (Line(
      points={{-200,70},{210,70},{210,40},{220,40}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, buiC.weaBus) annotation (Line(
      points={{-200,70},{140,70},{140,40},{152,40}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, buiE.weaBus) annotation (Line(
      points={{-200,70},{-180,70},{-180,-120},{60,-120},{60,-80},{80,-80}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, buiD.weaBus) annotation (Line(
      points={{-200,70},{-180,70},{-180,-120},{-58,-120},{-58,-70},{-42,-70}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(senA.terminal_p, buiA.terminal) annotation (Line(
      points={{330,20},{330,40},{300.4,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-200,70},{270,70},{270,200}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(senTra.terminal_p, acac.terminal_n) annotation (Line(
      points={{-128,-20},{-120,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(senTra.terminal_n, gri.terminal) annotation (Line(
      points={{-148,-20},{-162,-20},{-162,-4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(HDifTil.H,G. u1) annotation (Line(
      points={{331,160},{350,160},{350,146},{358,146}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H,G. u2) annotation (Line(
      points={{331,120},{350,120},{350,134},{358,134}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(G.y,pv. G) annotation (Line(
      points={{381,140},{436,140},{436,112}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus,HDifTil. weaBus) annotation (Line(
      points={{-200,70},{270,70},{270,160},{310,160}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(HDirTil.weaBus,HDifTil. weaBus) annotation (Line(
      points={{310,120},{270,120},{270,160},{310,160}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tur.vWin, weaBus.winSpe) annotation (Line(
      points={{440,192},{440,200},{270,200}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(linA.terminal_p, senA.terminal_n) annotation (Line(
      points={{300,-20},{330,-20},{330,-4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(bat.terminal, acdc.terminal_p)  annotation (Line(
      points={{418,-20},{370,-20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(linA.terminal_n, linBC.terminal_p) annotation (Line(
      points={{280,-20},{230,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(acac.terminal_p, linDT.terminal_n) annotation (Line(
      points={{-100,-20},{-84,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(linDT.terminal_p, senDT.terminal_n) annotation (Line(
      points={{-64,-20},{-54,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(senDT.terminal_p, linDE.terminal_n) annotation (Line(
      points={{-34,-20},{34,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(linD.terminal_p, senDT.terminal_p) annotation (Line(
      points={{10,-48},{10,-20},{-34,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(linDE.terminal_p, senDE.terminal_n) annotation (Line(
      points={{54,-20},{76,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(senDE.terminal_p, linCE.terminal_n) annotation (Line(
      points={{96,-20},{150,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(senDE.terminal_p, linE.terminal_p) annotation (Line(
      points={{96,-20},{120,-20},{120,-50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(linA.terminal_p, acdc.terminal_n) annotation (Line(
      points={{300,-20},{350,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(ETot.u, senTra.S[1]) annotation (Line(
      points={{-122,-70},{-144,-70},{-144,-29}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vRel.u, senA.V) annotation (Line(
      points={{366,50},{360,50},{360,10},{339,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(linDC_D.terminal_n, buiD.terminal_dc) annotation (Line(
      points={{26,-60},{26,-76},{-22,-76}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(buiE.terminal_dc, linDC_E.terminal_n) annotation (Line(
      points={{100,-86},{140,-86},{140,-60}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pv.terminal, linDC_PV.terminal_p) annotation (Line(
      points={{426,100},{400,100},{400,78}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(linDC_PV.terminal_n, bat.terminal) annotation (Line(
      points={{400,58},{400,-20},{418,-20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(linDC_PV.terminal_p, tur.terminal) annotation (Line(
      points={{400,78},{400,180},{430,180}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(linDC_D.terminal_p, linDC_E.terminal_p) annotation (Line(
      points={{26,-40},{140,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(linDC_E.terminal_p, linDC_CE.terminal_p) annotation (Line(
      points={{140,-40},{150,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(linDC_CE.terminal_n, linDC_BC.terminal_p) annotation (Line(
      points={{170,-40},{210,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(buiC.terminal_dc, linDC_C.terminal_p) annotation (Line(
      points={{172,34},{180,34},{180,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(linDC_C.terminal_n, linDC_BC.terminal_p) annotation (Line(
      points={{180,0},{180,-40},{210,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(buiB.terminal_dc, linDC_B.terminal_p) annotation (Line(
      points={{240,34},{246,34},{246,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(linDC_BC.terminal_n, linDC_AB.terminal_p) annotation (Line(
      points={{230,-40},{280,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(linDC_B.terminal_n, linDC_AB.terminal_p) annotation (Line(
      points={{246,0},{246,-40},{280,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(buiA.terminal_dc, linDC_A.terminal_p) annotation (Line(
      points={{300,34},{306,34},{306,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(linDC_A.terminal_n, linDC_AB.terminal_n) annotation (Line(
      points={{306,0},{306,-40},{300,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(linDC_AB.terminal_n, linDC_Bui.terminal_p) annotation (Line(
      points={{300,-40},{370,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(linDC_Bui.terminal_n, bat.terminal) annotation (Line(
      points={{390,-40},{400,-40},{400,-20},{418,-20}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -180},{460,220}}), graphics), Icon(coordinateSystem(extent={{-240,-180},
            {460,220}})));
end PartialTimeSeriesCampus;
