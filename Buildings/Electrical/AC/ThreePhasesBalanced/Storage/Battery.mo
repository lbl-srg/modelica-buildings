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
This model takes as an input the power to be extracted from the AC line and
stored in the battery (if <i>P &gt; 0</i>)
or to be fed into the AC line after being extracted from the battery.
The actual power stored or extracted in the battery differs from <i>P</i> due
to AC/DC conversion losses and battery charge and discharge efficiencies.
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
April 2, 2020 by Michael Wetter:<br/>
Corrected model and improved the documentation. The previous model extracted from
the AC connector the input power <code>P</code> plus the AC/DC conversion losses, but <code>P</code>
should be the power exchanged at the AC connector. Conversion losses are now only
accounted for in the energy exchange at the battery.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1865\">issue 1865</a>.
</li>
<li>
September 22, 2014, by Marco Bonvini:<br/>
Added model and documentation
</li>
</ul>
</html>"));
end Battery;
