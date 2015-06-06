within Buildings.OpenStudioToModelica.InternalHeatGains.Schedules.BaseClasses;
model Schedule
  "Basic schedule model that is used to represent a generalized pattern of occupancy or utilization"
  parameter Real patternWeek[24] = zeros(24) "Pattern for week days";
  parameter Real patternWeekend[24] = zeros(24) "Pattern for weekend days";
  parameter Real offsetWeek = 0 "Offset for the week days pattern";
  parameter Real offsetWeekend = 0 "Offset for the weekend days pattern";
  parameter Modelica.SIunits.Time t0 = 0
    "Time offset for aligning the patterns (t0 = 0 corresponds to Monday 00:00)";
  Modelica.Blocks.Interfaces.RealOutput y "Outpute value of the schedule"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Sources.Trapezoid weekPeriod(
    amplitude=1,
    rising=3600,
    falling=3600,
    period=7*24*3600,
    nperiod=-1,
    offset=0,
    width=(4*24 + 22)*3600,
    startTime=t0) "Trapezoidal signal that represents the week period"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Sources.Trapezoid weekendPeriod(
    amplitude=1,
    rising=3600,
    falling=3600,
    period=7*24*3600,
    nperiod=-1,
    offset=0,
    width=(24 + 22)*3600,
    startTime=t0 + 5*24*3600)
    "Trapezoidal signal that reperesents the weekend period"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Modelica.Blocks.Math.Feedback sub "Subtract the period signals"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
protected
  parameter Real timeTableWeek[25,2]=
          [0*3600.0,patternWeek[24];
           1*3600.0,patternWeek[1];
           2*3600.0,patternWeek[2];
           3*3600.0,patternWeek[3];
           4*3600.0,patternWeek[4];
           5*3600.0,patternWeek[5];
           6*3600.0,patternWeek[6];
           7*3600.0,patternWeek[7];
           8*3600.0,patternWeek[8];
           9*3600.0,patternWeek[9];
           10*3600.0,patternWeek[10];
           11*3600.0,patternWeek[11];
           12*3600.0,patternWeek[12];
           13*3600.0,patternWeek[13];
           14*3600.0,patternWeek[14];
           15*3600.0,patternWeek[15];
           16*3600.0,patternWeek[16];
           17*3600.0,patternWeek[17];
           18*3600.0,patternWeek[18];
           19*3600.0,patternWeek[19];
           20*3600.0,patternWeek[20];
           21*3600.0,patternWeek[21];
           22*3600.0,patternWeek[22];
           23*3600.0,patternWeek[23];
           24*3600.0,patternWeek[24]];
  parameter Real timeTableWeekend[25,2]=
          [0*3600.0,patternWeekend[24];
           1*3600.0,patternWeekend[1];
           2*3600.0,patternWeekend[2];
           3*3600.0,patternWeekend[3];
           4*3600.0,patternWeekend[4];
           5*3600.0,patternWeekend[5];
           6*3600.0,patternWeekend[6];
           7*3600.0,patternWeekend[7];
           8*3600.0,patternWeekend[8];
           9*3600.0,patternWeekend[9];
           10*3600.0,patternWeekend[10];
           11*3600.0,patternWeekend[11];
           12*3600.0,patternWeekend[12];
           13*3600.0,patternWeekend[13];
           14*3600.0,patternWeekend[14];
           15*3600.0,patternWeekend[15];
           16*3600.0,patternWeekend[16];
           17*3600.0,patternWeekend[17];
           18*3600.0,patternWeekend[18];
           19*3600.0,patternWeekend[19];
           20*3600.0,patternWeekend[20];
           21*3600.0,patternWeekend[21];
           22*3600.0,patternWeekend[22];
           23*3600.0,patternWeekend[23];
           24*3600.0,patternWeekend[24]];
  Buildings.Utilities.Math.Splice spl(deltax=0.01)
    "Blocks that selects which of the two schedules should be selected or not"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.CombiTimeTable weekDay(
    tableOnFile=false,
    table=timeTableWeek,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={offsetWeek},
    startTime=t0,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    "Table used for week days"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.CombiTimeTable weekendDay(
    tableOnFile=false,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={offsetWeekend},
    startTime=t0,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    table=timeTableWeekend) "Table used for weekend days"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
equation
  connect(weekDay.y[1], spl.u1) annotation (Line(
      points={{1,50},{20,50},{20,6},{38,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weekendDay.y[1], spl.u2) annotation (Line(
      points={{1,-50},{20,-50},{20,-6},{38,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(spl.y, y) annotation (Line(
      points={{61,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weekPeriod.y, sub.u1) annotation (Line(
      points={{-59,20},{-34,20},{-34,0},{-8,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weekendPeriod.y, sub.u2) annotation (Line(
      points={{-59,-20},{0,-20},{0,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sub.y, spl.x) annotation (Line(
      points={{9,0},{38,0}},
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
end Schedule;
