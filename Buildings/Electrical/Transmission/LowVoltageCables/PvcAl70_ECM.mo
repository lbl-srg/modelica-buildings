within Buildings.Electrical.Transmission.LowVoltageCables;
record PvcAl70_ECM "Aluminum cable 70mm^2"
    extends Buildings.Electrical.Transmission.LowVoltageCables.Cable(
    material=Materials.Material.Al,
    RCha=0.488e-003,
    XCha=0.072e-003);
end PvcAl70_ECM;
