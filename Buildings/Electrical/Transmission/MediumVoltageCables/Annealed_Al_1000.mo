within Buildings.Electrical.Transmission.MediumVoltageCables;
record Annealed_Al_1000 "Annealed Al cable - AWG 1000"
  extends Buildings.Electrical.Transmission.MediumVoltageCables.Cable(
    material=Materials.Material.Al,
    size="1000",
    Rdc=5.80709e-5,
    Tref=298.15,
    d=28.372e-3,
    D=46.101e-3,
    GMR=Buildings.Electrical.Transmission.Functions.computeGMR(d),
    GMD=Buildings.Electrical.Transmission.Functions.computeGMD(0.1905),
    Amp=640);
end Annealed_Al_1000;
