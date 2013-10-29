within Buildings.Electrical.Transmission.LowVoltageCables;
record PvcAl35_ECM "Aluminum cable 35 mm^2"
    extends Buildings.Electrical.Transmission.LowVoltageCables.Cable(
    material=Materials.Material.Al,
    RCha=0.956e-003,
    XCha=0.074e-003);
end PvcAl35_ECM;
