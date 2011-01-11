within Buildings.RoomsBeta.BaseClasses;
model MixedAir "Model for room air that is completely mixed"
  extends PartialSurfaceInterface;
  extends Buildings.RoomsBeta.BaseClasses.ParameterFluid;
  parameter Modelica.SIunits.Volume V "Volume";

  // Port definitions
  parameter Integer nPorts=0 "Number of fluid ports of this model"
    annotation(Evaluate=true, Dialog(__Dymola_connectorSizing=true, tab="General",group="Ports"));
  parameter Modelica.SIunits.Area AFlo "Floor area";
  parameter Modelica.SIunits.Length hRoo "Average room height";

  parameter Boolean isFloorConExt[NConExt]
    "Flag to indicate if floor for exterior constructions";
  parameter Boolean isFloorConExtWin[NConExtWin]
    "Flag to indicate if floor for constructions";
  parameter Boolean isFloorConPar_a[NConPar]
    "Flag to indicate if floor for constructions";
  parameter Boolean isFloorConPar_b[NConPar]
    "Flag to indicate if floor for constructions";
  parameter Boolean isFloorConBou[NConBou]
    "Flag to indicate if floor for constructions with exterior boundary conditions exposed to outside of room model";
  parameter Boolean isFloorSurBou[NSurBou]
    "Flag to indicate if floor for constructions that are modeled outside of this room";

  parameter Modelica.SIunits.Emissivity tauGlaSW[NConExtWin]
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
    annotation (Placement(transformation(extent={{-150,30},{-170,50}})));
  // Heat ports that are needed to connect to the window glass
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a glaUns[NConExtWin] if
     haveConExtWin
    "Heat port that connects to room-side surface of unshaded glass"
                              annotation (Placement(transformation(extent={{230,110},
            {250,130}},          rotation=0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a glaSha[NConExtWin] if
       haveShade "Heat port that connects to room-side surface of shaded glass"
                              annotation (Placement(transformation(extent={{230,70},
            {250,90}},           rotation=0)));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
      redeclare each final package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{-40,-10},{40,10}},
      origin={0,-238})));
protected
  HeatTransfer.Convection conConExt[NConExt](final A=AConExt) if
       haveConExt "Convective heat transfer"
    annotation (Placement(transformation(extent={{120,210},{100,230}})));
  HeatTransfer.Convection conConExtWin[NConExtWin](final A=AConExtWinOpa) if
       haveConExtWin "Convective heat transfer"
    annotation (Placement(transformation(extent={{120,170},{100,190}})));
  HeatTransfer.WindowsBeta.InteriorHeatTransfer conConWin[NConExtWin](
    final fFra=fFra,
    each final linearize=linearize,
    final haveExteriorShade=haveExteriorShade,
    final haveInteriorShade=haveInteriorShade,
    final A=AConExtWinGla + AConExtWinFra,
    final epsLWSha_air=epsConExtWinSha,
    final epsLWSha_glass=epsConExtWinUns,
    final tauLWSha_air=tauLWSha_air,
    final tauLWSha_glass=tauLWSha_glass) if
       haveConExtWin "Model for convective heat transfer at window"
    annotation (Placement(transformation(extent={{98,108},{118,128}})));

  HeatTransfer.Convection conConPar_a[nConPar](final A=AConPar) if
       haveConPar "Convective heat transfer"
    annotation (Placement(transformation(extent={{120,-70},{100,-50}})));
  HeatTransfer.Convection conConPar_b[nConPar](final A=AConPar) if
       haveConPar "Convective heat transfer"
    annotation (Placement(transformation(extent={{120,-110},{100,-90}})));
  HeatTransfer.Convection conConBou[nConBou](final A=AConBou) if
       haveConBou "Convective heat transfer"
    annotation (Placement(transformation(extent={{120,-150},{100,-130}})));
  HeatTransfer.Convection conSurBou[nSurBou](final A=ASurBou) if
       haveSurBou "Convective heat transfer"
    annotation (Placement(transformation(extent={{120,-210},{100,-190}})));
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
        origin={50,-140})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theConSurBou(final m=
        nSurBou) if
       haveSurBou
    "Thermal collector to convert from vector to scalar connector"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,-200})));
