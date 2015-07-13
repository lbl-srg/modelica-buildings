within Buildings.Rooms.BaseClasses;
model SolarRadiationExchange
  "Solar radiation heat exchange between the room facing surfaces"
  extends Buildings.Rooms.BaseClasses.PartialSurfaceInterfaceRadiative(
  final epsConExt = datConExt.layers.absSol_b,
  final epsConExtWinOpa = datConExtWin.layers.absSol_b,
  final epsConExtWinUns={(1-datConExtWin[i].glaSys.glass[size(datConExtWin[i].glaSys.glass, 1)].tauSol
                     -datConExtWin[i].glaSys.glass[size(datConExtWin[i].glaSys.glass, 1)].rhoSol_b) for i in 1:NConExtWin},
  final epsConExtWinSha = {(1-datConExtWin[i].glaSys.glass[size(datConExtWin[i].glaSys.glass, 1)].tauSol
                       -datConExtWin[i].glaSys.glass[size(datConExtWin[i].glaSys.glass, 1)].rhoSol_b) for i in 1:NConExtWin},
  final epsConExtWinFra = datConExtWin.glaSys.absSolFra,
  final epsConPar_a = datConPar.layers.absSol_a,
  final epsConPar_b = datConPar.layers.absSol_b,
  final epsConBou = datConBou.layers.absSol_b,
  final epsSurBou = surBou.absSol);
  // In the above declaration, we simplified the assignment of epsConExtWinSha.
  // An exact formulation would need to take into account the transmission and reflection
  // of the shade for the solar radiation that strikes the window from the room-side.
  // The simplification leads to too low a value of epsConExtWinSha. Since epsConExtWinSha
  // is used as a weight for how much solar radiation hits the window from the room-side,
  // underestimating epsConExtWinSha does not seem to cause concerns. The reason is that
  // the model assumes diffuse reflection, whereas in reality, reflection of the solar
  // radiation at the floor is likely specular, and therefore less radiation would hit
  // the window from the room-side.
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

  parameter Modelica.SIunits.Emissivity tauGla[NConExtWin]
    "Transmissivity of window";

  Modelica.Blocks.Interfaces.RealOutput HOutConExtWin[NConExtWin](unit="W/m2")
    "Outgoing solar radiation that strikes window per unit area"
    annotation (Placement(transformation(extent={{240,110},{260,130}})));
  Modelica.Blocks.Interfaces.RealInput JInConExtWin[NConExtWin](unit="W")
    "Solar radiation transmitted by window per unit area"
    annotation (Placement(transformation(extent={{260,70},{240,90}})));
  Modelica.SIunits.HeatFlowRate JOutConExtWin[NConExtWin]
    "Outgoing solar radiation that strikes the window";

  Modelica.SIunits.HeatFlowRate HTot
    "Total solar radiation that enters the room";

protected
  final parameter Real k1(unit="1", fixed=false)
    "Intermediate variable for gain for solar radiation distribution";
  final parameter Real k2(fixed=false)
    "Intermediate variable for gain for solar radiation distribution";
  Modelica.SIunits.HeatFlowRate Q_flow[NTot]
    "Total solar radiation that is absorbed by the surfaces (or transmitted back through the glass)";
  final parameter Integer NOpa = NConExt+2*NConExtWin+2*NConPar+NConBou+NSurBou
    "Number of opaque surfaces, including the window frame";
  final parameter Integer NWin = NConExtWin "Number of window surfaces";
  final parameter Integer NTot = NOpa + NWin "Total number of surfaces";
  final parameter Boolean isFlo[NTot](fixed=false)
    "Flag, true if a surface is a floor";
  final parameter Real eps[NTot](min=0, max=1, fixed=false)
    "Solar absorptivity";
  final parameter Real tau[NTot](min=0, max=1, fixed=false)
    "Solar transmissivity";
  final parameter Modelica.SIunits.Area AFlo(fixed=false) "Total floor area";
  final parameter Modelica.SIunits.Area A[NTot](fixed=false) "Surface areas";
  final parameter Real k[NTot](unit="1", fixed=false)
    "Gain for solar radiation distribution";

