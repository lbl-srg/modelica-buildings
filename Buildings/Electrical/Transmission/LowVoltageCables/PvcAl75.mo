within Buildings.Electrical.Transmission.LowVoltageCables;
record PvcAl75 "Aluminum cable 75mm^2"
  extends Buildings.Electrical.Transmission.LowVoltageCables.Cable(
    material=Types.Material.Al,
    RCha=0.431e-003,
    XCha=0.072e-003);
end PvcAl75;
