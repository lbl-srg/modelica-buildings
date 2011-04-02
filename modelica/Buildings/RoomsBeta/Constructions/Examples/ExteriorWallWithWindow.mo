within Buildings.RoomsBeta.Constructions.Examples;
model ExteriorWallWithWindow "Test model for an exterior wall with a window"
  import Buildings;
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Area A[:]={3*10}
    "Heat transfer area of wall and window";
  parameter Modelica.SIunits.Area AWin[:]=A-{2*3}
    "Heat transfer area of frame and window";
  parameter Real fFra[:]={0.1}
    "Fraction of window frame divided by total window area";
  parameter Boolean linearizeRadiation = false
    "Set to true to linearize emissive power";
  HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(
    UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveExteriorShade=false,
    haveInteriorShade=false) "Record for glazing system"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));

  ConstructionWithWindow conExt[1](
    layers={extConMat},
    glaSys={glaSys},
    linearizeRadiation = {linearizeRadiation},
    A=A,
    AWin=AWin,
    fFra=fFra,
    til={1.5707963267949}) "Construction of an exterior wall without a window"
    annotation (Placement(transformation(extent={{0,-30},{60,30}})));
  Buildings.RoomsBeta.BaseClasses.ExteriorBoundaryConditionsWithWindow
    bouConExt(
    nCon=1,
    linearizeRadiation = linearizeRadiation,
    fFra=fFra,
    absIR={extConMat.absIR_a},
    azi={0},
    AOpa=A - AWin,
    absSol={extConMat.absSol_a},
    AWin=AWin,
    absSolFra={glaSys.absSolFra},
    absIRSha_air={glaSys.shade.absIR_a},
    absIRSha_glass={glaSys.shade.absIR_b},
    tauIRSha_air={glaSys.shade.tauIR_a},
    tauIRSha_glass={glaSys.shade.tauIR_b},
    haveExteriorShade={glaSys.haveExteriorShade},
    haveInteriorShade={glaSys.haveInteriorShade},
    lat=0.73268921998722,
    conMod=Buildings.HeatTransfer.Types.InteriorConvection.Fixed,
    til={Buildings.HeatTransfer.Types.Tilt.Wall})
    "Exterior boundary conditions for constructions without a window"
    annotation (Placement(transformation(extent={{82,-14},{122,26}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Buildings.HeatTransfer.Convection.Interior con[
                              1](A=A - AWin, til={Buildings.HeatTransfer.Types.Tilt.Wall})
    "Model for heat convection"
    annotation (Placement(transformation(extent={{-20,20},{-40,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theCol(m=1)
    "Thermal collector to link a vector of models to a single model"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,30})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    annotation (Placement(transformation(extent={{110,60},{130,80}})));
  Modelica.Blocks.Sources.Constant TRoo(k=273.15 + 20) "Room air temperature"
    annotation (Placement(transformation(extent={{-180,20},{-160,40}})));
  HeatTransfer.Data.OpaqueConstructions.Insulation100Concrete200 extConMat
    "Record for material layers"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));

  HeatTransfer.WindowsBeta.InteriorHeatTransfer intCon[1](
    A=AWin,
    fFra=fFra,
    absIRSha_air={glaSys.shade.absIR_a},
    absIRSha_glass={glaSys.shade.absIR_b},
    tauIRSha_air={glaSys.shade.tauIR_a},
    tauIRSha_glass={glaSys.shade.tauIR_b},
    haveExteriorShade={glaSys.haveExteriorShade},
    haveInteriorShade={glaSys.haveInteriorShade},
    each linearizeRadiation = linearizeRadiation)
    "Model for interior convection"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Modelica.Blocks.Sources.Constant uSha(k=0) "Shading control signal"
    annotation (Placement(transformation(extent={{-180,-60},{-160,-40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theCol1(
                                                                   m=1)
    "Thermal collector to link a vector of models to a single model"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-90,-20})));
  HeatTransfer.Radiosity.IndoorRadiosity indRad(A=AWin[1], linearize = linearizeRadiation)
    "Model for indoor radiosity"
    annotation (Placement(transformation(extent={{-102,-78},{-82,-58}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theCol2(
                                                                   m=1)
    "Thermal collector to link a vector of models to a single model"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-20,-64})));
  Modelica.Blocks.Sources.Constant QAbs[1,glaSys.nLay](each k=0)
    "Solar radiation absorbed by glass"
    annotation (Placement(transformation(extent={{-8,-90},{12,-70}})));
  Modelica.Blocks.Sources.Constant QAbsSha(each k=0)
    "Solar radiation absorbed by interior shade"
    annotation (Placement(transformation(extent={{-58,-60},{-38,-40}})));
  Modelica.Blocks.Sources.Constant QTra(each k=0)
    "Solar radiation absorbed by exterior shade"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
equation
  connect(prescribedTemperature.port, theCol.port_b) annotation (Line(
      points={{-120,30},{-100,30},{-100,30},{-80,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theCol.port_a, con.fluid) annotation (Line(
      points={{-60,30},{-50,30},{-50,30},{-40,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con.solid, conExt.opa_a) annotation (Line(
      points={{-20,30},{-10,30},{-10,20},{-1.66533e-15,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExt.opa_b, bouConExt.opa_a) annotation (Line(
      points={{60.2,20},{72,20},{72,19.3333},{82,19.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(weaDat.weaBus, bouConExt.weaBus) annotation (Line(
      points={{130,70},{140,70},{140,7.4},{116.867,7.4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(TRoo.y, prescribedTemperature.T) annotation (Line(
      points={{-159,30},{-142,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(theCol1.port_b, prescribedTemperature.port) annotation (Line(
      points={{-100,-20},{-112,-20},{-112,30},{-120,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intCon[1].uSha, uSha.y) annotation (Line(
      points={{-40.8,-12},{-72,-12},{-72,-50},{-159,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(theCol1.port_a, intCon.air) annotation (Line(
      points={{-80,-20},{-60,-20},{-60,-20},{-40,-20}},
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
      points={{82,0.666667},{80,0.666667},{80,0},{72,0},{72,-8},{60,-8}},
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
  connect(indRad.JOut, intCon[1].JInRoo) annotation (Line(
      points={{-81,-64},{-66,-64},{-66,-28},{-40,-28}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(indRad.JIn, intCon[1].JOutRoo) annotation (Line(
      points={{-81,-72},{-62,-72},{-62,-24},{-40.4,-24}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(indRad.heatPort, prescribedTemperature.port) annotation (Line(
      points={{-91.2,-77.8},{-112,-77.8},{-112,30},{-120,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intCon.frame, theCol2.port_a) annotation (Line(
      points={{-23,-30},{-20,-30},{-20,-54}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theCol2.port_b, indRad.heatPort) annotation (Line(
      points={{-20,-74},{-20,-77.8},{-91.2,-77.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(uSha.y, bouConExt.uSha[1]) annotation (Line(
      points={{-159,-50},{-140,-50},{-140,12.6667},{80.6667,12.6667}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uSha.y, conExt[1].uSha) annotation (Line(
      points={{-159,-50},{-140,-50},{-140,6},{-2,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QAbs.y, conExt.QAbsUns_flow) annotation (Line(
      points={{13,-80},{22,-80},{22,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QAbs.y, conExt.QAbsSha_flow) annotation (Line(
      points={{13,-80},{38,-80},{38,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QAbsSha.y, intCon[1].QAbs_flow) annotation (Line(
      points={{-37,-50},{-30,-50},{-30,-31}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QTra.y, bouConExt.QAbsSolSha_flow[1]) annotation (Line(
      points={{61,50},{68,50},{68,10},{80.6667,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Commands(file="ExteriorWallWithWindow.mos" "run"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},{200,
            100}}), graphics),
    Documentation(info="<html>
This model tests the exterior constructions with windows.
</html>"));
end ExteriorWallWithWindow;
