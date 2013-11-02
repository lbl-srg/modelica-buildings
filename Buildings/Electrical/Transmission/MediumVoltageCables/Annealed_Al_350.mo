within Buildings.Electrical.Transmission.MediumVoltageCables;
record Annealed_Al_350 "Annealed Al cable - kcmil 350"
  extends Buildings.Electrical.Transmission.MediumVoltageCables.Cable(
    material=Materials.Material.Al,
    size="350",
    Rdc=0.165682e-3,
    Tref=298.15,
    d=16.789e-3,
    D=34.417e-3,
    GMR=0.0,
    GMD=0.0,
    Amp=375);
end Annealed_Al_350;
