within Buildings.ThermalZones.Detailed.BaseClasses;
partial model PartialAirHeatMassBalance
  "Partial model for heat and mass balance of the air"
  extends Buildings.ThermalZones.Detailed.BaseClasses.ConstructionRecords;

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);
  // Port definitions
  parameter Integer nPorts=0 "Number of ports"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));

  parameter Boolean haveShade
    "Set to true if at least one window has an interior or exterior shade";

  parameter Modelica.Units.SI.Volume V "Volume";

  // Input/output signals
  Modelica.Blocks.Interfaces.RealInput uSha[NConExtWin] if haveShade
    "Input connector, used to scale the surface area to take into account an operable shading device, 0: unshaded; 1: fully shaded"
    annotation (Placement(transformation(extent={{-280,180},{-240,220}}),
        iconTransformation(extent={{-256,192},{-240,208}})));
  Modelica.Blocks.Interfaces.RealInput QRadAbs_flow[NConExtWin](
  each final unit="W")
  if haveShade
    "Total net radiation that is absorbed by the shade (positive if absorbed)"
    annotation (Placement(transformation(extent={{-280,70},{-240,110}}),
        iconTransformation(extent={{-260,90},{-240,110}})));

  Modelica.Blocks.Interfaces.RealInput QCon_flow
    "Convective sensible heat gains of the room"
    annotation (Placement(transformation(extent={{-280,-120},{-240,-80}})));
  Modelica.Blocks.Interfaces.RealInput QLat_flow
    "Latent heat gains for the room"
    annotation (Placement(transformation(extent={{-280,-180},{-240,-140}})));

  Modelica.Blocks.Interfaces.RealOutput TSha[NConExtWin](
   each final unit="K",
   each final quantity="ThermodynamicTemperature")
   if haveShade "Shade temperature"
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

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conExt[NConExt]
  if haveConExt
    "Heat port that connects to room-side surface of exterior constructions"
                              annotation (Placement(transformation(extent={{230,210},
            {250,230}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conExtWin[NConExtWin]
  if haveConExtWin
    "Heat port that connects to room-side surface of exterior constructions that contain a window"
                              annotation (Placement(transformation(extent={{230,170},
            {250,190}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a glaUns[NConExtWin]
  if haveConExtWin
    "Heat port that connects to room-side surface of unshaded glass"
                              annotation (Placement(transformation(extent={{230,110},
            {250,130}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a glaSha[NConExtWin]
    if haveShade "Heat port that connects to room-side surface of shaded glass"
                              annotation (Placement(transformation(extent={{230,70},
            {250,90}}), iconTransformation(extent={{230,70},
            {250,90}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conExtWinFra[NConExtWin]
  if haveConExtWin
    "Heat port that connects to room-side surface of window frame"
                              annotation (Placement(transformation(extent={{232,-10},
            {252,10}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conPar_a[NConPar]
  if haveConPar
    "Heat port that connects to room-side surface a of partition constructions"
                              annotation (Placement(transformation(extent={{232,-70},
            {252,-50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conPar_b[NConPar]
  if haveConPar
    "Heat port that connects to room-side surface b of partition constructions"
                              annotation (Placement(transformation(extent={{232,
            -110},{252,-90}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conBou[NConBou]
  if haveConBou
    "Heat port that connects to room-side surface of constructions that expose their other surface to the outside"
                              annotation (Placement(transformation(extent={{232,
            -170},{252,-150}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conSurBou[NSurBou]
  if haveSurBou
    "Heat port to surfaces of models that compute the heat conduction outside of this room"
                              annotation (Placement(transformation(extent={{231,
            -230},{251,-210}})));

  // Surface areas
protected
  final parameter Modelica.Units.SI.Area AConExt[NConExt]=datConExt.A
    "Areas of exterior constructions";
  final parameter Modelica.Units.SI.Area AConExtWinOpa[NConExtWin]=datConExtWin.AOpa
    "Opaque areas of exterior construction that have a window";
  final parameter Modelica.Units.SI.Area AConExtWinGla[NConExtWin]=(1 .-
      datConExtWin.fFra) .* datConExtWin.AWin
    "Glass areas of exterior construction that have a window";
  final parameter Modelica.Units.SI.Area AConExtWinFra[NConExtWin]=datConExtWin.fFra
       .* datConExtWin.AWin
    "Frame areas of exterior construction that have a window";
  final parameter Modelica.Units.SI.Area AConPar[NConPar]=datConPar.A
    "Areas of partition constructions";
  final parameter Modelica.Units.SI.Area AConBou[NConBou]=datConBou.A
    "Areas of constructions with exterior boundary conditions exposed to outside of room model";
  final parameter Modelica.Units.SI.Area ASurBou[NSurBou]=surBou.A
    "Area of surface models of constructions that are modeled outside of this room";
  annotation (
    preferredView="info",
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-240,-240},{240,
            240}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-240,-240},{240,240}}),
                    graphics={
        Text(
          extent={{-230,182},{-188,216}},
          textColor={0,0,127},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="uSha"),
        Text(
          extent={{-232,82},{-190,116}},
          textColor={0,0,127},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="QRadAbs"),
        Text(
          extent={{-228,44},{-186,78}},
          textColor={0,0,127},
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
          textColor={0,0,127},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Text(
          extent={{-230,-124},{-180,-74}},
          textColor={0,0,127},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="QCon"),
        Text(
          extent={{-228,-184},{-178,-134}},
          textColor={0,0,127},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="QLat")}),
    Documentation(info="<html>
<p>
This is a partial model that is used to implement the heat and mass balance of the air.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 12, 2019, by Michael Wetter:<br/>
Added missing <code>each</code>.
</li>
<li>
May 2, 2016, by Michael Wetter:<br/>
Refactored implementation of latent heat gain.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/515\">issue 515</a>.
</li>
<li>
July 17, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialAirHeatMassBalance;
