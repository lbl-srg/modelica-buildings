within Buildings.Electrical.Transmission.LowVoltageCables;
record PvcAl50 "Aluminum cable 50 mm^2"
  extends Buildings.Electrical.Transmission.LowVoltageCables.Cable(
    material=Materials.Material.Al,
    RCha=0.641e-003,
    XCha=0.073e-003);
end PvcAl50;
