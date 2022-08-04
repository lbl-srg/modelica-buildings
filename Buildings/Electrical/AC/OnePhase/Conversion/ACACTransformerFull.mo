within Buildings.Electrical.AC.OnePhase.Conversion;
model ACACTransformerFull "AC AC transformer with detailed equivalent circuit"
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
    "RMS voltage on side 1 of the transformer (primary side)";
  parameter Modelica.Units.SI.Voltage VLow
    "RMS voltage on side 2 of the transformer (secondary side)";
  parameter Modelica.Units.SI.ApparentPower VABase
    "Nominal power of the transformer";
  parameter Modelica.Units.SI.Frequency f(start=60) "Nominal frequency";
  parameter Buildings.Electrical.Types.PerUnit R1(min=0)
    "Resistance on side 1 of the transformer (pu)";
  parameter Buildings.Electrical.Types.PerUnit L1(min=0)
    "Inductance on side 1 of the transformer (pu)";
  parameter Buildings.Electrical.Types.PerUnit R2(min=0)
    "Resistance on side 2 of the transformer (pu)";
  parameter Buildings.Electrical.Types.PerUnit L2(min=0)
    "Inductance on side 2 of the transformer (pu)";
  parameter Boolean magEffects = false
    "If true, introduce magnetization effects"
    annotation(Evaluate=true, Dialog(group="Magnetization"));
  parameter Buildings.Electrical.Types.PerUnit Rm(min=0)
    "Magnetization resistance (pu)"
    annotation(Evaluate=true, Dialog(group="Magnetization", enable = magEffects));
  parameter Buildings.Electrical.Types.PerUnit Lm(min=0)
    "Magnetization inductance (pu)"
    annotation(Evaluate=true, Dialog(group="Magnetization", enable = magEffects));
  parameter Boolean ground_1 = false "Connect side 1 of converter to ground"
   annotation(Evaluate=true,Dialog(tab = "Ground", group="side 1"));
  parameter Boolean ground_2 = true "Connect side 2 of converter to ground"
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
  Modelica.Units.SI.Voltage V2[2](start=PhaseSystem_n.phaseVoltages(VLow, phi_2))
    "Voltage at the winding - secondary side";
protected
  parameter Modelica.Units.SI.AngularVelocity omega_n=2*Modelica.Constants.pi*f;
  parameter Real N = VHigh/VLow "Winding ratio";
  parameter Modelica.Units.SI.Resistance RBaseHigh=VHigh^2/VABase
    "Base impedance of the primary side";
  parameter Modelica.Units.SI.Resistance RBaseLow=VLow^2/VABase
    "Base impedance of the secondary side";
  Modelica.Units.SI.Impedance Z1[2]={RBaseHigh*R1,omega*L1*RBaseHigh/omega_n}
    "Impedance of the primary side of the transformer";
  Modelica.Units.SI.Impedance Z2[2]={RBaseLow*R2,omega*L2*RBaseLow/omega_n}
    "Impedance of the secondary side of the transformer";
  Modelica.Units.SI.Impedance Zrm[2]={RBaseHigh*Rm,0}
    "Magnetization impedance - resistance";
  Modelica.Units.SI.Impedance Zlm[2]={0,omega*Lm*RBaseHigh/omega_n}
    "Magnetization impedance - impedence";
  Modelica.Units.SI.Power P_p[2]=PhaseSystem_p.phasePowers_vi(terminal_p.v,
      terminal_p.i) "Power transmitted at pin p (secondary)";
  Modelica.Units.SI.Power P_n[2]=PhaseSystem_n.phasePowers_vi(terminal_n.v,
      terminal_n.i) "Power transmitted at pin n (primary)";
  Modelica.Units.SI.Power S_p=Modelica.Fluid.Utilities.regRoot(P_p[1]^2 + P_p[2]
      ^2, delta=0.1) "Apparent power at terminal p";
  Modelica.Units.SI.Power S_n=Modelica.Fluid.Utilities.regRoot(P_n[1]^2 + P_n[2]
      ^2, delta=0.1) "Apparent power at terminal n";
  Modelica.Units.SI.AngularVelocity omega "Angular velocity";
  Modelica.Units.SI.Current Im[2] "Magnetization current";
  Modelica.Units.SI.Angle theRef "Absolute angle of rotating reference system";
