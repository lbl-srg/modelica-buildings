within Buildings.Electrical.Interfaces;
model PartialConversion
  "Model representing a generic two port system for conversion"
  extends Buildings.Electrical.Interfaces.PartialTwoPort;
  Modelica.Units.SI.Voltage v_p "Voltage drop between the two positive pins";
  Modelica.Units.SI.Voltage v_n "Voltage drop between the two negative pins";
  Modelica.Units.SI.Current i_p "Current flowing through the positive pins";
  Modelica.Units.SI.Current i_n "Current flowing through the negative pins";
equation
  i_p = PhaseSystem_p.systemCurrent(terminal_p.i);
  i_n = PhaseSystem_n.systemCurrent(terminal_n.i);

  v_p = PhaseSystem_p.systemVoltage(terminal_p.v);
  v_n = PhaseSystem_n.systemVoltage(terminal_n.v);

  annotation (Documentation(revisions="<html>
<ul>
<li>
May 15, 2014, by Marco Bonvini:<br/>
Created documentation.
</li>
<li>
October 31, 2013, by Marco Bonvini:<br/>
Model included in the Buildings library.
</li>
</ul>
</html>", info="<html>
<p>
This model extends the base class
<a href=\"Buildings.Electrical.Interfaces.PartialTwoPort\">
Buildings.Electrical.Interfaces.PartialTwoPort</a>
model and declares the variables
<code>v_p</code> and <code>i_p</code> that represents the voltage and the
current at the <code>terminal_p</code>, and the variables
<code>v_n</code> and <code>i_n</code> that represents the voltage and the
current at the <code>terminal_n</code>.
These variables are used in conversion models such as transformers and AC/DC converters.
</p>
</html>"));
end PartialConversion;
