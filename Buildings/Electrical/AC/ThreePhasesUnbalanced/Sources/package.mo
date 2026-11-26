within Buildings.Electrical.AC.ThreePhasesUnbalanced;
package Sources "Package with sources model for three-phase unbalanced AC systems"
  extends Modelica.Icons.SourcesPackage;


annotation (Documentation(revisions="<html>
<ul>
<li>
November 22, 2026, by Michael Wetter:<br/>
Added grounding transformer model.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2217\">IBPSA, #2217</a>
and
<a href=\"https://github.com/OpenModelica/OpenModelica/issues/10968\">OpenModelica, #10968</a>.
</li>
<li>
August 25, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>", info="<html>
<p>
This package contains models that represent different types of three-phase
unbalanced AC sources and grounding devices.
</p>
</html>"));
end Sources;