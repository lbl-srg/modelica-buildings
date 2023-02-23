within Buildings.Fluid.Storage.PCM.BaseClasses;
function SOC
  "this function calculates state of charge for a PCM heat exchanger"
  input Modelica.Units.SI.Energy Upcm "Current internal energy of PCM";
  input Modelica.Units.SI.Mass mpcm "Mass of PCM";
  input Modelica.Units.SI.Temperature TSol "Solidus temperature of PCM";
  input Modelica.Units.SI.SpecificHeatCapacity cSol "Specific heat capacity of solid PCM";
  input Modelica.Units.SI.SpecificInternalEnergy LHea "Latent heat of phase change";
  output Modelica.Units.SI.StoichiometricNumber SOC "State of charge of PCM";
protected
  Real Uf_ref;
  Real Ug_ref;
  Real Ufg;
algorithm
  Uf_ref := mpcm*cSol*(TSol);
  Ufg := mpcm*LHea;
  Ug_ref := Uf_ref+Ufg;
  if TSol >= 20+273.15 then
    SOC := (Upcm-Uf_ref)/Ufg;
  elseif TSol < 20+273.15 then
    SOC := (Ug_ref-Upcm)/Ufg;
  end if;
end SOC;
