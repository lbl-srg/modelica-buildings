within Buildings.Electrical;
package UsersGuide "Electrical package user's guide"
  extends Modelica.Icons.Information;
  annotation (preferredView="info",
Documentation(info="<html>

<h4>Overview</h4>
<p>
The <a href=\"modelica://Buildings.Electrical\">Buildings.Electrical</a> package extends the
capabilities of the buildings library with models for electrical systems, allowing
to study building-to-grid integration such as the effect of large scale PV on the
voltage of the electrical distribution grid.
The package contains models for different types of sources, loads, storage equipment,
and transmission lines for electric power. The package contains models that can be used to
represent DC, AC one-phase, and AC three-phase balanced and unbalanced systems.
The models can be used to scale from the building level up to the distribution level.
The models have been successfully validated against the IEEE four nodes test feeder.
</p>

<h4>Connectors</h4>
<p>
The <a href=\"modelica://Buildings.Electrical\">Buildings.Electrical</a> package uses a
new type of generalized connector that has been introduced by <a href=\"#RuedigerEtAl2014\">R. Franke and Wiesman (2014)</a>
and is used by the <a href=\"https://github.com/modelica/PowerSystems\">Power Systems Library</a>
and the <a href=\"http://www.modelon.com/products/modelica-libraries/electric-power-library\">
Electric Power Library</a>.
</p>
<p>
The Modelica Standard Library (MSL) version 3.2.1 has different connectors depending on the
type of electric system being modeled. For example, DC and AC continuous time systems have
a connector (<a href=\"modelica://Modelica.Electrical.Analog.Interfaces.Pin\">Modelica.Electrical.Analog.Interfaces.Pin</a>)
that differs from the one used by AC models, which use the
quasi-static assumption
(<a href=\"modelica://Modelica.Electrical.QuasiStatic.SinglePhase.Interfaces.Pin\">Modelica.Electrical.QuasiStatic.SinglePhase.Interfaces.Pin</a>).
</p>
<p>
The generalized electrical connector overcomes this limitation. It uses a paradigm
that is similar to the one used by the <code>Modelica.Fluid</code> connectors.
The generalized connector is as follows:
</p>

<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">
<span style=\" font-family:'Courier New,courier'; color:#0000ff;\">connector</span>
<span style=\" font-family:'Courier New,courier';\"> Terminal </span>
<span style=\" font-family:'Courier New,courier'; color:#006400;\">&quot;Generalized electric terminal&quot;</span>
</p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\">
<span style=\" font-family:'Courier New,courier'; color:#0000ff;\">extends </span>
<span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.Electrical.Interfaces.BaseTerminal</span>
<span style=\" font-family:'Courier New,courier';\">;</span>
</p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\">
<span style=\" font-family:'Courier New,courier'; color:#0000ff;\">replaceable package</span>
<span style=\" font-family:'Courier New,courier';\"> PhaseSystem = </span>
<span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.Electrical.PhaseSystems.PartialPhaseSystem </span>
<span style=\" font-family:'Courier New,courier'; color:#006400;\">&quot;Phase system&quot;</span>
<span style=\" font-family:'Courier New,courier';\">;</span>
</p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\">
<span style=\" font-family:'Courier New,courier'; color:#ff0000;\">PhaseSystem.Voltage</span>
<span style=\" font-family:'Courier New,courier';\"> v[PhaseSystem.n] </span>
<span style=\" font-family:'Courier New,courier'; color:#006400;\">&quot;Voltage vector&quot;</span>
<span style=\" font-family:'Courier New,courier';\">;</span
</p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\">
<span style=\" font-family:'Courier New,courier'; color:#0000ff;\">flow </span>
<span style=\" font-family:'Courier New,courier'; color:#ff0000;\">PhaseSystem.Current</span>
<span style=\" font-family:'Courier New,courier';\"> i[PhaseSystem.n] </span>
<span style=\" font-family:'Courier New,courier'; color:#006400;\">&quot;Current vector&quot;</span>
<span style=\" font-family:'Courier New,courier';\">;</span>
</p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\">
<span style=\" font-family:'Courier New,courier'; color:#ff0000;\">PhaseSystem.ReferenceAngle</span>
<span style=\" font-family:'Courier New,courier';\"> theta[PhaseSystem.m] </span>
<span style=\" font-family:'Courier New,courier'; color:#006400;\">&quot;Optional vector of phase angles&quot;</span>
<span style=\" font-family:'Courier New,courier';\">;</span>
</p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\">
<span style=\" font-family:'Courier New,courier'; color:#0000ff;\">end </span>
<span style=\" font-family:'Courier New,courier';\">Terminal;</span>
</p>

<p>
The connector has a package called <code>PhaseSystem</code> that contains constants, functions,
and equations of the specific electric domain. This allows to represent different electrical domains using the
same connector, reusing the same standardized interfaces.
</p>

<p>
As the electrical connectors of the Modelica Standard Library, the <code>Terminal</code> has a vector of voltages as effort variables and
a vector of currents as flow variables. The connector has an additional vector that represents the
reference angle <code>theta[PhaseSystem.m]</code>. If <code>PhaseSystem.m &gt; 0</code> the connector is overdetermined
because the number of effort variables is higher than the number of flow variables.
The over-determined connectors are defined and used in such a way that a Modelica tool is able
to remove the superfluous but consistent equations, arriving at a balanced set of equations based on a
graph analysis of the connection structure. The models in the library uses constructs specified
by the Modelica language to handle this situation <a href=\"#Olsson2008\">Olsson Et Al. (2008)</a>.
</p>

<h4>PhaseSystem</h4>

<p>
The connector has a package called <code>PhaseSystem</code> that allows to represent different
electrical domains using the same connector, reusing the same standardized interfaces.
The available <code>PhaseSystems</code> are contained in the package
<a href=\"modelica://Buildings.Electrical.PhaseSystems\">
Buildings.Electrical.PhaseSystems</a>.
</p>
<p>
Each of the available packages represent a different type of electrical systems.
The electrical systems represented are:
</p>
<ul>
<li>DC systems,</li>
<li>DC systems with two conductors,</li>
<li>one-phase AC systems,</li>
<li>three-phase resistive balanced AC systems,</li>
<li>three-phase balanced AC systems,</li>
<li>three-phase unbalanced AC systems (dq0 representation).</li>
</ul>

<h4>Linearized models and homotopy initialization</h4>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/DC/Loads/simpleLoad.png\"/>
</p>
<p>
Consider the simple DC circuit shown above, where <i>V<sub>S</sub></i> is a
constant voltage source and <i>R</i> is a line resistance. The load has a voltage <i>V</i> across
its electrical pins and a current <i>i</i>. If the power consumed
by the load is <i>P<sub>LOAD</sub></i>, the equation that describes the circuit is nonlinear.
</p>

<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/UsersGuide/nonlinearEq.png\"/>
</p>

<p>
If the number of loads increases, as typically happens in grid simulations, the size of the system of
nonlinear equations to be solved increases too, causing the numerical solver to slow the simulation.
A linearized load model can solve such a problem. All the load models in the
<a href=\"modelica://Buildings.Electrical\">Buildings.Electrical</a> package have a linearized version.
The linearized version of the model can be selected by setting the boolean flag <code>linearized = true</code>.
Details about the implementation of the linearized models can be found in
<a href=\"modelica://Buildings.Electrical.DC.Loads.Conductor\">Buildings.Electrical.DC.Loads.Conductor</a>
or
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Loads.Resistive\">Buildings.Electrical.AC.OnePhase.Loads.Resistive</a>.
</p>

<p>
When multiple loads are connected in a grid through cables that cause voltage drops,
the dimension of the system of nonlinear equations increases linearly with the number of loads.
This nonlinear system of equations introduces challenges during the initialization, as Newton solvers
may diverge if initialized far from a solution.
The initialization problem can be simplified using the homotopy
operator. The homotopy operator uses two different types of equations to compute the value of a
variable: the actual one and a simplified one. The actual equation is the one used during the normal
operation. During initialization, the simplified equation is first solved and then slowly replaced with the
actual equation to compute the initial values for the nonlinear systems of equations.
The load model uses the homotopy operator, with the linearized model being used
as the simplified equation. This numerical expedient has proven useful
when simulating models with more than ten connected loads.
All the load models of the <a href=\"modelica://Buildings.Electrical\">Buildings.Electrical</a> package use the
the homotopy operator during the initialization. The parameter <code>initMode</code> is used to select which
simplified equation should be used by the homotopy operator:
</p>
<ul>
<li><code>Buildings.Electrical.Types.InitMode.zeroCurrent</code></li>
<li><code>Buildings.Electrical.Types.InitMode.linearized</code></li>
</ul>

<h4>Nominal values</h4>
<p>
Most components have a parameters for the nominal operating conditions.
These parameters have names that end in <code>_nominal</code> and
they should be set to the values that the component typically
have if they are run at design conditions. Depending on the model, these
parameters are used differently, and the respective model documentation or code
should be consulted for details. However, the table below shows the typical use of
the parameters in various models to help the user understand how they are used.
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<th>Parameter</th>
<th>Model</th>
<th>Functionality</th>
</tr>
<tr>
  <td>V_nominal<br/>
      P_nominal</td>
  <td>Load models</td>
  <td>
  <code>V_nominal</code> is the RMS (Root Mean Square) voltage at which the load consumes the
  nominal real power (measured in [W]) <code>P_nominal</code>.
  When the load model are linearized, the linearization is done for <code>V = V_nominal</code>.
  </td>
</tr>
<tr>
  <td>V_nominal<br/>
      P_nominal</td>
  <td>Transmission line models
  </td>
  <td>
  <code>V_nominal</code> is the RMS (Root Mean Square) voltage at which the line operates
  while <code>P_nominal</code> is the power flowing through it. These values are used in some
  cases to automatically select the right cable properties.
  </td>
</tr>
<tr>
  <td>V_nominal</td>
  <td>Storage<br/>
      PVs<br/>
      Wind turbine
  </td>
  <td>
  <code>V_nominal</code> is the RMS (Root Mean Square) voltage at which these components
  typically operate. Since these model contain load models, <code>V_nominal</code> can be used
  for linearization purposes.
  </td>
</tr>
<tr>
  <td>V_nominal</td>
  <td>Sensors</td>
  <td>
  <code>V_nominal</code> is the RMS (Root Mean Square) voltage of the system
  that is currently measured, it can be used to measure quantities in per unit [pu].
  </td>
</tr>
</table>

<h4>Other information</h4>
<p>
Other information about the models and the packages can be found in the
info section of each model or sub-packages.
</p>

<h4>Awards</h4>
<p>
The paper titled <a href=\"modelica://Buildings/Resources/Images/Electrical/UsersGuide/2014-BauSim-BonviniWetterNouidui.pdf\">
A Modelica package for building-to-electrical grid integration</a> won the best paper
award at the BauSIM 2014 conference.
</p>

<h4>References</h4>
<p>
<a name=\"BonviniEtAl2014\"/>
Marco Bonvini, Michael Wetter, and Thierry Stephane Nouidui.<br/>
<a href=\"modelica://Buildings/Resources/Images/Electrical/UsersGuide/2014-BauSim-BonviniWetterNouidui.pdf\">
A Modelica package for building-to-electrical grid integration</a><br/>
<i>BauSIM 2014 Conference</i>, Aachen, Germany, September 2014.<br/>
</p>

<p>
<a name=\"RuedigerEtAl2014\"/>
Rudiger Franke and Hansjorg Wiesmann.<br/>
<a href=\"https://www.modelica.org/events/modelica2014/proceedings/html/submissions/ECP14096515_FrankeWiesmann.pdf\">
Flexible modeling of electrical power systems - the Modelica PowerSystems library</a>.<br/>
Proc. of the 10th Modelica Conference, Lund, Sweden, March 2014.<br/>
</p>

<p>
<a name=\"Olsson2008\"/>
Hans Olsson, Martin Otter, Sven Erik Mattson and Hilding Elmqvist.<br/>
<a href=\"http://elib-v3.dlr.de/55892/1/otter2008-modelica-balanced-models.pdf\">
Balanced Models in Modelica 3.0 for Increased Model Quality</a>.<br/>
Proc. of the 7th Modelica Conference, Bielefeld, Germany, March 2008.<br/>
</p>
</html>", revisions="<html>
<ul>
<li>
May 15, 2014, by Marco Bonvini:<br/>
Created User's guide.
</li>
</ul>
</html>"));
end UsersGuide;
