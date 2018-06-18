within Buildings.Utilities.IO.Python27.Functions.BaseClasses;
class PythonObject
  "class used to create the external object: PythonObject"
extends ExternalObject;
    function constructor
      "Construct an external object that can be used to store a Python object"
    output PythonObject pytObj;
    external "C" pytObj = initPythonMemory()
        annotation (Library={"ModelicaBuildingsPython2.7",  "python2.7"},
          LibraryDirectory="modelica://Buildings/Resources/Library",
          __iti_dll = "ITI_ModelicaBuildingsPython2.7.dll",
          __iti_dllNoExport = true);

    annotation(Documentation(info="<html>
<p>
The function <code>constructor</code> is a C function that is called by a Modelica simulator
exactly once during the initialization.
The function returns the object <code>PythonObject</code> that
will be used to store a Python object and pass it from one invocation to another
in the function
<a href=\"modelica://Buildings.Utilities.IO.Python27.Functions.BaseClasses.exchange\">
Buildings.Utilities.IO.Python27.Functions.BaseClasses.exchange</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 13, 2018, by Michael Wetter:<br/>
Corrected <code>LibraryDirectory</code> annotation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1160\">issue 1160</a>.
</li>
<li>
January 31, 2018, by Michael Wetter and Thierry Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"));
    end constructor;

  function destructor "Release memory"
    input PythonObject pytObj;
    external "C" freePythonMemory(pytObj)
      annotation (Library={"ModelicaBuildingsPython2.7",  "python2.7"},
        LibraryDirectory="modelica://Buildings/Resources/Library",
        __iti_dll = "ITI_ModelicaBuildingsPython2.7.dll",
        __iti_dllNoExport = true);

  annotation(Documentation(info="<html>
<p>
Destructor that frees the memory of the object
<code>PythonObject</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 31, 2018, by Michael Wetter and Thierry Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"));
  end destructor;
annotation(Documentation(info="<html>
<p>
Class derived from <code>ExternalObject</code> having two local external functions
named <code>destructor</code> and <code>constructor</code>.
<p>
These functions create and release an external object that allows the storage
of a Python object.

</html>",
revisions="<html>
<ul>
<li>
January 31, 2018, by Michael Wetter and Thierry Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"));
end PythonObject;
