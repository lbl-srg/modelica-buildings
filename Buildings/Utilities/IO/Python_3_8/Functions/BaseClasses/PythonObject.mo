within Buildings.Utilities.IO.Python_3_8.Functions.BaseClasses;
class PythonObject
  "class used to create the external object: PythonObject"
extends ExternalObject;
    impure function constructor
      "Construct an external object that can be used to store a Python object"
    output PythonObject pytObj;
    external "C" pytObj = initPythonMemory()
        annotation (Library={"ModelicaBuildingsPython_3_8",  "python3.8"},
          LibraryDirectory="modelica://Buildings/Resources/Library");

    annotation(Documentation(info="<html>
<p>
The function <code>constructor</code> is a C function that is called by a Modelica simulator
exactly once during the initialization.
The function returns the object <code>PythonObject</code> that
will be used to store a Python object and pass it from one invocation to another
in the function
<a href=\"modelica://Buildings.Utilities.IO.Python_3_8.Functions.BaseClasses.exchange\">
Buildings.Utilities.IO.Python_3_8.Functions.BaseClasses.exchange</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 27, 2021, by Michael Wetter:<br/>
Updated to Python 3.8.
</li>
<li>
April 10, 2020, by Jianjun Hu and Michael Wetter:<br/>
Updated to Python 3.6.
</li>
<li>
March 06, 2020, by Jianjun Hu:<br/>
Upgraded python version from 2.7 to 3.6.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1760\">issue 1760</a>.
</li>
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

  impure function destructor "Release memory"
    input PythonObject pytObj;
    external "C" freePythonMemory(pytObj)
      annotation (Library={"ModelicaBuildingsPython_3_8",  "python3.8"},
        LibraryDirectory="modelica://Buildings/Resources/Library");

  annotation(Documentation(info="<html>
<p>
Destructor that frees the memory of the object
<code>PythonObject</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 27, 2021, by Michael Wetter:<br/>
Updated to Python 3.8.
</li>
<li>
April 10, 2020, by Jianjun Hu and Michael Wetter:<br/>
Updated to Python 3.6.
</li>
<li>
March 06, 2020, by Jianjun Hu:<br/>
Upgraded python version from 2.7 to 3.6.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1760\">issue 1760</a>.
</li>
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
</p>
<p>
These functions create and release an external object that allows the storage
of a Python object.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 27, 2021, by Michael Wetter:<br/>
Updated to Python 3.8.
</li>
<li>
April 10, 2020, by Jianjun Hu and Michael Wetter:<br/>
Updated to Python 3.6.
</li>
<li>
January 31, 2018, by Michael Wetter and Thierry Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"));
end PythonObject;
