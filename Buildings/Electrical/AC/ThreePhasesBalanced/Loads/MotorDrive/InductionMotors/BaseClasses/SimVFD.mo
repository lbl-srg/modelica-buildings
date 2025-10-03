within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
block SimVFD "Simple VFD maintaing constant V/F ratio"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer f(
    start=50,
    fixed=true) "Nominal Frequency in Hz";
  parameter Integer p(
    start=4,
    fixed=true) " Number of Pole pairs ";
  parameter Real N_s(
    start=1500,
    fixed=true) "Synchronous Speed in RPM";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput N_ref
    "Reference speed"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput V_in
    "Input voltage"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput Freq
    "Nominal frequency"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput V_out
    "Output voltage"
    annotation (Placement(transformation(extent={{100,-58},{136,-22}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Freq_out
    "Output frequency"
    annotation (Placement(transformation(extent={{100,22},{136,58}})));

  Modelica.Blocks.Math.Gain Equivalent_Freq(k=p/(120)) "Equivalent frequency"
    annotation (Placement(transformation(extent={{-64,50},{-44,70}})));
  Modelica.Blocks.Math.Division VFD_Ratio "VFD ratio"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=N_s*p/120) "Rated frequency"
    annotation (Placement(transformation(extent={{-60,8},{-40,30}})));
  Modelica.Blocks.Math.Product product1 "VFD voltage"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Modelica.Blocks.Math.Product product2 "VFD frequency"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Modelica.Blocks.Math.Gain gain(k=2*Modelica.Constants.pi) "VFD angular frequency"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));

equation
  connect(Equivalent_Freq.u, N_ref)
    annotation (Line(points={{-66,60},{-120,60}}, color={0,0,127}));
  connect(Equivalent_Freq.y, VFD_Ratio.u1)
    annotation (Line(points={{-43,60},{-38,60},{-38,56},{-22,56}},
          color={0,0,127}));
  connect(product1.u2, VFD_Ratio.y) annotation (Line(points={{18,-46},{6,
          -46},{6,50},{1,50}}, color={0,0,127}));
  connect(product1.y, V_out) annotation (Line(points={{41,-40},{118,-40}},
          color={0,0,127}));
  connect(product2.u1, VFD_Ratio.y)
    annotation (Line(points={{18,46},{6,46},{6,50},{1,50}}, color={0,0,127}));
  connect(product2.u2, Freq) annotation (Line(points={{18,34},{0,34},{0,
          -60},{-120,-60}}, color={0,0,127}));
  connect(gain.u, product2.y)
    annotation (Line(points={{58,40},{41,40}}, color={0,0,127}));
  connect(V_in, product1.u1) annotation (Line(points={{-120,0},{12,0},{12,
          -34},{18,-34}}, color={0,0,127}));
  connect(VFD_Ratio.u2, realExpression.y) annotation (Line(points={{-22,
          44},{-34,44},{-34,19},{-39,19}}, color={0,0,127}));
  connect(Freq_out, Freq_out)
    annotation (Line(points={{118,40},{118,40}}, color={0,0,127}));
  connect(gain.y, Freq_out)
    annotation (Line(points={{81,40},{118,40}}, color={0,0,127}));
annotation (preferredView="info", Documentation(info="<html>
<p>
This block models a simple Variable Frequency Drive (VFD) that maintains a constant V/f ratio.  
It adjusts the output voltage <i>V<sub>out</sub></i> proportionally to the reference speed <i>N<sub>ref</sub></i> while maintaining the ratio with respect to the synchronous speed <i>N<sub>s</sub></i> and nominal frequency <i>f</i>.
</p>

<p>
The main relations are:
</p>

<p>
\\[
\\text{V/f ratio} = \\frac{V_{in}}{f}
\\qquad\\Longrightarrow\\qquad
V_{out} = \\frac{V_{in}}{f} \\times f_{out}
\\]
</p>

<p>
\\[
f_{out} = \\frac{p \\times N_{ref}}{120}
\\qquad\\text{ and }\\qquad
\\omega_{out} = 2\\pi f_{out}
\\]
</p>

<p>
where  
<i>p</i> is the number of poles,  
<i>f_{out}</i> is the generated output frequency,  
and <i>\\omega_{out}</i> is its corresponding angular frequency.
</p>

<p>
<b>Inputs:</b> <i>N<sub>ref</sub></i> [rpm], <i>V<sub>in</sub></i> [V], <i>f</i> [Hz] &nbsp; | &nbsp;
<b>Outputs:</b> <i>V<sub>out</sub></i> [V], <i>f<sub>out</sub></i> [Hz]
</p>

<p>
This block is used in 
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors\">
Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors</a>.
</p>
</html>
",        revisions="<html>
<ul>
<li>
May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br/>
First Implementation.
</li>
</ul>
</html>"));
end SimVFD;
