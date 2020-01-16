within Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Examples;
model ConstantFlowRC
  "Case with constant district water mass flow rate, RC building models (1 zone)"
  extends
    Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Examples.BaseClasses.PartialSeriesRC(
      datDes(epsPla=0.935));
  Modelica.Blocks.Sources.Constant massFlowMainPump(
    k=datDes.mDis_flow_nominal)
    "Distribution pump mass flow rate"
    annotation (Placement(transformation(extent={{-380,-70},{-360,-50}})));
equation
  connect(massFlowMainPump.y, pumpMainRLTN.m_flow_in)
    annotation (Line(points={{-359,-60},{60,-60},{60,-80},{68,-80}},
                                                color={0,0,127}));
  connect(pumpBHS.m_flow_in, massFlowMainPump.y)
    annotation (Line(points={{-160,-108},{-160,-60},{-359,-60}},
    color={0,0,127}));
  annotation (
  Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-480,-440},{480,440}}),
    graphics={
    Text(
    extent={{-272,-296},{68,-376}},
    lineColor={28,108,200},
    horizontalAlignment=TextAlignment.Left,
    textString="Simulation is faster with 

Advanced.SparseActivate=true")}),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Examples/DistrictReservoirNetworks/Examples/Reservoir1Constant.mos"
  "Simulate and plot"),
  experiment(
    StopTime=172800,
    Tolerance=1e-06,
    __Dymola_Algorithm="Cvode"));
end ConstantFlowRC;
