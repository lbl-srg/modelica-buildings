within Buildings.Experimental.NatVentControl.Lockouts.SubLockouts;
package Validation "Validation models for individual lockouts"

  model DryBulb
    "Validation model for outdoor air dry bulb natural ventilation lockout"

    Controls.OBC.CDL.Continuous.Sources.Constant con(k=293.15)
      annotation (Placement(transformation(extent={{-60,2},{-40,22}})));
    DryBulbLockout dryBulLoc
      annotation (Placement(transformation(extent={{-2,16},{18,36}})));
    Controls.OBC.CDL.Logical.Sources.Pulse booPul(width=0.25, period=86400)
      annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp ram(
      height=20,
      duration=86400,
      offset=278)
      annotation (Placement(transformation(extent={{-60,78},{-40,98}})));
    Controls.OBC.CDL.Continuous.Sources.Constant con1(k=295)
      annotation (Placement(transformation(extent={{-60,-38},{-40,-18}})));
  equation
    connect(con.y, dryBulLoc.TRooSet) annotation (Line(points={{-38,12},{-30,12},{
            -30,22},{-4,22}}, color={0,0,127}));
    connect(booPul.y, dryBulLoc.uNitFlu) annotation (Line(points={{-38,50},{
            -28,50},{-28,26},{-4,26}}, color={255,0,255}));
    connect(ram.y, dryBulLoc.TDryBul) annotation (Line(points={{-38,88},{-22,
            88},{-22,30},{-4,30}}, color={0,0,127}));
    connect(con1.y, dryBulLoc.TRooMea) annotation (Line(points={{-38,-28},{
            -22,-28},{-22,18.4},{-4,18.4}}, color={0,0,127}));
    annotation (Documentation(info="<html>
<p>
This model validates the dry bulb lockout. If natural ventilation is allowed, output should show true. 
If natural ventilation is locked out due to dry bulb temperature being out of range, output should show false.   
</p>
</html>"),  experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NatVentControl/Lockouts/SubLockouts/Validation/DryBulb.mos"
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
  end DryBulb;

  model ManualOverride
    "Validation model for manual override natural ventilation lockout"

    Controls.OBC.CDL.Logical.Sources.Pulse booPul(period=86400)
      annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
    ManualOverrideLockout manLoc
      annotation (Placement(transformation(extent={{0,0},{20,20}})));
  equation
    connect(booPul.y, manLoc.uManOveRid)
      annotation (Line(points={{-38,10},{-2,10}}, color={255,0,255}));
    annotation (Documentation(info="<html>
<p>
This model validates the manual override lockout. If natural ventilation is allowed, output should show true. 
If natural ventilation is locked out due to manual override, output should show false. 
</p>
</html>"),  experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NatVentControl/Lockouts/SubLockouts/Validation/ManualOverride.mos"
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
  end ManualOverride;

  model Occupancy
    "Validation model for occupancy natural ventilation lockout"

    OccupancyLockout occLoc
      annotation (Placement(transformation(extent={{0,38},{20,58}})));
    Controls.OBC.CDL.Logical.Sources.Pulse booPul(period=86400)
      annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
    Controls.OBC.CDL.Logical.Sources.Pulse booPul1(period=43200)
      annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  equation
    connect(booPul.y, occLoc.uOcc) annotation (Line(points={{-38,10},{-20,10},
            {-20,45},{-2,45}}, color={255,0,255}));
    connect(booPul1.y, occLoc.uNitFlu) annotation (Line(points={{-38,50},{-20,
            50},{-20,50.8},{-2,50.8}}, color={255,0,255}));
    annotation (Documentation(info="<html>
<p>
This model validates the occupancy lockout. If natural ventilation is allowed, output should show true. 
If natural ventilation is locked out because the building is unoccupied and is also not in night flush mode, output should show false. 
</p>  
</p>
</html>"),  experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NatVentControl/Lockouts/SubLockouts/Validation/Occupancy.mos"
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
  end Occupancy;

  model Rain "Validation model for rain natural ventilation lockout"

    RainLockout raiLoc
      annotation (Placement(transformation(extent={{0,20},{20,40}})));
    Controls.OBC.CDL.Logical.Sources.Pulse booPul(period=14400)
      annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  equation
    connect(booPul.y, raiLoc.uRai)
      annotation (Line(points={{-38,30},{-2,30}}, color={255,0,255}));
    annotation (Documentation(info="<html>
<p>
This model validates the rain lockout. If natural ventilation is allowed, output should show true. 
If natural ventilation is locked out because it is raining or it was raining within a specified amount of time (in this case, 30 minutes), output should show false. 
</p>  
</p>
</html>"),  experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NatVentControl/Lockouts/SubLockouts/Validation/Rain.mos"
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
  end Rain;

  model WetBulb
    "Validation model for natural ventilation wet bulb lockout"

    Controls.OBC.CDL.Continuous.Sources.Sine sin(
      amplitude=2*4.44,
      freqHz=2/86400,
      phase(displayUnit="rad"),
      offset=293.15)
      annotation (Placement(transformation(extent={{-60,42},{-40,62}})));
    Controls.OBC.CDL.Continuous.Sources.Constant con(k=293.15)
      annotation (Placement(transformation(extent={{-60,2},{-40,22}})));
    WetBulbLockout wetBulLoc
      annotation (Placement(transformation(extent={{0,20},{20,40}})));
  equation
    connect(con.y, wetBulLoc.TRooSet) annotation (Line(points={{-38,12},{-20,
            12},{-20,27},{-2,27}}, color={0,0,127}));
    connect(sin.y, wetBulLoc.TWetBul) annotation (Line(points={{-38,52},{-20,
            52},{-20,33},{-2,33}}, color={0,0,127}));
    annotation (Documentation(info="<html>
<p>
This model validates the wet bulb lockout. If natural ventilation is allowed, output should show true. 
If natural ventilation is locked out because the wet bulb temperature is above the room setpoint minus the temperature difference , output should show false. 
</p> 
</p>
</html>"),  experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NatVentControl/Lockouts/SubLockouts/Validation/WetBulb.mos"
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
  end WetBulb;

  model Wind "Validation model for wind natural ventilation lockout"

    Controls.OBC.CDL.Continuous.Sources.Sine sin2(
      amplitude=2,
      freqHz=4/86400,
      phase(displayUnit="rad"),
      offset=8.94)
      annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
    WindLockout winLoc
      annotation (Placement(transformation(extent={{0,0},{20,20}})));
  equation
    connect(sin2.y, winLoc.winSpe)
      annotation (Line(points={{-38,10},{-2,10}}, color={0,0,127}));
    annotation (Documentation(info="<html>
<p>
This model validates the wind speed lockout. If natural ventilation is allowed, output should show true. 
If natural ventilation is locked out due to wind speeds exceeding the specified threshhold, output should show false. 
</p>  
</p>
</html>"),  experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NatVentControl/Lockouts/SubLockouts/Validation/Wind.mos"
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
  end Wind;
end Validation;
