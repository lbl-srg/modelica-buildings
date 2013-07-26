within Buildings.Rooms.BaseClasses;
model AirHeatMassBalanceFFD
  "Heat and mass balance of the air based on fast fluid flow dynamics"
  extends Buildings.Rooms.BaseClasses.PartialAirHeatMassBalance(
   energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial,
   massDynamics = Modelica.Fluid.Types.Dynamics.DynamicFreeInitial);

  parameter Boolean useFFD = true
    "Set to false to deactivate the FFD interface and use instead yFixed as output"
    annotation(Evaluate = true);

  parameter Modelica.SIunits.Time samplePeriod(min=100*Modelica.Constants.eps)
    "Sample period of component"
    annotation(Dialog(group = "Sampling"));
  parameter Modelica.SIunits.Time startTime
    "First sample time instant. fixme: this should be at first step."
    annotation(Dialog(group = "Sampling"));

  // fixme: for the ffd instance, need to correctly assign uStart, flaWri and yFixed
  FFDExchange ffd(
    final startTime=startTime,
    final activateInterface=useFFD,
    final samplePeriod = if useFFD then samplePeriod else Modelica.Constants.inf,
    uStart=fill(T0, kFluIntC_inflow+Medium.nC*nPorts),
    nWri=kFluIntC_inflow+Medium.nC*nPorts,
    nRea=kFluIntC_outflow+Medium.nC*nPorts)
    "Block that exchanges data with the FFD simulation"
    annotation (Placement(transformation(extent={{-40,180},{-20,200}})));

