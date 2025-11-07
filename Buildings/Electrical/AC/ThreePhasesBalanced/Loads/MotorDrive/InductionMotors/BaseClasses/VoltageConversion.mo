within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
block VoltageConversion
  "Convert the stator voltage from its root mean square (RMS) value into q-axis and d-axis voltages"
  extends Modelica.Blocks.Icons.Block;

  Buildings.Controls.OBC.CDL.Interfaces.RealInput V_rms(
    final unit="V",
    final quantity="Voltage")
    "Root mean squre voltage"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput v_qs(
    final unit="V",
    final quantity="Voltage")
    "Q-axis stator voltage"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput v_ds(
    final unit="V",
    final quantity="Voltage")
    "D-axis stator voltage"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

algorithm
  v_ds:= V_rms;
  v_qs:= 0;

annotation (defaultComponentName="volCon",
Documentation(info="<html>
<p>
This block converts the stator voltage from its root mean square (RMS) value into
d–q axis components.
It assumes the entire applied RMS stator voltage is aligned along the d-axis,
while the q-axis component is set to zero.
</p>
<p>
The implemented relation is:
</p>
<p>
\\[
v_{ds} = V_{rms}
\\qquad\\text{ and }\\qquad
v_{qs} = 0
\\]
</p>
<p>
This simplification is commonly used for initializing induction machine models
where the stator voltage space vector is aligned with the d-axis.
</p>
<p>
This block is used in
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors\">
Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>"));
end VoltageConversion;
