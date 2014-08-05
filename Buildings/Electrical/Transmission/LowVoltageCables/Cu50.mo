within Buildings.Electrical.Transmission.LowVoltageCables;
record Cu50 "Cu cable 50 mm^2"
  extends Buildings.Electrical.Transmission.LowVoltageCables.Generic(
    material=Types.Material.Cu,
    Amp=170,
    RCha=0.362e-003,
    XCha=0.073e-003);
end Cu50;
