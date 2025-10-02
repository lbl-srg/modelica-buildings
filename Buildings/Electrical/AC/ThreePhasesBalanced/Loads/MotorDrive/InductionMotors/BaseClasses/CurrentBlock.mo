within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
model CurrentBlock "Converts DQ-abc"
  extends Modelica.Blocks.Icons.Block;
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_ds
    "D-axis stator current"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_qs
    "Q-axis stator current"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput wt
    "angular frequency across time"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput I_a
    "Sinusoidal current phase A"
    annotation (Placement(transformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput I_b
    "Sinusoidal current phase B"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput I_c
    "Sinusoidal current phase C"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}})));

equation
  I_a = sin(wt)*i_ds+cos(wt)*i_qs;
  I_b = sin(wt-2.0933)*i_ds+cos(wt-2.0933)*i_qs;
  I_c = sin(wt+2.0933)*i_ds+cos(wt+2.0933)*i_qs;
 annotation (preferredView="info", Documentation(info="<html>
<p>
This block computes 3-phase currents from D-Q currents using the inverse Park transformation:
</p>
<p>
\\[
\\begin{bmatrix}
I_a \\\\[4pt]
I_b \\\\[4pt]
I_c
\\end{bmatrix}
=
\\begin{bmatrix}
\\sin(\\omega t) &amp; \\cos(\\omega t) \\\\[4pt]
\\sin(\\omega t - 120^\\circ) &amp; \\cos(\\omega t - 120^\\circ) \\\\[4pt]
\\sin(\\omega t + 120^\\circ) &amp; \\cos(\\omega t + 120^\\circ)
\\end{bmatrix}
\\begin{bmatrix}
i_{ds} \\\\[4pt]
i_{qs}
\\end{bmatrix}
\\]
</p>
<p>
Here, 120&deg; ≈ 2.0933 radians.
</p>
<p>
This block is used in 
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors\">
Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br/>
First Implementation.
</li>
</ul>
</html>"));
end CurrentBlock;
