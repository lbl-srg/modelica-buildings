within Districts.BuildingLoads.Examples;
model TimeSeriesCampus
  "Example model for the time series building load as part of a campus"
  import Districts;
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Voltage VTra = 50e3 "Voltage of transmission grid";
  parameter Modelica.SIunits.Voltage VDis = 480
    "Voltage of the distribution grid";
  parameter Modelica.SIunits.Voltage VDC = 240 "Voltage of DC grid";

  // Rated power that is used to size cables
  constant Real safetyMargin = 2 "Safety margin used for cable sizing";
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

  parameter Modelica.SIunits.Power P_a = PMaxAC_A*safetyMargin
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
  parameter Modelica.SIunits.Power P_dt = max(P_de + P_d + PMaxDC, PDCGen)
    "Rated apparent power for sizing";
  // Declaration of the line model
  // Set the instance 'line' either to 'DummyLine' or to 'Districts.Electrical.AC.AC3ph.Lines.Line'
  //model line = DummyLine "Line model";
  model line = Districts.Electrical.AC.AC3ph.Lines.Line "Line model";
  //model line = resistiveLine "Line model";
  Districts.BuildingLoads.TimeSeries buiA(fileName="Resources/Data/BuildingLoads/Examples/buildingA.txt")
    "Building A"
    annotation (Placement(transformation(extent={{280,30},{300,50}})));
  Districts.BuildingLoads.TimeSeries buiB(fileName="Resources/Data/BuildingLoads/Examples/buildingB.txt")
    "Building B"
    annotation (Placement(transformation(extent={{220,30},{240,50}})));
  Districts.BuildingLoads.TimeSeries buiC(fileName="Resources/Data/BuildingLoads/Examples/buildingC.txt")
    "Building C"
    annotation (Placement(transformation(extent={{152,30},{172,50}})));
  Districts.BuildingLoads.TimeSeries buiD(fileName="Resources/Data/BuildingLoads/Examples/buildingD.txt")
    "Building D"
    annotation (Placement(transformation(extent={{-42,-80},{-22,-60}})));
  Districts.BuildingLoads.TimeSeries buiE(fileName="Resources/Data/BuildingLoads/Examples/buildingE.txt")
    "Building E"
    annotation (Placement(transformation(extent={{110,-90},{130,-70}})));

  Districts.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "Resources/weatherdata/CZ10RV2.mos")
    annotation (Placement(transformation(extent={{-220,60},{-200,80}})));
  Districts.Electrical.AC.AC3ph.Sources.Grid gri(
    f=60,
    Phi=0,
    V=VTra)
           annotation (Placement(transformation(extent={{-172,0},{-152,20}})));
  Districts.Electrical.AC.AC3ph.Conversion.ACACConverter acac(eta=0.9,
      conversionFactor=VDis/VTra) "AC/AC converter"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  line linDT(
    P_nominal=P_dt,
    V_nominal=VDis,
    l=40,
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"
    annotation (Placement(transformation(extent={{-22,-30},{-2,-10}})));
  line linDE(
    V_nominal=VDis,
    P_nominal=P_de,
    l=400,
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  line linD(
    V_nominal=VDis,
    P_nominal=P_d,
    l=20,
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,-50})));
  line linE(
    V_nominal=VDis,
    P_nominal=P_e,
    l=20,
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={140,-50})));
  line linCE(
    V_nominal=VDis,
    P_nominal=P_ce,
    l=50,
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"
    annotation (Placement(transformation(extent={{150,-30},{170,-10}})));
  line linC(
    V_nominal=VDis,
    P_nominal=P_c,
    l=60,
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={190,10})));
  line linBC(
    V_nominal=VDis,
    P_nominal=P_bc,
    l=40,
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"
    annotation (Placement(transformation(extent={{210,-30},{230,-10}})));
  line linB(
    V_nominal=VDis,
    P_nominal=P_b,
    l=20,
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={250,10})));
  line linA(
    V_nominal=VDis,
    P_nominal=P_a,
    l=120,
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={310,-20})));

  Districts.Electrical.AC.AC3ph.Sensors.GeneralizedSensor senAC
    "Sensor in AC line after the transformer"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Districts.Electrical.AC.AC3ph.Sensors.GeneralizedSensor senA
    "Sensor in AC line at building A"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={330,10})));

  Districts.BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{260,190},{280,210}})));
