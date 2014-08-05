within Buildings.Electrical.Transmission.Benchmarks;
model DataSeries_v2 "Benchmark data"
  parameter String fileName_PV = "modelica://Buildings/Resources/Data/Electrical/Benchmark/load_PV.mat";
  parameter String fileName_buildings = "modelica://Buildings/Resources/Data/Electrical/Benchmark/SLP_33buildings.mat";
  parameter String fName_PV = Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(fileName_PV);
  parameter String fName_buildings = Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(fileName_buildings);
  Modelica.Blocks.Sources.CombiTimeTable node_loads(
    tableOnFile=true,
    tableName="SLP_33buildings",
    columns=2:34,
    fileName=fName_buildings,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Modelica.Blocks.Interfaces.RealOutput bldg[33]
    "fixme: update comment to something more descriptive. Connector of Real output signals"
                                                                                            annotation (Placement(transformation(
          extent={{100,-50},{120,-30}}),iconTransformation(extent={{80,-50},{100,
            -30}})));
equation
  // fixme: Don't mix graphical modeling with equations (see style guide).
  // Use a constant gain of -1 instead of this loop.
  for i in 1:33 loop
    bldg[i] = -node_loads.y[i];
  end for;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Text(
          extent={{-100,20},{100,-20}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="benchmark
data"), Text(
          extent={{0,100},{100,60}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="PV"),
        Text(
          extent={{0,-60},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Loads")}));
end DataSeries_v2;
