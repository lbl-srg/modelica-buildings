within Buildings.Electrical.AC;
package ThreePhasesUnbalanced "Three phases unbalanced AC systems"
  extends Modelica.Icons.VariantsPackage;


annotation (Documentation(info="<html>
<p>
Package with models for alternate current (AC) three phase unbalanced systems.<br/>
The models in this package uses the models of the package
<a href=\"modelica://Buildings.Electrical.AC.OnePhase\">
Buildings.Electrical.AC.OnePhase</a> to fully describe the three phases.
</p>
<p>
The models that are part of this package assume 480 V as nominal RMS phase
to phase voltage.
</p>

<h4>Conventions</h4>

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
