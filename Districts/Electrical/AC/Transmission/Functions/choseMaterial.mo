within Districts.Electrical.AC.Transmission.Functions;
function choseMaterial
  input Real x;
  output Districts.Electrical.AC.Transmission.Materials.Material material;
protected
  Districts.Electrical.AC.Transmission.Materials.Copper Cu;
  Districts.Electrical.AC.Transmission.Materials.Copper Ag;
  Districts.Electrical.AC.Transmission.Materials.Copper Al;
  Districts.Electrical.AC.Transmission.Materials.Copper Pt;
algorithm
  // Chose the material
  if x >= 0 and x < 1 then
    material := Cu;
  elseif x >= 1 and x < 2 then
    material := Ag;
  elseif x >= 2 and x < 3 then
    material := Al;
  else
    material := Pt;
  end if;

end choseMaterial;
