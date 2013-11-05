within Buildings.Electrical.Transmission.LowVoltageCables;
record Cu100 "Cu cable 100 mm^2"
  extends Buildings.Electrical.Transmission.LowVoltageCables.Cable(
    material=Materials.Material.Cu,
    Amp = 230,
    RCha=0.181e-003,
    XCha=0.072e-003);
end Cu100;
