model IdealMotor "Test model for IdealMotor" 
  annotation (Diagram, Commands(file=
          "IdealMotor.mos" "run"));
  Buildings.Fluids.Actuators.Motors.IdealMotor mot(tOpe=60) "Motor model" 
    annotation (extent=[-20,20; 0,40]);
  Modelica.Blocks.Sources.TimeTable ySet(table=[0,0; 60,0; 60,1; 120,1; 180,0.5;
        240,0.5; 300,0; 360,0; 360,0.25; 420,0.25; 480,1; 540,1.5; 600,-0.25]) 
    "Set point for actuator" annotation (extent=[-80,20; -60,40]);
  annotation (Diagram);
equation 
  connect(ySet.y, mot.u) 
    annotation (points=[-59,30; -22,30], style(color=74, rgbcolor={0,0,127}));
end IdealMotor;
