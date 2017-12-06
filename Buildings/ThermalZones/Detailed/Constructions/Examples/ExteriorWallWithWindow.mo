within Buildings.ThermalZones.Detailed.Constructions.Examples;
model ExteriorWallWithWindow "Test model for an exterior wall with a window"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Area A=3*10
    "Heat transfer area of wall and window";
  parameter Modelica.SIunits.Length hWin = 2 "Window height";
  parameter Modelica.SIunits.Length wWin = 3 "Window width";
  parameter Modelica.SIunits.Area AWin=hWin*wWin
    "Heat transfer area of frame and window";
  parameter Real fFra=0.1
    "Fraction of window frame divided by total window area";
  parameter Boolean linearizeRadiation = false
    "Set to true to linearize emissive power";
  parameter HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(
    UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveExteriorShade=false,
    haveInteriorShade=false) "Record for glazing system"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));

  parameter HeatTransfer.Data.OpaqueConstructions.Insulation100Concrete200 extConMat
    "Record for material layers"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));

  parameter Buildings.ThermalZones.Detailed.BaseClasses.ParameterConstructionWithWindow conPar(
    til=Buildings.Types.Tilt.Wall,
    azi=0,
    layers=extConMat,
    glaSys=glaSys,
    A=A,
    hWin=hWin,
    wWin=wWin) "Data for construction with window"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  ConstructionWithWindow conExt[1](
    layers={conPar.layers},
    glaSys={conPar.glaSys},
    linearizeRadiation = {linearizeRadiation},
    A={conPar.A},
    AWin={conPar.hWin * conPar.wWin},
    fFra={conPar.fFra},
    til={conPar.til}) "Construction of an exterior wall with a window"
    annotation (Placement(transformation(extent={{60,-30},{0,30}})));
  Buildings.ThermalZones.Detailed.BaseClasses.ExteriorBoundaryConditionsWithWindow
    bouConExt(
    nCon=1,
    linearizeRadiation = linearizeRadiation,
    conMod=Buildings.HeatTransfer.Types.ExteriorConvection.Fixed,
    lat=0.73268921998722,
    conPar={conPar})
    "Exterior boundary conditions for constructions with a window"
    annotation (Placement(transformation(extent={{94,-14},{134,26}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TRoo(T=293.15)
    "Room temperature"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  Buildings.HeatTransfer.Convection.Interior con[1](
      each A=A .- AWin,
      til={Buildings.Types.Tilt.Wall}) "Model for heat convection"
    annotation (Placement(transformation(extent={{-20,20},{-40,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theCol(m=1)
    "Thermal collector to link a vector of models to a single model"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,30})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{180,0},{160,20}})));

  Modelica.Blocks.Sources.Constant uSha(k=0) "Shading control signal"
    annotation (Placement(transformation(extent={{-180,-60},{-160,-40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theCol1(m=1)
    "Thermal collector to link a vector of models to a single model"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-74,-130})));
  HeatTransfer.Radiosity.IndoorRadiosity indRad(A=AWin, linearize=
        linearizeRadiation) "Model for indoor radiosity"
    annotation (Placement(transformation(extent={{-122,-100},{-102,-80}})));
  Modelica.Blocks.Sources.Constant QAbs[1,size(glaSys.glass, 1)](each k=0)
    "Solar radiation absorbed by glass"
    annotation (Placement(transformation(extent={{-180,-180},{-160,-160}})));
  Modelica.Blocks.Sources.Constant QAbsSha(k=0)
    "Solar radiation absorbed by interior shade"
    annotation (Placement(transformation(extent={{-180,-120},{-160,-100}})));
  Modelica.Blocks.Sources.Constant QTra(k=0)
    "Solar radiation absorbed by exterior shade"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));

  Buildings.HeatTransfer.Windows.InteriorHeatTransferConvective intShaCon[1](
    each A=A,
    each fFra=fFra,
    each til=conPar.til,
    each haveExteriorShade=glaSys.haveExteriorShade,
    each haveInteriorShade=glaSys.haveInteriorShade)
    "Model for interior shade heat transfer"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));

  Buildings.HeatTransfer.Windows.BaseClasses.ShadeRadiation intShaRad[1](
    each thisSideHasShade=glaSys.haveInteriorShade,
    each linearize=linearize,
    each absIR_air=glaSys.shade.absIR_a,
    each absIR_glass=glaSys.shade.absIR_b,
    each tauIR_air=glaSys.shade.tauIR_a,
    each tauIR_glass=glaSys.shade.tauIR_b,
    each A=AGla) if
     glaSys.haveShade "Interior shade radiation model"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
protected
  Modelica.Blocks.Math.Sum sumJ[1](each nin=if glaSys.haveShade then 2 else 1)
    "Sum of radiosity fom glass to outside"
    annotation (Placement(transformation(extent={{-72,-80},{-92,-60}})));

  Buildings.HeatTransfer.Radiosity.RadiositySplitter radShaOut[1]
    "Radiosity that strikes shading device"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