public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat port to air volume"
    annotation (Placement(transformation(extent={{-252,-10},{-232,10}})));

  parameter Modelica.SIunits.TransmissionCoefficient tauLWSha_air[NConExtWin]
    "Long wave transmissivity of shade for radiation coming from the exterior or the room"
    annotation (Dialog(group="Shading"));
  parameter Modelica.SIunits.TransmissionCoefficient tauLWSha_glass[NConExtWin]
    "Long wave transmissivity of shade for radiation coming from the glass"
    annotation (Dialog(group="Shading"));

  parameter Boolean haveExteriorShade[NConExtWin]
    "Set to true if window has exterior shade (at surface a)"
    annotation (Dialog(group="Shading"));
  parameter Boolean haveInteriorShade[NConExtWin]
    "Set to true if window has interior shade (at surface b)"
    annotation (Dialog(group="Shading"));
  final parameter Boolean haveShade = haveExteriorShade[1] or haveInteriorShade[1]
    "Set to true if the windows have a shade";
  parameter Real fFra[NConExtWin](each min=0, each max=1)
    "Fraction of window frame divided by total window area";
  parameter Boolean linearize "Set to true to linearize emissive power";
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

  ShortWaveRadiationExchange shoWavRadExc(
    final nConExt=nConExt,
    final nConExtWin=nConExtWin,
    final nConPar=nConPar,
    final nConBou=nConBou,
    final nSurBou=nSurBou,
    final AConExt=AConExt,
    final AConExtWinOpa=AConExtWinOpa,
    final AConExtWinGla=AConExtWinGla,
    final AConExtWinFra=AConExtWinFra,
    final AConPar=AConPar,
    final AConBou=AConBou,
    final ASurBou=ASurBou,
    final epsConExt=epsConExt,
    final epsConExtWinOpa=epsConExtWinOpa,
    final epsConExtWinUns=epsConExtWinUns,
    final epsConExtWinSha=epsConExtWinSha,
    final epsConExtWinFra=epsConExtWinFra,
    final epsConPar_a=epsConPar_a,
    final epsConPar_b=epsConPar_b,
    final epsConBou=epsConBou,
    final epsSurBou=epsSurBou,
    final isFloorConExt=isFloorConExt,
    final isFloorConExtWin=isFloorConExtWin,
    final isFloorConPar_a=isFloorConPar_a,
    final isFloorConPar_b=isFloorConPar_b,
    final isFloorConBou=isFloorConBou,
    final isFloorSurBou=isFloorSurBou,
    final tauGla=tauGlaSW) "Short wave radiative heat exchange"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

  LongWaveRadiationGainDistribution lonWavRadGai(
    final nConExt=nConExt,
    final nConExtWin=nConExtWin,
    final nConPar=nConPar,
    final nConBou=nConBou,
    final nSurBou=nSurBou,
    final AConExt=AConExt,
    final AConExtWinOpa=AConExtWinOpa,
    final AConExtWinGla=AConExtWinGla,
    final AConExtWinFra=AConExtWinFra,
    final AConPar=AConPar,
    final AConBou=AConBou,
    final ASurBou=ASurBou,
    final epsConExt=epsConExt,
    final epsConExtWinOpa=epsConExtWinOpa,
    final epsConExtWinUns=epsConExtWinUns,
    final epsConExtWinSha=epsConExtWinSha,
    final epsConExtWinFra=epsConExtWinFra,
    final epsConPar_a=epsConPar_a,
    final epsConPar_b=epsConPar_b,
    final epsConBou=epsConBou,
    final epsSurBou=epsSurBou)
    "Distribution for long wave radiative heat gains (e.g., due to equipment and people)"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  LongWaveRadiationExchange lonWavRadExc(
    final nConExt=nConExt,
    final nConExtWin=nConExtWin,
    final nConPar=nConPar,
    final nConBou=nConBou,
    final nSurBou=nSurBou,
    final AConExt=AConExt,
    final AConExtWinOpa=AConExtWinOpa,
    final AConExtWinGla=AConExtWinGla,
    final AConExtWinFra=AConExtWinFra,
    final AConPar=AConPar,
    final AConBou=AConBou,
    final ASurBou=ASurBou,
    final epsConExt=epsConExt,
    final epsConExtWinOpa=epsConExtWinOpa,
    final epsConExtWinUns=epsConExtWinUns,
    final epsConExtWinSha=epsConExtWinSha,
    final epsConExtWinFra=epsConExtWinFra,
    final epsConPar_a=epsConPar_a,
    final epsConPar_b=epsConPar_b,
    final epsConBou=epsConBou,
    final epsSurBou=epsSurBou,
    linearize=linearize) "Long wave radiative heat exchange"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Modelica.Blocks.Interfaces.RealInput qGai_flow[3]
    "Radiant, convective and latent heat input into room (positive if heat gain)"
    annotation (Placement(transformation(extent={{-280,80},{-240,120}})));

  Modelica.Blocks.Interfaces.RealInput uSha[NConExtWin](each min=0, each max=1)
    "Control signal for the shading device (removed if no shade is present)"
    annotation (Placement(transformation(extent={{-280,160},{-240,200}}),
        iconTransformation(extent={{-280,162},{-240,202}})));

  Modelica.Blocks.Interfaces.RealInput QAbsSWSha_flow[NConExtWin](
    final unit="W", quantity="Power") "Solar radiation absorbed by shade"
    annotation (Placement(transformation(extent={{-280,-220},{-240,-180}})));
  Modelica.Blocks.Interfaces.RealInput JInConExtWin[NConExtWin](final unit="W",
      quantity="Power")
    "Solar radiation transmitted from the outside through the glazing system"
    annotation (Placement(transformation(extent={{-280,-120},{-240,-80}}),
        iconTransformation(extent={{-280,-120},{-240,-80}})));

  Modelica.Blocks.Interfaces.RealOutput HOutConExtWin[NConExtWin](unit="W/m2")
    "Outgoing short wave radiation that strikes window"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-200,-250})));

  HeatGain heaGai(redeclare package Medium = Medium, final AFlo=AFlo)
    "Model to convert internal heat gains"
    annotation (Placement(transformation(extent={{-200,-60},{-180,-40}})));
