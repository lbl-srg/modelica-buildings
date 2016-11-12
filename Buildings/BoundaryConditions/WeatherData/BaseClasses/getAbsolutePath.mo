within Buildings.BoundaryConditions.WeatherData.BaseClasses;
function getAbsolutePath "Gets the absolute path of a URI"
  input String uri "A URI";
  output String path "The absolute path of the file pointed to by the URI";
algorithm
  path := Modelica.Utilities.Files.loadResource(uri);
  assert(Modelica.Utilities.Files.exist(path), "File '" + uri + "' does not exist.");
  annotation (Documentation(info="<html>
<p>
The function returns the absolute path of a
uniform resource identifier (URI) or local file name.
If the file is not found, then this function 
terminates with an <code>assert</code>.
</p>
<p>
This function has been introduced to allow users
to specify the name of weather data files with a path
that is relative to the library path. This allows users
to change the current working directory while still
being able to read the files.
</p>
</html>", revisions="<html>
<ul>
<li>
July 07, 2016, by Thierry S. Nouidui:<br/>
Removed the use of <code>Modelica.Utilities.Files.fullPathName</code>
which is implicitly done in <code>Modelica.Utilities.Files.loadResource</code>. <br/>
Removed the addition of <code>file://</code> to file names which do not start
with <code>file://</code>, or <code>modelica://</code>.
This is not required when using <code>Modelica.Utilities.Files.loadResource</code>.
</li>
<li>
April 21, 2016, by Michael Wetter:<br/>
Replaced <code>ModelicaServices.ExternalReferences.loadResource</code> with
<code>Modelica.Utilities.Files.loadResource</code>.
</li>
<li>
October 8, 2013, by Michael Wetter:<br/>
Improved algorithm that determines the absolute path of the file.
Now the function works from any directory as long as the <code>Buildings</code> library
is on the <code>MODELICAPATH</code>.
</li>
<li>
May 2, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end getAbsolutePath;
