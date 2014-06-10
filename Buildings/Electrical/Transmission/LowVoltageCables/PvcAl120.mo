within Buildings.Electrical.Transmission.LowVoltageCables;
record PvcAl120 "Aluminum cable 120mm^2"
  extends Buildings.Electrical.Transmission.LowVoltageCables.Generic(
    material=Types.Material.Al,
    RCha=0.269e-003,
    XCha=0.071e-003);
end PvcAl120;
