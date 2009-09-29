within Buildings.Fluid.Actuators.Motors.Examples;
model IdealMotor "Test model for IdealMotor"
  annotation (Diagram(graphics),
                       Commands(file=
          "IdealMotor.mos" "run"));
  Buildings.Fluid.Actuators.Motors.IdealMotor mot(tOpe=60) "Motor model" 
    annotation (Placement(transformation(extent={{-20,20},{0,40}}, rotation=0)));
  Modelica.Blocks.Sources.TimeTable ySet(table=[0,0; 60,0; 60,1; 120,1; 180,0.5;
        240,0.5; 300,0; 360,0; 360,0.25; 420,0.25; 480,1; 540,1.5; 600,-0.25])
    "Set point for actuator" annotation (Placement(transformation(extent={{-80,
            20},{-60,40}}, rotation=0)));
  annotation (Diagram);
equation
  connect(ySet.y, mot.u) 
    annotation (Line(points={{-59,30},{-22,30}}, color={0,0,127}));
end IdealMotor;
