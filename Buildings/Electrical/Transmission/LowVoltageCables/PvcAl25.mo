within Buildings.Electrical.Transmission.LowVoltageCables;
record PvcAl25 "Aluminum cable 25 mm^2"
  extends Buildings.Electrical.Transmission.LowVoltageCables.Cable(
    material=Materials.Material.Al,
    RCha=1.292e-003,
    XCha=0.075e-003);
end PvcAl25;
