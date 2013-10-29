within Buildings.Electrical.Transmission.MediumVoltageCables;
record Annealed_Al_500 "Annealed Al cable - AWG 500"
  extends Buildings.Electrical.Transmission.MediumVoltageCables.Cable(
    material=Materials.Material.Al,
    size="500",
    Rdc=0.116142e-3,
    Tref=298.15,
    d=20.066e-3,
    D=37.592e-3,
    GMR=0.0,
    GMD=0.0,
    Amp=100);
end Annealed_Al_500;
