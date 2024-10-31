within Buildings.Electrical;
package AC "Package for electrical systems in which the frequency is modeled as quasi-stationary"
  extends Modelica.Icons.Package;

package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

    annotation (preferredView="info",
Documentation(info="<html>
<p>
The package
<a href=\"modelica://Buildings.Electrical.AC\">Buildings.Electrical.AC</a>
models alternate current electrical systems.
</p>

<h4>Modeling assumptions</h4>
<p>
The package <a href=\"modelica://Buildings.Electrical.AC\">Buildings.Electrical.AC</a> contains
component models for AC systems. The mathematics that describes AC systems is contained in the package
<a href=\"modelica://Buildings.Electrical.PhaseSystems.OnePhase\">Buildings.Electrical.PhaseSystems.OnePhase</a>,
in which <code>n = 2</code> and <code>m = 1</code>. The AC models that are part of the library can use two different assumptions.
</p>
<p>
The first assumption is that the frequency is modeled as quasi-stationary, assuming a perfect sine
wave with no higher harmonics. Voltages and currents are considered as sine waves and just their
amplitudes and phase shifts are taken into account during the analysis.
With such an assumption, electric quantities can be represented with a phasor, i.e., a vector
in the complex plane.
</p>
<p>
The second assumption is the so-called dynamic phasorial representation. The basic idea of the
dynamic phasorial representation is to account for dynamic variations of the amplitude and
the angle of the phasors. With such an approach, it is possible to analyze faster dynamics
without directly representing all the electromagnetic effects and high-order harmonics
(for more details, see <a href=\"#Stankovic1999\">Stankovic Et Al. 1999</a>, and
<a href=\"#Stankovic2000\">Stankovic A.M. and Aydin T.</a>).
</p>

<h4>Phasorial representation</h4>
<p>
Both the quasi-stationary and the dynamic phasors represent electric
quantities such as voltages and currents using phasors.
The phasors are described by complex numbers that internally are represented as a vector
with two components. The vectors can be represented in the so called Argand plane where on the x-axis
are represented Real numbers while on the y-axis imaginary numbers.
</p>
<p>
With such a representation the complex voltages, currents, and powers are represented as
</p>
<p align=\"center\" style=\"font-style:italic;\">
<span style=\"text-decoration: overline;\">V</span> = V<sub>Re</sub> + j V<sub>Im</sub>,
</p>
<p align=\"center\" style=\"font-style:italic;\">
<span style=\"text-decoration: overline;\">I</span> = I<sub>Re</sub> + j I<sub>Im</sub>,
</p>
<p align=\"center\" style=\"font-style:italic;\">
<span style=\"text-decoration: overline;\">S</span> = P + j Q,
</p>

<p>
The images below shows how the complex power vector <i><span style=\"text-decoration: overline;\">S</span></i>
changes depending on the type of load.
</p>

<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/OnePhase/ComplexPower.png\"/>
</p>

<p>
where the subscripts indicates a
</p>

<ul>
<li><i>R</i> - purely resistive load</li>
<li><i>L</i> - purely inductive load</li>
<li><i>C</i> - purely capacitive load</li>
<li><i>RL</i> - resistive inductive load</li>
<li><i>RC</i> - resistive capacitive load</li>
</ul>

<h4>Reference angle for AC systems</h4>
<p>
The AC connector has an additional vector that represents the
reference angle <code>theta[PhaseSystem.m]</code>. The reference angle is used, for example in the
AC single phase systems to describe the phase angle of the reference voltage.
This extra information in the connector makes it overdetermined
because the number of effort variables is higher than the number of flow variables.
The over-determined connectors are defined and used in such a way that a Modelica tool is able
to remove the superfluous but consistent equations, arriving at a balanced set of equations based on a
graph analysis of the connection structure. The models in the library uses constructs specified
by the Modelica language to handle this situation, as described by <a href=\"#Olsson2008\">Olsson et al. (2008)</a>.
</p>
<p>
The reference angles are usually defined by the sources (e.g., voltage sources or generators) and
their values need to be propagated to all the components connected to them.
If more than one generator are connected to the same network, the Modelica tool is able to remove the superfluous equations,
arriving at a balanced set of equations based on a graph analysis of the connection structure.
The flags <code>potentialReference</code> and <code>definiteReference</code> are used to help the
Modelica tool during the selection of the reference angle. If <code>definiteReference = true</code>,
then the reference angle of the source has to be used as reference, while if
<code>potentialReference = true</code>, the reference angle is used only if there are no
definite sources defined.
</p>
<p>
When a model is set as definite source an icon representing a phase angle is placed close to its
electrical terminal.
</p>


<h4>References</h4>
<p>
<a name=\"Stankovic1999\"/>
A.M. Stankovic, B.C. Lesieutre, T. Aydin; Modeling and analysis of single-pahse
induction machines with dynamic phasors<br/>
<a href=\"http://www.ece.neu.edu/faculty/stankovic/Jour_papers/pwrs299im.pdf\">
<i>IEEE Transactions on Power Systems</i>, 14(1), Feb. 1999, pp. 9-14.</a><br/>
<a name=\"Stankovic2000\"/>
A.M. Stankovic, T. Aydin; Analysis of asymmetrical faults in power systems using
dynamic phasors<br/>
<a href=\"http://www.ece.neu.edu/faculty/stankovic/Jour_papers/pwrs299im.pdf\">
<i>IEEE Transactions on Power Systems</i>, 15(3), 2000, pp. 1062-1068 .</a><br/>
<a name=\"Olsson2008\"/>
Hans Olsson, Martin Otter, Sven Erik Mattson and Hilding Elmqvist.<br/>
<a href=\"http://elib-v3.dlr.de/55892/1/otter2008-modelica-balanced-models.pdf\">
Balanced Models in Modelica 3.0 for Increased Model Quality</a>.<br/>
Proc. of the 7th Modelica Conference, Bielefeld, Germany, March 2008.<br/>
</p>

</html>"));
end UsersGuide;

  annotation (Icon(graphics={ Line(points={{-92,-10},{-80.7,24.2},{-73.5,43.1},{
              -67.1,56.4},{-61.4,64.6},{-55.8,69.1},{-50.2,69.8},{-44.6,66.6},{-38.9,
              59.7},{-33.3,49.4},{-26.9,34.1},{-18.83,11.2},{-1.9,-40.8},{5.3,-60.2},
              {11.7,-74.2},{17.3,-83.1},{23,-88.4},{28.6,-90},{34.2,-87.6},{39.9,
              -81.5},{45.5,-71.9},{51.9,-57.2},{60,-34.8},{68,-10}}, color={0,0,
              0})}), Documentation(info="<html>
<p>
Package with models for alternating current (AC) systems.
</p>
</html>", revisions="<html>
<ul>
<li>
August 27, 2014, by Marco Bonvini:<br/>
Added documentation.
</li>
</ul>
</html>"));
end AC;
