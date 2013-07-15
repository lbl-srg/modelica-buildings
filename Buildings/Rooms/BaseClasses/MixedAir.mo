within Buildings.Rooms.BaseClasses;
model MixedAir "Model for room air that is completely mixed"
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;
  extends Buildings.Rooms.BaseClasses.PartialSurfaceInterface;

  parameter Modelica.SIunits.Volume V "Volume";

  // Port definitions
  parameter Integer nPorts=1 "Number of fluid ports of this model"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
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

  parameter Boolean homotopyInitialization "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  // Heat ports that are needed to connect to the window glass
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a glaUns[NConExtWin]
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

  // For conPar_a, we use for the tilt pi-tilt since it is the
  // surface that is on the other side of the construction
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
  final parameter Boolean haveShade=
  Modelica.Math.BooleanVectors.anyTrue(haveExteriorShade[:]) or
  Modelica.Math.BooleanVectors.anyTrue(haveInteriorShade[:])
    "Set to true if the windows have a shade";
//  final parameter Real fFra[NConExtWin](each min=0, each max=1) = datConExtWin.fFra
//    "Fraction of window frame divided by total window area";
  parameter Boolean linearizeRadiation
    "Set to true to linearize emissive power";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0)
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
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

  AirHeatMassBalanceMixed con(
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
    conMod=conMod,
    hFixed=hFixed,
    final haveShade=haveShade) "Convective heat and mass balance of air"
    annotation (Placement(transformation(extent={{-12,-142},{12,-118}})));

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

  HeatTransfer.Windows.BaseClasses.ShadeRadiation shaRad[NConExtWin](
    final A=AConExtWinGla,
    final thisSideHasShade=haveInteriorShade,
    final absIR_air=datConExtWin.glaSys.shade.absIR_a,
    final absIR_glass={(datConExtWin[i].glaSys.glass[datConExtWin[i].glaSys.nLay].absIR_b) for i in 1:NConExtWin},
    final tauIR_air=tauIRSha_air,
    final tauIR_glass=tauIRSha_glass,
    each final linearize = linearizeRadiation) if
       haveShade "Radiation model for room-side window shade"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));

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
  HeatTransfer.Windows.BaseClasses.ShadingSignal shaSig[NConExtWin](
    each final haveShade=haveShade) if
       haveConExtWin "Conversion for shading signal"
    annotation (Placement(transformation(extent={{-200,170},{-180,190}})));

  Modelica.Blocks.Math.Sum sumJFroWin[NConExtWin](each nin=if haveShade then 2
         else 1) if
       haveConExtWin "Sum of radiosity fom window to room surfaces"
    annotation (Placement(transformation(extent={{-20,4},{-40,24}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TSha[NConExtWin] if
       haveShade "Temperature of shading device"
    annotation (Placement(transformation(extent={{-20,-80},{-40,-60}})));
equation
  connect(conExt, irRadExc.conExt) annotation (Line(
      points={{240,220},{160,220},{160,60},{-60,60},{-60,20},{-80,20},{-80,
          19.1667}},
      color={190,0,0},
      smooth=Smooth.None));
  connect(conExtWinFra, irRadExc.conExtWinFra) annotation (Line(
      points={{242,5.55112e-16},{160,5.55112e-16},{160,60},{-60,60},{-60,10},{
          -79.9167,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conPar_a, irRadExc.conPar_a) annotation (Line(
      points={{242,-60},{160,-60},{160,60},{-60,60},{-60,8},{-80,8},{-80,7.5},{
          -79.9167,7.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conPar_b, irRadExc.conPar_b) annotation (Line(
      points={{242,-100},{160,-100},{160,60},{-60,60},{-60,5.83333},{-79.9167,
          5.83333}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(conBou, irRadExc.conBou) annotation (Line(
      points={{242,-160},{160,-160},{160,60},{-60,60},{-60,3.33333},{-79.9167,
          3.33333}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(conSurBou, irRadExc.conSurBou) annotation (Line(
      points={{241,-220},{160,-220},{160,60},{-60,60},{-60,0.833333},{-79.9583,
          0.833333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(irRadGai.conExt, conExt) annotation (Line(
      points={{-80,-20.8333},{-80,-20},{-60,-20},{-60,60},{160,60},{160,220},{
          240,220}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(irRadGai.conExtWinFra, conExtWinFra) annotation (Line(
      points={{-79.9167,-30},{-60,-30},{-60,60},{160,60},{160,5.55112e-16},{242,
          5.55112e-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(irRadGai.conPar_a, conPar_a) annotation (Line(
      points={{-79.9167,-32.5},{-60,-32.5},{-60,60},{160,60},{160,-60},{242,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(irRadGai.conPar_b, conPar_b) annotation (Line(
      points={{-79.9167,-34.1667},{-60,-34.1667},{-60,60},{160,60},{160,-100},{
          242,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(irRadGai.conBou, conBou) annotation (Line(
      points={{-79.9167,-36.6667},{-60,-36.6667},{-60,60},{160,60},{160,-160},{
          242,-160}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(irRadGai.conSurBou, conSurBou) annotation (Line(
      points={{-79.9583,-39.1667},{-60,-39.1667},{-60,60},{160,60},{160,-220},{
          241,-220}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(irRadGai.uSha, uSha)
                             annotation (Line(
      points={{-100.833,-22.5},{-120,-22.5},{-120,154},{-220,154},{-220,180},{
          -260,180}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaGai.qGai_flow, qGai_flow) annotation (Line(
      points={{-222,100},{-260,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conExtWin, irRadExc.conExtWin) annotation (Line(
      points={{240,180},{160,180},{160,60},{-60,60},{-60,16},{-80,16},{-80,17.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExtWin, irRadGai.conExtWin) annotation (Line(
      points={{240,180},{160,180},{160,60},{-60,60},{-60,-22},{-70,-22},{-70,
          -22.5},{-80,-22.5}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(conExt, solRadExc.conExt) annotation (Line(
      points={{240,220},{160,220},{160,60},{-80,60},{-80,59.1667}},
      color={190,0,0},
      smooth=Smooth.None));
  connect(conExtWinFra, solRadExc.conExtWinFra) annotation (Line(
      points={{242,5.55112e-16},{160,5.55112e-16},{160,60},{-60,60},{-60,50},{
          -79.9167,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conPar_a, solRadExc.conPar_a) annotation (Line(
      points={{242,-60},{160,-60},{160,60},{-60,60},{-60,48},{-79.9167,48},{
          -79.9167,47.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conPar_b, solRadExc.conPar_b) annotation (Line(
      points={{242,-100},{160,-100},{160,60},{-60,60},{-60,46},{-70,46},{-70,
          45.8333},{-79.9167,45.8333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conBou, solRadExc.conBou) annotation (Line(
      points={{242,-160},{160,-160},{160,60},{-60,60},{-60,43.3333},{-79.9167,
          43.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conSurBou, solRadExc.conSurBou) annotation (Line(
      points={{241,-220},{160,-220},{160,60},{-60,60},{-60,40},{-70,40},{-70,
          40.8333},{-79.9583,40.8333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExtWin, solRadExc.conExtWin) annotation (Line(
      points={{240,180},{160,180},{160,60},{-60,60},{-60,57.5},{-80,57.5}},
      color={191,0,0},
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
      points={{-260,180},{-220,180},{-220,154},{-120,154},{-120,-62.5},{
          -100.833,-62.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conExt, radTem.conExt) annotation (Line(
      points={{240,220},{160,220},{160,60},{-60,60},{-60,-60.8333},{-80,
          -60.8333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExtWin, radTem.conExtWin) annotation (Line(
      points={{240,180},{160,180},{160,60},{-60,60},{-60,-62.5},{-80,-62.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExtWinFra, radTem.conExtWinFra) annotation (Line(
      points={{242,5.55112e-16},{202,5.55112e-16},{202,0},{160,0},{160,60},{-60,
          60},{-60,-70},{-79.9167,-70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conPar_a, radTem.conPar_a) annotation (Line(
      points={{242,-60},{160,-60},{160,60},{-60,60},{-60,-72.5},{-79.9167,-72.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conPar_b, radTem.conPar_b) annotation (Line(
      points={{242,-100},{160,-100},{160,60},{-60,60},{-60,-74.1667},{-79.9167,
          -74.1667}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(conBou, radTem.conBou) annotation (Line(
      points={{242,-160},{160,-160},{160,60},{-60,60},{-60,-76.6667},{-79.9167,
          -76.6667}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(conSurBou, radTem.conSurBou) annotation (Line(
      points={{241,-220},{160,-220},{160,60},{-60,60},{-60,-79.1667},{-79.9583,
          -79.1667}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(radTem.glaUns, glaUns) annotation (Line(
      points={{-80,-65},{-60,-65},{-60,60},{160,60},{160,120},{242,120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radTem.glaSha, glaSha) annotation (Line(
      points={{-80,-66.6667},{-60,-66.6667},{-60,60},{160,60},{160,80},{242,80}},
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
      points={{-260,180},{-202,180}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaSig.y, radShaOut.u) annotation (Line(
      points={{-179,180},{-150,180},{-150,124},{-102,124}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(sumJToWin.y, radShaOut.JIn)
                                 annotation (Line(
      points={{-19,-20},{0,-20},{0,148},{-110,148},{-110,136},{-101,136}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radShaOut.JOut_1, shaRad.JIn_air) annotation (Line(
      points={{-79,136},{-70,136},{-70,96},{-61,96}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radShaOut.JOut_2, JOutUns) annotation (Line(
      points={{-79,124},{-20,124},{-20,160},{250,160}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(shaRad.JOut_glass, JOutSha) annotation (Line(
      points={{-39,96},{20,96},{20,72},{220,72},{220,60},{250,60}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(JInSha, shaRad.JIn_glass) annotation (Line(
      points={{250,40},{214,40},{214,70},{16,70},{16,92},{-39,92}},
      color={0,127,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));

  connect(irRadExc.JInConExtWin, sumJFroWin.y) annotation (Line(
      points={{-79.5833,13.3333},{-46,13.3333},{-46,14},{-41,14}},
      color={0,127,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(shaSig.y, shaRad.u) annotation (Line(
      points={{-179,180},{-150,180},{-150,124},{-110,124},{-110,108},{-61,108}},
      color={0,127,0},
      smooth=Smooth.None));

  connect(shaRad.QSolAbs_flow, QAbsSolSha_flow) annotation (Line(
      points={{-50,89},{-50,86},{-160,86},{-160,-200},{-260,-200}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sumJFroWin.u[1], JInUns) annotation (Line(
      points={{-18,14},{200,14},{200,144},{248,144}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sumJFroWin.u[2], shaRad.JOut_air) annotation (Line(
      points={{-18,14},{-10,14},{-10,40},{-40,40},{-40,64},{-66,64},{-66,92},{
          -61,92}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(radTem.sha, TSha.port) annotation (Line(
      points={{-80,-68.4167},{-64,-68.4167},{-64,-68},{-50,-68},{-50,-70},{-40,
          -70}},
      color={191,0,0},
      smooth=Smooth.None));

  for i in 1:nPorts loop
    connect(ports[i], con.ports[i])
                                  annotation (Line(
      points={{2.22045e-15,-238},{2.22045e-15,-198},{8.88178e-16,-198},{8.88178e-16,
            -141.9}},
      color={0,127,255},
      smooth=Smooth.None));
  end for;
  connect(con.heaPorAir, heaGai.QCon_flow) annotation (Line(
      points={{-12,-130},{-180,-130},{-180,100},{-200,100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaGai.QLat_flow, con.ports[nPorts + 1])
                                                 annotation (Line(
      points={{-200,94},{-186,94},{-186,-170},{8.88178e-16,-170},{8.88178e-16,-141.9}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(con.conExt, conExt) annotation (Line(
      points={{12,-119},{26,-119},{26,-120},{160,-120},{160,220},{240,220}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con.conExtWin, conExtWin) annotation (Line(
      points={{12,-121},{86,-121},{86,-122},{160,-122},{160,180},{240,180}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con.glaUns, glaUns) annotation (Line(
      points={{12,-124},{160,-124},{160,120},{242,120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con.glaSha, glaSha) annotation (Line(
      points={{12,-126},{160,-126},{160,80},{242,80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con.conExtWinFra, conExtWinFra) annotation (Line(
      points={{12.1,-130},{160,-130},{160,4.44089e-16},{242,4.44089e-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con.conPar_a, conPar_a) annotation (Line(
      points={{12.1,-133},{86,-133},{86,-132},{160,-132},{160,-60},{242,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con.conPar_b, conPar_b) annotation (Line(
      points={{12.1,-135},{86,-135},{86,-134},{160,-134},{160,-100},{242,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con.conBou, conBou) annotation (Line(
      points={{12.1,-138},{160,-138},{160,-160},{242,-160}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con.conSurBou, conSurBou) annotation (Line(
      points={{12.05,-141},{86,-141},{86,-142},{160,-142},{160,-220},{241,-220}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con.uSha, uSha) annotation (Line(
      points={{-12.4,-120},{-16,-120},{-16,-112},{6,-112},{6,154},{-220,154},{-220,
          180},{-260,180}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaRad.QRadAbs_flow, con.QRadAbs_flow) annotation (Line(
      points={{-55,89},{-55,72},{4,72},{4,-110},{-20,-110},{-20,-125},{-12.5,-125}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(con.TSha, shaRad.TSha) annotation (Line(
      points={{-12.5,-127},{-22,-127},{-22,-108},{2,-108},{2,70},{-45,70},{-45,89}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(con.heaPorAir, heaPorAir) annotation (Line(
      points={{-12,-130},{-180,-130},{-180,0},{-240,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con.TSha, TSha.T) annotation (Line(
      points={{-12.5,-127},{-22,-127},{-22,-108},{0,-108},{0,-70},{-18,-70}},
      color={0,0,127},
      smooth=Smooth.None));
                           annotation (Diagram(coordinateSystem(preserveAspectRatio=false,
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
<p>
Model for the heat exchange inside a room.
This model integrates various components that model
heat exchange between the room-facing surfaces of constructions
and the room air, the internal heat gains, and the fluid port that
can be used to connect models of HVAC systems to the room model.
</p>
<p>
The main components that are used in this model are as follows:
</p>
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
<a href=\"modelica://Buildings.HeatTransfer.Windows.InteriorHeatTransfer\">
Buildings.HeatTransfer.Windows.InteriorHeatTransfer</a>
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
<a href=\"modelica://Buildings.Rooms.BaseClasses.HeatGain\">
Buildings.Rooms.BaseClasses.HeatGain</a>.
</li>
<li>
The radiant heat gains in the infrared spectrum are also a user
input. They are distributed to the room enclosing surfaces using
the model
<a href=\"modelica://Buildings.Rooms.BaseClasses.InfraredRadiationGainDistribution\">
Buildings.Rooms.BaseClasses.InfraredRadiationGainDistribution</a>.
</li>
<li>
The infrared radiative heat exchange between the room enclosing
surfaces is modeled in
<a href=\"modelica://Buildings.Rooms.BaseClasses.InfraredRadiationExchange\">
Buildings.Rooms.BaseClasses.InfraredRadiationExchange</a>.
This model takes into account the absorptivity of the surfaces and
the surface area. However, the view factors are assumed to be 
proportional to the area of the receiving surface, without taking
into account the location of the surfaces.
</li>
<li>
The solar radiation exchange is modeled in
<a href=\"modelica://Buildings.Rooms.BaseClasses.SolarRadiationExchange\">
Buildings.Rooms.BaseClasses.SolarRadiationExchange</a>.
The assumptions in this model is that all solar radiation
first hits the floor, and is then partially absorbed and partially reflected by the floor.
The reflectance are diffuse, and the reflected radiation is distributed
in proportion to the product of the receiving areas times their
solar absorptivity.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
June 12, 2013, by Michael Wetter:<br/>
Redesigned model to separate convection from radiation, which is
required for the implementation of a CFD model.
</li>
<li>
June 27, 2013, by Michael Wetter:<br/>
Changed model because the outflowing radiosity has been changed to be a non-negative quantity.
See track issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/158\">#158</a>.
</li>
<li>
December 9, 2011, by Michael Wetter:<br/>
Reconnected heat ports to clean-up model.
</li>
<li>
November 29, 2011, by Michael Wetter:<br/>
Added missing connect statement between window frame
surface and window frame convection model. Prior to this bug fix,
no convective heat transfer was computed between window frame and
room air.
Bug fix is due to feedback from Tobias Klingbeil (Fraunhofer ISE).
</li>
<li>
November 16 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MixedAir;
