within Buildings.Fluid.HeatExchangers.Borefield.Data.FillingData;
record Bentonite
  extends Records.Filling(
    pathMod="Buildings.Fluid.HeatExchangers.Borefield.Data.FillingData.Bentonite",
    pathCom = Modelica.Utilities.Files.loadResource("modelica://Buildings/Fluid/HeatExchangers/Borefield/Data/FillingData/Bentonite.mo"),
    k=1.15,
    d=1600,
    c=800);
end Bentonite;
