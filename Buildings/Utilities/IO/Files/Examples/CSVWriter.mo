within Buildings.Utilities.IO.Files.Examples;
model CSVWriter "Example of csv writer use"
  extends Buildings.Utilities.IO.Files.Examples.BaseClasses.PartialCSV;
  CombiTimeTableWriter combiTimeTableWriter(
    nin=2,
    samplePeriod=0.3,
    fileName="test.csv",
    significantDigits=10)
    "Model that writes two inputs to csv file in a format that can be read by a combiTimeTable"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Utilities.IO.Files.CSVWriter csvWriter(
    writeHeader=false,
    nin=2,
    samplePeriod=0.3)
    "Duplicate to test for conflicts when instantiating multiple file writers"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

equation
  connect(cos.y, combiTimeTableWriter.u[1]) annotation (Line(points={{-59,30},{-40,
          30},{-40,1},{-20,1}},     color={0,0,127}));
  connect(step.y, combiTimeTableWriter.u[2]) annotation (Line(points={{-59,-30},
          {-40,-30},{-40,-1},{-20,-1}}, color={0,0,127}));
  connect(csvWriter.u[1], cos.y) annotation (Line(points={{-20,-29},{-32,-29},{-32,
          30},{-59,30}},     color={0,0,127}));
  connect(csvWriter.u[2], step.y) annotation (Line(points={{-20,-31},{-40,-31},
          {-40,-30},{-59,-30}}, color={0,0,127}));
  annotation (experiment(
      StartTime=-1.21,
      StopTime=10,
      Tolerance=1e-06),
  Documentation(revisions="<html>
<ul>
<li>
October 8, 2018 by Filip Jorissen:<br/>
Using implementation of the parameter <code>significantDigits</code>.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1041\">#1041</a>.
</li>
<li>
May 10, 2018 by Filip Jorissen:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/924\">#924</a>.
</li>
</ul>
</html>", info="<html>
<p>
This model demonstrates the use of the csv file writer.
</p>
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/IO/Files/Examples/CSVWriter.mos"
        "Simulate and plot"));
end CSVWriter;
