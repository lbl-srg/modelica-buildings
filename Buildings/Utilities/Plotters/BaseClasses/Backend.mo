within Buildings.Utilities.Plotters.BaseClasses;
class Backend "Backend implementation for the plotter"
extends ExternalObject;
    function constructor
      "Construct the data structure that allows multiple plotters writing to the same html file"
      input String fileName "Name of html file to which this block prints";
      input String instanceName "Name of the instance of this plotter";
      input Integer nDbl "Number of double values in the array that is sent at each sampling time";
      output Backend plt "Pointer to data structure for this plotter";
      external "C" plt = plotInit(fileName, instanceName, nDbl)
    annotation(Include="#include <plotInit.c>",
    IncludeDirectory="modelica://Buildings/Resources/C-Sources");
    annotation(Documentation(info="<html>
<p>
The function <code>constructor</code> is a C function that is called by a Modelica simulator
exactly once during the initialization.
The function returns the object <code>Backend</code> that
will be used to store data that will be plotted to an html file.
</p>
<h4>Implementation</h4>
<p>
This function has been implemented to allow mutiple plotters to write
their plots to the same html file.
</p>
</html>", revisions="<html>
<ul>
<li>
March 23, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
    end constructor;

  function destructor "Release storage of plotter backend"
    input Backend plt;
    external "C" plotFree(plt)
    annotation(Include=" #include <plotFree.c>",
    IncludeDirectory="modelica://Buildings/Resources/C-Sources");
  annotation(Documentation(info="<html>
<p>
Destructor that frees the memory of the object
<code>Backend</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 23, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end destructor;
annotation(Documentation(info="<html>
<p>
Class derived from <code>ExternalObject</code> having two local external function definitions,
named <code>destructor</code> and <code>constructor</code> respectively.
<p>
These functions create and release an external object that allows
multiple plotters to write to the same html output file.

</html>",
revisions="<html>
<ul>
<li>
March 23, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Backend;
