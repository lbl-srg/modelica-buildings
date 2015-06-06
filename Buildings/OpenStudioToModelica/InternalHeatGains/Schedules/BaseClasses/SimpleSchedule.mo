within Buildings.OpenStudioToModelica.InternalHeatGains.Schedules.BaseClasses;
model SimpleSchedule
  "Basic schedule model that is used to represent a generalized pattern of occupancy or utilization"
  parameter Real offsetWeek = 0 "Offset for the week days pattern";
  parameter Modelica.SIunits.Time t0 = 0
    "Time offset for aligning the patterns (t0 = 0 corresponds to Monday 00:00)";
  Modelica.Blocks.Sources.CombiTimeTable weekDay(
    tableOnFile=false,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    offset={offsetWeek},
    startTime=t0,
    table=tableWeek,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Table used for week days"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
public
  Modelica.Blocks.Interfaces.RealOutput y "Outpute value of the schedule"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  parameter Real tableWeek[25,2]=
          [0*3600.0,0;
           1*3600.0,0;
           2*3600.0,0;
           3*3600.0,0;
           4*3600.0,0;
           5*3600.0,0;
           6*3600.0,0;
           7*3600.0,0;
           8*3600.0,0;
           9*3600.0,0;
           10*3600.0,0;
           11*3600.0,0;
           12*3600.0,0;
           13*3600.0,0;
           14*3600.0,0;
           15*3600.0,0;
           16*3600.0,0;
           17*3600.0,0;
           18*3600.0,0;
           19*3600.0,0;
           20*3600.0,0;
           21*3600.0,0;
           22*3600.0,0;
           23*3600.0,0;
           24*3600.0,0] "Table for week day pattern";
equation
  connect(weekDay.y[1], y) annotation (Line(
      points={{1,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
                                Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
    Polygon(visible=true,
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid,
      points={{-80,90},{-88,68},{-72,68},{-80,90}}),
    Line(visible=true,
      points={{-80,68},{-80,-80}},
      color={192,192,192}),
    Line(visible=true,
      points={{-90,-70},{82,-70}},
      color={192,192,192}),
    Polygon(visible=true,
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid,
      points={{90,-70},{68,-62},{68,-78},{90,-70}}),
    Rectangle(visible=true,
      lineColor={255,255,255},
      fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-70,-50},{42,70}}),
    Line(visible=true,
      points={{-70,-50},{-70,70},{80,70},{80,-50},{-70,-50},{-70,-20},{80,-20},{
              80,10},{-70,10},{-70,40},{80,40},{80,70},{42,70},{42,-50}}),
        Text(
          extent={{-140,140},{140,100}},
          lineColor={0,0,255},
          textString="%name")}));
end SimpleSchedule;
