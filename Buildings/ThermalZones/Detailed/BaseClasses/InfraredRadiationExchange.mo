within Buildings.ThermalZones.Detailed.BaseClasses;
model InfraredRadiationExchange
  "Infrared radiation heat exchange between the room facing surfaces"
  extends Buildings.ThermalZones.Detailed.BaseClasses.PartialSurfaceInterfaceRadiative;

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Boolean linearizeRadiation
    "Set to true to linearize emissive power";
  parameter Boolean sampleModel=false
    "Set to true to time-sample the model, which can give shorter simulation time if there is already time sampling in the system model"
    annotation (Evaluate=true, Dialog(tab=
          "Experimental (may be changed in future releases)"));

  HeatTransfer.Interfaces.RadiosityInflow JInConExtWin[NConExtWin] if
    haveConExtWin
    "Incoming radiosity that connects to non-frame part of the window"
    annotation (Placement(transformation(extent={{260,70},{240,90}})));
  HeatTransfer.Interfaces.RadiosityOutflow JOutConExtWin[NConExtWin]
    "Outgoing radiosity that connects to non-frame part of the window"
    annotation (Placement(transformation(extent={{240,110},{260,130}})));
protected
  constant Real T30(unit="K3") = 293.15^3 "Nominal temperature";
  constant Real T40(unit="K4") = 293.15^4 "Nominal temperature";

  final parameter Integer NOpa=NConExt + 2*NConExtWin + 2*NConPar + NConBou +
      NSurBou "Number of opaque surfaces, including the window frame";
  final parameter Integer nOpa=nConExt + 2*nConExtWin + 2*nConPar + nConBou +
      nSurBou "Number of opaque surfaces, including the window frame";
  final parameter Integer NWin=NConExtWin "Number of window surfaces";
  final parameter Integer nWin=nConExtWin "Number of window surfaces";
  final parameter Integer NTot=NOpa + NWin "Total number of surfaces";
  final parameter Integer nTot=nOpa + nWin "Total number of surfaces";
  final parameter Real epsOpa[nOpa](
    each min=0,
    each max=1,
    each fixed=false) "Absorptivity of opaque surfaces";
  final parameter Real rhoOpa[nOpa](
    each min=0,
    each max=1,
    each fixed=false) "Reflectivity of opaque surfaces";
  final parameter Modelica.SIunits.Area AOpa[nOpa](each fixed=false)
    "Surface area of opaque surfaces";
  final parameter Modelica.SIunits.Area A[nTot](each fixed=false)
    "Surface areas";
  final parameter Real kOpa[nOpa](each unit="W/K4", each fixed=false)
    "Product sigma*epsilon*A for opaque surfaces";
  final parameter Real kOpaInv[nOpa](each unit="K4/W", each fixed=false)
    "Inverse of kOpa, used to avoid having to use a safe division";
  final parameter Real F[nTot, nTot](
    each min=0,
    each max=1,
    each fixed=false) "View factor from surface i to j";

  parameter Modelica.SIunits.Time t0(fixed=false) "First sample time instant";

  Buildings.HeatTransfer.Interfaces.RadiosityInflow JInConExtWin_internal[
    NConExtWin](start=AConExtWinGla*0.8*Modelica.Constants.sigma*293.15^4,
      each fixed=sampleModel and nConExtWin > 0)
    "Incoming radiosity that connects to non-frame part of the window";

  Modelica.SIunits.HeatFlowRate J[nTot](
    each max=0,
    start=-A .* 0.8*Modelica.Constants.sigma*293.15^4,
    fixed={sampleModel and (i <= nOpa or i > nOpa + nWin) for i in 1:nTot},
    each nominal=10*0.8*Modelica.Constants.sigma*293.15^4)
    "Radiosity leaving the surface";

  Modelica.SIunits.HeatFlowRate G[nTot](
    each min=0,
    start=A .* 0.8*Modelica.Constants.sigma*293.15^4,
    each nominal=10*0.8*Modelica.Constants.sigma*293.15^4)
    "Radiosity entering the surface";

  Modelica.SIunits.Temperature TOpa[nOpa](each start=293.15, each nominal=
        293.15) "Temperature of opaque surfaces";
  Real T4Opa[nOpa](
    each unit="K4",
    each start=T40,
    each nominal=293.15^4) "Forth power of temperature of opaque surfaces";
  Modelica.SIunits.HeatFlowRate Q_flow[nTot](each start=0, each fixed=
        sampleModel) "Heat flow rate at surfaces";
  parameter Modelica.SIunits.Temperature T0=293.15
    "Temperature used to linearize radiative heat transfer";
  final parameter Real T03(
    min=0,
    unit="K3") = T0^3 "3rd power of temperature T0";
  Modelica.SIunits.HeatFlowRate sumEBal(start=0, fixed=sampleModel)
    "Sum of energy balance, should be zero";
initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

  // The next loops build the array epsOpa, AOpa and kOpa that simplify
  // the model equations.
  // These arrays store the values of the constructios in the following order
  // [x[1:NConExt] x[1:NConPar] x[1: NConPar] x[1: NConBou] x[1: NSurBou] x[1: NConExtWin] x[1: NConExtWin]]
  // where x is epsOpa, AOpa or kOpa.
  // The last two entries are for the opaque wall that contains a window, and for the window frame.
  for i in 1:nConExt loop
    epsOpa[i] = epsConExt[i];
    AOpa[i] = AConExt[i];
    kOpa[i] = Modelica.Constants.sigma*epsConExt[i]*AOpa[i];
  end for;
  for i in 1:nConPar loop
    epsOpa[i + nConExt] = epsConPar_a[i];
    AOpa[i + nConExt] = AConPar[i];
    kOpa[i + nConExt] = Modelica.Constants.sigma*epsConPar_a[i]*AOpa[i +
      nConExt];
    epsOpa[i + nConExt + nConPar] = epsConPar_b[i];
    AOpa[i + nConExt + nConPar] = AConPar[i];
    kOpa[i + nConExt + nConPar] = Modelica.Constants.sigma*epsConPar_b[i]*AOpa[
      i + nConExt + nConPar];
  end for;
  for i in 1:nConBou loop
    epsOpa[i + nConExt + 2*nConPar] = epsConBou[i];
    AOpa[i + nConExt + 2*nConPar] = AConBou[i];
    kOpa[i + nConExt + 2*nConPar] = Modelica.Constants.sigma*epsConBou[i]*AOpa[
      i + nConExt + 2*nConPar];
  end for;
  for i in 1:nSurBou loop
    epsOpa[i + nConExt + 2*nConPar + nConBou] = epsSurBou[i];
    AOpa[i + nConExt + 2*nConPar + nConBou] = ASurBou[i];
    kOpa[i + nConExt + 2*nConPar + nConBou] = Modelica.Constants.sigma*
      epsSurBou[i]*AOpa[i + nConExt + 2*nConPar + nConBou];
  end for;
  for i in 1:nConExtWin loop
    // Opaque part of construction that has a window embedded
    epsOpa[i + nConExt + 2*nConPar + nConBou + nSurBou] = epsConExtWinOpa[i];
    AOpa[i + nConExt + 2*nConPar + nConBou + nSurBou] = AConExtWinOpa[i];
    kOpa[i + nConExt + 2*nConPar + nConBou + nSurBou] = Modelica.Constants.sigma
      *epsConExtWinOpa[i]*AOpa[i + nConExt + 2*nConPar + nConBou + nSurBou];
    // Window frame
    epsOpa[i + nConExt + 2*nConPar + nConBou + nSurBou + nConExtWin] =
      epsConExtWinFra[i];
    AOpa[i + nConExt + 2*nConPar + nConBou + nSurBou + nConExtWin] =
      AConExtWinFra[i];
    kOpa[i + nConExt + 2*nConPar + nConBou + nSurBou + nConExtWin] = Modelica.Constants.sigma
      *epsConExtWinFra[i]*AOpa[i + nConExt + 2*nConPar + nConBou + nSurBou +
      nConExtWin];
  end for;
  // Vector with all surface areas.
  // The next loops build the array A that simplifies
  // the model equations.
  // These array stores the values of the constructios in the following order
  // [AOpa[1:nConExt] AOpa[1:nConPar] AOpa[1: nConPar] AOpa[1: nConBou] AOpa[1: nSurBou]
  //  AOpa[1: nConExtWin] AOpa[1: nConExtWin] AGla[1: nConExtWin]]
  // since nWin=nConExtWin.
  for i in 1:nOpa loop
    A[i] = AOpa[i];
  end for;
  for i in 1:nWin loop
    A[i + nOpa] = AConExtWinGla[i];
  end for;
  // Reflectivity for opaque surfaces
  rhoOpa = 1 .- epsOpa;
  // View factors from surface i to surface j
  for i in 1:nTot loop
    for j in 1:nTot loop
      F[i, j] = A[j]/sum((A[k]) for k in 1:nTot);
    end for;
  end for;
  for i in 1:nOpa loop
    kOpaInv[i] = 1/kOpa[i];
  end for;
  // Test whether the view factors add up to one, or the sum is zero in case there
  // is only one construction
  for i in 1:nTot loop
    assert((abs(1 - sum(F[i, j] for j in 1:nTot))) < 1E-10,
      "Program error: Sum 1 of view factors is " + String(sum(F[i, j] for j in
      1:nTot)));
  end for;

  t0 = time;
  ////////////////////////////////////////////////////////////////////
