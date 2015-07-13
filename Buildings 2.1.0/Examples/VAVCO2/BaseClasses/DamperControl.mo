within Buildings.Examples.VAVCO2.BaseClasses;
block DamperControl "Local loop controller for damper"
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Real CO2Set = 700E-6 "CO2 set point in volume fraction";
  parameter Real Kp = 10 "Proportional gain";
protected
  Modelica.Blocks.Sources.Constant xSetNor(k=1) "CO2 set point (normalized)"
                                          annotation (extent=[-20,-50; 0,-30],
      Placement(transformation(extent={{-20,-10},{0,10}})));
public
  Buildings.Controls.Continuous.LimPID con(
    yMin=0,
    y_start=0.5,
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    k=Kp,
    limiter(u(start=0.75)),
    yMax=1,
    reverseAction=true,
    Td=60)       annotation (extent=[20,-50; 40,-30], Placement(transformation(
          extent={{20,-10},{40,10}})));
protected
  Modelica.Blocks.Math.Gain gain1(k=1/CO2Set)
    "Gain. Division by CO2Set is to normalize the control error"
                                        annotation (extent=[-74,-50; -54,-30],
      Placement(transformation(extent={{-40,-50},{-20,-30}})));
equation

  connect(con.y, y) annotation (Line(
      points={{41,6.10623e-16},{72,6.10623e-16},{72,5.55112e-16},{110,
          5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(xSetNor.y, con.u_s) annotation (Line(
      points={{1,6.10623e-16},{8.5,6.10623e-16},{8.5,6.66134e-16},{18,
          6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain1.y, con.u_m) annotation (Line(
      points={{-19,-40},{30,-40},{30,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(u, gain1.u) annotation (Line(
      points={{-120,1.11022e-15},{-70,1.11022e-15},{-70,-40},{-42,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (                       Icon(
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
end DamperControl;
