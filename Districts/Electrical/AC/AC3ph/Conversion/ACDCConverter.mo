within Districts.Electrical.AC.AC3ph.Conversion;
model ACDCConverter "AC DC converter"
  extends Districts.Electrical.Interfaces.PartialConversion(
      redeclare package PhaseSystem_p =
        Districts.Electrical.PhaseSystems.TwoConductor,
      redeclare package PhaseSystem_n =
        Districts.Electrical.PhaseSystems.ThreePhase_dq,
      redeclare Interfaces.Terminal_n terminal_n,
      redeclare Districts.Electrical.DC.Interfaces.Terminal_p terminal_p);
  // fixme: add example. Consider adding a constant loss therm for
  // parasitic losses
  parameter Real conversionFactor "Ratio of DC voltage / QS rms voltage";
  parameter Real eta(min=0, max=1)
    "Converter efficiency, pLoss = (1-eta) * pDC";
  parameter Boolean ground_AC = false "Connect side 1 of converter to ground" annotation(evaluate=true,Dialog(tab = "Ground", group="side 1"));
  parameter Boolean ground_DC = true "Connect side 2 of converter to ground" annotation(evaluate=true, Dialog(tab = "Ground", group="side 2"));
  Modelica.SIunits.Power LossPower "Loss power";
protected
  PhaseSystem_p.Current i_dc "DC current";
  PhaseSystem_p.Voltage v_dc "DC voltage";
  Modelica.SIunits.Power Pow_p[2] = PhaseSystem_p.phasePowers_vi(terminal_p.v, terminal_p.i);
  Modelica.SIunits.Power Pow_n[2] = PhaseSystem_n.phasePowers_vi(terminal_n.v, terminal_n.i);
  Modelica.SIunits.Power LossPower_n "Loss power on side n";
  Modelica.SIunits.Power LossPower_p "Loss power on side p";

equation
  //voltage relation
  v_p = v_n*conversionFactor;

  //power balance
  {LossPower_n, LossPower_p} = (1-eta) * abs(Pow_p);
  Pow_n + Pow_p = {LossPower_n, LossPower_p};
  LossPower = LossPower_n + LossPower_p;

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
          points={{2,60},{2,60},{82,60},{2,60},{82,-60},{2,-60},{2,60},{2,-60}},
          color={0,0,225},
          smooth=Smooth.None),
        Line(
          points={{-2,60},{-2,60},{-82,60},{-2,60},{-82,-60},{-2,-60},{-2,
              60},{-2,-60}},
          color={11,193,87},
          smooth=Smooth.None),
        Text(
          extent={{-100,92},{100,60}},
          lineColor={0,120,120},
          textString="%name"),
        Text(
          extent={{-100,-62},{100,-100}},
          lineColor={0,120,120},
          textString="%conversionFactor"),
        Text(
          extent={{-100,-100},{100,-132}},
          lineColor={0,120,120},
          textString="%eta"),
        Text(
          extent={{-132,78},{-72,38}},
          lineColor={0,128,0},
          textString="1"),
        Text(
          extent={{-88,52},{-28,12}},
          lineColor={0,128,0},
          textString="AC"),
        Text(
          extent={{32,52},{92,12}},
          lineColor={0,0,255},
          textString="AC"),
        Line(
          points={{-120,-100},{-80,-100}},
          color=DynamicSelect({0,120,120}, if ground_1 then {0,120,120} else {255,255,
              255}),
          smooth=Smooth.None),
        Line(
          points={{-112,-106},{-88,-106}},
          color=DynamicSelect({0,120,120}, if ground_1 then {0,120,120} else {255,255,
              255}),
          smooth=Smooth.None),
        Line(
          points={{-106,-112},{-92,-112}},
          color=DynamicSelect({0,120,120}, if ground_1 then {0,120,120} else {255,255,
              255}),
          smooth=Smooth.None),
        Line(
          points={{100,-100},{100,-12}},
          color=DynamicSelect({0,120,120}, if ground_2 then {0,120,120}
               else {255,255,255}),
          smooth=Smooth.None),
        Line(
          points={{80,-100},{120,-100}},
          color=DynamicSelect({0,120,120}, if ground_2 then {0,120,120} else {255,255,
              255}),
          smooth=Smooth.None),
        Line(
          points={{88,-106},{112,-106}},
          color=DynamicSelect({0,120,120}, if ground_2 then {0,120,120} else {255,255,
              255}),
          smooth=Smooth.None),
        Line(
          points={{94,-112},{108,-112}},
          color=DynamicSelect({0,120,120}, if ground_2 then {0,120,120} else {255,255,
              255}),
          smooth=Smooth.None),
        Line(
          points={{-100,-100},{-100,-12}},
          color=DynamicSelect({0,120,120}, if ground_1 then {0,120,120} else {255,255,
              255}),
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p>
This is a converter from 3 phase AC to DC power, based on a power balance between both circuit sides.
All three AC phases will have the same power transmitted.
The paramater <i>conversionFactor</i> defines the ratio between the DC voltage and the averaged QS rms.
The loss of the converter is proportional to the power transmitted at the DC side.
The parameter <code>eps</code> is the efficiency of the transfer.
The loss is computed as
<i>P<sub>loss</sub> = (1-&eta;) |P<sub>DC</sub>|</i>,
where <i>|P<sub>DC</sub>|</i> is the power transmitted on the DC circuit side.
Furthermore, reactive power on the AC side is set to <i>0</i>.
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
July 24, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ACDCConverter;
