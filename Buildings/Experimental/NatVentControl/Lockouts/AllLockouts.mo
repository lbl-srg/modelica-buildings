within Buildings.Experimental.NatVentControl.Lockouts;
model AllLockouts "All lockouts combined"
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
 parameter Real TNitFluCut(min=0,
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=280 "Outdoor air temperature below which night flush sequence does not operate";
  SubLockouts.DryBulbLockout dryBulLoc(
    TDryBulCut=TDryBulCut,
    TiFav=TiFav,
    TiNotFav=TiNotFav,
    TNitFluCut=TNitFluCut)
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  SubLockouts.ManualOverrideLockout manLoc
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  SubLockouts.OccupancyLockout occLoc
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  SubLockouts.RainLockout raiLoc(locTimRai=locTimRai)
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  SubLockouts.WetBulbLockout wetBulLoc(TWetBulDif=TWetBulDif)
    annotation (Placement(transformation(extent={{-40,-86},{-20,-66}})));
  SubLockouts.WindLockout winLoc(winSpeLim=winSpeLim)
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Controls.OBC.CDL.Interfaces.BooleanInput uManOveRid
    "Manual override signal- true if override, false if not" annotation (
      Placement(transformation(extent={{-160,130},{-120,170}}),
        iconTransformation(extent={{-140,68},{-100,108}})));
  Controls.OBC.CDL.Interfaces.BooleanInput uNitFlu
    "Night flush signal; true if night flush on, false if not" annotation (
      Placement(transformation(extent={{-160,90},{-120,130}}),
        iconTransformation(extent={{-140,48},{-100,88}})));
  Controls.OBC.CDL.Interfaces.BooleanInput uRai
    "Rain signal- true if raining; false if not" annotation (Placement(
        transformation(extent={{-160,50},{-120,90}}), iconTransformation(extent=
           {{-140,28},{-100,68}})));
  Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Occupancy signal- true if room is occupied, false if not" annotation (
      Placement(transformation(extent={{-160,10},{-120,50}}),
        iconTransformation(extent={{-140,8},{-100,48}})));
  Controls.OBC.CDL.Interfaces.RealInput uDryBul
    "Outdoor air dry bulb temperature" annotation (Placement(transformation(
          extent={{-160,-30},{-120,10}}), iconTransformation(extent={{-140,-70},
            {-100,-30}})));
  Controls.OBC.CDL.Interfaces.RealInput uWinSpe annotation (Placement(
        transformation(extent={{-160,-70},{-120,-30}}), iconTransformation(
          extent={{-140,-90},{-100,-50}})));
  Controls.OBC.CDL.Interfaces.RealInput uRooSet "Room setpoint" annotation (
      Placement(transformation(extent={{-160,-110},{-120,-70}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Controls.OBC.CDL.Interfaces.RealInput uWetBul
    "Outdoor air wet bulb temperature" annotation (Placement(transformation(
          extent={{-160,-150},{-120,-110}}), iconTransformation(extent={{-140,
            -30},{-100,10}})));
  Controls.OBC.CDL.Logical.And3 and3
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Controls.OBC.CDL.Logical.And3 and1
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yAllNatVenLoc
    "True if nat vent allowed, false if nat vent locked out" annotation (
      Placement(transformation(extent={{100,-30},{140,10}}), iconTransformation(
          extent={{100,-20},{140,20}})));
  Controls.OBC.CDL.Interfaces.RealInput uRooMea "Room setpoint" annotation (
      Placement(transformation(extent={{-160,-180},{-120,-140}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
equation
  connect(uDryBul, dryBulLoc.TDryBul) annotation (Line(points={{-140,-10},{-100,
          -10},{-100,74},{-42,74}}, color={0,0,127}));
  connect(uRooSet, dryBulLoc.TRooSet) annotation (Line(points={{-140,-90},{-80,-90},
          {-80,66},{-42,66}}, color={0,0,127}));
  connect(uWinSpe, winLoc.winSpe)
    annotation (Line(points={{-140,-50},{-42,-50}}, color={0,0,127}));
  connect(uRooSet, wetBulLoc.TRooSet) annotation (Line(points={{-140,-90},{-80,-90},
          {-80,-80},{-62,-80},{-62,-79},{-42,-79}}, color={0,0,127}));
  connect(uWetBul, wetBulLoc.TWetBul) annotation (Line(points={{-140,-130},{-60,
          -130},{-60,-73},{-42,-73}}, color={0,0,127}));
  connect(uRai, raiLoc.uRai) annotation (Line(points={{-140,70},{-114,70},{-114,
          -20},{-42,-20}},
                      color={255,0,255}));
  connect(uManOveRid, manLoc.uManOveRid) annotation (Line(points={{-140,150},{-50,
          150},{-50,40},{-42,40}}, color={255,0,255}));
  connect(uOcc, occLoc.uOcc) annotation (Line(points={{-140,30},{-92,30},{-92,7},
          {-42,7}}, color={255,0,255}));
  connect(uNitFlu, occLoc.uNitFlu) annotation (Line(points={{-140,110},{-60,110},
          {-60,12.8},{-42,12.8}}, color={255,0,255}));
  connect(dryBulLoc.yDryBulOASig, and3.u1) annotation (Line(points={{-18,70},{12,
          70},{12,38},{18,38}}, color={255,0,255}));
  connect(manLoc.yManOveNatVenSig, and3.u2) annotation (Line(points={{-18,40},{2,
          40},{2,30},{18,30}}, color={255,0,255}));
  connect(occLoc.yOccNatVenSig, and3.u3) annotation (Line(points={{-18,10},{10,10},
          {10,22},{18,22}}, color={255,0,255}));
  connect(raiLoc.yRaiNatVenSig, and1.u1) annotation (Line(points={{-18,-20},{10,
          -20},{10,-42},{18,-42}}, color={255,0,255}));
  connect(winLoc.yWinNatVenSig, and1.u2)
    annotation (Line(points={{-18,-50},{18,-50}}, color={255,0,255}));
  connect(wetBulLoc.yWetBulNatVenSig, and1.u3) annotation (Line(points={{-18,-75.8},
          {10,-75.8},{10,-58},{18,-58}}, color={255,0,255}));
  connect(and3.y, and2.u1) annotation (Line(points={{42,30},{52,30},{52,-10},{58,
          -10}}, color={255,0,255}));
  connect(and1.y, and2.u2) annotation (Line(points={{42,-50},{50,-50},{50,-18},{
          58,-18}}, color={255,0,255}));
  connect(and2.y, yAllNatVenLoc) annotation (Line(points={{82,-10},{92,-10},{92,
          -10},{120,-10}}, color={255,0,255}));
  connect(uNitFlu, dryBulLoc.uNitFlu) annotation (Line(points={{-140,110},{-60,
          110},{-60,70},{-42,70}}, color={255,0,255}));
  connect(uRooMea, dryBulLoc.TRooMea) annotation (Line(points={{-140,-160},{-74,
          -160},{-74,62},{-42,62},{-42,62.4}}, color={0,0,127}));
  annotation (defaultComponentName = "allLoc",  Documentation(info="<html>
  <p>
  This block combines all six lockouts to determine whether or not natural ventilation is locked out. 
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
  
  <p>Output is expressed as a boolean signal. If the signal is true, natural ventilation is allowed (ie, it is not locked out).<p>

  A true signal indicates only that natural ventilation is *permitted*- it does *not* indicate the actual status
  of the final signal, which is determined based on whether or not there is a call for natural ventilation based on the room's temperature and setpoint. 
 
</p>
</html>"),  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),                                        graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-82,46},{-82,-76},{78,-76},{78,46},{-82,46}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{-56,46},{-62,86}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{-62,92},{58,86}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{58,46},{52,86}},
          lineColor={28,108,200},
          lineThickness=1),
        Text(
          extent={{-24,48},{26,-48}},
          lineColor={28,108,200},
          textString="A")}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-120,-160},{100,160}})));
end AllLockouts;
