within Buildings.Examples.VAVCO2.BaseClasses;
block DamperControl "Local loop controller for damper"
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Real CO2Set = 700E-6 "CO2 set point in volume fraction";
  parameter Real Kp = 10 "Gain";

  Buildings.Controls.Continuous.LimPID con(
    yMin=0,
    y_start=0.5,
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    k=Kp,
    yMax=1,
    reverseAction=true,
    Td=60)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

protected
  Modelica.Blocks.Sources.Constant xSetNor(k=1) "CO2 set point (normalized)"
  annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Modelica.Blocks.Math.Gain gain1(k=1/CO2Set)
    "Gain. Division by CO2Set is to normalize the control error"
    annotation(Placement(transformation(extent={{-40,-50},{-20,-30}})));
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
  annotation (Icon(graphics={
        Line(points={{-80,78},{-80,-90}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-80},{82,-80}}, color={192,192,192}),
        Line(points={{-80,-80},{-56,-80},{-2,18},{66,18}}, color={0,0,127})}));
end DamperControl;
