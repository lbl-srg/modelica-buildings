within Buildings.Electrical.AC;
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
in which n = 2 and m = 1. The AC models that are part of the library can use two different assumptions.
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
the angle of the pha- sors. With such an approach, it is possible to analyze faster dynamics
without directly representing all the electromagnetic effects and high-order harmonics
(for more details <a href=\"#Stankovic1999\">Stankovic Et Al. 1999</a>, and
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

<h4>Phasorial representation</h4>
<p>
fixme: add documentation for the flags <code>potentialReference</code> and
<code>definiteReference</code>.
</p>

<h4>References</h4>
<p>
<a NAME=\"Stankovic1999\"/>
A.M. Stankovic, B.C. Lesieutre, T. Aydin; Modeling and analysis of single-pahse
induction machines with dynamic phasors<br/>
<a href=\"http://www.ece.neu.edu/faculty/stankovic/Jour_papers/pwrs299im.pdf\">
<i>IEEE Transactions on Power Systems</i>, 14(1), Feb. 1999, pp. 9-14.</a><br/>
<a NAME=\"Stankovic2000\"/>
A.M. Stankovic, T. Aydin; Analysis of asymmetrical faults in power systems using
dynamic phasors<br/>
<a href=\"http://www.ece.neu.edu/faculty/stankovic/Jour_papers/pwrs299im.pdf\">
<i>IEEE Transactions on Power Systems</i>, 15(3), 2000, pp. 1062-1068 .</a><br/>
</p>


</html>"));
end UsersGuide;
