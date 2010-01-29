within Buildings.HeatTransfer;
package Data "Data for heat transfer models"
  record Solids "Thermal properties of solids"
      extends Modelica.Icons.Record;
   Modelica.SIunits.ThermalConductivity k "Thermal conductivity";
   Modelica.SIunits.Density d "Mass density";
   Modelica.SIunits.SpecificHeatCapacity c "Specific heat capacity";
  end Solids;

  record Brick = Solids(k=0.89, d=1920, c=790) "Brick (k=0.89)";
  record InsulationBoard = Solids(k=0.03, d=40, c=1200)
    "Insulation board (k=0.03)";
  record GypsumBoard = Solids(k=0.58, d=800, c=1090) "Gypsum board (k=0.58)";
  record Plywood = Solids(k=0.12, d=540, c=1210) "Plywood (k=0.12)";

  annotation (Documentation(info="<html>
Package with thermal properties of solid materials.
</html>"));
end Data;
