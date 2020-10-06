within Buildings.Experimental.NaturalVentilation;
block NaturalVentilationNightFlushFixed
  "Nat vent control including night flush"
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
   parameter Real h(min=0,max=24)=6 "hour at which night flush ends";
   parameter Real TNitFluCut(min=0,
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=280 "Outdoor air temperature below which night flush sequence does not operate";
  parameter Real TiConInt(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=300  "Time constant for integral term";
  parameter Real kConPro(min=0,max=10)=0.1 "Constant for proportional term";

  NaturalVentilationOnly natVenCon(
    minOpe=minOpe,
    TDryBulCut=TDryBulCut,
    TWetBulDif=TWetBulDif,
    winSpeLim=winSpeLim,
    locTimRai=locTimRai,
    TiFav=TiFav,
    TiNotFav=TiNotFav,
    TiConInt=TiConInt,
    kConPro=kConPro,
    TNitFluCut=TNitFluCut)
    annotation (Placement(transformation(extent={{8,10},{72,74}})));
  Controls.OBC.CDL.Interfaces.BooleanInput uManOveRid
    "Manual override signal- true if override, false if not" annotation (
      Placement(transformation(extent={{-140,72},{-100,112}}),
        iconTransformation(extent={{-140,68},{-100,108}})));
  Controls.OBC.CDL.Interfaces.BooleanInput uRai
    "Rain signal- true if raining; false if not" annotation (Placement(
        transformation(extent={{-140,38},{-100,78}}),  iconTransformation(
          extent={{-140,48},{-100,88}})));
  Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Occupancy signal- true if room is occupied, false if not" annotation (
      Placement(transformation(extent={{-140,10},{-100,50}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Controls.OBC.CDL.Interfaces.RealInput uDryBul
    "Outdoor air dry bulb temperature" annotation (Placement(transformation(
          extent={{-140,-44},{-100,-4}}),  iconTransformation(extent={{-140,-68},
            {-100,-28}})));
  Controls.OBC.CDL.Interfaces.RealInput uWinSpe annotation (Placement(
        transformation(extent={{-140,-74},{-100,-34}}),  iconTransformation(
          extent={{-140,-90},{-100,-50}})));
  Controls.OBC.CDL.Interfaces.RealInput uRooSet "Room setpoint" annotation (
      Placement(transformation(extent={{-140,-112},{-100,-72}}),
        iconTransformation(extent={{-140,-18},{-100,22}})));
  Controls.OBC.CDL.Interfaces.RealInput uWetBul
    "Outdoor air wet bulb temperature" annotation (Placement(transformation(
          extent={{-140,-150},{-100,-110}}), iconTransformation(extent={{-140,2},
            {-100,42}})));
  Controls.OBC.CDL.Interfaces.RealInput uRooMeaTem "Measured room temperature"
    annotation (Placement(transformation(extent={{-140,-182},{-100,-142}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Controls.OBC.CDL.Interfaces.RealInput uForHi
    "Outdoor air dry bulb temperature" annotation (Placement(transformation(
          extent={{-140,-16},{-100,24}}), iconTransformation(extent={{-140,-48},
            {-100,-8}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yNatVenOn
    "True if nat vent is on, false if off"                          annotation (
     Placement(transformation(extent={{100,-102},{140,-62}}),
        iconTransformation(extent={{100,-32},{140,8}})));
  Controls.OBC.CDL.Interfaces.RealOutput yWinOpe
    "Window percent open from nat vent and night flush combined control"
    annotation (Placement(transformation(extent={{100,16},{140,56}}),
        iconTransformation(extent={{100,8},{140,48}})));
  NightFlush.NightFlushFixedDuration nitFluFix(h=h)
    annotation (Placement(transformation(extent={{-78,60},{-58,80}})));
equation
  connect(uManOveRid, natVenCon.uManOveRid) annotation (Line(points={{-120,92},
          {-14,92},{-14,70},{-6,70},{-6,70.16},{1.6,70.16}}, color={255,0,255}));
  connect(uRai, natVenCon.uRai) annotation (Line(points={{-120,58},{-90,58},{-90,
          46},{-8,46},{-8,57.36},{1.6,57.36}}, color={255,0,255}));
  connect(uOcc, natVenCon.uOcc) annotation (Line(points={{-120,30},{-58,30},{-58,
          50.96},{1.6,50.96}}, color={255,0,255}));
  connect(uRooMeaTem, natVenCon.uRooMeaTem) annotation (Line(points={{-120,-162},
          {-22,-162},{-22,13.2},{1.6,13.2}}, color={0,0,127}));
  connect(uWetBul, natVenCon.uWetBul) annotation (Line(points={{-120,-130},{-40,
          -130},{-40,38.8},{1.6,38.8}}, color={0,0,127}));
  connect(uWinSpe, natVenCon.uWinSpe) annotation (Line(points={{-120,-54},{-59,
          -54},{-59,19.6},{1.6,19.6}}, color={0,0,127}));
  connect(uDryBul, natVenCon.uDryBul) annotation (Line(points={{-120,-24},{-80,
          -24},{-80,26},{1.6,26}}, color={0,0,127}));
  connect(natVenCon.yNatVen, yNatVenOn) annotation (Line(points={{78.4,31.76},{
          84,31.76},{84,-82},{120,-82}}, color={255,0,255}));
  connect(natVenCon.yWinOpe, yWinOpe) annotation (Line(points={{78.4,42.64},{
          91.2,42.64},{91.2,36},{120,36}}, color={0,0,127}));
  connect(nitFluFix.yNitFlu, natVenCon.uNitFlu) annotation (Line(points={{-56,
          67.2},{-26,67.2},{-26,63.76},{1.6,63.76}}, color={255,0,255}));
  connect(nitFluFix.yRooSetAdj, natVenCon.uRooSet) annotation (Line(points={{-56,
          75},{-26,75},{-26,32.4},{1.6,32.4}}, color={0,0,127}));
  connect(uForHi, nitFluFix.uForHi) annotation (Line(points={{-120,4},{-92,4},{-92,
          68},{-86,68},{-86,67.2},{-80.2,67.2}}, color={0,0,127}));
  connect(uRooSet, nitFluFix.uRooSet) annotation (Line(points={{-120,-92},{-96,-92},
          {-96,72},{-88,72},{-88,72.2},{-80,72.2}}, color={0,0,127}));
  annotation (defaultComponentName = "natVenNitFluFix",Documentation(info="<html>
    <p>This block combines the fixed duration night flush sequence and daytime natural ventilation. 
  
  <p>~~~~~~~~~~~~~Daytime Natural Ventilation~~~~~~~~~~~~~ 
  

<p>During the day, the window position is modulated to maintain daytime setpoint with direct-acting PI control, with a user-specified constant 
  for the proportional term (kConPro, typically 0.1) and time constant for the integral term (TiConInt, typically 5 minutes). 
  <p>The user also specifies a minimum opening position (minOpe, typically 0.15)- if the window is to be opened, it must be opened at least this amount. 
  If the PI control loop calls for a window position that is less than this minimum value, the window remains closed. 
  
    <p> ~~~~~~~~~~~~~Lockouts~~~~~~~~~~~~~
  <p> Lockouts are determined as specified in Buildings.Experimental.NatVentControl.AllLockouts.
  If any of the six below conditions indicates that natural ventilation should be locked out, natural ventilation is locked out.
  This is true in night flush mode OR in daytime mode.  
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
  <p>~~~~~~~~~~~~~Fixed Duration Night Flush~~~~~~~~~~~~~
  <p> Based on the forecast high for each day, a night flush duration and set point are selected from a lookup table, as shown below. 
  <p>Higher forecast high temperatures yield longer night flush durations and lower night flush setpoints. 
  <p>Below a forecast high of 70F, night flush is not active.
  <p>The user specifies a fixed night flush stop time (h, typically 6 = 6AM) at which night flush stops every day it is active.
 
 <p>
 <table>
<tr><th>Forecast High Temp Above [deg F]</th>       <th>Night Flush Setpoint [deg F] </th>  <th>Duration [hours] </th>      </tr>
<tr><td>70</td>         <td>70</td>  <td>1</td>      </tr>
<tr><td>75</td>         <td>69</td>  <td>2</td>       </tr>
<tr><td>80</td>         <td>67</td>  <td>3</td>      </tr>
<tr><td>85</td>         <td>65</td>  <td>4</td>      </tr>
<tr><td>90</td>         <td>63</td>  <td>5</td>     </tr>

</table>
</p>

During the setpoint duration, the setpoint is changed to the appropriate night flush setpoint. During this specified duration, the night flush signal is set to true.
If night flush is not on, the setpoint passes through the block unchanged and the night flush signal is false. 

  
<p>
</p>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,102},{100,-98}},
          lineColor={162,29,33},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-18,60},{22,60}},
          color={162,29,33},
          thickness=1),
        Line(
          points={{-98,0},{-18,-20}},
          color={162,29,33},
          thickness=1),
        Line(
          points={{-58,50},{-58,-74}},
          color={162,29,33},
          thickness=1),
        Line(
          points={{-98,60},{-98,-60},{-18,-88},{-18,40},{-98,60},{-18,60}},
          color={162,29,33},
          thickness=1),
        Ellipse(
          extent={{92,76},{-48,-68}},
          lineColor={28,108,200},
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-14,74},{94,-68}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          lineColor={0,0,255},
          extent={{-146,106},{154,146}},
          textString="%name")}),            Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-180},{100,100}}), graphics={
          Text(
          extent={{-98,112},{302,80}},
          lineColor={0,0,0},
          lineThickness=1,
          fontSize=9,
          horizontalAlignment=TextAlignment.Left,
          textStyle={TextStyle.Bold},
          textString="Nat Vent Control with Fixed Duration Night Flush")}));
end NaturalVentilationNightFlushFixed;
