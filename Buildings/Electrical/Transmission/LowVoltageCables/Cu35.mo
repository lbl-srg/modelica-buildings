within Buildings.Electrical.Transmission.LowVoltageCables;
record Cu35 "Cu cable 35 mm^2"
  extends Buildings.Electrical.Transmission.LowVoltageCables.Generic(
    material=Types.Material.Cu,
    Amp=130,
    RCha=0.517e-003,
    XCha=0.074e-003);
end Cu35;
