within Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines;
package Examples
  extends Modelica.Icons.ExamplesPackage;
  model ACline

    Sources.FixedVoltage fixedVoltage(
      f=50,
      V=380,
      Phi=0) annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
    Line line(
      l=2000,
      P_nominal=5000,
      V_nominal=380,
      mode=Buildings.Electrical.Types.CableMode.commercial,
      voltageLevel=Buildings.Electrical.Types.VoltageLevel.Low,
      commercialCable_low=
          Buildings.Electrical.Transmission.LowVoltageCables.PvcAl70())
      annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
    Loads.InductiveLoadP inductiveLoadP(
      mode=Buildings.Electrical.Types.Assumption.FixedZ_steady_state,
      P_nominal=4000,
      V_nominal=380)
      annotation (Placement(transformation(extent={{0,-10},{20,10}})));
    Modelica.Blocks.Sources.CombiTimeTable pv_loads(
      tableOnFile=true,
      tableName="load_PV",
      columns=2:17,
      fileName=
          Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(
          "modelica://Buildings/Resources/Data/Electrical/Benchmark/load_PV.txt"))
      annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
    Modelica.Blocks.Sources.CombiTimeTable node_loads(
      tableOnFile=true,
      tableName="SLP_33buildings",
      columns=2:34,
      fileName=
          Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(
          "modelica://Buildings/Resources/Data/Electrical/Benchmark/SLP_33buildings.txt"))
      annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  equation
    connect(fixedVoltage.terminal, line.terminal_n) annotation (Line(
        points={{-60,0},{-40,0}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(line.terminal_p, inductiveLoadP.terminal_p) annotation (Line(
        points={{-20,0},{-4.44089e-16,0}},
        color={0,120,120},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics));
  end ACline;
end Examples;
