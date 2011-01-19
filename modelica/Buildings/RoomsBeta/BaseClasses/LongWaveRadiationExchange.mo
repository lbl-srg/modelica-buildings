within Buildings.RoomsBeta.BaseClasses;
model LongWaveRadiationExchange
  "Long-wave radiation heat exchange between the room facing surfaces"
  extends Buildings.RoomsBeta.BaseClasses.PartialSurfaceInterface;

  final parameter Integer NOpa = NConExt+2*NConExtWin+2*NConPar+NConBou+NSurBou
    "Number of opaque surfaces, including the window frame";
  final parameter Integer NWin = NConExtWin "Number of window surfaces";
  final parameter Integer NTot = NOpa + NWin "Total number of surfaces";
  final parameter Real epsOpa[NOpa](min=0, max=1, fixed=false)
    "Emissivity of opaque surfaces";
  final parameter Real rhoOpa[NOpa](min=0, max=1, fixed=false)
    "Reflectivity of opaque surfaces";
  final parameter Modelica.SIunits.Area AOpa[NOpa](fixed=false)
    "Surface area of opaque surfaces";
  final parameter Modelica.SIunits.Area A[NTot](fixed=false) "Surface areas";
  final parameter Real kOpa[NOpa](unit="W/K4", fixed=false)
    "Product sigma*epsilon*A for opaque surfaces";
  final parameter Real F[NTot,NTot](min=0, max=1, fixed=false)
    "View factor from surface i to j";
  final parameter Real M[NTot,NTot](min=0, max=1, fixed=false)
    "Incidence matrix, with elements of 1 if surfaces can see each other, or zero otherwise";
  parameter Boolean linearizeRadiation
    "Set to true to linearize emissive power";
  Modelica.SIunits.HeatFlowRate J[NTot](max=0, start=A .* 0.8*7385154648, nominal=10*419)
    "Radiosity leaving the surface";
  Modelica.SIunits.HeatFlowRate G[NTot](min=0, start=A .* 0.8*7385154648, nominal=10*419)
    "Radiosity entering the surface";
  constant Real T40(unit="K4") = 293.15^4 "Nominal temperature";
  Modelica.SIunits.Temperature TOpa[NOpa](each start=293.15, each nominal=293.15)
    "Tmperature of opaque surfaces";
  Real T4Opa[NOpa](each unit="K4", each start=T40, each nominal=293.15^4)
    "Forth power of temperature of opaque surfaces";
  Modelica.SIunits.HeatFlowRate Q_flow[NTot] "Heat flow rate at surfaces";

  HeatTransfer.Interfaces.RadiosityOutflow JOutConExtWin[NConExtWin]
    "Outgoing radiosity that connects to non-frame part of the window"
    annotation (Placement(transformation(extent={{240,110},{260,130}})));
  HeatTransfer.Interfaces.RadiosityInflow JInConExtWin[NConExtWin]
    "Incoming radiosity that connects to non-frame part of the window"
    annotation (Placement(transformation(extent={{260,70},{240,90}})));
protected
  parameter Modelica.SIunits.Temperature T0=293.15
    "Temperature used to linearize radiative heat transfer";
  final parameter Real T03(min=0, unit="K3")=T0^3 "3rd power of temperature T0"
 annotation(Evaluate=true);
  Modelica.SIunits.HeatFlowRate sumEBal "Sum of energy balance, should be zero";
