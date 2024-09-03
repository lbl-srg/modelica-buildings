within Buildings.Fluid.FMI.Interfaces;
connector FluidProperties "Type definition for fluid properties"
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));


  Medium.Temperature T "Temperature";
  Buildings.Fluid.FMI.Interfaces.MassFractionConnector X_w
    if Medium.nXi > 0 "Water vapor mass fractions per kg total air";
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
January 18, 2019, by Jianjun Hu:<br/>
Limited the media choice.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">#1050</a>.
</li>
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
