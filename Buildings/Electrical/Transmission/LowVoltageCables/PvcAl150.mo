within Buildings.Electrical.Transmission.LowVoltageCables;
record PvcAl150 "Aluminum cable 150mm^2"
  extends Buildings.Electrical.Transmission.LowVoltageCables.Cable(
    material=Materials.Material.Al,
    RCha=0.206e-003,
    XCha=0.070e-003);
end PvcAl150;
