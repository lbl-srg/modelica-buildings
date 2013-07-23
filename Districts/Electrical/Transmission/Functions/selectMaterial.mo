within Districts.Electrical.Transmission.Functions;
function selectMaterial
  input Real x;
  output Districts.Electrical.Transmission.Materials.Material material;
protected
  Districts.Electrical.Transmission.Materials.Copper Cu;
  Districts.Electrical.Transmission.Materials.Copper Ag;
  Districts.Electrical.Transmission.Materials.Copper Al;
  Districts.Electrical.Transmission.Materials.Copper Pt;
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

end selectMaterial;