initial equation
  // The next loops build the array epsOpa, AOpa and kOpa that simplify
  // the model equations.
  // These arrays store the values of the constructios in the following order
  // [x[1:NConExt] x[1:NConPar] x[1: NConPar] x[1: NConBou] x[1: NSurBou] x[1: NConExtWin] x[1: NConExtWin]]
  // where x is epsOpa, AOpa or kOpa.
  // The last two entries are for the opaque wall that contains a window, and for the window frame.
  for i in 1:NConExt loop
    epsOpa[i] = epsConExt[i];
    AOpa[i]   = AConExt[i];
    kOpa[i]   = Modelica.Constants.sigma * epsConExt[i] *AConExt[i];
  end for;
  for i in 1:NConPar loop
    epsOpa[i+NConExt]         = epsConPar_a[i];
    AOpa[i+NConExt]           = AConPar[i];
    kOpa[i+NConExt]           = Modelica.Constants.sigma * epsConPar_a[i] *AConPar[i];
    epsOpa[i+NConExt+NConPar] = epsConPar_b[i];
    AOpa[i+NConExt+NConPar]   = AConPar[i];
    kOpa[i+NConExt+NConPar]   = Modelica.Constants.sigma * epsConPar_b[i] *AConPar[i];
  end for;
  for i in 1:NConBou loop
    epsOpa[i+NConExt+2*NConPar] = epsConBou[i];
    AOpa[i+NConExt+2*NConPar]   = AConBou[i];
    kOpa[i+NConExt+2*NConPar]   = Modelica.Constants.sigma * epsConBou[i] *AConBou[i];
  end for;
  for i in 1:NSurBou loop
    epsOpa[i+NConExt+2*NConPar+NConBou] = epsSurBou[i];
    AOpa[i+NConExt+2*NConPar+NConBou]   = ASurBou[i];
    kOpa[i+NConExt+2*NConPar+NConBou]   = Modelica.Constants.sigma * epsSurBou[i] *ASurBou[i];
  end for;

  for i in 1:NConExtWin loop
    // Opaque part of construction that has a window embedded
    epsOpa[i+NConExt+2*NConPar+NConBou+NSurBou] = epsConExtWinOpa[i];
    AOpa[i+NConExt+2*NConPar+NConBou+NSurBou]   = AConExtWinOpa[i];
    kOpa[i+NConExt+2*NConPar+NConBou+NSurBou]   = Modelica.Constants.sigma * epsConExtWinOpa[i] *AConExtWinOpa[i];
    // Window frame
    epsOpa[i+NConExt+2*NConPar+NConBou+NSurBou+NConExtWin] = epsConExtWinFra[i];
    AOpa[i+NConExt+2*NConPar+NConBou+NSurBou+NConExtWin]   = AConExtWinFra[i];
    kOpa[i+NConExt+2*NConPar+NConBou+NSurBou+NConExtWin]   = Modelica.Constants.sigma * epsConExtWinFra[i] *AConExtWinFra[i];
  end for;
  // Vector with all surface areas.
  // The next loops build the array A that simplifies
  // the model equations.
  // These array stores the values of the constructios in the following order
  // [AOpa[1:NConExt] AOpa[1:NConPar] AOpa[1: NConPar] AOpa[1: NConBou] AOpa[1: NSurBou]
  //  AOpa[1: NConExtWin] AOpa[1: NConExtWin] AGla[1: NConExtWin]]
  // since NWin=NConExtWin.
  for i in 1:NOpa loop
    A[i] = AOpa[i];
  end for;
  for i in 1:NWin loop
    A[i+NOpa] = AConExtWinGla[i];
  end for;
  // Reflectivity for opaque surfaces
  rhoOpa = 1 .- epsOpa;
  // View factors for surface i to j.
  // We approximate the view factors in such a way that
  // they are proportional to the area of the receiving surface.
  // We make the following assumptions:
  //   - Surfaces cannot see themselve,
  //   - for conPar, surfaces a and b cannot see each other, and
  //   - glass, frame and opaque constructions that are in the same construction
  //     cannot see each other.
  for j in 1:NTot loop
      // Surfaces that can see conExt.
      // Assume all can see it, except that a surface cannot see itself
      for i in 1:NConExt loop
        M[i,j] = if (i == j) then 0 else 1;
     end for;
     // Surfaces that can see conPar_a.
     // Assume that surface a of conPar cannot see surface b, and vice versa
     for i in NConExt+1 : NConExt+NConPar loop
       M[i,j] = if (i == j or j == i+NConPar) then 0 else 1;
    end for;
     for i in NConExt+NConPar+1 : NConExt+2*NConPar loop
       M[i,j] = if (i == j or j == i-NConPar) then 0 else 1;
     end for;
     // NConBou and NSurBou can see all other surfaces
     for i in NConExt+2*NConPar+1 : NConExt+2*NConPar+NConBou+NSurBou loop
       M[i,j] = if (i == j) then 0 else 1;
     end for;
     // NConExtWin cannot see themselve, nor can they see their frame or their window
     for i in NConExt+2*NConPar+NConBou+NSurBou+1 : NConExt+2*NConPar+NConBou+NSurBou+NConExtWin loop
       M[i,j] = if (i == j or j == i+NConExtWin or j == i+2*NConExtWin) then 0 else 1;
     end for;
     for i in NConExt+2*NConPar+NConBou+NSurBou+NConExtWin+1 : NConExt+2*NConPar+NConBou+NSurBou+2*NConExtWin loop
       M[i,j] = if (i == j or j == i-NConExtWin or j == i+NConExtWin) then 0 else 1;
     end for;
     for i in NConExt+2*NConPar+NConBou+NSurBou+2*NConExtWin+1 : NConExt+2*NConPar+NConBou+NSurBou+3*NConExtWin loop
       M[i,j] = if (i == j or j == i-NConExtWin or j == i-2*NConExtWin) then 0 else 1;
     end for;
  end for;
 // View factors from surface i to surface j
  for i in 1:NTot loop
    if ( sum((M[i,k] * A[k]) for k in 1:NTot) < 10E-20) then
      // This is the special case where only one construction is in the room
       for j in 1:NTot loop
         F[i,j] = if (i==j) then 1 else 0;
       end for;
    else
      // This is the usual situation
       for j in 1:NTot loop
         F[i,j] = (M[i,j] * A[j]) /sum((M[i,k] * A[k]) for k in 1:NTot);
       end for;
    end if;
  end for;

  // Test whether the view factors add up to one, or the sum is zero in case there
  // is only one construction
  for i in 1:NTot loop
    assert((abs(1-sum(F[i,j] for j in 1:NTot))) < 1E-10 or (abs(sum(F[i,j] for j in 1:NTot)) < 1E-10),
           "Program error: Sum of view factors is " + realString(sum(F[i,j] for j in 1:NTot)));
  end for;
