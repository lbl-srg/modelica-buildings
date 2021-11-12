within Buildings.Templates;
package Types
  extends Modelica.Icons.TypesPackage;
  type ChilledWaterPlant = enumeration(
      AirCooledParallel
      "Air cooled parallel chiller plant",
      AirCooledSeries
      "Air cooled series chiller plant",
      WaterCooledParallel
      "Water cooled parallel chiller plant",
      WaterCooledSeries
      "Water cooled series chiller plant");
end Types;
