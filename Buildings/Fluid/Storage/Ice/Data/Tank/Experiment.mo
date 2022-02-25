within Buildings.Fluid.Storage.Ice.Data.Tank;
record Experiment =
  Buildings.Fluid.Storage.Ice.Data.Tank.Generic (
    mIce_max = 2846.35,
    coeCha={1.76953858E-04,0,0,0,0,0},
    dtCha=10,
    coeDisCha={5.54E-05,-1.45679E-04,9.28E-05,1.126122E-03,-1.1012E-03,
        3.00544E-04},
    dtDisCha=10)   "Performance curve obtained from onsite experiment"
   annotation (defaultComponentName="per",
    Documentation(info="<html>
<p>
The performance curves are obtained from experiments demonstrated in the following reference.
</p>
<h4>Reference</h4>
<p>
Pradhan, Ojas, et.al. \"Development and Validation of a Simulation Testbed for the Intelligent Building Agents Laboratory (IBAL) using TRNSYS.\" 
ASHRAE Transactions 126 (2020): 458-466.
</p>
<p>
Li, Guowen, et al. \"An Ice Storage Tank Modelica Model: Implementation and Validation.\" Modelica Conferences. 2021.
</p>
</html>"));
