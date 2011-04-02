within Buildings.RoomsBeta.BaseClasses;
model MixedAir "Model for room air that is completely mixed"
  extends Buildings.RoomsBeta.BaseClasses.ParameterFluid;
  extends Buildings.RoomsBeta.BaseClasses.PartialSurfaceInterface;

  parameter Modelica.SIunits.Volume V "Volume";

  // Port definitions
  parameter Integer nPorts=0 "Number of fluid ports of this model"
    annotation(Evaluate=true, Dialog(__Dymola_connectorSizing=true, tab="General",group="Ports"));
  parameter Modelica.SIunits.Area AFlo "Floor area";
  parameter Modelica.SIunits.Length hRoo "Average room height";

  parameter Buildings.HeatTransfer.Types.InteriorConvection conMod=
  Buildings.HeatTransfer.Types.InteriorConvection.Temperature
    "Convective heat transfer model for opaque constructions"
    annotation (Dialog(group="Convective heat transfer"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hFixed=3.0
    "Constant convection coefficient for opaque constructions"
    annotation (Dialog(group="Convective heat transfer",
                       enable=(conMod == Buildings.HeatTransfer.Types.InteriorConvection.Fixed)));

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

  parameter Modelica.SIunits.Emissivity tauGlaSol[NConExtWin]
    "Transmissivity of window";

  Fluid.MixingVolumes.MixingVolume vol(V=AFlo*hRoo,
    redeclare package Medium = Medium,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final substanceDynamics=substanceDynamics,
    final traceDynamics=traceDynamics,
    final p_start=p_start,
    final use_T_start=use_T_start,
    final T_start=T_start,
    final h_start=h_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final use_HeatTransfer=true,
    redeclare final model HeatTransfer =
        Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.IdealHeatTransfer,
    final nPorts=nPorts+1) "Room air volume"
    annotation (Placement(transformation(extent={{10,-210},{-10,-190}})));
  // Heat ports that are needed to connect to the window glass
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a glaUns[NConExtWin] if
     haveConExtWin
    "Heat port that connects to room-side surface of unshaded glass"
                              annotation (Placement(transformation(extent={{232,110},
            {252,130}},          rotation=0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a glaSha[NConExtWin] if
       haveShade "Heat port that connects to room-side surface of shaded glass"
                              annotation (Placement(transformation(extent={{232,70},
            {252,90}},           rotation=0)));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
      redeclare each final package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{-40,-10},{40,10}},
      origin={0,-238})));

  Buildings.HeatTransfer.Convection.Interior convConExt[
                                     NConExt](
    final A=AConExt,
    final til =  datConExt.til,
    each conMod=conMod,
    each hFixed=hFixed) if
       haveConExt "Convective heat transfer"
    annotation (Placement(transformation(extent={{120,210},{100,230}})));
  Buildings.HeatTransfer.Convection.Interior convConExtWin[
                                        NConExtWin](
    final A=AConExtWinOpa,
    final til =  datConExtWin.til,
    each conMod=conMod,
    each hFixed=hFixed) if
       haveConExtWin "Convective heat transfer"
    annotation (Placement(transformation(extent={{120,170},{100,190}})));
  HeatTransfer.WindowsBeta.InteriorHeatTransfer convConWin[NConExtWin](
    final fFra=fFra,
    each final linearizeRadiation = linearizeRadiation,
    final haveExteriorShade=haveExteriorShade,
    final haveInteriorShade=haveInteriorShade,
    final A=AConExtWinGla + AConExtWinFra,
    final absIRSha_air=epsConExtWinSha,
    final absIRSha_glass=epsConExtWinUns,
    final tauIRSha_air=tauIRSha_air,
    final tauIRSha_glass=tauIRSha_glass) if
       haveConExtWin "Model for convective heat transfer at window"
    annotation (Placement(transformation(extent={{98,108},{118,128}})));
  // For conPar_a, we use for the tilt pi-tilt since it is the
  // surface that is on the other side of the construction
  Buildings.HeatTransfer.Convection.Interior convConPar_a[
                                       nConPar](
    final A=AConPar,
    final til=Modelica.Constants.pi .- datConPar.til,
    each conMod=conMod,
    each hFixed=hFixed) if
       haveConPar "Convective heat transfer"
    annotation (Placement(transformation(extent={{120,-70},{100,-50}})));
  Buildings.HeatTransfer.Convection.Interior convConPar_b[
                                       nConPar](
    final A=AConPar,
    final til =  datConPar.til,
    each conMod=conMod,
    each hFixed=hFixed) if
       haveConPar "Convective heat transfer"
    annotation (Placement(transformation(extent={{120,-110},{100,-90}})));
  Buildings.HeatTransfer.Convection.Interior convConBou[
                                     nConBou](
    final A=AConBou,
    final til =  datConBou.til,
    each conMod=conMod,
    each hFixed=hFixed) if
       haveConBou "Convective heat transfer"
    annotation (Placement(transformation(extent={{120,-170},{100,-150}})));
  Buildings.HeatTransfer.Convection.Interior convSurBou[
                                     nSurBou](
    final A=ASurBou,
    final til =  surBou.til,
    each conMod=conMod,
    each hFixed=hFixed) if
       haveSurBou "Convective heat transfer"
    annotation (Placement(transformation(extent={{122,-230},{102,-210}})));
protected
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theConConExt(final m=
        nConExt) if
       haveConExt
    "Thermal collector to convert from vector to scalar connector"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={48,220})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theConConExtWin(
      final m=nConExtWin) if
       haveConExtWin
    "Thermal collector to convert from vector to scalar connector"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={48,180})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theConConWin(final m=
        nConExtWin) if
       haveConExtWin
    "Thermal collector to convert from vector to scalar connector"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,120})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theConConPar_a(final m=
        nConPar) if
       haveConPar
    "Thermal collector to convert from vector to scalar connector"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={52,-60})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theConConPar_b(final m=
        nConPar) if
       haveConPar
    "Thermal collector to convert from vector to scalar connector"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,-100})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theConConBou(final m=
        nConBou) if
       haveConBou
    "Thermal collector to convert from vector to scalar connector"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,-160})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theConSurBou(final m=
        nSurBou) if
       haveSurBou
    "Thermal collector to convert from vector to scalar connector"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={52,-220})));
