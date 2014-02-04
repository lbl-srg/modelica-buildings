within Buildings.Electrical.AC.OnePhase.Conversion;
model ACACTransformer "AC AC transformer for single phase systems"
  extends Buildings.Electrical.Interfaces.PartialConversion(
    redeclare package PhaseSystem_p = PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n = PhaseSystems.OnePhase,
    redeclare Interfaces.Terminal_n terminal_n,
    redeclare Interfaces.Terminal_p terminal_p);
  parameter Modelica.SIunits.Voltage Vhigh
    "Rms voltage on side 1 of the transformer (primary side)";
  parameter Modelica.SIunits.Voltage Vlow
    "Rms voltage on side 2 of the transformer (secondary side)";
  parameter Modelica.SIunits.ApparentPower VAbase
    "Nominal power of the transformer";
  parameter Real XoverR
    "Ratio between the complex and real components of the impedance (XL/R)";
  parameter Real Zperc "Short circuit impedance";
  Modelica.SIunits.Efficiency eta "Efficiency of the transformer";
  Modelica.SIunits.Power LossPower[2] "Loss power";
  parameter Boolean ground_1 = false "Connect side 1 of converter to ground" annotation(evaluate=true,Dialog(tab = "Ground", group="side 1"));
  parameter Boolean ground_2 = true "Connect side 2 of converter to ground" annotation(evaluate=true, Dialog(tab = "Ground", group="side 2"));
//protected
  Real N = Vhigh/Vlow "Winding ratio";
  Modelica.SIunits.Current Ihigh = VAbase/Vhigh
    "Nominal current on primary side";
  Modelica.SIunits.Current Ilow = VAbase/Vlow
    "Nominal current on secondary side";
  Modelica.SIunits.Current Isc_high = Ihigh/Zperc
    "Short circuit current on primary side";
  Modelica.SIunits.Current Isc_low = Ilow/Zperc
    "Short circuit current on secondary side";
  Modelica.SIunits.Impedance Zp = Vhigh/Isc_high
    "Impedance of the primary side";
  Modelica.SIunits.Impedance Z1[2] = {Zp*XoverR/sqrt(1+XoverR^2), Zp/sqrt(1+XoverR^2)};
  Modelica.SIunits.Impedance Zs = Vlow/Isc_low
    "Impedance of the secondary side";
  Modelica.SIunits.Impedance Z2[2] = {Zs*XoverR/sqrt(1+XoverR^2), Zs/sqrt(1+XoverR^2)};
  Modelica.SIunits.Voltage V1[2] "Voltage at the winding - primary side";
  Modelica.SIunits.Voltage V2[2] "Voltage at the winding - secondary side";
  Modelica.SIunits.Power Pow_p[2] = PhaseSystem_p.phasePowers_vi(terminal_p.v, terminal_p.i);
  Modelica.SIunits.Power Pow_n[2] = PhaseSystem_n.phasePowers_vi(terminal_n.v, terminal_n.i);
equation
  assert(sqrt(Pow_p[1]^2 + Pow_p[2]^2) <= VAbase*1.01,"The load power of transformer is higher than VAbase");

  // Efficiency
  eta = sqrt(Pow_p[1]^2 + Pow_p[2]^2) / (sqrt(Pow_n[1]^2 + Pow_n[2]^2) + 1e-6);

  // Ideal transformation
  V2 = V1/N;
  terminal_p.i[1] + terminal_n.i[1]*N = 0;
  terminal_p.i[2] + terminal_n.i[2]*N = 0;

  // Losses due to the impedance
  terminal_n.v = V1 + Buildings.Electrical.PhaseSystems.OnePhase.product(
    terminal_n.i, Z1);
  V2 = terminal_p.v;

  // Loss of power
  LossPower = Pow_p + Pow_n;

  //fixme: do we need to do anything for the phase or should we assume the phase remains the same?
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
        Text(
          extent={{-100,-60},{100,-92}},
          lineColor={0,120,120},
          textString="%name"),
        Text(
          extent={{-130,60},{-70,20}},
          lineColor={11,193,87},
          textString="1"),
        Text(
          extent={{-130,100},{-70,60}},
          lineColor={11,193,87},
          textString="AC"),
        Text(
          extent={{70,100},{130,60}},
          lineColor={0,120,120},
          textString="AC"),
        Text(
          extent={{70,60},{130,20}},
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
          smooth=Smooth.Bezier),
        Line(
          points={{-72,40},{-66,40},{-64,44},{-60,36},{-56,44},{-52,36},{-48,44},
              {-44,36},{-42,40},{-38,40}},
          color={0,127,127},
          smooth=Smooth.None),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{-60,-7.34764e-15}},
          color={0,127,127},
          origin={-40,40},
          rotation=180),
        Ellipse(
          extent={{-30,46},{-18,34}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-18,46},{-6,34}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-6,46},{6,34}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,40},{6,28}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{20,40},{20,20}},
          color={0,127,127},
          smooth=Smooth.None),
        Ellipse(
          extent={{14,20},{26,8}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{14,8},{26,-4}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{14,-4},{26,-16}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,20},{20,-16}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{20,-16},{20,-40}},
          color={0,127,127},
          smooth=Smooth.None),
        Line(
          points={{20,-40},{-70,-40}},
          color={0,127,127},
          smooth=Smooth.None),
        Line(
          points={{34,40},{34,20}},
          color={0,127,127},
          smooth=Smooth.None),
        Ellipse(
          extent={{40,20},{28,8}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{40,8},{28,-4}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{40,-4},{28,-16}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{44,20},{34,-16}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{34,-16},{34,-40}},
          color={0,127,127},
          smooth=Smooth.None),
        Line(
          points={{70,-40},{34,-40}},
          color={0,127,127},
          smooth=Smooth.None),
        Line(
          points={{70,40},{34,40}},
          color={0,127,127},
          smooth=Smooth.None),
        Text(
          extent={{-64,60},{-48,48}},
          lineColor={0,120,120},
          textString="R"),
        Text(
          extent={{-20,60},{-4,48}},
          lineColor={0,120,120},
          textString="L")}),
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
end ACACTransformer;
