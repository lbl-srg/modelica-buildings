within Buildings.Electrical.Transmission.LowVoltageCables;
record PvcAl35 "Aluminum cable 35 mm^2"
extends Buildings.Electrical.Transmission.LowVoltageCables.Generic(
    material=Types.Material.Al,
    RCha=0.923e-003,
    XCha=0.074e-003);
end PvcAl35;
