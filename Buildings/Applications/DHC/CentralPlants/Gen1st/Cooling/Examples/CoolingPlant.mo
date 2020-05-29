within Buildings.Applications.DHC.CentralPlants.Gen1st.Cooling.Examples;
model CoolingPlant "Example to test the chiller cooling plant"
  extends Modelica.Icons.Example;
  Buildings.Applications.DHC.CentralPlants.Gen1st.Cooling.CoolingPlant
    coolingPlant
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CoolingPlant;
