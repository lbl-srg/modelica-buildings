within Districts.Electrical.AC.AC1ph.Conversion;
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
  Modelica.SIunits.Power LossPower[2] "Loss power";
  parameter Boolean ground_AC = true "Connect AC side of converter to ground" annotation(evaluate=true, Dialog(tab = "Ground", group="AC side"));
  parameter Boolean ground_DC = true "Connect DC side of converter to ground" annotation(evaluate=true, Dialog(tab = "Ground", group="DC side"));
protected
  Real i_dc,v_dc;
  Modelica.SIunits.Power Pow_p[2] = PhaseSystem_p.phasePowers_vi(terminal_p.v, terminal_p.i);
  Modelica.SIunits.Power Pow_n[2] = PhaseSystem_n.phasePowers_vi(terminal_n.v, terminal_n.i);
equation

  if not ground_DC then
    i_dc = 0;
  else
    v_dc = 0;
  end if;

  v_dc = terminal_p.v[2];
  sum(terminal_p.i) + i_dc = 0;

  //voltage relation
  v_p = v_n*conversionFactor;

  //power balance
  LossPower = (1-eta) * abs(Pow_p);
  Pow_n + Pow_p = LossPower;

  if ground_AC then
    Connections.potentialRoot(terminal_n.theta);
  end if;

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
          points={{-100,-100},{-100,-12}},
          color=DynamicSelect({0,120,120}, if ground_AC then {0,120,120} else {255,255,
              255}),
          smooth=Smooth.None),
        Line(
          points={{-120,-100},{-80,-100}},
          color=DynamicSelect({0,120,120}, if ground_AC then {0,120,120} else {255,255,
              255}),
          smooth=Smooth.None),
        Line(
          points={{-112,-106},{-88,-106}},
          color=DynamicSelect({0,120,120}, if ground_AC then {0,120,120} else {255,255,
              255}),
          smooth=Smooth.None),
        Line(
          points={{-106,-112},{-92,-112}},
          color=DynamicSelect({0,120,120}, if ground_AC then {0,120,120} else {255,255,
              255}),
          smooth=Smooth.None)}),
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
January 4, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end ACDCConverter;
