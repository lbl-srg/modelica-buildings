within Buildings.HeatTransfer.Conduction.BaseClasses;
class CTFData
  "Class used to store the CTF data between the invocation of the C functions"
extends ExternalObject;
    function constructor
    "Construct an extendable array that can be used to store double values"
    output CTFData ctfData;
    external "C" ctfData = initCTFData()
    annotation(Include="#include <initCTFData.c>",
    IncludeDirectory="modelica://Buildings/Resources/C-Sources");
    annotation(Documentation(info="<html>
<p>
The function <code>constructor</code> is a C function that is called by a Modelica simulator
exactly once during the initialization.
The function returns the object <code>ctfData</code> that
will be used to store double the data for the CTF method
between function calls.
</p>
</html>", revisions="<html>
<ul>
<li>
January 12, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
    end constructor;

  function destructor "Release storage of table and close the external object"
    input CTFData ctfData;
    external "C" freeCTFData(ctfData)
    annotation(Include=" #include <freeCTFData.c>",
    IncludeDirectory="modelica://Buildings/Resources/C-Sources");
  annotation(Documentation(info="<html>
<p>
Destructor that frees the memory of the object
<code>cTFData</code>.
</p>
</html>",
   revisions="<html>
<ul>
<li>
January 12, 2017, by Michael Wetter:<br/>
First implementation
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
of real parameters in an data structure that is managed in C.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 12, 2017, by Michael Wetter:<br/>
First implementation
</li>
</ul>
</html>"));
end CTFData;
