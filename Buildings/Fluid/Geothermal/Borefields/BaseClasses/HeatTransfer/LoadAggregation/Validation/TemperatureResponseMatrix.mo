within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation.Validation;
model TemperatureResponseMatrix
  "This validation case test the calculation, writing and reading of the temperature step response"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.Time timSer[26 + 50,2]=
      Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation.temperatureResponseMatrix(
      nBor=1,
      cooBor={{0,0}},
      hBor=150,
      dBor=4,
      rBor=0.075,
      aSoi=1e-6,
      kSoi=3,
      nSeg=12,
      nClu=1,
      nTimSho=26,
      nTimLon=50,
      nTimTot=26 + 50,
      ttsMax=exp(5),
      sha="TemperatureResponseMatrix_validation",
      forceGFunCalc=true) "Resulting temperature response matrix";
  Modelica.Units.SI.ThermalResistance TStep "Temperature step response";

equation
  TStep = Modelica.Math.Vectors.interpolate(timSer[:,1],timSer[:,2],time);

annotation (experiment(StopTime=31536000,Tolerance=1e-6),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/LoadAggregation/Validation/TemperatureResponseMatrix.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This validation case calculates the g-function for a defined single borehole, turns it
into a temperature step response, saves it as &#34;TemperatureResponseMatrix_validationTStep.mat&#34;,
reads this .mat file and shows the evolution of the temperature step reponse over
the course of the first year.
</p>
</html>", revisions="<html>
<ul>
<li>
July 18, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end TemperatureResponseMatrix;