initial equation
  // The next loops builds arrays that simplify
  // the model equations.
  // These arrays store the values of the constructios in the following order
  // [x[1:NConExt] x[1:NConPar] x[1: NConPar] x[1: NConBou] x[1: NSurBou] x[1: NConExtWin] x[1: NConExtWin]]
  // where x is epsOpa, AOpa or kOpa.
  // The last two entries are for the opaque wall that contains a window, and for the window frame.
  for i in 1:NConExt loop
    eps[i] = epsConExt[i];
    A[i]      = AConExt[i];
    isFlo[i]  = isFloorConExt[i];
  end for;
  for i in 1:NConPar loop
    eps[i+NConExt]           = epsConPar_a[i];
    A[i+NConExt]             = AConPar[i];
    isFlo[i+NConExt]         = isFloorConPar_a[i];
    eps[i+NConExt+NConPar]   = epsConPar_b[i];
    A[i+NConExt+NConPar]     = AConPar[i];
    isFlo[i+NConExt+NConPar] = isFloorConPar_b[i];
  end for;
  for i in 1:NConBou loop
    eps[i+NConExt+2*NConPar]   = epsConBou[i];
    A[i+NConExt+2*NConPar]     = AConBou[i];
    isFlo[i+NConExt+2*NConPar] = isFloorConBou[i];
  end for;
  for i in 1:NSurBou loop
    eps[i+NConExt+2*NConPar+NConBou]   = epsSurBou[i];
    A[i+NConExt+2*NConPar+NConBou]     = ASurBou[i];
    isFlo[i+NConExt+2*NConPar+NConBou] = isFloorSurBou[i];
  end for;

  for i in 1:NConExtWin loop
    // Opaque part of construction that has a window embedded
    eps[i+NConExt+2*NConPar+NConBou+NSurBou]   = epsConExtWinOpa[i];
    A[i+NConExt+2*NConPar+NConBou+NSurBou]     = AConExtWinOpa[i];
    isFlo[i+NConExt+2*NConPar+NConBou+NSurBou] = isFloorConExtWin[i];
    // Window frame
    eps[i+NConExt+2*NConPar+NConBou+NSurBou+NConExtWin]   = epsConExtWinFra[i];
    A[i+NConExt+2*NConPar+NConBou+NSurBou+NConExtWin]     = AConExtWinFra[i];
    isFlo[i+NConExt+2*NConPar+NConBou+NSurBou+NConExtWin] = isFloorConExtWin[i];
  end for;
  // Window glass
  for i in 1:NConExtWin loop
    // We simplify and assume that the shaded and unshaded part of the window
    // have the same solar absorbtance.
    // This simplification allows lumping the solar distribution into
    // a parameter.
    eps[i+NConExt+2*NConPar+NConBou+NSurBou+2*NConExtWin] = epsConExtWinUns[i];
    isFlo[i+NConExt+2*NConPar+NConBou+NSurBou+2*NConExtWin] = isFloorConExtWin[i];
    A[i+NConExt+2*NConPar+NConBou+NSurBou+2*NConExtWin] = AConExtWinGla[i];
  end for;
  // Vector with all surface areas.
  // The next loops build the array A that simplifies
  // the model equations.
  // These array stores the values of the constructios in the following order
  // [AOpa[1:NConExt] AOpa[1:NConPar] AOpa[1: NConPar] AOpa[1: NConBou] AOpa[1: NSurBou]
  //  AOpa[1: NConExtWin] AOpa[1: NConExtWin] AGla[1: NConExtWin]]
  // since NWin=NConExtWin.

  // Solar transmissivity
  for i in 1:NOpa loop
    tau[i] = 0;
  end for;
  for i in 1:NWin loop
    tau[NOpa+i] = tauGla[i];
  end for;

  // Sum of surface areas
  AFlo = sum( (if isFlo[i] then A[i] else 0) for i in 1:NTot);

  // Coefficient that is used for non-floor areas.
  // The expression  max(1E-20, AFlo) is used to prevent a division by zero in case AFlo=0.
  // The situation for AFlo=0 is caught by the assert statement.
  k1 = sum( ( if isFlo[i] then (A[i] * (1-eps[i]-tau[i])) else 0)  for i in 1:NTot) / max(1E-20, AFlo);

  k2 = sum( ( if isFlo[i] then 0 else (A[i] * (eps[i]+tau[i])))  for i in 1:NTot);

  if ( k2 > 1E-10) then
    for i in 1:NTot loop
      if isFlo[i] then
         k[i] = (eps[i]+tau[i]) * A[i] / AFlo;
      else
         k[i] = k1/k2*(eps[i]+tau[i]) * A[i];
      end if;
     end for;
  else
        // This branch only happens if k2=0, i.e., there is no surface other than floors
    for i in 1:NTot loop
      if isFlo[i] then
        k[i] = A[i] / AFlo;
      else
        k[i] = 0;
      end if;
    end for;
  end if;

  // Test whether there is a floor inside this room
  assert( AFlo > 1E-10,
     "Error in parameters of the room model: The geometry is incorrect:\n" +
     "    The room model must have a construction that is a floor,\n" +
     "    and this construction must not have a window.\n" +
     "    The parameters for the room model are such that there is no such construction.\n" +
     "    Revise the model parameters.");
  // Test whether the distribution factors add up to one
  assert(abs(1-sum(k)) < 1E-5,
     "Program error: Sum of solar distribution factors in room is not equal to one. k=" + String(sum(k)));

