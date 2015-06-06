within Buildings.OpenStudioToModelica.InternalHeatGains.Schedules.BaseClasses.Examples;
model SimpleSchedule "Test for the simple schedule model"
    Buildings.OpenStudioToModelica.InternalHeatGains.Schedules.BaseClasses.SimpleSchedule
           schFix(tableWeek=[0*3600.0,1; 1*3600.0,2; 2*3600.0,3; 3*3600.0,
        4; 4*3600.0,5; 5*3600.0,6; 6*3600.0,7; 7*3600.0,8; 8*3600.0,9; 9*3600.0,
        10; 10*3600.0,11; 11*3600.0,12; 12*3600.0,13; 13*3600.0,14; 14*3600.0,15;
        16*3600.0,16; 16*3600.0,17; 17*3600.0,18; 18*3600.0,19; 19*3600.0,20; 20
        *3600.0,21; 21*3600.0,22; 22*3600.0,23; 23*3600.0,24; 24*3600.0,0])
    "Schedule model"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  annotation (experiment(StopTime=1.8144e+06));
end SimpleSchedule;