protected
  constant Modelica.SIunits.Temperature T0 = 293.15
    "Temperature used for conditionally removed constructions";

  // Interfaces between the FFD block and the heat ports of this model
  FFDSurfaceInterface ffdConExt(final n=NConExt) if haveConExt
    "Interface to heat port of exterior constructions"
    annotation (Placement(transformation(extent={{180,210},{200,230}})));

  FFDSurfaceInterface ffdConExtWin(final n=NConExtWin) if haveConExtWin
    "Interface to heat port of opaque part of exterior constructions with window"
    annotation (Placement(transformation(extent={{180,170},{200,190}})));

  FFDSurfaceInterface ffdGlaUns(final n=NConExtWin) if haveConExtWin
    "Interface to heat port of unshaded part of glass"
    annotation (Placement(transformation(extent={{180,110},{200,130}})));

  FFDSurfaceInterface ffdGlaSha(final n=NConExtWin) if haveShade
    "Interface to heat port of shaded part of glass"
    annotation (Placement(transformation(extent={{180,70},{200,90}})));

  FFDSurfaceInterface ffdConExtWinFra(final n=NConExtWin) if haveConExtWin
    "Interface to heat port of window frame"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));

  FFDSurfaceInterface ffdConPar_a(final n=NConPar) if haveConPar
    "Interface to heat port of surface a of partition constructions"
    annotation (Placement(transformation(extent={{180,-70},{200,-50}})));

  FFDSurfaceInterface ffdConPar_b(final n=NConPar) if haveConPar
    "Interface to heat port of surface b of partition constructions"
    annotation (Placement(transformation(extent={{180,-110},{200,-90}})));

  FFDSurfaceInterface ffdConBou(final n=NConBou) if haveConBou
    "Interface to heat port that connects to room-side surface of constructions that expose their other surface to the outside"
    annotation (Placement(transformation(extent={{180,-170},{200,-150}})));

  FFDSurfaceInterface ffdSurBou(final n=NSurBou) if haveSurBou
    "Interface to heat port of surfaces of models that compute the heat conduction outside of this room"
    annotation (Placement(transformation(extent={{180,-230},{200,-210}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
                      ffdHeaPorAir "Interface to heat port of air node"
    annotation (Placement(transformation(extent={{-182,-10},{-202,10}})));

  FFDFluidInterface fluInt(
    redeclare final package Medium = Medium,
    final nPorts=nPorts,
    final V=V,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal) "Fluid interface"
    annotation (Placement(transformation(extent={{10,-198},{-10,-178}})));

  // The following list declares the first index minus 1
  // of the input and output signals to the FFD block.
  // These parameters are then used to loop over the connectors, such
  // as
  //    for i in kConExt+1:kConExt+nConExt loop
  //      ...
  //    end for;
  final parameter Integer kConExt = 0
    "Offset used to connect FFD signals to conExt";
  final parameter Integer kConExtWin = kConExt + nConExt
    "Offset used to connect FFD signals to conExtWin";
  final parameter Integer kGlaUns =    kConExtWin + nConExtWin
    "Offset used to connect FFD signals to glaUns";
  final parameter Integer kGlaSha = kGlaUns + nConExtWin
    "Offset used to connect FFD signals to glaSha";
  final parameter Integer kConExtWinFra = if haveShade then kGlaSha + nConExtWin else kGlaSha
    "Offset used to connect FFD signals to glaSha";
  final parameter Integer kConPar_a = kConExtWinFra + nConExtWin
    "Offset used to connect FFD signals to conPar_a";
  final parameter Integer kConPar_b = kConPar_a + nConPar
    "Offset used to connect FFD signals to conPar_b";
  final parameter Integer kConBou = kConPar_b + nConPar
    "Offset used to connect FFD signals to conBou";
  final parameter Integer kSurBou = kConBou + nConBou
    "Offset used to connect FFD signals to surBou";
  final parameter Integer kHeaPorAir = kSurBou + nSurBou
    "Offset used to connect FFD output signal to air heat port (to send average temperature from FFD to Modelica)";
//  final parameter Integer kUSha = kHeaPorAir + 1
  final parameter Integer kUSha = kSurBou + nSurBou
    "Offset used to connect FFD signals to input signal of shade";
  final parameter Integer kQRadAbs_flow = if haveShade then kUSha + nConExtWin else kUSha
    "Offset used to connect FFD signals to input signal that contains the radiation absorbed by the shade";
  // Because heaPorAir is only receiving T from FFD, but does not send Q_flow to FFD, there is no '+1' increment
  // for kTSha
  final parameter Integer kTSha = kHeaPorAir + 1
    "Offset used to connect FFD signals to output signal that contains the shade temperature";

  final parameter Integer kFluIntP = if haveShade then kQRadAbs_flow + nConExtWin else kQRadAbs_flow
    "Offset used to connect FFD signals to input signal for pressure from the fluid ports";

  final parameter Integer kFluIntM_flow = kFluIntP + 1
    "Offset used to connect FFD signals to input signals for mass flow rate from the fluid ports";
  final parameter Integer kFluIntT_inflow = kFluIntM_flow + nPorts
    "Offset used to connect FFD signals to input signals for inflowing temperature from the fluid ports";
  final parameter Integer kFluIntXi_inflow = kFluIntT_inflow + nPorts
    "Offset used to connect FFD signals to input signals for inflowing species concentration from the fluid ports";

  final parameter Integer kFluIntC_inflow = kFluIntXi_inflow + nPorts*Medium.nXi
    "Offset used to connect FFD signals to input signals for inflowing trace substances from the fluid ports";

  // Input signals to fluInt block
//  final parameter Integer kFluIntP2nPorts = if haveShade then kTSha + nConExtWin else kTSha
//    "Offset used to connect FFD signals to output signals for the fluid ports";
  final parameter Integer kFluIntT_outflow = if haveShade then kTSha + nConExtWin else kTSha
    "Offset used to connect FFD signals to outgoing temperature for the fluid ports";
  final parameter Integer kFluIntXi_outflow = kFluIntT_outflow+nPorts
    "Offset used to connect FFD signals to outgoing species concentration for the fluid ports";
  final parameter Integer kFluIntC_outflow = kFluIntXi_outflow+nPorts*Medium.nXi
    "Offset used to connect FFD signals to outgoing trace substances for the fluid ports";

equation
  //////////////////////////////////////////////////////////////////////
  // Data exchange with FFD block
  if haveConExt then
    for i in 1:nConExt loop
      connect(ffd.u[kConExt+i], ffdConExt.T[i]) annotation (Line(
        points={{-42,190},{-60,190},{-60,216},{179,216}},
        color={0,0,127},
        smooth=Smooth.None));
      connect(ffd.y[kConExt+i], ffdConExt.Q_flow[i]) annotation (Line(
        points={{-19,190},{60,190},{60,226},{178,226}},
        color={0,0,127},
        smooth=Smooth.None));
    end for;
  end if;

  if haveConExtWin then
    for i in 1:nConExtWin loop
      connect(ffd.u[kConExtWin+i], ffdConExtWin.T[i])
          annotation (Line(
          points={{-42,190},{-60,190},{-60,176},{179,176}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(ffd.y[kConExtWin+i], ffdConExtWin.Q_flow[i])
          annotation (Line(
          points={{-19,190},{60,190},{60,186},{178,186}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(ffd.u[kGlaUns+i], ffdGlaUns.T[i])
          annotation (Line(
          points={{-42,190},{-60,190},{-60,116},{179,116}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(ffd.y[kGlaUns+i], ffdGlaUns.Q_flow[i])
          annotation (Line(
          points={{-19,190},{60,190},{60,126},{178,126}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(ffd.u[kConExtWinFra+i], ffdConExtWinFra.T[i])
          annotation (Line(
          points={{-42,190},{-60,190},{-60,-4},{179,-4}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(ffd.y[kConExtWinFra+i], ffdConExtWinFra.Q_flow[i])
          annotation (Line(
          points={{-19,190},{60,190},{60,6},{178,6}},
          color={0,0,127},
          smooth=Smooth.None));
    end for;
  end if;

  if haveShade then
    for i in 1:nConExtWin loop
      connect(ffd.u[kGlaSha+i], ffdGlaSha.T[i])
          annotation (Line(
          points={{-42,190},{-60,190},{-60,76},{179,76}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(ffd.y[kGlaSha+i], ffdGlaSha.Q_flow[i])
          annotation (Line(
          points={{-19,190},{60,190},{60,86},{178,86}},
          color={0,0,127},
          smooth=Smooth.None));
    end for;
  end if;

  if haveConPar then
    for i in 1:nConPar loop
      connect(ffd.u[kConPar_a+i], ffdConPar_a.T[i])
          annotation (Line(
          points={{-42,190},{-60,190},{-60,-64},{179,-64}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(ffd.y[kConPar_a+i], ffdConPar_a.Q_flow[i])
          annotation (Line(
          points={{-19,190},{60,190},{60,-54},{178,-54}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(ffd.u[kConPar_b+i], ffdConPar_b.T[i])
          annotation (Line(
          points={{-42,190},{-60,190},{-60,-104},{179,-104}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(ffd.y[kConPar_b+i], ffdConPar_b.Q_flow[i])
          annotation (Line(
          points={{-19,190},{60,190},{60,-94},{178,-94}},
          color={0,0,127},
          smooth=Smooth.None));
    end for;
  end if;

  if haveConBou then
    for i in 1:nConBou loop
      connect(ffd.u[kConBou+i], ffdConBou.T[i])
          annotation (Line(
          points={{-42,190},{-60,190},{-60,-164},{179,-164}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(ffd.y[kConBou+i], ffdConBou.Q_flow[i])
          annotation (Line(
          points={{-19,190},{60,190},{60,-154},{178,-154}},
          color={0,0,127},
          smooth=Smooth.None));
    end for;
  end if;

  if haveSurBou then
    for i in 1:nSurBou loop
      connect(ffd.u[kSurBou+i], ffdSurBou.T[i])
          annotation (Line(
          points={{-42,190},{-60,190},{-60,-224},{179,-224}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(ffd.y[kSurBou+i], ffdSurBou.Q_flow[i])
          annotation (Line(
          points={{-19,190},{60,190},{60,-214},{178,-214}},
          color={0,0,127},
          smooth=Smooth.None));
    end for;
  end if;

  connect(ffdConExt.port, conExt) annotation (Line(
      points={{200,220},{240,220}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ffdConExtWin.port, conExtWin) annotation (Line(
      points={{200,180},{240,180}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ffdGlaUns.port, glaUns) annotation (Line(
      points={{200,120},{220,120},{220,120},{240,120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ffdGlaSha.port, glaSha) annotation (Line(
      points={{200,80},{240,80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ffdConExtWinFra.port, conExtWinFra) annotation (Line(
      points={{200,0},{242,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ffdConPar_a.port, conPar_a) annotation (Line(
      points={{200,-60},{242,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ffdConPar_b.port, conPar_b) annotation (Line(
      points={{200,-100},{242,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ffdConBou.port, conBou) annotation (Line(
      points={{200,-160},{222,-160},{222,-160},{242,-160}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ffdSurBou.port, conSurBou) annotation (Line(
      points={{200,-220},{241,-220}},
      color={191,0,0},
      smooth=Smooth.None));
  // Connections to heat port of air volume
  connect(ffd.y[kHeaPorAir+1], ffdHeaPorAir.T) annotation (Line(
      points={{-19,190},{60,190},{60,0},{-180,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ffdHeaPorAir.port, heaPorAir) annotation (Line(
      points={{-202,0},{-240,0}},
      color={191,0,0},
      smooth=Smooth.None));
  // Connections to shade
  if haveShade then
    for i in 1:nConExtWin loop
      connect(ffd.u[kUSha+i], uSha[i]) annotation (Line(
          points={{-42,190},{-60,190},{-60,200},{-260,200}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(ffd.u[kQRadAbs_flow+i], QRadAbs_flow[i]) annotation (Line(
          points={{-42,190},{-60,190},{-60,90},{-260,90}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(ffd.y[kTSha+i], TSha[i]) annotation (Line(
          points={{-19,190},{60,190},{60,60},{-250,60}},
          color={0,0,127},
          smooth=Smooth.None));
    end for;
  end if;
  // Connections to fluid port
  connect(ports, fluInt.ports) annotation (Line(
      points={{0,-238},{0,-198}},
      color={0,127,255},
      smooth=Smooth.None));

  // Output signals from fluInt block

  // The pressure the air volume will be sent from Modelica to FFD
  connect(ffd.u[kFluIntP+1], fluInt.p) annotation (Line(
      points={{-42,190},{-60,190},{-60,-180},{-11,-180}},
      color={0,0,127},
      smooth=Smooth.None));
  for i in 1:nPorts loop
    connect(ffd.u[kFluIntM_flow+i], fluInt.m_flow[i]) annotation (Line(
        points={{-42,190},{-60,190},{-60,-184},{-11,-184}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(ffd.u[kFluIntT_inflow+i], fluInt.T_inflow[i]) annotation (Line(
        points={{-42,190},{-60,190},{-60,-188},{-11,-188}},
        color={0,0,127},
        smooth=Smooth.None));
    for j in 1:Medium.nXi loop
      connect(ffd.u[kFluIntXi_inflow+(i-1)*Medium.nXi+j], fluInt.Xi_inflow[(i-1)*Medium.nXi+j]) annotation (Line(
          points={{-42,190},{-60,190},{-60,-192},{-11,-192}},
          color={0,0,127},
          smooth=Smooth.None));
    end for;
    for j in 1:Medium.nC loop
      connect(ffd.u[kFluIntC_inflow+(i-1)*Medium.nC+j], fluInt.C_inflow[(i-1)*Medium.nC+j]) annotation (Line(
          points={{-42,190},{-60,190},{-60,-196},{-11,-196}},
          color={0,0,127},
          smooth=Smooth.None));
    end for;
  end for;
  // Input signals to fluInt block
  // The pressures of ports[2:nPorts] will be sent from FFD to Modelica
  for i in 1:nPorts-1 loop
  end for;
  for i in 1:nPorts loop
    connect(ffd.y[kFluIntT_outflow+i], fluInt.T_outflow[i]) annotation (Line(
        points={{-19,190},{60,190},{60,-188},{12,-188}},
        color={0,0,127},
        smooth=Smooth.None));
    for j in 1:Medium.nXi loop
      connect(ffd.y[kFluIntXi_outflow+(i-1)*Medium.nXi+j], fluInt.Xi_outflow[(i-1)*Medium.nXi+j]) annotation (Line(
          points={{-19,190},{60,190},{60,-192},{12,-192}},
          color={0,0,127},
          smooth=Smooth.None));
    end for;
    for j in 1:Medium.nC loop
      connect(ffd.y[kFluIntC_outflow+(i-1)*Medium.nC+j], fluInt.C_outflow[(i-1)*Medium.nC+j]) annotation (Line(
          points={{-19,190},{60,190},{60,-196},{12,-196}},
          color={0,0,127},
          smooth=Smooth.None));
    end for;
  end for;
  annotation (
    preferredView="info",
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-240,-240},{240,
            240}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-240,-240},{240,240}}),
                    graphics={
          Rectangle(
          extent={{-144,184},{148,-200}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Sphere)}),
    Documentation(info="<html>
<p>
This model computes the heat and mass balance of the air using Fast Fluid Dynamics.
</p>
<h4>Conventions</h4>
<p>
The following conventions are made:
</p>
<ol>
<li>
<p>
The port <code>heaPorAir</code> contains the average room air temperature, defined as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  T<sub>a</sub> = 1 &frasl; V &nbsp; &int;<sub>V</sub> T(dV) &nbsp; dV,
</p>
<p>
where <i>T<sub>a</sub></i> is the average room air temperature, <i>V</i> is the room air volume
and <i>T(dV)</i> is the room air temperature in the control volume <i>dV</i>.
The average room air temperature <i>T<sub>a</sub></i> is computed by the FFD program.
</p>
</li>
<li>
If a model injects heat to <code>heaPorAir</code>, then the heat will be distributed to all
cells. The amount of heat flow rate that each cell exchanges with <code>heaPorAir</code> is
proportional to its volume.
</li>
<li>
If a construction is not present, or if no shade is present, or if no air stream is connected to <code>ports</code>,
then no variables are exchanged for this quantity with the block <code>ffd</code>.
</li>
<li>
The variables of the connector <code>ports</code> are exchanged with the FFD block
through the instance <code>intFlu</code>. Its output and input signals are as follows:
<ul>
<li>
Input to the FFD block is a vector <code>[p, m_flow[nPorts], T_inflow[nPorts], 
X_inflow[nPorts*Medium.nXi], C_inflow[nPorts*Medium.nC]]</code>.
The quantity <code>p</code> is the total pressure of the fluid ports (all fluid ports have the same
total pressure). 
Therefore, the flow resistance of the diffusor or exhaust grill must be computed in the 
Modelica HVAC system that is connected to the room model.
The quantities <code>X_inflow</code> and <code>C_inflow</code> (or <code>X_inflow</code> and <code>C_inflow</code>)
are vectors with components <code>X_inflow[1:Medium.nXi]</code> and <code>C_inflow[1:Medium.nC]</code>.
For example, for moist air, <code>X_inflow</code> has one element which is equal to the mass fraction of air,
relative to the total air mass and not the dry air.
</li>
<li>
Output from the FFD block is a vector 
<code>[T_outflow[nPorts], X_outflow[nPorts*Medium.nXi], C_outflow[nPorts*Medium.nC]]</code>.
The quantities <code>*_outflow</code> are the fluid properties of the cell to which the port is
connected. 
</li>
<li>
If <code>Medium.nXi=0</code> (e.g., for dry air) or <code>Medium.nC=0</code>, then these signals are not present as input/output signals of the FFD block.
</li>
</ul>
</li>
</ol>
</html>",
revisions="<html>
<ul>
<li>
July 17, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirHeatMassBalanceFFD;
