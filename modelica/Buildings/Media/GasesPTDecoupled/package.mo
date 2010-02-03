within Buildings.Media;
package GasesPTDecoupled "Package with models for gases where pressure and temperature are independent of each other"
  annotation (preferedView="info", Documentation(info="<HTML>
<p>
Medium models in this package use the gas law
<tt>d/dStp = p/pStp</tt> where 
<tt>pStd</tt> and <tt>dStp</tt> are constants for a reference
temperature and density instead of the ideal gas law
<tt>d = p/(R*T)</tt>.
</p>
<p>
This new formulation often leads to smaller systems of nonlinear equations 
because pressure and temperature are decoupled, at the expense of accuracy.
</p>
</HTML>", revisions="<html>
<ul>
<li>
March 19, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

end GasesPTDecoupled;
