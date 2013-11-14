within Buildings.BuildingLoads.EnergyPlusModels.Examples;
model AllBuildings "Example testing all the buildings together"
  import Buildings;
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Constant SP_Cool(k=26)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.Constant SP_Heat(k=22)
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.BuildingLoads.EnergyPlusModels.BuildingA buildingA(fmi_StopTime=
        2592000)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.BuildingLoads.EnergyPlusModels.BuildingB buildingB(fmi_StopTime=
        2592000)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.BuildingLoads.EnergyPlusModels.BuildingC buildingC(fmi_StopTime=
        2592000)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.BuildingLoads.EnergyPlusModels.BuildingD buildingD(fmi_StopTime=
        2592000)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.BuildingLoads.EnergyPlusModels.BuildingE buildingE(fmi_StopTime=
        2592000)
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
equation
  connect(SP_Heat.y, buildingA.Tsp_Heat) annotation (Line(
      points={{-79,70},{-68,70},{-68,74},{-58,74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SP_Heat.y, buildingB.Tsp_Heat) annotation (Line(
      points={{-79,70},{-70,70},{-70,34},{-58,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SP_Heat.y, buildingC.Tsp_Heat) annotation (Line(
      points={{-79,70},{-70,70},{-70,-6},{-58,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SP_Heat.y, buildingD.Tsp_Heat) annotation (Line(
      points={{-79,70},{-70,70},{-70,-46},{-58,-46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SP_Heat.y, buildingE.Tsp_Heat) annotation (Line(
      points={{-79,70},{-70,70},{-70,-86},{-58,-86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SP_Cool.y, buildingB.Tsp_Cool) annotation (Line(
      points={{-79,30},{-74,30},{-74,25.8},{-58,25.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SP_Cool.y, buildingA.Tsp_Cool) annotation (Line(
      points={{-79,30},{-74,30},{-74,65.8},{-58,65.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SP_Cool.y, buildingC.Tsp_Cool) annotation (Line(
      points={{-79,30},{-74,30},{-74,-14.2},{-58,-14.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SP_Cool.y, buildingD.Tsp_Cool) annotation (Line(
      points={{-79,30},{-74,30},{-74,-54.2},{-58,-54.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SP_Cool.y, buildingE.Tsp_Cool) annotation (Line(
      points={{-79,30},{-74,30},{-74,-94.2},{-58,-94.2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end AllBuildings;