public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorAir
    "Heat port to air volume"
    annotation (Placement(transformation(extent={{-250,-10},{-230,10}})));

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
  final parameter Boolean haveShade = haveExteriorShade[1] or haveInteriorShade[1]
    "Set to true if the windows have a shade";
  final parameter Real fFra[NConExtWin](each min=0, each max=1) = datConExtWin.fFra
    "Fraction of window frame divided by total window area";
  parameter Boolean linearizeRadiation
    "Set to true to linearize emissive power";
  HeatTransfer.Interfaces.RadiosityInflow JInSha[NConExtWin] if
                                       haveShade
    "Incoming radiosity that connects to shaded part of glass"
    annotation (Placement(transformation(extent={{260,30},{240,50}})));

  HeatTransfer.Interfaces.RadiosityOutflow JOutSha[NConExtWin] if
                                         haveShade
    "Outgoing radiosity that connects to shaded part of glass"
    annotation (Placement(transformation(extent={{240,50},{260,70}})));
  HeatTransfer.Interfaces.RadiosityInflow JInUns[NConExtWin] if
     haveConExtWin "Incoming radiosity that connects to unshaded part of glass"
    annotation (Placement(transformation(extent={{258,134},{238,154}})));
  HeatTransfer.Interfaces.RadiosityOutflow JOutUns[NConExtWin] if
     haveConExtWin "Outgoing radiosity that connects to unshaded part of glass"
    annotation (Placement(transformation(extent={{240,150},{260,170}})));

  SolarRadiationExchange solRadExc(
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
    final tauGla=tauGlaSol) if
       haveConExtWin "Solar radiative heat exchange"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));

  InfraredRadiationGainDistribution irRadGai(
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
  InfraredRadiationExchange irRadExc(
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

  Modelica.Blocks.Interfaces.RealInput qGai_flow[3]
    "Radiant, convective and latent heat input into room (positive if heat gain)"
    annotation (Placement(transformation(extent={{-280,80},{-240,120}})));

  Modelica.Blocks.Interfaces.RealInput uSha[NConExtWin](each min=0, each max=1) if
       haveShade
    "Control signal for the shading device (removed if no shade is present)"
    annotation (Placement(transformation(extent={{-280,160},{-240,200}}),
        iconTransformation(extent={{-280,162},{-240,202}})));

  Modelica.Blocks.Interfaces.RealInput QAbsSolSha_flow[NConExtWin](
    final unit="W", quantity="Power") if
       haveConExtWin "Solar radiation absorbed by shade"
    annotation (Placement(transformation(extent={{-280,-220},{-240,-180}})));
  Modelica.Blocks.Interfaces.RealInput JInConExtWin[NConExtWin](final unit="W",
      quantity="Power") if haveConExtWin
    "Solar radiation transmitted from the outside through the glazing system"
    annotation (Placement(transformation(extent={{-280,-120},{-240,-80}}),
        iconTransformation(extent={{-280,-120},{-240,-80}})));

  Modelica.Blocks.Interfaces.RealOutput HOutConExtWin[NConExtWin](unit="W/m2") if
       haveConExtWin "Outgoing solar radiation that strikes window"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-200,-250})));

  HeatGain heaGai(redeclare package Medium = Medium, final AFlo=AFlo)
    "Model to convert internal heat gains"
    annotation (Placement(transformation(extent={{-220,90},{-200,110}})));
