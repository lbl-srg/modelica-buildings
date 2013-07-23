within Districts.Electrical.AC.AC3ph.Conversion;
model AC3phAC1phConverter "AC AC converter"
  extends Districts.Electrical.AC.AC3ph.Interfaces.PartialConversionAC3to1ph;
  // fixme: add example. Consider adding a constant loss therm for
  // parasitic losses
  parameter Real conversionFactor
    "Ratio of QS rms voltage on side 2 / QS rms voltage on side 1";
  parameter Real eta(min=0, max=1)
    "Converter efficiency, pLoss = (1-eta) * 'abs'(v2QS)";
  Modelica.SIunits.Power LossPower[2] "Loss power";
  parameter Boolean ground_1 = false "Connect side 1 of converter to ground" annotation(evaluate=true,Dialog(tab = "Ground", group="side 1"));
  parameter Boolean ground_2 = true "Connect side 2 of converter to ground" annotation(evaluate=true, Dialog(tab = "Ground", group="side 2"));
protected
  Modelica.SIunits.Power Pow_p[2] = PhaseSystem_p.phasePowers_vi(terminal_p.v, terminal_p.i);
  Modelica.SIunits.Power Pow_a[2] = PhaseSystem_n.phasePowers_vi(terminal_a.v, terminal_a.i);
  Modelica.SIunits.Power Pow_b[2] = PhaseSystem_n.phasePowers_vi(terminal_b.v, terminal_b.i);
  Modelica.SIunits.Power Pow_c[2] = PhaseSystem_n.phasePowers_vi(terminal_c.v, terminal_c.i);
equation

  PhaseSystem_p.rotate(terminal_p.v,0) = conversionFactor*terminal_a.v;
  PhaseSystem_p.rotate(terminal_p.v,2*Modelica.Constants.pi/3) = conversionFactor*terminal_b.v;
  PhaseSystem_p.rotate(terminal_p.v,4*Modelica.Constants.pi/3) = conversionFactor*terminal_c.v;

  Pow_p + Pow_a + Pow_b + Pow_c = LossPower;

  LossPower[1] = (1-eta) * abs(Pow_p[1]);
  LossPower[2] = (1-eta) * abs(Pow_p[2]);

  //fixme: do we need to do anything for the phase or should we assume the phase remains the same?
  terminal_p.theta[1] = terminal_a.theta[1];
  terminal_p.theta[1] + 2*Modelica.Constants.pi/3 = terminal_b.theta[1];
  terminal_p.theta[1] + 4*Modelica.Constants.pi/3 = terminal_c.theta[1];

  if ground_1 then
    Connections.potentialRoot(terminal_p.theta);
  end if;
  if ground_2 then
    Connections.root(terminal_a.theta);
    Connections.root(terminal_b.theta);
    Connections.root(terminal_c.theta);
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
          points={{-2,60},{-2,60},{-82,60},{-2,60},{-82,-60},{-2,-60},{-2,60},{-2,
              -60}},
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
          extent={{-62,-18},{-2,-58}},
          lineColor={11,193,87},
          textString="3 Ph"),
        Text(
          extent={{4,-18},{64,-58}},
          lineColor={0,120,120},
          textString="1 Ph"),
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
          points={{100,-100},{100,-70}},
          color=DynamicSelect({0,120,120}, if ground_2 then {0,120,120} else {255,255,
              255}),
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
January 29, 2012, by Thierry S. Nouidui:<br>
First implementation.
</li>
</ul>
</html>"));
end AC3phAC1phConverter;
