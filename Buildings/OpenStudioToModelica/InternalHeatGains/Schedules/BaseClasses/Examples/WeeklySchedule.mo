within Buildings.OpenStudioToModelica.InternalHeatGains.Schedules.BaseClasses.Examples;
model WeeklySchedule "Test for the schedule model"
  Schedule schFix(patternWeek=0.7*ones(24), patternWeekend=0.4*
        ones(24)) "Schedule model"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Schedule schVar(patternWeek={0.4,0.4,0.4,0.45,0.5,0.45,0.6,0.7,
    0.75,0.9,1.0,1.0,0.9,1.2,1.3,1.4,1.1,1.0,0.8,0.7,0.6,0.5,0.4,0.4},
    patternWeekend={0.3,0.2,0.2,0.3,0.3,0.4,0.4,0.5,0.5,0.5,0.4,0.4,0.4,
    0.5,0.5,0.4,0.3,0.2,0.2,0.2,0.3,0.3,0.3,0.3}) "Schedule model"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Schedule schFixOffset(
    patternWeek=0.7*ones(24),
    patternWeekend=0.4*ones(24),
    offsetWeek=0.2,
    offsetWeekend=0.1) "Schedule model"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Schedule schFixDelay(
    patternWeek=0.7*ones(24),
    patternWeekend=0.4*ones(24),
    offsetWeek=0,
    offsetWeekend=0,
    t0=24*3600) "Schedule model"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  annotation (experiment(StopTime=1.8144e+06));
end WeeklySchedule;
