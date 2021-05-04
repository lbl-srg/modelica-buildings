within Buildings.ThermalZones.EnergyPlus.Validation;
model NonalignedSchedule
  "Validation model in which the schedule input is not aligned with the EnergyPlus time step"
   extends Modelica.Icons.Example;


  model Zone "Model of a thermal zone"
    extends Buildings.ThermalZones.EnergyPlus.Validation.Schedule.EquipmentScheduleOutputVariable(
      intLoaFra(
        amplitude=amplitude,
        width=width,
        period(displayUnit="min") = 1200),
        assEqu(threShold=1E100));
        // fixme: above, the assignment assEqu(threShold=1E100)
        // should be removed for the release. It has been added for
        // https://github.com/lbl-srg/modelica-buildings/issues/2000
    extends Modelica.Blocks.Icons.Block;
    Controls.OBC.CDL.Interfaces.RealOutput movMeaSch
      "Moving mean of schedule value over past day" annotation (Placement(
          transformation(extent={{100,20},{140,60}}), iconTransformation(extent={{100,22},
              {140,62}})));
    Controls.OBC.CDL.Continuous.MovingMean movMea(delta=1200)
      "Moving mean of schedule value over past day"
      annotation (Placement(transformation(extent={{0,100},{20,120}})));
    Modelica.Blocks.Interfaces.RealOutput TAir(unit="K", displayUnit="degC") "Air temperature of the zone"
      annotation (Placement(transformation(extent={{100,-10},{120,10}}),
          iconTransformation(extent={{100,-10},{120,10}})));
    parameter Real amplitude=1 "Amplitude of pulse";
    parameter Modelica.SIunits.Time startTime(displayUnit="min") = 600
      "Output = offset for time < startTime";
    parameter Real width=0.5 "Width of pulse in fraction of period";
    Controls.OBC.CDL.Discrete.Sampler sam(samplePeriod=120) "Time sampler"
      annotation (Placement(transformation(extent={{40,100},{60,120}})));
  equation
    connect(zon.TAir, TAir) annotation (Line(points={{41,13.8},{80,13.8},{80,0},
            {110,0}}, color={0,0,127}));
    connect(movMea.u, intLoaFra.y) annotation (Line(points={{-2,110},{-50,110},{-50,
            80},{-58,80}}, color={0,0,127}));
    connect(movMea.y, sam.u)
      annotation (Line(points={{22,110},{38,110}},color={0,0,127}));
    connect(sam.y, movMeaSch) annotation (Line(points={{62,110},{80,110},{80,40},{
            120,40}},
                  color={0,0,127}));
    annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,140}})), Icon(
          coordinateSystem(extent={{-100,-100},{100,100}})));
  end Zone;

  Zone zonAli "Zone with schedule aligned with EnergyPlus time step"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));

  Zone zonNonAli(
    amplitude=2,
    startTime=660,
    width=0.25) "Zone with schedule not aligned with EnergyPlus time step"
    annotation (Placement(transformation(extent={{-10,-32},{10,-12}})));
  annotation (Documentation(info="<html>
<p>
Model that validates that
schedule values need not be aligned with the EnergyPlus time step.
In this situation,
if it represents a continuous-valued schedule (such as for an internal gain),
EnergyPlus should time-average the schedule values over the EnergyPlus time step.
If it represents an instantaneous value such as a control state, then
EnergyPlus should use the instantaneuous value at the start of the EnergyPlus time
step.
This validation tests a continuous-valued schedule.
</p>
<p>
Both buildings are identical, but in one building, the schedule that
determines the internal heat gains switches
on and off every 10 minutes, while in the other one the schedule is on
from 3 minutes and off after 8 minutes, but the schedule values is twice as
large in order to add the same amount of internal heat to the zone over an EnergyPlus
time step. Because EnergyPlus uses a fixed time step, both models must result in the same air temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
June 10, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Validation/NonalignedSchedule.mos"
        "Simulate and plot"),
experiment(
      StopTime=172800,
      Tolerance=1e-06));

end NonalignedSchedule;
