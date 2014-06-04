within Buildings.Electrical.AC.OnePhase.Conversion;
model ACACConverter "AC AC converter single phase systems"
  extends Buildings.Electrical.Interfaces.PartialConversion(
    redeclare package PhaseSystem_p = PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n = PhaseSystems.OnePhase,
    redeclare Interfaces.Terminal_n terminal_n(redeclare package PhaseSystem =
          PhaseSystem_n),
    redeclare Interfaces.Terminal_p terminal_p(redeclare package PhaseSystem =
          PhaseSystem_p));
  // fixme: add example. Consider adding a constant loss therm for
  // parasitic losses
  parameter Real conversionFactor
    "Ratio of QS rms voltage on side 2 / QS rms voltage on side 1";
  parameter Real eta(min=0, max=1)
    "Converter efficiency, pLoss = (1-eta) * 'abs'(v2QS)";
  Modelica.SIunits.Power LossPower[2] "Loss power";
  parameter Boolean ground_1 = false "Connect side 1 of converter to ground" annotation(Evaluate=true,Dialog(tab = "Ground", group="side 1"));
  parameter Boolean ground_2 = true "Connect side 2 of converter to ground" annotation(Evaluate=true, Dialog(tab = "Ground", group="side 2"));
protected
  Modelica.SIunits.Power P_p[2] = PhaseSystem_p.phasePowers_vi(terminal_p.v, terminal_p.i);
  Modelica.SIunits.Power P_n[2] = PhaseSystem_n.phasePowers_vi(terminal_n.v, terminal_n.i);
equation

  // Ideal transformation
  terminal_p.v = conversionFactor*terminal_n.v;

  /* Easier way to look at the next expression 
  if P_p[1]<=0 then
    terminal_p.i[1] = terminal_n.i[1]/conversionFactor/(eta-2);
    terminal_p.i[2] = terminal_n.i[2]/conversionFactor/(eta-2);
  else
    terminal_p.i[1] = terminal_n.i[1]/conversionFactor*(eta-2);
    terminal_p.i[2] = terminal_n.i[2]/conversionFactor*(eta-2);
  end if;
  */
  terminal_p.i[1] = terminal_n.i[1]/conversionFactor*Buildings.Utilities.Math.Functions.spliceFunction(eta-2, 1/(eta-2), P_p[1], deltax=0.1);
  terminal_p.i[2] = terminal_n.i[2]/conversionFactor*Buildings.Utilities.Math.Functions.spliceFunction(eta-2, 1/(eta-2), P_p[1], deltax=0.1);
  LossPower = P_p + P_n;

  // The two sides have the same reference angle
  terminal_p.theta = terminal_n.theta;

  if ground_1 then
    Connections.potentialRoot(terminal_n.theta);
  end if;
  if ground_2 then
    Connections.root(terminal_p.theta);
  end if;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                      graphics={
        Line(
          points={{2,60},{2,60},{82,60},{2,60},{82,-60},{2,-60},{2,60},{2,-60}},
          color={0,120,120},
          smooth=Smooth.None),
        Line(
          points={{-2,60},{-2,60},{-82,60},{-2,60},{-82,-60},{-2,-60},{-2,60},{
              -2,-60}},
          color={11,193,87},
          smooth=Smooth.None),
        Text(
          extent={{-100,92},{100,60}},
          lineColor={0,120,120},
          textString="%name"),
        Text(
          extent={{-100,-60},{100,-92}},
          lineColor={0,120,120},
          textString="%conversionFactor"),
        Text(
          extent={{-100,-100},{100,-132}},
          lineColor={0,120,120},
          textString="%eta"),
        Text(
          extent={{-132,78},{-72,38}},
          lineColor={11,193,87},
          textString="1"),
        Text(
          extent={{-88,52},{-28,12}},
          lineColor={11,193,87},
          textString="AC"),
        Text(
          extent={{32,52},{92,12}},
          lineColor={0,120,120},
          textString="AC"),
        Text(
          extent={{70,78},{130,38}},
          lineColor={0,120,120},
          textString="2"),
        Line(
          points={{-80,-40},{-120,-40}},
          color=DynamicSelect({0,120,120}, if ground_1 then {0,120,120} else {
              255,255,255}),
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-80,-40},{-106,-14}},
          color=DynamicSelect({0,120,120}, if ground_1 then {0,120,120} else {255,
              255,255}),
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-102,-16},{-114,-24},{-118,-42}},
          color=DynamicSelect({0,120,120}, if ground_1 then {0,120,120} else {
              255,255,255}),
          smooth=Smooth.Bezier),
        Line(
          points={{80,-40},{120,-40}},
          color=DynamicSelect({0,120,120}, if ground_2 then {0,120,120} else {
              255,255,255}),
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{80,-40},{106,-14}},
          color=DynamicSelect({0,120,120}, if ground_2 then {0,120,120} else {
              255,255,255}),
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{102,-16},{114,-24},{118,-42}},
          color=DynamicSelect({0,120,120}, if ground_2 then {0,120,120} else {
              255,255,255}),
          smooth=Smooth.Bezier)}),
    Documentation(info="<html>
<p>
This is an AC AC converter, based on a power balance between both QS circuit sides.
The paramater <i>conversionFactor</i> defines the ratio between averaged the QS rms voltages.
The loss of the converter is proportional to the power transmitted at the second circuit side.
The parameter <code>eps</code> is the efficiency of the transfer.
The loss is computed as
<i>P<sub>loss</sub> = (1-&eta;) |P<sub>DC</sub>|</i>,
where <i>|P<sub>DC</sub>|</i> is the power transmitted on the second circuit side.
Furthermore, reactive power on both QS side are set to 0.
</p>
<h4>Note:</h4>
<p>
This model is derived from 
<a href=\"modelica://Modelica.Electrical.QuasiStationary.SinglePhase.Utilities.IdealACDCConverter\">
Modelica.Electrical.QuasiStationary.SinglePhase.Utilities.IdealACDCConverter</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 29, 2012, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"));
end ACACConverter;
