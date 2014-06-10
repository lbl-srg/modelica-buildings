within Buildings.Electrical.Transmission.LowVoltageCables;
record Cu25 "Cu cable 25 mm^2"
  extends Buildings.Electrical.Transmission.LowVoltageCables.Generic(
    material=Types.Material.Cu,
    Amp=110,
    RCha=0.727e-003,
    XCha=0.075e-003);
end Cu25;
