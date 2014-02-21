within Buildings.Electrical.Transmission.Benchmark;
model DataSeries_v1 "Benchmark data"
  parameter Real factorB = 1.0
    "Multiply the power consumed by buildings by this factor";
  parameter Real factorPV = 1.0
    "Multiply the power produced by the PV panels by this factor";
  parameter String fileName_PV = "modelica://Buildings/Resources/Data/Electrical/Benchmark/load_PV.mat";
  parameter String fileName_buildings = "modelica://Buildings/Resources/Data/Electrical/Benchmark/SLP_33buildings.mat";
  parameter String fName_PV = Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(fileName_PV);
  parameter String fName_buildings = Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(fileName_buildings);
  Modelica.Blocks.Sources.CombiTimeTable pv_loads(
    tableOnFile=true,
    tableName="load_PV",
    columns=2:17,
    fileName=fName_PV)
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Modelica.Blocks.Sources.CombiTimeTable node_loads(
    tableOnFile=true,
    tableName="SLP_33buildings",
    columns=2:34,
    fileName="/home/marco/Documents/Projects/District/NewBranch-Electrical/modelica-buildings/Buildings/Resources/Data/Electrical/Benchmark/SLP_33buildings.mat")
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Modelica.Blocks.Interfaces.RealOutput pv[16]
    "Connector of Real output signals" annotation (Placement(transformation(
          extent={{80,30},{100,50}}), iconTransformation(extent={{80,30},{100,50}})));
  Modelica.Blocks.Interfaces.RealOutput bldg[33]
    "Connector of Real output signals" annotation (Placement(transformation(
          extent={{80,-50},{100,-30}}), iconTransformation(extent={{80,-50},{100,
            -30}})));
  Modelica.Blocks.Math.Gain b_factor[33](each k=-factorB)
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Modelica.Blocks.Math.Gain pv_factor[16](each k=factorPV)
    annotation (Placement(transformation(extent={{22,30},{42,50}})));
equation
  connect(node_loads.y,b_factor. u) annotation (Line(
      points={{-19,-40},{18,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(b_factor.y, bldg) annotation (Line(
      points={{41,-40},{90,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pv_loads.y, pv_factor.u) annotation (Line(
      points={{-19,40},{20,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pv_factor.y, pv) annotation (Line(
      points={{43,40},{90,40}},
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
end DataSeries_v1;