////////////////////////////////////////////////////////////////////
equation
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
  // 4th power of temperature
  if linearizeRadiation then
    T4Opa = T03 .* TOpa;
  else
    T4Opa = TOpa.^4;
  end if;
  // Incoming radiosity at each surface
  // is equal Modelica.SIunits.HeatFlowRateto the negative of the outgoing radiosity of
  // all other surfaces times the view factor
  for j in 1:NTot loop
    G[j] = -sum(J[i] * F[i,j] for i in 1:NTot);
  end for;
  // Outgoing radiosity
  // Opaque surfaces.
  // If kOpa[j]=epsLW[j]*A[j] < 1E-28, then A < 1E-20 and the surface is
  // from a dummy construction. In this situation, we set T40=293.15^4 to
  // avoid a singularity.
  for j in 1:NOpa loop
    T4Opa[j] = if (kOpa[j] > 1E-28) then (-J[j]-rhoOpa[j] * G[j])/kOpa[j] else T40;
  end for;
  // Assign radiosity that comes from window
  // and that leaves window.
  // J < 0 because it leaves the surface
  // G > 0 because it strikes the surface
  // JIn > 0 because it enters the model
  // JOut < 0 because it leaves the model
  for j in 1:NWin loop
    J[j+NOpa] = -JInConExtWin[j];
    G[j+NOpa] = -JOutConExtWin[j];
  end for;
  // Net heat exchange
  Q_flow = -J-G;

  // Assign heat exchange to connectors
  for i in 1:NConExt loop
    Q_flow[i] = conExt[i].Q_flow;
  end for;
  for i in 1:NConPar loop
    Q_flow[i+NConExt]         = conPar_a[i].Q_flow;
    Q_flow[i+NConExt+NConPar] = conPar_b[i].Q_flow;
  end for;
  for i in 1:NConBou loop
    Q_flow[i+NConExt+2*NConPar] = conBou[i].Q_flow;
  end for;
  for i in 1:NSurBou loop
    Q_flow[i+NConExt+2*NConPar+NConBou] = conSurBou[i].Q_flow;
  end for;
  for i in 1:NConExtWin loop
    Q_flow[i+NConExt+2*NConPar+NConBou+NSurBou]            = conExtWin[i].Q_flow;
    Q_flow[i+NConExt+2*NConPar+NConBou+NSurBou+NConExtWin] = conExtWinFra[i].Q_flow;
  end for;
  // Sum of energy balance
  // Remove sumEBal and assert statement for final release
  sumEBal = sum(conExt.Q_flow)+sum(conPar_a.Q_flow)+sum(conPar_b.Q_flow)
    +sum(conBou.Q_flow)+sum(conSurBou.Q_flow)+sum(conExtWin.Q_flow)+sum(conExtWinFra.Q_flow)
    +(sum(JInConExtWin)+sum(JOutConExtWin));
  assert(abs(sumEBal) < 1E-1, "Program error: Energy is not conserved in LongWaveRadiationExchange."
   + "\n  Sum of all energy is " + realString(sumEBal));
  annotation (
preferedView="info",
Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-240,
            -240},{240,240}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-240,-240},{240,240}}),
                                      graphics={
        Line(
          points={{-144,-8},{146,-8}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-144,-8},{2,184}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-144,-8},{2,-200}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{2,-200},{2,184}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{2,184},{148,-8}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{2,-200},{148,-8}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5)}),
