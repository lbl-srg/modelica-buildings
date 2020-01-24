within Buildings.Examples.DistrictReservoirNetworks;
model Reservoir1Constant
  "Reservoir network with simple control"
  extends Modelica.Icons.Example;
  extends
    Buildings.Examples.DistrictReservoirNetworks.BaseClasses.RN_BaseModel(
    datDes(
      mDisPip_flow_nominal=95,
      RDisPip=250,
      epsPla=0.935));
  Modelica.Blocks.Sources.Constant massFlowMainPump(
    k(final unit="kg/s")=datDes.mDisPip_flow_nominal) "Pump mass flow rate"
    annotation (Placement(transformation(extent={{0,-300},{20,-280}})));
equation
  connect(massFlowMainPump.y, pumDisLop.m_flow_in)
    annotation (Line(points={{21,-290},{68,-290}}, color={0,0,127}));
  connect(pumpBHS.m_flow_in, massFlowMainPump.y)
    annotation (Line(points={{50,-428},{50,-290},{21,-290}},color={0,0,127}));
  annotation (
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-480},{380,360}})),
        __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/DistrictReservoirNetworks/Reservoir1Constant.mos"
        "Simulate and plot"),
    experiment(StopTime=31536000,
    Tolerance=1e-06, __Dymola_NumberOfIntervals=8760),
    Documentation(info="<html>
<p>
Model of reservoir network,
</p>
<p>
In this model, the temperature of the district loop is stabilized
through the operation of the plant and the borefield.
The main circulation pump has a constant mass flow rate.
Each substation, or agent, takes water from the main district loop
and feeds its return water back into the main district loop downstream
from the intake.
The pipes of the main loop are designed for a pressure drop
of <i>250</i> Pa/m at the design flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
January 12, 2020, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end Reservoir1Constant;
