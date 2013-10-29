within Buildings.Electrical.Transmission.MediumVoltageCables;
record Annealed_Al_30 "Annealed Al cable - AWG 3/0"
  extends Buildings.Electrical.Transmission.MediumVoltageCables.Cable(
    material=Materials.Material.Al,
    size="3/0",
    Rdc=0.344488e-3,
    Tref=298.15,
    d=11.582e-3,
    D=28.956e-3,
    GMR=0.0,
    GMD=0.0,
    Amp=100);
end Annealed_Al_30;
