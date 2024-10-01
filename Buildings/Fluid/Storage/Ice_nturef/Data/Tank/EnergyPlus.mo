within Buildings.Fluid.Storage.Ice_nturef.Data.Tank;
record EnergyPlus =
  Buildings.Fluid.Storage.Ice_nturef.Data.Tank.Generic
                                                (
    coeCha={0.0,0.09,-0.15,0.612,-0.324,-0.216},
    dtCha=3600,
    coeDisCha={0.0,0.09,-0.15,0.612,-0.324,-0.216},
    dtDisCha=3600)   "Performance curve obtained from EnergyPlus example"
   annotation (defaultComponentName="per",
    Documentation(info="<html>
<p>
The performance curves are obtained from the EnergyPlus example idf file: 
<a href = \"https://github.com/NREL/EnergyPlus/blob/0474bcff0f09143605459c4168e69a17d49e7dd1/testfiles/5ZoneDetailedIceStorage.idf#L3137\">5ZoneDetailedIceStorage.idf</a>.
</p>

</html>"));
