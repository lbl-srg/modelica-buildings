within Buildings.Applications.DHC.Examples.FifthGeneration.UnidirectionalSeries.Examples;
model Reservoir1Constant
  "Reservoir network with simple control and 0.08m pipe diameter"
  extends Modelica.Icons.Example;
  extends
    Buildings.Applications.DHC.Examples.FifthGeneration.UnidirectionalSeries.Examples.BaseClasses.RN_BaseModel(
      datDes(
      epsPla=0.935));
  Modelica.Blocks.Sources.Constant massFlowMainPump(
    k(final unit="kg/s")=datDes.mDis_flow_nominal)
    "Pump mass flow rate"
    annotation (Placement(transformation(extent={{-44,-390},{-24,-370}})));
equation
  connect(massFlowMainPump.y, pumpMainRLTN.m_flow_in)
    annotation (Line(points={{-23,
          -380},{34,-380},{34,-360},{68,-360}}, color={0,0,127}));
  connect(pumpBHS.m_flow_in, massFlowMainPump.y)
    annotation (Line(points={{50,-428},{50,-380},{-23,-380}},
    color={0,0,127}));
  annotation (
  Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-480,-480},{420,420}})),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/DistrictReservoirNetworks/Examples/Reservoir1Constant.mos"
  "Simulate and plot"),
  experiment(
    StopTime=172800,
    Tolerance=1e-06,
    __Dymola_Algorithm="Cvode"));
end Reservoir1Constant;
