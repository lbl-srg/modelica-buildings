within Buildings.HeatTransfer.Windows.Examples;
model Window "Test model for the window"
  import Buildings;
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Area A=1 "Window surface area";
  parameter Real fFra=0.2
    "Fraction of frame, = frame area divided by total area";
  parameter Boolean linearize = false "Set to true to linearize emissive power";
  parameter Modelica.SIunits.Angle lat=0.34906585039887 "Latitude";
  parameter Modelica.SIunits.Angle azi=0 "Surface azimuth";
  parameter Modelica.SIunits.Angle til=1.5707963267949 "Surface tilt";
  Buildings.HeatTransfer.Windows.Window window(
    A=A,
    fFra=fFra,
    glaSys=glaSys,
    linearize=linearize,
    til=til) "Window"
    annotation (Placement(transformation(extent={{82,70},{122,110}})));
  Buildings.HeatTransfer.Windows.InteriorHeatTransfer intCon(A=A, fFra=fFra,
    linearizeRadiation=linearize,
    absIRSha_air=glaSys.shade.absIR_a,
    absIRSha_glass=glaSys.shade.absIR_b,
    tauIRSha_air=glaSys.shade.tauIR_a,
    tauIRSha_glass=glaSys.shade.tauIR_b,
    haveExteriorShade=glaSys.haveExteriorShade,
    haveInteriorShade=glaSys.haveInteriorShade)
    "Room-side convective heat transfer"
    annotation (Placement(transformation(extent={{158,82},{138,102}})));
  Buildings.HeatTransfer.Windows.ExteriorHeatTransfer extCon(
    A=A,
    fFra=fFra,
    linearizeRadiation=linearize,
    absIRSha_air=glaSys.shade.absIR_a,
    absIRSha_glass=glaSys.shade.absIR_b,
    tauIRSha_air=glaSys.shade.tauIR_a,
    tauIRSha_glass=glaSys.shade.tauIR_b,
    haveExteriorShade=glaSys.haveExteriorShade,
    haveInteriorShade=glaSys.haveInteriorShade,
    vieFacSky=0.5) "Exterior convective heat transfer"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Modelica.Blocks.Sources.Constant TRooAir(k=293.15, y(unit="K"))
    "Room air temperature"
    annotation (Placement(transformation(extent={{120,140},{140,160}})));
  Modelica.Blocks.Sources.Ramp uSha(duration=0.5, startTime=0.25)
    "Shading control signal"
    annotation (Placement(transformation(extent={{-90,120},{-70,140}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TOuts
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TRAir
    "Room air temperature"
    annotation (Placement(transformation(extent={{160,140},{180,160}})));
  Buildings.HeatTransfer.Radiosity.IndoorRadiosity indRad(A=A)
    "Model for indoor radiosity"
    annotation (Placement(transformation(extent={{188,80},{168,100}})));
  Buildings.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow=0)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={178,48})));
  Buildings.HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveExteriorShade=false,
    haveInteriorShade=true)
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));
  Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
    til=til,
    lat=lat,
    azi=azi)
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.BoundaryConditions.SolarIrradiation.DiffuseIsotropic HDifTilIso(
               til=til)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
                                                        filNam=
        "Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Modelica.Blocks.Math.Gain HRoo(k=0.1) "Solar irradiation from room"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Buildings.HeatTransfer.Windows.BaseClasses.WindowRadiation winRad(
    AWin=1,
    N=glaSys.nLay,
    tauGlaSol=glaSys.glass.tauSol,
    rhoGlaSol_a=glaSys.glass.rhoSol_a,
    rhoGlaSol_b=glaSys.glass.rhoSol_b,
    xGla=glaSys.glass.x,
    tauShaSol_a=glaSys.shade.tauSol_a,
    tauShaSol_b=glaSys.shade.tauSol_b,
    rhoShaSol_a=glaSys.shade.rhoSol_a,
    rhoShaSol_b=glaSys.shade.rhoSol_b,
    haveExteriorShade=glaSys.haveExteriorShade,
    haveInteriorShade=glaSys.haveInteriorShade)
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{10,-20},{30,0}})));
equation
  connect(uSha.y, extCon.uSha) annotation (Line(
      points={{-69,130},{20,130},{20,98},{39.2,98}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uSha.y, window.uSha) annotation (Line(
      points={{-69,130},{54,130},{54,106},{80,106}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uSha.y, intCon.uSha) annotation (Line(
      points={{-69,130},{162,130},{162,100},{158.8,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOuts.port, extCon.air) annotation (Line(
      points={{5.55112e-16,50},{28,50},{28,90},{40,90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TRAir.port, intCon.air) annotation (Line(
      points={{180,150},{188,150},{188,120},{166,120},{166,92},{158,92}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TRooAir.y, TRAir.T) annotation (Line(
      points={{141,150},{158,150}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(window.glaUns_b, intCon.glaUns) annotation (Line(
      points={{122,92},{126,92},{126,94},{138,94}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(window.glaSha_b, intCon.glaSha) annotation (Line(
      points={{122,88},{126,88},{126,90},{138,90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(window.glaUns_a, extCon.glaUns) annotation (Line(
      points={{82,92},{60,92}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(window.glaSha_a, extCon.glaSha) annotation (Line(
      points={{82,88},{60,88}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(window.fra_a, extCon.frame) annotation (Line(
      points={{82,74},{70,74},{70,80},{57,80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(window.fra_b, intCon.frame) annotation (Line(
      points={{122.2,74},{140,74},{140,82},{141,82}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(extCon.JOutUns, window.JInUns_a) annotation (Line(
      points={{61,98},{71.5,98},{71.5,102},{81,102}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(extCon.JInUns, window.JOutUns_a) annotation (Line(
      points={{61,96},{72,96},{72,98},{81,98}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(extCon.JOutSha, window.JInSha_a) annotation (Line(
      points={{61,84},{81,84}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(extCon.JInSha, window.JOutSha_a) annotation (Line(
      points={{61,82},{72,82},{72,80},{81,80}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(window.JOutUns_b, intCon.JInUns) annotation (Line(
      points={{123,102},{130,102},{130,98},{137,98}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(intCon.JOutUns, window.JInUns_b) annotation (Line(
      points={{137,100},{130,100},{130,98},{123,98}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(window.JOutSha_b, intCon.JInSha) annotation (Line(
      points={{123,84},{126,84},{126,82},{130,82},{130,84},{137,84}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(intCon.JOutSha, window.JInSha_b) annotation (Line(
      points={{137,86},{130,86},{130,80},{123,80}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(indRad.JOut, intCon.JInRoo) annotation (Line(
      points={{167,94},{162,94},{162,84},{158,84}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(intCon.JOutRoo, indRad.JIn) annotation (Line(
      points={{158.4,88},{162,88},{162,86},{167,86}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(fixedHeatFlow.port, indRad.heatPort) annotation (Line(
      points={{178,58},{177.2,58},{177.2,80.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(winRad.QTra_flow,HRoo. u) annotation (Line(
      points={{121,-18},{140,-18},{140,-80},{40,-80},{40,-50},{58,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HRoo.y,winRad. HRoo) annotation (Line(
      points={{81,-50},{90,-50},{90,-17.6},{98.5,-17.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTilIso.H, winRad.HDif) annotation (Line(
      points={{81,30},{90,30},{90,-2},{98.5,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H, winRad.HDir) annotation (Line(
      points={{81,-10},{90,-10},{90,-6},{98.5,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.inc, winRad.incAng) annotation (Line(
      points={{81,-14},{90,-14},{90,-11},{98.5,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(winRad.QAbsExtSha_flow, extCon.QAbs_flow) annotation (Line(
      points={{121,-1},{128,-1},{128,52},{50,52},{50,79}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(winRad.QAbsIntSha_flow, intCon.QAbs_flow) annotation (Line(
      points={{121,-13},{148,-13},{148,81}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(winRad.QAbsGlaUns_flow, window.QAbsUns_flow) annotation (Line(
      points={{121,-5},{132,-5},{132,60},{94,60},{94,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(winRad.QAbsGlaSha_flow, window.QAbsSha_flow) annotation (Line(
      points={{121,-9},{138,-9},{138,64},{110,64},{110,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{5.55112e-16,-10},{20,-10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus, HDirTil.weaBus) annotation (Line(
      points={{20,-10},{60,-10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(HDifTilIso.weaBus, weaBus) annotation (Line(
      points={{60,30},{20,30},{20,-10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TOuts.T, weaBus.TDryBul) annotation (Line(
      points={{-22,50},{-30,50},{-30,20},{20,20},{20,-10}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(uSha.y, winRad.uSha) annotation (Line(
      points={{-69,130},{-60,130},{-60,-28},{109.8,-28},{109.8,-21.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.winSpe, extCon.vWin) annotation (Line(
      points={{20,-10},{20,94},{39.2,94}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus.TBlaSky, extCon.TBlaSky) annotation (Line(
      points={{20,-10},{20,85.8},{38.8,85.8}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.TDryBul, extCon.TOut) annotation (Line(
      points={{20,-10},{20,82.1},{38.9,82.1}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {200,200}}),
                      graphics),
  
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/Examples/Window.mos"
        "Simulate and plot"));
end Window;
