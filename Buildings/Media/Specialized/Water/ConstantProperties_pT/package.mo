within Buildings.Media.Specialized.Water;
package ConstantProperties_pT "Package with model for liquid water with constant properties at user-provided nominal conditions"

  extends Buildings.Media.Water(
    mediumName="ConstantPropertyWater(p="+String(p_nominal)+",T="+String(T_nominal)+")",
    p_default=p_nominal,
    reference_p=p_nominal,
    cp_const=cp_nominal,
    d_const=d_nominal,
    eta_const=eta_nominal,
    lambda_const=lambda_nominal,
    a_const=a_nominal,
    T_max=T_max_nominal);

constant Modelica.Units.SI.Temperature T_max_nominal=
    Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.tsat(p_nominal)
  "Maximum temperature valid for medium model";

constant Modelica.Units.SI.Temperature T_nominal=273.15 + 20
  "Nominal temperature for calculation of water properties";

constant Modelica.Units.SI.VelocityOfSound a_nominal=
    Modelica.Media.Water.IF97_Utilities.velocityOfSound_pT(p_nominal, T_nominal)
  "Constant velocity of sound";

constant Modelica.Units.SI.SpecificHeatCapacity cp_nominal=
    Modelica.Media.Water.IF97_Utilities.cp_pT(p_nominal, T_nominal)
  "Specific heat capacity at nominal water conditions";

constant Modelica.Units.SI.Density d_nominal=
    Modelica.Media.Water.IF97_Utilities.rho_pT(p_nominal, T_nominal)
  "Density at nominal water conditions";

constant Modelica.Units.SI.DynamicViscosity eta_nominal=
    Modelica.Media.Water.IF97_Utilities.dynamicViscosity(
    d_nominal,
    T_nominal,
    p_nominal) "Constant dynamic viscosity";

constant Modelica.Units.SI.ThermalConductivity lambda_nominal=
    Modelica.Media.Water.IF97_Utilities.thermalConductivity(
    d_nominal,
    T_nominal,
    p_nominal) "Constant thermal conductivity";

constant Modelica.Units.SI.AbsolutePressure p_nominal=101325
  "Nominal pressure for calculation of water properties";

annotation (Documentation(info="<html>
<p>
Model for liquid water with constant properties at given nominal conditions.
</p>
<p>
This water model is similar to
<a href=\"modelica://Buildings.Media.Water\">Buildings.Media.Water</a> with regard to its
complexity. It also uses constant values for properties such as density and
specific heat capacity. The main difference is that the constants <code>T_nominal</code>
and <code>p_nominal</code> allow for user-provided nominal condition of the water model. The
constant properties will be derived for this nominal condition. The maximum
allowed temperature is set at the saturation temperature for the given nominal
pressure <code>p_nominal</code>.
</p>
<h4>Assumptions and limitations</h4>
<p>
The nominal values for the constant medium properties are calculated using the
<a href=\"modelica://Modelica.Media.Water.WaterIF97_base\">Modelica.Media.Water.WaterIF97_base</a>
model.
</p>
<h4>Typical use and important parameters</h4>
<p>A model using this medium model can set the nominal conditions e.g. by defining</p>
<pre>
  package Medium = Buildings.Media.Specialized.Water.ConstantProperties_pT(
    T_nominal=273.15+100,
    p_nominal=5e5);
</pre>
</html>", revisions="<html>
<ul>
<li>
September 20, 2016, by Michael Wetter:<br/>
Reordered constants to conform with the order in <code>package.order</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/518\">issue 518</a>.
</li>
<li>
September 14, 2016, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
September 8, 2016, by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Polygon(
          points={{16,-28},{32,-42},{26,-48},{10,-36},{16,-28}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Polygon(
          points={{10,34},{26,44},{30,36},{14,26},{10,34}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Ellipse(
          extent={{-82,52},{24,-54}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Sphere,
          fillColor={0,0,0}),
        Ellipse(
          extent={{22,82},{80,24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Ellipse(
          extent={{20,-30},{78,-88}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Text(
          extent={{-110,40},{50,-36}},
          textColor={238,46,47},
          textString="pT")}));
end ConstantProperties_pT;
