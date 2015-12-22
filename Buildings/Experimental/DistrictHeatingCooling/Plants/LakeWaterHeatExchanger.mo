within Buildings.Experimental.DistrictHeatingCooling.Plants;
model LakeWaterHeatExchanger "Heat exchanger with lake"
  parameter String filNam="modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/Plants/AlamedaOceanT.mos"
    "Name of data file with water temperatures"                                                                            annotation (Dialog(
        loadSelector(filter="Temperature file (*.mos)", caption=
            "Select temperature file")));

  Modelica.Blocks.Sources.CombiTimeTable lakTem(
    tableOnFile=true,
    tableName="tab1",
    fileName=Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(filNam),
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    y(unit="K")) "Temperature of the lake"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.CombiTimeTable lakTem1(
    tableOnFile=true,
    tableName="tab1",
    fileName=Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(filNam),
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(unit="K")) "Temperature of the lake"
    annotation (Placement(transformation(extent={{-4,-46},{16,-26}})));
end LakeWaterHeatExchanger;
