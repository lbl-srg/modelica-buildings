within Buildings.BoundaryConditions.WeatherData.BaseClasses;
function getAbsolutePath "Gets the absolute path of a URI"
  input String uri "A uri";
  output String path "The absolute path of the file pointed to by the URI";
algorithm
  path :=ModelicaServices.ExternalReferences.loadResource(uri);
  if not Modelica.Utilities.Files.exist(path) then
    path :=ModelicaServices.ExternalReferences.loadResource("file://" + uri);
  end if;
  if not Modelica.Utilities.Files.exist(path) then
      path :=ModelicaServices.ExternalReferences.loadResource("modelica://" +
        uri);
  end if;
  if not Modelica.Utilities.Files.exist(path) then
        path :=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/"
           + uri);
  end if;
  assert(Modelica.Utilities.Files.exist(path), "File '" + uri + "' does not exist.
  Expected to find either '" + uri + "
                       or 'file://" + uri + "
                       or 'modelica://" + uri + " +
                       or 'modelica://Buildings/" + uri);

  annotation (Documentation(info="<html>
This function returns the absolute path of the uniform resource identifier
by searching for a file with the name
</p>
<pre>
uri
file://uri
modelica://uri
modelica://Buildings/uri
</pre>
The function returns the absolute path of the first file that is found, using the above search order.
If the file is not found, then this function terminates with an <code>assert</code>.
</p>
<p>
This function has been introduced to allow users to specify the name of weather data
files with a path that is relative to the library path.
This allows users to change the current working directory while still being able to read
the files.
</p>                       
</html>", revisions="<html>
<ul>
<li>
May 2, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end getAbsolutePath;
