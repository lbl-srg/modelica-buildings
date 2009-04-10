within Buildings.Examples.BaseClasses;
block DamperControl "Local loop controller for damper"
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Real CO2Set = 700E-6 "CO2 set point in volume fraction";
  parameter Real Kp = 10 "Proportional gain";
  annotation (Diagram, Icon(
      Line(points=[-60,-68; -60,42],
                                   style(color=8)),
      Polygon(points=[-60,52; -65,42; -55,42; -60,52],
                                                    style(color=8,
            fillColor=8)),
      Line(points=[-58,-68; 52,-68],
                                   style(color=8)),
      Polygon(points=[62,-68; 52,-73; 52,-63; 62,-68],
                                                    style(color=8,
            fillColor=8)),
      Line(points=[-80,-68; -60,-68; 10,40; 42,40],     style(color=0)),
      Text(
        extent=[48,-74; 70,-86],
        string="u",
        style(color=10)),
      Text(
        extent=[-90,62; -65,42],
        string="y",
        style(color=10))));
protected
  Modelica.Blocks.Sources.Constant xSetNor(k=1) "CO2 set point (normalized)" 
                                          annotation (extent=[-20,-50; 0,-30]);
public
  Modelica.Blocks.Continuous.LimPID con(
    yMin=0,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0.5,
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    k=Kp,
    limiter(u(start=0.75)),
    yMax=1)      annotation (extent=[20,-50; 40,-30]);
protected
  Modelica.Blocks.Math.Gain gain1(k=1/CO2Set)
    "Gain. Division by CO2Set is to normalize the control error" 
                                        annotation (extent=[-74,-50; -54,-30]);
  Modelica.Blocks.Math.Feedback feedback annotation (extent=[60,-10; 80,10]);
  Modelica.Blocks.Sources.Constant uni(k=1) "Unity signal" 
                                          annotation (extent=[20,-10; 40,10]);
equation

  connect(u, gain1.u) annotation (points=[-120,1.11022e-15; -80,1.11022e-15;
        -80,-40; -76,-40], style(color=74, rgbcolor={0,0,127}));
  connect(gain1.y,con. u_m) annotation (points=[-53,-40; -40,-40; -40,-80; 30,
        -80; 30,-52], style(color=74, rgbcolor={0,0,127}));
  connect(xSetNor.y,con. u_s) 
    annotation (points=[1,-40; 18,-40], style(color=74, rgbcolor={0,0,127}));
  connect(feedback.y, y) annotation (points=[79,6.10623e-16; 90.5,6.10623e-16;
        90.5,5.55112e-16; 110,5.55112e-16], style(color=74, rgbcolor={0,0,127}));
  connect(con.y, feedback.u2) annotation (points=[41,-40; 70,-40; 70,-8], style(
        color=74, rgbcolor={0,0,127}));
  connect(uni.y, feedback.u1) annotation (points=[41,6.10623e-16; 52.5,
        6.10623e-16; 52.5,6.66134e-16; 62,6.66134e-16], style(color=74,
        rgbcolor={0,0,127}));
end DamperControl;
