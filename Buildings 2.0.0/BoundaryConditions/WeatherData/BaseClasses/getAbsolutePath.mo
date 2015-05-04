within Buildings.BoundaryConditions.WeatherData.BaseClasses;
function getAbsolutePath "Gets the absolute path of a URI"
  input String uri "A uri";
  output String path "The absolute path of the file pointed to by the URI";

protected
  function loadResource
    input String name "Name of the resource";
    output String path
      "Full path of the resource, or a string of length 0 if it does not exist";
  algorithm
    path :=ModelicaServices.ExternalReferences.loadResource(name);
    if Modelica.Utilities.Strings.length(path) > 0 then
      path := Modelica.Utilities.Files.fullPathName(name=path);
    end if;
  end loadResource;

algorithm
  // If uri does not start with file:// or modelica://, then add file:// to it.
  // This is done because a data reader uses as a parameter the file name without file://
  if (Modelica.Utilities.Strings.find(uri, "file://", startIndex=1, caseSensitive=false) == 0
  and Modelica.Utilities.Strings.find(uri, "modelica://", startIndex=1, caseSensitive=false) == 0) then
  // try file://+uri
    path := loadResource("file://" + uri);
    if not Modelica.Utilities.Files.exist(path) then
      // try modelica://+uri
      path := loadResource("modelica://" + uri);
      if not Modelica.Utilities.Files.exist(path) then
        // try modelica://Buildings/+uri
        path := loadResource("modelica://Buildings/" + uri);

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
<p>
This function returns the absolute path of the uniform resource identifier
by searching for a file with the name
</p>
<pre>
file://uri
modelica://uri
modelica://Buildings/uri
</pre>
<p>
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
