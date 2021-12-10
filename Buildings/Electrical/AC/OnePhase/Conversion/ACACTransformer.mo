within Buildings.Electrical.AC.OnePhase.Conversion;
model ACACTransformer "AC AC transformer simplified equivalent circuit"
  extends Buildings.Electrical.Icons.RefAngleConversion;
  extends Buildings.Electrical.Interfaces.PartialConversion(
    redeclare package PhaseSystem_p = PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n = PhaseSystems.OnePhase,
    redeclare replaceable Interfaces.Terminal_n terminal_n
      constrainedby Interfaces.Terminal_n(
      i(start = zeros(PhaseSystem_n.n),
      each stateSelect = StateSelect.prefer)),
    redeclare replaceable Interfaces.Terminal_p terminal_p
      constrainedby Interfaces.Terminal_p(
      i(start = zeros(PhaseSystem_p.n),
      each stateSelect = StateSelect.prefer)));
  parameter Modelica.Units.SI.Voltage VHigh
    "Rms voltage on side 1 of the transformer (primary side)";
  parameter Modelica.Units.SI.Voltage VLow
    "Rms voltage on side 2 of the transformer (secondary side)";
  parameter Modelica.Units.SI.ApparentPower VABase
    "Nominal power of the transformer";
  parameter Real XoverR
    "Ratio between the complex and real components of the impedance (XL/R)";
  parameter Real Zperc "Short circuit impedance";
  parameter Boolean ground_1 = false
    "If true, connect side 1 of converter to ground"
    annotation(Evaluate=true,Dialog(tab = "Ground", group="side 1"));
  parameter Boolean ground_2 = true
    "If true, connect side 2 of converter to ground"
    annotation(Evaluate=true, Dialog(tab = "Ground", group="side 2"));
  parameter Modelica.Units.SI.Angle phi_1=0
    "Angle of the voltage side 1 at initialization"
    annotation (Evaluate=true, Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.Angle phi_2=phi_1
    "Angle of the voltage side 2 at initialization"
    annotation (Evaluate=true, Dialog(tab="Initialization"));
  Modelica.Units.SI.Efficiency eta "Efficiency";
  Modelica.Units.SI.Power PLoss[2] "Loss power";

  Modelica.Units.SI.Voltage V1[2](start=PhaseSystem_n.phaseVoltages(VHigh,
        phi_1)) "Voltage at the winding - primary side";
  Modelica.Units.SI.Voltage V2[2](start=PhaseSystem_p.phaseVoltages(VLow, phi_2))
    "Voltage at the winding - secondary side";
protected
  Real N = VHigh/VLow "Winding ratio";
  Modelica.Units.SI.Current IHigh=VABase/VHigh
    "Nominal current on primary side";
  Modelica.Units.SI.Current ILow=VABase/VLow
    "Nominal current on secondary side";
  Modelica.Units.SI.Current IscHigh=IHigh/Zperc
    "Short circuit current on primary side";
  Modelica.Units.SI.Current IscLow=ILow/Zperc
    "Short circuit current on secondary side";
  Modelica.Units.SI.Impedance Zp=VHigh/IscHigh
    "Impedance of the primary side (module)";
  Modelica.Units.SI.Impedance Z1[2]={Zp*cos(atan(XoverR)),Zp*sin(atan(XoverR))}
    "Impedance of the primary side of the transformer";
  Modelica.Units.SI.Impedance Zs=VLow/IscLow
    "Impedance of the secondary side (module)";
  Modelica.Units.SI.Impedance Z2[2]={Zs*cos(atan(XoverR)),Zs*sin(atan(XoverR))}
    "Impedance of the secondary side of the transformer";
  Modelica.Units.SI.Power P_p[2]=PhaseSystem_p.phasePowers_vi(terminal_p.v,
      terminal_p.i) "Power transmitted at pin p (secondary)";
  Modelica.Units.SI.Power P_n[2]=PhaseSystem_n.phasePowers_vi(terminal_n.v,
      terminal_n.i) "Power transmitted at pin n (primary)";
  Modelica.Units.SI.Power S_p=Modelica.Fluid.Utilities.regRoot(P_p[1]^2 + P_p[2]
      ^2, delta=0.1) "Apparent power at terminal p";
  Modelica.Units.SI.Power S_n=Modelica.Fluid.Utilities.regRoot(P_n[1]^2 + P_n[2]
      ^2, delta=0.1) "Apparent power at terminal n";

equation
  // Efficiency
  eta = Buildings.Utilities.Math.Functions.smoothMin(
        x1=
        Modelica.Fluid.Utilities.regRoot(P_p[1]^2 + P_p[2]^2, delta=0.01)/
        Modelica.Fluid.Utilities.regRoot(P_n[1]^2 + P_n[2]^2 + 1e-6, delta=0.01),
        x2=
        Modelica.Fluid.Utilities.regRoot(P_n[1]^2 + P_n[2]^2, delta=0.01)/
        Modelica.Fluid.Utilities.regRoot(P_p[1]^2 + P_p[2]^2 + 1e-6, delta=0.01),
        deltaX = 0.01);

  // Ideal transformation
  V2 = V1/N;
  terminal_p.i[1] + terminal_n.i[1]*N = 0;
  terminal_p.i[2] + terminal_n.i[2]*N = 0;

  // Losses due to the impedance
  terminal_n.v = V1 + Buildings.Electrical.PhaseSystems.OnePhase.product(
    terminal_n.i, Z1);
  V2 = terminal_p.v;

  // Loss of power
  PLoss = P_p + P_n;

  // The two sides have the same reference angle
  terminal_p.theta = terminal_n.theta;

  if ground_1 then
    Connections.potentialRoot(terminal_n.theta);
  end if;
  if ground_2 then
    Connections.root(terminal_p.theta);
  end if;

  annotation (
  defaultComponentName="traACAC",
 Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                      graphics={
        Text(
          extent={{-100,-60},{100,-92}},
          textColor={0,0,0},
          textString="%name"),
        Text(
          extent={{-130,60},{-70,20}},
          textColor={11,193,87},
          textString="1"),
        Text(
          extent={{-130,100},{-70,60}},
          textColor={11,193,87},
          textString="AC"),
        Text(
          extent={{70,100},{130,60}},
          textColor={0,120,120},
          textString="AC"),
        Text(
          extent={{70,60},{130,20}},
          textColor={0,120,120},
          textString="2"),
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
          textColor={0,120,120},
          textString="R"),
        Text(
          extent={{-20,60},{-4,48}},
          textColor={0,120,120},
          textString="L")}),
    Documentation(info="<html>
<p>
This is a simplified equivalent transformer model.
The model accounts for winding Joule losses and leakage reactances
that are represented by a series of a resistance <i>R</i> and an
inductance <i>L</i>. The resistance and the inductance represent both the
effects of the secondary and primary side of the transformer.
</p>
<p>
The model is parameterized using the following parameters
</p>
<ul>
<li><code>VHigh</code> - RMS voltage at primary side,</li>
<li><code>VLow</code> - RMS voltage at secondary side,</li>
<li><code>VABase</code> - apparent nominal power of the transformer,</li>
<li><code>XoverR</code> - ratio between reactance and resistance, and</li>
<li><code>Zperc</code> - the short circuit impedance.</li>
</ul>
<p>
Given the nominal conditions,the model computes the values of the resistance and the inductance.
</p>
</html>", revisions="<html>
<ul>
<li>
January 30, 2019, by Michael Wetter:<br/>
Added missing <code>replaceable</code> for the terminal.
</li>
<li>
November 28, 2016, by Michael Wetter:<br/>
Made voltage public to allow setting a start value in
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Validation.IEEETests.Test4NodesFeeder.UnbalancedStepUp.DY\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Validation.IEEETests.Test4NodesFeeder.UnbalancedStepUp.DY</a>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/584\">#584</a>.
</li>
<li>
September 4, 2014, by Michael Wetter:<br/>
Revised model.
</li>
<li>
August 5, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
<li>June 17, 2014, by Marco Bonvini:<br/>
Adde parameter <code>phi_1</code> and <code>phi_2</code> that are
used during initialization to specify the angle of the voltage phasor.
</li>
<li>
June 9, 2014, by Marco Bonvini:<br/>
Revised implementation and added <code>stateSelect</code> statement to use
the current <code>i[:]</code> on the connectors as iteration variable for the
initialization problem.
</li>
<li>
January 29, 2012, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"));
end ACACTransformer;
