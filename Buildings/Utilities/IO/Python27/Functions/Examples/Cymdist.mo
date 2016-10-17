within Buildings.Utilities.IO.Python27.Functions.Examples;
model Cymdist "Test model for cymdist function"
  extends Modelica.Icons.Example;

  Real    yR2[2] "Real function value";
algorithm
  yR2 := Buildings.Utilities.IO.Python27.Functions.cymdist(
      moduleName="testFunctionsCymdist",
      functionName="r2p2_r2",
      nDblInp=2,
      dblInpNam={"u", "u1"},
      dblInpVal={1.0, 2.0},
      nDblOut=2,
      dblOutNam={"y","y1"},
      nDblPar=2,
      dblParNam={"par1", "par2"},
      dblParVal={1.0, 10.0});
      assert(abs(yR2[1]-1) + abs(yR2[2]-20) < 1E-5, "Error in function r2p2_r2");

  annotation (
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/IO/Python27/Functions/Examples/Exchange.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example calls various functions in the Python module <code>testFunctionsCymdist.py</code>.
It tests whether arguments and return values are passed correctly.
The functions in  <code>testFunctionsCymdist.py</code> are very simple in order to test
whether they compute correctly, and whether the data conversion between Modelica and
Python is implemented correctly.
Each call to Python is followed by an <code>assert</code> statement which terminates
the simulation if the return value is different from the expected value.
</p>
</html>", revisions="<html>
<ul>
<li>
October 17, 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"));
end Cymdist;
