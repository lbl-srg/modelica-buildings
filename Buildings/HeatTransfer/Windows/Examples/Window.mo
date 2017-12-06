within Buildings.HeatTransfer.Windows.Examples;
model Window "Test model for the window"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Area A=1 "Window surface area";
  parameter Real fFra=0.2
    "Fraction of frame, = frame area divided by total area";
  final parameter Modelica.SIunits.Area AFra = fFra * A "Frame area";
  final parameter Modelica.SIunits.Area AGla = A-AFra "Glass area";
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
  Modelica.Blocks.Sources.Ramp uSha(duration=0.5, startTime=0.25)
    "Shading control signal"
    annotation (Placement(transformation(extent={{-90,120},{-70,140}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TOuts
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TRAir(T=293.15)
    "Room air temperature"
    annotation (Placement(transformation(extent={{300,20},{280,40}})));
  Buildings.HeatTransfer.Radiosity.IndoorRadiosity indRad(A=A)
    "Model for indoor radiosity"
    annotation (Placement(transformation(extent={{322,100},{302,120}})));
  Buildings.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow=0)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={312,68})));
  replaceable parameter
    Buildings.HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear         glaSys(
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveExteriorShade=false,
    haveInteriorShade=true) constrainedby Data.GlazingSystems.Generic
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
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Modelica.Blocks.Math.Gain HRoo(k=0.1) "Solar irradiation from room"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Buildings.HeatTransfer.Windows.BaseClasses.WindowRadiation winRad(
    AWin=1,
    N=size(glaSys.glass, 1),
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

  Buildings.HeatTransfer.Windows.BaseClasses.ShadeRadiation intShaRad(
    thisSideHasShade=glaSys.haveInteriorShade,
    linearize=linearize,
    absIR_air=glaSys.shade.absIR_a,
    absIR_glass=glaSys.shade.absIR_b,
    tauIR_air=glaSys.shade.tauIR_a,
    tauIR_glass=glaSys.shade.tauIR_b,
    A=AGla) if
     glaSys.haveShade "Interior shade radiation model"
    annotation (Placement(transformation(extent={{240,106},{220,126}})));

  Buildings.HeatTransfer.Windows.BaseClasses.ShadingSignal shaSig(
    haveShade=glaSys.haveInteriorShade) "Conversion for shading signal"
    annotation (Placement(transformation(extent={{120,180},{140,160}})));

  Buildings.HeatTransfer.Windows.InteriorHeatTransferConvective intShaCon(
    A=A,
    fFra=fFra,
    til=Buildings.Types.Tilt.Wall,
    haveExteriorShade=glaSys.haveExteriorShade,
    haveInteriorShade=glaSys.haveInteriorShade)
    "Model for interior shade heat transfer"
    annotation (Placement(transformation(extent={{248,20},{228,40}})));
protected
  Modelica.Blocks.Math.Sum sumJ(nin=if glaSys.haveShade then 2 else 1)
    "Sum of radiosity fom glass to outside"
    annotation (Placement(transformation(extent={{260,60},{280,80}})));

  Buildings.HeatTransfer.Radiosity.RadiositySplitter radShaOut
    "Radiosity that strikes shading device"
    annotation (Placement(transformation(extent={{280,100},{260,120}})));

equation
  connect(uSha.y, extCon.uSha) annotation (Line(
      points={{-69,130},{20,130},{20,98},{39.2,98}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uSha.y, window.uSha) annotation (Line(
      points={{-69,130},{54,130},{54,106},{80,106}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOuts.port, extCon.air) annotation (Line(
      points={{5.55112e-16,50},{28,50},{28,90},{40,90}},
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
  connect(extCon.JOutUns, window.JInUns_a) annotation (Line(
      points={{61,98},{71.5,98},{71.5,102},{81,102}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(extCon.JInUns, window.JOutUns_a) annotation (Line(
      points={{61,96},{72,96},{72,98},{81,98}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(extCon.JOutSha, window.JInSha_a) annotation (Line(
      points={{61,84},{81,84}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(extCon.JInSha, window.JOutSha_a) annotation (Line(
      points={{61,82},{72,82},{72,80},{81,80}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(fixedHeatFlow.port, indRad.heatPort) annotation (Line(
      points={{312,78},{311.2,78},{311.2,100.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(winRad.QTraDif_flow, HRoo.u) annotation (Line(
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
      points={{20,-10},{20,86},{39,86}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.TDryBul, extCon.TOut) annotation (Line(
      points={{20,-10},{20,81.8},{39,81.8}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(uSha.y, shaSig.u) annotation (Line(
      points={{-69,130},{20,130},{20,170},{118,170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intShaRad.u, shaSig.y) annotation (Line(
      points={{241,124},{246,124},{246,170},{141,170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(indRad.JOut, radShaOut.JIn) annotation (Line(
      points={{301,114},{292,114},{292,116},{281,116}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radShaOut.JOut_1, intShaRad.JIn_air) annotation (Line(
      points={{259,116},{250,116},{250,112},{241,112}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(indRad.JIn, sumJ.y) annotation (Line(
      points={{301,106},{292,106},{292,70},{281,70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(sumJ.u[2], intShaRad.JOut_air) annotation (Line(
      points={{258,70},{250,70},{250,108},{241,108}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(window.JOutUns_b, sumJ.u[1]) annotation (Line(
      points={{123,102},{152,102},{152,134},{254,134},{254,70},{258,70}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(intShaRad.JOut_glass, window.JInSha_b) annotation (Line(
      points={{219,112},{172,112},{172,80},{123,80}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(window.JInUns_b, radShaOut.JOut_2) annotation (Line(
      points={{123,98},{154,98},{154,138},{256,138},{256,104},{259,104}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(radShaOut.u, shaSig.y) annotation (Line(
      points={{282,104},{286,104},{286,170},{141,170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intShaRad.JIn_glass, window.JOutSha_b) annotation (Line(
      points={{219,108},{174,108},{174,84},{123,84}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(TRAir.port, intShaCon.air) annotation (Line(
      points={{280,30},{248,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(uSha.y, intShaCon.uSha) annotation (Line(
      points={{-69,130},{-60,130},{-60,-28},{262,-28},{262,38},{248.8,38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intShaCon.TSha, intShaRad.TSha) annotation (Line(
      points={{238,19},{238,8},{220,8},{220,100},{225,100},{225,105}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(window.fra_b, intShaCon.frame) annotation (Line(
      points={{122.2,74},{152,74},{152,16},{231,16},{231,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(window.glaUns_b, intShaCon.glaUns) annotation (Line(
      points={{122,92},{160,92},{160,32},{228,32}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intShaCon.glaSha, window.glaSha_b) annotation (Line(
      points={{228,28},{156,28},{156,88},{122,88}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intShaCon.QRadAbs_flow, intShaRad.QRadAbs_flow) annotation (Line(
      points={{244,19},{244,6},{222,6},{222,94},{235,94},{235,105}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(winRad.QAbsIntSha_flow, intShaRad.QSolAbs_flow) annotation (Line(
      points={{121,-13},{216,-13},{216,98},{230,98},{230,105}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(winRad.QAbsExtSha_flow, extCon.QSolAbs_flow) annotation (Line(
      points={{121,-1},{128,-1},{128,56},{50,56},{50,79}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{340,200}}),
                         graphics),
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/Examples/Window.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
March 13, 2015, by Michael Wetter:<br/>
Changed model to avoid a translation error
in OpenModelica.
</li>
<li>
June 11, 2013, by Michael Wetter:<br/>
Redesigned model to separate convection from radiation, which is
required for the implementation of a CFD model.
</li>
<li>
May 1, 2013, by Michael Wetter:<br/>
Declared the parameter record to be a parameter, as declaring its elements
to be parameters does not imply that the whole record has the variability of a parameter.
</li>
</ul>
</html>", info="<html>
<p>
This model demonstrates the implementation of a window model.
On the left hand side is a model for the combined convective and radiative heat
transfer on the outside facing side of the window.
In the top middle is the window model, and below is a model that
computes the solar radiation balance of the window. Output of the solar
radiation balance model are the absorbed solar heat flow rates, which are
input to the heat balance models.
On the right hand side are models for the inside surface heat balance.
As opposed to the outside surface heat balance models, these models are
implemented using separate components for the radiative balance and for the convective
balance. This has been done to allow separating radiation from convection,
which is required when the room model is used with room air heat balance models
that use computational fluid dynamics.
</p>
</html>"));
end Window;
