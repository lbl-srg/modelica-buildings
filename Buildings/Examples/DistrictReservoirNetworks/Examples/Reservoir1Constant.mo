within Buildings.Examples.DistrictReservoirNetworks.Examples;
model Reservoir1Constant
  "Reservoir network with simple control and 0.08m pipe diameter"
  extends Modelica.Icons.Example;
  extends
    Buildings.Examples.DistrictReservoirNetworks.Examples.BaseClasses.RN_BaseModel(
    datDes(
      mDisPip_flow_nominal=95,
      RDisPip=250,
      epsPla=0.935));
  Modelica.Blocks.Sources.Constant massFlowMainPump(
    k(final unit="kg/s")=datDes.mDisPip_flow_nominal) "Pump mass flow rate"
    annotation (Placement(transformation(extent={{-20,-380},{0,-360}})));
equation
  connect(massFlowMainPump.y, pumpMainRLTN.m_flow_in) annotation (Line(points={{1,-370},
          {68,-370}},                              color={0,0,127}));
  connect(pumpBHS.m_flow_in, massFlowMainPump.y)
    annotation (Line(points={{50,-428},{50,-370},{1,-370}}, color={0,0,127}));
  annotation (
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-480},{380,360}})),
        __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/DistrictReservoirNetworks/Examples/Reservoir1Constant.mos"
        "Simulate and plot"),
    experiment(StopTime=31536000,
    Tolerance=1e-06, __Dymola_NumberOfIntervals=8760));
end Reservoir1Constant;
