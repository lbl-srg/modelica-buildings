within Buildings.BoundaryConditions.WeatherData.BaseClasses;
function getAbsolutePath "Gets the absolute path of a URI"
  input String uri "A uri";
  output String path "The absolute path of the file pointed to by the URI";
algorithm
  // If uri does not start with file:// or modelica://, then add file:// to it.
  // This is done because a data reader uses as a parameter the file name without file://
  if (Modelica.Utilities.Strings.find(uri, "file://", startIndex=1, caseSensitive=false) == 0
  and Modelica.Utilities.Strings.find(uri, "modelica://", startIndex=1, caseSensitive=false) == 0) then
  // try file://+uri
    path :=ModelicaServices.ExternalReferences.loadResource("file://" + uri);
    path := Modelica.Utilities.Files.fullPathName(name=path);
    if not Modelica.Utilities.Files.exist(path) then
      // try modelica://+uri
      path := ModelicaServices.ExternalReferences.loadResource("modelica://" + uri);
      path := Modelica.Utilities.Files.fullPathName(name=path);
      if not Modelica.Utilities.Files.exist(path) then
        // try modelica://Buildings/+uri
        path := ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/" + uri);
        path := Modelica.Utilities.Files.fullPathName(name=path);
        assert(Modelica.Utilities.Files.exist(path), "File '" + uri + "' does not exist.
  Expected to find either 'file://" + uri + "
                       or 'modelica://" + uri + " +
                       or 'modelica://Buildings/" + uri);
      end if;
    end if;
  else
    path := ModelicaServices.ExternalReferences.loadResource(uri);
    path := Modelica.Utilities.Files.fullPathName(name=path);

    assert(Modelica.Utilities.Files.exist(path), "File '" + uri + "' does not exist.");

  end if;

  annotation (Documentation(info="<html>
This function returns the absolute path of the uniform resource identifier
by searching for a file with the name
</p>
<pre>
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
