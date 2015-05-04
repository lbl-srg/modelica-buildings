within Buildings.Electrical.AC;
package ThreePhasesUnbalanced "Three phases unbalanced AC systems"
  extends Modelica.Icons.VariantsPackage;


annotation (Documentation(info="<html>
<p>
Package with models for alternate current (AC) three phase unbalanced systems.<br/>
The models in this package use the models of the package
<a href=\"modelica://Buildings.Electrical.AC.OnePhase\">
Buildings.Electrical.AC.OnePhase</a> to fully describe the three-phase.
</p>
<p>
The models that are part of this package assume by default <i>480</i> V
as the nominal RMS phase to phase voltage. This default can be changed.
</p>

<h4>Conventions</h4>

<p>
In this package the voltage phasors are measured using the convention shown below.
The phase to phase RMS voltages are by default <i>480</i> V,
which is equal to <code>sqrt(3)</code> times the
phase to neutral voltage <i>V</i>, which is <i>277.13</i> V.
</p>

<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/ThreePhasesUnbalanced/PhaseConvention.png\"/>
</p>

<p>
In this package the voltage phasors are measured using the convention shown above.
The phase to phase RMS voltage equal to 480 V, is equal to <code>sqrt(3)</code> times the
phase to neutral voltage <i>V</i> that is equal to 277.13 V.
</p>

</html>", revisions="<html>
<ul>
<li>
August 25, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"));
end ThreePhasesUnbalanced;
