within Buildings.Utilities.IO.Python27;
class PythonMemory
  "class used to create the external object: PythonMemory"
extends ExternalObject;
    function constructor
    "Construct an extendable array that can be used to store double values"
    output PythonMemory memory;
    external "C" memory = initPythonMemory()
    annotation(Include="#include <initPythonMemory.c>",
    IncludeDirectory="modelica://Buildings/Resources/C-Sources");
    annotation(Documentation(info="<html>
<p>
The function <code>constructor</code> is a C function that is called by a Modelica simulator
exactly once during the initialization.
The function returns the object <code>ExtendableArray</code> that
will be used to store double values in the function
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Ground.Boreholes.BaseClasses.storeValues\">
Buildings.Fluid.HeatExchangers.Ground.Boreholes.BaseClasses.storeValues</a>.
</p>
<h4>Implementation</h4>
<p>
This function has been implemented to allow storing an increasing number of
double values. Since Modelica requires the size of an array to be known at
compile time, the implementation is done in a C function.
</p>
</html>", revisions="<html>
<ul>
<li>
July 28 2011, by Pierre Vigouroux:<br/>
First implementation.
</li>
</ul>
</html>"));
    end constructor;

  function destructor "Release memory"
    input PythonMemory memory;
    external "C" freePythonMemory(memory)
    annotation(Include=" #include <freePythonMemory.c>",
    IncludeDirectory="modelica://Buildings/Resources/C-Sources");
  annotation(Documentation(info="<html>
<p>
Destructor that frees the memory of the object
<code>ExtendableArray</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 5, 2011, by Michael Wetter:<br/>
Fixed bug in <code>freeArray.c</code>, which called <code>free(table->n)</code>,
where <code>n</code> is an <code>int</code>. This caused Dymola 2012-FD01 to hang.
</li>
<li>
July 27, 2011, by Pierre Vigouroux:<br/>
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
end PythonMemory;
