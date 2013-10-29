within Buildings.Electrical.Transmission.MediumVoltageCables;
record Annealed_Al_10 "Annealed Al cable - AWG 1/0"
  extends Buildings.Electrical.Transmission.MediumVoltageCables.Cable(
    material=Materials.Material.Al,
    size="1/0",
    Rdc=0.551181e-3,
    Tref=298.15,
    d=9.195e-3,
    D=26.543e-3,
    GMR=0.0,
    GMD=0.0,
    Amp=100);
end Annealed_Al_10;
