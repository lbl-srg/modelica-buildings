within IceStorage.Data.IceThermalStorage;
record EnergyPlus =
  IceStorage.Data.IceThermalStorage.Generic (
    coeCha={0.318,0,0,0,0,0},
    dtCha = 3600,
    coeDisCha={0.0,0.09,-0.15,0.612,-0.324,-0.216},
    dtDisCha = 3600) "Performance curve obtained from EnergyPlus example"
   annotation (
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
