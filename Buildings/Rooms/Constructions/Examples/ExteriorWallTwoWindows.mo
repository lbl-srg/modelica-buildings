within Buildings.Rooms.Constructions.Examples;
model ExteriorWallTwoWindows
  "Test model for an exterior wall with two windows, one having a shade, the other not"
  import Buildings;
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

  parameter Buildings.Rooms.BaseClasses.ParameterConstructionWithWindow conPar[nCon](
    redeclare
      Buildings.HeatTransfer.Data.OpaqueConstructions.Insulation100Concrete200
      layers,
    each til=Buildings.HeatTransfer.Types.Tilt.Wall,
    each azi=0.017453292519943,
    A=A,
    hWin=hWin,
    wWin=wWin,
    glaSys = {glaSys1, glaSys2}) "Construction parameters"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  ConstructionWithWindow conExt[nCon](
    layers=conPar[:].layers,
    glaSys=conPar[:].glaSys,
    linearizeRadiation = {linearizeRadiation, linearizeRadiation},
    A=conPar[:].A,
    AWin=conPar[:].hWin .* conPar[:].wWin,
    fFra=conPar[:].fFra,
    til=conPar[:].til) "Construction of an exterior wall with a window"
    annotation (Placement(transformation(extent={{60,-30},{0,30}})));

  Buildings.Rooms.BaseClasses.ExteriorBoundaryConditionsWithWindow
    bouConExt(
    nCon=2,
    linearizeRadiation = false,
    conMod=Buildings.HeatTransfer.Types.InteriorConvection.Fixed,
    lat=0.73268921998722,
    conPar=conPar)
    "Exterior boundary conditions for constructions with a window"
    annotation (Placement(transformation(extent={{82,-14},{122,26}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  Buildings.HeatTransfer.Convection.Interior con[nCon](A=A - AWin,
    til={Buildings.HeatTransfer.Types.Tilt.Wall,
         Buildings.HeatTransfer.Types.Tilt.Wall}) "Model for heat convection"
    annotation (Placement(transformation(extent={{-20,10},{-40,30}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theCol(m=2)
    "Thermal collector to link a vector of models to a single model"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-110,20})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  Modelica.Blocks.Sources.Constant TRoo(k=273.15 + 20) "Room air temperature"
    annotation (Placement(transformation(extent={{-190,10},{-170,30}})));
  HeatTransfer.Data.OpaqueConstructions.Insulation100Concrete200 extConMat
    "Record for material layers"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));

  HeatTransfer.Windows.InteriorHeatTransfer intCon[nCon](
    A=AWin,
    fFra=fFra,
    absIRSha_air={glaSys1.shade.absIR_a, glaSys2.shade.absIR_a},
    absIRSha_glass={glaSys1.shade.absIR_b, glaSys2.shade.absIR_b},
    tauIRSha_air={glaSys1.shade.tauIR_a, glaSys2.shade.tauIR_a},
    tauIRSha_glass={glaSys1.shade.tauIR_b, glaSys2.shade.tauIR_b},
    haveExteriorShade={glaSys1.haveExteriorShade, glaSys2.haveExteriorShade},
    haveInteriorShade={glaSys1.haveInteriorShade, glaSys2.haveInteriorShade},
    each linearizeRadiation = linearizeRadiation)
    "Model for interior convection"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Modelica.Blocks.Sources.Constant uSha(k=0) "Shading control signal"
    annotation (Placement(transformation(extent={{-192,-44},{-172,-24}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theCol1(m=2)
    "Thermal collector to link a vector of models to a single model"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-110,-20})));
  HeatTransfer.Radiosity.IndoorRadiosity indRad[nCon](each linearize = linearizeRadiation,
    A=AWin) "Model for indoor radiosity"
    annotation (Placement(transformation(extent={{-96,-80},{-76,-60}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theCol2(
                                                                   m=2)
    "Thermal collector to link a vector of models to a single model"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-22,-68})));
  Modelica.Blocks.Routing.Replicator replicator(nout=nCon)
    annotation (Placement(transformation(extent={{-160,-44},{-140,-24}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theCol3(
                                                                   m=2)
    "Thermal collector to link a vector of models to a single model"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-110,-80})));
  Modelica.Blocks.Sources.Constant QAbsSha[nCon](each k=0)
    "Solar radiation absorbed by interior shade"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.Constant QAbs[nCon,glaSys1.nLay](each k=0)
    "Solar radiation absorbed by glass"
    annotation (Placement(transformation(extent={{-6,-90},{14,-70}})));
  Modelica.Blocks.Sources.Constant QTra[nCon](each k=0)
    "Solar radiation absorbed by exterior shade"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.HeatTransfer.Convection.Interior con1[nCon](A=A - AWin,
     each til=Buildings.HeatTransfer.Types.Tilt.Wall)
    "Model for heat convection"
    annotation (Placement(transformation(extent={{-38,-130},{-58,-110}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theCol4(
                                                                   m=nCon)
    "Thermal collector to link a vector of models to a single model"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-88,-120})));

equation
  connect(prescribedTemperature.port, theCol.port_b) annotation (Line(
      points={{-140,20},{-130,20},{-130,20},{-120,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theCol.port_a, con.fluid) annotation (Line(
      points={{-100,20},{-70,20},{-70,20},{-40,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(weaDat.weaBus, bouConExt.weaBus) annotation (Line(
      points={{120,70},{140,70},{140,7.4},{116.867,7.4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(TRoo.y, prescribedTemperature.T) annotation (Line(
      points={{-169,20},{-162,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(theCol1.port_b, prescribedTemperature.port) annotation (Line(
      points={{-120,-20},{-130,-20},{-130,20},{-140,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theCol1.port_a, intCon.air) annotation (Line(
      points={{-100,-20},{-70,-20},{-70,-20},{-40,-20}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(intCon.frame, theCol2.port_a) annotation (Line(
      points={{-23,-30},{-22,-30},{-22,-58}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(uSha.y, replicator.u) annotation (Line(
      points={{-171,-34},{-162,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(replicator.y, intCon.uSha) annotation (Line(
      points={{-139,-34},{-52,-34},{-52,-12},{-40.8,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(indRad.JOut, intCon.JInRoo) annotation (Line(
      points={{-75,-66},{-50,-66},{-50,-28},{-40,-28}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(indRad.JIn, intCon.JOutRoo) annotation (Line(
      points={{-75,-74},{-46,-74},{-46,-24},{-40.4,-24}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(theCol3.port_a, indRad.heatPort) annotation (Line(
      points={{-100,-80},{-86.6,-80},{-86.6,-79.8},{-85.2,-79.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theCol2.port_b, prescribedTemperature.port) annotation (Line(
      points={{-22,-78},{-22,-96},{-130,-96},{-130,20},{-140,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theCol3.port_b, prescribedTemperature.port) annotation (Line(
      points={{-120,-80},{-130,-80},{-130,20},{-140,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(bouConExt.uSha, replicator.y) annotation (Line(
      points={{80.6667,12.6667},{-52,12.6667},{-52,-34},{-139,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QAbs.y, conExt.QAbsUns_flow) annotation (Line(
      points={{15,-80},{38,-80},{38,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QAbs.y, conExt.QAbsSha_flow) annotation (Line(
      points={{15,-80},{22,-80},{22,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QAbsSha.y, intCon.QAbs_flow) annotation (Line(
      points={{-59,-50},{-30,-50},{-30,-31}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QTra.y, bouConExt.QAbsSolSha_flow) annotation (Line(
      points={{41,50},{48,50},{48,10},{80.6667,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con.solid, conExt.opa_b) annotation (Line(
      points={{-20,20},{-10.1,20},{-10.1,20},{-0.2,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExt.JOutUns_b, intCon.JInUns) annotation (Line(
      points={{-1,2},{-14,2},{-14,-14},{-19,-14}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(intCon.JOutUns, conExt.JInUns_b) annotation (Line(
      points={{-19,-12},{-16,-12},{-16,-2},{-1,-2}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(conExt.glaUns_b, intCon.glaUns) annotation (Line(
      points={{-1.66533e-15,-8},{-12,-8},{-12,-18},{-20,-18}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExt.glaSha_b, intCon.glaSha) annotation (Line(
      points={{-1.66533e-15,-12},{-10,-12},{-10,-22},{-20,-22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExt.JOutSha_b, intCon.JInSha) annotation (Line(
      points={{-1,-16},{-6,-16},{-6,-28},{-19,-28}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(intCon.JOutSha, conExt.JInSha_b) annotation (Line(
      points={{-19,-26},{-8,-26},{-8,-20},{-1,-20}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(replicator.y, conExt.uSha) annotation (Line(
      points={{-139,-34},{-52,-34},{-52,-40},{66,-40},{66,6},{62,6}},
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
  connect(con1.solid, conExt.fra_b) annotation (Line(
      points={{-38,-120},{-12,-120},{-12,-60},{-0.2,-60},{-0.2,-26}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con1.fluid,theCol4. port_a) annotation (Line(
      points={{-58,-120},{-78,-120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theCol4.port_b, prescribedTemperature.port) annotation (Line(
      points={{-98,-120},{-130,-120},{-130,20},{-140,20}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    
experiment(StopTime=1209600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Rooms/Constructions/Examples/ExteriorWallTwoWindows.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-140},{200,
            100}})),
    Documentation(info="<html>
<p>
This model tests the exterior construction with two windows.
</p>
</html>", revisions="<html>
<ul>
<li>
March 7, 2012, by Michael Wetter:<br>
Updated example to use new data model 
<a href=\"modelica://Buildings.Rooms.BaseClasses.ParameterConstructionWithWindow\">
Buildings.Rooms.BaseClasses.ParameterConstructionWithWindow</a>
in model for boundary conditions.
</li>
<li>
December 6, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end ExteriorWallTwoWindows;