equation
  connect(TRoo.port, theCol.port_b)                  annotation (Line(
      points={{-140,30},{-80,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theCol.port_a, con.fluid) annotation (Line(
      points={{-60,30},{-50,30},{-50,30},{-40,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(weaDat.weaBus, bouConExt.weaBus) annotation (Line(
      points={{160,10},{140,10},{140,7.4},{128.867,7.4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(theCol1.port_b, TRoo.port)                  annotation (Line(
      points={{-84,-130},{-128,-130},{-128,30},{-140,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(indRad.heatPort, TRoo.port)                  annotation (Line(
      points={{-111.2,-99.8},{-128,-99.8},{-128,30},{-140,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(uSha.y, bouConExt.uSha[1]) annotation (Line(
      points={{-159,-50},{-140,-50},{-140,6},{54,6},{54,12},{64,12},{64,12.6667},
          {92.6667,12.6667}},
      color={0,0,127},
      smooth=Smooth.None));

  if glaSys.haveShade then
    connect(uSha.y, conExt[1].uSha) annotation (Line(
      points={{-159,-50},{-140,-50},{-140,6},{54,6},{54,12},{66,12},{66,6},{62,6}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(QAbs.y, conExt.QAbsSha_flow) annotation (Line(
      points={{-159,-170},{22,-170},{22,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intShaCon.glaSha, conExt.glaSha_b) annotation (Line(
      points={{-20,-132},{-6,-132},{-6,-12},{0,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intShaCon[1].uSha, uSha.y) annotation (Line(
      points={{-40.8,-122},{-140,-122},{-140,-50},{-159,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  connect(QAbs.y, conExt.QAbsUns_flow) annotation (Line(
      points={{-159,-170},{38,-170},{38,-32}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(QTra.y, bouConExt.QAbsSolSha_flow[1]) annotation (Line(
      points={{81,50},{88,50},{88,10},{92.6667,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conExt.opa_b, con.solid) annotation (Line(
      points={{-0.2,20},{-10,20},{-10,30},{-20,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExt.opa_a, bouConExt.opa_a) annotation (Line(
      points={{60,20},{65.5,20},{65.5,19.3333},{94,19.3333}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(conExt.JInUns_a, bouConExt.JOutUns) annotation (Line(
      points={{61,2},{66,2},{66,4.66667},{93.3333,4.66667}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(conExt.JOutUns_a, bouConExt.JInUns) annotation (Line(
      points={{61,-2},{68,-2},{68,7.33333},{93.3333,7.33333}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(conExt.glaUns_a, bouConExt.glaUns) annotation (Line(
      points={{60,-8},{70,-8},{70,0.666667},{94,0.666667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExt.glaSha_a, bouConExt.glaSha) annotation (Line(
      points={{60,-12},{72,-12},{72,-2},{94,-2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExt.JInSha_a, bouConExt.JOutSha) annotation (Line(
      points={{61,-16},{74,-16},{74,-7.33333},{93.3333,-7.33333}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(conExt.JOutSha_a, bouConExt.JInSha) annotation (Line(
      points={{61,-20},{76,-20},{76,-4.66667},{93.3333,-4.66667}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(conExt.fra_a, bouConExt.fra) annotation (Line(
      points={{60,-26},{78,-26},{78,-11.3333},{94,-11.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intShaCon.QRadAbs_flow,intShaRad. QRadAbs_flow) annotation (Line(
      points={{-36,-141},{-36,-146},{-50,-146},{-50,-98},{-35,-98},{-35,-61}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intShaCon.TSha,intShaRad. TSha) annotation (Line(
      points={{-30,-141},{-30,-148},{-46,-148},{-46,-100},{-25,-100},{-25,-61}},
      color={0,0,127},
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
  connect(theCol1.port_a, intShaCon.air) annotation (Line(
      points={{-64,-130},{-40,-130}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(uSha.y, intShaRad[1].u) annotation (Line(
      points={{-159,-50},{-60,-50},{-60,-42},{-41,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conExt.JOutUns_b, sumJ.u[1]) annotation (Line(
      points={{-1,2},{-54,2},{-54,-70},{-70,-70}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(intShaRad.JOut_air, sumJ.u[2]) annotation (Line(
      points={{-41,-58},{-54,-58},{-54,-70},{-70,-70}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radShaOut[1].u, uSha.y) annotation (Line(
      points={{-82,-36},{-92,-36},{-92,-50},{-159,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radShaOut.JOut_1, intShaRad.JIn_air) annotation (Line(
      points={{-59,-24},{-50,-24},{-50,-54},{-41,-54}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radShaOut.JOut_2, conExt.JInUns_b) annotation (Line(
      points={{-59,-36},{-40,-36},{-40,-2},{-1,-2}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(QAbsSha.y, intShaRad[1].QSolAbs_flow) annotation (Line(
      points={{-159,-110},{-30,-110},{-30,-61}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(indRad.JOut, radShaOut[1].JIn) annotation (Line(
      points={{-101,-86},{-98,-86},{-98,-24},{-81,-24}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(indRad.JIn, sumJ[1].y) annotation (Line(
      points={{-101,-94},{-96,-94},{-96,-70},{-93,-70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(conExt.fra_b, intShaCon.frame) annotation (Line(
      points={{-0.2,-26},{-4,-26},{-4,-146},{-22,-146},{-22,-140},{-23,-140}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
experiment(Tolerance=1e-6, StopTime=1209600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Constructions/Examples/ExteriorWallWithWindow.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-200,-220},{200,
            100}}), graphics),
    Documentation(info="<html>
<p>
This model tests the exterior constructions with windows.
</p>
</html>", revisions="<html>
<ul>
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
May 1, 2013, by Michael Wetter:<br/>
Declared the parameter record to be a parameter, as declaring its elements
to be parameters does not imply that the whole record has the variability of a parameter.
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
end ExteriorWallWithWindow;
