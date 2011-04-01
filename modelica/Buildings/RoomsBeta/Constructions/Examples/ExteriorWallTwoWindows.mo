within Buildings.RoomsBeta.Constructions.Examples;
model ExteriorWallTwoWindows
  "Test model for an exterior wall with two windows, one having a shade, the other not"
  import Buildings;
  extends Modelica.Icons.Example;
  parameter Integer nCon = 2 "Number of constructions";
  parameter Modelica.SIunits.Area A[:]={3*10, 3*10}
    "Heat transfer area of wall and window";
  parameter Modelica.SIunits.Area AWin[:]=A-{2*3, 1*3}
    "Heat transfer area of frame and window";
  parameter Real fFra[:]={0.1, 0.1}
    "Fraction of window frame divided by total window area";
  parameter Boolean linearizeRadiation = false
    "Set to true to linearize emissive power";
  HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys1(
    UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveInteriorShade=false,
    haveExteriorShade=false) "Record for glazing system"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys2(
    UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveInteriorShade=false,
    haveExteriorShade=false) "Record for glazing system"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  ConstructionWithWindow conExt[nCon](
    layers={extConMat, extConMat},
    glaSys={glaSys1, glaSys2},
    linearizeRadiation = {linearizeRadiation, linearizeRadiation},
    A=A,
    AWin=AWin,
    fFra=fFra,
    til={Buildings.RoomsBeta.Types.Tilt.Wall,Buildings.RoomsBeta.Types.Tilt.Wall})
    "Construction of an exterior wall without a window"
    annotation (Placement(transformation(extent={{0,-30},{60,30}})));
  Buildings.RoomsBeta.BaseClasses.ExteriorBoundaryConditionsWithWindow
    bouConExt(
    nCon=2,
    linearizeRadiation = false,
    fFra=fFra,
    epsLW={extConMat.epsLW_a, extConMat.epsLW_a},
    AOpa=A - AWin,
    epsSW={extConMat.epsSW_a, extConMat.epsSW_a},
    AWin=AWin,
    epsSWFra={glaSys1.epsSWFra, glaSys2.epsSWFra},
    epsLWSha_air={glaSys1.shade.epsLW_a, glaSys2.shade.epsLW_a},
    epsLWSha_glass={glaSys1.shade.epsLW_b, glaSys2.shade.epsLW_b},
    tauLWSha_air={glaSys1.shade.tauLW_a, glaSys2.shade.tauLW_a},
    tauLWSha_glass={glaSys1.shade.tauLW_b, glaSys2.shade.tauLW_b},
    haveExteriorShade={glaSys1.haveExteriorShade, glaSys2.haveExteriorShade},
    haveInteriorShade={glaSys1.haveInteriorShade, glaSys2.haveInteriorShade},
    lat=0.73268921998722,
    conMod=Buildings.RoomsBeta.Types.InteriorConvection.Fixed,
    til={Buildings.RoomsBeta.Types.Tilt.Wall,Buildings.RoomsBeta.Types.Tilt.Wall},
    azi={0,0})
    "Exterior boundary conditions for constructions without a window"
    annotation (Placement(transformation(extent={{82,-14},{122,26}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  Buildings.HeatTransfer.InteriorConvection con[
                              nCon](A=A - AWin,
    til={Buildings.RoomsBeta.Types.Tilt.Wall,
         Buildings.RoomsBeta.Types.Tilt.Wall}) "Model for heat convection"
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

  HeatTransfer.WindowsBeta.InteriorHeatTransfer intCon[nCon](
    A=AWin,
    fFra=fFra,
    epsLWSha_air={glaSys1.shade.epsLW_a, glaSys2.shade.epsLW_a},
    epsLWSha_glass={glaSys1.shade.epsLW_b, glaSys2.shade.epsLW_b},
    tauLWSha_air={glaSys1.shade.tauLW_a, glaSys2.shade.tauLW_a},
    tauLWSha_glass={glaSys1.shade.tauLW_b, glaSys2.shade.tauLW_b},
    haveExteriorShade={glaSys1.haveExteriorShade, glaSys2.haveExteriorShade},
    haveInteriorShade={glaSys1.haveInteriorShade, glaSys2.haveInteriorShade},
    each linearizeRadiation = linearizeRadiation)
    "Model for interior convection"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Modelica.Blocks.Sources.Constant uSha(k=0) "Shading control signal"
    annotation (Placement(transformation(extent={{-190,-50},{-170,-30}})));
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
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
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
equation
  connect(prescribedTemperature.port, theCol.port_b) annotation (Line(
      points={{-140,20},{-130,20},{-130,20},{-120,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theCol.port_a, con.fluid) annotation (Line(
      points={{-100,20},{-70,20},{-70,20},{-40,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con.solid, conExt.opa_a) annotation (Line(
      points={{-20,20},{-10,20},{-10,20},{-1.66533e-15,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExt.opa_b, bouConExt.opa_a) annotation (Line(
      points={{60.2,20},{72,20},{72,19.3333},{82,19.3333}},
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
  connect(intCon.glaUns, conExt.glaUns_a) annotation (Line(
      points={{-20,-18},{-12,-18},{-12,-8},{-1.66533e-15,-8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intCon.glaSha, conExt.glaSha_a) annotation (Line(
      points={{-20,-22},{-10,-22},{-10,-12},{-1.66533e-15,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intCon.JOutUns, conExt.JInUns_a) annotation (Line(
      points={{-19,-12},{-16,-12},{-16,2},{-1,2}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(intCon.JInUns, conExt.JOutUns_a) annotation (Line(
      points={{-19,-14},{-14,-14},{-14,-2},{-1,-2}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(intCon.JOutSha, conExt.JInSha_a) annotation (Line(
      points={{-19,-26},{-8,-26},{-8,-16},{-1,-16}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(intCon.JInSha, conExt.JOutSha_a) annotation (Line(
      points={{-19,-28},{-6,-28},{-6,-20},{-1,-20}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(conExt.JOutUns_b, bouConExt.JInUns) annotation (Line(
      points={{61,2},{68,2},{68,7.33333},{81.3333,7.33333}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(bouConExt.JOutUns, conExt.JInUns_b) annotation (Line(
      points={{81.3333,4.66667},{70,4.66667},{70,-2},{61,-2}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(bouConExt.glaUns, conExt.glaUns_b) annotation (Line(
      points={{82,0.666667},{82,0.666667},{80,0},{72,0},{72,-8},{60,-8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(bouConExt.glaSha, conExt.glaSha_b) annotation (Line(
      points={{82,-2},{74,-2},{74,-12},{60,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExt.JOutSha_b, bouConExt.JInSha) annotation (Line(
      points={{61,-16},{76,-16},{76,-4.66667},{81.3333,-4.66667}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(conExt.JInSha_b, bouConExt.JOutSha) annotation (Line(
      points={{61,-20},{78,-20},{78,-7.33333},{81.3333,-7.33333}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(conExt.fra_b, bouConExt.fra) annotation (Line(
      points={{60.2,-26},{80,-26},{80,-11.3333},{82,-11.3333}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(intCon.frame, theCol2.port_a) annotation (Line(
      points={{-23,-30},{-22,-30},{-22,-58}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(uSha.y, replicator.u) annotation (Line(
      points={{-169,-40},{-162,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(replicator.y, intCon.uSha) annotation (Line(
      points={{-139,-40},{-52,-40},{-52,-12},{-40.8,-12}},
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
      points={{80.6667,12.6667},{-52,12.6667},{-52,-40},{-139,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conExt.uSha, replicator.y) annotation (Line(
      points={{-2,6},{-52,6},{-52,-30},{-96,-30},{-96,-40},{-139,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QAbs.y, conExt.QAbsUns_flow) annotation (Line(
      points={{15,-80},{22,-80},{22,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QAbs.y, conExt.QAbsSha_flow) annotation (Line(
      points={{15,-80},{38,-80},{38,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QAbsSha.y, intCon.QAbs_flow) annotation (Line(
      points={{-59,-50},{-30,-50},{-30,-31}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QTra.y, bouConExt.QAbsSWSha_flow) annotation (Line(
      points={{41,50},{48,50},{48,10},{80.6667,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Commands(file="ExteriorWallTwoWindows.mos" "run"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},{200,
            100}}), graphics),
    Documentation(info="<html>
This model tests the exterior construction with windows.
</html>"));
end ExteriorWallTwoWindows;
