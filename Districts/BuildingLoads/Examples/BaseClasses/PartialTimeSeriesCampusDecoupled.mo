within Districts.BuildingLoads.Examples.BaseClasses;
partial model PartialTimeSeriesCampusDecoupled
  "Partial model for the time series building load as part of a campus"
  import Districts;
  parameter Modelica.SIunits.Voltage VTra = 50e3 "Voltage of transmission grid";
  parameter Modelica.SIunits.Voltage VDis = 480
    "Voltage of the distribution grid";
  parameter Modelica.SIunits.Voltage VDC = 240 "Voltage of DC grid";

  // Rated power that is used to size cables
  constant Real safetyMargin = 1.2 "Safety margin used for cable sizing";
  parameter Modelica.SIunits.Power PDCGen = 1e8
    "Rated power for generated DC power";

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
  //replaceable model line = DummyLine "Line model";
  replaceable model line =
      Districts.Electrical.AC.ThreePhasesBalanced.Lines.Line (
    mode = Districts.Electrical.Types.CableMode.commercial,
    commercialCable = Districts.Electrical.Transmission.CommercialCables.Cu100())
    "Line model";
  //model line = resistiveLine "Line model";
  Districts.BuildingLoads.TimeSeries buiA(fileName="modelica://Districts/Resources/Data/BuildingLoads/Examples/buildingA.txt",
    V_nominal_AC=VDis,
    V_nominal_DC=VDC) "Building A"
    annotation (Placement(transformation(extent={{280,30},{300,50}})));
  Districts.BuildingLoads.TimeSeries buiB(fileName="modelica://Districts/Resources/Data/BuildingLoads/Examples/buildingB.txt",
    V_nominal_AC=VDis,
    V_nominal_DC=VDC) "Building B"
    annotation (Placement(transformation(extent={{220,30},{240,50}})));
  Districts.BuildingLoads.TimeSeries buiC(fileName="modelica://Districts/Resources/Data/BuildingLoads/Examples/buildingC.txt",
    V_nominal_AC=VDis,
    V_nominal_DC=VDC) "Building C"
    annotation (Placement(transformation(extent={{152,30},{172,50}})));
  Districts.BuildingLoads.TimeSeries buiD(fileName="modelica://Districts/Resources/Data/BuildingLoads/Examples/buildingD.txt",
    V_nominal_AC=VDis,
    V_nominal_DC=VDC) "Building D"
    annotation (Placement(transformation(extent={{-42,-80},{-22,-60}})));
  Districts.BuildingLoads.TimeSeries buiE(fileName="modelica://Districts/Resources/Data/BuildingLoads/Examples/buildingE.txt",
    V_nominal_AC=VDis,
    V_nominal_DC=VDC) "Building E"
    annotation (Placement(transformation(extent={{110,-90},{130,-70}})));

  Districts.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Districts/Resources/weatherdata/CZ10RV2.mos")
    annotation (Placement(transformation(extent={{-220,60},{-200,80}})));
  Districts.Electrical.AC.ThreePhasesBalanced.Sources.Grid gri(
    f=60,
    Phi=0,
    V=VTra)
           annotation (Placement(transformation(extent={{-172,0},{-152,20}})));
  Districts.Electrical.AC.ThreePhasesBalanced.Conversion.ACACConverter
                                                         acac(eta=0.9,
      conversionFactor=VDis/VTra) "AC/AC converter"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  line linDT(
    P_nominal=P_dt,
    V_nominal=VDis,
    l=40,
    wireMaterial=Districts.Electrical.Transmission.Materials.Material.Cu)
    "Distribution line"
    annotation (Placement(transformation(extent={{-84,-30},{-64,-10}})));
  line linDE(
    V_nominal=VDis,
    wireMaterial=Districts.Electrical.Transmission.Materials.Material.Cu,
    P_nominal=P_de,
    l=400) "Distribution line"
    annotation (Placement(transformation(extent={{34,-30},{54,-10}})));
  line linD(
    V_nominal=VDis,
    P_nominal=P_d,
    l=20,
    wireMaterial=Districts.Electrical.Transmission.Materials.Material.Cu)
    "Distribution line"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,-50})));
  line linE(
    V_nominal=VDis,
    P_nominal=P_e,
    l=20,
    wireMaterial=Districts.Electrical.Transmission.Materials.Material.Cu)
    "Distribution line"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={140,-50})));
  line linCE(
    V_nominal=VDis,
    P_nominal=P_ce,
    l=50,
    wireMaterial=Districts.Electrical.Transmission.Materials.Material.Cu)
    "Distribution line"
    annotation (Placement(transformation(extent={{150,-30},{170,-10}})));
  line linC(
    V_nominal=VDis,
    P_nominal=P_c,
    l=60,
    wireMaterial=Districts.Electrical.Transmission.Materials.Material.Cu)
    "Distribution line"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={190,10})));
  line linBC(
    V_nominal=VDis,
    P_nominal=P_bc,
    l=40,
    wireMaterial=Districts.Electrical.Transmission.Materials.Material.Cu)
    "Distribution line"
    annotation (Placement(transformation(extent={{210,-30},{230,-10}})));
  line linB(
    V_nominal=VDis,
    P_nominal=P_b,
    l=20,
    wireMaterial=Districts.Electrical.Transmission.Materials.Material.Cu)
    "Distribution line"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={250,10})));
  line linA(
    V_nominal=VDis,
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
  Districts.Electrical.DC.Sources.PVSimple pv(A=10000) "PV array"
    annotation (Placement(transformation(extent={{426,90},{446,110}})));
  Modelica.Blocks.Math.Add G "Total irradiation on tilted surface"
    annotation (Placement(transformation(extent={{340,130},{360,150}})));
  Districts.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil(
    til=0.34906585039887,
    lat=0.65798912800186,
    azi=-0.78539816339745) "Diffuse irradiation on tilted surface"
    annotation (Placement(transformation(extent={{290,150},{310,170}})));
  Districts.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
    til=0.34906585039887,
    lat=0.65798912800186,
    azi=-0.78539816339745) "Direct irradiation on tilted surface"
    annotation (Placement(transformation(extent={{290,110},{310,130}})));
  Districts.Electrical.DC.Sources.WindTurbine tur(h=50, scale=500e3)
    "Wind turbine"
    annotation (Placement(transformation(extent={{430,170},{450,190}})));
  Districts.Electrical.DC.Storage.Battery bat(EMax=PDCGen*4*3600) "Battery"
    annotation (Placement(transformation(extent={{418,-30},{438,-10}})));
  Districts.Electrical.AC.ThreePhasesBalanced.Sensors.GeneralizedSensor senDE
    "Sensor in DE line"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Continuous.Integrator ETot "Total transmitted energy"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  Districts.Electrical.DC.Sources.ConstantVoltage constantVoltage(V=VDC,
      definiteReference=true)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={360,-20})));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{340,-52},{360,-32}})));
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
      points={{190,0},{190,-20},{170,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(linB.terminal_n, linBC.terminal_p)
                                       annotation (Line(
      points={{250,0},{250,-20},{230,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(linB.terminal_p, buiB.terminal)
                                       annotation (Line(
      points={{250,20},{250,40},{240.4,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(linC.terminal_p, buiC.terminal)
                                       annotation (Line(
      points={{190,20},{190,40},{172.4,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(buiE.terminal, linE.terminal_n)
                                       annotation (Line(
      points={{130.4,-80},{140,-80},{140,-60}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(buiD.terminal, linD.terminal_n)
                                       annotation (Line(
      points={{-21.6,-70},{10,-70},{10,-60}},
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
      points={{-200,70},{-180,70},{-180,-120},{100,-120},{100,-80},{110,-80}},
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
      points={{311,160},{332,160},{332,146},{338,146}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H,G. u2) annotation (Line(
      points={{311,120},{332,120},{332,134},{338,134}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(G.y,pv. G) annotation (Line(
      points={{361,140},{436,140},{436,112}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus,HDifTil. weaBus) annotation (Line(
      points={{-200,70},{270,70},{270,160},{290,160}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(HDirTil.weaBus,HDifTil. weaBus) annotation (Line(
      points={{290,120},{270,120},{270,160},{290,160}},
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
      points={{10,-40},{10,-20},{-34,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(linDE.terminal_p, senDE.terminal_n) annotation (Line(
      points={{54,-20},{100,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(senDE.terminal_p, linCE.terminal_n) annotation (Line(
      points={{120,-20},{150,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(senDE.terminal_p, linE.terminal_p) annotation (Line(
      points={{120,-20},{140,-20},{140,-40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(ETot.u, senTra.S[1]) annotation (Line(
      points={{-122,-70},{-144,-70},{-144,-29}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(buiC.terminal_dc, buiB.terminal_dc) annotation (Line(
      points={{172,34},{200,34},{200,24},{246,24},{246,34},{240,34}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(buiB.terminal_dc, buiA.terminal_dc) annotation (Line(
      points={{240,34},{246,34},{246,24},{310,24},{310,34},{300,34}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(buiA.terminal_dc, constantVoltage.terminal) annotation (Line(
      points={{300,34},{370,34},{370,-20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(constantVoltage.terminal, bat.terminal) annotation (Line(
      points={{370,-20},{418,-20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(constantVoltage.terminal, pv.terminal) annotation (Line(
      points={{370,-20},{370,100},{426,100}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(buiD.terminal_dc, buiE.terminal_dc) annotation (Line(
      points={{-22,-76},{16,-76},{16,-76},{50,-76},{50,-100},{136,-100},{136,-86},
          {130,-86}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(buiE.terminal_dc, constantVoltage.terminal) annotation (Line(
      points={{130,-86},{370,-86},{370,-20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(tur.terminal, constantVoltage.terminal) annotation (Line(
      points={{430,180},{370,180},{370,-20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(ground.p, constantVoltage.n) annotation (Line(
      points={{350,-32},{350,-20}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -140},{460,220}}), graphics));
end PartialTimeSeriesCampusDecoupled;
