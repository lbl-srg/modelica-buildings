within Buildings.Fluid.FMI.Interfaces;
connector FluidProperties "Type definition for fluid properties"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model" annotation (choicesAllMatching=true);

  Medium.Temperature T "Temperature";
  Buildings.Fluid.FMI.Interfaces.MassFractionConnector X_w if
       Medium.nXi > 0 "Water vapor mass fractions per kg total air";
  Medium.ExtraProperty C[Medium.nC] "Properties c_i/m";

  annotation (Documentation(info="<html>
<p>
This is a connector that declares the following fluid properties:
</p>
<ul>
<li>
The temperature <code>T</code>.
</li>
<li>
The mass fraction of water vapor <code>X_w</code> per kg of total air,
unless <code>Medium.nXi=0</code>.
Note that the mass fraction is not per kg of dry air, but rather
per kg of total air as is customary in Modelica.
</li>
<li>
The trace substances
<code>C</code>, 
unless <code>Medium.nC=0</code>.
</li>
</ul>
<p>
These quantities are used in the connectors
<a href=\"modelica://Buildings.Fluid.FMI.Interfaces.Inlet\">
Buildings.Fluid.FMI.Interfaces.Inlet</a>
and
<a href=\"modelica://Buildings.Fluid.FMI.Interfaces.Outlet\">
Buildings.Fluid.FMI.Interfaces.Outlet</a>.
</p>
<p>
Note that none of these quantities is declared to be an
<code>input</code> or <code>output</code>, because the role
is reversed whether the properties are in inlet or
outlet connector.
</p>
</html>", revisions="<html>
<ul>
<li>
April 15, 2015 by Michael Wetter:<br/>
Changed connector variable to be temperature instead of
specific enthalpy.
</li>
<li>
November 8, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FluidProperties;
