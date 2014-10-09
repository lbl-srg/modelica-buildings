within Districts.BuildingLoads.Examples;
model LinearRegressionCampus
  "Example model for the linear regression building load as part of a campus"
  import Districts;
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Voltage VTra = 50e3 "Voltage of transmission grid";
  parameter Modelica.SIunits.Voltage VDis = 480
    "Voltage of the distribution grid";
  parameter Modelica.SIunits.Voltage VDC = 240 "Voltage of DC grid";

  // Rated power that is used to size cables
  parameter Modelica.SIunits.Power P_a = 1e5 "Rated power for sizing";
  parameter Modelica.SIunits.Power P_b = 1e5 "Rated power for sizing";
  parameter Modelica.SIunits.Power P_c = 1e5 "Rated power for sizing";
  parameter Modelica.SIunits.Power P_d = 1e5 "Rated power for sizing";
  parameter Modelica.SIunits.Power P_e = 1e5 "Rated power for sizing";
  parameter Modelica.SIunits.Power P_bc = P_a  + P_b "Rated power for sizing";
  parameter Modelica.SIunits.Power P_ce = P_bc + P_c "Rated power for sizing";
  parameter Modelica.SIunits.Power P_de = P_ce + P_e "Rated power for sizing";
  parameter Modelica.SIunits.Power P_dt = P_de + P_d "Rated power for sizing";
  // Declaration of the line model
  // Set the instance 'line' either to 'DummyLine' or to 'Districts.Electrical.AC.AC3ph.Lines.Line'
  //model line = DummyLine "Line model";
  model line = Districts.Electrical.AC.ThreePhasesBalanced.Lines.Line
    "Line model";
  //model line = resistiveLine "Line model";
  Districts.BuildingLoads.LinearRegression buiA(fileName="modelica://Districts/Resources/Data/BuildingLoads/Examples/smallOffice_1.txt",
    V_nominal_AC=VDis,
    V_nominal_DC=VDC) "Building A"
    annotation (Placement(transformation(extent={{230,30},{250,50}})));
  Districts.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Districts/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-220,60},{-200,80}})));
  Districts.Electrical.AC.ThreePhasesBalanced.Sources.Grid gri(
    f=60,
    Phi=0,
    V=VTra)
           annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  Districts.Electrical.AC.ThreePhasesBalanced.Conversion.ACACConverter acac(eta=0.9,
      conversionFactor=VDis/VTra) "AC/AC converter"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  line dt(
    P_nominal=P_dt,
    V_nominal=VDis,
    l=40,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu35())
    "Distribution line"
    annotation (Placement(transformation(extent={{-22,-30},{-2,-10}})));
  line de(
    V_nominal=VDis,
    P_nominal=P_de,
    l=400,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu35())
    "Distribution line"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  line d(
    V_nominal=VDis,
    P_nominal=P_d,
    l=20,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu35())
    "Distribution line"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-50})));
  line e(
    V_nominal=VDis,
    P_nominal=P_e,
    l=20,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu35())
    "Distribution line"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-50})));
  line ce(
    V_nominal=VDis,
    P_nominal=P_ce,
    l=50,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu35())
    "Distribution line"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  line c(
    V_nominal=VDis,
    P_nominal=P_c,
    l=60,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu35())
    "Distribution line"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={140,10})));
  line bc(
    V_nominal=VDis,
    P_nominal=P_bc,
    l=40,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu35())
    "Distribution line"
    annotation (Placement(transformation(extent={{160,-30},{180,-10}})));
  line b(
    V_nominal=VDis,
    P_nominal=P_b,
    l=20,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu35())
    "Distribution line"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={200,10})));
  line a(
    V_nominal=VDis,
    P_nominal=P_a,
    l=120,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu35())
    "Distribution line"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={250,-20})));
  Districts.BuildingLoads.LinearRegression buiB(fileName="modelica://Districts/Resources/Data/BuildingLoads/Examples/smallOffice_1.txt",
    V_nominal_AC=VDis,
    V_nominal_DC=VDC) "Building B"
    annotation (Placement(transformation(extent={{170,30},{190,50}})));
  Districts.BuildingLoads.LinearRegression buiC(fileName="modelica://Districts/Resources/Data/BuildingLoads/Examples/smallOffice_1.txt",
    V_nominal_AC=VDis,
    V_nominal_DC=VDC) "Building C"
    annotation (Placement(transformation(extent={{108,30},{128,50}})));
  Districts.BuildingLoads.LinearRegression buiD(fileName="modelica://Districts/Resources/Data/BuildingLoads/Examples/smallOffice_1.txt",
    V_nominal_AC=VDis,
    V_nominal_DC=VDC) "Building D"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Districts.BuildingLoads.LinearRegression buiE(fileName="modelica://Districts/Resources/Data/BuildingLoads/Examples/smallOffice_1.txt",
    V_nominal_AC=VDis,
    V_nominal_DC=VDC) "Building E"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));

  Districts.Electrical.AC.ThreePhasesBalanced.Sensors.GeneralizedSensor senAC
    "Sensor in AC line after the transformer"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Districts.Electrical.AC.ThreePhasesBalanced.Conversion.ACDCConverter acdc(conversionFactor=
        VDC/VDis, eta=0.9) "AC/DC converter"
    annotation (Placement(transformation(extent={{300,-30},{320,-10}})));
  Districts.Electrical.AC.ThreePhasesBalanced.Sensors.GeneralizedSensor senA
    "Sensor in AC line at building A"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={280,10})));
  Districts.Electrical.DC.Storage.Battery bat(EMax=P_dt*24*3600*0.1) "Battery"
    annotation (Placement(transformation(extent={{376,-10},{396,-30}})));

  Districts.BuildingLoads.Examples.BaseClasses.BatteryControl_V
                   conBat(PMax=PDCGen/100, VDis=VDis) "Battery controller"
    annotation (Placement(transformation(extent={{358,-114},{378,-94}})));
  Districts.Electrical.DC.Sources.PVSimple pv(A=100*150) "PV array"
    annotation (Placement(transformation(extent={{376,80},{396,100}})));
  Modelica.Blocks.Math.Add G "Total irradiation on tilted surface"
    annotation (Placement(transformation(extent={{310,120},{330,140}})));
  Districts.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil(
    til=0.34906585039887,
    lat=0.65798912800186,
    azi=-0.78539816339745) "Diffuse irradiation on tilted surface"
    annotation (Placement(transformation(extent={{260,140},{280,160}})));
  Districts.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
    til=0.34906585039887,
    lat=0.65798912800186,
    azi=-0.78539816339745) "Direct irradiation on tilted surface"
    annotation (Placement(transformation(extent={{260,100},{280,120}})));
  Districts.Electrical.DC.Sources.WindTurbine tur(h=50, scale=500e3)
    "Wind turbine"
    annotation (Placement(transformation(extent={{380,160},{400,180}})));
  Districts.BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{210,190},{230,210}})));
