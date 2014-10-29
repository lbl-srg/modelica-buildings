within Buildings.Controls.DemandResponse.Examples;
model ClientLBNL90
  "Demand response client with input data from building 90 at LBNL"
  extends Modelica.Icons.Example;
  // fixme: scaling factor for easier debugging
  parameter Integer nSam = 24*4 "Number of samples in a day";
  Client clientAverage(
    nSam=nSam,
    predictionModel=Buildings.Controls.Predictors.Types.PredictionModel.Average)
    "Demand response client"
    annotation (Placement(transformation(extent={{8,40},{28,60}})));
  Sources.DayType dayType "Outputs the type of the day"
    annotation (Placement(transformation(extent={{-52,60},{-32,80}})));
  Modelica.Blocks.Sources.CombiTimeTable bui90(
    tableOnFile=true,
    tableName="b90",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    fileName=ModelicaServices.ExternalReferences.loadResource(
      "modelica://Buildings/Resources/Data/Controls/DemandResponse/Examples/B90_DR_Data.mos"),
    columns={2,3,4}) "LBNL building 90 data"
    annotation (Placement(transformation(extent={{-92,0},{-72,20}})));

  Modelica.Blocks.Logical.GreaterThreshold drSig(threshold=0.5)
    "Demand response signal"
    annotation (Placement(transformation(extent={{-52,34},{-32,54}})));
  Modelica.Blocks.Math.Add errorAverage(k2=-1)
    "Difference between predicted minus actual load"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Client clientWeather(
    nSam=nSam,
    predictionModel=Buildings.Controls.Predictors.Types.PredictionModel.WeatherRegression)
    "Demand response client with weather regression model"
    annotation (Placement(transformation(extent={{8,-20},{28,0}})));
  Modelica.Blocks.Math.Add errorWeather(k2=-1)
    "Difference between predicted minus actual load"
    annotation (Placement(transformation(extent={{40,-54},{60,-34}})));
  Modelica.Blocks.Math.Gain relErrAverage(k=1/400000)
    "Relative error, normalized by a value that is close to the peak power consumption"
    annotation (Placement(transformation(extent={{70,10},{90,30}})));
  Modelica.Blocks.Math.Gain relErrWeather(k=1/400000)
    "Relative error, normalized by a value that is close to the peak power consumption"
    annotation (Placement(transformation(extent={{72,-54},{92,-34}})));
  Modelica.Blocks.Continuous.Integrator ene(u(unit="W"))
    "Integrator to compute energy from power"
    annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));
equation
  connect(clientAverage.isEventDay, clientAverage.shed) annotation (Line(
      points={{7,54},{-12,54},{-12,46},{7,46}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(drSig.u, bui90.y[3]) annotation (Line(
      points={{-54,44},{-64,44},{-64,10},{-71,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(drSig.y, clientAverage.shed) annotation (Line(
      points={{-31,44},{-12,44},{-12,46},{7,46}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(clientAverage.PPre, errorAverage.u1) annotation (Line(
      points={{29,50},{34,50},{34,26},{38,26}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(clientWeather.isEventDay, clientWeather.shed) annotation (Line(
      points={{7,-6},{-12,-6},{-12,-14},{7,-14}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(drSig.y, clientWeather.shed) annotation (Line(
      points={{-31,44},{-12,44},{-12,-14},{7,-14}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(clientWeather.PPre, errorWeather.u1) annotation (Line(
      points={{29,-10},{34,-10},{34,-38},{38,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(clientAverage.TOut, bui90.y[1]) annotation (Line(
      points={{7,42},{-8,42},{-8,10},{-71,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(clientWeather.TOut, bui90.y[1]) annotation (Line(
      points={{7,-18},{-8,-18},{-8,10},{-71,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(relErrAverage.u, errorAverage.y) annotation (Line(
      points={{68,20},{61,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(relErrWeather.u, errorWeather.y) annotation (Line(
      points={{70,-44},{61,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ene.u, bui90.y[2]) annotation (Line(
      points={{-52,-10},{-64,-10},{-64,10},{-71,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ene.y, clientWeather.ECon) annotation (Line(
      points={{-29,-10},{7,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ene.y, clientAverage.ECon) annotation (Line(
      points={{-29,-10},{-16,-10},{-16,50},{7,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(errorWeather.u2, bui90.y[2]) annotation (Line(
      points={{38,-50},{-64,-50},{-64,10},{-71,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(errorAverage.u2, bui90.y[2]) annotation (Line(
      points={{38,14},{-64,14},{-64,10},{-71,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dayType.y, clientAverage.typeOfDay) annotation (Line(
      points={{-31,70},{-12,70},{-12,58},{7,58}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(dayType.y, clientWeather.typeOfDay) annotation (Line(
      points={{-31,70},{-12,70},{-12,-2},{7,-2}},
      color={0,127,0},
      smooth=Smooth.None));
  annotation (
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
          __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/DemandResponse/Examples/ClientLBNL90.mos"
        "Simulate and plot"),
            experiment(
      StopTime=1.728e+06,
      Interval=900),
    Documentation(info="<html>
<p>
Model that demonstrates the demand response client, 
using as an input for the actual electrical consumption simulated
data from building 90 at LBNL.
Output of the data reader are the outdoor dry-bulb temperature,
the total electrical consumption,
and a signal that indicates whether load shedding is required.
</p>
</html>", revisions="<html>
<ul>
<li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_experimentSetupOutput);
end ClientLBNL90;
