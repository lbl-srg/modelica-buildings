within Buildings.Electrical.Transmission.LowVoltageCables;
record PvcAl25_ECM "Aluminum cable 25 mm^2"
    extends Buildings.Electrical.Transmission.LowVoltageCables.Cable(
    material=Types.Material.Al,
    RCha=1.32e-003,
    XCha=0.075e-003);
end PvcAl25_ECM;
