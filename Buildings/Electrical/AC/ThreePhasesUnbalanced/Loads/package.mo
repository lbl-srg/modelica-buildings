within Buildings.Electrical.AC.ThreePhasesUnbalanced;
package Loads "Package with load models for three-phase unbalanced AC systems"
  extends Modelica.Icons.VariantsPackage;


annotation (Documentation(revisions="<html>
<ul>
<li>
September 24, 2014, by Marco Bonvini:<br/>
Revised load models, now they all have the optional voltage controller and the
ability to select the type of connection: Wye (Y) or Delta (D).
</li>
<li>
August 25, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>", info="<html>
<p>
This package contains models that represent different types of three
phases unbalanced AC loads.
</p>
</html>"));
end Loads;