protected
  Buildings.HeatTransfer.Radiosity.Constant zerJ1(
                                        k=0) if
     not haveConExtWin "Radiosity signal, only needed if no window is present"
    annotation (Placement(transformation(extent={{-60,190},{-40,210}})));
  Buildings.HeatTransfer.Radiosity.Constant zerJ2(
                                        k=0) if
     not haveConExtWin "Radiosity signal, only needed if no window is present"
    annotation (Placement(transformation(extent={{-60,160},{-40,180}})));
equation
  connect(conConExt.solid, conExt) annotation (Line(
      points={{120,220},{240,220}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConPar_a.solid, conPar_a) annotation (Line(
      points={{120,-60},{242,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConPar_b.solid, conPar_b) annotation (Line(
      points={{120,-100},{242,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConBou.solid, conBou) annotation (Line(
      points={{120,-140},{180,-140},{180,-160},{242,-160}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conSurBou.solid, surBou) annotation (Line(
      points={{120,-200},{180.5,-200},{180.5,-220},{241,-220}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConExt.fluid, theConConExt.port_a) annotation (Line(
      points={{100,220},{58,220}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConPar_a.fluid, theConConPar_a.port_a) annotation (Line(
      points={{100,-60},{62,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConPar_b.fluid, theConConPar_b.port_a) annotation (Line(
      points={{100,-100},{60,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConBou.fluid, theConConBou.port_a) annotation (Line(
      points={{100,-140},{60,-140}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conSurBou.fluid, theConSurBou.port_a) annotation (Line(
      points={{100,-200},{60,-200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theConConExt.port_b,vol. heatPort) annotation (Line(
      points={{38,220},{20,220},{20,40},{-150,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theConConExtWin.port_b,vol. heatPort) annotation (Line(
      points={{38,180},{20,180},{20,40},{-150,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theConConPar_a.port_b,vol. heatPort) annotation (Line(
      points={{42,-60},{20,-60},{20,40},{-150,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theConConPar_b.port_b,vol. heatPort) annotation (Line(
      points={{40,-100},{20,-100},{20,40},{-150,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theConConBou.port_b,vol. heatPort) annotation (Line(
      points={{40,-140},{20,-140},{20,40},{-150,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theConSurBou.port_b,vol. heatPort) annotation (Line(
      points={{40,-200},{20,-200},{20,40},{-150,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.heatPort, heatPort) annotation (Line(
      points={{-150,40},{-140,40},{-140,0},{-200,0},{-200,5.55112e-16},{-242,
          5.55112e-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConWin.JOutUns, JOutUns) annotation (Line(
      points={{119,126},{130,126},{130,160},{250,160}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(JInUns, conConWin.JInUns) annotation (Line(
      points={{248,144},{190,144},{190,124},{119,124}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(conConWin.JOutSha, JOutSha) annotation (Line(
      points={{119,112},{134,112},{134,60},{250,60}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(conConWin.JInSha, JInSha) annotation (Line(
      points={{119,110},{132,110},{132,40},{250,40}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(uSha, conConWin.uSha)
                          annotation (Line(
      points={{-260,180},{-220,180},{-220,148},{90,148},{90,126},{97.2,126}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conExt, lonWavRadExc.conExt) annotation (Line(
      points={{240,220},{160,220},{160,19.1667},{-80,19.1667}},
      color={190,0,0},
      smooth=Smooth.None));
  connect(conExtWinFra, lonWavRadExc.conExtWinFra) annotation (Line(
      points={{242,5.55112e-16},{180,5.55112e-16},{180,12},{-79.9167,12},{
          -79.9167,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conPar_a, lonWavRadExc.conPar_a) annotation (Line(
      points={{242,-60},{172,-60},{172,7.5},{-79.9167,7.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conPar_b, lonWavRadExc.conPar_b) annotation (Line(
      points={{242,-100},{166,-100},{166,-26},{-8,-26},{-8,5.83333},{-79.9167,
          5.83333}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(conBou, lonWavRadExc.conBou) annotation (Line(
      points={{242,-160},{160,-160},{160,-34},{-12,-34},{-12,3.33333},{-79.9167,
          3.33333}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(surBou, lonWavRadExc.surBou) annotation (Line(
      points={{241,-220},{154,-220},{154,-40},{-16,-40},{-16,0.833333},{
          -79.9583,0.833333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(lonWavRadExc.JOutConExtWin, conConWin.JInRoo) annotation (Line(
      points={{-79.5833,15},{86,15},{86,110},{98,110}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(conConWin.JOutRoo, lonWavRadExc.JInConExtWin) annotation (Line(
      points={{97.6,114},{84,114},{84,13.3333},{-79.5833,13.3333}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(lonWavRadGai.JOutConExtWin, conConWin.JInRoo) annotation (Line(
      points={{-79.5833,-25},{86,-25},{86,110},{98,110}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(lonWavRadGai.conExt, lonWavRadExc.conExt) annotation (Line(
      points={{-80,-20.8333},{-80,-20},{-58,-20},{-58,19.1667},{-80,19.1667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(lonWavRadGai.conExtWinFra, lonWavRadExc.conExtWinFra) annotation (Line(
      points={{-79.9167,-30},{-54,-30},{-54,10},{-79.9167,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(lonWavRadGai.conPar_a, lonWavRadExc.conPar_a) annotation (Line(
      points={{-79.9167,-32.5},{-52,-32.5},{-52,7.5},{-79.9167,7.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(lonWavRadGai.conPar_b, lonWavRadExc.conPar_b) annotation (Line(
      points={{-79.9167,-34.1667},{-50,-34.1667},{-50,5.83333},{-79.9167,
          5.83333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(lonWavRadGai.conBou, lonWavRadExc.conBou) annotation (Line(
      points={{-79.9167,-36.6667},{-54,-36.6667},{-54,-36},{-48,-36},{-48,
          3.33333},{-79.9167,3.33333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(lonWavRadGai.surBou, lonWavRadExc.surBou) annotation (Line(
      points={{-79.9583,-39.1667},{-46,-39.1667},{-46,0.833333},{-79.9583,
          0.833333}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(lonWavRadGai.uSha, uSha)
                             annotation (Line(
      points={{-100.833,-22.5},{-120,-22.5},{-120,148},{-220,148},{-220,180},{
          -260,180}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lonWavRadGai.Q_flow, heaGai.QRad_flow) annotation (Line(
      points={{-100.833,-30},{-170,-30},{-170,-44},{-179,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaGai.QCon_flow,vol. heatPort) annotation (Line(
      points={{-180,-50},{-140,-50},{-140,40},{-150,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaGai.qGai_flow, qGai_flow) annotation (Line(
      points={{-202,-50},{-212,-50},{-212,100},{-260,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conConExtWin.fluid, theConConExtWin.port_a)
                                                annotation (Line(
      points={{100,180},{58,180}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConExtWin.solid, conExtWin) annotation (Line(
      points={{120,180},{240,180}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExtWin, lonWavRadExc.conExtWin) annotation (Line(
      points={{240,180},{166,180},{166,17.5},{-80,17.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(lonWavRadExc.conExtWin, lonWavRadGai.conExtWin) annotation (Line(
      points={{-80,17.5},{-56,17.5},{-56,-22.5},{-80,-22.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaGai.QLat_flow,vol. ports[nPorts+1]) annotation (Line(
      points={{-180,-56},{-160,-56},{-160,30}},
      color={0,127,255},
      smooth=Smooth.None));
  for i in 1:nPorts loop
  connect(ports[i],vol. ports[i]) annotation (Line(
      points={{2.22045e-15,-238},{0,-238},{0,-180},{-160,-180},{-160,30}},
      color={0,127,255},
      smooth=Smooth.None));
  end for;
  connect(conConWin.air, theConConWin.port_a) annotation (Line(
      points={{98,118},{80,118},{80,120},{60,120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theConConWin.port_b,vol. heatPort) annotation (Line(
      points={{40,120},{20,120},{20,40},{-150,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(glaUns, conConWin.glaUns) annotation (Line(
      points={{240,120},{118,120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConWin.glaSha, glaSha) annotation (Line(
      points={{118,116},{180,116},{180,80},{240,80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(zerJ1.JOut, JOutUns[1]) annotation (Line(
      points={{-39,200},{-20,200},{-20,160},{250,160}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(zerJ2.JOut, lonWavRadExc.JInConExtWin[1]) annotation (Line(
      points={{-39,170},{-30,170},{-30,13.3333},{-79.5833,13.3333}},
      color={0,127,0},
      smooth=Smooth.None));

  connect(conExt, shoWavRadExc.conExt) annotation (Line(
      points={{240,220},{160,220},{160,79.1667},{-80,79.1667}},
      color={190,0,0},
      smooth=Smooth.None));
  connect(conExtWinFra, shoWavRadExc.conExtWinFra) annotation (Line(
      points={{242,5.55112e-16},{180,5.55112e-16},{180,70},{-79.9167,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conPar_a, shoWavRadExc.conPar_a) annotation (Line(
      points={{242,-60},{172,-60},{172,67.5},{-79.9167,67.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conPar_b, shoWavRadExc.conPar_b) annotation (Line(
      points={{242,-100},{166,-100},{166,66},{-79.9167,66},{-79.9167,65.8333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conBou, shoWavRadExc.conBou) annotation (Line(
      points={{242,-160},{160,-160},{160,64},{-79.9167,64},{-79.9167,63.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(surBou, shoWavRadExc.surBou) annotation (Line(
      points={{241,-220},{154,-220},{154,60.8333},{-79.9583,60.8333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExtWin, shoWavRadExc.conExtWin) annotation (Line(
      points={{240,180},{166,180},{166,77.5},{-80,77.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(QAbsSWSha_flow, conConWin.QAbs_flow) annotation (Line(
      points={{-260,-200},{10,-200},{10,88},{108,88},{108,107}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shoWavRadExc.JInConExtWin, JInConExtWin) annotation (Line(
      points={{-79.5833,73.3333},{-74,73.3333},{-74,90},{-220,90},{-220,-100},{
          -260,-100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shoWavRadExc.HOutConExtWin,HOutConExtWin)  annotation (Line(
      points={{-79.5833,75},{-72,75},{-72,86},{-208,86},{-208,-220},{-200,-220},
          {-200,-250}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-240,-240},
            {240,240}}),       graphics), Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-240,-240},{240,240}}), graphics={
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
          textString="QAbsSW")}),
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
The radiant heat gains in the long-wave spectrum are also a user
input. They are distributed to the room enclosing surfaces using
the model
<a href=\"modelica://Buildings.RoomsBeta.BaseClasses.LongWaveRadiationGainDistribution\">
Buildings.RoomsBeta.BaseClasses.LongWaveRadiationGainDistribution</a>.
</li>
<li>
The long-wave radiative heat exchange between the room enclosing
surfaces is modeled in
<a href=\"modelica://Buildings.RoomsBeta.BaseClasses.LongWaveRadiationExchange\">
Buildings.RoomsBeta.BaseClasses.LongWaveRadiationExchange</a>.
This model takes into account the emissivity of the surfaces and
the surface area. However, the view factors are assumed to be 
proportional to the area of the receiving surface, without taking
into account the location of the surfaces.
</li>
<li>
The short wave radiation exchange is modeled in
<a href=\"modelica://Buildings.RoomsBeta.BaseClasses.ShortWaveRadiationExchange\">
Buildings.RoomsBeta.BaseClasses.ShortWaveRadiationExchange</a>.
The assumptions in this model is that all solar radiation
first hits the floor, and is then partially absorbed and partially reflected by the floor.
The reflectance are diffuse, and the reflected radiation is distributed
in proportion to the product of the receiving areas times their
short wave emissivity.
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
