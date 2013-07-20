within Buildings.Rooms.BaseClasses;
model AirHeatMassBalanceFFD
  "Heat and mass balance of the air based on fast fluid flow dynamics"
  extends Buildings.Rooms.BaseClasses.PartialAirHeatMassBalance;

  parameter Boolean activateInterface = true
    "Set to false to deactivate interface and use instead yFixed as output"
    annotation(Evaluate = true);

  parameter Modelica.SIunits.Time samplePeriod(min=100*Modelica.Constants.eps)
    "Sample period of component"
    annotation(Dialog(group = "Sampling"));
  parameter Modelica.SIunits.Time startTime
    "First sample time instant. fixme: this should be at first step."
    annotation(Dialog(group = "Sampling"));

  // fixme: for the ffd instance, need to correctly assign uStart, flaWri and yFixed,
  //        and need to connect the fluid port variables to it.
  FFDExchange ffd(
    final startTime=startTime,
    final activateInterface=activateInterface,
    final samplePeriod = if activateInterface then samplePeriod else Modelica.Constants.inf,
    uStart=fill(T0, if haveShade then kPortsU else kPortsU-1),
    nWri=if haveShade then kPortsU else kPortsU-1,
    nRea=if haveShade then kPortsY else kPortsY-1)
    "Block that exchanges data with the FFD simulation"
    annotation (Placement(transformation(extent={{-40,180},{-20,200}})));

protected
  constant Modelica.SIunits.Temperature T0 = 293.15
    "Temperature used for conditionally removed constructions";
  Modelica.SIunits.Temperature TRooAve = T0
    "fixme: average room air temperature";

  // Internal connectors
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conExt_internal[NConExt]
    "Heat port that connects to room-side surface of exterior constructions";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conExtWin_internal[NConExtWin]
    "Heat port that connects to room-side surface of exterior constructions that contain a window";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a glaUns_internal[NConExtWin]
    "Heat port that connects to room-side surface of unshaded part of the window glass";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a glaSha_internal[NConExtWin]
    "Heat port that connects to room-side surface of shaded part of the window glass";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conExtWinFra_internal[NConExtWin]
    "Heat port that connects to room-side surface of window frame";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conPar_a_internal[NConPar]
    "Heat port that connects to room-side surface a of partition constructions";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conPar_b_internal[NConPar]
    "Heat port that connects to room-side surface b of partition constructions";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conBou_internal[NConBou]
    "Heat port that connects to room-side surface of constructions that expose their other surface to the outside";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conSurBou_internal[NSurBou]
    "Heat port to surfaces of models that compute the heat conduction outside of this room";

  Modelica.Blocks.Interfaces.RealInput uSha_internal[NConExtWin]
    "Input connector, used to scale the surface area to take into account an operable shading device, 0: unshaded; 1: fully shaded";

  Modelica.Blocks.Interfaces.RealInput QRadAbs_flow_internal[NConExtWin](
  final unit="W")
    "Total net radiation that is absorbed by the shade (positive if absorbed)";

  Modelica.Blocks.Interfaces.RealOutput TSha_internal[NConExtWin](
   final unit="K",
   final quantity="ThermodynamicTemperature") "Shade temperature";

  // Interfaces between the FFD block and the heat ports of this model
  FFDSurfaceInterface ffdConExt(final n=nConExt)
    "Interface to heat port of exterior constructions"
    annotation (Placement(transformation(extent={{180,210},{200,230}})));

  FFDSurfaceInterface ffdConExtWin(final n=nConExtWin)
    "Interface to heat port of opaque part of exterior constructions with window"
    annotation (Placement(transformation(extent={{180,170},{200,190}})));

  FFDSurfaceInterface ffdGlaUns(final n=nConExtWin)
    "Interface to heat port of unshaded part of glass"
    annotation (Placement(transformation(extent={{180,110},{200,130}})));

  FFDSurfaceInterface ffdGlaSha(final n=nConExtWin)
    "Interface to heat port of shaded part of glass"
    annotation (Placement(transformation(extent={{180,70},{200,90}})));

  FFDSurfaceInterface ffdConExtWinFra(final n=nConExtWin)
    "Interface to heat port of window frame"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));

  FFDSurfaceInterface ffdConPar_a(final n=nConPar)
    "Interface to heat port of surface a of partition constructions"
    annotation (Placement(transformation(extent={{180,-70},{200,-50}})));

  FFDSurfaceInterface ffdConPar_b(final n=nConPar)
    "Interface to heat port of surface b of partition constructions"
    annotation (Placement(transformation(extent={{180,-110},{200,-90}})));

  FFDSurfaceInterface ffdConBou(final n=nConBou)
    "Interface to heat port that connects to room-side surface of constructions that expose their other surface to the outside"
    annotation (Placement(transformation(extent={{180,-170},{200,-150}})));

  FFDSurfaceInterface ffdSurBou(final n=nSurBou)
    "Interface to heat port of surfaces of models that compute the heat conduction outside of this room"
    annotation (Placement(transformation(extent={{180,-230},{200,-210}})));

  FFDSurfaceInterface ffdHeaPorAir(final n=1)
    "Interface to heat port of air node"
    annotation (Placement(transformation(extent={{-182,-10},{-202,10}})));

  // The following list declares the first index of the input and output signals
  // to the FFD block
  final parameter Integer kConExt = 1
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
    "Offset used to connect FFD signals to air heat port";
  final parameter Integer kUSha = kHeaPorAir + 1
    "Offset used to connect FFD signals to input signal of shade";
  final parameter Integer kQRadAbs_flow = if haveShade then kUSha + NConExtWin else kUSha
    "Offset used to connect FFD signals to input signal that contains the radiation absorbed by the shade";
  final parameter Integer kTSha = kUSha
    "Offset used to connect FFD signals to output signal that contains the shade temperature";

  final parameter Integer kPortsU = if haveShade then kQRadAbs_flow + NConExtWin else kQRadAbs_flow
    "Offset used to connect FFD signals to input signals from the fluid ports";
  final parameter Integer kPortsY = if haveShade then kTSha + NConExtWin else kTSha
    "Offset used to connect FFD signals to input signals from the fluid ports";

