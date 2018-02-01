within Buildings.Utilities.IO.Python27.Functions.BaseClasses;
class PythonObject
  "class used to create the external object: PythonMemory"
extends ExternalObject;
    function constructor
    "Construct an extendable array that can be used to store double values"
    output PythonObject pytObj;
    external "C" pytObj = initPythonMemory()
        annotation (Library={"ModelicaBuildingsPython2.7",  "python2.7"},
          LibraryDirectory={"modelica://Buildings/Resources/Library"},
          __iti_dll = "ITI_ModelicaBuildingsPython2.7.dll",
          __iti_dllNoExport = true);

    annotation(Documentation(info="<html>
<p>
The function <code>constructor</code> is a C function that is called by a Modelica simulator
exactly once during the initialization.
The function returns the object <code>PythonObject</code> that
will be used to store a Python object and pass it from one invocation to another 
in the function
<a href=\"modelica://Buildings.Utilities.IO.Python27.Functions.BaseClasses.exchangeWithMemory\">
Buildings.Utilities.IO.Python27.Functions.BaseClasses.exchangeWithMemory</a>.
</p>
</html>", revisions="<html>
<ul>
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
        LibraryDirectory={"modelica://Buildings/Resources/Library"},
        __iti_dll = "ITI_ModelicaBuildingsPython2.7.dll",
        __iti_dllNoExport = true);

  annotation(Documentation(info="<html>
<p>
Destructor that frees the memory of the object
<code>PythonMemory</code>.
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
Class derived from <code>ExternalObject</code> having two local external function definition,
named <code>destructor</code> and <code>constructor</code> respectively.
<p>
These functions create and release an external object that allows the storage
of real parameters in an array of extendable dimension.

</html>",
revisions="<html>
<ul>
<li>
July 28 2011, by Pierre Vigouroux:<br/>
First implementation.
</li>
</ul>
</html>"));
end PythonObject;
