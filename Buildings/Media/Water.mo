within Buildings.Media;
package Water "Package with model for liquid water with constant density"
   extends Modelica.Media.Water.ConstantPropertyLiquidWater(
     p_default=300000,
     reference_p=300000,
     reference_T=273.15,
     reference_X={1},
     AbsolutePressure(start=p_default),
     Temperature(start=T_default),
     Density(start=d_const),
     final cv_const=cp_const);
  // cp_const and cv_const have been made final because the model sets u=h.
  extends Modelica.Icons.Package;

  redeclare replaceable model BaseProperties "Base properties (p, d, T, h, u, R, MM and X and Xi) of a medium"
    parameter Boolean preferredMediumStates=false
      "= true if StateSelect.prefer shall be used for the independent property variables of the medium"
      annotation (Evaluate=true, Dialog(tab="Advanced"));
    final parameter Boolean standardOrderComponents=true
      "If true, and reducedX = true, the last element of X will be computed from the other ones";
    Modelica.SIunits.Density d=d_const "Density of medium";
    Temperature T(stateSelect=
      if preferredMediumStates then StateSelect.prefer else StateSelect.default)
      "Temperature of medium";
    InputAbsolutePressure p "Absolute pressure of medium";
    InputMassFraction[nXi] Xi=fill(0, 0)
      "Structurally independent mass fractions";
    InputSpecificEnthalpy h "Specific enthalpy of medium";
    Modelica.SIunits.SpecificInternalEnergy u
      "Specific internal energy of medium";

    Modelica.SIunits.MassFraction[nX] X={1}
      "Mass fractions (= (component mass)/total mass  m_i/m)";
    final Modelica.SIunits.SpecificHeatCapacity R=0
      "Gas constant (of mixture if applicable)";
    final Modelica.SIunits.MolarMass MM=MM_const
      "Molar mass (of mixture or single fluid)";
    ThermodynamicState state
      "Thermodynamic state record for optional functions";


    Modelica.SIunits.Conversions.NonSIunits.Temperature_degC T_degC=
        Modelica.SIunits.Conversions.to_degC(T)
      "Temperature of medium in [degC]";
    Modelica.SIunits.Conversions.NonSIunits.Pressure_bar p_bar=
        Modelica.SIunits.Conversions.to_bar(p)
      "Absolute pressure of medium in [bar]";

    // Local connector definition, used for equation balancing check
    connector InputAbsolutePressure = input Modelica.SIunits.AbsolutePressure
      "Pressure as input signal connector";
    connector InputSpecificEnthalpy = input Modelica.SIunits.SpecificEnthalpy
      "Specific enthalpy as input signal connector";
    connector InputMassFraction = input Modelica.SIunits.MassFraction
      "Mass fraction as input signal connector";

  equation
    h = cp_const*(T-reference_T);
    u = h;
    state.T = T;
    state.p = p;

    // Assertions to test for bounds
    assert(noEvent(T >= T_min), "In " + getInstanceName() + ": Temperature T = " + String(T) + " K exceeded its minimum allowed value of " +
  String(T_min-273.15) + " degC (" + String(T_min) + " Kelvin) as required from medium model \"Buildings.Media.Water\".");

    assert(noEvent(T <= T_max), "In " + getInstanceName() + ": Temperature T = " + String(T) + " K exceeded its maximum allowed value of " +
  String(T_max-273.15) + " degC (" + String(T_max) + " Kelvin) as required from medium model \"Buildings.Media.Water\".");

    assert(noEvent(p >= 0.0), "Pressure (= " + String(p) + " Pa) of medium \"Buildings.Media.Water\" is negative\n(Temperature = " + String(T) + " K)");

    annotation(Documentation(info="<html>
<p>
Model with basic thermodynamic properties.
</p>
<p>
This base properties model is identical to
<a href=\"modelica://Modelica.Media.Water.ConstantPropertyLiquidWater\">
Modelica.Media.Water.ConstantPropertyLiquidWater</a>,
except that the equation
<code>u = cv_const*(T - reference_T)</code>
has been replaced by <code>u=h</code> because
<code>cp_const=cv_const</code>.
</p>
<p>
This model provides equation for the following thermodynamic properties:
</p>
<table border=1 cellspacing=0 cellpadding=2 summary=\"Thermodynamic properties\">
  <tr><td><strong>Variable</strong></td>
      <td><strong>Unit</strong></td>
      <td><strong>Description</strong></td></tr>
  <tr><td>T</td>
      <td>K</td>
      <td>temperature</td></tr>
  <tr><td>p</td>
      <td>Pa</td>
      <td>absolute pressure</td></tr>
  <tr><td>d</td>
      <td>kg/m3</td>
      <td>density</td></tr>
  <tr><td>h</td>
      <td>J/kg</td>
      <td>specific enthalpy</td></tr>
  <tr><td>u</td>
      <td>J/kg</td>
      <td>specific internal energy</td></tr>
  <tr><td>Xi[nXi]</td>
      <td>kg/kg</td>
      <td>independent mass fractions m_i/m</td></tr>
  <tr><td>R</td>
      <td>J/kg.K</td>
      <td>gas constant</td></tr>
  <tr><td>M</td>
      <td>kg/mol</td>
      <td>molar mass</td></tr>
</table>
</html>"));
  end BaseProperties;

function enthalpyOfLiquid "Return the specific enthalpy of liquid"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature";
  output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
algorithm
  h := cp_const*(T-reference_T);
annotation (
  smoothOrder=5,
  Inline=true,
Documentation(info="<html>
<p>
Enthalpy of the water.
</p>
</html>", revisions="<html>
<ul>
<li>
October 16, 2014 by Michael Wetter:<br/>
First implementation.
This function is used by
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir\">
Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir</a>.
</li>
</ul>
</html>"));
end enthalpyOfLiquid;
  annotation(Documentation(info="<html>
<p>
This medium package models liquid water.
</p>
<p>
The mass density is computed using a constant value of <i>995.586</i> kg/s.
For a medium model in which the density is a function of temperature, use
<a href=\"modelica://Buildings.Media.Specialized.Water.TemperatureDependentDensity\">
Buildings.Media.Specialized.Water.TemperatureDependentDensity</a> which may have considerably higher computing time.
</p>
<p>
For the specific heat capacities at constant pressure and at constant volume,
a constant value of <i>4184</i> J/(kg K), which corresponds to <i>20</i>&deg;C
is used.
The figure below shows the relative error of the specific heat capacity that
is introduced by this simplification.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Media/Water/plotCp.png\" border=\"1\"
alt=\"Relative variation of specific heat capacity with temperature\"/>
</p>
<p>
The enthalpy is computed using the convention that <i>h=0</i>
if <i>T=0</i> &deg;C.
</p>
<h4>Limitations</h4>
<p>
Density, specific heat capacity, thermal conductivity and viscosity are constant.
Water is modeled as an incompressible liquid.
There are no phase changes.
</p>
</html>", revisions="<html>
<ul>
<li>
September 28, 2020, by Michael Wetter:<br/>
Reformulated <code>BaseProperties</code> to avoid event-triggering assertions.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1401\">#1401</a>.
</li>
<li>
October 26, 2018, by Filip Jorissen and Michael Wetter:<br/>
Now printing different messages if temperature is above or below its limit,
and adding instance name as JModelica does not print the full instance name in the assertion.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1045\">#1045</a>.
</li>
<li>
June 6, 2015, by Michael Wetter:<br/>
Set <code>AbsolutePressure(start=p_default)</code> to avoid
a translation error if
<a href=\"modelica://Buildings.Fluid.Sources.Examples.TraceSubstancesFlowSource\">
Buildings.Fluid.Sources.Examples.TraceSubstancesFlowSource</a>
(if used with water instead of air)
is translated in pedantic mode in Dymola 2016.
The reason is that pressures use <code>Medium.p_default</code> as start values,
but
<a href=\"modelica://Modelica.Media.Interfaces.Types\">
Modelica.Media.Interfaces.Types</a>
sets a default value of <i>1E-5</i>.
A similar change has been done for pressure and density.
This fixes
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/266\">#266</a>.
</li>
<li>
June 6, 2015, by Michael Wetter:<br/>
Changed type of <code>BaseProperties.T</code> from
<code>Modelica.SIunits.Temperature</code> to <code>Temperature</code>.
Otherwise, it has a different start value than <code>Medium.T</code>, which
causes an error if
<a href=\"Buildings.Media.Examples.WaterProperties\">
Buildings.Media.Examples.WaterProperties</a>
is translated in pedantic mode.
This fixes
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/266\">#266</a>.
</li>
<li>
June 5, 2015, by Michael Wetter:<br/>
Added <code>stateSelect</code> attribute in <code>BaseProperties.T</code>
to allow correct use of <code>preferredMediumState</code> as
described in
<a href=\"modelica://Modelica.Media.Interfaces.PartialMedium\">
Modelica.Media.Interfaces.PartialMedium</a>,
and set <code>preferredMediumState=false</code>
to keep the same states as were used before.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/260\">#260</a>.
</li>
<li>
June 5, 2015, by Michael Wetter:<br/>
Removed <code>ThermodynamicState</code> declaration as this lead to
the error
\"Attempting to redeclare record ThermodynamicState when the original was not replaceable.\"
in Dymola 2016 using the pedantic model check.
</li>
<li>
May 1, 2015, by Michael Wetter:<br/>
Added <code>Inline=true</code> for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/227\">
issue 227</a>.
</li>
<li>
February 25, 2015, by Michael Wetter:<br/>
Removed <code>stateSelect</code> attribute on pressure as this caused
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3</a>
to fail with the error message
\"differentiated if-then-else was not continuous\".
</li>
<li>
October 15, 2014, by Michael Wetter:<br/>
Reimplemented media based on
<a href=\"https://github.com/ibpsa/modelica-ibpsa/blob/446aa83720884052476ad6d6d4f90a6a29bb8ec9/Buildings/Media/Water.mo\">446aa83</a>.
</li>
<li>
November 15, 2013, by Michael Wetter:<br/>
Complete new reimplementation because the previous version
had the option to add a compressibility to the medium, which
has never been used.
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
          fillColor={95,95,95})}));
end Water;
