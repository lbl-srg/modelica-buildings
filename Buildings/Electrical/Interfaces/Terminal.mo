within Buildings.Electrical.Interfaces;
connector Terminal "General electric terminal"
  extends Buildings.Electrical.Interfaces.BaseTerminal;
replaceable package PhaseSystem = PhaseSystems.PartialPhaseSystem
    "Phase system"
  annotation (choicesAllMatching=true);
PhaseSystem.Voltage v[PhaseSystem.n] "Voltage vector";
flow PhaseSystem.Current i[PhaseSystem.n] "Current vector";
PhaseSystem.ReferenceAngle theta[PhaseSystem.m] if PhaseSystem.m > 0
    "Optional vector of phase angles";
  annotation (Icon(graphics), Documentation(revisions="<html>
<ul>
<li>
October 31, 2013, by Marco Bonvini:<br/>
Model included into the Buildings library.
</li>
</ul>
</html>", info="<html>
<p>
This connector represents a generalized electric terminal. The generalization is made possible by the
replaceable package <a href=\"modelica://Buildings.Electrical.Interfaces.Terminal.PhaseSystem\">Buildings.Electrical.Interfaces.Terminal.PhaseSystem</a>.<br/>
The package <code>PhaseSystem</code> can be one of the packages contained in <a href=\"modelica://Buildings.Electrical.PhaseSystems\">Buildings.Electrical.PhaseSystems</a>.<br/>
Using this approach is possible to represent DC, single phase AC and multi phases balanced/unbalanced AC systems with the same connector.
</p>
<p>
This connector is compatible with the following Modelica libraries:
<ul>
<li><a href=\"http://www.modelon.com/products/modelica-libraries/electric-power-library\">Electric Power Library</a> developed by Modelon,</li>
<li><a href=\"https://github.com/modelica/PowerSystems\">Power Systems Library</a> developed by <a href=\"mailto:Ruediger.Franke@de.abb.com\">Rüdiger Franke</a> (ABB).</li>
</ul>
</p>
<p>
More details about the generalized electrical terminal can be found in <a href=\"#RuedigerEtAl2014\">Franke and Wierssman (2014)</a>.
</p>
<h4>References</h4>
<p>
<a NAME=\"RuedigerEtAl2014\"/>
Rüdiger Franke and Hansjürg Wiesmann.<br/>
<a href=\"https://www.modelica.org/events/modelica2014/proceedings/html/submissions/ECP14096515_FrankeWiesmann.pdf\">
Flexible modeling of electrical power systems - the Modelica PowerSystems library</a><br/>
Proc. of the 10th Modelica Conference, Lund, Sweden, March 2014. 
</p>
</html>"));
end Terminal;
