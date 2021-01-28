within Buildings.Media.Interfaces;
partial package PartialPureSubstanceWithSaturation "Partial pure substance model with saturation state functions"
  extends Modelica.Media.Interfaces.PartialPureSubstance;

  replaceable partial function densityOfSaturatedLiquid
       "Return density of saturated liquid"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output Density dl "Boiling curve density";
  end densityOfSaturatedLiquid;

  replaceable partial function densityOfSaturatedVapor
    "Return density of saturated vapor"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output Density dv "Dew curve density";
  end densityOfSaturatedVapor;

  replaceable partial function enthalpyOfSaturatedLiquid
    "Return enthalpy of saturated liquid"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEnthalpy hl "Boiling curve specific enthalpy";
  end enthalpyOfSaturatedLiquid;

  replaceable partial function enthalpyOfSaturatedVapor
    "Return enthalpy of saturated vapor"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEnthalpy hv "Dew curve specific enthalpy";
  end enthalpyOfSaturatedVapor;

  replaceable partial function enthalpyOfVaporization
    "Return enthalpy of vaporization"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEnthalpy hlv "Vaporization enthalpy";
  end enthalpyOfVaporization;

  replaceable partial function entropyOfSaturatedLiquid
    "Return entropy of saturated liquid"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEntropy sl "Boiling curve specific entropy";
  end entropyOfSaturatedLiquid;

  replaceable partial function entropyOfSaturatedVapor
    "Return entropy of saturated vapor"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEntropy sv "Dew curve specific entropy";
  end entropyOfSaturatedVapor;

  replaceable partial function entropyOfVaporization
    "Return entropy of vaporization"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEntropy slv "Vaporization entropy";
  end entropyOfVaporization;

  replaceable partial function saturationState
    "Return saturation property record from pressure"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    output SaturationProperties sat "Saturation property record";
  end saturationState;

  replaceable partial function saturationTemperature
    "Return saturation temperature"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    output Temperature T "Saturation temperature";
  end saturationTemperature;

  annotation (Documentation(revisions="<html>
<ul>
<li>
May 6, 2020, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p><b><span style=\"font-size: 11pt; color: #ee2e2f;\">This model is a 
beta version and is not fully validated yet. </span></b></p>
<p>This interface model extends 
<a href=\"modelica://Modelica.Media.Interfaces.PartialPureSubstance\">Modelica.Media.Interfaces.PartialPureSubstance</a> 
and includes functions for calculating saturation properties of fluid 
media. It is implemented in models requiring fluid phase change and 
when saturation properties are of primary interest, such as with 
<a href=\"modelica://Buildings.Media.Steam\">Buildings.Media.Steam</a>. </p>
</html>"));
end PartialPureSubstanceWithSaturation;
