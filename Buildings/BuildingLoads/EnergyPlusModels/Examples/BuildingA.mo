within Buildings.BuildingLoads.EnergyPlusModels.Examples;
model BuildingA "Example test for building A"
  import Buildings;
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Constant SP_Cool(k=26)
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Blocks.Sources.Constant SP_Heat(k=22)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.BuildingLoads.EnergyPlusModels.BuildingA buildingA(
    fmi_StartTime=0,
    fmi_CommunicationStepSize=900,
    fmi_StopTime=172800)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
equation
  connect(SP_Heat.y, buildingA.Tsp_Heat) annotation (Line(
      points={{-79,30},{-68,30},{-68,14},{-58,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SP_Cool.y, buildingA.Tsp_Cool) annotation (Line(
      points={{-79,-10},{-68,-10},{-68,5.8},{-58,5.8}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{
            -100,-100},{100,100}}), graphics));
end BuildingA;
