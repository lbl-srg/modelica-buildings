within Buildings.Electrical.Transmission.LowVoltageCables;
record PvcAl70 "Aluminum cable 70mm^2"
  extends Buildings.Electrical.Transmission.LowVoltageCables.Cable(
    material=Types.Material.Al,
    RCha=0.5071e-003,
    XCha=0.072e-003);
end PvcAl70;
