within Buildings.ThermalZones.ReducedOrder.Validation;
model RoomWithLatentGain
  "Test case based on VDI 6007 Case 12, with latent heat gain added"
  extends VDI6007.TestCase12(
    redeclare package Medium = Buildings.Media.Air,
    thermalZoneTwoElements(use_moisture_balance=true,
    nPorts=4,
    VAir=52.5),
    assEqu(
      startTime=0,
      endTime=0,
      startTime2=0,
      endTime2=0,
      startTime3=0,
      endTime3=0));
  Fluid.Sensors.RelativeHumidity senRelHum(
    redeclare package Medium = Medium)
    "Relative humidity of room air"
    annotation (Placement(transformation(extent={{110,-20},{130,0}})));
  Fluid.Sensors.MassFraction senMasFra(
    redeclare package Medium = Medium)
    "Absolute humidity of room air in kg/kg total air"
    annotation (Placement(transformation(extent={{110,-50},{130,-30}})));
equation
  connect(senRelHum.port, thermalZoneTwoElements.ports[3]) annotation (Line(
        points={{120,-20},{83,-20},{83,-1.95}}, color={0,127,255}));
  connect(senMasFra.port, thermalZoneTwoElements.ports[4]) annotation (Line(
        points={{120,-50},{83,-50},{83,-1.95}}, color={0,127,255}));
  connect(intGai.y[2], thermalZoneTwoElements.QLat_flow) annotation (Line(
        points={{22.8,-52},{32,-52},{32,4},{43,4},{43,4}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
Test Case 12 of the VDI 6007 Part 1: Calculation of indoor air temperature
excited by a radiative and convective heat source for room version S.</p>
<h4>Boundary conditions</h4>
<p>
This test case changes the medium to moist air, and adds latent heat gain.
</p>
</html>", revisions="<html>
<ul>
<li>
October 9, 2019, by Michael Wetter:<br/>
First implementation.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1209\">IBPSA, issue 1209</a>.
</li>
</ul>
</html>"),
experiment(
      StopTime=604800,
      Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ReducedOrder/Validation/RoomWithLatentGain.mos"
  "Simulate and plot"),
    Diagram(coordinateSystem(extent={{-140,-100},{140,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end RoomWithLatentGain;
