within Districts.Electrical.AC.OnePhase.Conversion;
model ACDCConverter "AC DC converter"
  extends Districts.Electrical.Interfaces.PartialConversion(
      redeclare package PhaseSystem_p =
        Districts.Electrical.PhaseSystems.TwoConductor,
      redeclare package PhaseSystem_n =
        Districts.Electrical.PhaseSystems.OnePhase,
      redeclare Interfaces.Terminal_n terminal_n,
      redeclare Districts.Electrical.DC.Interfaces.Terminal_p
                                                           terminal_p);
  // fixme: add example. Consider adding a constant loss therm for
  // parasitic losses
  parameter Real conversionFactor "Ratio of DC voltage / QS rms voltage";
  parameter Real eta(min=0, max=1)
    "Converter efficiency, pLoss = (1-eta) * pDC";
  Modelica.SIunits.Power LossPower "Loss power";
  parameter Boolean ground_AC = false "Connect AC side of converter to ground" annotation(evaluate=true, Dialog(tab = "Ground", group="AC side"));
  parameter Boolean ground_DC = true "Connect DC side of converter to ground" annotation(evaluate=true, Dialog(tab = "Ground", group="DC side"));
protected
  PhaseSystem_p.Current i_dc "DC current";
  PhaseSystem_p.Voltage v_dc "DC voltage";
  Modelica.SIunits.Power Pow_p[2] = PhaseSystem_p.phasePowers_vi(terminal_p.v, terminal_p.i);
  Modelica.SIunits.Power Pow_n[2] = PhaseSystem_n.phasePowers_vi(terminal_n.v, terminal_n.i);
equation
  //voltage relation
  v_p = v_n*conversionFactor;

  /* OLD VERSION INCLUDED ALSO THESE VARIABLES
  protecetd
    Modelica.SIunits.Power LossPower_n "Loss power on side n";
    Modelica.SIunits.Power LossPower_p "Loss power on side p";
  equation
    //power balance
    {LossPower_n, LossPower_p} = (1-eta) * abs(Pow_p);
    Pow_n + Pow_p = {LossPower_n, LossPower_p};
    LossPower = LossPower_n + LossPower_p;
  */

  if i_p<=0 then
    LossPower = - Pow_p[1]*(1-eta);
    Pow_n + Pow_p = {LossPower, 0};
  else
    LossPower = - Pow_n[1]*(1-eta);
    Pow_n + Pow_p = {LossPower, 0};
  end if;

  if ground_AC then
    Connections.potentialRoot(terminal_n.theta);
  end if;

  if ground_DC then
    v_dc = 0;
  else
    i_dc = 0;
  end if;
  v_dc = terminal_p.v[2];
  sum(terminal_p.i) + i_dc = 0;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                      graphics={
        Line(
          points={{2,100},{2,60},{82,60},{2,60},{82,-60},{2,-60},{2,60},{2,-100}},
          color={0,0,255},
          smooth=Smooth.None),
        Text(
          extent={{36,54},{96,14}},
          lineColor={0,0,255},
          textString="DC"),
        Line(
          points={{-2,100},{-2,60},{-82,60},{-2,60},{-82,-60},{-2,-60},{-2,60},{
              -2,-100}},
          color={0,120,120},
          smooth=Smooth.None),
        Text(
          extent={{-100,52},{-40,12}},
          lineColor={0,120,120},
          textString="AC"),
        Text(
          extent={{-100,92},{100,60}},
          lineColor={0,120,120},
          textString="%name"),
        Text(
          extent={{-100,-60},{100,-92}},
          lineColor={0,0,255},
          textString="%conversionFactor"),
        Text(
          extent={{-100,-100},{100,-132}},
          lineColor={0,0,255},
          textString="%eta"),
        Line(
          points={{100,-100},{100,-12}},
          color=DynamicSelect({0,0,255}, if ground_DC then {0,0,255} else {
              255,255,255}),
          smooth=Smooth.None),
        Line(
          points={{80,-100},{120,-100}},
          color=DynamicSelect({0,0,255}, if ground_DC then {0,0,255} else {
              255,255,255}),
          smooth=Smooth.None),
        Line(
          points={{88,-106},{112,-106}},
          color=DynamicSelect({0,0,255}, if ground_DC then {0,0,255} else {
              255,255,255}),
          smooth=Smooth.None),
        Line(
          points={{94,-112},{108,-112}},
          color=DynamicSelect({0,0,255}, if ground_DC then {0,0,255} else {
              255,255,255}),
          smooth=Smooth.None),
        Line(
          points={{-80,-40},{-120,-40}},
          color=DynamicSelect({0,120,120}, if ground_AC then {0,120,120} else {
              255,255,255}),
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-80,-40},{-106,-14}},
          color=DynamicSelect({0,120,120}, if ground_AC then {0,120,120} else {
              255,255,255}),
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-102,-16},{-114,-24},{-118,-42}},
          color=DynamicSelect({0,120,120}, if ground_AC then {0,120,120} else {
              255,255,255}),
          smooth=Smooth.Bezier)}),
    Documentation(info="<html>
<p>
This is an AC DC converter, based on a power balance between QS circuit and DC side.
The paramater <i>conversionFactor</i> defines the ratio between averaged DC voltage and QS rms voltage.
The loss of the converter is proportional to the power transmitted at the DC side.
The parameter <code>eps</code> is the efficiency of the transfer.
The loss is computed as
<i>P<sub>loss</sub> = (1-&eta;) |P<sub>DC</sub>|</i>,
where <i>|P<sub>DC</sub>|</i> is the power transmitted on the DC side.
Furthermore, reactive power at the QS side is set to 0.
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
January 4, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ACDCConverter;
