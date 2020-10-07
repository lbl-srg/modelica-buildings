within Buildings.Experimental.NaturalVentilation;
block NaturalVentilationOnly
  "Natural ventilation control block with lockouts"
  parameter Real minOpe(min=0,
  max=1)=
      0.15 "Minimum % open for window";
parameter Real TDryBulCut(min=0,
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=288.7 "Outdoor air temperature below which nat vent is not allowed";
parameter Real TWetBulDif(min=0.001,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=4.44 "Allowable difference between outdoor air wet bulb temperature and room air temperature setpoint: OA WB +  this difference must be less than room air temperature setpoint";
parameter Real winSpeLim(min=0,
    final unit="m/s",
    final displayUnit="m/s",
    final quantity="Velocity")=8.94 "Wind speed above which window must be closed";
  parameter Real locTimRai(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=1800  "Time for which natural ventilation is locked out after rain is detected";
  parameter Real TiFav(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=900  "Time for which conditions must be favorable for natural ventilation to start being allowed";
  parameter Real TiNotFav(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=900  "Time for which conditions must be unfavorable for natural ventilation to stop being allowed";
  parameter Real TiConInt(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=300  "Time constant for integral term";
  parameter Real kConPro(min=0,max=10)=0.1 "Constant for proportional term";
  parameter Real TNitFluCut(min=0,
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=280 "Outdoor air temperature below which night flush sequence does not operate. If no night flush is active, set equal to TDryBulCut.";

  Lockouts.AllLockouts allLoc(
    TDryBulCut=TDryBulCut,
    TWetBulDif=TWetBulDif,
    winSpeLim=winSpeLim,
    locTimRai=locTimRai,
    TiFav=TiFav,
    TiNotFav=TiNotFav,
    TNitFluCut=TNitFluCut) "All lockouts"
    annotation (Placement(transformation(extent={{-62,-20},{-20,20}})));
  Controls.OBC.CDL.Continuous.Sources.Constant winClo(k=0)
    "Signal if window is 0% open"
    annotation (Placement(transformation(extent={{-40,-62},{-20,-42}})));
  Controls.OBC.CDL.Logical.Switch swi
    "If true, output window signal. If false, window is closed (output zero)"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Controls.OBC.CDL.Interfaces.BooleanInput uManOveRid
    "Manual override signal- true if override, false if not" annotation (
      Placement(transformation(extent={{-140,70},{-100,110}}),
        iconTransformation(extent={{-140,68},{-100,108}})));
  Controls.OBC.CDL.Interfaces.BooleanInput uNitFlu
    "Night flush signal; true if night flush on, false if not" annotation (
      Placement(transformation(extent={{-140,30},{-100,70}}),
        iconTransformation(extent={{-140,48},{-100,88}})));
  Controls.OBC.CDL.Interfaces.BooleanInput uRai
    "Rain signal- true if raining; false if not" annotation (Placement(
        transformation(extent={{-140,-10},{-100,30}}), iconTransformation(
          extent={{-140,28},{-100,68}})));
  Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Occupancy signal- true if room is occupied, false if not" annotation (
      Placement(transformation(extent={{-140,-50},{-100,-10}}),
        iconTransformation(extent={{-140,8},{-100,48}})));
  Controls.OBC.CDL.Interfaces.RealInput uDryBul
    "Outdoor air dry bulb temperature" annotation (Placement(transformation(
          extent={{-140,-90},{-100,-50}}), iconTransformation(extent={{-140,-70},
            {-100,-30}})));
  Controls.OBC.CDL.Interfaces.RealInput uWinSpe "Wind speed"
                                                annotation (Placement(
        transformation(extent={{-140,-118},{-100,-78}}), iconTransformation(
          extent={{-140,-90},{-100,-50}})));
  Controls.OBC.CDL.Interfaces.RealInput uRooSet "Room setpoint" annotation (
      Placement(transformation(extent={{-140,-160},{-100,-120}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Controls.OBC.CDL.Interfaces.RealInput uWetBul
    "Outdoor air wet bulb temperature" annotation (Placement(transformation(
          extent={{-140,-192},{-100,-152}}), iconTransformation(extent={{-140,-30},
            {-100,10}})));
  Controls.OBC.CDL.Interfaces.RealOutput yWinOpe "Window percent open"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-18},{140,22}})));
  Controls.OBC.CDL.Interfaces.RealInput uRooMeaTem "Measured room temperature"
    annotation (Placement(transformation(extent={{-140,-228},{-100,-188}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Window.WindowControl winCon(
    minOpe=minOpe,
    TiConInt=TiConInt,
    kConPro=kConPro) "Window control"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys(uLow=0.01, uHigh=0.02)
    "If window is open (position > 0), natural ventilation mode is on"
    annotation (Placement(transformation(extent={{58,-82},{78,-62}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yNatVen
    "True if natural ventilation is on, false if not" annotation (Placement(
        transformation(extent={{100,-92},{140,-52}}), iconTransformation(extent=
           {{100,-52},{140,-12}})));
equation
  connect(allLoc.yAllNatVenLoc, swi.u2) annotation (Line(points={{-15.8,0},{-6,0},
          {-6,10},{18,10}}, color={255,0,255}));
  connect(winClo.y, swi.u3) annotation (Line(points={{-18,-52},{10,-52},{10,2},{
          18,2}}, color={0,0,127}));
  connect(uManOveRid, allLoc.uManOveRid) annotation (Line(points={{-120,90},{-92,
          90},{-92,17.6},{-66.2,17.6}}, color={255,0,255}));
  connect(uNitFlu, allLoc.uNitFlu) annotation (Line(points={{-120,50},{-92,50},{
          -92,13.6},{-66.2,13.6}}, color={255,0,255}));
  connect(uRai, allLoc.uRai) annotation (Line(points={{-120,10},{-94,10},{-94,9.6},
          {-66.2,9.6}}, color={255,0,255}));
  connect(uOcc, allLoc.uOcc) annotation (Line(points={{-120,-30},{-94,-30},{-94,
          5.6},{-66.2,5.6}}, color={255,0,255}));
  connect(uWinSpe, allLoc.uWinSpe) annotation (Line(points={{-120,-98},{-92,-98},
          {-92,-14},{-66.2,-14}}, color={0,0,127}));
  connect(uRooSet, allLoc.uRooSet) annotation (Line(points={{-120,-140},{-82,-140},
          {-82,-6},{-66.2,-6}}, color={0,0,127}));
  connect(uDryBul, allLoc.uDryBul) annotation (Line(points={{-120,-70},{-92,-70},
          {-92,-10},{-66.2,-10}}, color={0,0,127}));
  connect(uWetBul, allLoc.uWetBul) annotation (Line(points={{-120,-172},{-74,-172},
          {-74,-2},{-66.2,-2}}, color={0,0,127}));
  connect(swi.y, yWinOpe) annotation (Line(points={{42,10},{72,10},{72,0},{120,0}},
        color={0,0,127}));
  connect(yWinOpe, yWinOpe)
    annotation (Line(points={{120,0},{120,0}}, color={0,0,127}));
  connect(uRooMeaTem, winCon.TRooMea) annotation (Line(points={{-120,-208},{-88,
          -208},{-88,75},{-42,75}}, color={0,0,127}));
  connect(uRooSet, winCon.TRooSet) annotation (Line(points={{-120,-140},{-80,-140},
          {-80,67.2},{-42,67.2}}, color={0,0,127}));
  connect(winCon.yWinOpeReq, swi.u1) annotation (Line(points={{-18,70.2},{2,70.2},
          {2,18},{18,18}}, color={0,0,127}));
  connect(swi.y, hys.u) annotation (Line(points={{42,10},{50,10},{50,-72},{56,-72}},
        color={0,0,127}));
  connect(hys.y, yNatVen) annotation (Line(points={{80,-72},{90,-72},{90,-72},{120,
          -72}}, color={255,0,255}));
  connect(uRooMeaTem, allLoc.uRooMea) annotation (Line(points={{-120,-208},{-88,
          -208},{-88,-18},{-66.2,-18}}, color={0,0,127}));
  annotation (defaultComponentName = "natVen",Documentation(info="<html>
  <p>This block determines the window open position and whether or not natural ventilation is allowed. This block excludes night flush.
  <p>The block combines the window control signal with the natural ventilation lockouts to determine a final window position and binary output indicating 
  whether or not natural ventilation is active (ie, window position > 0).
  
  <p>Window control, as specified in Buildings.Experimental.NatVentControl.Window, determines the window control signal, ie what % the window is called to be open.
  <p>The window position is modulated with direct-acting PI control, with a user-specified constant 
  for the proportional term (kConPro, typically 0.1) and time constant for the integral term (TiConInt, typically 5 minutes). 
  <p>The user also specifies a minimum opening position (minOpe, typically 0.15)- if the window is to be opened, it must be opened at least this amount. 
  If the PI control loop calls for a window position that is less than this minimum value, the window remains closed. 
  
  Lockouts are determined as specified in Buildings.Experimental.NatVentControl.AllLockouts.
    If any of the six below conditions indicates that natural ventilation should be locked out, natural ventilation is locked out. 
  <p>1. Dry Bulb Temperature Lockout: 
    Dry bulb lockout locks out natural ventilation if the dry bulb temperature is unacceptable for natural ventilation based on user-specified conditions.
  These conditions vary with the building's operational mode.
  
   <p>If the building is in night flush mode, natural ventilation is locked out if one of the following is true:
   <p>a. The outdoor air is below a user-specified threshhold (TNitFluCut)
   <p>b. The outdoor air temperature is above the current measured room temperature
   <p>AND either or both of these conditions has persisted for a user-specified amount of time (TiNotFav, typically 15 minutes). 
  
   <p>If the building is not in night flush mode, natural ventilation is locked out if:
   <p>c. The outdoor air is below a user-specified threshhold (TDryBulCut)
   <p>d. The outdoor air dry bulb temperature is above the air temperature setpoint for the room.
   <p>AND either or both of these conditions has persisted for a user-specified amount of time (TiNotFav, typically 15 minutes). 
  
  <p> In either night flush or daytime natural ventilation mode, in order for the lockout to reverse (ie, for natural ventilation to be allowed), conditions must be favorable for at least a user-specified amount of time
  (TiFav, typically 15 minutes).
  <p>2. Manual Override Lockout: If the window is in manual override mode, natural ventilation is locked out. 
  <p>3. Occupancy Lockout: If the building is unoccpied and is not in night flush mode, natural ventilation is locked out. 
  <p>4. Rain Lockout:  If rain is detected, natural ventilation is locked out for a user-specified amount of time (locTimRai, typically 30 minutes) if rain is detected.
  <p>5. Wet Bulb Lockout: The user specifies a tolerance (TWetBulDif, typically 4.5 degrees Celsius), and the wet bulb temperature must be below the room setpoint minus the tolerance 
  in order for natural ventilation to be permitted. 
  <p> 6. Wind Lockout: If wind speed exceeds a user-specified limit (winSpeLim, typically 20 mph), natural ventilation is locked out.  
  
<p>
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
Updated description. 
</li>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),                                        graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={162,29,33},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-16,-60},{20,-60},{-20,-60}},
          color={162,29,33},
          thickness=1),
        Line(
          points={{-20,60},{20,60}},
          color={162,29,33},
          thickness=1),
        Line(
          points={{20,60},{100,60},{100,-62},{20,-88},{20,40},{98,60},{100,58}},
          color={162,29,33},
          thickness=1),
        Line(
          points={{60,50},{60,-74}},
          color={162,29,33},
          thickness=1),
        Line(
          points={{20,-20},{100,0}},
          color={162,29,33},
          thickness=1),
        Line(
          points={{-100,0},{-20,-20}},
          color={162,29,33},
          thickness=1),
        Line(
          points={{-60,50},{-60,-74}},
          color={162,29,33},
          thickness=1),
        Line(
          points={{-100,60},{-100,-60},{-20,-88},{-20,40},{-100,60},{-20,60}},
          color={162,29,33},
          thickness=1),
        Text(
          lineColor={0,0,255},
          extent={{-148,102},{152,142}},
          textString="%name")}),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-220},{100,100}}), graphics={Text(
          extent={{8,88},{408,56}},
          lineColor={0,0,0},
          lineThickness=1,
          fontSize=9,
          horizontalAlignment=TextAlignment.Left,
          textStyle={TextStyle.Bold},
          textString="Nat Vent Control w/o Night Flush:
Combines window PID control
 with 
all natural ventilation lockouts;
outputs natural ventilation 
status signal
and window percentage open")}));
end NaturalVentilationOnly;
