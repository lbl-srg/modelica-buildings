within Buildings.Electrical.Transmission.LowVoltageCables;
record PvcAl16_ECM "Aluminum cable 16 mm^2"
    extends Buildings.Electrical.Transmission.LowVoltageCables.Generic(
    material=Types.Material.Al,
    RCha=2.105e-003,
    XCha=0.076e-003);
end PvcAl16_ECM;
