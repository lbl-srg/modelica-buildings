within Buildings.ThermalZones.EnergyPlus.Validation.Schedule;
model EquipmentScheduleOutputVariable
  "Validation case with a schedule that is not sampled, and output reader of the energy affected by the scheduled value"
  extends Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.EquipmentSchedule;
  Buildings.ThermalZones.EnergyPlus.OutputVariable equEle(
    name="Zone Electric Equipment Electricity Rate",
    key="LIVING ZONE",
    isDirectDependent=true,
    y(
      final unit="W"))
    "Block that reads output from EnergyPlus"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Utilities.Diagnostics.AssertEquality assEqu(
    threShold=1E-6,
    message="EnergyPlus did not synchronize the output variable correctly")
    "Assertion to test whether the schedule and the EnergyPlus output variable are correctly synchronized"
    annotation (Placement(transformation(extent={{30,40},{50,60}})));
  Controls.OBC.CDL.Continuous.Gain gai(
    k=500)
    "Gain for internal heat gain"
    annotation (Placement(transformation(extent={{-40,34},{-20,54}})));

equation
  connect(schInt.y,equEle.directDependency)
    annotation (Line(points={{-18,80},{-2,80}},color={0,0,127}));
  connect(equEle.y,assEqu.u1)
    annotation (Line(points={{21,80},{24,80},{24,56},{28,56}},color={0,0,127}));
  connect(assEqu.u2,gai.y)
    annotation (Line(points={{28,44},{-18,44}},color={0,0,127}));
  connect(gai.u,intLoaFra.y)
    annotation (Line(points={{-42,44},{-50,44},{-50,80},{-58,80}},color={0,0,127}));
  annotation (
    Documentation(
      info="<html>
<p>
Simple test case that verifies whether the schedule for the internal loads 
used by EnergyPlus is modified from Modelica, and the electrical equipment load
that is controlled by this schedule is reported correctly.
</p>
<p>
The instance <code>assEqu</code> asserts that the input and output of EnergyPlus
are correctly synchronized. If the output were delayed, the simulation would
stop with an error.
</p>
</html>",
      revisions="<html>
<ul><li>
June 5, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Validation/Schedule/EquipmentScheduleOutputVariable.mos" "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-06));
end EquipmentScheduleOutputVariable;
