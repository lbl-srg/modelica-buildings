within Buildings.Electrical.Transmission.MediumVoltageCables;
record Annealed_Al_1500 "Annealed Al cable - AWG 1500"
  extends Buildings.Electrical.Transmission.MediumVoltageCables.Cable(
    material=Types.Material.Al,
    size="1500",
    Rdc=3.87139e-5,
    Tref=298.15,
    d=34.798e-3,
    D=53.34e-3,
    GMR=Buildings.Electrical.Transmission.Functions.computeGMR(d),
    GMD=Buildings.Electrical.Transmission.Functions.computeGMD(0.1905),
    Amp=800);
end Annealed_Al_1500;
