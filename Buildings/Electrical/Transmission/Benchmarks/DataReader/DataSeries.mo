within Buildings.Electrical.Transmission.Benchmarks.DataReader;
model DataSeries "Benchmark power data for buildings load and PV panels"
  parameter Real factorB = 1.0
    "Multiply the power consumed by buildings by this factor";
  parameter Real factorPV = 1.0
    "Multiply the power produced by the PV panels by this factor";
  parameter String fileName_PV = "modelica://Buildings/Resources/Data/Electrical/Benchmark/pvload_hot.mat"
    "File that copntains the data of the PVs";
  parameter String fileName_buildings = "modelica://Buildings/Resources/Data/Electrical/Benchmark/hhload_hot.mat"
    "File that contains the data of the buildings";
  Modelica.Blocks.Sources.CombiTimeTable pv_loads(
    tableOnFile=true,
    columns=2:40,
    fileName=
        Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(fileName_PV),
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableName="pvload") "Table that reads the PV power data from file"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Modelica.Blocks.Sources.CombiTimeTable node_loads(
    tableOnFile=true,
    columns=2:40,
    fileName=
        Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(fileName_buildings),
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableName="hhload") "Table that reads the building power data from file"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Modelica.Blocks.Interfaces.RealOutput pv[39] "Power produced by the PVs"
                                annotation (Placement(transformation(
          extent={{80,30},{100,50}}), iconTransformation(extent={{80,30},{100,50}})));
  Modelica.Blocks.Interfaces.RealOutput bldg[39]
    "Power consumed by the buildings" annotation (Placement(transformation(
          extent={{80,-50},{100,-30}}), iconTransformation(extent={{80,-50},{100,
            -30}})));
  Modelica.Blocks.Math.Gain b_factor[39](each k=-factorB)
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Modelica.Blocks.Math.Gain pv_factor[39](each k=-factorPV)
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
  annotation ( Icon(coordinateSystem(
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
          textString="Loads")}),
    Documentation(info="<html>
<p>
This model reads time series data from .mat files and provides
them as output signals. The data series represent the power
produced by PV panels and the power consumed by buildings in a
network with up to 50 nodes.
</p>
</html>", revisions="<html>
<ul>
<li>
Sept 19 2014 by Marco Bonvini:</br>
Added documentation
</li>
</ul>
</html>"));
end DataSeries;
