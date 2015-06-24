within Buildings.Rooms.BaseClasses;
model AirHeatMassBalanceMixed
  "Heat and mass balance of the air, assuming completely mixed air"
  extends Buildings.Rooms.BaseClasses.ConstructionRecords;
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0)
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  // Port definitions
  parameter Integer nPorts=0 "Number of ports"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
  parameter Boolean homotopyInitialization "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  parameter Modelica.SIunits.Volume V "Volume";

  parameter Buildings.HeatTransfer.Types.InteriorConvection conMod
    "Convective heat transfer model for opaque constructions"
    annotation (Dialog(group="Convective heat transfer"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hFixed
    "Constant convection coefficient for opaque constructions"
    annotation (Dialog(group="Convective heat transfer",
                       enable=(conMod == Buildings.HeatTransfer.Types.InteriorConvection.Fixed)));

  parameter Boolean haveShade
    "Set to true if at least one window has an interior or exterior shade";

  // Input/output signals
  Modelica.Blocks.Interfaces.RealInput uSha[NConExtWin] if haveShade
    "Input connector, used to scale the surface area to take into account an operable shading device, 0: unshaded; 1: fully shaded"
    annotation (Placement(transformation(extent={{-280,180},{-240,220}}),
        iconTransformation(extent={{-256,192},{-240,208}})));
  Modelica.Blocks.Interfaces.RealInput QRadAbs_flow[NConExtWin](
  final unit="W") if
     haveShade
    "Total net radiation that is absorbed by the shade (positive if absorbed)"
    annotation (Placement(transformation(extent={{-280,70},{-240,110}}),
        iconTransformation(extent={{-260,90},{-240,110}})));
  Modelica.Blocks.Interfaces.RealOutput TSha[NConExtWin](
   final unit="K",
   final quantity="ThermodynamicTemperature") if
      haveShade "Shade temperature"
    annotation (Placement(transformation(extent={{-240,50},{-260,70}})));

  // Fluid port
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
      redeclare each final package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{-40,-10},{40,10}},
      origin={0,-238})));

  // Heat ports
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorAir
    "Heat port to air volume"
    annotation (Placement(transformation(extent={{-250,-10},{-230,10}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conExt[NConExt] if
     haveConExt
    "Heat port that connects to room-side surface of exterior constructions"
                              annotation (Placement(transformation(extent={{230,210},
            {250,230}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conExtWin[NConExtWin] if
     haveConExtWin
    "Heat port that connects to room-side surface of exterior constructions that contain a window"
                              annotation (Placement(transformation(extent={{230,170},
            {250,190}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a glaUns[NConExtWin] if
     haveConExtWin
    "Heat port that connects to room-side surface of unshaded glass"
                              annotation (Placement(transformation(extent={{230,110},
            {250,130}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a glaSha[NConExtWin] if
       haveShade "Heat port that connects to room-side surface of shaded glass"
                              annotation (Placement(transformation(extent={{230,70},
            {250,90}}), iconTransformation(extent={{230,70},
            {250,90}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conExtWinFra[NConExtWin] if
     haveConExtWin
    "Heat port that connects to room-side surface of window frame"
                              annotation (Placement(transformation(extent={{232,-10},
            {252,10}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conPar_a[NConPar] if
     haveConPar
    "Heat port that connects to room-side surface a of partition constructions"
                              annotation (Placement(transformation(extent={{232,-70},
            {252,-50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conPar_b[NConPar] if
     haveConPar
    "Heat port that connects to room-side surface b of partition constructions"
                              annotation (Placement(transformation(extent={{232,
            -110},{252,-90}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conBou[NConBou] if
     haveConBou
    "Heat port that connects to room-side surface of constructions that expose their other surface to the outside"
                              annotation (Placement(transformation(extent={{232,
            -170},{252,-150}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conSurBou[NSurBou] if
     haveSurBou
    "Heat port to surfaces of models that compute the heat conduction outside of this room"
                              annotation (Placement(transformation(extent={{231,
            -230},{251,-210}})));

  // Mixing volume
  Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final V=V,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final m_flow_nominal = m_flow_nominal,
    final prescribedHeatFlowRate = true,
    final nPorts=nPorts,
    m_flow_small=1E-4*abs(m_flow_nominal),
    allowFlowReversal=true) "Room air volume"
    annotation (Placement(transformation(extent={{10,-210},{-10,-190}})));

  // Convection models
  HeatTransfer.Convection.Interior convConExt[NConExt](
    final A=AConExt,
    final til = datConExt.til,
    each conMod=conMod,
    each hFixed=hFixed,
    each final homotopyInitialization=homotopyInitialization) if
       haveConExt "Convective heat transfer"
    annotation (Placement(transformation(extent={{120,210},{100,230}})));

  HeatTransfer.Convection.Interior convConExtWin[NConExtWin](
    final A=AConExtWinOpa,
    final til = datConExtWin.til,
    each conMod=conMod,
    each hFixed=hFixed,
    each final homotopyInitialization=homotopyInitialization) if
       haveConExtWin "Convective heat transfer"
    annotation (Placement(transformation(extent={{120,170},{100,190}})));

  HeatTransfer.Windows.InteriorHeatTransferConvective convConWin[NConExtWin](
    final fFra=datConExtWin.fFra,
    final haveExteriorShade={datConExtWin[i].glaSys.haveExteriorShade for i in 1:NConExtWin},
    final haveInteriorShade={datConExtWin[i].glaSys.haveInteriorShade for i in 1:NConExtWin},
    final A=AConExtWinGla + AConExtWinFra) if
       haveConExtWin "Model for convective heat transfer at window"
    annotation (Placement(transformation(extent={{98,110},{118,130}})));

  HeatTransfer.Convection.Interior convConPar_a[nConPar](
    final A=AConPar,
    final til=Modelica.Constants.pi .- datConPar.til,
    each conMod=conMod,
    each hFixed=hFixed,
    each final homotopyInitialization=homotopyInitialization) if
       haveConPar "Convective heat transfer"
    annotation (Placement(transformation(extent={{120,-70},{100,-50}})));

  HeatTransfer.Convection.Interior convConPar_b[nConPar](
    final A=AConPar,
    final til = datConPar.til,
    each conMod=conMod,
    each hFixed=hFixed,
    each final homotopyInitialization=homotopyInitialization) if
       haveConPar "Convective heat transfer"
    annotation (Placement(transformation(extent={{120,-110},{100,-90}})));

  HeatTransfer.Convection.Interior convConBou[nConBou](
    final A=AConBou,
    final til = datConBou.til,
    each conMod=conMod,
    each hFixed=hFixed,
    each final homotopyInitialization=homotopyInitialization) if
       haveConBou "Convective heat transfer"
    annotation (Placement(transformation(extent={{120,-170},{100,-150}})));

  HeatTransfer.Convection.Interior convSurBou[nSurBou](
    final A=ASurBou,
    final til = surBou.til,
    each conMod=conMod,
    each hFixed=hFixed,
    each final homotopyInitialization=homotopyInitialization) if
       haveSurBou "Convective heat transfer"
    annotation (Placement(transformation(extent={{122,-230},{102,-210}})));

  // Surface areas
protected
  final parameter Modelica.SIunits.Area AConExt[NConExt] = datConExt.A
    "Areas of exterior constructions";
  final parameter Modelica.SIunits.Area AConExtWinOpa[NConExtWin] = datConExtWin.AOpa
    "Opaque areas of exterior construction that have a window";
  final parameter Modelica.SIunits.Area AConExtWinGla[NConExtWin] = (1 .- datConExtWin.fFra) .* datConExtWin.AWin
    "Glass areas of exterior construction that have a window";
  final parameter Modelica.SIunits.Area AConExtWinFra[NConExtWin] = datConExtWin.fFra .* datConExtWin.AWin
    "Frame areas of exterior construction that have a window";
  final parameter Modelica.SIunits.Area AConPar[NConPar] = datConPar.A
    "Areas of partition constructions";
  final parameter Modelica.SIunits.Area AConBou[NConBou] = datConBou.A
    "Areas of constructions with exterior boundary conditions exposed to outside of room model";
  final parameter Modelica.SIunits.Area ASurBou[NSurBou] = surBou.A
    "Area of surface models of constructions that are modeled outside of this room";

  // Thermal collectors
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theConConExt(final m=nConExt) if
       haveConExt
    "Thermal collector to convert from vector to scalar connector"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={48,220})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theConConExtWin(final m=nConExtWin) if
       haveConExtWin
    "Thermal collector to convert from vector to scalar connector"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={48,180})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theConConWin(final m=nConExtWin) if
       haveConExtWin
    "Thermal collector to convert from vector to scalar connector"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,120})));

  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theConConPar_a(final m=nConPar) if
       haveConPar
    "Thermal collector to convert from vector to scalar connector"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={52,-60})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theConConPar_b(final m=nConPar) if
       haveConPar
    "Thermal collector to convert from vector to scalar connector"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,-100})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theConConBou(final m=nConBou) if
       haveConBou
    "Thermal collector to convert from vector to scalar connector"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,-160})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theConSurBou(final m=nSurBou) if
       haveSurBou
    "Thermal collector to convert from vector to scalar connector"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={52,-220})));

equation
  connect(convConPar_a.fluid,theConConPar_a. port_a) annotation (Line(
      points={{100,-60},{62,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConPar_b.fluid,theConConPar_b. port_a) annotation (Line(
      points={{100,-100},{60,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConBou.fluid,theConConBou. port_a) annotation (Line(
      points={{100,-160},{60,-160}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convSurBou.fluid,theConSurBou. port_a) annotation (Line(
      points={{102,-220},{62,-220}},
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
  connect(conExtWinFra,convConWin. frame) annotation (Line(
      points={{242,4.44089e-16},{160,4.44089e-16},{160,100},{115,100},{115,110}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConExt.solid, conExt) annotation (Line(
      points={{120,220},{240,220}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConExt.fluid,theConConExt. port_a) annotation (Line(
      points={{100,220},{58,220}},
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
  connect(convConExtWin.fluid,theConConExtWin. port_a) annotation (Line(
      points={{100,180},{58,180}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConExtWin.solid, conExtWin) annotation (Line(
      points={{120,180},{240,180}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theConConWin.port_b,vol. heatPort) annotation (Line(
      points={{40,120},{20,120},{20,-200},{10,-200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConWin.air,theConConWin. port_a) annotation (Line(
      points={{98,120},{60,120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConWin.glaSha, glaSha) annotation (Line(
      points={{118,118},{166,118},{166,80},{240,80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConWin.glaUns, glaUns) annotation (Line(
      points={{118,122},{180,122},{180,120},{240,120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConPar_a.solid, conPar_a) annotation (Line(
      points={{120,-60},{242,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConPar_b.solid, conPar_b) annotation (Line(
      points={{120,-100},{242,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConBou.solid, conBou) annotation (Line(
      points={{120,-160},{242,-160}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convSurBou.solid, conSurBou) annotation (Line(
      points={{122,-220},{241,-220}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.ports, ports) annotation (Line(
      points={{0,-210},{0,-238}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heaPorAir, vol.heatPort) annotation (Line(
      points={{-240,0},{20,0},{20,-200},{10,-200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(uSha, convConWin.uSha) annotation (Line(
      points={{-260,200},{0,200},{0,150},{82,150},{82,128},{97.2,128}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(convConWin.QRadAbs_flow, QRadAbs_flow) annotation (Line(
      points={{102,109},{102,90},{-260,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(convConWin.TSha, TSha) annotation (Line(
      points={{108,109},{108,60},{-250,60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    preferredView="info",
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-240,-240},{240,
            240}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-240,-240},{240,240}}),
                    graphics={
        Text(
          extent={{-230,182},{-188,216}},
          lineColor={0,0,127},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="uSha"),
        Text(
          extent={{-232,82},{-190,116}},
          lineColor={0,0,127},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="QRadAbs"),
        Text(
          extent={{-228,44},{-186,78}},
          lineColor={0,0,127},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="TSha"),
          Rectangle(
          extent={{-144,184},{148,-200}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Sphere),
        Text(
          extent={{-84,232},{94,282}},
          lineColor={0,0,127},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}),
    Documentation(info="<html>
<p>
This model computes the heat and mass balance of the air.
The model assumes a completely mixed air volume.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 12, 2013, by Michael Wetter:<br/>
First implementation to facilitate the separation of the convective and radiative model.
</li>
</ul>
</html>"));
end AirHeatMassBalanceMixed;
