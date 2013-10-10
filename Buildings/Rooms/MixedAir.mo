within Buildings.Rooms;
model MixedAir "Model of a room in which the air is completely mixed"
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;
  extends Buildings.Rooms.BaseClasses.ConstructionRecords;
  parameter Integer nPorts=0 "Number of ports" annotation (Evaluate=true,
      Dialog(
      connectorSizing=true,
      tab="General",
      group="Ports"));

  parameter Modelica.SIunits.Angle lat "Latitude";
  final parameter Modelica.SIunits.Volume V=AFlo*hRoo "Volume";
  parameter Modelica.SIunits.Area AFlo "Floor area";
  parameter Modelica.SIunits.Length hRoo "Average room height";

  ////////////////////////////////////////////////////////////////////////
  // Fluid and heat ports
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
      redeclare each package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(
        extent={{-40,-10},{40,10}},
        origin={-260,-60},
        rotation=90), iconTransformation(
        extent={{-40,-10},{40,10}},
        rotation=90,
        origin={-150,-100})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorAir
    "Heat port to air volume" annotation (Placement(transformation(extent={{-270,30},
            {-250,50}}),   iconTransformation(extent={{-20,-10},{0,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorRad
    "Heat port for radiative heat gain and radiative temperature" annotation (
      Placement(transformation(extent={{-270,-10},{-250,10}}),
                                                           iconTransformation(
          extent={{-20,-48},{0,-28}})));
  ////////////////////////////////////////////////////////////////////////
  // Constructions
  Constructions.Construction conExt[NConExt](
    A=datConExt.A,
    til=datConExt.til,
    final layers={datConExt[i].layers for i in 1:NConExt},
    steadyStateInitial=datConExt.steadyStateInitial,
    T_a_start=datConExt.T_a_start,
    T_b_start=datConExt.T_b_start) if haveConExt
    "Heat conduction through exterior construction that have no window"
    annotation (Placement(transformation(extent={{288,100},{242,146}})));
  Constructions.ConstructionWithWindow conExtWin[NConExtWin](
    A=datConExtWin.A,
    til=datConExtWin.til,
    final layers={datConExtWin[i].layers for i in 1:NConExtWin},
    steadyStateInitial=datConExtWin.steadyStateInitial,
    T_a_start=datConExtWin.T_a_start,
    T_b_start=datConExtWin.T_b_start,
    AWin=datConExtWin.AWin,
    fFra=datConExtWin.fFra,
    glaSys=datConExtWin.glaSys) if haveConExtWin
    "Heat conduction through exterior construction that have a window"
    annotation (Placement(transformation(extent={{280,44},{250,74}})));
  Constructions.Construction conPar[NConPar](
    A=datConPar.A,
    til=datConPar.til,
    final layers={datConPar[i].layers for i in 1:NConPar},
    steadyStateInitial=datConPar.steadyStateInitial,
    T_a_start=datConPar.T_a_start,
    T_b_start=datConPar.T_b_start) if haveConPar
    "Heat conduction through partitions that have both sides inside the thermal zone"
    annotation (Placement(transformation(extent={{282,-122},{244,-84}})));
  Constructions.Construction conBou[NConBou](
    A=datConBou.A,
    til=datConBou.til,
    final layers={datConBou[i].layers for i in 1:NConBou},
    steadyStateInitial=datConBou.steadyStateInitial,
    T_a_start=datConBou.T_a_start,
    T_b_start=datConBou.T_b_start) if haveConBou
    "Heat conduction through opaque constructions that have the boundary conditions of the other side exposed"
    annotation (Placement(transformation(extent={{282,-156},{242,-116}})));
  parameter Boolean linearizeRadiation=true
    "Set to true to linearize emissive power";
  ////////////////////////////////////////////////////////////////////////
  // Convection
  parameter Buildings.HeatTransfer.Types.InteriorConvection intConMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature
    "Convective heat transfer model for room-facing surfaces of opaque constructions"
    annotation (Dialog(group="Convective heat transfer"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hIntFixed=3.0
    "Constant convection coefficient for room-facing surfaces of opaque constructions"
    annotation (Dialog(group="Convective heat transfer", enable=(conMod ==
          Buildings.HeatTransfer.Types.InteriorConvection.Fixed)));
  parameter Buildings.HeatTransfer.Types.ExteriorConvection extConMod=Buildings.HeatTransfer.Types.ExteriorConvection.TemperatureWind
    "Convective heat transfer model for exterior facing surfaces of opaque constructions"
    annotation (Dialog(group="Convective heat transfer"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hExtFixed=10.0
    "Constant convection coefficient for exterior facing surfaces of opaque constructions"
    annotation (Dialog(group="Convective heat transfer", enable=(conMod ==
          Buildings.HeatTransfer.Types.ExteriorConvection.Fixed)));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0) = V*1.2/3600
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));
  parameter Boolean homotopyInitialization "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  ////////////////////////////////////////////////////////////////////////
  // Models for boundary conditions
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a surf_conBou[nConBou] if
    haveConBou "Heat port at surface b of construction conBou" annotation (
      Placement(transformation(extent={{-270,-190},{-250,-170}}),
        iconTransformation(extent={{50,-170},{70,-150}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a surf_surBou[nSurBou] if
    haveSurBou "Heat port of surface that is connected to the room air"
    annotation (Placement(transformation(extent={{-270,-150},{-250,-130}}),
        iconTransformation(extent={{-48,-150},{-28,-130}})));
  Modelica.Blocks.Interfaces.RealInput uSha[nConExtWin](each min=0, each max=1) if
       haveShade
    "Control signal for the shading device (removed if no shade is present)"
    annotation (Placement(transformation(extent={{-300,160},{-260,200}}),
        iconTransformation(extent={{-240,140},{-200,180}})));
  Modelica.Blocks.Interfaces.RealInput qGai_flow[3](unit="W/m2")
    "Radiant, convective and latent heat input into room (positive if heat gain)"
    annotation (Placement(transformation(extent={{-300,80},{-260,120}})));
  // Reassign the tilt since a construction that is declared as a ceiling of the
  // room model has an exterior-facing surface that is a floor
  BaseClasses.ExteriorBoundaryConditions bouConExt(
    final nCon=nConExt,
    final lat=lat,
    linearizeRadiation=linearizeRadiation,
    final conMod=extConMod,
    final conPar=datConExt,
    final hFixed=hExtFixed) if haveConExt
    "Exterior boundary conditions for constructions without a window"
    annotation (Placement(transformation(extent={{352,114},{382,144}})));
  // Reassign the tilt since a construction that is declared as a ceiling of the
  // room model has an exterior-facing surface that is a floor
  BaseClasses.ExteriorBoundaryConditionsWithWindow bouConExtWin(
    final nCon=nConExtWin,
    final lat=lat,
    final conPar=datConExtWin,
    linearizeRadiation=linearizeRadiation,
    final conMod=extConMod,
    final hFixed=hExtFixed) if haveConExtWin
    "Exterior boundary conditions for constructions with a window"
    annotation (Placement(transformation(extent={{352,44},{382,74}})));

  HeatTransfer.Windows.BaseClasses.WindowRadiation conExtWinRad[NConExtWin](
    final AWin=(1 .- datConExtWin.fFra) .* datConExtWin.AWin,
    final N=datConExtWin.glaSys.nLay,
    final tauGlaSol=datConExtWin.glaSys.glass.tauSol,
    final rhoGlaSol_a=datConExtWin.glaSys.glass.rhoSol_a,
    final rhoGlaSol_b=datConExtWin.glaSys.glass.rhoSol_b,
    final xGla=datConExtWin.glaSys.glass.x,
    final tauShaSol_a=datConExtWin.glaSys.shade.tauSol_a,
    final tauShaSol_b=datConExtWin.glaSys.shade.tauSol_b,
    final rhoShaSol_a=datConExtWin.glaSys.shade.rhoSol_a,
    final rhoShaSol_b=datConExtWin.glaSys.shade.rhoSol_b,
    final haveExteriorShade=datConExtWin.glaSys.haveExteriorShade,
    final haveInteriorShade=datConExtWin.glaSys.haveInteriorShade) if
    haveConExtWin "Model for solar radiation through shades and window"
    annotation (Placement(transformation(extent={{320,-24},{300,-4}})));
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{170,150},{190,170}}), iconTransformation(extent=
           {{166,166},{192,192}})));

  Buildings.Rooms.BaseClasses.AirHeatMassBalanceMixed air(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    nPorts=nPorts + 1,
    final V=V,
    final nConExt=nConExt,
    final nConExtWin=nConExtWin,
    final nConPar=nConPar,
    final nConBou=nConBou,
    final nSurBou=nSurBou,
    final datConExt=datConExt,
    final datConExtWin=datConExtWin,
    final datConPar=datConPar,
    final datConBou=datConBou,
    final surBou=surBou,
    final homotopyInitialization=homotopyInitialization,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final m_flow_nominal=m_flow_nominal,
    final haveShade=haveShade,
    final conMod=intConMod,
    final hFixed=hIntFixed) "Convective heat and mass balance of air"
    annotation (Placement(transformation(extent={{40,-142},{64,-118}})));

  Buildings.Rooms.BaseClasses.SolarRadiationExchange solRadExc(
    final nConExt=nConExt,
    final nConExtWin=nConExtWin,
    final nConPar=nConPar,
    final nConBou=nConBou,
    final nSurBou=nSurBou,
    final datConExt = datConExt,
    final datConExtWin = datConExtWin,
    final datConPar = datConPar,
    final datConBou = datConBou,
    final surBou = surBou,
    final isFloorConExt=isFloorConExt,
    final isFloorConExtWin=isFloorConExtWin,
    final isFloorConPar_a=isFloorConPar_a,
    final isFloorConPar_b=isFloorConPar_b,
    final isFloorConBou=isFloorConBou,
    final isFloorSurBou=isFloorSurBou,
    final tauGla={datConExtWin[i].glaSys.glass[datConExtWin[i].glaSys.nLay].tauSol for i in 1:NConExtWin}) if
       haveConExtWin "Solar radiative heat exchange"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));

  Buildings.Rooms.BaseClasses.InfraredRadiationGainDistribution irRadGai(
    final nConExt=nConExt,
    final nConExtWin=nConExtWin,
    final nConPar=nConPar,
    final nConBou=nConBou,
    final nSurBou=nSurBou,
    final datConExt = datConExt,
    final datConExtWin = datConExtWin,
    final datConPar = datConPar,
    final datConBou = datConBou,
    final surBou = surBou,
    final haveShade=haveShade)
    "Distribution for infrared radiative heat gains (e.g., due to equipment and people)"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Rooms.BaseClasses.InfraredRadiationExchange irRadExc(
    final nConExt=nConExt,
    final nConExtWin=nConExtWin,
    final nConPar=nConPar,
    final nConBou=nConBou,
    final nSurBou=nSurBou,
    final datConExt = datConExt,
    final datConExtWin = datConExtWin,
    final datConPar = datConPar,
    final datConBou = datConBou,
    final surBou = surBou,
    final linearizeRadiation = linearizeRadiation)
    "Infrared radiative heat exchange"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Buildings.Rooms.BaseClasses.RadiationTemperature radTem(
    final nConExt=nConExt,
    final nConExtWin=nConExtWin,
    final nConPar=nConPar,
    final nConBou=nConBou,
    final nSurBou=nSurBou,
    final datConExt=datConExt,
    final datConExtWin=datConExtWin,
    final datConPar=datConPar,
    final datConBou=datConBou,
    final surBou=surBou,
    final haveShade=haveShade) "Radiative temperature of the room"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));

  HeatTransfer.Windows.BaseClasses.ShadeRadiation shaRad[NConExtWin](
    final A=(1 .- datConExtWin.fFra) .* datConExtWin.AWin,
    final thisSideHasShade=haveInteriorShade,
    final absIR_air=datConExtWin.glaSys.shade.absIR_a,
    final absIR_glass={(datConExtWin[i].glaSys.glass[datConExtWin[i].glaSys.nLay].absIR_b) for i in 1:NConExtWin},
    final tauIR_air=tauIRSha_air,
    final tauIR_glass=tauIRSha_glass,
    each final linearize = linearizeRadiation) if
       haveShade "Radiation model for room-side window shade"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));