////////////////////////////////////////////////////////////////////
equation
  // Incoming radiation
  HTot = sum(JInConExtWin);
  // Radiation that is absorbed by the surfaces
  Q_flow = -k .* HTot;
  // Assign heat exchange to connectors
  if haveConExt then
    for i in 1:NConExt loop
      Q_flow[i] = conExt[i].Q_flow;
    end for;
  else
    conExt[1].T = 293.15;
  end if;

  if haveConPar then
    for i in 1:NConPar loop
      Q_flow[i+NConExt]         = conPar_a[i].Q_flow;
      Q_flow[i+NConExt+NConPar] = conPar_b[i].Q_flow;
    end for;
  else
      conPar_a[1].T = 293.15;
      conPar_b[1].T = 293.15;
  end if;

  if haveConBou then
    for i in 1:NConBou loop
      Q_flow[i+NConExt+2*NConPar] = conBou[i].Q_flow;
    end for;
  else
    conBou[1].T = 293.15;
  end if;

  if haveSurBou then
    for i in 1:NSurBou loop
      Q_flow[i+NConExt+2*NConPar+NConBou] = conSurBou[i].Q_flow;
     end for;
  else
      conSurBou[1].T = 293.15;
  end if;

  if haveConExtWin then
    for i in 1:NConExtWin loop
      Q_flow[i+NConExt+2*NConPar+NConBou+NSurBou]            = conExtWin[i].Q_flow;
      Q_flow[i+NConExt+2*NConPar+NConBou+NSurBou+NConExtWin] = conExtWinFra[i].Q_flow;
    end for;
  else
    conExtWin[1].T    = 293.15;
    conExtWinFra[1].T = 293.15;
  end if;
  // Windows
  for j in 1:NWin loop
    Q_flow[j+NOpa] = JOutConExtWin[j];
    HOutConExtWin[j] = if (AConExtWinGla[j] > 1E-10) then JOutConExtWin[j] / AConExtWinGla[j] else 0;
  end for;

  annotation (
preferredView="info",
Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-240,-240},
            {240,240}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-240,-240},{240,240}}),
                                      graphics={
        Line(
          points={{-144,-8},{2,-200}},
          color={255,128,0},
          smooth=Smooth.None),
        Line(
          points={{2,-200},{2,184}},
          color={255,128,0},
          smooth=Smooth.None),
        Line(
          points={{2,-200},{148,-8}},
          color={255,128,0},
          smooth=Smooth.None,
          thickness=1),
        Rectangle(
          extent={{148,74},{174,-78}},
          lineColor={95,95,95},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{154,74},{158,-78}},
          lineColor={95,95,95},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{166,74},{170,-78}},
          lineColor={95,95,95},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid)}),
        Documentation(info="<html>
<p>
This model computes the distribution of the solar radiation gain
to the room surfaces.
Let
<i>N<sup>w</sup></i>
denote the number of windows,
<i>N<sup>f</sup></i>
the number of floor elements and
<i>N<sup>n</sup></i>
the number of non-floor elements such as ceiling, wall and window elements.
Input to the model are the solar radiosities
<i>J<sup>i</sup>, i &isin; {1, &hellip; , N<sup>w</sup>}</i>,
that were transmitted through the window.
The total incoming solar radiation is therefore
</p>
<p align=\"center\" style=\"font-style:italic;\">
H = &sum;<sub>i=1</sub><sup>N<sup>w</sup></sup> J<sub>in</sub><sup>i</sup>
</p>
<p>
It is assumed that <i>H</i> first hits the floor where some of it is absorbed,
and some of it is diffusely reflected to all other surfaces. Only the first
reflection is taken into account and the location of the floor patch
relative to the window is neglected.
</p>
<p>Hence, the radiation that is
absorbed by each floor patch <i>i &isin; {1, &hellip;, N<sup>f</sup>}</i>,
and may be partially transmitted in
the unusual case that the floor contains a window, is
</p>
<p align=\"center\" style=\"font-style:italic;\">
 Q<sup>i</sup> = H &nbsp; (&epsilon;<sup>i</sup>+&tau;<sup>i</sup>) &nbsp; A<sup>i</sup>
&frasl; &sum;<sub>j=1</sub><sup>N<sup>f</sup></sup> &nbsp; A<sup>j</sup>.
</p>
The sum of the radiation that is reflected by the floor is therefore
<p align=\"center\" style=\"font-style:italic;\">
 J<sup>f</sup> = H &nbsp;
&sum;<sub>i=1</sub><sup>N<sup>f</sup></sup>
(1-&epsilon;<sup>i</sup>-&tau;<sup>i</sup>) &nbsp; A<sup>i</sup>
&frasl; &sum;<sub>j=1</sub><sup>N<sup>f</sup></sup> &nbsp; A<sup>j</sup>.
</p>
<p>
This reflected radiosity is then distributed to all non-floor areas
<i>i &isin; {1, &hellip;, N<sup>n</sup>}</i>
using</p>
<p align=\"center\" style=\"font-style:italic;\">
  Q<sup>i</sup> = J<sup>f</sup> &nbsp;
A<sup>i</sup> &nbsp; (&epsilon;<sup>i</sup>+&tau;<sup>i</sup>)
&frasl;
&sum;<sub>k=1</sub><sup>N<sup>n</sup></sup>
A<sup>k</sup> &nbsp; (&epsilon;<sup>k</sup>+&tau;<sup>k</sup>)
</p>
<p>
For opaque surfaces, the heat flow rate
<i>Q<sup>i</sup></i>
is set to be equal to the heat flow rate at the heat port.
For the glass of the windows, the heat flow rate
<i>Q<sup>i</sup></i> is set to the radiosity
<i>J<sub>out</sub><sup>i</sup></i>
that will strike the glass or the window shade as diffuse solar
radiation.
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
November 6, 2011, by Michael Wetter:<br/>
Fixed bug as in the old version, the absorbtance and reflectance
of the infrared spectrum has been used instead of the solar spectrum.
</li>
<li>
Dec. 1 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SolarRadiationExchange;
