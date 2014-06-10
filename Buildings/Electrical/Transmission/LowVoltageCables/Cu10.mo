within Buildings.Electrical.Transmission.LowVoltageCables;
record Cu10 "Cu cable 10 mm^2"
  extends Buildings.Electrical.Transmission.LowVoltageCables.Cable(
    material=Types.Material.Cu,
    Amp=65,
    RCha=1.81e-003,
    XCha=0.076e-003);
end Cu10;