equation
  // Conditional connector
  connect(JInConExtWin, JInConExtWin_internal);
  if not haveConExtWin then
    JInConExtWin_internal = fill(0, NConExtWin);
  end if;
  // Assign temperature of opaque surfaces
  for i in 1:nConExt loop
    TOpa[i] = conExt[i].T;
  end for;
  for i in 1:nConPar loop
    TOpa[i + nConExt] = conPar_a[i].T;
    TOpa[i + nConExt + nConPar] = conPar_b[i].T;
  end for;
  for i in 1:nConBou loop
    TOpa[i + nConExt + 2*nConPar] = conBou[i].T;
  end for;
  for i in 1:nSurBou loop
    TOpa[i + nConExt + 2*nConPar + nConBou] = conSurBou[i].T;
  end for;
  for i in 1:nConExtWin loop
    TOpa[i + nConExt + 2*nConPar + nConBou + nSurBou] = conExtWin[i].T;
    TOpa[i + nConExt + 2*nConPar + nConBou + nConExtWin + nSurBou] =
      conExtWinFra[i].T;
  end for;
  // Incoming radiosity at each surface
  // is equal to the negative of the outgoing radiosity of
  // all other surfaces times the view factor
  if sampleModel then
    // experimental mode to sample the model which can give shorter
    // simulation time if there is already a sampling in the system model
    when sample(t0, 2*60) then
      G = -transpose(F)*pre(J);
      // Net heat exchange
      Q_flow = -pre(J) - G;
      // Outgoing radiosity
      // Sum of energy balance
      // Remove sumEBal and assert statement for final release
      sumEBal = sum(conExt.Q_flow) + sum(conPar_a.Q_flow) + sum(conPar_b.Q_flow)
         + sum(conBou.Q_flow) + sum(conSurBou.Q_flow) + sum(conExtWin.Q_flow)
         + sum(conExtWinFra.Q_flow) + (sum(JInConExtWin_internal) - sum(
        JOutConExtWin));
    end when;
  else
    G = -transpose(F)*J;
    // Net heat exchange
    Q_flow = -J - G;
    // Outgoing radiosity
    // Sum of energy balance
    // Remove sumEBal and assert statement for final release
    sumEBal = sum(conExt.Q_flow) + sum(conPar_a.Q_flow) + sum(conPar_b.Q_flow)
       + sum(conBou.Q_flow) + sum(conSurBou.Q_flow) + sum(conExtWin.Q_flow) +
      sum(conExtWinFra.Q_flow) + (sum(JInConExtWin_internal) - sum(
      JOutConExtWin));
    assert(abs(sumEBal) < 1E-1, "Program error: Energy is not conserved in InfraredRadiationExchange.
    Sum of all energy is " + String(sumEBal));
  end if;

  // Opaque surfaces.
  // If kOpa[j]=absIR[j]*A[j] < 1E-28, then A < 1E-20 and the surface is
  // from a dummy construction. In this situation, we set T40=293.15^4 to
  // avoid a singularity.
  for j in 1:nOpa loop
    //   T4Opa[j] = if (kOpa[j] > 1E-28) then (Q_flow[j]-epsOpa[j] * G[j])/kOpa[j] else T40;
    T4Opa[j] = (-J[j] - rhoOpa[j]*G[j])*kOpaInv[j];
  end for;
  // 4th power of temperature
  if linearizeRadiation then
    TOpa = (T4Opa .+ 3*T40)/(4*T30);
    // Based on T4 = 4*T30*T-3*T40
  else
    if homotopyInitialization then
      TOpa = homotopy(actual=Buildings.Utilities.Math.Functions.powerLinearized(
        x=T4Opa,
        x0=243.15^4,
        n=0.25), simplified=(T4Opa .+ 3*T40)/(4*T30));
    else
      TOpa = Buildings.Utilities.Math.Functions.powerLinearized(
        x=T4Opa,
        x0=243.15^4,
        n=0.25);
    end if;
  end if;
  // Assign radiosity that comes from window
  // and that leaves window.
  // J < 0 because it leaves the surface
  // G > 0 because it strikes the surface
  for j in 1:nWin loop
    J[j + nOpa] = -JInConExtWin_internal[j];
    G[j + nOpa] = +JOutConExtWin[j];
  end for;

  // Assign heat exchange to connectors
  for i in 1:nConExt loop
    Q_flow[i] = conExt[i].Q_flow;
  end for;
  if nConExt == 0 then
    conExt[1].T = T0;
  end if;
  for i in 1:nConPar loop
    Q_flow[i + nConExt] = conPar_a[i].Q_flow;
    Q_flow[i + nConExt + nConPar] = conPar_b[i].Q_flow;
  end for;
  if nConPar == 0 then
    conPar_a[1].T = T0;
    conPar_b[1].T = T0;
  end if;
  for i in 1:nConBou loop
    Q_flow[i + nConExt + 2*nConPar] = conBou[i].Q_flow;
  end for;
  if nConBou == 0 then
    conBou[1].T = T0;
  end if;
  for i in 1:nSurBou loop
    Q_flow[i + nConExt + 2*nConPar + nConBou] = conSurBou[i].Q_flow;
  end for;
  if nSurBou == 0 then
    conSurBou[1].T = T0;
  end if;
  for i in 1:nConExtWin loop
    Q_flow[i + nConExt + 2*nConPar + nConBou + nSurBou] = conExtWin[i].Q_flow;
    Q_flow[i + nConExt + 2*nConPar + nConBou + nSurBou + nConExtWin] =
      conExtWinFra[i].Q_flow;
  end for;
  if nConExtWin == 0 then
    conExtWin[1].T = T0;
    conExtWinFra[1].T = T0;
    JOutConExtWin[1] = 0;
  end if;

  annotation (
    preferredView="info",
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-240,-240},{240,
            240}})),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-240,-240},{240,
            240}}), graphics={
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
    Documentation(info="<html>
<p>
This model computes the infrared radiative heat transfer between the interior
surfaces of a room. Each opaque surface emits radiation according to
</p>
<p align=\"center\" style=\"font-style:italic;\">
  E<sup>i</sup> = &sigma; &nbsp; A<sup>i</sup> &nbsp; &epsilon;<sup>i</sup> &nbsp;
(T<sup>i</sup>)<sup>4</sup>,
</p>
<p>
where
<i>&sigma;</i>
is the Stefan-Boltzmann constant,
<i>A<sup>i</sup> </i>
is the surface area,
<i>&epsilon;<sup>i</sup> </i>
is the absorptivity in the infrared spectrum, and
<i>T<sup>i</sup></i>
is the surface temperature.
If the parameter <code>linearizeRadidation</code> is set to <code>true</code>,
then the term <i>(T<sup>i</sup>)<sup>4</sup></i> is replaced with
<i>T<sub>0</sub><sup>3</sup> T<sup>i</sup></i>,
where <i>T<sub>0</sub> = 20&deg;C</i> is a parameter.
</p>
<p>
The incoming radiation at surface <i>i</i> is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  G<sup>i</sup> = -&sum;<sub>j</sub> &nbsp; F<sup>j,i</sup> &nbsp; J<sup>j</sup>
</p>
<p>
where
<i>F<sup>j,i</sup></i>
is the view factor from surface
<i>j</i> to surface <i>i</i>,
<i>J<sup>j</sup></i>
is the radiosity leaving surface <i>j</i>
and the sum is over all surfaces.
For opaque surfaces, it follows from the first law
that the radiosity
<i>J<sup>i</sup></i>
is
</p>
<p align=\"center\" style=\"font-style:italic;\">
 J<sup>i</sup> = -E<sup>i</sup>  - (1-&epsilon;<sup>i</sup>) &nbsp; G<sup>i</sup>.
</p>
<p>
For windows, the outgoing radiosity is an input into this model
because the window model computes this quantity directly.
</p>
<p>
For each surface <i>i</i>, the heat balance is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  0 = Q<sup>i</sup> + J<sup>i</sup> + G<sup>i</sup>.
</p>
<p>
For opaque surfaces, the heat flow rate
<i>Q<sup>i</sup></i>
is set to be equal to the heat flow rate at the heat port.
For the glass of the windows, the radiosity outflow at the connector is
set to the radiosity
<i>G<sup>i</sup></i>
that is leaving the surface.
</p>
<p>
The view factor from surface <i>i</i> to <i>j</i> is approximated as
<p align=\"center\" style=\"font-style:italic;\">
  F<sup>i,j</sup> = A<sup>j</sup> &frasl; &sum;<sub>k </sub> A<sup>k</sup>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">IBPSA, #1341</a>.
</li>
<li>
January 23, 2017, by Michael Wetter:<br/>
Corrected wrong start value for <code>J</code>.
The start value was positive, but <code>J(each max =0)</code>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/627\">issue 627</a>.
</li>
<li>
May 21, 2015, by Michael Wetter:<br/>
Reformulated to reduce use of the division macro
in Dymola.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/417\">issue 417</a>.
</li>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
June 27, 2013, by Michael Wetter:<br/>
Changed model because the outflowing radiosity has been changed to be a non-negative quantity.
See track issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/158\">#158</a>.
</li>
<li>
April 18, 2013, by Michael Wetter:<br/>
Removed <code>cardinality</code> function as this is
deprecated in the MSL specification and not correctly implemented in omc.
</li>
<li>
February 10, 2012 by Wangda Zuo:<br/>
Fixed a bug for linearization of T4.
</li>
<li>
April 21, 2011 by Michael Wetter:<br/>
Fixed a bug in the view factor calculation, and rewrote the model to reduce simulation time. The bug caused too much radiosity to flow from large to small surfaces because the law of reciprocity for view factors was not satisfied. This led to low surface temperatures if a surface had a large area compared to other surfaces.
</li>
<li>
April 2, 2011 by Michael Wetter:<br/>
Added <code>homotopy</code> operator.
</li>
<li>
Feb. 3, 2011, by Michael Wetter:<br/>
Corrected bug in start value of radiosity, reformulated equations to get
smaller system of coupled equations.
</li>
<li>
Dec. 1, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end InfraredRadiationExchange;
