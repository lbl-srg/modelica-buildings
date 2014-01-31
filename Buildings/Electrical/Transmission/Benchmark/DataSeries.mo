within Buildings.Electrical.Transmission.Benchmark;
model DataSeries "Benchmark data"

  Modelica.Blocks.Sources.CombiTimeTable pv_loads(
    tableOnFile=true,
    tableName="load_PV",
    columns=2:17,
    fileName=
        Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath("modelica://Buildings/Resources/Data/Electrical/Benchmark/load_PV.txt"))
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Modelica.Blocks.Sources.CombiTimeTable node_loads(
    tableOnFile=true,
    tableName="SLP_33buildings",
    columns=2:34,
    fileName=
        Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath("modelica://Buildings/Resources/Data/Electrical/Benchmark/SLP_33buildings.txt"))
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Modelica.Blocks.Interfaces.RealOutput pv[16]
    "Connector of Real output signals" annotation (Placement(transformation(
          extent={{80,30},{100,50}}), iconTransformation(extent={{80,30},{100,50}})));
  Modelica.Blocks.Interfaces.RealOutput bldg[33]
    "Connector of Real output signals" annotation (Placement(transformation(
          extent={{80,-50},{100,-30}}), iconTransformation(extent={{80,-50},{100,
            -30}})));
equation
  connect(pv_loads.y, pv) annotation (Line(
      points={{-19,40},{90,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(node_loads.y, bldg) annotation (Line(
      points={{-19,-40},{90,-40}},
      color={0,0,127},
      smooth=Smooth.None));
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
end DataSeries;