Documentation(
info="<html>
<p>
This model computes the long-wave radiative heat transfer between the interior
surfaces of a room. Each opaque surface emits radiation according to
<p/>
<p align=\"center\" style=\"font-style:italic;\">
  E<sup>i</sup> = &sigma; &nbsp; A<sup>i</sup> &nbsp; &epsilon;<sup>i</sup> &nbsp; 
(T<sup>i</sup>)<sup>4</sup>,
<p/>
<p>
where
<i>&sigma;</i>
is the Stefan-Boltzmann constant,
<i>A<sup>i</sup> </i>
is the surface area,
<i>&epsilon;<sup>i</sup> </i>
is the emissivity in the infrared spectrum, and
<i>T<sup>i</sup></i>
is the surface temperature.
If the parameter <code>linearizeRadidation</code> is set to <code>true</code>,
then the term <i>(T<sup>i</sup>)<sup>4</sup></i> is replaced with
<i>T<sub>0</sub><sup>3</sup> T<sup>i</sup></i>
where <i>T<sub>0</sub> = 20&deg;C</i> is a parameter.
</p>
<p>
The incoming radiation at surface <i>i</i> is
<p/>
<p align=\"center\" style=\"font-style:italic;\">
  G<sup>i</sup> = -&sum;<sub>i &ne; j</sub> &nbsp; F<sup>j,i</sup> &nbsp; J<sup>j</sup>
<p/>
<p>
where 
<i>F<sup>j,i</sup></i> 
is the view factor from surface
<i>j</i> to surface <i>i</i>, 
<i>J<sup>j</sup></i> 
is the radiosity leaving surface <i>j</i>
and the sum is over all surfaces with <i>i &ne; j</i>.
For opaque surfaces, it follows from the first law
that the radiosity
<i>J<sup>i</sup></i> 
is
<p/>
<p align=\"center\" style=\"font-style:italic;\">
 J<sup>i</sup> = -E<sup>i</sup>  - (1-&epsilon;<sup>i</sup>) &nbsp; G<sup>i</sup>.
<p/>
<p>
For windows, the outgoing radiosity is an input into this model
because the window model computes this quantity directly.
</p>
<p>
For each surface <i>i</i>, the heat balance is
<p/>
<p align=\"center\" style=\"font-style:italic;\">
  0 = Q<sup>i</sup> + J<sup>i</sup> + G<sup>i</sup>.
<p/>
<p>
For opaque surfaces, the heat flow rate 
<i>Q<sup>i</sup></i> 
is set to be equal to the heat flow rate at the heat port.
For the glass of the windows, the radiosity outflow at the connector is
set to the radiosity
<i>G<sup>i</sup></i>
that is leaving the surface.
<p/>
<p>
The model computes the view factors between each surface using the following
assumptions:
<ol>
<li>
 The view factor from surface <i>i</i> to <i>j</i> is simplified as
  <i>F<sup>i,j</sup> = A<sup>j</sup> / &sum;<sub>k &ne; j</sub> A<sup>k</sup></i>, that is, only the surface areas are taken into account, but not their
orientation and location.
</li>
<li>
For interior partitions (instances <code>conPar</code>), the surfaces 
<code>a</code> and <code>b</code> cannot see each other.
</li>
<li>
Glass, frame and opaque construction of the same element in <code>conExtWin</code> 
cannot see each other.
</li>
</ol>
</p>
</html>",
revisions="<html>
<ul>
<li>
Dec. 1 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end LongWaveRadiationExchange;
