within Buildings.Airflow.Multizone.BaseClasses;
model ErrorControl "Interface that defines parameters for error control"
  parameter Boolean forceErrorControlOnFlow = true
    "Flag to force error control on m_flow. Set to true if interested in flow rate";
  annotation (Documentation(info="<html>
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
</html>",
revisions="<html>
<ul>
<li><i>July 20, 2010</i> by Michael Wetter:<br/>
       Integrated model into the Buildings library.
</li>
<li><i>November 1, 2005</i> by Michael Wetter:<br/>
       Released first version.
</ul>
</html>"));
end ErrorControl;
