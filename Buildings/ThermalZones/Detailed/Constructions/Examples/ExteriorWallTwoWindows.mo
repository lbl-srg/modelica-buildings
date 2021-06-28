within Buildings.ThermalZones.Detailed.Constructions.Examples;
model ExteriorWallTwoWindows
  "Test model for an exterior wall with two windows, one having a shade, the other not"
  extends Modelica.Icons.Example;
  parameter Integer nCon = 2 "Number of constructions";
  parameter Modelica.SIunits.Area A[:]={3*10, 3*10}
    "Heat transfer area of wall and window";
  parameter Modelica.SIunits.Length hWin[:] = {2, 1} "Window height";
  parameter Modelica.SIunits.Length wWin[:] = {3, 3} "Window width";
  parameter Modelica.SIunits.Area AWin[:]= hWin .* wWin
    "Heat transfer area of frame and window";
  parameter Real fFra[:]={0.1, 0.1}
    "Fraction of window frame divided by total window area";
  final parameter Modelica.SIunits.Area AFra[:]= fFra .* AWin "Frame area";
  final parameter Modelica.SIunits.Area AGla[:] = AWin .- AFra "Glass area";

  parameter Boolean linearizeRadiation = false
    "Set to true to linearize emissive power";
  parameter HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys1(
    UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveInteriorShade=false,
    haveExteriorShade=false) "Record for glazing system"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  parameter HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys2(
    UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveInteriorShade=false,
    haveExteriorShade=false) "Record for glazing system"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  parameter Buildings.ThermalZones.Detailed.BaseClasses.ParameterConstructionWithWindow conPar[nCon](
    each layers = extConMat,
    each til=Buildings.Types.Tilt.Wall,
    each azi=0.017453292519943,
    A=A,
    hWin=hWin,
    wWin=wWin,
    glaSys = {glaSys1, glaSys2}) "Construction parameters"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  parameter HeatTransfer.Data.OpaqueConstructions.Insulation100Concrete200 extConMat
    "Record for material layers"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));

  ConstructionWithWindow conExt[nCon](
    layers=conPar.layers,
    glaSys=conPar[:].glaSys,
    linearizeRadiation = {linearizeRadiation, linearizeRadiation},
    A=conPar[:].A,
    AWin=conPar[:].hWin .* conPar[:].wWin,
    fFra=conPar[:].fFra,
    til=conPar[:].til) "Construction of an exterior wall with a window"
    annotation (Placement(transformation(extent={{60,-30},{0,30}})));

  Buildings.ThermalZones.Detailed.BaseClasses.ExteriorBoundaryConditionsWithWindow
    bouConExt(
    nCon=2,
    linearizeRadiation = false,
    conMod=Buildings.HeatTransfer.Types.ExteriorConvection.Fixed,
    lat=0.73268921998722,
    conPar=conPar)
    "Exterior boundary conditions for constructions with a window"
    annotation (Placement(transformation(extent={{82,-14},{122,26}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TRoo(T=293.15)
    "Room temperature"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  Buildings.HeatTransfer.Convection.Interior con[nCon](A=A - AWin,
    til={Buildings.Types.Tilt.Wall,
         Buildings.Types.Tilt.Wall}) "Model for heat convection"
    annotation (Placement(transformation(extent={{-40,10},{-60,30}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theCol(m=2)
    "Thermal collector to link a vector of models to a single model"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-110,20})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{100,60},{120,80}})));

  Modelica.Blocks.Sources.Constant uSha(k=0) "Shading control signal"
    annotation (Placement(transformation(extent={{-190,-42},{-170,-22}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theCol1(m=2)
    "Thermal collector to link a vector of models to a single model"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-112,-160})));
  HeatTransfer.Radiosity.IndoorRadiosity indRad[nCon](
    each linearize = linearizeRadiation,
    A=AWin) "Model for indoor radiosity"
    annotation (Placement(transformation(extent={{-122,-58},{-102,-38}})));
  Modelica.Blocks.Routing.Replicator replicator(nout=nCon)
    annotation (Placement(transformation(extent={{-160,-42},{-140,-22}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theCol3(m=2)
    "Thermal collector to link a vector of models to a single model"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-112,-110})));
  Modelica.Blocks.Sources.Constant QAbsSha[nCon](each k=0)
    "Solar radiation absorbed by interior shade"
    annotation (Placement(transformation(extent={{-90,-120},{-70,-100}})));
  Modelica.Blocks.Sources.Constant QAbs[nCon, size(glaSys1.glass, 1)](each k=0)
    "Solar radiation absorbed by glass"
    annotation (Placement(transformation(extent={{-20,-180},{0,-160}})));
  Modelica.Blocks.Sources.Constant QTra[nCon](each k=0)
    "Solar radiation absorbed by exterior shade"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Buildings.HeatTransfer.Windows.BaseClasses.ShadeRadiation intShaRad[nCon](
    thisSideHasShade={glaSys1.haveInteriorShade, glaSys2.haveInteriorShade},
    each linearize=linearizeRadiation,
    absIR_air={glaSys1.shade.absIR_a, glaSys2.shade.absIR_a},
    absIR_glass={glaSys1.shade.absIR_b, glaSys2.shade.absIR_b},
    tauIR_air={glaSys1.shade.tauIR_a, glaSys2.shade.tauIR_a},
    tauIR_glass={glaSys1.shade.tauIR_b, glaSys2.shade.tauIR_b},
    A=AGla) if
     glaSys1.haveShade or glaSys2.haveShade "Interior shade radiation model"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.HeatTransfer.Windows.InteriorHeatTransferConvective intShaCon[nCon](
    A=A,
    fFra=fFra,
    til=conPar[:].til,
    haveExteriorShade={glaSys1.haveExteriorShade, glaSys2.haveExteriorShade},
    haveInteriorShade={glaSys1.haveInteriorShade, glaSys2.haveInteriorShade})
    "Model for interior shade heat transfer"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
protected
  Modelica.Blocks.Math.Sum sumJ[nCon](each nin=if glaSys1.haveShade or glaSys2.haveShade
         then 2 else 1) "Sum of radiosity fom glass to outside"
    annotation (Placement(transformation(extent={{-68,-80},{-88,-60}})));
  Buildings.HeatTransfer.Radiosity.RadiositySplitter radShaOut[nCon]
    "Radiosity that strikes shading device"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
equation
  connect(TRoo.port, theCol.port_b)                  annotation (Line(
      points={{-140,20},{-120,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theCol.port_a, con.fluid) annotation (Line(
      points={{-100,20},{-60,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(weaDat.weaBus, bouConExt.weaBus) annotation (Line(
      points={{120,70},{140,70},{140,7.4},{116.867,7.4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(theCol1.port_b, TRoo.port)                  annotation (Line(
      points={{-122,-160},{-130,-160},{-130,20},{-140,20}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(uSha.y, replicator.u) annotation (Line(
      points={{-169,-32},{-162,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(theCol3.port_b, TRoo.port)                  annotation (Line(
      points={{-122,-110},{-130,-110},{-130,20},{-140,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(bouConExt.uSha, replicator.y) annotation (Line(
      points={{80.6667,12.6667},{66,12.6667},{66,40},{-20,40},{-20,-32},{-139,
          -32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QAbs.y, conExt.QAbsUns_flow) annotation (Line(
      points={{1,-170},{38,-170},{38,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QAbs.y, conExt.QAbsSha_flow) annotation (Line(
      points={{1,-170},{22,-170},{22,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QTra.y, bouConExt.QAbsSolSha_flow) annotation (Line(
      points={{41,70},{48,70},{48,10},{80.6667,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con.solid, conExt.opa_b) annotation (Line(
      points={{-40,20},{-0.2,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(replicator.y, conExt.uSha) annotation (Line(
      points={{-139,-32},{-20,-32},{-20,40},{66,40},{66,6},{62,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conExt.opa_a, bouConExt.opa_a) annotation (Line(
      points={{60,20},{65.5,20},{65.5,19.3333},{82,19.3333}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(bouConExt.JOutUns, conExt.JInUns_a) annotation (Line(
      points={{81.3333,4.66667},{70,4.66667},{70,2},{61,2}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(conExt.JOutUns_a, bouConExt.JInUns) annotation (Line(
      points={{61,-2},{68,-2},{68,6},{74,6},{74,7.33333},{81.3333,7.33333}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(bouConExt.glaUns, conExt.glaUns_a) annotation (Line(
      points={{82,0.666667},{70,0.666667},{70,-8},{60,-8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(bouConExt.glaSha, conExt.glaSha_a) annotation (Line(
      points={{82,-2},{72,-2},{72,-12},{60,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(bouConExt.JOutSha, conExt.JInSha_a) annotation (Line(
      points={{81.3333,-7.33333},{74,-7.33333},{74,-16},{61,-16}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(conExt.JOutSha_a, bouConExt.JInSha) annotation (Line(
      points={{61,-20},{76,-20},{76,-4.66667},{81.3333,-4.66667}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(bouConExt.fra, conExt.fra_a) annotation (Line(
      points={{82,-11.3333},{78,-11.3333},{78,-26},{60,-26}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intShaCon.TSha,intShaRad. TSha) annotation (Line(
      points={{-30,-141},{-30,-148},{-46,-148},{-46,-100},{-25,-100},{-25,-61}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QAbsSha.y,intShaRad [1].QSolAbs_flow) annotation (Line(
      points={{-69,-110},{-30,-110},{-30,-61}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intShaCon.QRadAbs_flow,intShaRad. QRadAbs_flow) annotation (Line(
      points={{-36,-141},{-36,-146},{-50,-146},{-50,-98},{-35,-98},{-35,-61}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(theCol1.port_a,intShaCon. air) annotation (Line(
      points={{-102,-160},{-80,-160},{-80,-130},{-40,-130}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intShaRad.JOut_air,sumJ. u[2]) annotation (Line(
      points={{-41,-58},{-54,-58},{-54,-70},{-66,-70}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radShaOut.JOut_1,intShaRad. JIn_air) annotation (Line(
      points={{-59,-14},{-50,-14},{-50,-54},{-41,-54}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radShaOut.JOut_2, conExt.JInUns_b) annotation (Line(
      points={{-59,-26},{-40,-26},{-40,-2},{-1,-2}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(conExt.JOutUns_b,sumJ. u[1]) annotation (Line(
      points={{-1,2},{-54,2},{-54,-70},{-66,-70}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(intShaRad.JOut_glass, conExt.JInSha_b) annotation (Line(
      points={{-19,-54},{-12,-54},{-12,-20},{-1,-20}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(intShaRad.JIn_glass, conExt.JOutSha_b) annotation (Line(
      points={{-19,-58},{-10,-58},{-10,-16},{-1,-16}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(conExt.glaUns_b, intShaCon.glaUns) annotation (Line(
      points={{0,-8},{-8,-8},{-8,-128},{-20,-128}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intShaCon.glaSha, conExt.glaSha_b) annotation (Line(
      points={{-20,-132},{-6,-132},{-6,-12},{-1.77636e-15,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExt.fra_b, intShaCon.frame) annotation (Line(
      points={{-0.2,-26},{-4,-26},{-4,-146},{-23,-146},{-23,-140}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sumJ.y, indRad.JIn) annotation (Line(
      points={{-89,-70},{-96,-70},{-96,-52},{-101,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(theCol3.port_a, indRad.heatPort) annotation (Line(
      points={{-102,-110},{-98,-110},{-98,-84},{-111.2,-84},{-111.2,-57.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(replicator.y, radShaOut.u) annotation (Line(
      points={{-139,-32},{-92,-32},{-92,-26},{-82,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(indRad.JOut, radShaOut.JIn) annotation (Line(
      points={{-101,-44},{-98,-44},{-98,-14},{-81,-14}},
      color={0,127,0},
      smooth=Smooth.None));
  annotation (
experiment(Tolerance=1e-6, StopTime=1209600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Constructions/Examples/ExteriorWallTwoWindows.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-200,-200},{200,
            100}}), graphics),
    Documentation(info="<html>
<p>
This model tests the exterior construction with two windows.
</p>
</html>", revisions="<html>
<ul>
<li>
February 18, 2020, by Michael Wetter:<br/>
Corrected wrong parameter assignment.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1766\">#1766</a>.
</li>
<li>
November 17, 2016, by Thierry S. Nouidui:<br/>
Removed <code>[:]</code> in <code>conPar.layers</code>
to avoid translation error in Dymola 2107.
This is a work-around for a bug in Dymola
which will be addressed in future releases.
</li>
<li>
March 13, 2015, by Michael Wetter:<br/>
Changed model for OpenModelica.
</li>
<li>
April 29, 2013, by Michael Wetter:<br/>
Corrected wrong assignment of parameter in instance <code>bouConExt(conMod=...)</code>
which was set to an interior instead of an exterior convection model.
</li>
<li>
June 12, 2013, by Michael Wetter:<br/>
Redesigned model to separate convection from radiation, which is
required for the implementation of a CFD model.
Corrected wrong connection to frame heat transfer. The previous implementation accounted
twice for the convective resistance of the frame on the room-side.
</li>
<li>
March 7, 2012, by Michael Wetter:<br/>
Updated example to use new data model
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.ParameterConstructionWithWindow\">
Buildings.ThermalZones.Detailed.BaseClasses.ParameterConstructionWithWindow</a>
in model for boundary conditions.
</li>
<li>
December 6, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ExteriorWallTwoWindows;
