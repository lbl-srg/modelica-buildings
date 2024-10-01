within Buildings.Fluid.Storage.Ice_ntu_bis.Data.Tank;
record Experiment =
  Buildings.Fluid.Storage.Ice_ntu_bis.Data.Tank.Generic
  (coeCha={4.950E04,-1.262E05,2.243E05,-1.455E05}, coeDisCha={1.848E03,7.429E04,
        -1.419E05,9.366E04})
  "Performance curve obtained from onsite experiment"
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
