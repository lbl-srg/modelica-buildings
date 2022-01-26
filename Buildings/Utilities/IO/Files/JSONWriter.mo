within Buildings.Utilities.IO.Files;
model JSONWriter "Model for writing results to a json file"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Integer nin
    "Number of inputs"
    annotation(Evaluate=true, Dialog(connectorSizing=true));
  parameter String fileName = getInstanceName() + ".json"
    "File name, including extension";
  parameter String[nin] varKeys = {"key" + String(i) for i in 1:nin}
    "Key names, indices by default";
  parameter Buildings.Utilities.IO.Files.BaseClasses.OutputTime outputTime=
    Buildings.Utilities.IO.Files.BaseClasses.OutputTime.Terminal
    "Time when results are written to file"
    annotation(Evaluate=true);
  parameter Modelica.Units.SI.Time customTime=0
    "Custom time when results are stored, used if outputTime=Custom only"
    annotation (Dialog(enable=outputTime == Buildings.Utilities.IO.Files.BaseClasses.OutputTime.Custom));

  Modelica.Blocks.Interfaces.RealVectorInput[nin] u "Variables that are saved"
     annotation (Placement(transformation(extent={{-120,20},{-80,-20}})));
protected
  parameter String insNam = getInstanceName() "Instance name";
  Buildings.Utilities.IO.Files.BaseClasses.JSONWriterObject jsonWri=
      Buildings.Utilities.IO.Files.BaseClasses.JSONWriterObject(
        insNam,
        fileName,
        outputTime==Buildings.Utilities.IO.Files.BaseClasses.OutputTime.Terminal,
        varKeys)
    "File writer object";
equation
  if outputTime==Buildings.Utilities.IO.Files.BaseClasses.OutputTime.Terminal then
    Buildings.Utilities.IO.Files.BaseClasses.cacheVals(jsonWri, u);
  end if;

  if outputTime==Buildings.Utilities.IO.Files.BaseClasses.OutputTime.Initial then
    when initial() then
      Buildings.Utilities.IO.Files.BaseClasses.writeJSON(jsonWri, u);
    end when;
  end if;

  if outputTime==Buildings.Utilities.IO.Files.BaseClasses.OutputTime.Custom then
    when time>=customTime then
      Buildings.Utilities.IO.Files.BaseClasses.writeJSON(jsonWri, u);
    end when;
  end if;

  annotation (
  defaultComponentName="jsonWri",
  Documentation(info="<html>
<p>
This model samples the model inputs <code>u</code> and saves them to a json file.
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
The parameter <code>keyNames</code> defines the key names that are used to 
store the json values corresponding to the inputs <code>u</code>.
</p>
<h4>Dynamics</h4>
<p>
This model samples its inputs at the time defined by the parameter <code>outputTime</code>
and writes them to the file <code>fileName</code>.
The model has the following options:
</p>
<ul>
<li>
If <code>outputTime==OutputTime.Initial</code>, results are saved at initialisation.
</li>
<li>
If <code>outputTime==OutputTime.Custom</code>, results are saved when the built-in variable
<code>time</code> achieves <code>customTime</code>.
</li>
<li>
If <code>outputTime==OutputTime.Terminal</code>, results are saved when the simulation terminates.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
April 9, 2019 by Filip Jorissen:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1114\">#1114</a>.
</li>
</ul>
</html>"),
  Icon(graphics={
         Text(
          extent={{-88,90},{88,48}},
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="JSON")}));
end JSONWriter;
