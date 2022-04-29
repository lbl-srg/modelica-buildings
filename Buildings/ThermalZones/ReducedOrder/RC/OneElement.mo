within Buildings.ThermalZones.ReducedOrder.RC;
model OneElement "Thermal Zone with one element for exterior walls"
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations(
    final massDynamics=energyDynamics);

  parameter Modelica.Units.SI.Volume VAir "Air volume of the zone"
    annotation (Dialog(group="Thermal zone"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hRad
    "Coefficient of heat transfer for linearized radiation exchange between walls"
    annotation (Dialog(group="Thermal zone"));
  parameter Integer nOrientations(min=1) "Number of orientations"
    annotation(Dialog(group="Thermal zone"));
  parameter Integer nPorts=0 "Number of fluid ports"
    annotation(Evaluate=true,
    Dialog(connectorSizing=true, tab="General",group="Ports"));
  parameter Modelica.Units.SI.Area AWin[nOrientations]
    "Vector of areas of windows by orientations"
    annotation (Dialog(group="Windows"));
  parameter Modelica.Units.SI.Area ATransparent[nOrientations] "Vector of areas of transparent (solar radiation transmittend) elements by
    orientations" annotation (Dialog(group="Windows"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hConWin
    "Convective coefficient of heat transfer of windows (indoor)"
    annotation (Dialog(group="Windows"));
  parameter Modelica.Units.SI.ThermalResistance RWin "Resistor for windows"
    annotation (Dialog(group="Windows"));
  parameter Modelica.Units.SI.TransmissionCoefficient gWin
    "Total energy transmittance of windows" annotation (Dialog(group="Windows"));
  parameter Real ratioWinConRad
    "Ratio for windows between indoor convective and radiative heat emission"
    annotation(Dialog(group="Windows"));
  parameter Boolean indoorPortWin = false
    "Additional heat port at indoor surface of windows"
    annotation(Dialog(group="Windows"),choices(checkBox = true));
  parameter Modelica.Units.SI.Area AExt[nOrientations]
    "Vector of areas of exterior walls by orientations"
    annotation (Dialog(group="Exterior walls"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hConExt
    "Convective coefficient of heat transfer of exterior walls (indoor)"
    annotation (Dialog(group="Exterior walls"));
  parameter Integer nExt(min = 1) "Number of RC-elements of exterior walls"
    annotation(Dialog(group="Exterior walls"));
  parameter Modelica.Units.SI.ThermalResistance RExt[nExt](each min=Modelica.Constants.small)
    "Vector of resistances of exterior walls, from inside to outside"
    annotation (Dialog(group="Exterior walls"));
  parameter Modelica.Units.SI.ThermalResistance RExtRem(min=Modelica.Constants.small)
    "Resistance of remaining resistor RExtRem between capacity n and outside"
    annotation (Dialog(group="Exterior walls"));
  parameter Modelica.Units.SI.HeatCapacity CExt[nExt](each min=Modelica.Constants.small)
    "Vector of heat capacities of exterior walls, from inside to outside"
    annotation (Dialog(group="Exterior walls"));
  parameter Boolean indoorPortExtWalls = false
    "Additional heat port at indoor surface of exterior walls"
    annotation(Dialog(group="Exterior walls"),choices(checkBox = true));
  parameter Boolean use_moisture_balance = false
    "If true, input connector QLat_flow is enabled and room air computes moisture balance"
    annotation(choices(checkBox = true));

  parameter Boolean use_C_flow = false
    "Set to true to enable input connector for trace substance"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  Modelica.Blocks.Interfaces.RealInput solRad[nOrientations](
    each final quantity="RadiantEnergyFluenceRate",
    each final unit="W/m2") if sum(ATransparent) > 0
    "Solar radiation transmitted through windows"
    annotation (
    Placement(transformation(extent={{-280,120},{-240,160}}),
    iconTransformation(extent={{-260,140},{-240,160}})));

  Modelica.Blocks.Interfaces.RealInput QLat_flow(final unit="W")
 if use_moisture_balance and ATot >0
    "Latent heat gains for the room"
    annotation (Placement(transformation(extent={{-280,-150},{-240,-110}}),
        iconTransformation(extent={{-260,-130},{-240,-110}})));

  Modelica.Blocks.Interfaces.RealOutput TAir(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") if ATot > 0 or VAir > 0 "Indoor air temperature"
    annotation (Placement(transformation(extent={{240,150},{260,170}}),
    iconTransformation(extent={{240,150},{260,170}})));

  Modelica.Blocks.Interfaces.RealOutput TRad(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") if ATot > 0 "Mean indoor radiation temperature"
    annotation (Placement(transformation(extent={{240,110},{260,130}}),
    iconTransformation(extent={{240,110},{260,130}})));

  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
    redeclare each final package Medium = Medium)
    "Auxiliary fluid inlets and outlets to indoor air volume"
    annotation (
    Placement(transformation(
    extent={{-45,-12},{45,12}},
    origin={85,-180}),iconTransformation(
    extent={{-30.5,-8},{30.5,8}},
    origin={150,-179.5})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a extWall if ATotExt > 0
    "Ambient port for exterior walls"
    annotation (Placement(transformation(
    extent={{-250,-50},{-230,-30}}), iconTransformation(extent={{-250,-50},{
            -230,-30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a window if ATotWin > 0
    "Ambient port for windows"
    annotation (Placement(transformation(extent={{-250,30},{-230,50}}),
    iconTransformation(extent={{-250,30},{-230,50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a intGainsConv
 if ATot > 0 or VAir > 0
    "Auxiliary port for sensible internal convective gains"
    annotation (Placement(
    transformation(extent={{230,30},{250,50}}), iconTransformation(extent={{230,30},
    {250,50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a intGainsRad if ATot > 0
    "Auxiliary port for internal radiative gains"
    annotation (Placement(
    transformation(extent={{230,70},{250,90}}),
    iconTransformation(extent={{230,70},{250,90}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a windowIndoorSurface
 if indoorPortWin "Auxiliary port at indoor surface of windows"
    annotation (Placement(transformation(extent={{-210,-190},{-190,-170}}),
    iconTransformation(extent={{-210,-190},{-190,-170}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a extWallIndoorSurface
 if indoorPortExtWalls "Auxiliary port at indoor surface of exterior walls"
    annotation (Placement(
    transformation(extent={{-170,-190},{-150,-170}}), iconTransformation(
    extent={{-170,-190},{-150,-170}})));

  Fluid.MixingVolumes.MixingVolume volAir(
    redeclare final package Medium = Medium,
    final nPorts=nPorts,
    m_flow_nominal=VAir*6/3600*1.2,
    final V=VAir,
    final energyDynamics=energyDynamics,
    final massDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    final use_C_flow=use_C_flow) if VAir > 0 and not use_moisture_balance
    "Indoor air volume"
    annotation (Placement(transformation(extent={{42,-26},{22,-6}})));
  Fluid.MixingVolumes.MixingVolumeMoistAir volMoiAir(
    redeclare final package Medium = Medium,
    final nPorts=nPorts,
    m_flow_nominal=VAir*6/3600*1.2,
    final V=VAir,
    final energyDynamics=energyDynamics,
    final massDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    final use_C_flow=use_C_flow) if VAir > 0 and use_moisture_balance
    "Indoor air volume"
    annotation (Placement(transformation(extent={{-20,-26},{0,-6}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor resWin(final R=RWin)
 if ATotWin > 0 "Resistor for windows"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow convHeatSol(
    final alpha=0)
 if ratioWinConRad > 0 and (ATot > 0 or VAir > 0) and sum(ATransparent) > 0
    "Solar heat considered as convection"
    annotation (Placement(transformation(extent={{-166,114},{-146,134}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow radHeatSol[
    nOrientations](each final alpha=0) if ATot > 0 and sum(ATransparent) > 0
    "Solar heat considered as radiation"
    annotation (Placement(transformation(extent={{-166,136},{-146,156}})));
  BaseClasses.ThermSplitter thermSplitterIntGains(
    final splitFactor=splitFactor,
    final nOut=dimension,
    final nIn=1) if ATot > 0
    "Splits incoming internal gains into separate gains for each wall element,
    weighted by their area"
    annotation (Placement(transformation(extent={{210,76},{190,96}})));
  BaseClasses.ThermSplitter thermSplitterSolRad(
    final splitFactor=splitFactorSolRad,
    final nOut=dimension,
    final nIn=nOrientations) if ATot > 0 and sum(ATransparent) > 0
    "Splits incoming solar radiation into separate gains for each wall element,
    weighted by their area"
    annotation (Placement(transformation(extent={{-138,138},{-122,154}})));
  BaseClasses.ExteriorWall extWallRC(
    final n=nExt,
    final RExt=RExt,
    final CExt=CExt,
    final RExtRem=RExtRem,
    final T_start=T_start) if ATotExt > 0 "RC-element for exterior walls"
    annotation (Placement(transformation(extent={{-158,-50},{-178,-28}})));

  Modelica.Blocks.Interfaces.RealInput[Medium.nC] C_flow if use_C_flow
    "Trace substance mass flow rate added to the thermal zone"
    annotation (Placement(transformation(extent={{-280,70},{-240,110}}), iconTransformation(extent={{-260,90},{-240,110}})));

protected
  constant Modelica.Units.SI.SpecificEnergy h_fg=
      Buildings.Media.Air.enthalpyOfCondensingGas(273.15 + 37)
    "Latent heat of water vapor";
  parameter Modelica.Units.SI.Area ATot=sum(AArray) "Sum of wall surface areas";
  parameter Modelica.Units.SI.Area ATotExt=sum(AExt)
    "Sum of exterior wall surface areas";
  parameter Modelica.Units.SI.Area ATotWin=sum(AWin)
    "Sum of window surface areas";
  parameter Modelica.Units.SI.Area[:] AArray={ATotExt,ATotWin}
    "List of all wall surface areas";
  parameter Integer dimension = sum({if A>0 then 1 else 0 for A in AArray})
    "Number of non-zero wall surface areas";
  parameter Real splitFactor[dimension, 1]=
    BaseClasses.splitFacVal(dimension, 1, AArray, fill(0, 1), fill(0, 1))
    "Share of each wall surface area that is non-zero";
  parameter Real splitFactorSolRad[dimension, nOrientations]=
    BaseClasses.splitFacVal(dimension, nOrientations, AArray, AExt, AWin)
    "Share of each wall surface area that is non-zero, for each orientation separately";
  Modelica.Thermal.HeatTransfer.Components.Convection convExtWall(dT(start=0))
                                                                  if ATotExt > 0
    "Convective heat transfer of exterior walls"
    annotation (Placement(transformation(extent={{-114,-30},{-94,-50}})));
  Modelica.Blocks.Sources.Constant hConExtWall_const(
  final k=ATotExt*hConExt) if ATotExt > 0
    "Coefficient of convective heat transfer for exterior walls"
    annotation (Placement(transformation(
    extent={{5,-5},{-5,5}},
    rotation=-90,
    origin={-104,-61})));
  Modelica.Thermal.HeatTransfer.Components.Convection convWin if ATotWin > 0
    "Convective heat transfer of windows"
    annotation (Placement(transformation(extent={{-116,30},{-96,50}})));
  Modelica.Blocks.Sources.Constant hConWin_const(final k=ATotWin*hConWin)
    "Coefficient of convective heat transfer for windows"
    annotation (Placement(transformation(
    extent={{-6,-6},{6,6}},
    rotation=-90,
    origin={-106,68})));
  Modelica.Blocks.Math.Gain eRadSol[nOrientations](
    final k=gWin*(1 - ratioWinConRad)*ATransparent) if sum(ATransparent) > 0
    "Emission coefficient of solar radiation considered as radiation"
    annotation (Placement(transformation(extent={{-206,141},{-196,151}})));
  Modelica.Blocks.Math.Gain eConvSol[nOrientations](
    final k=gWin*ratioWinConRad*ATransparent)
 if ratioWinConRad > 0 and sum(ATransparent) > 0
    "Emission coefficient of solar radiation considered as convection"
    annotation (Placement(transformation(extent={{-206,119},{-196,129}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor resExtWallWin(
      final G=min(ATotExt, ATotWin)*hRad) if ATotExt > 0 and ATotWin > 0
    "Resistor between exterior walls and windows"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-146,10})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTAir
 if ATot > 0 or VAir > 0 "Indoor air temperature sensor"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTRad
 if ATot > 0 "Mean indoor radiation temperatur sensor"
    annotation (Placement(
    transformation(
    extent={{-10,-10},{10,10}},
    rotation=90,
    origin={210,110})));
  Modelica.Blocks.Math.Sum sumSolRad(final nin=nOrientations)
 if ratioWinConRad > 0 and sum(ATransparent) > 0
    "Sums up solar radiation from different directions"
    annotation (Placement(transformation(extent={{-186,118},{-174,130}})));

  Modelica.Blocks.Math.Gain mWat_flow(
    final k(unit="kg/J") = 1/h_fg,
    u(final unit="W"),
    y(final unit="kg/s"))
    if use_moisture_balance and ATot >0 "Water flow rate due to latent heat gain"
    annotation (Placement(transformation(extent={{-200,-100},{-180,-80}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow conQLat_flow
 if use_moisture_balance and ATot >0
    "Converter for latent heat flow rate"
    annotation (Placement(transformation(extent={{-202,-130},{-182,-110}})));
equation
  connect(volAir.ports, ports)
    annotation (Line(
      points={{32,-26},{32,-46},{86,-46},{86,-180},{85,-180}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(volMoiAir.ports, ports) annotation (Line(
      points={{-10,-26},{-10,-46},{86,-46},{86,-180},{85,-180}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(resWin.port_a, window)
    annotation (Line(
    points={{-180,40},{-240,40}},
    color={191,0,0},
    smooth=Smooth.None));
  connect(resWin.port_b, convWin.solid)
    annotation (Line(
    points={{-160,40},{-116,40}},
    color={191,0,0},
    smooth=Smooth.None));
  connect(eRadSol.y, radHeatSol.Q_flow)
    annotation (Line(
    points={{-195.5,146},{-166,146}},
    color={0,0,127},
    smooth=Smooth.None));
  connect(thermSplitterIntGains.portIn[1], intGainsRad)
    annotation (Line(
    points={{210,86},{220,86},{220,80},{240,80}},
    color={191,0,0},
    smooth=Smooth.None));
  connect(radHeatSol.port, thermSplitterSolRad.portIn)
    annotation (Line(
    points={{-146,146},{-138,146}},
    color={191,0,0},
    smooth=Smooth.None));
  connect(extWallRC.port_b, extWall)
    annotation (Line(
    points={{-178,-40},{-240,-40}},
    color={191,0,0},
    smooth=Smooth.None));
  connect(extWallRC.port_a, convExtWall.solid)
    annotation (Line(
    points={{-158,-40},{-114,-40}},
    color={191,0,0},
    smooth=Smooth.None));
  if ATotExt > 0 and ATotWin > 0 then
    connect(thermSplitterSolRad.portOut[1], convExtWall.solid)
      annotation (
      Line(
      points={{-122,146},{-68,146},{-68,-12},{-126,-12},{-126,-40},{-114,-40}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(thermSplitterIntGains.portOut[1], convExtWall.solid)
      annotation (Line(
      points={{190,86},{-62,86},{-62,-16},{-118,-16},{-118,-40},{-114,-40}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(thermSplitterSolRad.portOut[2], convWin.solid)
      annotation (
      Line(points={{-122,146},{-76,146},{-76,94},{-134,94},{-134,40},{-116,40}},
      color={191,0,0}));
    connect(thermSplitterIntGains.portOut[2], convWin.solid)
      annotation (
      Line(points={{190,86},{190,86},{-120,86},{-120,64},{-120,40},{-116,40}},
      color={191,0,0}));
  elseif not ATotExt > 0 and ATotWin > 0 then
    connect(thermSplitterSolRad.portOut[1], convWin.solid);
    connect(thermSplitterIntGains.portOut[1], convWin.solid);
  elseif ATotExt > 0 and not ATotWin > 0 then
    connect(thermSplitterSolRad.portOut[1], convExtWall.solid);
    connect(thermSplitterIntGains.portOut[1], convExtWall.solid);
  end if;
  connect(eRadSol.u, solRad)
    annotation (Line(points={{-207,146},{-214,146},{-214,140},{-260,140}},
    color={0,0,127}));
  connect(resExtWallWin.port_b, convExtWall.solid)
    annotation (Line(points={{-146,0},{-144,0},{-144,-40},{-114,-40}},
    color={191,0,0}));
  connect(resExtWallWin.port_a, convWin.solid)
    annotation (Line(points={{-146,20},{-146,40},{-116,40}}, color={191,0,0}));
  connect(hConWin_const.y, convWin.Gc)
    annotation (Line(points={{-106,61.4},{-106,50},{-106,50}},
    color={0,0,127}));
  connect(hConExtWall_const.y, convExtWall.Gc)
    annotation (Line(points={{-104,-55.5},{-104,-22},{-104,-22},{-104,-50}},
    color={0,0,127}));
  connect(convExtWall.fluid, senTAir.port)
    annotation (Line(points={{-94,-40},{66,-40},{66,0},{80,0}},
    color={191,0,0}));
  connect(convHeatSol.port, senTAir.port)
    annotation (Line(
    points={{-146,124},{-62,124},{-62,92},{66,92},{66,0},{80,0}},
    color={191,0,0},
    pattern=LinePattern.Dash));
  connect(intGainsConv, senTAir.port)
    annotation (Line(points={{240,40},{66,40},{66,0},{80,0}},
    color={191,0,0}));
  connect(convWin.fluid, senTAir.port)
    annotation (Line(points={{-96,40},{66,40},{66,0},{80,0}},
    color={191,0,0}));
  connect(volAir.heatPort, senTAir.port)
    annotation (Line(points={{42,-16},{42,0},{80,0}},
                                                    color={191,0,0}));
  connect(volMoiAir.heatPort, senTAir.port)
    annotation (Line(points={{-20,-16},{-20,0},{80,0}}, color={191,0,0}));
  connect(senTAir.T, TAir)
    annotation (Line(points={{100,0},{108,0},{108,160},{250,160}},
    color={0,0,127}));
  connect(convWin.solid, windowIndoorSurface)
    annotation (Line(points={{-116,40},{-130,40},{-130,-10},{-212,-10},{-212,
    -146},{-200,-146},{-200,-180}},
    color={191,0,0}));
  connect(convExtWall.solid, extWallIndoorSurface)
    annotation (Line(points={{-114,-40},{-134,-40},{-152,-40},{-152,-58},{-208,
    -58},{-208,-140},{-160,-140},{-160,-180}},
    color={191,0,0}));
  connect(senTRad.port, thermSplitterIntGains.portIn[1])
    annotation (
    Line(points={{210,100},{210,100},{210,100},{210,86}}, color={191,
    0,0}));
  connect(senTRad.T, TRad)
    annotation (Line(points={{210,120},{210,128},{228,128},{228,128},{228,120},
    {250,120}}, color={0,0,127}));
  connect(solRad, eConvSol.u)
    annotation (Line(
    points={{-260,140},{-226,140},{-226,124},{-207,124}},
    color={0,0,127},
    pattern=LinePattern.Dash));
  connect(eConvSol.y, sumSolRad.u)
    annotation (Line(
    points={{-195.5,124},{-187.2,124}},
    color={0,0,127},
    pattern=LinePattern.Dash));
  connect(sumSolRad.y, convHeatSol.Q_flow)
    annotation (Line(points={{-173.4,124},{-166,124}}, color={0,0,127}));
  connect(mWat_flow.y, volMoiAir.mWat_flow) annotation (Line(
        points={{-179,-90},{-168,-90},{-168,-80},{-34,-80},{-34,-8},{-22,-8}},
        color={0,0,127},
        pattern=LinePattern.Dash));

  connect(conQLat_flow.port, volMoiAir.heatPort) annotation (Line(points={{-182,
          -120},{-166,-120},{-166,-82},{-32,-82},{-32,-16},{-20,-16}}, color={191,
          0,0}));
  connect(mWat_flow.u, QLat_flow) annotation (Line(points={{-202,-90},{-232,-90},
          {-232,-130},{-260,-130}}, color={0,0,127}));
  connect(conQLat_flow.Q_flow, QLat_flow)
    annotation (Line(points={{-202,-120},{-232,-120},{-232,-130},{-260,-130}},
                                                       color={0,0,127}));
  connect(volMoiAir.C_flow, C_flow) annotation (Line(points={{-22,-22},{-52,-22},
          {-52,90},{-260,90}}, color={0,0,127}));
  connect(volAir.C_flow, C_flow) annotation (Line(points={{44,-22},{56,-22},{56,
          90},{-260,90}}, color={0,0,127}));
  annotation (defaultComponentName="theZon",Diagram(coordinateSystem(
  preserveAspectRatio=false, extent={{-240,-180},{240,180}},
  grid={2,2}),  graphics={
  Rectangle(
    extent={{-206,80},{-92,26}},
    lineColor={0,0,255},
    fillColor={215,215,215},
    fillPattern=FillPattern.Solid),
  Rectangle(
    extent={{-218,174},{-118,115}},
    lineColor={0,0,255},
    fillColor={215,215,215},
    fillPattern=FillPattern.Solid),
  Text(
    extent={{-201,180},{-144,152}},
    textColor={0,0,255},
    fillColor={215,215,215},
    fillPattern=FillPattern.Solid,
    textString="Solar Radiation"),
  Rectangle(
    extent={{-204,-20},{-86,-74}},
    lineColor={0,0,255},
    fillColor={215,215,215},
    fillPattern=FillPattern.Solid),
  Text(
    extent={{-201,-59},{-146,-76}},
    textColor={0,0,255},
    fillColor={215,215,215},
    fillPattern=FillPattern.Solid,
    textString="Exterior Walls"),
  Text(
    extent={{-202,82},{-168,64}},
    textColor={0,0,255},
    fillColor={215,215,215},
    fillPattern=FillPattern.Solid,
    textString="Windows"),
  Rectangle(
    extent={{-30,20},{50,-32}},
    lineColor={0,0,255},
    fillColor={215,215,215},
    fillPattern=FillPattern.Solid),
  Text(
    extent={{-11,18},{26,4}},
    textColor={0,0,255},
    fillColor={215,215,215},
    fillPattern=FillPattern.Solid,
    textString="Indoor Air")}),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-240,-180},{240,180}},
  grid={2,2}),
   graphics={
  Rectangle(
    extent={{-240,180},{240,-180}},
    lineColor={0,0,0},
    fillColor={215,215,215},
    fillPattern=FillPattern.Forward),
  Rectangle(
    extent={{-230,170},{230,-170}},
    lineColor={0,0,0},
    fillColor={230,230,230},
    fillPattern=FillPattern.Solid),
  Line(
    points={{-226,-170},{-124,-74},{-124,76},{-230,170}},
    color={0,0,0},
    smooth=Smooth.None),
  Line(
    points={{-124,76},{2,76},{124,76},{230,170}},
    color={0,0,0},
    smooth=Smooth.None),
  Line(
    points={{124,76},{124,-74},{230,-170}},
    color={0,0,0},
    smooth=Smooth.None),
  Line(
    points={{-124,-74},{124,-74}},
    color={0,0,0},
    smooth=Smooth.None),
  Text(
    extent={{-260,266},{24,182}},
    textColor={0,0,255},
    lineThickness=0.5,
    fillColor={236,99,92},
    fillPattern=FillPattern.Solid,
    textString="%name"),
  Text(
    extent={{-67,60},{57,-64}},
    textColor={0,0,0},
    textString="1")}),
  Documentation(info="<html>
<p>
This model merges all thermal masses into one
element, parameterized by the length of the RC-chain
<code>nExt,</code> the vector of the capacities <code>CExt[nExt]</code> that is
connected via the vector of resistances <code>RExt[nExt]</code> and
<code>RExtRem</code> to the ambient and indoor air.
By default, the model neglects all
internal thermal masses that are not directly connected to the ambient.
However, the thermal capacity of the room air can be increased by
using the parameter <code>mSenFac</code>.
</p>
<p>
The image below shows the RC-network of this model.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/ReducedOrder/RC/OneElement.png\" alt=\"image\"/>
</p>
  </html>",
revisions="<html>
<ul>
<li>
March 7, 2022, by Michael Wetter:<br/>
Removed <code>massDynamics</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">#1542</a>.
</li>
<li>
October 9, 2019, by Michael Wetter:<br/>
Refactored addition of moisture to also account for the energy content of the
water vapor.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1209\">IBPSA, issue 1209</a>.
</li>
  <li>
  September 24, 2019, by Martin Kremer:<br/>
  Added possibility to consider moisture balance. <br/>
  Defined <code>volAir</code> conditional. Added conditional <code>volMoistAir</code> and corresponding in- and output connectors.
  </li>
  <li>
  July 11, 2019, by Katharina Brinkmann:<br/>
  Renamed <code>alphaRad</code> to <code>hRad</code>,
  <code>alphaWin</code> to <code>hConWin</code>,
  <code>alphaExt</code> to <code>hConExt</code>,
  <code>alphaExtWallConst</code> to <code>hConExtWall_const</code>,
  <code>alphaWinConst</code> to <code>hConWin_const</code>
  </li>
  <li>
  January 25, 2019, by Michael Wetter:<br/>
  Added start value to avoid warning in JModelica.
  </li>
  <li>
  September 26, 2016, by Moritz Lauster:<br/>
  Added conditional statements to solar radiation part.<br/>
  Deleted conditional statements of
  <code>splitFactor</code> and <code>splitFactorSolRad</code>.
  </li>
  <li>
  April 17, 2015, by Moritz Lauster:<br/>
  First implementation.
  </li>
</ul>
</html>"));
end OneElement;
