within Buildings.Electrical.DC.Storage.BaseClasses;
model Charge "Model to compute the battery charge"
  extends Modelica.Blocks.Icons.Block;
  parameter Real etaCha(min=0, max=1, unit="1") = 0.9
    "Efficiency during charging";
  parameter Real etaDis(min=0, max=1, unit="1") = 0.9
    "Efficiency during discharging";
  parameter Real SOC_start(min=0, max=1, unit="1")=0.1
    "Initial state of charge";
  parameter Modelica.SIunits.Energy EMax(min=0, displayUnit="kWh")
    "Maximum available charge";
  Modelica.SIunits.Power PAct "Actual power";
  Modelica.Blocks.Interfaces.RealInput P(final quantity="Power",
                                         final unit="W") annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}),iconTransformation(extent={{-140,-20},{
            -100,20}})));
  Modelica.Blocks.Interfaces.RealOutput SOC(min=0, max=1) "State of charge" annotation (Placement(transformation(
          extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,
            10}})));
protected
  Boolean underCharged "Flag, true if battery is undercharged";
  Boolean overCharged "Flag, true if battery is overcharged";
initial equation
  pre(underCharged) = SOC_start < 0;
  pre(overCharged)  = SOC_start > 1;

  SOC = SOC_start;
equation
  // Charge balance of battery
  PAct = if P > 0 then etaCha*P else (2-etaDis)*P;
  der(SOC)=PAct/EMax;

  // Equations to warn if state of charge exceeds 0 and 1
  underCharged = SOC < 0;
  overCharged = SOC > 1;
  when change(underCharged) or change(overCharged) then
    assert(SOC >= 0, "Warning: Battery is below minimum charge.",
    level=AssertionLevel.warning);
    assert(SOC <= 1, "Warning: Battery is above maximum charge.",
    level=AssertionLevel.warning);
  end when;

  annotation ( Documentation(info="<html>
<p>
This model represents the charge/discharge mechanism of a battery.
</p>
<p>
This model two parameters <i>&eta;<sub>CHA</sub></i> and <i>&eta;<sub>DIS</sub></i> that represent
the efficiency during the charge and discharge of the battery.
</p>
<p>
The model given the power <i>P</i> that should be provide or taken from the battery
and compute the actual power flowing through the battery as
</p>

<table summary=\"equations\" border = \"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collape;\">
<tr><th>Equation</th><th>Condition</th></tr>
<tr>
<td>P<sub>actual</sub> = P &eta;<sub>CHA</sub></td>
<td>P &ge; 0</td>
</tr>
<tr>
<td>P<sub>actual</sub> = P (2 - &eta;<sub>DIS</sub>)</td>
<td>P &lt; 0</td>
</tr>
</table>

<p>
The actual power is then used to compute the variation of the state of charge <code>SOC</code>.
The state of charge is the state variable of this model and is a real value between 0 and 1.
</p>

<p align=\"center\" style=\"font-style:italic;\">
 d SOC / dt = P<sub>actual</sub>
</p>

<p>
<b>Note:</b>The input power <i>P</i> has to be controlled in order
to avoid the state of charge <code>SOC</code>
exceeding the range between 0 and 1.
</p>

</html>", revisions="<html>
<ul>
<li>
June 2, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"));
end Charge;
