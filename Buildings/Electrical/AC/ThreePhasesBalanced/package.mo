within Buildings.Electrical.AC;
package ThreePhasesBalanced "Three phases balanced AC systems"
  extends Modelica.Icons.VariantsPackage;


annotation (Documentation(info="<html>
<p>
Package with models for alternate current (AC) three phase balanced systems.<br/>
Because the phases are balanced, the models in this
package extend the models of the package
<a href=\"modelica://Buildings.Electrical.AC.OnePhase\">
Buildings.Electrical.AC.OnePhase</a>.
</p>
<p>
The models that are part of this package assume by default 480 V as nominal RMS phase
to phase voltage. This default value can be changed.
</p>
</html>", revisions="<html>
<ul>
<li>
August 24, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>"));
end ThreePhasesBalanced;
