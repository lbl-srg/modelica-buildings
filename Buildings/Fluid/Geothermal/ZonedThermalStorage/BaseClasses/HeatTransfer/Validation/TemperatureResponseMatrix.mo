within Buildings.Fluid.Geothermal.ZonedThermalStorage.BaseClasses.HeatTransfer.Validation;
model TemperatureResponseMatrix
  "This validation case tests the calculation of thermal resposne factors"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.Time kappa[8,8,7]=
      Buildings.Fluid.Geothermal.ZonedThermalStorage.BaseClasses.HeatTransfer.temperatureResponseMatrix(
      nBor=3,
      cooBor={{0,0}, {0,5}, {5,0}},
      hBor=150,
      dBor=4,
      rBor=0.075,
      aSoi=1e-6,
      kSoi=2,
      nSeg=4,
      nZon=2,
      iZon={1, 2, 1},
      nBorPerZon={2, 1},
      nu={300, 3600, 86400, 604800, 2592000, 31536000, 315360000},
      nTim=7) "Resulting temperature response matrix";

annotation (experiment(StopTime=1.1,Tolerance=1e-6),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/ZonedThermalStorage/BaseClasses/HeatTransfer/Validation/TemperatureResponseMatrix.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This validation case calculates the thermal response matrix for a field of 3
boreholes divided into 2 zones.
</p>
</html>", revisions="<html>
<ul>
<li>
February 2024, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));

end TemperatureResponseMatrix;
