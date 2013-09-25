within Districts.Electrical.Transmission.Functions;
function selectCable
  input Districts.Electrical.Transmission.Materials.Material  wireMaterial
    "Wire material";
  input Modelica.SIunits.Power P_nominal "Rated power";
  input Modelica.SIunits.Voltage V_nominal "Rated voltage";
  output Districts.Electrical.Transmission.CommercialCables.Cable cable "Cable";
protected
  Modelica.SIunits.Current I_nominal = P_nominal/V_nominal
    "Nominal current flowing through the line";
  parameter Real I_mm2 = 4 "Current density A/mm2";
  // List of commercial cables available in the library
  Districts.Electrical.Transmission.CommercialCables.PvcAl16 pvcAl16;
  Districts.Electrical.Transmission.CommercialCables.PvcAl25 pvcAl25;
  Districts.Electrical.Transmission.CommercialCables.PvcAl35 pvcAl35;
  Districts.Electrical.Transmission.CommercialCables.PvcAl50 pvcAl50;
  Districts.Electrical.Transmission.CommercialCables.PvcAl70 pvcAl70;
  Districts.Electrical.Transmission.CommercialCables.PvcAl75 pvcAl75;
  Districts.Electrical.Transmission.CommercialCables.PvcAl95 pvcAl95;
  Districts.Electrical.Transmission.CommercialCables.PvcAl120 pvcAl120;
  Districts.Electrical.Transmission.CommercialCables.PvcAl150 pvcAl150;
  Districts.Electrical.Transmission.CommercialCables.Cu10 cu10;
  Districts.Electrical.Transmission.CommercialCables.Cu10 cu20;
  Districts.Electrical.Transmission.CommercialCables.Cu10 cu25;
  Districts.Electrical.Transmission.CommercialCables.Cu10 cu35;
  Districts.Electrical.Transmission.CommercialCables.Cu10 cu50;
  Districts.Electrical.Transmission.CommercialCables.Cu10 cu95;
  Districts.Electrical.Transmission.CommercialCables.Cu10 cu100;
algorithm

  if wireMaterial == Districts.Electrical.Transmission.Materials.Material.Al then
      // The material is Aluminium
      if I_nominal*I_mm2 < 16 then
        cable := pvcAl16;
      elseif I_nominal*I_mm2>=16 and I_nominal*I_mm2 <25 then
        cable := pvcAl25;
      elseif I_nominal*I_mm2>=25 and I_nominal*I_mm2 <35 then
        cable := pvcAl35;
      elseif I_nominal*I_mm2>=35 and I_nominal*I_mm2 <50 then
        cable := pvcAl50;
      elseif I_nominal*I_mm2>=50 and I_nominal*I_mm2 <70 then
        cable := pvcAl70;
      elseif I_nominal*I_mm2>=70 and I_nominal*I_mm2 <75 then
        cable := pvcAl75;
      elseif I_nominal*I_mm2>=75 and I_nominal*I_mm2 <95 then
        cable := pvcAl95;
      elseif I_nominal*I_mm2>=95 and I_nominal*I_mm2 <120 then
        cable := pvcAl120;
      elseif I_nominal*I_mm2>=120 and I_nominal*I_mm2 <150 then
        cable := pvcAl150;
      else
        Modelica.Utilities.Streams.print("Warning: Cable autosizing does not support a current of " +
        String(I_nominal) + " A.
  The selected cable will be undersized.");
        cable := pvcAl150;
      end if;

    else

      // The material is Copper
      if I_nominal*I_mm2 < 10 then
        cable := cu10;
      elseif I_nominal*I_mm2>=10 and I_nominal*I_mm2 <20 then
        cable := cu20;
      elseif I_nominal*I_mm2>=20 and I_nominal*I_mm2 <25 then
        cable := cu25;
      elseif I_nominal*I_mm2>=25 and I_nominal*I_mm2 <35 then
        cable := cu35;
      elseif I_nominal*I_mm2>=35 and I_nominal*I_mm2 <50 then
        cable := cu50;
      elseif I_nominal*I_mm2>=50 and I_nominal*I_mm2 <95 then
        cable := cu95;
      elseif I_nominal*I_mm2>=95 and I_nominal*I_mm2 <100 then
        cable := cu100;
      else
        Modelica.Utilities.Streams.print("Warning: Cable autosizing does not support a current of " +
        String(I_nominal) + " A.
  The selected cable will be undersized.");
        cable := cu100;
      end if;

    end if;

end selectCable;
