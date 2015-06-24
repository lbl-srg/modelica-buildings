within Buildings.Controls.DemandResponse.Examples;
model ClientLBNL90
  "Demand response client with input data from building 90 at LBNL"
  extends Modelica.Icons.Example;
  parameter Integer nSam = 24*4 "Number of samples in a day";
  Client clientAverage(
    nSam=nSam,
    predictionModel=Buildings.Controls.Predictors.Types.PredictionModel.Average)
    "Demand response client"
    annotation (Placement(transformation(extent={{10,20},{30,40}})));
  Sources.DayType dayType "Outputs the type of the day"
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  Modelica.Blocks.Sources.CombiTimeTable bui90(
    tableOnFile=true,
    tableName="b90",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    fileName=ModelicaServices.ExternalReferences.loadResource(
      "modelica://Buildings/Resources/Data/Controls/DemandResponse/Examples/B90_DR_Data.mos"),
    columns={2,3,4}) "LBNL building 90 data"
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));

  Modelica.Blocks.Logical.GreaterThreshold drSig(threshold=0.5)
    "Demand response signal"
    annotation (Placement(transformation(extent={{-50,14},{-30,34}})));
  Modelica.Blocks.Math.Add errorAverage(k2=-1)
    "Difference between predicted minus actual load"
    annotation (Placement(transformation(extent={{42,-10},{62,10}})));
  Client clientWeather(
    nSam=nSam,
    predictionModel=Buildings.Controls.Predictors.Types.PredictionModel.WeatherRegression)
    "Demand response client with weather regression model"
    annotation (Placement(transformation(extent={{10,-40},{30,-20}})));
  Modelica.Blocks.Math.Add errorWeather(k2=-1)
    "Difference between predicted minus actual load"
    annotation (Placement(transformation(extent={{42,-74},{62,-54}})));
  Modelica.Blocks.Math.Gain relErrAverage(k=1/400000)
    "Relative error, normalized by a value that is close to the peak power consumption"
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
  Modelica.Blocks.Math.Gain relErrWeather(k=1/400000)
    "Relative error, normalized by a value that is close to the peak power consumption"
    annotation (Placement(transformation(extent={{74,-74},{94,-54}})));
  Modelica.Blocks.Continuous.Integrator ene(u(unit="W"))
    "Integrator to compute energy from power"
    annotation (Placement(transformation(extent={{-48,-40},{-28,-20}})));
  Modelica.Blocks.Sources.Constant yShed(k=0.5)
    "Amount of load to be shed during DR event"
    annotation (Placement(transformation(extent={{-50,70},{-30,90}})));
equation
  connect(clientAverage.isEventDay, clientAverage.shed) annotation (Line(
      points={{9,34},{-10,34},{-10,27},{9,27}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(drSig.u, bui90.y[3]) annotation (Line(
      points={{-52,24},{-62,24},{-62,-10},{-69,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(drSig.y, clientAverage.shed) annotation (Line(
      points={{-29,24},{-10,24},{-10,27},{9,27}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(clientAverage.PPre, errorAverage.u1) annotation (Line(
      points={{31,30},{36,30},{36,6},{40,6}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(clientWeather.isEventDay, clientWeather.shed) annotation (Line(
      points={{9,-26},{-10,-26},{-10,-33},{9,-33}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(drSig.y, clientWeather.shed) annotation (Line(
      points={{-29,24},{-10,24},{-10,-33},{9,-33}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(clientWeather.PPre, errorWeather.u1) annotation (Line(
      points={{31,-30},{36,-30},{36,-58},{40,-58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(clientWeather.TOut, bui90.y[1]) annotation (Line(
      points={{9,-37},{-6,-37},{-6,-10},{-69,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(relErrAverage.u, errorAverage.y) annotation (Line(
      points={{70,0},{63,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(relErrWeather.u, errorWeather.y) annotation (Line(
      points={{72,-64},{63,-64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ene.u, bui90.y[2]) annotation (Line(
      points={{-50,-30},{-62,-30},{-62,-10},{-69,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ene.y, clientWeather.ECon) annotation (Line(
      points={{-27,-30},{9,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ene.y, clientAverage.ECon) annotation (Line(
      points={{-27,-30},{-14,-30},{-14,30},{9,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(errorWeather.u2, bui90.y[2]) annotation (Line(
      points={{40,-70},{-62,-70},{-62,-10},{-69,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(errorAverage.u2, bui90.y[2]) annotation (Line(
      points={{40,-6},{-62,-6},{-62,-10},{-69,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dayType.y, clientAverage.typeOfDay) annotation (Line(
      points={{-29,50},{-10,50},{-10,38},{9,38}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(dayType.y, clientWeather.typeOfDay) annotation (Line(
      points={{-29,50},{-10,50},{-10,-22},{9,-22}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(yShed.y, clientAverage.yShed) annotation (Line(
      points={{-29,80},{0,80},{0,25},{9,25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(clientWeather.yShed, yShed.y) annotation (Line(
      points={{9,-35},{0,-35},{0,80},{-29,80}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
          __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/DemandResponse/Examples/ClientLBNL90.mos"
        "Simulate and plot"),
            experiment(
      StopTime=1.728e+06),
    Documentation(info="<html>
<p>
Model that demonstrates the demand response client,
using as an input for the actual electrical consumption simulated
data from building 90 at LBNL.
Output of the data reader are the outdoor dry-bulb temperature,
the total electrical consumption,
and a signal that indicates whether load shedding is required.
</p>
<p>
Output of the demand response blocks are the predicted power consumption.
If the input signal <code>shed</code> is <code>true</code>,
then the predicted load is reduced by the amount of power that is shed,
as received from the input signal <code>yShed</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ClientLBNL90;
