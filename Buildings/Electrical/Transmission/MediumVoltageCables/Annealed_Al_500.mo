within Buildings.Electrical.Transmission.MediumVoltageCables;
record Annealed_Al_500 "Annealed Al cable - AWG 500"
  extends Buildings.Electrical.Transmission.MediumVoltageCables.Cable(
    material=Types.Material.Al,
    size="500",
    Rdc=0.116142e-3,
    Tref=298.15,
    d=20.066e-3,
    D=37.592e-3,
    GMR=Buildings.Electrical.Transmission.Functions.computeGMR(d),
    GMD=Buildings.Electrical.Transmission.Functions.computeGMD(0.1905),
    Amp=450);
end Annealed_Al_500;
