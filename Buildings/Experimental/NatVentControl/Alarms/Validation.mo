within Buildings.Experimental.NatVentControl.Alarms;
package Validation "Validation models for natural ventilation alarms"
  model WindowUnstable "Validation model for window instability alarm"
    WindowUnstableAlarm winUnsAla1
      annotation (Placement(transformation(extent={{-20,20},{0,40}})));
    Controls.OBC.CDL.Logical.Sources.Constant con(k=false)
      annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
    Controls.OBC.CDL.Continuous.Sources.Pulse pulWinSta(width=1, period=2400)
      "Stable window"
      annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
    WindowUnstableAlarm winUnsAla2(TiUns=4800)
      annotation (Placement(transformation(extent={{42,-80},{62,-60}})));
    Controls.OBC.CDL.Logical.Sources.Constant con1(k=false)
      annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
    Controls.OBC.CDL.Continuous.Sources.Sine sin(
      amplitude=0.95,
      freqHz=1/1200,
      offset=0.5)
      annotation (Placement(transformation(extent={{-80,-98},{-60,-78}})));
    Controls.OBC.CDL.Continuous.Sources.Pulse pulWinSta1(width=0.75, period=
          3600) "Stable window"
      annotation (Placement(transformation(extent={{-80,-180},{-60,-160}})));
    Controls.OBC.CDL.Logical.Switch swi
      annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
    Controls.OBC.CDL.Logical.Sources.Pulse booPul3(width=0.2, period=86400)
      annotation (Placement(transformation(extent={{-82,-138},{-62,-118}})));
  equation
    connect(winUnsAla1.uManOvr, con.y) annotation (Line(points={{-22,33},{-40,
            33},{-40,30},{-58,30}}, color={255,0,255}));
    connect(pulWinSta.y, winUnsAla1.uWinPos) annotation (Line(points={{-58,-10},
            {-40,-10},{-40,27.2},{-22,27.2}}, color={0,0,127}));
    connect(winUnsAla2.uManOvr, con1.y) annotation (Line(points={{40,-67},{-28,
            -67},{-28,-50},{-58,-50}}, color={255,0,255}));
    connect(swi.y, winUnsAla2.uWinPos) annotation (Line(points={{2,-110},{22,-110},
            {22,-72.8},{40,-72.8}}, color={0,0,127}));
    connect(sin.y, swi.u1) annotation (Line(points={{-58,-88},{-42,-88},{-42,
            -102},{-22,-102}}, color={0,0,127}));
    connect(pulWinSta1.y, swi.u3) annotation (Line(points={{-58,-170},{-40,-170},
            {-40,-118},{-22,-118}}, color={0,0,127}));
    connect(booPul3.y, swi.u2) annotation (Line(points={{-60,-128},{-48,-128},{
            -48,-110},{-22,-110}}, color={255,0,255}));
    annotation (Documentation(info="<html>
<p>
This model validates the window instability alarm, which should show true if the window fluctuates within a given range more than a user-specified amount of times within a user-specified time duration.
</html>"),   experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NatVentControl/Alarms/Validation/WindowUnstable.mos"
          "Simulate and plot"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Ellipse(
            lineColor={75,138,73},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            extent={{-100,-100},{100,100}}),
          Polygon(lineColor = {0,0,255},
                  fillColor = {75,138,73},
                  pattern = LinePattern.None,
                  fillPattern = FillPattern.Solid,
                  points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-100,-240},{100,
              100}})));
  end WindowUnstable;

  model ZoneTemperature "Validation model for slab temperature alarm"
     final parameter Real TimErr(min=0,
      final unit="s",
      final displayUnit="s",
      final quantity="Time")=3600  "Time threshhold zone temp must be out of range to trigger alarm";
    final parameter Real TemErr(min=0,
      final unit="K",
      final displayUnit="K",
      final quantity="TemperatureDifference")=1.1 "Difference from zone temp setpoint required to trigger alarm";

    Controls.OBC.CDL.Continuous.Sources.Sine sin(
      amplitude=TemErr/2,
      freqHz=1/86400,
      phase(displayUnit="rad"),
      offset=293.15 + 2*TemErr)
      annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
    ZoneTemperatureAlarm zonTemAla1
      annotation (Placement(transformation(extent={{0,38},{20,58}})));
    ZoneTemperatureAlarm zonTemAla2
      annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
    Controls.OBC.CDL.Continuous.Sources.Sine sin2(
      amplitude=TemErr/2,
      freqHz=4/86400,
      phase(displayUnit="rad"),
      offset=293.15)
      annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
    Controls.OBC.CDL.Continuous.Sources.Constant con(k=293.15)
      annotation (Placement(transformation(extent={{-98,-2},{-78,18}})));
  equation
    connect(con.y, zonTemAla1.TRooSet) annotation (Line(points={{-76,8},{-70,8},
            {-70,44.6},{-2,44.6}}, color={0,0,127}));
    connect(con.y, zonTemAla2.TRooSet) annotation (Line(points={{-76,8},{-70,8},
            {-70,-33.4},{-2,-33.4}}, color={0,0,127}));
    connect(sin2.y, zonTemAla2.TRooMea) annotation (Line(points={{-38,-10},{-20,
            -10},{-20,-27},{-2,-27}}, color={0,0,127}));
    connect(sin.y, zonTemAla1.TRooMea) annotation (Line(points={{-38,70},{-20,
            70},{-20,51},{-2,51}}, color={0,0,127}));
    annotation (Documentation(info="<html>
<p>
This model validates the zone temperature alarm, which should show true if the zone temperature has been a user-specified amount away from setpoint for a user-specified amount of time.  
</p>
</html>"),  experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NatVentControl/Alarms/Validation/ZoneTemperature.mos"
          "Simulate and plot"), Icon(graphics={
          Ellipse(
            lineColor={75,138,73},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            extent={{-100,-100},{100,100}}),
          Polygon(lineColor = {0,0,255},
                  fillColor = {75,138,73},
                  pattern = LinePattern.None,
                  fillPattern = FillPattern.Solid,
                  points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end ZoneTemperature;
annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains validation models for Alarms, which indicate if the window position is unstable (WindowUnstable) 
<l> or if room conditions are out of range (ZoneTemperature).
</p>
</html>"));
end Validation;