protected
  RadiationAdapter radiationAdapter
    annotation (Placement(transformation(extent={{-220,120},{-200,140}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-180,110},{-160,130}})));
public
  RadiationTemperature radTem(
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
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorRad
    "Heat port for radiative heat gain and radiative temperature"
    annotation (Placement(transformation(extent={{-250,-50},{-230,-30}})));
equation
  connect(convConExt.solid, conExt)
                                   annotation (Line(
      points={{120,220},{240,220}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConPar_a.solid, conPar_a)
                                       annotation (Line(
      points={{120,-60},{242,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConPar_b.solid, conPar_b)
                                       annotation (Line(
      points={{120,-100},{242,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConBou.solid, conBou)
                                   annotation (Line(
      points={{120,-160},{242,-160}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convSurBou.solid, conSurBou) annotation (Line(
      points={{122,-220},{241,-220}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConExt.fluid, theConConExt.port_a)
                                                annotation (Line(
      points={{100,220},{58,220}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConPar_a.fluid, theConConPar_a.port_a)
                                                    annotation (Line(
      points={{100,-60},{62,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConPar_b.fluid, theConConPar_b.port_a)
                                                    annotation (Line(
      points={{100,-100},{60,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConBou.fluid, theConConBou.port_a)
                                                annotation (Line(
      points={{100,-160},{60,-160}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convSurBou.fluid, theConSurBou.port_a) annotation (Line(
      points={{102,-220},{62,-220}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theConConExt.port_b,vol. heatPort) annotation (Line(
      points={{38,220},{20,220},{20,-200},{10,-200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theConConExtWin.port_b,vol. heatPort) annotation (Line(
      points={{38,180},{20,180},{20,-200},{10,-200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theConConPar_a.port_b,vol. heatPort) annotation (Line(
      points={{42,-60},{20,-60},{20,-200},{10,-200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theConConPar_b.port_b,vol. heatPort) annotation (Line(
      points={{40,-100},{20,-100},{20,-200},{10,-200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theConConBou.port_b,vol. heatPort) annotation (Line(
      points={{40,-160},{20,-160},{20,-200},{10,-200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theConSurBou.port_b,vol. heatPort) annotation (Line(
      points={{42,-220},{20,-220},{20,-200},{10,-200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.heatPort, heaPorAir)
                                  annotation (Line(
      points={{10,-200},{20,-200},{20,-90},{-150,-90},{-150,0},{-200,0},{-200,
          5.55112e-16},{-240,5.55112e-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConWin.JOutUns, JOutUns)
                                      annotation (Line(
      points={{119,126},{196,126},{196,160},{250,160}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(JInUns, convConWin.JInUns)
                                    annotation (Line(
      points={{248,144},{200,144},{200,124},{119,124}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(convConWin.JOutSha, JOutSha)
                                      annotation (Line(
      points={{119,112},{200,112},{200,60},{250,60}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(convConWin.JInSha, JInSha)
                                    annotation (Line(
      points={{119,110},{196,110},{196,40},{250,40}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(uSha, convConWin.uSha)
                          annotation (Line(
      points={{-260,180},{-220,180},{-220,148},{90,148},{90,126},{97.2,126}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conExt, irRadExc.conExt) annotation (Line(
      points={{240,220},{160,220},{160,19.1667},{-80,19.1667}},
      color={190,0,0},
      smooth=Smooth.None));
  connect(conExtWinFra, irRadExc.conExtWinFra) annotation (Line(
      points={{242,5.55112e-16},{192,5.55112e-16},{192,10},{-79.9167,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conPar_a, irRadExc.conPar_a) annotation (Line(
      points={{242,-60},{188,-60},{188,7.5},{-79.9167,7.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conPar_b, irRadExc.conPar_b) annotation (Line(
      points={{242,-100},{184,-100},{184,6},{180,6},{180,5.83333},{-79.9167,
          5.83333}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(conBou, irRadExc.conBou) annotation (Line(
      points={{242,-160},{180,-160},{180,4},{-79.9167,4},{-79.9167,3.33333}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(conSurBou, irRadExc.conSurBou) annotation (Line(
      points={{241,-220},{176,-220},{176,0},{-79.9583,0},{-79.9583,0.833333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(irRadExc.JOutConExtWin, convConWin.JInRoo)
                                                        annotation (Line(
      points={{-79.5833,15},{86,15},{86,110},{98,110}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(convConWin.JOutRoo, irRadExc.JInConExtWin)
                                                        annotation (Line(
      points={{97.6,114},{84,114},{84,13.3333},{-79.5833,13.3333}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(irRadGai.JOutConExtWin, convConWin.JInRoo)
                                                        annotation (Line(
      points={{-79.5833,-25},{86,-25},{86,110},{98,110}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(irRadGai.conExt, irRadExc.conExt) annotation (Line(
      points={{-80,-20.8333},{-80,-20},{-58,-20},{-58,19.1667},{-80,19.1667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(irRadGai.conExtWinFra, irRadExc.conExtWinFra) annotation (Line(
      points={{-79.9167,-30},{-54,-30},{-54,10},{-79.9167,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(irRadGai.conPar_a, irRadExc.conPar_a) annotation (Line(
      points={{-79.9167,-32.5},{-52,-32.5},{-52,7.5},{-79.9167,7.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(irRadGai.conPar_b, irRadExc.conPar_b) annotation (Line(
      points={{-79.9167,-34.1667},{-50,-34.1667},{-50,5.83333},{-79.9167,
          5.83333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(irRadGai.conBou, irRadExc.conBou) annotation (Line(
      points={{-79.9167,-36.6667},{-54,-36.6667},{-54,-36},{-48,-36},{-48,
          3.33333},{-79.9167,3.33333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(irRadGai.conSurBou, irRadExc.conSurBou) annotation (Line(
      points={{-79.9583,-39.1667},{-46,-39.1667},{-46,0.833333},{-79.9583,
          0.833333}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(irRadGai.uSha, uSha)
                             annotation (Line(
      points={{-100.833,-22.5},{-120,-22.5},{-120,148},{-220,148},{-220,180},{
          -260,180}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaGai.QCon_flow,vol. heatPort) annotation (Line(
      points={{-200,100},{-150,100},{-150,-90},{20,-90},{20,-200},{10,-200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaGai.qGai_flow, qGai_flow) annotation (Line(
      points={{-222,100},{-260,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(convConExtWin.fluid, theConConExtWin.port_a)
                                                annotation (Line(
      points={{100,180},{58,180}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConExtWin.solid, conExtWin)
                                         annotation (Line(
      points={{120,180},{240,180}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExtWin, irRadExc.conExtWin) annotation (Line(
      points={{240,180},{166,180},{166,17.5},{-80,17.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(irRadExc.conExtWin, irRadGai.conExtWin) annotation (Line(
      points={{-80,17.5},{-56,17.5},{-56,-22.5},{-80,-22.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaGai.QLat_flow,vol. ports[nPorts+1]) annotation (Line(
      points={{-200,94},{-180,94},{-180,-220},{-2,-220},{-2,-210},{-7.77156e-16,
          -210}},
      color={0,127,255},
      smooth=Smooth.None));
  for i in 1:nPorts loop
  connect(ports[i],vol. ports[i]) annotation (Line(
      points={{2.22045e-15,-238},{0,-238},{0,-220},{-7.77156e-16,-220},{
            -7.77156e-16,-210}},
      color={0,127,255},
      smooth=Smooth.None));
  end for;
  connect(convConWin.air, theConConWin.port_a)
                                              annotation (Line(
      points={{98,118},{80,118},{80,120},{60,120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theConConWin.port_b,vol. heatPort) annotation (Line(
      points={{40,120},{20,120},{20,-200},{10,-200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(glaUns, convConWin.glaUns)
                                    annotation (Line(
      points={{242,120},{118,120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConWin.glaSha, glaSha)
                                    annotation (Line(
      points={{118,116},{216,116},{216,80},{242,80}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(conExt, solRadExc.conExt) annotation (Line(
      points={{240,220},{160,220},{160,59.1667},{-80,59.1667}},
      color={190,0,0},
      smooth=Smooth.None));
  connect(conExtWinFra, solRadExc.conExtWinFra) annotation (Line(
      points={{242,5.55112e-16},{192,5.55112e-16},{192,50},{-79.9167,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conPar_a, solRadExc.conPar_a) annotation (Line(
      points={{242,-60},{188,-60},{188,48},{-79.9167,48},{-79.9167,47.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conPar_b, solRadExc.conPar_b) annotation (Line(
      points={{242,-100},{184,-100},{184,44},{-79.9167,44},{-79.9167,45.8333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conBou, solRadExc.conBou) annotation (Line(
      points={{242,-160},{180,-160},{180,42},{-79.9167,42},{-79.9167,43.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conSurBou, solRadExc.conSurBou) annotation (Line(
      points={{241,-220},{176,-220},{176,40.8333},{-79.9583,40.8333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExtWin, solRadExc.conExtWin) annotation (Line(
      points={{240,180},{166,180},{166,57.5},{-80,57.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(QAbsSolSha_flow, convConWin.QAbs_flow)
                                               annotation (Line(
      points={{-260,-200},{-210,-200},{-210,80},{108,80},{108,107}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solRadExc.JInConExtWin, JInConExtWin) annotation (Line(
      points={{-79.5833,53.3333},{-74,53.3333},{-74,70},{-220,70},{-220,-100},{
          -260,-100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solRadExc.HOutConExtWin,HOutConExtWin)  annotation (Line(
      points={{-79.5833,55},{-70,55},{-70,76},{-200,76},{-200,-250}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uSha, radTem.uSha) annotation (Line(
      points={{-260,180},{-220,180},{-220,148},{-120,148},{-120,-62.5},{
          -100.833,-62.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(irRadExc.conExt, radTem.conExt) annotation (Line(
      points={{-80,19.1667},{-58,19.1667},{-58,-60.8333},{-80,-60.8333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(irRadExc.conExtWin, radTem.conExtWin) annotation (Line(
      points={{-80,17.5},{-56,17.5},{-56,-62.5},{-80,-62.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(irRadExc.conExtWinFra, radTem.conExtWinFra) annotation (Line(
      points={{-79.9167,10},{-54,10},{-54,-70},{-79.9167,-70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(irRadExc.conPar_a, radTem.conPar_a) annotation (Line(
      points={{-79.9167,7.5},{-52,7.5},{-52,-72.5},{-79.9167,-72.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(irRadExc.conPar_b, radTem.conPar_b) annotation (Line(
      points={{-79.9167,5.83333},{-50,5.83333},{-50,-74.1667},{-79.9167,
          -74.1667}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(irRadExc.conBou, radTem.conBou) annotation (Line(
      points={{-79.9167,3.33333},{-48,3.33333},{-48,-76.6667},{-79.9167,
          -76.6667}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(irRadExc.conSurBou, radTem.conSurBou) annotation (Line(
      points={{-79.9583,0.833333},{-46,0.833333},{-46,-79.1667},{-79.9583,
          -79.1667}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(radTem.glaUns, glaUns) annotation (Line(
      points={{-80,-65},{-8,-65},{-8,-32},{212,-32},{212,120},{242,120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radTem.glaSha, glaSha) annotation (Line(
      points={{-80,-66.6667},{-4,-66.6667},{-4,-36},{216,-36},{216,80},{242,80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConWin.sha, radTem.sha) annotation (Line(
      points={{104.8,108},{104,108},{104,-40},{0,-40},{0,-68},{-80,-68},{-80,
          -68.4167}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(radTem.TRad, radiationAdapter.TRad) annotation (Line(
      points={{-100.417,-77.6667},{-232,-77.6667},{-232,130},{-222,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radiationAdapter.rad, heaPorRad)
                                     annotation (Line(
      points={{-210.2,120},{-210,120},{-210,114},{-226,114},{-226,-40},{-240,-40}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(radiationAdapter.QRad_flow, add.u1) annotation (Line(
      points={{-199,130},{-190,130},{-190,126},{-182,126}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaGai.QRad_flow, add.u2) annotation (Line(
      points={{-199,106},{-190,106},{-190,114},{-182,114}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, irRadGai.Q_flow) annotation (Line(
      points={{-159,120},{-130,120},{-130,-30},{-100.833,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,
           extent={{-240,-240},{240,240}}),
        graphics), Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-300,-300},{300,300}}), graphics={
          Rectangle(
          extent={{-144,184},{148,-200}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Sphere),
        Text(
          extent={{-232,130},{-176,68}},
          lineColor={0,0,127},
          textString="qGai_flow"),
        Text(
          extent={{-230,210},{-174,148}},
          lineColor={0,0,127},
          textString="uSha"),
        Text(
          extent={{-230,-90},{-174,-152}},
          lineColor={0,0,127},
          textString="QTraSW"),
        Text(
          extent={{-230,-168},{-174,-230}},
          lineColor={0,0,127},
          textString="QAbsSW"),
        Text(
          extent={{-104,-230},{-48,-292}},
          lineColor={0,0,127},
          textString="TRad")}),
    Documentation(info="<html>
Model for the heat exchange inside a room.
This model integrates various components that model
heat exchange between the room-facing surfaces of constructions
and the room air, the internal heat gains, and the fluid port that
can be used to connect models of HVAC systems to the room model.
</p>
<p>
The main components that are used in this model are as follows:
<ol>
<li>
The model 
<a href=\"modelica://Buildings.HeatTransfer.Convection\">
Buildings.HeatTransfer.Convection</a>
is used to compute heat convection between the room air
and the surface of opaque constructions.
</li>
<li>
The model 
<a href=\"modelica://Buildings.HeatTransfer.WindowsBeta.InteriorHeatTransfer\">
Buildings.HeatTransfer.WindowsBeta.InteriorHeatTransfer</a>
is used to compute heat convection between the room air
and the surfaces of the window glass, frame and shade.
</li>
<li>
The thermodynamics of the room air is modeled using
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a>
which assumes the room air to be completely mixed.
Depending on the medium model, moisture and species concentrations,
such as CO<sub>2</sub>, can be modeled transiently.
</li>
<li>
The latent heat gain of the room, which is a user-input,
is converted to a moisture source using
the model
<a href=\"modelica://Buildings.RoomsBeta.BaseClasses.HeatGain\">
Buildings.RoomsBeta.BaseClasses.HeatGain</a>.
</li>
<li>
The radiant heat gains in the infrared spectrum are also a user
input. They are distributed to the room enclosing surfaces using
the model
<a href=\"modelica://Buildings.RoomsBeta.BaseClasses.InfraredRadiationGainDistribution\">
Buildings.RoomsBeta.BaseClasses.InfraredRadiationGainDistribution</a>.
</li>
<li>
The infrared radiative heat exchange between the room enclosing
surfaces is modeled in
<a href=\"modelica://Buildings.RoomsBeta.BaseClasses.InfraredRadiationExchange\">
Buildings.RoomsBeta.BaseClasses.InfraredRadiationExchange</a>.
This model takes into account the absorptivity of the surfaces and
the surface area. However, the view factors are assumed to be 
proportional to the area of the receiving surface, without taking
into account the location of the surfaces.
</li>
<li>
The solar radiation exchange is modeled in
<a href=\"modelica://Buildings.RoomsBeta.BaseClasses.SolarRadiationExchange\">
Buildings.RoomsBeta.BaseClasses.SolarRadiationExchange</a>.
The assumptions in this model is that all solar radiation
first hits the floor, and is then partially absorbed and partially reflected by the floor.
The reflectance are diffuse, and the reflected radiation is distributed
in proportion to the product of the receiving areas times their
solar absorptivity.
</li>
</ol>
</p>


</html>", revisions="<html>
<ul>
<li>
November 16 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end MixedAir;
