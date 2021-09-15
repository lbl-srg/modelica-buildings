within Buildings.ThermalZones.Detailed.BaseClasses;
model RadiationTemperature "Radiative temperature of the room"
  extends Buildings.ThermalZones.Detailed.BaseClasses.PartialSurfaceInterfaceRadiative;

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a glaUns[NConExtWin] if
     haveConExtWin
    "Heat port that connects to room-side surface of unshaded glass"
                              annotation (Placement(transformation(extent={{230,110},
            {250,130}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a glaSha[NConExtWin] if
    haveShade "Heat port that connects to room-side surface of shaded glass"
                              annotation (Placement(transformation(extent={{230,70},
            {250,90}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a sha[NConExtWin] if
    haveShade "Heat port that connects to shade"
                                       annotation (Placement(transformation(extent={{230,28},
            {250,48}})));
  parameter Boolean haveShade "Set to true if the windows have a shade"
  annotation(HideResult=true);

  Modelica.Blocks.Interfaces.RealInput uSha[NConExtWin](each min=0, each max=1) if
       haveShade
    "Control signal for the shading device (removed if no shade is present)"
    annotation (Placement(transformation(extent={{-280,160},{-240,200}}),
        iconTransformation(extent={{-280,160},{-240,200}})));

  Modelica.Blocks.Interfaces.RealOutput TRad(min=0, unit="K", displayUnit="degC")
    "Radiative temperature"
    annotation (Placement(transformation(extent={{-240,-190},{-260,-170}}),
        iconTransformation(extent={{-240,-194},{-260,-174}})));

protected
  final parameter Integer NOpa = NConExt+2*NConExtWin+2*NConPar+NConBou+NSurBou
    "Number of opaque surfaces, including the window frame";
  final parameter Integer NWin = NConExtWin "Number of window surfaces";
  final parameter Integer NTot = NOpa + NWin "Total number of surfaces";

  final parameter Modelica.SIunits.Area AGla[NWin] = datConExtWin.AGla
    "Surface area of opaque surfaces";
  final parameter Real epsGla[NWin](each min=0, each max=1)=
    {datConExtWin[i].glaSys.glass[size(datConExtWin[i].glaSys.glass, 1)].absIR_b for i in 1:NWin}
    "Absorptivity of glass";
  final parameter Real epsSha[NWin](each min=0, each max=1)=
    {datConExtWin[i].glaSys.shade.absIR_a for i in 1:NWin}
    "Absorptivity of shade";
  final parameter Real tauSha[NWin](each min=0, each max=1)=
    {(if datConExtWin[i].glaSys.haveInteriorShade then
      datConExtWin[i].glaSys.shade.tauIR_a else 1) for i in 1:NWin}
    "Transmissivity of shade";
  final parameter Modelica.SIunits.Area epsAOpa[NOpa](each fixed=false)
    "Product of area times absorptivity of opaque surfaces";
  final parameter Modelica.SIunits.Area epsAGla[NWin](each fixed=false)
    "Product of area times absorptivity of window surfaces";
  final parameter Modelica.SIunits.Area epsASha[NWin](each fixed=false)
    "Product of area times absorptivity of window shade";
  final parameter Modelica.SIunits.Area epsTauASha[NWin](each fixed=false)
    "Product of area times glass absorptivity times shade transmittance";
  Modelica.SIunits.Temperature TOpa[NOpa](each start=293.15, each nominal=293.15)
    "Temperature of opaque surfaces";
  Modelica.SIunits.Temperature TGlaUns[NWin](each start=293.15, each nominal=293.15)
    "Temperature of unshaded part of glass";
  Modelica.SIunits.Temperature TGlaSha[NWin](each start=293.15, each nominal=293.15)
    "Temperature of shaded part of glass";
  Modelica.SIunits.Temperature TSha[NWin](each start=293.15, each nominal=293.15)
    "Temperature of shade";
  // Internal connectors, used because of the conditionally removed connectors
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a glaUns_internal[NConExtWin]
    "Heat port that connects to room-side surface of unshaded glass";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a glaSha_internal[NConExtWin]
    "Heat port that connects to room-side surface of shaded glass";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a sha_internal[NConExtWin]
    "Heat port that connects to shade";
  Modelica.Blocks.Interfaces.RealInput uSha_internal[NConExtWin](each min=0, each max=1)
    "Control signal for the shading device";

initial equation
  // The next loops build the array epsAOpa that simplifies
  // the model equations.
  // The arrays stores the values of the constructios in the following order
  // [x[1:NConExt] x[1:NConPar] x[1: NConPar] x[1: NConBou] x[1: NSurBou] x[1: NConExtWin] x[1: NConExtWin]]
  // where x is epsOpa, AOpa or kOpa.
  // The last two entries are for the opaque wall that contains a window, and for the window frame.
  for i in 1:NConExt loop
    epsAOpa[i] = epsConExt[i] * AConExt[i];
  end for;
  for i in 1:NConPar loop
    epsAOpa[i+NConExt]         = epsConPar_a[i] * AConPar[i];
    epsAOpa[i+NConExt+NConPar] = epsConPar_b[i] * AConPar[i];
  end for;
  for i in 1:NConBou loop
    epsAOpa[i+NConExt+2*NConPar] = epsConBou[i] * AConBou[i];
  end for;
  for i in 1:NSurBou loop
    epsAOpa[i+NConExt+2*NConPar+NConBou] = epsSurBou[i] * ASurBou[i];
  end for;
  for i in 1:NConExtWin loop
    // Opaque part of construction that has a window embedded
    epsAOpa[i+NConExt+2*NConPar+NConBou+NSurBou] = epsConExtWinOpa[i] * AConExtWinOpa[i];
    // Window frame
    epsAOpa[i+NConExt+2*NConPar+NConBou+NSurBou+NConExtWin] = epsConExtWinFra[i] * AConExtWinFra[i];
  end for;
  // Window glass
  for i in 1:NConExtWin loop
    // Window glass
    epsAGla[i] = AGla[i] * epsGla[i];
    // Window shade
    epsASha[i]    = AGla[i] * epsSha[i];
    // Emitted from glas and transmitted through window shade
    epsTauASha[i] = AGla[i] * epsGla[i] * tauSha[i];
  end for;
////////////////////////////////////////////////////////////////////
equation
  // Conditional connnector
  connect(glaUns, glaUns_internal);
  connect(glaSha, glaSha_internal);
  connect(sha, sha_internal);
  connect(uSha, uSha_internal);
  if not haveConExtWin then
    glaUns_internal.T = fill(293.15, NConExtWin);
  end if;
  if not haveShade then
    glaSha_internal.T = fill(293.15, NConExtWin);
    sha_internal.T = fill(293.15, NConExtWin);
    uSha_internal = fill(0, NConExtWin);
  end if;

  // Assign temperature of opaque surfaces
  for i in 1:NConExt loop
    TOpa[i] = conExt[i].T;
  end for;
  for i in 1:NConPar loop
    TOpa[i+NConExt]         = conPar_a[i].T;
    TOpa[i+NConExt+NConPar] = conPar_b[i].T;
  end for;
  for i in 1:NConBou loop
    TOpa[i+NConExt+2*NConPar] = conBou[i].T;
  end for;
  for i in 1:NSurBou loop
    TOpa[i+NConExt+2*NConPar+NConBou] = conSurBou[i].T;
  end for;
  for i in 1:NConExtWin loop
    TOpa[i+NConExt+2*NConPar+NConBou+NSurBou]            = conExtWin[i].T;
    TOpa[i+NConExt+2*NConPar+NConBou+NConExtWin+NSurBou] = conExtWinFra[i].T;
  end for;
  // Assign temperature of glass and shade
  for i in 1:NConExtWin loop
    TGlaUns[i] = glaUns_internal[i].T;
    TGlaSha[i] = glaSha_internal[i].T;
    TSha[i]    = sha_internal[i].T;
  end for;
  // Compute radiative temperature
  if haveShade then
    TRad = (sum(epsAOpa[i] * TOpa[i] for i in 1:NOpa)
        + sum(
      ( uSha_internal[i] * (epsASha[i] * TSha[i] + epsTauASha[i] * TGlaSha[i]) +
      (1-uSha_internal[i]) * epsAGla[i] * TGlaUns[i])
        for i in 1:NConExtWin))  /
        (sum(epsAOpa) + sum(
      ( uSha_internal[i] * (epsASha[i] + epsTauASha[i]) + (1-uSha_internal[i]) * epsAGla[i])
        for i in 1:NConExtWin));
      else
    TRad = (sum(epsAOpa[i] * TOpa[i] for i in 1:NOpa) + sum(epsAGla .* TGlaUns)) / (sum(epsAOpa) + sum(epsAGla));
  end if;

  // Assign heat exchange to connectors
  if haveConExt then
    for i in 1:NConExt loop
      0 = conExt[i].Q_flow;
    end for;
  else
      conExt[1].T = 293.15;
  end if;

  if haveConPar then
    for i in 1:NConPar loop
      0 = conPar_a[i].Q_flow;
      0 = conPar_b[i].Q_flow;
    end for;
  else
      conPar_a[1].T = 293.15;
      conPar_b[1].T = 293.15;
  end if;

  if haveConBou then
    for i in 1:NConBou loop
      0 = conBou[i].Q_flow;
    end for;
  else
     conBou[1].T = 293.15;
  end if;

  if haveSurBou then
    for i in 1:NSurBou loop
      0 = conSurBou[i].Q_flow;
    end for;
  else
      conSurBou[1].T = 293.15;
  end if;

  if haveConExtWin then
    for i in 1:NConExtWin loop
      0 = conExtWin[i].Q_flow;
      0 = conExtWinFra[i].Q_flow;
    end for;
  else
      conExtWin[1].T    = 293.15;
      conExtWinFra[1].T = 293.15;
  end if;

  annotation (
preferredView="info",
Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-240,-240},{240,240}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-240,-240},{240,240}}),
                                      graphics={
        Line(
          points={{-144,-8},{146,-8}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{2,-200},{2,184}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5)}),
Documentation(
info="<html>
<p>
This model computes the radiative temperature in the room.
For a room with windows but no shade, the radiative temperature is
computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  T<sub>rad</sub> = &sum;<sub>i</sub> &nbsp; (A<sup>i</sup> &nbsp; &epsilon;<sup>i</sup> &nbsp; T<sup>i</sup>)
  &frasl;
  &sum;<sub>i</sub> &nbsp; (A<sup>i</sup> &nbsp; &epsilon;<sup>i</sup>)
</p>
<p>
where
<i>T<sub>rad</sub></i> is the radiative temperature of the room,
<i>A<sup>i</sup></i> are the surface areas of the room,
<i>&epsilon;<sup>i</sup></i> are the infrared emissivities of the surfaces, and
<i>T<sup>i</sup></i> are the surface temperatures.
</p>
<p>
If a the windows have a shade, then the equation is modified to take the actual shaded and non-shaded
surface area into account. In this situation, the shaded part of a window has a infrared radiative power
of</p>
<p align=\"center\" style=\"font-style:italic;\">
 E = A &nbsp; ( u &nbsp; &epsilon;<sub>s</sub> &nbsp; T<sub>s</sub> +
   (1-u) &nbsp; &epsilon;<sub>g</sub> &tau;<sub>s</sub> &nbsp; T<sub>gs</sub>)
</p>
<p>
where
<i>A</i> is the surface area of the glass,
<i>u</i> is the control signal of the shade,
<i>&epsilon;<sub>s</sub></i> is the infrared absorptivity of the shade,
<i>T<sub>s</sub></i> is the temperature of the shade,
<i>&epsilon;<sub>g</sub></i> is the infrared absorptivity of the glass,
<i>&tau;<sub>s</sub></i> is the infrared transmittance of the shade, and
<i>T<sub>gs</sub></i> is the glass temperature behind the shade.
</p>
<p>
For the unshaded part of the window, the radiative power is
</p>
<p align=\"center\" style=\"font-style:italic;\">
 E = A &nbsp; (1-u) &nbsp; &epsilon;<sub>g</sub> &nbsp; T<sub>gn</sub>
</p>
<p>where
<i>T<sub>gn</sub></i> is the glass temperature of the non-shaded part of the window.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 13, 2015, by Michael Wetter:<br/>
Changed model to avoid a translation error
in OpenModelica.
</li>
<li>
July 16, 2013, by Michael Wetter:<br/>
Added assignment of heat port temperature instead of heat flow rate
for the cases where a construction has been conditionally removed.
This is required to avoid a singularity.
</li>
<li>
March 29 2011, by Michael Wetter:<br/>
Rewrote sum for the radiation temperature.
</li>
<li>
Jan. 18 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end RadiationTemperature;
