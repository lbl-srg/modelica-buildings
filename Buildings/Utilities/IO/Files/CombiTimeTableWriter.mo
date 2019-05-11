within Buildings.Utilities.IO.Files;
model CombiTimeTableWriter
  "Model for writing results to a format that is readable by the model CombiTimeTable"
  extends Buildings.Utilities.IO.Files.BaseClasses.FileWriter(
    final delimiter="\t",
    final isCombiTimeTable=true);

initial algorithm
  if writeHeader then
    str :="# time" + delimiter;
    for i in 1:nin-1 loop
      str :=str + headerNames[i] + delimiter;
    end for;
    str :=str + headerNames[nin] + "\n";
    writeLine(filWri, str, 1);
  end if;

  annotation (
  defaultComponentName="tabWri",
  Documentation(info="<html>
<p>This model samples the model inputs <code>u</code> and saves them to a .csv file,
which can be read by a 
<a href=\"modelica://Modelica.Blocks.Sources.CombiTimeTable\">
Modelica.Blocks.Sources.CombiTimeTable</a>.
The <a href=\"modelica://Modelica.Blocks.Sources.CombiTimeTable\">
Modelica.Blocks.Sources.CombiTimeTable</a>
must then have <code>tableName=\"csv\"</code>, as illustrated in the example
<a href=\"modelica://Buildings.Utilities.IO.Files.Examples.CSVReader\">
Buildings.Utilities.IO.Files.Examples.CSVReader</a>.
</p>
<h4>Typical use and important parameters</h4>
<p>
The parameter <code>nin</code> defines the number of variables that are stored.
In Dymola, this parameter is updated automatically when inputs are connected to the component.
</p>
<p>
The parameter <code>fileName</code> defines to what file name the results
are saved. The file is in the current working directory,
unless an absolute path is provided.
</p>
<p>
The parameter <code>samplePeriod</code> defines every how many seconds
the inputs are saved to the file.
</p>
<h4>Options</h4>
<p>
By default the first line of the csv file consists of the file header.
The column names can be defined using parameter <code>headerNames</code>
or the header can be removed by setting <code>writeHeader=false</code>
</p>
<h4>Dynamics</h4>
<p>
This model samples the outputs at an equidistant interval and
hence disregards the simulation tool output interval settings.
</p>
</html>", revisions="<html>
<ul>
<li>
July 7, 2018 by Filip Jorissen:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/924\">#924</a>.
</li>
</ul>
</html>"), Icon(graphics={                                                Text(
          extent={{-88,90},{88,48}},
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="CombiTimeTable")}));
end CombiTimeTableWriter;
