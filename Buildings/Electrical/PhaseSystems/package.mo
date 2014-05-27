within Buildings.Electrical;
package PhaseSystems "Phase systems used in power connectors"
  extends Modelica.Icons.Package;
  import SI = Modelica.SIunits;
  import Modelica.Constants.pi;


  annotation (Icon(graphics={Line(
          points={{-70,-52},{50,-52}},
          color={95,95,95},
          smooth=Smooth.None), Line(
          points={{-70,8},{-58,28},{-38,48},{-22,28},{-10,8},{2,-12},{22,-32},{
              40,-12},{50,8}},
          color={95,95,95},
          smooth=Smooth.Bezier)}), Documentation(info="<html>
<p>
This package contains a list of packages that represent different type of electric systems.<br/>
Each package inherit from <a href=\"modelica://Buildings.Electrical.PhaseSystems.PartialPhaseSystem\">Buildings.Electrical.PhaseSystems.PartialPhaseSystem</a>.<br/>
</p>
<p>
The packages represent various type of electrical systems. The basic idea behind this 
approach is to use the same connector for different electrical domains.<br/>
Each connector will have a replaceable package that inherit from <a href=\"modelica://Buildings.Electrical.PhaseSystems.PartialPhaseSystem\">Buildings.Electrical.PhaseSystems.PartialPhaseSystem</a> 
depending on the type of system to represent.<br/>
The electrical systems represented are:
<ul>
<li>DC systems,</li>
<li>DC systems with two conductors,</li>
<li>1 Phase AC systems,</li>
<li>3 Phases resistive balanced AC systems,</li>
<li>3 Phases balanced AC systems,</li>
<li>3 Phases unbalanced AC systems (dq0 representation).</li>
</ul>
</p>
</p>
<p>
This approach has been used by the following Modelica libraries:
<ul>
<li><a href=\"http://www.modelon.com/products/modelica-libraries/electric-power-library\">Electric Power Library</a> developed by Modelon,</li>
<li><a href=\"https://github.com/modelica/PowerSystems\">Power Systems Library</a> developed by <a href=\"mailto:Ruediger.Franke@de.abb.com\">Rüdiger Franke</a> (ABB).</li>
</ul>
</p>

<p>
More details about the phase system packages can be found in <a href=\"#RuedigerEtAl2014\">Franke and Wierssman (2014)</a>.
</p>
<h4>References</h4>
<p>
<a NAME=\"RuedigerEtAl2014\"/>
Rüdiger Franke and Hansjürg Wiesmann.<br/>
<a href=\"https://www.modelica.org/events/modelica2014/proceedings/html/submissions/ECP14096515_FrankeWiesmann.pdf\">
Flexible modeling of electrical power systems - the Modelica PowerSystems library</a><br/>
Proc. of the 10th Modelica Conference, Lund, Sweden, March 2014. 
</p>
</html>", revisions="<html>
<ul>
<li>
May 27, 2014, by Marco Bonvini:<br/>
Created documentation.
</li>
</ul>
</html>"));
end PhaseSystems;
