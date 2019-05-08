within Buildings.Utilities.IO.Files.BaseClasses;
class JSONWriterObject
  "Class used to ensure that each JSON writer writes to a unique file"
extends ExternalObject;
  function constructor
    "Verify whether a file writer with  the same path exists and cache variable keys"
    extends Modelica.Icons.Function;
    input String instanceName "Instance name of the file write";
    input String fileName "Name of the file, including extension";
    input Boolean dumpAtDestruction "=true, to write cached values at destruction";
    input String[:] varKeys "Keys for values that are written to file";
    output JSONWriterObject jsonWriter "Pointer to the file writer";
    external"C" jsonWriter = jsonWriterInit(instanceName, fileName, dumpAtDestruction, size(varKeys,1), varKeys)
    annotation (
      Include="#include <jsonWriterInit.c>",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources");

    annotation(Documentation(info="<html>
<p>
Creates an empty file with name <code>fileName</code>.
If <code>fileName</code> is used in another instance of
<a href=\"modelica://Buildings.Utilities.IO.Files.CSVWriter\">
Buildings.Utilities.IO.Files.CSVWriter</a>,
the simulation stops with an error.
</p>
</html>", revisions="<html>
c
</html>"));
  end constructor;

  function destructor "Release storage and close the external object, write data if needed"
    input JSONWriterObject jsonWriter "Pointer to file writer object";
    external "C" jsonWriterFree(jsonWriter)
    annotation(Include=" #include <jsonWriterFree.c>",
    IncludeDirectory="modelica://Buildings/Resources/C-Sources");
  annotation(Documentation(info="<html>
<p>
Destructor that frees the memory of the object
<code>FileWriter</code>.
</p>
</html>",
  revisions="<html>
<ul>
<li>
April 15 2019, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
  end destructor;

annotation(Documentation(info="<html>
<p>
Class derived from <code>ExternalObject</code> having two local external function definition,
named <code>destructor</code> and <code>constructor</code> respectively.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 15 2019, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end JSONWriterObject;
