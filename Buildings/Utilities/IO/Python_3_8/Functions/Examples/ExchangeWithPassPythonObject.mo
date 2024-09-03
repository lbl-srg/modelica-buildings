within Buildings.Utilities.IO.Python_3_8.Functions.Examples;
model ExchangeWithPassPythonObject
  "Test model for exchange function with memory"
  extends Modelica.Icons.Example;

  parameter Boolean passPythonObject = true
    "Set to true if the Python function returns and receives an object, see User's Guide";
  Buildings.Utilities.IO.Python_3_8.Functions.BaseClasses.PythonObject pytObj=
      Buildings.Utilities.IO.Python_3_8.Functions.BaseClasses.PythonObject();

  parameter Real yR1[1](each fixed=false) "Real function value";
  parameter Real yR2[1](each fixed=false) "Real function value";

initial equation
  yR1 = Buildings.Utilities.IO.Python_3_8.Functions.exchange(
    moduleName="testFunctions",
    functionName="r1_r1PassPythonObject",
    dblWri={2.0},
    intWri={0},
    nDblWri=1,
    nDblRea=1,
    nIntWri=0,
    nIntRea=0,
    nStrWri=0,
    strWri={""},
    pytObj=pytObj,
    passPythonObject=passPythonObject);
  assert(abs(3-yR1[1]) < 1e-5, "Error in function r1_r1PassPythonObject");

  // Invoke the same function with the same Python object.
  // Hence, pytObj is reused.
  yR2 = Buildings.Utilities.IO.Python_3_8.Functions.exchange(
    moduleName="testFunctions",
    functionName="r1_r1PassPythonObject",
    dblWri=yR1,
    intWri={0},
    nDblWri=1,
    nDblRea=1,
    nIntWri=0,
    nIntRea=0,
    nStrWri=0,
    strWri={""},
    pytObj=pytObj,
    passPythonObject=passPythonObject);
    assert(abs(16-yR2[1]) < 1e-5, "Error in function r1_r1PassPythonObject");

  annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/IO/Python_3_8/Functions/Examples/ExchangeWithPassPythonObject.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example calls various functions in the Python module <code>testFunctions.py</code>.
It tests whether arguments and return values are passed correctly.
The functions in  <code>testFunctions.py</code> are very simple in order to test
whether they compute correctly, and whether the data conversion between Modelica and
Python is implemented correctly.
Each call to Python is followed by an <code>assert</code> statement which terminates
the simulation if the return value is different from the expected value.
</p>
</html>", revisions="<html>
<ul>
<li>
January 10, 2022, by Michael Wetter:<br/>
Updated to Python 3.8.
</li>
<li>
December 11, 2021, by Michael Wetter:<br/>
Changed implementation to assigning parameters as opposed to variables because the
assignment is made through impure function calls.
This is for MSL 4.0.0.
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
end ExchangeWithPassPythonObject;
