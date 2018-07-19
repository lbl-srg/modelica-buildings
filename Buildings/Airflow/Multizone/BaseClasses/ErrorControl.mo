within Buildings.Airflow.Multizone.BaseClasses;
model ErrorControl "Interface that defines parameters for error control"
  parameter Boolean forceErrorControlOnFlow = true
    "Flag to force error control on m_flow. Set to true if interested in flow rate"
    annotation(Dialog(tab="Advanced"));

  annotation (Documentation(info="<html>
<p>
This is an interface that defines parameters used for error control.
</p>
<p>
Dymola does error control on state variables, such as temperature, pressure and
species concentration.
Flow variables such as <code>m_flow</code> are typically not checked during the error control.
This can give large errors in flow variables, as long as the error on the volume's state variables
that are coupled to the flow variables is small.
Obtaining accurate flow variables can be achieved by imposing an error control
on the exchanged mass, which can be defined as
</p>
<pre>
  dm/dt = m_flow.
</pre>
<p>
By setting <code>forceErrorControlOnFlow = true</code>, such an equation is imposed
by models that extend this class.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 27, 2018, by Michael Wetter:<br/>
Moved parameter <code>forceErrorControlOnFlow</code> to the Advanced tab.
</li>
<li>
July 20, 2010 by Michael Wetter:<br/>
Integrated model into the Buildings library.
</li>
<li>
November 1, 2005 by Michael Wetter:<br/>
Released first version.
</li>
</ul>
</html>"));
end ErrorControl;
