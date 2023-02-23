within Buildings.Fluid.Storage.PCM.BaseClasses;
function Ufg
  "this function calculates the capacity of a PCM heat exchanger"
  input Modelica.Units.SI.Mass mpcm "Mass of PCM";
  input Modelica.Units.SI.SpecificInternalEnergy LHea "Latent heat of phase change";
  output Modelica.Units.SI.Energy Ufg "Latent capacity of PCM heat exchanger";
algorithm
  Ufg := mpcm*LHea;
end Ufg;
