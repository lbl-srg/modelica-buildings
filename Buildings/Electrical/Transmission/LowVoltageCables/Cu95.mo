within Buildings.Electrical.Transmission.LowVoltageCables;
record Cu95 "Cu cable 95 mm^2"
  extends Buildings.Electrical.Transmission.LowVoltageCables.Cable(
    material=Types.Material.Cu,
    Amp=220,
    RCha=0.191e-003,
    XCha=0.072e-003);
end Cu95;
