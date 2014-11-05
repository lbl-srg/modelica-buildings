within Buildings.Fluid.FMI.Interfaces;
connector FluidProperties "Type definition for fluid properties"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model" annotation (choicesAllMatching=true);

  Medium.SpecificEnthalpy h "Specific thermodynamic enthalpy";
  Medium.MassFraction Xi[Medium.nXi] "Independent mixture mass fractions m_i/m";
  Medium.ExtraProperty C[Medium.nC] "Properties c_i/m";

end FluidProperties;
