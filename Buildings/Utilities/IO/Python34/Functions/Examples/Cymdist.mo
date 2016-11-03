within Buildings.Utilities.IO.Python34.Functions.Examples;
model Cymdist "Test model for cymdist functions"
  extends Modelica.Icons.Example;
  Real yR1[1] "Real function value";
  Real yR2[2] "Real function value";
  parameter Integer resWri=0 "Flag for results writing";
  // The inputFileName should be provided
  // using Modelica.Utilitites.loadResource().
  parameter String inputFileName="cymdist.inp";
  // Parameters names can be empty.
  // Inputs and outputs cannot be empty.
  parameter String emptyDblParNam[0] "Empty list of parameters names";
  parameter Real emptyDblParVal[0]=zeros(0) "Empty vector of parameters values";

algorithm

  yR1 := Buildings.Utilities.IO.Python34.Functions.cymdist(
    moduleName="testCymdist",
    functionName="r1_r1",
    inputFileName=inputFileName,
    nDblInp=1,
    dblInpNam={"u"},
    dblInpVal={15.0},
    nDblOut=1,
    dblOutNam={"y"},
    dblOutDevNam={"dev"},
    nDblPar=0,
    dblParNam=emptyDblParNam,
    dblParVal=emptyDblParVal,
    resWri=resWri);
  assert(abs(15 - yR1[1]) < 1e-5, "Error in function r1_r1");

  yR1 := Buildings.Utilities.IO.Python34.Functions.cymdist(
    moduleName="testCymdist",
    functionName="r2_r1",
    inputFileName=inputFileName,
    nDblInp=2,
    dblInpNam={"u","u1"},
    dblInpVal={15.0,30.0},
    nDblOut=1,
    dblOutNam={"y"},
    dblOutDevNam={"dev"},
    nDblPar=0,
    dblParNam=emptyDblParNam,
    dblParVal=emptyDblParVal,
    resWri=resWri);
  assert(abs(45 - yR1[1]) < 1e-5, "Error in function r2_r1");

  yR1 := Buildings.Utilities.IO.Python34.Functions.cymdist(
    moduleName="testCymdist",
    functionName="par3_r1",
    inputFileName=inputFileName,
    nDblInp=0,
    dblInpNam={""},
    dblInpVal={0},
    nDblOut=1,
    dblOutNam={"y"},
    dblOutDevNam={"dev"},
    nDblPar=3,
    dblParNam={"par1","par2","par3"},
    dblParVal={1.0,2.0,3.0},
    resWri=resWri);
  assert(abs(6 - yR1[1]) < 1e-5, "Error in function par3_r1");

  yR2 := Buildings.Utilities.IO.Python34.Functions.cymdist(
    moduleName="testCymdist",
    functionName="r1_r2",
    inputFileName=inputFileName,
    nDblInp=1,
    dblInpNam={"u"},
    dblInpVal={30.0},
    nDblOut=2,
    dblOutNam={"y","y1"},
    dblOutDevNam={"dev","dev1"},
    nDblPar=0,
    dblParNam=emptyDblParNam,
    dblParVal=emptyDblParVal,
    resWri=resWri);
  assert(abs(yR2[1] - 30) + abs(yR2[2] - 60) < 1E-5, "Error in function r1_r2");

  yR2 := Buildings.Utilities.IO.Python34.Functions.cymdist(
    moduleName="testCymdist",
    functionName="r2p2_r2",
    inputFileName=inputFileName,
    nDblInp=2,
    dblInpNam={"u","u1"},
    dblInpVal={1.0,2.0},
    nDblOut=2,
    dblOutNam={"y","y1"},
    dblOutDevNam={"dev","dev1"},
    nDblPar=2,
    dblParNam={"par1","par2"},
    dblParVal={1.0,10.0},
    resWri=resWri);
  assert(abs(yR2[1] - 1) + abs(yR2[2] - 20) < 1E-5, "Error in function r2p2_r2");

  annotation (
    experiment(StopTime=1.0),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/IO/Python34/Functions/Examples/Cymdist.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example calls various functions in the Python module <code>testCymdist.py</code>.
It tests whether arguments and return values are passed correctly.
The functions in  <code>testCymdist.py</code> are very simple in order to test
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
