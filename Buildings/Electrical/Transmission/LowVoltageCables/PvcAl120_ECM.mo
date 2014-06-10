within Buildings.Electrical.Transmission.LowVoltageCables;
record PvcAl120_ECM "Aluminum cable 120mm^2"
    extends Buildings.Electrical.Transmission.LowVoltageCables.Cable(
    material=Types.Material.Al,
    RCha=0.278e-003,
    XCha=0.071e-003);
end PvcAl120_ECM;
