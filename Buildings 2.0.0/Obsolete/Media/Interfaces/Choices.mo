within Buildings.Obsolete.Media.Interfaces;
package Choices "Types, constants to define menu choices"

  type IndependentVariables = enumeration(
      T "Temperature",
      pT "Pressure, Temperature",
      ph "Pressure, Specific Enthalpy",
      phX "Pressure, Specific Enthalpy, Mass Fraction",
      pTX "Pressure, Temperature, Mass Fractions",
      dTX "Density, Temperature, Mass Fractions")
    "Enumeration defining the independent variables of a medium";

  type Init = enumeration(
      NoInit "NoInit (no initialization)",
      InitialStates "InitialStates (initialize medium states)",
      SteadyState "SteadyState (initialize in steady state)",
      SteadyMass "SteadyMass (initialize density or pressure in steady state)")
    "Enumeration defining initialization for fluid flow"
            annotation (Evaluate=true);

  type ReferenceEnthalpy = enumeration(
      ZeroAt0K
        "The enthalpy is 0 at 0 K (default), if the enthalpy of formation is excluded",

      ZeroAt25C
        "The enthalpy is 0 at 25 degC, if the enthalpy of formation is excluded",

      UserDefined
        "The user-defined reference enthalpy is used at 293.15 K (25 degC)")
    "Enumeration defining the reference enthalpy of a medium"
      annotation (Evaluate=true);

  type ReferenceEntropy = enumeration(
      ZeroAt0K "The entropy is 0 at 0 K (default)",
      ZeroAt0C "The entropy is 0 at 0 degC",
      UserDefined
        "The user-defined reference entropy is used at 293.15 K (25 degC)")
    "Enumeration defining the reference entropy of a medium"
      annotation (Evaluate=true);

  type pd = enumeration(
      default "Default (no boundary condition for p or d)",
      p_known "p_known (pressure p is known)",
      d_known "d_known (density d is known)")
    "Enumeration defining whether p or d are known for the boundary condition"
      annotation (Evaluate=true);

  type Th = enumeration(
      default "Default (no boundary condition for T or h)",
      T_known "T_known (temperature T is known)",
      h_known "h_known (specific enthalpy h is known)")
    "Enumeration defining whether T or h are known as boundary condition"
      annotation (Evaluate=true);

  annotation (Documentation(info="<html>
<p>
Enumerations and data types for all types of fluids
</p>

<p>
Note: Reference enthalpy might have to be extended with enthalpy of formation.
</p>
<h4>Implementation</h4>
<p>
This package is a copy from the Modelica Standard Library (MSL) because
MSL 3.2 stores this package in
<code>Modelica.Media.Interfaces.PartialMedium.Choices</code>, whereas
MSL 3.2.1 stores it in
<code>Modelica.Media.Interfaces.Choices</code> because enumerations
cannot be done through a partial package.
The local copy has done to enable compatibility with both versions.
</p>
</html>", revisions="<html>
<ul>
<li>
April 17, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Choices;
