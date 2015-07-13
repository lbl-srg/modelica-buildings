within Buildings.Electrical.AC.ThreePhasesBalanced.Storage;
model Battery "Simple model of a battery"
  extends Buildings.Electrical.AC.OnePhase.Storage.Battery(redeclare
      Interfaces.Terminal_p terminal,
      V_nominal(start=480),
      redeclare Buildings.Electrical.AC.ThreePhasesBalanced.Loads.Resistive bat);

  annotation (
defaultComponentName="bat",
Documentation(info="<html>
<p>
Simple model of a battery.
</p>
<p>
This model takes as an input the power to be stored in the battery (if <i>P &gt; 0</i>)
or to be extracted from the battery. This model takes into account the efficiency of the conversion
between DC and AC <i>&eta;<sub>DCAC</sub></i>.
</p>
<p>
The output connector <code>SOC</code> is the state of charge of the battery.
This model does not enforce that the state of charge is between zero and one.
However, each time the state of charge crosses zero or one, a warning will
be written to the simulation log file.
The model also does not limit the current through the battery. The user should
provide a control so that only a reasonable amount of power is exchanged,
and that the state of charge remains between zero and one.
</p>
</html>",
        revisions="<html>
<ul>
<li>
September 22, 2014, by Marco Bonvini:<br/>
Added model and documentation
</li>
</ul>
</html>"));
end Battery;
