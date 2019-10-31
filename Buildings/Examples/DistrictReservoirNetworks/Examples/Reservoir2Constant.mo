within Buildings.Examples.DistrictReservoirNetworks.Examples;
model Reservoir2Constant "Reservoir network with simple control and dp=125 Pa/m"
  extends Modelica.Icons.Example;
  extends
    Buildings.Examples.DistrictReservoirNetworks.Examples.Reservoir1Constant(
    datDes(
      RDisPip=125));

  annotation (
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-480},{380,360}})),
        __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/DistrictReservoirNetworks/Examples/Reservoir2Constant.mos"
        "Simulate and plot"),
    experiment(StopTime=31536000,
    Tolerance=1e-06, __Dymola_NumberOfIntervals=8760));
end Reservoir2Constant;