protected
  model resistiveLine
    extends Districts.Electrical.AC.ThreePhasesBalanced.Lines.TwoPortResistance(R=0.3e-3*l);
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
      redeclare
        Districts.Electrical.AC.ThreePhasesBalanced.Interfaces.Terminal_n         terminal_n,
      redeclare
        Districts.Electrical.AC.ThreePhasesBalanced.Interfaces.Terminal_n         terminal_p);

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
equation
  connect(weaDat.weaBus,buiA. weaBus)             annotation (Line(
      points={{-200,70},{220,70},{220,40},{230,40}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(gri.terminal, acac.terminal_n)          annotation (Line(
      points={{-150,-4.44089e-16},{-150,-20},{-120,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(dt.terminal_p, de.terminal_n) annotation (Line(
      points={{-2,-20},{40,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(dt.terminal_p, d.terminal_p) annotation (Line(
      points={{-2,-20},{20,-20},{20,-40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(de.terminal_p, ce.terminal_n) annotation (Line(
      points={{60,-20},{100,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(e.terminal_p, de.terminal_p) annotation (Line(
      points={{80,-40},{80,-20},{60,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(ce.terminal_p, bc.terminal_n) annotation (Line(
      points={{120,-20},{160,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(c.terminal_n, ce.terminal_p) annotation (Line(
      points={{140,0},{140,-20},{120,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(bc.terminal_p, a.terminal_n) annotation (Line(
      points={{180,-20},{240,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(b.terminal_n, bc.terminal_p) annotation (Line(
      points={{200,-4.44089e-16},{200,-20},{180,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(b.terminal_p, buiB.terminal) annotation (Line(
      points={{200,20},{200,40},{190.4,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(c.terminal_p, buiC.terminal) annotation (Line(
      points={{140,20},{140,40},{128.4,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(buiE.terminal, e.terminal_n) annotation (Line(
      points={{70.4,-80},{80,-80},{80,-60}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(buiD.terminal, d.terminal_n) annotation (Line(
      points={{10.4,-80},{20,-80},{20,-60}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(weaDat.weaBus, buiB.weaBus) annotation (Line(
      points={{-200,70},{160,70},{160,40},{170,40}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, buiC.weaBus) annotation (Line(
      points={{-200,70},{100,70},{100,40},{108,40}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, buiE.weaBus) annotation (Line(
      points={{-200,70},{-180,70},{-180,-100},{40,-100},{40,-80},{50,-80}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, buiD.weaBus) annotation (Line(
      points={{-200,70},{-180,70},{-180,-100},{-20,-100},{-20,-80},{-10,-80}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(acac.terminal_p, senAC.terminal_n)  annotation (Line(
      points={{-100,-20},{-80,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(senAC.terminal_p, dt.terminal_n)  annotation (Line(
      points={{-60,-20},{-22,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(a.terminal_p, senA.terminal_n) annotation (Line(
      points={{260,-20},{280,-20},{280,-4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(senA.terminal_p, buiA.terminal) annotation (Line(
      points={{280,20},{280,40},{250.4,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(acdc.terminal_p, buiC.terminal_dc) annotation (Line(
      points={{320,-20},{340,-20},{340,24},{136,24},{136,34},{128,34}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(buiB.terminal_dc, buiC.terminal_dc) annotation (Line(
      points={{190,34},{194,34},{194,24},{136,24},{136,34},{128,34}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(buiA.terminal_dc, buiC.terminal_dc) annotation (Line(
      points={{250,34},{256,34},{256,24},{136,24},{136,34},{128,34}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(acdc.terminal_p, buiD.terminal_dc) annotation (Line(
      points={{320,-20},{340,-20},{340,-94},{20,-94},{20,-86},{10,-86}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(buiE.terminal_dc, buiD.terminal_dc) annotation (Line(
      points={{70,-86},{80,-86},{80,-94},{20,-94},{20,-86},{10,-86}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(bat.terminal, buiC.terminal_dc)     annotation (Line(
      points={{376,-20},{340,-20},{340,24},{136,24},{136,34},{128,34}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(bat.SOC, conBat.SOC) annotation (Line(
      points={{397,-26},{410,-26},{410,50},{346,50},{346,-98},{356,-98}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTil.H,G. u1) annotation (Line(
      points={{281,150},{300,150},{300,136},{308,136}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H,G. u2) annotation (Line(
      points={{281,110},{300,110},{300,124},{308,124}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(G.y, pv.G) annotation (Line(
      points={{331,130},{386,130},{386,102}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pv.terminal, buiD.terminal_dc) annotation (Line(
      points={{376,90},{340,90},{340,-94},{20,-94},{20,-86},{10,-86}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, HDifTil.weaBus) annotation (Line(
      points={{-200,70},{220,70},{220,150},{260,150}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(HDirTil.weaBus, HDifTil.weaBus) annotation (Line(
      points={{260,110},{220,110},{220,150},{260,150}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tur.vWin, weaBus.winSpe) annotation (Line(
      points={{390,182},{390,200},{220,200}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-200,70},{220,70},{220,200}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(tur.terminal, acdc.terminal_p) annotation (Line(
      points={{380,170},{340,170},{340,-20},{320,-20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(acdc.terminal_n, a.terminal_p) annotation (Line(
      points={{300,-20},{260,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(conBat.P, bat.P) annotation (Line(
      points={{379,-104},{386,-104},{386,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senAC.V, conBat.VMea) annotation (Line(
      points={{-70,-29},{-70,-110},{356,-110}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -120},{420,220}}), graphics),
    experiment(
      StartTime=345600,
      StopTime=950400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"),
      Commands(file=
          "modelica://Districts/Resources/Scripts/Dymola/BuildingLoads/Examples/LinearRegressionCampus.mos"
        "Simulate and plot"));
end LinearRegressionCampus;
