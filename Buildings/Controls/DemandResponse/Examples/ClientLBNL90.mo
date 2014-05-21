within Buildings.Controls.DemandResponse.Examples;
model ClientLBNL90
  "Demand response client with input data from building 90 at LBNL"
  extends Modelica.Icons.Example;
  // fixme: scaling factor for easier debugging
  parameter Modelica.SIunits.Time tPeriod = 24*3600 "Period";
  parameter Modelica.SIunits.Time tSample = 900 "Sampling period";
  Client client(tSample=tSample, tPeriod=24*3600) "Demand response client"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Sources.DayType dayType "Outputs the type of the day"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.CombiTimeTable bui90(
    tableOnFile=true,
    tableName="b90",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    fileName=ModelicaServices.ExternalReferences.loadResource(
      "modelica://Buildings/Resources/Data/Controls/DemandResponse/Examples/B90_DR_Data.mos"),
    columns={2,3,4}) "LBNL building 90 data"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

  Modelica.Blocks.Logical.GreaterThreshold drSig(threshold=0.5)
    "Demand response signal"
    annotation (Placement(transformation(extent={{-40,-6},{-20,14}})));
  Modelica.Blocks.Math.Add err(k2=-1)
    "Difference between predicted minus actual load"
    annotation (Placement(transformation(extent={{60,-34},{80,-14}})));
equation
  connect(client.isEventDay, client.shed) annotation (Line(
      points={{19,4},{0,4},{0,-6},{18,-6}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(dayType.y, client.typeOfDay) annotation (Line(
      points={{-19,30},{0,30},{0,8},{19,8}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(bui90.y[2], client.PCon) annotation (Line(
      points={{-59,-30},{-12,-30},{-12,0},{18,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(drSig.u, bui90.y[3]) annotation (Line(
      points={{-42,4},{-52,4},{-52,-30},{-59,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(drSig.y, client.shed) annotation (Line(
      points={{-19,4},{0,4},{0,-6},{18,-6}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(client.PPre, err.u1) annotation (Line(
      points={{41,0},{48,0},{48,-18},{58,-18}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(err.u2, client.PCon) annotation (Line(
      points={{58,-30},{-12,-30},{-12,0},{18,0},{18,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),                                                                    graphics),
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
