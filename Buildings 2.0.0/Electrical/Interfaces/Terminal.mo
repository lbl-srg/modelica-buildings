within Buildings.Electrical.Interfaces;
connector Terminal "Generalized electric terminal"
  extends Buildings.Electrical.Interfaces.BaseTerminal;
replaceable package PhaseSystem = PhaseSystems.PartialPhaseSystem
    "Phase system"
  annotation (choicesAllMatching=true);
PhaseSystem.Voltage v[PhaseSystem.n] "Voltage vector";
flow PhaseSystem.Current i[PhaseSystem.n] "Current vector";
PhaseSystem.ReferenceAngle theta[PhaseSystem.m]
    "Optional vector of phase angles";
  annotation (Documentation(revisions="<html>
<ul>
<li>
May 15, 2014, by Marco Bonvini:<br/>
Created documentation.
</li>
<li>
October 31, 2013, by Marco Bonvini:<br/>
Model included into the Buildings library.
</li>
</ul>
</html>", info="<html>
<p>
This connector represents a generalized electric terminal. The generalization is made possible by the
replaceable package <a href=\"modelica://Buildings.Electrical.Interfaces.Terminal.PhaseSystem\">
Buildings.Electrical.Interfaces.Terminal.PhaseSystem</a>.
The package <code>PhaseSystem</code> can be one of the packages contained in
<a href=\"modelica://Buildings.Electrical.PhaseSystems\">
Buildings.Electrical.PhaseSystems</a>.
Using this approach allows to represent DC, single phase AC and
multi phases balanced and unbalanced AC systems with the same connector.
</p>
<p>
This connector is compatible with the following Modelica libraries:
</p>
<ul>
<li><a href=\"http://www.modelon.com/products/modelica-libraries/electric-power-library\">
Electric Power Library</a>
developed by Modelon, and
</li>
<li>
<a href=\"https://github.com/modelica/PowerSystems\">Power Systems Library</a>
developed by <a href=\"mailto:Ruediger.Franke@de.abb.com\">Ruediger Franke</a> (ABB).
</li>
</ul>
<p>
The connector is overdetermined since the number of effort variables
is higher than the number of flow variables.
This happens when the phase system has a number of reference angles
<code>PhaseSystem.m &gt; 0</code>.
The over-determined connectors are defined and used in such a way
that a Modelica tool is able
to remove the superfluous but consistent equations arriving
at a balanced set of equations, based on a
graph analysis of the connection structure.
The models have to use ad-hoc constructs specified by the Modelica language to handle this situation.
More information can be found in <a href=\"#Olsson2008\">Olsson Et Al. (2008)</a>.
</p>
<p>
More details about the generalized electrical terminal
can be found in <a href=\"#RuedigerEtAl2014\">Franke and Wiesmann (2014)</a>.
</p>
<h4>References</h4>
<p>
<a NAME=\"Olsson2008\"/>
Hans Olsson, Martin Otter, Sven Erik Mattson and Hilding Elmqvist.<br/>
<a href=\"http://elib-v3.dlr.de/55892/1/otter2008-modelica-balanced-models.pdf\">
Balanced Models in Modelica 3.0 for Increased Model Quality</a>.<br/>
Proc. of the 7th Modelica Conference, Bielefeld, Germany, March 2008.<br/>
</p>
<p>
<a NAME=\"RuedigerEtAl2014\"/>
Ruediger Franke and Hansjurg Wiesmann.<br/>
<a href=\"https://www.modelica.org/events/modelica2014/proceedings/html/submissions/ECP14096515_FrankeWiesmann.pdf\">
Flexible modeling of electrical power systems - the Modelica PowerSystems library</a>.<br/>
Proc. of the 10th Modelica Conference, Lund, Sweden, March 2014.
</p>
</html>"));
end Terminal;
