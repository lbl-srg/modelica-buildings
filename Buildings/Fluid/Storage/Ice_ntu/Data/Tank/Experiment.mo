within Buildings.Fluid.Storage.Ice_ntu.Data.Tank;
record Experiment =
  Buildings.Fluid.Storage.Ice_ntu.Data.Tank.Generic
  ( Vtank=1655*0.00378541,
    Dtank=89*0.0254,
    Htank=101*0.0254,
    coeCha={4.950E04,-1.262E05,2.243E05,-1.455E05},
    coeDisCha={1.848E03,7.429E04,-1.419E05,9.366E04},
    coeWatliq={4.21534,-0.00287819,7.4729E-05,-7.79624E-07,3.220424E-09})
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
