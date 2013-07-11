within Buildings.HeatTransfer.Windows.Examples;
model Window "Test model for the window"
  import Buildings;
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
  Modelica.Blocks.Sources.Constant TRooAir(k=293.15, y(unit="K"))
    "Room air temperature"
    annotation (Placement(transformation(extent={{320,-10},{300,10}})));
  Modelica.Blocks.Sources.Ramp uSha(duration=0.5, startTime=0.25)
    "Shading control signal"
    annotation (Placement(transformation(extent={{-90,120},{-70,140}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TOuts
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TRAir
    "Room air temperature"
    annotation (Placement(transformation(extent={{288,-10},{268,10}})));
  Buildings.HeatTransfer.Radiosity.IndoorRadiosity indRad(A=A)
    "Model for indoor radiosity"
    annotation (Placement(transformation(extent={{322,100},{302,120}})));
  Buildings.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow=0)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={312,68})));
  parameter Buildings.HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(
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
  Buildings.HeatTransfer.Windows.BaseClasses.InteriorConvectionCoefficient
    conCoeGla(                                          final A=AGla)
    "Model for the inside convective heat transfer coefficient of the glass"
    annotation (Placement(transformation(extent={{150,30},{170,50}})));
  Buildings.HeatTransfer.Windows.BaseClasses.InteriorConvectionCoefficient
    conCoeFra(                                          final A=AFra)
    "Model for the inside convective heat transfer coefficient of the frame"
    annotation (Placement(transformation(extent={{150,-4},{170,16}})));
protected
  Modelica.Blocks.Math.Sum sumJ(nin=if glaSys.haveInteriorShade then 2 else 1)
    "Sum of radiosity fom glass to outside"
    annotation (Placement(transformation(extent={{260,60},{280,80}})));
public
  Buildings.HeatTransfer.Windows.BaseClasses.ShadeConvection intShaCon(
      thisSideHasShade=glaSys.haveInteriorShade, A=AGla) if
         glaSys.haveInteriorShade "Interior shade convection model"
    annotation (Placement(transformation(extent={{240,60},{220,80}})));
  Buildings.HeatTransfer.Windows.BaseClasses.ShadeRadiation intShaRad(
    thisSideHasShade=glaSys.haveInteriorShade,
    linearize=linearize,
    absIR_air=glaSys.shade.absIR_a,
    absIR_glass=glaSys.shade.absIR_b,
    tauIR_air=glaSys.shade.tauIR_a,
    tauIR_glass=glaSys.shade.tauIR_b,
    A=AGla) if
     glaSys.haveInteriorShade "Interior shade radiation model"
    annotation (Placement(transformation(extent={{240,106},{220,126}})));
public
  Buildings.HeatTransfer.Windows.BaseClasses.ShadingSignal
                shaSig(haveShade=glaSys.haveInteriorShade)
    "Conversion for shading signal"
    annotation (Placement(transformation(extent={{120,180},{140,160}})));
protected
  Buildings.HeatTransfer.Radiosity.RadiositySplitter
                              radShaOut "Radiosity that strikes shading device"
    annotation (Placement(transformation(extent={{280,100},{260,120}})));
public
  Modelica.Thermal.HeatTransfer.Components.Convection conFra
    "Convective heat transfer between air and frame"
    annotation (Placement(transformation(extent={{218,-20},{238,0}})));
  Modelica.Thermal.HeatTransfer.Components.Convection conWinUns
    "Convective heat transfer between air and unshaded part of glass"
    annotation (Placement(transformation(extent={{218,14},{238,34}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{192,30},{212,50}})));
  Modelica.Blocks.Math.Product product2
    annotation (Placement(transformation(extent={{190,80},{210,100}})));
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
  connect(TRooAir.y, TRAir.T) annotation (Line(
      points={{299,4.44089e-16},{298,4.44089e-16},{298,0},{294,0},{294,
          8.88178e-16},{290,8.88178e-16}},
      color={0,0,127},
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
  connect(fixedHeatFlow.port, indRad.heatPort) annotation (Line(
      points={{312,78},{311.2,78},{311.2,100.2}},
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
  connect(shaSig.y, intShaCon.u) annotation (Line(
      points={{141,170},{246,170},{246,78},{241,78}},
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
      pattern=LinePattern.None,
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
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(window.glaSha_b, intShaCon.glass) annotation (Line(
      points={{122,88},{144,88},{144,70},{220.6,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intShaCon.air, TRAir.port) annotation (Line(
      points={{240,70},{248,70},{248,4.44089e-16},{268,4.44089e-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conFra.fluid, TRAir.port) annotation (Line(
      points={{238,-10},{248,-10},{248,4.44089e-16},{268,4.44089e-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conFra.solid, window.fra_b) annotation (Line(
      points={{218,-10},{142,-10},{142,74},{122.2,74}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conCoeFra.GCon, conFra.Gc) annotation (Line(
      points={{171,6},{228,6},{228,4.44089e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoeGla.GCon, product1.u2) annotation (Line(
      points={{171,40},{184,40},{184,34},{190,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product1.u1, shaSig.yCom) annotation (Line(
      points={{190,46},{180,46},{180,176},{141,176}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product1.y, conWinUns.Gc)
                                 annotation (Line(
      points={{213,40},{228,40},{228,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conWinUns.fluid, TRAir.port)
                                    annotation (Line(
      points={{238,24},{248,24},{248,0},{248,0},{248,0},{248,4.44089e-16},{258,
          4.44089e-16},{268,4.44089e-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conWinUns.solid, window.glaUns_b)
                                         annotation (Line(
      points={{218,24},{146,24},{146,92},{122,92}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conCoeGla.GCon,product2. u2) annotation (Line(
      points={{171,40},{184,40},{184,84},{188,84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product2.y, intShaCon.Gc) annotation (Line(
      points={{211,90},{244,90},{244,74},{241,74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(winRad.QAbsIntSha_flow, intShaRad.QAbs_flow) annotation (Line(
      points={{121,-13},{214,-13},{214,94},{230,94},{230,105}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intShaRad.QRadAbs_flow, intShaCon.QRadAbs_flow) annotation (Line(
      points={{235,105},{235,86},{218,86},{218,54},{236,54},{236,59}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intShaRad.TSha, intShaCon.TSha) annotation (Line(
      points={{225,105},{225,96},{216,96},{216,56},{224,56},{224,59}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radShaOut.u, shaSig.y) annotation (Line(
      points={{282,104},{286,104},{286,170},{141,170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intShaRad.JIn_glass, window.JOutSha_b) annotation (Line(
      points={{219,108},{174,108},{174,84},{123,84}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(product2.u1, shaSig.y) annotation (Line(
      points={{188,96},{186,96},{186,170},{141,170}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {340,200}})),
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/Examples/Window.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
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
