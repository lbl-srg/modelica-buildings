within Buildings.Electrical.Transmission.MediumVoltageCables;
record Annealed_Al_40 "Annealed Al cable - AWG 4/0"
  extends Buildings.Electrical.Transmission.MediumVoltageCables.Cable(
    material=Materials.Material.Al,
    size="4/0",
    Rdc=0.274278e-3,
    Tref=298.15,
    d=13.005e-3,
    D=30.353e-3,
    GMR=0.0,
    GMD=0.0,
    Amp=285);
end Annealed_Al_40;
