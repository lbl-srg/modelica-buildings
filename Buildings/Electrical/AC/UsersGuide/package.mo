within Buildings.Electrical.AC;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

    annotation (preferredView="info",
Documentation(info="<html>
<p>
The package 
<a href=\"modelica://Buildings.Electrical.AC\">Buildings.Electrical.AC</a>
models alternate current (AC) electrical systems.
</p>

<h4>Modeling assumptions</h4>
<p>
The AC models that are part of the library have the ability to use two different
assumptions:
</p>
<p>
The first assumption is that the frequency is modeled as quasi-stationary, 
assuming a perfect sine wave with no higher harmonics. Voltages and currents are considered as 
sine waves and just their amplitudes and phase shifts are taken into account during the analysis.
With such an assumption, the electric quantities can be represented with phasors, e.g., vectors
with a given length and angle. Such a mathematical representation is used to describes the sine waves.
</p>
<p>
The second assumption is the so-called dynamic phasorial representation.
The basic idea behind the dynamic phasorial representation is to account for dynamic variations of the amplitude
and the angle of the phasors. This allows to analyze faster dynamics without
directly representing all the electromagnetic effects and performing a continuous time simulation using first
principle models. 
</p>

<h4>Phasorial representation</h4>
<p>
The models contained in this package use the phasorial representation of voltages, currents and powers.
Each of the electric quantities is represented by a complex number that internally is represented as a vector
with two components. Those vectors can be represented in the so called Argand plane where on the x-axis
are the real numbers and on the y-axis are the imaginary numbers.  
</p>
<p>
With such a representation, the complex voltages, currents, and powers are represented as
</p>
<p align=\"center\" style=\"font-style:italic;\">
<span style=\"text-decoration: overline;\">V</span> = V<sub>Re</sub> + j V<sub>Im</sub>,
</p>
<p align=\"center\" style=\"font-style:italic;\">
<span style=\"text-decoration: overline;\">I</span> = I<sub>Re</sub> + j I<sub>Im</sub>,
</p>
<p align=\"center\" style=\"font-style:italic;\">
<span style=\"text-decoration: overline;\">S</span> = P + j Q.
</p>

<p>
The images below shows how the complex power vector <i><span style=\"text-decoration: overline;\">S</span></i>
changes depending on the type of load.  
</p>

<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/OnePhase/ComplexPower.png\"/>
</p>

<p>
The subscripts in the figure indicate:
</p>
<p>
<ul>
<li><i>R</i> - purely resistive load</li>
<li><i>L</i> - purely inductive load</li>
<li><i>C</i> - purely capacitive load</li>
<li><i>RL</i> - resistive inductive load</li>
<li><i>RC</i> - resistive capacitive load</li>
</ul>
</p>

<h4>Dynamic phasorial representation</h4>
<p>
More details about the dynamic phasorial representation can be found in <a href=\"#Stankovi1999\">Stankovi Et Al. 1999</a>.
</p>

<h4>References</h4>
<p>
<a NAME=\"Stankovi1999\"/>
A.M. Stankovi, B.C. Lesieutre, T. Aydin.<br/>
<a href=\"http://www.ece.neu.edu/faculty/stankovic/Jour_papers/pwrs299im.pdf\">
<i>IEEE Transactions on Power Systems</i>, 14(1), Feb. 1999, pp. 9-14.<br/>
</p>

</html>"));
end UsersGuide;