equation
  assert(sqrt(P_p[1]^2 + P_p[2]^2) <= VABase*1.01,
    "The load power of the transformer is higher than VABase");

  // Angular velocity
  theRef = PhaseSystem_p.thetaRef(terminal_p.theta);
  omega = der(theRef);

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
  terminal_p.i[1] + (terminal_n.i[1] - Im[1])*N = 0;
  terminal_p.i[2] + (terminal_n.i[2] - Im[2])*N = 0;

  // Magnetization current
  if magEffects then
    Im = Buildings.Electrical.PhaseSystems.OnePhase.divide(V1, Zrm) +
         Buildings.Electrical.PhaseSystems.OnePhase.divide(V1, Zlm);
  else
    Im = zeros(2);
  end if;

  // Losses due to the impedance - primary side
  terminal_n.v = V1 + Buildings.Electrical.PhaseSystems.OnePhase.product(
    terminal_n.i, Z1);

  // Losses due to the impedance - secondary side
  terminal_p.v = V2 + Buildings.Electrical.PhaseSystems.OnePhase.product(
    terminal_p.i, Z2);

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
          extent={{-140,60},{-80,20}},
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
          extent={{80,60},{140,20}},
          textColor={0,120,120},
          textString="2"),
        Line(
          points={{-100,40},{-94,40},{-92,44},{-88,36},{-84,44},{-80,36},{-76,44},
              {-72,36},{-70,40},{-64,40}},
          color={0,127,127},
          smooth=Smooth.None),
        Ellipse(
          extent={{-64,46},{-52,34}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-52,46},{-40,34}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-40,46},{-28,34}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-64,40},{-26,28}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{0,40},{0,20}},
          color={0,127,127},
          smooth=Smooth.None),
        Ellipse(
          extent={{-6,20},{6,8}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-6,8},{6,-4}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-6,-4},{6,-16}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,20},{0,-16}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{0,-16},{0,-40}},
          color={0,127,127},
          smooth=Smooth.None),
        Line(
          points={{0,-40},{-90,-40}},
          color={0,127,127},
          smooth=Smooth.None),
        Line(
          points={{14,40},{14,20}},
          color={0,127,127},
          smooth=Smooth.None),
        Ellipse(
          extent={{20,20},{8,8}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,8},{8,-4}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,-4},{8,-16}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{24,20},{14,-16}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{14,-16},{14,-40}},
          color={0,127,127},
          smooth=Smooth.None),
        Line(
          points={{100,-40},{14,-40}},
          color={0,127,127},
          smooth=Smooth.None),
        Text(
          extent={{-80,60},{-64,48}},
          textColor={0,120,120},
          textString="R"),
        Text(
          extent={{-54,60},{-38,48}},
          textColor={0,120,120},
          textString="L"),
        Line(
          points={{66,40},{72,40},{74,44},{78,36},{82,44},{86,36},{90,44},{94,36},
              {96,40},{100,40}},
          color={0,127,127},
          smooth=Smooth.None),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{-54,-6.61288e-15}},
          color={0,127,127},
          origin={14,40},
          rotation=180),
        Ellipse(
          extent={{26,46},{38,34}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{38,46},{50,34}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{50,46},{62,34}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{26,40},{62,28}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{76,60},{92,48}},
          textColor={0,120,120},
          textString="R"),
        Text(
          extent={{36,60},{52,48}},
          textColor={0,120,120},
          textString="L"),
        Line(
          points={{-26,-1},{-10,-1},{-9,4},{-5,-4},{-1,4},{3,-4},{7,4},{10,-5},{
              12,-1},{22,-1}},
          color={0,127,127},
          smooth=Smooth.None,
          origin={-45,2},
          rotation=90),
        Ellipse(
          extent={{-36,18},{-24,6}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-36,6},{-24,-6}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-36,-6},{-24,-18}},
          lineColor={0,127,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,18},{-30,-18}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{-28,-2.09669e-15}},
          color={0,127,127},
          origin={-28,40},
          rotation=180),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{-1.53415e-16,-6}},
          color={0,127,127},
          origin={-30,18},
          rotation=180),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{-1.53415e-16,-6}},
          color={0,127,127},
          origin={-30,-24},
          rotation=180),
        Line(
          points={{-44,24},{-20,24},{-20,40}},
          color={0,127,127},
          smooth=Smooth.None),
        Line(
          points={{-44,-24},{-20,-24},{-20,-40}},
          color={0,127,127},
          smooth=Smooth.None),
        Text(
          extent={{-70,22},{-54,10}},
          textColor={0,120,120},
          textString="Rm"),
        Text(
          extent={{-70,-8},{-54,-20}},
          textColor={0,120,120},
          textString="Lm")}),
    Documentation(info="<html>
<p>
This is a detailed transformer model that takes into account the winding Joule losses
and the leakage reactances on both primary and secondary side. The model also describes
the core or iron losses and the losses due to magnetization effects.
</p>
<p>
The losses are represented by a series of resistances <i>R<sub>1</sub></i>, <i>R<sub>2</sub></i>,
<i>R<sub>m</sub></i> and inductances <i>L<sub>1</sub></i>, <i>L<sub>2</sub></i>, and
<i>L<sub>m</sub></i>.
</p>
<p>
The model is parameterized using the following parameters
</p>
<ul>
<li><code>VHigh</code> - RMS voltage at primary side,</li>
<li><code>VLow</code> - RMS voltage at secondary side,</li>
<li><code>VABase</code> - apparent nominal power of the transformer,</li>
<li><code>f</code> - frequency,</li>
<li><code>R_1, L_1</code> - resistance and inductance at primary side (per unit),</li>
<li><code>R_2, L_2</code> - resistance and inductance at secondary side (per unit), and</li>
<li><code>R_m, L_m</code> - resistance and inductance for magnetization effects (per unit).</li>
</ul>
<p>
Given the nominal conditions, the model computes the values of the nominal impedances
at both primary and secondary side. Given these values, the per unit values are transformed into
the actual values of the resistances and inductances.
</p>
<p>
The magnetization losses can be enabled or disabled using the boolean flag <code>magEffects</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 30, 2019, by Michael Wetter:<br/>
Added missing <code>replaceable</code> for the terminal.
</li>
<li>
November 28, 2016, by Michael Wetter:<br/>
Made voltage public to allow setting a start value.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/584\">#584</a>.
</li>
<li>
May 26, 2016, by Michael Wetter:<br/>
Moved function call to <code>PhaseSystem.thetaRef</code> out of
derivative operator as this is not yet supported by JModelica.
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
end ACACTransformerFull;
