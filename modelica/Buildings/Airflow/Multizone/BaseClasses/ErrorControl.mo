within Buildings.Airflow.Multizone.BaseClasses;
model ErrorControl "Interface that defines parameters for error control"
public
  parameter Boolean forceErrorControlOnFlow = true
    "Flag to force error control on m_flow. Set to true if interested in flow rate";
  annotation (Diagram(graphics),
                       Icon(graphics),
Documentation(info="<html>
<p>
This is an interface that defines parameters used for error control.
<p>
Dymola does error control on state variables, such as temperature, pressure and 
species concentration.
Flow variables such as <code>m_flow</code> are typically not checked during the error control. 
This can give large errors in flow variables, as long as the error on the volume's state variables
that are coupled to the flow variables is small. 
Obtaining accurate flow variables can be achieved by imposing an error control
on the exchanged mass, which can be defined as 
<pre>
  dm/dt = m_flow.
</pre>
By setting <code>enforceErrorControlOnFlow = true</code>, such an equation is imposed
by models that extend this class.

<h3>Main Author</h3>
<P>
    Michael Wetter<br>
    <a href=\"http://www.utrc.utc.com\">United Technologies Research Center</a><br>
    411 Silver Lane<br>
    East Hartford, CT 06108<br>
    USA<br>
    email: <A HREF=\"mailto:WetterM@utrc.utc.com\">WetterM@utrc.utc.com</A>
<h3>Release Notes</h3>
<P>
<ul>
<li><i>November 1, 2005</i> by Michael Wetter:<br>
       Released first version.
</ul>
</html>"));
end ErrorControl;
