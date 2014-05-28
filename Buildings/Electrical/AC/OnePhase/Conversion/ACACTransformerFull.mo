within Buildings.Electrical.AC.OnePhase.Conversion;
model ACACTransformerFull
  "AC AC transformer for single phase systems with impedances on both primary and secondary side"
  extends Buildings.Electrical.Interfaces.PartialConversion(
    redeclare package PhaseSystem_p = PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n = PhaseSystems.OnePhase,
    redeclare Interfaces.Terminal_n terminal_n(redeclare package PhaseSystem =
          PhaseSystem_n),
    redeclare Interfaces.Terminal_p terminal_p(redeclare package PhaseSystem =
          PhaseSystem_p));
  parameter Modelica.SIunits.Voltage Vhigh
    "Rms voltage on side 1 of the transformer (primary side)";
  parameter Modelica.SIunits.Voltage Vlow
    "Rms voltage on side 2 of the transformer (secondary side)";
  parameter Modelica.SIunits.ApparentPower VAbase
    "Nominal power of the transformer";
  parameter Buildings.Electrical.Types.PerUnit R1(min=0)
    "Resistance on side 1 of the transformer (pu)";
  parameter Buildings.Electrical.Types.PerUnit L1(min=0)
    "Inductance on side 1 of the transformer (pu)";
  parameter Buildings.Electrical.Types.PerUnit R2(min=0)
    "Resistance on side 2 of the transformer (pu)";
  parameter Buildings.Electrical.Types.PerUnit L2(min=0)
    "Inductance on side 2 of the transformer (pu)";
  parameter Boolean ground_1 = false "Connect side 1 of converter to ground" annotation(evaluate=true,Dialog(tab = "Ground", group="side 1"));
  parameter Boolean ground_2 = true "Connect side 2 of converter to ground" annotation(evaluate=true, Dialog(tab = "Ground", group="side 2"));
  Modelica.SIunits.Efficiency eta "Efficiency of the transformer";
  Modelica.SIunits.Power LossPower[2] "Loss power";
//protected
  Real N = Vhigh/Vlow "Winding ratio";
  Modelica.SIunits.Impedance Zbase_high = Vhigh^2/VAbase
    "Base impedance of the primary side";
  Modelica.SIunits.Impedance Zbase_low = Vlow^2/VAbase
    "Base impedance of the secondary side";
  Modelica.SIunits.Impedance Z1[2] = Zbase_high*{R1, omega*L1};
  Modelica.SIunits.Impedance Z2[2] = Zbase_low*{R2, omega*L2};
  Modelica.SIunits.Voltage V1[2] "Voltage at the winding - primary side";
  Modelica.SIunits.Voltage V2[2] "Voltage at the winding - secondary side";
  Modelica.SIunits.Power Pow_p[2] = PhaseSystem_p.phasePowers_vi(terminal_p.v, terminal_p.i);
  Modelica.SIunits.Power Pow_n[2] = PhaseSystem_n.phasePowers_vi(terminal_n.v, terminal_n.i);
  Modelica.SIunits.Power Sp = sqrt(Pow_p[1]^2 + Pow_p[2]^2)
    "Apparent power terminal p";
  Modelica.SIunits.Power Sn = sqrt(Pow_n[1]^2 + Pow_n[2]^2)
    "Apparent power terminal n";
  Modelica.SIunits.AngularVelocity omega;
equation
  assert(sqrt(Pow_p[1]^2 + Pow_p[2]^2) <= VAbase*1.01,"The load power of transformer is higher than VAbase");

  // Angular velocity
  omega = der(PhaseSystem_p.thetaRef(terminal_p.theta));

  // Efficiency
  eta = Buildings.Utilities.Math.Functions.smoothMin(
        x1=  sqrt(Pow_p[1]^2 + Pow_p[2]^2) / (sqrt(Pow_n[1]^2 + Pow_n[2]^2) + 1e-6),
        x2=  sqrt(Pow_n[1]^2 + Pow_n[2]^2) / (sqrt(Pow_p[1]^2 + Pow_p[2]^2) + 1e-6),
        deltaX=  0.01);

  // Ideal transformation
  V2 = V1/N;
  terminal_p.i[1] + terminal_n.i[1]*N = 0;
  terminal_p.i[2] + terminal_n.i[2]*N = 0;

  // Losses due to the impedance - primary side
  terminal_n.v = V1 + Buildings.Electrical.PhaseSystems.OnePhase.product(
    terminal_n.i, Z1);

  // Losses due to the impedance - secondary side
  terminal_p.v = V2 + Buildings.Electrical.PhaseSystems.OnePhase.product(
    terminal_p.i, Z2);

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
          extent={{74,60},{134,20}},
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
          points={{-92,40},{-86,40},{-84,44},{-80,36},{-76,44},{-72,36},{-68,44},
              {-64,36},{-62,40},{-58,40}},
          color={0,127,127},
          smooth=Smooth.None),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{-54,-6.61288e-15}},
          color={0,127,127},
          origin={-62,40},
          rotation=180),
        Ellipse(
          extent={{-50,46},{-38,34}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-38,46},{-26,34}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-26,46},{-14,34}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-50,40},{-14,28}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{-8,40},{-8,20}},
          color={0,127,127},
          smooth=Smooth.None),
        Ellipse(
          extent={{-14,20},{-2,8}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-14,8},{-2,-4}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-14,-4},{-2,-16}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,20},{-8,-16}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{-8,-16},{-8,-40}},
          color={0,127,127},
          smooth=Smooth.None),
        Line(
          points={{-8,-40},{-98,-40}},
          color={0,127,127},
          smooth=Smooth.None),
        Line(
          points={{6,40},{6,20}},
          color={0,127,127},
          smooth=Smooth.None),
        Ellipse(
          extent={{12,20},{0,8}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{12,8},{0,-4}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{12,-4},{0,-16}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{16,20},{6,-16}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{6,-16},{6,-40}},
          color={0,127,127},
          smooth=Smooth.None),
        Line(
          points={{98,-40},{6,-40}},
          color={0,127,127},
          smooth=Smooth.None),
        Text(
          extent={{-80,60},{-64,48}},
          lineColor={0,120,120},
          textString="R"),
        Text(
          extent={{-40,60},{-24,48}},
          lineColor={0,120,120},
          textString="L"),
        Line(
          points={{58,40},{64,40},{66,44},{70,36},{74,44},{78,36},{82,44},{86,36},
              {88,40},{92,40}},
          color={0,127,127},
          smooth=Smooth.None),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{-54,-6.61288e-15}},
          color={0,127,127},
          origin={6,40},
          rotation=180),
        Ellipse(
          extent={{18,46},{30,34}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{30,46},{42,34}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{42,46},{54,34}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{18,40},{54,28}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{68,60},{84,48}},
          lineColor={0,120,120},
          textString="R"),
        Text(
          extent={{28,60},{44,48}},
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
end ACACTransformerFull;