protected
  model resistiveLine
    extends Districts.Electrical.AC.AC3ph.Lines.TwoPortResistance(R=0.3e-3*l);
      parameter Modelica.SIunits.Distance l(min=0) "Length of the line";
      parameter Modelica.SIunits.Power P_nominal(min=0)
      "Nominal power of the line";
      parameter Modelica.SIunits.Voltage V_nominal
      "Nominal voltage of the line";
  parameter Districts.Electrical.Transmission.Materials.Material wireMaterial=
      Districts.Electrical.Transmission.Materials.Copper()
      "Material of the cable"
    annotation (choicesAllMatching=true,Dialog(tab="Tech. specification",
                enable=mode==Districts.Electrical.Types.CableMode.normative),
                Placement(transformation(extent={{60,60}, {80,80}})));

  end resistiveLine;

model DummyLine
  extends Districts.Electrical.Interfaces.PartialTwoPort(
      redeclare package PhaseSystem_p =
        Districts.Electrical.PhaseSystems.ThreePhase_dq,
      redeclare package PhaseSystem_n =
        Districts.Electrical.PhaseSystems.ThreePhase_dq,
      redeclare Districts.Electrical.AC.AC3ph.Interfaces.Terminal_n terminal_n,
      redeclare Districts.Electrical.AC.AC3ph.Interfaces.Terminal_n terminal_p);

  parameter Modelica.SIunits.Distance l(min=0) "Length of the line";
  parameter Modelica.SIunits.Power P_nominal(min=0) "Nominal power of the line";
  parameter Modelica.SIunits.Voltage V_nominal "Nominal voltage of the line";
  parameter Districts.Electrical.Transmission.Cables.Cable cable=
      Districts.Electrical.Transmission.Functions.selectCable(
        P=P_nominal,
        V=V_nominal,
        mode=Districts.Electrical.Types.CableMode.automatic) "Type of cable"
  annotation (choicesAllMatching=true,Dialog(tab="Tech. specification"), Placement(transformation(extent={{20,60},
              {40,80}})));
  parameter Districts.Electrical.Transmission.Materials.Material wireMaterial=
      Districts.Electrical.Transmission.Materials.Copper()
      "Material of the cable"
    annotation (choicesAllMatching=true,Dialog(tab="Tech. specification"), Placement(transformation(extent={{60,60},
              {80,80}})));
