within Buildings.Media;
package GasesConstantDensity "Package with models for gases where pressure and temperature are independent of each other"


  annotation (preferedView="info", Documentation(info="<HTML>
<p>
Medium models in this package use a constant mass density.
<p>
The use of a constant density avoids having pressure as a state variable in mixing volumes. Hence, fast transients
introduced by a change in pressure are avoided. 
The drawback is that the dimensionality of the coupled
nonlinear equation system is typically larger for flow
networks.
</p>
</HTML>", revisions="<html>
<ul>
<li>
March 19, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end GasesConstantDensity;
