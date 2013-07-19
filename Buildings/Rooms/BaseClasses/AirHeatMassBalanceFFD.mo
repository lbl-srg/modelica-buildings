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

  FFDExchange ffd(
    final startTime=startTime,
    final activateInterface=activateInterface,
    final samplePeriod = if activateInterface then samplePeriod else Modelica.Constants.inf,
    uStart=fill(T0, nConExt),
    nWri=nConExt,
    nRea=nConExt) "Block that exchanges data with the FFD simulation"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));

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

public
  FFDSurfaceInterface ffdConExt(n=nConExt)
    "Interface to heat port of exterior constructions"
    annotation (Placement(transformation(extent={{180,210},{200,230}})));
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
  // Data exchange with FFD
  // Fixme: for this test, we only send TConExt

  connect(ffdConExt.port, conExt) annotation (Line(
      points={{200,220},{240,220}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ffdConExt.T, ffd.u) annotation (Line(
      points={{179,216},{-60,216},{-60,110},{-42,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ffd.y, ffdConExt.Q_flow) annotation (Line(
      points={{-19,110},{20,110},{20,226},{178,226}},
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
This model computes the heat and mass balance of the air.
It implements a call to a program that computes the air flow in the room
based on Fast Fluid Dynamics.
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
