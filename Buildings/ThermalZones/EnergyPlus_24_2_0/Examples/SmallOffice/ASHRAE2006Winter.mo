within Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice;
model ASHRAE2006Winter
  "Variable air volume flow system with terminal reheat and five thermal zones using a control sequence published by ASHRAE in 2006"
  extends Modelica.Icons.Example;
  extends Buildings.Examples.VAVReheat.BaseClasses.HVACBuilding(
    mCor_flow_nominal=ACHCor*VRooCor*conv,
    mSou_flow_nominal=ACHSou*VRooSou*conv,
    mEas_flow_nominal=ACHEas*VRooEas*conv,
    mNor_flow_nominal=ACHNor*VRooNor*conv,
    mWes_flow_nominal=ACHWes*VRooWes*conv,
    redeclare Buildings.Examples.VAVReheat.BaseClasses.ASHRAE2006 hvac,
    redeclare Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.BaseClasses.Floor flo);

  parameter Real ACHCor(final unit="1/h")=4
    "Design air change per hour core";
  parameter Real ACHSou(final unit="1/h")=4
    "Design air change per hour south";
  parameter Real ACHEas(final unit="1/h")=6
    "Design air change per hour east";
  parameter Real ACHNor(final unit="1/h")=4
    "Design air change per hour north";
  parameter Real ACHWes(final unit="1/h")=6
    "Design air change per hour west";

  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_24_2_0/Examples/SmallOffice/ASHRAE2006Winter.mos" "Simulate and plot"),
    experiment(
      StartTime=432000,
      StopTime=864000,
      Tolerance=1e-07),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}},
        preserveAspectRatio=true)),
    Documentation(
      info="<html>
<p>
This model consist of an HVAC system, a building envelope model and a model
for air flow through building leakage and through open doors.
</p>
<p>
The HVAC system is a variable air volume (VAV) flow system with economizer
and a heating and cooling coil in the air handler unit. There is also a
reheat coil and an air damper in each of the five zone inlet branches.
The figure below shows the schematic diagram of the HVAC system
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavSchematics.png\" border=\"1\"/>
</p>
<p>
See the model
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC\">
Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC</a>
for a description of the HVAC system,
and see the model
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.BaseClasses.Floor\">
Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.BaseClasses.Floor</a>
for a description of the building envelope.
</p>
<p>
The control is an implementation of the control sequence
<i>VAV 2A2-21232</i> of the Sequences of Operation for
Common HVAC Systems (ASHRAE, 2006). In this control sequence, the
supply fan speed is regulated based on the duct static pressure.
The return fan controller tracks the supply fan air flow rate.
The duct static pressure is adjusted
so that at least one VAV damper is 90% open. The economizer dampers
are modulated to track the setpoint for the mixed air dry bulb temperature.
Priority is given to maintain a minimum outside air volume flow rate.
In each zone, the VAV damper is adjusted to meet the room temperature
setpoint for cooling, or fully opened during heating.
The room temperature setpoint for heating is tracked by varying
the water flow rate through the reheat coil. There is also a
finite state machine that transitions the mode of operation of
the HVAC system between the modes
<i>occupied</i>, <i>unoccupied off</i>, <i>unoccupied night set back</i>,
<i>unoccupied warm-up</i> and <i>unoccupied pre-cool</i>.
In the VAV model, all air flows are computed based on the
duct static pressure distribution and the performance curves of the fans.
Local loop control is implemented using proportional and proportional-integral
controllers, while the supervisory control is implemented
using a finite state machine.
</p>
<p>
A similar model but with a different control sequence can be found in
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.Guideline36Winter\">
Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.Guideline36Winter</a>.
</p>
<h4>References</h4>
<p>
ASHRAE.
<i>Sequences of Operation for Common HVAC Systems</i>.
ASHRAE, Atlanta, GA, 2006.
</p>
</html>",
      revisions="<html>
<ul>
<li>
December 20, 2021, by Michael Wetter:<br/>
Changed parameter declarations for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2829\">issue #2829</a>.
</li>
<li>
October 4, 2021, by Michael Wetter:<br/>
Refactored <a href=\"modelica://Buildings.Examples.VAVReheat\">Buildings.Examples.VAVReheat</a>
and its base classes to separate building from HVAC model.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2652\">issue #2652</a>.
</li>
<li>
September 3, 2021, by Michael Wetter:<br/>
Updated documentation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2600\">issue #2600</a>.
</li>
<li>
November 25, 2019, by Milica Grahovac:<br/>
Impementation of <a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a> model with an EnergyPlus thermal zone instance.
</li>
</ul>
</html>"));
end ASHRAE2006Winter;
