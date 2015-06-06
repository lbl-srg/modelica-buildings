within Buildings.OpenStudioToModelica.InternalHeatGains.Schedules.BaseClasses;
partial model SimplePowerDensitySchedule
  "Schedule that computes the power per unit area"
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
           24*3600.0,0] "Table for week day pattern"
    annotation (Dialog(group="Schedule"));
  parameter Modelica.SIunits.Area ATot(min=1,start=1) "Total area";
  parameter Real offsetWeek(unit="1") = 0
    "Offset for the week days pattern (fraction of P_nominal)"
    annotation (Dialog(group="Schedule"));
  parameter Modelica.SIunits.Time t0=0
    "Time offset for aligning patterns (t=0 corresponds to Monday 00:00)"
    annotation (Dialog(group="Schedule"));
  SimpleSchedule schedule(
    tableWeek=tableWeek,
    offsetWeek=offsetWeek,
    t0=t0) "Basic schedule"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput P_m2(unit="W/m2")
    "Power per unit area computed by the schedule"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput P(unit="W") "Power consumption"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
protected
    Modelica.SIunits.Power P_nominal "Nominal power";
equation
  schedule.y * P_nominal / ATot = P_m2;
  schedule.y * P_nominal = P;
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
end SimplePowerDensitySchedule;