equation
  connect(conExt, conExt_internal);
  if haveConExt then
    conExt_internal.Q_flow = zeros(NConExt);
  else
    conExt_internal.T = {T0};
  end if;

  connect(conExtWin, conExtWin_internal);
  connect(glaUns, glaUns_internal);
  connect(conExtWinFra, conExtWinFra_internal);

  if haveConExtWin then
    conExtWin_internal.Q_flow = zeros(NConExtWin);
    glaUns_internal.Q_flow = zeros(NConExtWin);
    conExtWinFra_internal.Q_flow = zeros(NConExtWin);
  else
    conExtWin_internal.T = {T0};
    glaUns_internal.T = {T0};
    conExtWinFra_internal.T = {T0};
  end if;

  connect(glaSha, glaSha_internal);
  connect(uSha, uSha_internal);
  connect(QRadAbs_flow, QRadAbs_flow_internal);
  connect(TSha, TSha_internal);

  if haveShade then
    glaSha_internal.Q_flow = zeros(NConExtWin);
    TSha_internal = fill(T0, NConExtWin); // fixme: connect to shade temperature from FFD
  else
    glaSha_internal.T = {T0};
    uSha_internal = {0};
    QRadAbs_flow_internal = {0};
    TSha_internal = {T0};
  end if;

  connect(conPar_a, conPar_a_internal);
  connect(conPar_b, conPar_b_internal);
  if haveConPar then
    conPar_a_internal.Q_flow = zeros(NConPar);
    conPar_b_internal.Q_flow = zeros(NConPar);
  else
    conPar_a_internal.T = {T0};
    conPar_b_internal.T = {T0};
  end if;

  connect(conBou, conBou_internal);
  if haveConBou then
    conBou_internal.Q_flow = zeros(NConBou);
  else
    conBou_internal.T = {T0};
  end if;

  connect(conSurBou, conSurBou_internal);
  if haveSurBou then
    conSurBou_internal.Q_flow = zeros(NSurBou);
  else
    conSurBou_internal.T = {T0};
  end if;

  heaPorAir.T = TRooAve;
  // Data exchange with FFD block
  if haveConExt then
  connect(ffd.u[kConExt:kConExtWin-1], ffdConExt.T) annotation (Line(
        points={{-42,190},{-60,190},{-60,216},{179,216}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(ffd.y[kConExt:kConExtWin-1], ffdConExt.Q_flow) annotation (Line(
        points={{-19,190},{20,190},{20,226},{178,226}},
        color={0,0,127},
        smooth=Smooth.None));
  end if;

  if haveConExtWin then
    connect(ffd.u[kConExtWin:kGlaUns-1], ffdConExtWin.T)
        annotation (Line(
        points={{-42,190},{-60,190},{-60,176},{179,176}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(ffd.y[kConExtWin:kGlaUns-1], ffdConExtWin.Q_flow)
        annotation (Line(
        points={{-19,190},{20,190},{20,186},{178,186}},
        color={0,0,127},
        smooth=Smooth.None));

    connect(ffd.u[kGlaUns:kGlaSha-1], ffdGlaUns.T)
        annotation (Line(
        points={{-42,190},{-60,190},{-60,116},{179,116}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(ffd.y[kGlaUns:kGlaSha-1], ffdGlaUns.Q_flow)
        annotation (Line(
        points={{-19,190},{20,190},{20,126},{178,126}},
        color={0,0,127},
        smooth=Smooth.None));

    connect(ffd.u[kConExtWinFra:kConPar_a-1], ffdConExtWinFra.T)
        annotation (Line(
        points={{-42,190},{-60,190},{-60,-4},{179,-4}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(ffd.y[kConExtWinFra:kConPar_a-1], ffdConExtWinFra.Q_flow)
        annotation (Line(
        points={{-19,190},{20,190},{20,6},{178,6}},
        color={0,0,127},
        smooth=Smooth.None));
  end if;
  if haveShade then
    connect(ffd.u[kGlaSha:kConExtWinFra-1], ffdGlaSha.T)
        annotation (Line(
        points={{-42,190},{-60,190},{-60,76},{179,76}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(ffd.y[kGlaSha:kConExtWinFra-1], ffdGlaSha.Q_flow)
        annotation (Line(
        points={{-19,190},{20,190},{20,86},{178,86}},
        color={0,0,127},
        smooth=Smooth.None));
  end if;

  if haveConPar then
    connect(ffd.u[kConPar_a:kConPar_b-1], ffdConPar_a.T)
        annotation (Line(
        points={{-42,190},{-60,190},{-60,-64},{179,-64}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(ffd.y[kConPar_a:kConPar_b-1], ffdConPar_a.Q_flow)
        annotation (Line(
        points={{-19,190},{20,190},{20,-54},{178,-54}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(ffd.u[kConPar_b:kConBou-1], ffdConPar_b.T)
        annotation (Line(
        points={{-42,190},{-60,190},{-60,-104},{179,-104}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(ffd.y[kConPar_b:kConBou-1], ffdConPar_b.Q_flow)
        annotation (Line(
        points={{-19,190},{20,190},{20,-94},{178,-94}},
        color={0,0,127},
        smooth=Smooth.None));
  end if;

  if haveConBou then
    connect(ffd.u[kConBou:kSurBou-1], ffdConBou.T)
        annotation (Line(
        points={{-42,190},{-60,190},{-60,-164},{179,-164}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(ffd.y[kConBou:kSurBou-1], ffdConBou.Q_flow)
        annotation (Line(
        points={{-19,190},{20,190},{20,-154},{178,-154}},
        color={0,0,127},
        smooth=Smooth.None));
  end if;

  if haveSurBou then
    connect(ffd.u[kSurBou:kHeaPorAir-1], ffdSurBou.T)
        annotation (Line(
        points={{-42,190},{-60,190},{-60,-224},{179,-224}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(ffd.y[kSurBou:kHeaPorAir-1], ffdSurBou.Q_flow)
        annotation (Line(
        points={{-19,190},{20,190},{20,-214},{178,-214}},
        color={0,0,127},
        smooth=Smooth.None));
  end if;

  connect(ffdConExt.port, conExt) annotation (Line(
      points={{200,220},{240,220}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ffdConExtWin.port, conExtWin) annotation (Line(
      points={{200,180},{220,180},{220,180},{240,180}},
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
  connect(ffd.u[kHeaPorAir:kHeaPorAir], ffdHeaPorAir.T) annotation (Line(
      points={{-42,190},{-60,190},{-60,-4},{-181,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ffd.y[kHeaPorAir:kHeaPorAir], ffdHeaPorAir.Q_flow) annotation (Line(
      points={{-19,190},{20,190},{20,6},{-180,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ffdHeaPorAir.port[1], heaPorAir) annotation (Line(
      points={{-202,0},{-240,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ffd.u[kUSha:kQRadAbs_flow-1], uSha) annotation (Line(
      points={{-42,190},{-60,190},{-60,200},{-260,200}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ffd.u[kQRadAbs_flow:kPortsU-1], QRadAbs_flow) annotation (Line(
      points={{-42,190},{-60,190},{-60,90},{-260,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ffd.y[kTSha:kPortsY], TSha) annotation (Line(
      points={{-19,190},{20,190},{20,60},{-250,60}},
      color={0,0,127},
      smooth=Smooth.None));
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
<ul>
<li>
The variables of the connector <code>ports</code> are exchanged with the FFD block as follows:
<li>
Input to the FFD block is a vector <code>[m_flow[nPorts], T_inflow[nPorts], X_inflow[nPorts], C_inflow[nPorts]]</code>.
</li>
<li>
Output from the FFD block is a vector <code>[m_flow[nPorts], T_outflow[nPorts], X_outflow[nPorts], C_outflow[nPorts]]</code>.
</li>
</ul>
The quantities <code>X_inflow</code> and <code>C_inflow</code> (or <code>X_inflow</code> and <code>C_inflow</code>)
are vectors with components <code>X_inflow[1:Medium.nXi]</code> and <code>C_inflow[1:Medium.nC]</code>.
For example, for moist air, <code>X_inflow</code> has one element which is equal to the mass fraction of air,
relative to the total air mass and not the dry air.
<li>
If <code>Medium.nXi=0</code> (e.g., for dry air) or <code>Medium.nC=0</code>, then these signals are not present 
as input/output signals of the FFD block.
</li>
</li>
</ol>
</p>
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
