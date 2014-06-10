within Buildings.Electrical.Transmission.LowVoltageCables;
record PvcAl95 "Aluminum cable 95mm^2"
  extends Buildings.Electrical.Transmission.LowVoltageCables.Cable(
    material=Types.Material.Al,
    RCha=0.320e-003,
    XCha=0.072e-003);
end PvcAl95;