equation

  connect(terminal_n, terminal_p) annotation (Line(
      points={{-100,2.22045e-16},{-4,2.22045e-16},{-4,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
          graphics={
          Rectangle(extent={{-80,12},{80,-12}}, lineColor={0,0,0}),
          Line(
            points={{-80,0},{-100,0}},
            color={0,0,0},
            smooth=Smooth.None),
          Line(
            points={{80,0},{100,0}},
            color={0,0,0},
            smooth=Smooth.None),
          Text(
            extent={{-44,70},{40,34}},
            lineColor={0,0,0},
            textString="%name"),
          Text(
            extent={{-104,-36},{104,-78}},
            lineColor={0,0,0},
            textString="l=%l")}));
end DummyLine;
public
  Districts.Electrical.AC.AC3ph.Sensors.GeneralizedSensor senTra
    "Sensor in the transmission grid"
    annotation (Placement(transformation(extent={{-150,-30},{-130,-10}})));
  Districts.Electrical.AC.AC3ph.Conversion.ACDCConverter acdc(conversionFactor=
        VDC/VDis, eta=0.9) "AC/DC converter"
    annotation (Placement(transformation(extent={{42,-80},{62,-60}})));
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
  Districts.Electrical.DC.Sources.WindTurbine tur(h=50, scale=500e3)
    "Wind turbine"
    annotation (Placement(transformation(extent={{430,170},{450,190}})));
  Districts.BuildingLoads.Examples.BaseClasses.BatteryControl_V conBat(VDis=
        VDis, PMax=PDCGen/10) "Battery controller"
    annotation (Placement(transformation(extent={{420,0},{440,20}})));
  Districts.Electrical.DC.Storage.Battery bat(EMax=PDCGen*4*3600) "Battery"
    annotation (Placement(transformation(extent={{418,-30},{438,-10}})));
equation
  connect(weaDat.weaBus,buiA. weaBus)             annotation (Line(
      points={{-200,70},{270,70},{270,40},{280,40}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(linDT.terminal_p, linDE.terminal_n)
                                        annotation (Line(
      points={{-2,-20},{100,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(linDT.terminal_p, linD.terminal_p)
                                       annotation (Line(
      points={{-2,-20},{10,-20},{10,-40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(linDE.terminal_p, linCE.terminal_n)
                                        annotation (Line(
      points={{120,-20},{150,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(linE.terminal_p, linDE.terminal_p)
                                       annotation (Line(
      points={{140,-40},{140,-20},{120,-20}},
      color={0,120,120},
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
  connect(acac.terminal_p, senAC.terminal_n)  annotation (Line(
      points={{-100,-20},{-80,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(senAC.terminal_p, linDT.terminal_n)
                                            annotation (Line(
      points={{-60,-20},{-22,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(senA.terminal_p, buiA.terminal) annotation (Line(
      points={{330,20},{330,40},{300.4,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(buiB.terminal_dc, buiC.terminal_dc) annotation (Line(
      points={{240,34},{244,34},{244,24},{186,24},{186,34},{172,34}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(buiA.terminal_dc, buiC.terminal_dc) annotation (Line(
      points={{300,34},{306,34},{306,24},{186,24},{186,34},{172,34}},
      color={0,0,255},
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
      points={{-130,-20},{-120,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(senTra.terminal_n, gri.terminal) annotation (Line(
      points={{-150,-20},{-162,-20},{-162,-4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(buiD.terminal_dc, acdc.terminal_p)  annotation (Line(
      points={{-22,-76},{0,-76},{0,-100},{80,-100},{80,-70},{62,-70}},
      color={0,0,255},
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
      points={{320,-20},{330,-20},{330,-4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(bat.SOC,conBat. SOC) annotation (Line(
      points={{439,-14},{450,-14},{450,34},{408,34},{408,16},{418,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senA.V,conBat. VMea) annotation (Line(
      points={{339,10},{378,10},{378,4},{418,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conBat.P, bat.P) annotation (Line(
      points={{441,10},{446,10},{446,-2},{428,-2},{428,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(acdc.terminal_p, tur.terminal)  annotation (Line(
      points={{62,-70},{80,-70},{80,-100},{400,-100},{400,180},{430,180}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pv.terminal, acdc.terminal_p)  annotation (Line(
      points={{426,100},{400,100},{400,-100},{80,-100},{80,-70},{62,-70}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(buiE.terminal_dc, acdc.terminal_p)  annotation (Line(
      points={{130,-86},{140,-86},{140,-100},{80,-100},{80,-70},{62,-70}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(bat.terminal, acdc.terminal_p)  annotation (Line(
      points={{418,-20},{400,-20},{400,-100},{80,-100},{80,-70},{62,-70}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(buiC.terminal_dc, acdc.terminal_p)  annotation (Line(
      points={{172,34},{180,34},{180,-100},{80,-100},{80,-70},{62,-70}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(linDT.terminal_p, acdc.terminal_n)  annotation (Line(
      points={{-2,-20},{28,-20},{28,-70},{42,-70}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(linA.terminal_n, linBC.terminal_p) annotation (Line(
      points={{300,-20},{230,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -140},{460,220}}), graphics),
    experiment(
      StartTime=345600,
      StopTime=950400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"),
      Commands(file=
          "Resources/Scripts/Dymola/BuildingLoads/Examples/TimeSeriesCampus.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(extent={{-240,-140},{460,220}})));
end TimeSeriesCampus;