protected
  final parameter Modelica.SIunits.TransmissionCoefficient tauIRSha_air[NConExtWin]=
    datConExtWin.glaSys.shade.tauIR_a
    "Infrared transmissivity of shade for radiation coming from the exterior or the room"
    annotation (Dialog(group="Shading"));
        final parameter Modelica.SIunits.TransmissionCoefficient tauIRSha_glass[
                                                                          NConExtWin]=
    datConExtWin.glaSys.shade.tauIR_b
    "Infrared transmissivity of shade for radiation coming from the glass"
    annotation (Dialog(group="Shading"));

  final parameter Boolean haveExteriorShade[NConExtWin]=
    {datConExtWin[i].glaSys.haveExteriorShade for i in 1:NConExtWin}
    "Set to true if window has exterior shade (at surface a)"
    annotation (Dialog(group="Shading"));
  final parameter Boolean haveInteriorShade[NConExtWin]=
    {datConExtWin[i].glaSys.haveInteriorShade for i in 1:NConExtWin}
    "Set to true if window has interior shade (at surface b)"
    annotation (Dialog(group="Shading"));

  final parameter Boolean haveShade=
    Modelica.Math.BooleanVectors.anyTrue(haveExteriorShade[:]) or
    Modelica.Math.BooleanVectors.anyTrue(haveInteriorShade[:])
    "Set to true if the windows have a shade";

  final parameter Boolean isFloorConExt[NConExt]=
    datConExt.isFloor "Flag to indicate if floor for exterior constructions";
  final parameter Boolean isFloorConExtWin[NConExtWin]=
    datConExtWin.isFloor "Flag to indicate if floor for constructions";
  final parameter Boolean isFloorConPar_a[NConPar]=
    datConPar.isFloor "Flag to indicate if floor for constructions";
  final parameter Boolean isFloorConPar_b[NConPar]=
    datConPar.isCeiling "Flag to indicate if floor for constructions";
  final parameter Boolean isFloorConBou[NConBou]=
    datConBou.isFloor
    "Flag to indicate if floor for constructions with exterior boundary conditions exposed to outside of room model";
  parameter Boolean isFloorSurBou[NSurBou]=
    surBou.isFloor
    "Flag to indicate if floor for constructions that are modeled outside of this room";

  HeatTransfer.Windows.BaseClasses.ShadingSignal shaSig[NConExtWin](
    each final haveShade=haveShade) if
       haveConExtWin "Shading signal"
    annotation (Placement(transformation(extent={{-220,150},{-200,170}})));

  Buildings.Rooms.BaseClasses.HeatGain heaGai(redeclare package Medium = Medium, final AFlo=AFlo)
    "Model to convert internal heat gains"
    annotation (Placement(transformation(extent={{-220,90},{-200,110}})));
  Buildings.Rooms.BaseClasses.RadiationAdapter radiationAdapter
    annotation (Placement(transformation(extent={{-180,120},{-160,140}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));

  Modelica.Blocks.Math.Add sumJToWin[NConExtWin](
    each final k1=1,
    each final k2=1) if
       haveConExtWin
    "Sum of radiosity flows from room surfaces toward the window"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  HeatTransfer.Radiosity.RadiositySplitter radShaOut[NConExtWin] if
     haveConExtWin
    "Splitter for radiosity that strikes shading device or unshaded part of window"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));

  Modelica.Blocks.Math.Sum sumJFroWin[NConExtWin](each nin=if haveShade then 2
         else 1) if
       haveConExtWin "Sum of radiosity fom window to room surfaces"
    annotation (Placement(transformation(extent={{-20,4},{-40,24}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TSha[NConExtWin] if
       haveShade "Temperature of shading device"
    annotation (Placement(transformation(extent={{-20,-78},{-40,-58}})));

equation
  connect(conBou.opa_a, surf_conBou) annotation (Line(
      points={{282,-122.667},{282,-122},{288,-122},{288,-216},{-240,-216},{-240,
          -180},{-260,-180}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(uSha, conExtWin.uSha) annotation (Line(
      points={{-280,180},{306,180},{306,62},{281,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uSha, bouConExtWin.uSha) annotation (Line(
      points={{-280,180},{306,180},{306,64},{351,64}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(bouConExtWin.opa_a, conExtWin.opa_a) annotation (Line(
      points={{352,69},{280,69}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(conExtWin.JInUns_a, bouConExtWin.JOutUns) annotation (Line(
      points={{280.5,60},{304,60},{304,58},{351.5,58}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(bouConExtWin.JInUns, conExtWin.JOutUns_a) annotation (Line(
      points={{351.5,60},{316,60},{316,58},{280.5,58}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(conExtWin.glaUns_a, bouConExtWin.glaUns) annotation (Line(
      points={{280,55},{352,55}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(bouConExtWin.glaSha, conExtWin.glaSha_a) annotation (Line(
      points={{352,53},{280,53}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(conExtWin.JInSha_a, bouConExtWin.JOutSha) annotation (Line(
      points={{280.5,51},{286,51},{286,52},{292,52},{292,50},{292,50},{292,49},{
          351.5,49}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(bouConExtWin.JInSha, conExtWin.JOutSha_a) annotation (Line(
      points={{351.5,51},{290,51},{290,50},{290,50},{290,49},{280.5,49}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(conExtWin.fra_a, bouConExtWin.fra) annotation (Line(
      points={{280,46},{352,46}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(conExt.opa_a, bouConExt.opa_a) annotation (Line(
      points={{288,138.333},{314,138.333},{334,138.333},{334,139},{352,139}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(weaBus, bouConExtWin.weaBus) annotation (Line(
      points={{180,160},{400,160},{400,120},{400,120},{400,60.05},{378.15,60.05}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus, bouConExt.weaBus) annotation (Line(
      points={{180,160},{400,160},{400,130},{378.15,130},{378.15,130.05}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(bouConExtWin.QAbsSolSha_flow, conExtWinRad.QAbsExtSha_flow)
    annotation (Line(
      points={{351,62},{312,62},{312,46},{290,46},{290,-5},{299,-5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bouConExtWin.inc, conExtWinRad.incAng) annotation (Line(
      points={{382.5,68},{390,68},{390,-16},{390,-16},{390,-15},{321.5,-15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bouConExtWin.HDir, conExtWinRad.HDir) annotation (Line(
      points={{382.5,65},{388,65},{388,-10},{386,-10},{386,-10},{321.5,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bouConExtWin.HDif, conExtWinRad.HDif) annotation (Line(
      points={{382.5,62},{392,62},{392,-6},{392,-6},{392,-6},{321.5,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uSha, conExtWinRad.uSha) annotation (Line(
      points={{-280,180},{420,180},{420,-40},{310.2,-40},{310.2,-25.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conExtWin.QAbsSha_flow, conExtWinRad.QAbsGlaSha_flow) annotation (
      Line(
      points={{261,43},{261,38},{260,38},{260,-12},{280,-12},{280,-13},{299,-13}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conExtWinRad.QAbsGlaUns_flow, conExtWin.QAbsUns_flow) annotation (
      Line(
      points={{299,-9},{284,-9},{284,-10},{268,-10},{268,36},{269,36},{269,43}},
      color={0,0,127},
      smooth=Smooth.None));
 // Connect statements from the model BaseClasses.MixedAir
  connect(conExt.opa_b, irRadExc.conExt) annotation (Line(
      points={{241.847,138.333},{160,138.333},{160,60},{-60,60},{-60,20},{-80,
          20},{-80,19.1667}},
      color={190,0,0},
      smooth=Smooth.None));
  connect(conExtWin.fra_b, irRadExc.conExtWinFra) annotation (Line(
      points={{249.9,46},{160,46},{160,60},{-60,60},{-60,10},{-79.9167,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conPar.opa_a, irRadExc.conPar_a) annotation (Line(
      points={{282,-90.3333},{288,-90.3333},{288,-106},{160,-106},{160,60},{-60,
          60},{-60,8},{-80,8},{-80,7.5},{-79.9167,7.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conPar.opa_b, irRadExc.conPar_b) annotation (Line(
      points={{243.873,-90.3333},{160,-90.3333},{160,60},{-60,60},{-60,5.83333},
          {-79.9167,5.83333}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(conBou.opa_b, irRadExc.conBou) annotation (Line(
      points={{241.867,-122.667},{160,-122.667},{160,60},{-60,60},{-60,3.33333},
          {-79.9167,3.33333}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(surf_surBou, irRadExc.conSurBou) annotation (Line(
      points={{-260,-140},{-232,-140},{-232,-210},{160,-210},{160,60},{-60,60},
          {-60,0.833333},{-79.9583,0.833333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(irRadGai.conExt, conExt.opa_b) annotation (Line(
      points={{-80,-20.8333},{-80,-20},{-60,-20},{-60,60},{160,60},{160,138.333},
          {241.847,138.333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(irRadGai.conExtWinFra, conExtWin.fra_b) annotation (Line(
      points={{-79.9167,-30},{-60,-30},{-60,60},{160,60},{160,46},{249.9,46}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(irRadGai.conPar_a, conPar.opa_a) annotation (Line(
      points={{-79.9167,-32.5},{-60,-32.5},{-60,60},{160,60},{160,-106},{288,
          -106},{288,-90.3333},{282,-90.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(irRadGai.conPar_b, conPar.opa_b) annotation (Line(
      points={{-79.9167,-34.1667},{-60,-34.1667},{-60,60},{160,60},{160,
          -90.3333},{243.873,-90.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(irRadGai.conBou, conBou.opa_b) annotation (Line(
      points={{-79.9167,-36.6667},{-60,-36.6667},{-60,60},{160,60},{160,
          -122.667},{241.867,-122.667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(irRadGai.conSurBou, surf_surBou) annotation (Line(
      points={{-79.9583,-39.1667},{-60,-39.1667},{-60,60},{160,60},{160,-210},{
          -232,-210},{-232,-140},{-260,-140}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(irRadGai.uSha, uSha)
                             annotation (Line(
      points={{-100.833,-22.5},{-100.833,-22.5},{-112,-22.5},{-112,180},{-280,
          180}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaGai.qGai_flow, qGai_flow) annotation (Line(
      points={{-222,100},{-280,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conExtWin.opa_b, irRadExc.conExtWin) annotation (Line(
      points={{249.9,69},{160,69},{160,60},{-60,60},{-60,16},{-80,16},{-80,17.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExtWin.opa_b, irRadGai.conExtWin) annotation (Line(
      points={{249.9,69},{160,69},{160,60},{-60,60},{-60,-22},{-70,-22},{-70,-22.5},
          {-80,-22.5}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(conExt.opa_b, solRadExc.conExt) annotation (Line(
      points={{241.847,138.333},{160,138.333},{160,60},{-80,60},{-80,59.1667}},
      color={190,0,0},
      smooth=Smooth.None));
  connect(conExtWin.fra_b, solRadExc.conExtWinFra) annotation (Line(
      points={{249.9,46},{160,46},{160,60},{-60,60},{-60,50},{-79.9167,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conPar.opa_a, solRadExc.conPar_a) annotation (Line(
      points={{282,-90.3333},{288,-90.3333},{288,-106},{160,-106},{160,60},{-60,
          60},{-60,48},{-79.9167,48},{-79.9167,47.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conPar.opa_b, solRadExc.conPar_b) annotation (Line(
      points={{243.873,-90.3333},{160,-90.3333},{160,60},{-60,60},{-60,46},{-70,
          46},{-70,45.8333},{-79.9167,45.8333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conBou.opa_b, solRadExc.conBou) annotation (Line(
      points={{241.867,-122.667},{160,-122.667},{160,60},{-60,60},{-60,43.3333},
          {-79.9167,43.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(surf_surBou, solRadExc.conSurBou) annotation (Line(
      points={{-260,-140},{-232,-140},{-232,-210},{160,-210},{160,60},{-60,60},
          {-60,40},{-70,40},{-70,40.8333},{-79.9583,40.8333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExtWin.opa_b, solRadExc.conExtWin) annotation (Line(
      points={{249.9,69},{160,69},{160,60},{-60,60},{-60,57.5},{-80,57.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solRadExc.JInConExtWin, conExtWinRad.QTra_flow) annotation (Line(
      points={{-79.5833,53.3333},{-74,53.3333},{-74,52},{14,52},{14,-22},{299,
          -22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solRadExc.HOutConExtWin,conExtWinRad.HRoo)  annotation (Line(
      points={{-79.5833,55},{10,55},{10,-34},{328,-34},{328,-21.6},{321.5,-21.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uSha, radTem.uSha) annotation (Line(
      points={{-280,180},{-112,180},{-112,-62},{-100.833,-62},{-100.833,-62.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conExt.opa_b, radTem.conExt) annotation (Line(
      points={{241.847,138.333},{160,138.333},{160,60},{-60,60},{-60,-60.8333},
          {-80,-60.8333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExtWin.opa_b, radTem.conExtWin) annotation (Line(
      points={{249.9,69},{160,69},{160,60},{-60,60},{-60,-62.5},{-80,-62.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExtWin.fra_b, radTem.conExtWinFra) annotation (Line(
      points={{249.9,46},{160,46},{160,4},{160,4},{160,60},{-60,60},{-60,-70},{
          -79.9167,-70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conPar.opa_a, radTem.conPar_a) annotation (Line(
      points={{282,-90.3333},{288,-90.3333},{288,-106},{160,-106},{160,60},{-60,
          60},{-60,-72.5},{-79.9167,-72.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conPar.opa_b, radTem.conPar_b) annotation (Line(
      points={{243.873,-90.3333},{160,-90.3333},{160,60},{-60,60},{-60,-74.1667},
          {-79.9167,-74.1667}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(conBou.opa_b, radTem.conBou) annotation (Line(
      points={{241.867,-122.667},{160,-122.667},{160,60},{-60,60},{-60,-76.6667},
          {-79.9167,-76.6667}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(surf_surBou, radTem.conSurBou) annotation (Line(
      points={{-260,-140},{-232,-140},{-232,-210},{160,-210},{160,60},{-60,60},
          {-60,-79.1667},{-79.9583,-79.1667}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(radTem.glaUns, conExtWin.glaUns_b) annotation (Line(
      points={{-80,-65},{-60,-65},{-60,60},{160,60},{160,55},{250,55}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radTem.glaSha, conExtWin.glaSha_b) annotation (Line(
      points={{-80,-66.6667},{-60,-66.6667},{-60,60},{160,60},{160,53},{250,53}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(radTem.TRad, radiationAdapter.TRad) annotation (Line(
      points={{-100.417,-77.6667},{-166,-77.6667},{-192,-77.6667},{-192,130},{
          -182,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radiationAdapter.rad, heaPorRad)
                                     annotation (Line(
      points={{-170.2,120},{-170,120},{-170,118},{-170,118},{-170,114},{-226,114},
          {-226,4.44089e-16},{-260,4.44089e-16}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(radiationAdapter.QRad_flow, add.u1) annotation (Line(
      points={{-159,130},{-154,130},{-154,126},{-142,126}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaGai.QRad_flow, add.u2) annotation (Line(
      points={{-199,106},{-160,106},{-160,114},{-142,114}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, irRadGai.Q_flow) annotation (Line(
      points={{-119,120},{-116,120},{-116,-30},{-100.833,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(irRadExc.JOutConExtWin, sumJToWin.u1)
                                           annotation (Line(
      points={{-79.5833,15},{-50,15},{-50,-14},{-42,-14}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(irRadGai.JOutConExtWin, sumJToWin.u2)
                                           annotation (Line(
      points={{-79.5833,-25},{-46,-25},{-46,-26},{-42,-26}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(uSha, shaSig.u) annotation (Line(
      points={{-280,180},{-250,180},{-250,160},{-222,160}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaSig.y, radShaOut.u) annotation (Line(
      points={{-199,160},{-110,160},{-110,124},{-102,124}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaSig.y, shaRad.u) annotation (Line(
      points={{-199,160},{-64,160},{-64,108},{-61,108}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(sumJToWin.y, radShaOut.JIn)
                                 annotation (Line(
      points={{-19,-20},{0,-20},{0,148},{-106,148},{-106,136},{-101,136}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radShaOut.JOut_1, shaRad.JIn_air) annotation (Line(
      points={{-79,136},{-70,136},{-70,96},{-61,96}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radShaOut.JOut_2, conExtWin.JInUns_b) annotation (Line(
      points={{-79,124},{-20,124},{-20,58},{249.5,58}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(shaRad.JOut_glass, conExtWin.JInSha_b) annotation (Line(
      points={{-39,96},{20,96},{20,72},{220,72},{220,49},{249.5,49}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(conExtWin.JOutSha_b, shaRad.JIn_glass) annotation (Line(
      points={{249.5,51},{222,51},{222,70},{16,70},{16,92},{-39,92}},
      color={0,127,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));

  connect(irRadExc.JInConExtWin, sumJFroWin.y) annotation (Line(
      points={{-79.5833,13.3333},{-46,13.3333},{-46,14},{-41,14}},
      color={0,127,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));

  connect(shaRad.QSolAbs_flow, conExtWinRad.QAbsIntSha_flow) annotation (Line(
      points={{-50,89},{-50,86},{148,86},{148,-17},{299,-17}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sumJFroWin.u[1], conExtWin.JOutUns_b) annotation (Line(
      points={{-18,14},{164,14},{164,60},{249.5,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sumJFroWin.u[2], shaRad.JOut_air) annotation (Line(
      points={{-18,14},{-10,14},{-10,40},{-40,40},{-40,64},{-66,64},{-66,92},{
          -61,92}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radTem.sha, TSha.port) annotation (Line(
      points={{-80,-68.4167},{-64,-68.4167},{-64,-68},{-40,-68}},
      color={191,0,0},
      smooth=Smooth.None));

  for i in 1:nPorts loop
    connect(ports[i],air. ports[i])
                                  annotation (Line(
      points={{-260,-60},{-218,-60},{-218,-204},{52,-204},{52,-141.9}},
      color={0,127,255},
      smooth=Smooth.None));
  end for;
  connect(heaGai.QLat_flow,air. ports[nPorts + 1])
                                                 annotation (Line(
      points={{-200,94},{-186,94},{-186,-170},{52,-170},{52,-141.9}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(air.heaPorAir, heaGai.QCon_flow) annotation (Line(
      points={{40,-130},{-180,-130},{-180,100},{-200,100}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(air.conExt, conExt.opa_b) annotation (Line(
      points={{64,-119},{160,-119},{160,138.333},{241.847,138.333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(air.conExtWin, conExtWin.opa_b) annotation (Line(
      points={{64,-121},{160,-121},{160,69},{249.9,69}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(air.glaUns, conExtWin.glaUns_b) annotation (Line(
      points={{64,-124},{160,-124},{160,55},{250,55}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(air.glaSha, conExtWin.glaSha_b) annotation (Line(
      points={{64,-126},{160,-126},{160,53},{250,53}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(air.conExtWinFra, conExtWin.fra_b) annotation (Line(
      points={{64.1,-130},{160,-130},{160,46},{249.9,46}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(air.conPar_a, conPar.opa_a) annotation (Line(
      points={{64.1,-133},{160,-133},{160,-106},{288,-106},{288,-90.3333},{282,
          -90.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(air.conPar_b, conPar.opa_b) annotation (Line(
      points={{64.1,-135},{160,-135},{160,-90},{243.873,-90},{243.873,-90.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(air.conBou, conBou.opa_b) annotation (Line(
      points={{64.1,-138},{160,-138},{160,-122.667},{241.867,-122.667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(air.conSurBou, surf_surBou) annotation (Line(
      points={{64.05,-141},{160,-141},{160,-210},{-232,-210},{-232,-140},{-260,-140}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(air.uSha, uSha) annotation (Line(
      points={{39.6,-120},{6,-120},{6,180},{-280,180}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaRad.QRadAbs_flow,air. QRadAbs_flow) annotation (Line(
      points={{-55,89},{-55,72},{4,72},{4,-125},{39.5,-125}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(air.TSha, shaRad.TSha) annotation (Line(
      points={{39.5,-127},{2,-127},{2,70},{-45,70},{-45,89}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(air.heaPorAir, heaPorAir) annotation (Line(
      points={{40,-130},{-180,-130},{-180,40},{-260,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(air.TSha, TSha.T) annotation (Line(
      points={{39.5,-127},{2,-127},{2,-68},{-18,-68}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-260,-220},{460,
            200}}), graphics),
        Icon(coordinateSystem(preserveAspectRatio=true, extent={{-200,-200},{200, 200}}),
                    graphics={
        Text(
          extent={{-104,210},{84,242}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Text(
          extent={{-214,114},{-138,82}},
          lineColor={0,0,127},
          textString="q"),
        Text(
          extent={{-212,176},{-136,144}},
          lineColor={0,0,127},
          textString="u"),
        Text(
          extent={{-14,-160},{44,-186}},
          lineColor={0,0,0},
          fillColor={61,61,61},
          fillPattern=FillPattern.Solid,
          textString="boundary"),
        Rectangle(
          extent={{-160,-160},{160,160}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-140,138},{140,-140}},
          pattern=LinePattern.None,
          lineColor={117,148,176},
          fillColor={170,213,255},
          fillPattern=FillPattern.Sphere),
        Rectangle(
          extent={{140,70},{160,-70}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{146,70},{154,-70}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-60,12},{-22,-10}},
          lineColor={0,0,0},
          fillColor={61,61,61},
          fillPattern=FillPattern.Solid,
          textString="air"),
        Text(
          extent={{-72,-22},{-22,-50}},
          lineColor={0,0,0},
          fillColor={61,61,61},
          fillPattern=FillPattern.Solid,
          textString="radiation"),
        Text(
          extent={{-104,-124},{-54,-152}},
          lineColor={0,0,0},
          fillColor={61,61,61},
          fillPattern=FillPattern.Solid,
          textString="surface"),
        Text(
          extent={{-138,-82},{-96,-100}},
          lineColor={0,0,0},
          fillColor={61,61,61},
          fillPattern=FillPattern.Solid,
          textString="fluid")}),
    preferredView="info",
    defaultComponentName="roo",
    Documentation(info="<html>
<p>
Room model that assumes the air to be completely mixed. 
</p>
<p>
See 
<a href=\"modelica://Buildings.Rooms.UsersGuide\">Buildings.Rooms.UsersGuide</a>
for detailed explanations.
</p>
</html>",   revisions="<html>
<ul>
<li>
July 16, 2013, by Michael Wetter:<br/>
Redesigned implementation to remove one level of model hierarchy on the room-side heat and mass balance.
This change was done to facilitate the implementation of non-uniform room air heat and mass balance,
which required separating the convection and long-wave radiation models.<br/>
Changed assignment 
<code>solRadExc(tauGla={0.6 for i in 1:NConExtWin})</code> to
<code>solRadExc(tauGla={datConExtWin[i].glaSys.glass[datConExtWin[i].glaSys.nLay].tauSol for i in 1:NConExtWin})</code> to
better take into account the solar properties of the glass.
</li>
<li>
March 7 2012, by Michael Wetter:<br/>
Added optional parameters <code>ove</code> and <code>sidFin</code> to
the parameter <code>datConExtWin</code>.
This allows modeling windows with an overhang or with side fins.
</li>
<li>
February 8 2012, by Michael Wetter:<br/>
Changed model to use new implementation of
<a href=\"modelica://Buildings.HeatTransfer.Radiosity.OutdoorRadiosity\">
Buildings.HeatTransfer.Radiosity.OutdoorRadiosity</a>.
This change leads to the use of the same equations for the radiative
heat transfer between window and ambient as is used for 
the opaque constructions.
</li>
<li>
December 12, 2011, by Wangda Zuo:<br/>
Add glass thickness as a parameter for conExtWinRad. It is needed by the claculation of property for uncoated glass.
</li>
<li>
December 6, 2011, by Michael Wetter:<br/>
Fixed bug that caused convective heat gains to be 
removed from the room instead of added to the room.
This error was caused by a wrong sign in
<a href=\"modelica://Buildings.Rooms.BaseClasses.HeatGain\">
Buildings.Rooms.BaseClasses.HeatGain</a>.
This closes ticket <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/46\">issue 46</a>.
</li>
<li>
August 9, 2011, by Michael Wetter:<br/>
Fixed bug that caused too high a surface temperature of the window frame.
The previous version did not compute the infrared radiation exchange between the
window frame and the sky. This has been corrected by adding the instance
<code>skyRadExcWin</code> and the parameter <code>absIRFra</code> to the 
model 
<a href=\"modelica://Buildings.Rooms.BaseClasses.ExteriorBoundaryConditionsWithWindow\">
Buildings.Rooms.BaseClasses.ExteriorBoundaryConditionsWithWindow</a>.
This closes ticket <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/36\">issue 36</a>.
</li>
<li>
August 9, 2011 by Michael Wetter:<br/>
Changed assignment of tilt in instances <code>bouConExt</code> and <code>bouConExtWin</code>.
This fixes the bug in <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/35\">issue 35</a>
that led to the wrong solar radiation gain for roofs and floors.
</li>
<li>
March 23, 2011, by Michael Wetter:<br/>
Propagated convection model to exterior boundary condition models.
</li>
<li>
December 14, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MixedAir;
