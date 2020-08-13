within Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1;
block Setpoints "Specify zone minimum outdoor air and minimum airflow set points"
  CDL.Interfaces.RealInput                        TZon(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-260,210},{-220,250}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  CDL.Interfaces.RealInput                        TDis(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC") "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-260,170},{-220,210}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  CDL.Continuous.Feedback feedback
    annotation (Placement(transformation(extent={{-190,220},{-170,240}})));
  CDL.Continuous.Hysteresis cooSup(uLow=-dT, uHigh=dT)
    "Check if it is supplying cooling"
    annotation (Placement(transformation(extent={{-140,220},{-120,240}})));
  CDL.Conversions.BooleanToReal airDisEff(realTrue=EzC, realFalse=EzH)
    "Air distribution effectiveness"
    annotation (Placement(transformation(extent={{-100,220},{-80,240}})));
  CDL.Interfaces.RealInput                        ppmCO2 if have_CO2Sen
    "Detected CO2 conventration"
    annotation (Placement(transformation(extent={{-260,120},{-220,160}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  CDL.Continuous.Line lin "CO2 control loop"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  CDL.Continuous.Sources.Constant zer(k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));
  CDL.Continuous.Sources.Constant one(k=1) "Constant one"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  CDL.Continuous.Sources.Constant co2Set(k=CO2Set) "CO2 setpoint"
    annotation (Placement(transformation(extent={{-200,150},{-180,170}})));
  CDL.Continuous.AddParameter addPar(p=-200) "Lower threshold of CO2 setpoint"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  CDL.Interfaces.IntegerInput                        uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-260,50},{-220,90}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  CDL.Integers.Equal inOccMod "Check if it is in occupied mode"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  CDL.Conversions.BooleanToReal booToRea "Convert boolean to real"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  CDL.Continuous.Product co2Con "Corrected CO2 control loop output"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  CDL.Continuous.Line occMinAirSet "Modified occupied minimum airflow setpoint"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  CDL.Continuous.Sources.Constant zer1(k=Vmin)
    "Zone minimum airflow setpoint Vmin"
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));
  CDL.Continuous.Sources.Constant zer2(k=Vcool_max)
    "Maximum cooling airflow setpoint"
    annotation (Placement(transformation(extent={{-200,-50},{-180,-30}})));
  CDL.Continuous.Line popBreOutAir
    "Modified population componenet of the required breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  CDL.Continuous.Sources.Constant zer3(k=Vbz_P)
    "Normal population component of the required breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-200,-90},{-180,-70}})));
  CDL.Interfaces.IntegerInput uZonSta if is_parFanPow "Zone state" annotation (
      Placement(transformation(extent={{-260,-140},{-220,-100}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  CDL.Integers.Equal inCooSta if is_parFanPow "Check if it is in cooling state"
    annotation (Placement(transformation(extent={{-140,-130},{-120,-110}})));
  CDL.Logical.Switch maxFloCO2 if is_parFanPow
    "Maximum airflow set point for CO2"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  CDL.Interfaces.RealInput VParFan_flow(final quantity="VolumeFlowRate", final
      unit="m3/s") if is_parFanPow "Parallel fan airflow rate" annotation (
      Placement(transformation(extent={{-260,-210},{-220,-170}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  CDL.Continuous.Feedback difCooMax if is_parFanPow
    "Maximum cooling airflw set point minus parallel fan airflow"
    annotation (Placement(transformation(extent={{-140,-180},{-120,-160}})));
protected
  CDL.Integers.Sources.Constant occMod(final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Occupied mode"
    annotation (Placement(transformation(extent={{-200,30},{-180,50}})));
protected
  CDL.Integers.Sources.Constant cooSta(final k=Buildings.Controls.OBC.ASHRAE.G36.Types.ZoneStates.cooling) if
       is_parFanPow "Cooling state"
    annotation (Placement(transformation(extent={{-200,-162},{-180,-142}})));
equation
  connect(TZon, feedback.u1)
    annotation (Line(points={{-240,230},{-192,230}}, color={0,0,127}));
  connect(TDis, feedback.u2) annotation (Line(points={{-240,190},{-180,190},{
          -180,218}}, color={0,0,127}));
  connect(feedback.y, cooSup.u)
    annotation (Line(points={{-168,230},{-142,230}}, color={0,0,127}));
  connect(cooSup.y, airDisEff.u)
    annotation (Line(points={{-118,230},{-102,230}}, color={255,0,255}));
  connect(co2Set.y, addPar.u)
    annotation (Line(points={{-178,160},{-142,160}}, color={0,0,127}));
  connect(addPar.y, lin.x1) annotation (Line(points={{-118,160},{-100,160},{
          -100,148},{-82,148}}, color={0,0,127}));
  connect(zer.y, lin.f1) annotation (Line(points={{-178,110},{-150,110},{-150,
          144},{-82,144}}, color={0,0,127}));
  connect(ppmCO2, lin.u)
    annotation (Line(points={{-240,140},{-82,140}}, color={0,0,127}));
  connect(co2Set.y, lin.x2) annotation (Line(points={{-178,160},{-160,160},{
          -160,136},{-82,136}}, color={0,0,127}));
  connect(one.y, lin.f2) annotation (Line(points={{-118,110},{-100,110},{-100,
          132},{-82,132}}, color={0,0,127}));
  connect(uOpeMod, inOccMod.u1)
    annotation (Line(points={{-240,70},{-142,70}}, color={255,127,0}));
  connect(occMod.y, inOccMod.u2) annotation (Line(points={{-178,40},{-160,40},{
          -160,62},{-142,62}}, color={255,127,0}));
  connect(inOccMod.y, booToRea.u)
    annotation (Line(points={{-118,70},{-82,70}}, color={255,0,255}));
  connect(lin.y, co2Con.u1) annotation (Line(points={{-58,140},{-50,140},{-50,
          116},{-42,116}}, color={0,0,127}));
  connect(booToRea.y, co2Con.u2) annotation (Line(points={{-58,70},{-50,70},{
          -50,104},{-42,104}}, color={0,0,127}));
  connect(zer.y, occMinAirSet.x1) annotation (Line(points={{-178,110},{-150,110},
          {-150,38},{18,38}}, color={0,0,127}));
  connect(zer1.y, occMinAirSet.f1) annotation (Line(points={{-178,0},{-168,0},{
          -168,34},{18,34}}, color={0,0,127}));
  connect(one.y, occMinAirSet.x2) annotation (Line(points={{-118,110},{-100,110},
          {-100,26},{18,26}}, color={0,0,127}));
  connect(zer2.y, occMinAirSet.f2) annotation (Line(points={{-178,-40},{-20,-40},
          {-20,22},{18,22}}, color={0,0,127}));
  connect(co2Con.y, occMinAirSet.u) annotation (Line(points={{-18,110},{0,110},
          {0,30},{18,30}}, color={0,0,127}));
  connect(zer.y, popBreOutAir.x1) annotation (Line(points={{-178,110},{-150,110},
          {-150,-2},{18,-2}}, color={0,0,127}));
  connect(zer.y, popBreOutAir.f1) annotation (Line(points={{-178,110},{-150,110},
          {-150,-6},{18,-6}}, color={0,0,127}));
  connect(one.y, popBreOutAir.x2) annotation (Line(points={{-118,110},{-100,110},
          {-100,-14},{18,-14}}, color={0,0,127}));
  connect(zer3.y, popBreOutAir.f2) annotation (Line(points={{-178,-80},{-16,-80},
          {-16,-18},{18,-18}}, color={0,0,127}));
  connect(co2Con.y, popBreOutAir.u) annotation (Line(points={{-18,110},{0,110},
          {0,-10},{18,-10}}, color={0,0,127}));
  connect(uZonSta, inCooSta.u1) annotation (Line(points={{-240,-120},{-192,-120},
          {-192,-120},{-142,-120}}, color={255,127,0}));
  connect(cooSta.y, inCooSta.u2) annotation (Line(points={{-178,-152},{-160,
          -152},{-160,-128},{-142,-128}}, color={255,127,0}));
  connect(inCooSta.y, maxFloCO2.u2)
    annotation (Line(points={{-118,-120},{-82,-120}}, color={255,0,255}));
  connect(zer2.y, maxFloCO2.u1) annotation (Line(points={{-178,-40},{-100,-40},
          {-100,-112},{-82,-112}}, color={0,0,127}));
  connect(zer2.y, difCooMax.u1) annotation (Line(points={{-178,-40},{-150,-40},
          {-150,-170},{-142,-170}}, color={0,0,127}));
  connect(VParFan_flow, difCooMax.u2) annotation (Line(points={{-240,-190},{
          -130,-190},{-130,-182}}, color={0,0,127}));
  connect(difCooMax.y, maxFloCO2.u3) annotation (Line(points={{-118,-170},{-100,
          -170},{-100,-128},{-82,-128}}, color={0,0,127}));
  connect(maxFloCO2.y, occMinAirSet.f2) annotation (Line(points={{-58,-120},{
          -20,-120},{-20,22},{18,22}}, color={0,0,127}));

annotation (
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-220,-260},{200,260}})),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-260},{200,260}})),
  Documentation(info="<html>
<p>
This sequence sets the zone minimum outdoor air and minimum airflow setpoints, for
compliance with the ventilation rate procedure of ASHRAE Standard 62.1-2016. The
implementation is according to ASHRAE Guideline36, Section 5.2.1.3. The calculation
is done following the steps below.
</p>
<p>
1. For every zone that requires mechanical ventilation, the zone minimum outdoor airflows
and set points shall be calculated depending on the governing standard or code for
outdoor air requirements.
</p>
<p>
2. According to section 3.1.2 of Guideline 36, the zone minimum airflow setpoint
<code>VZonMin_flow</code> should be provided by designer.
</p>
<h4>Zone ventilation set points</h4>
<p>
According to Section 3.1.1.2 of Guideline 36, 
</p>
<ul>
<li>
The area component of the breathing zone outdoor airflow is the zone flow area
<code>AZon</code> times the outdoor airflow rate per unit area
<code>outAirRat_area</code>, as given in ASHRAE Standard 62.1-2016, Table 6.2.2.1.
</li>
<li>
The population component of the breathing zone outdoor airflow is the zone design
popuation <code>desZonPop</code> times the outdoor airflow rate per occupant
<code>outAirRat_occupant</code>, as given in ASHRAE Standard 62.1-2016, Table 6.2.2.1.
</li>
</ul>
<h4>Zone air distribution effectiveness</h4>
<ul>
<li>
If the discharge air temperature <code>TDis</code> at the terminal unit is less than
or equal to zone space temperature <code>TZon</code>, the effectiveness should be
the zone cooling air distribution effectiveness <code>zonDisEff_cool</code> and defaults
it to 1.0 if no value is scheduled.
</li>
<li>
If the discharge air temperature <code>TDis</code> at the terminal unit is greater than
zone space temperature <code>TZon</code>, the effectiveness should be
the zone heating air distribution effectiveness <code>zonDisEff_heat</code> and defaults
it to 0.8 if no value is scheduled.
</li>
</ul>
<h4>Population component of the breathing zone outdoor airflow</h4>
<p>
The population component of the breathing zone outdoor airflow should normally equal
to the value calculated above. However, it would be modified as noted in below.
</p>
<h4>Occupied minimum airflow</h4>
<p>
The occupied minimum airflow shall be equal to <code>VZonMin_flow</code> except as
noted in below.
</p>
<h4>Modify the set points</h4>
<p>
The required zone outdoor airflow shall be calculated as the sum of area and population
components of breathing zone outdoor airflow divided by air distribution effectiveness.
The normal value of the area and population components are modified if any of the
following conditions are met, in order from higher to lower priority:
</p>
<ol>
<li>
If the zone is any mode other than occupied mode, and for zones that have window
switches and the window is open: the area and population components of breathing
zone outdoor airflow, and the occupied minimum airflow rate should be zero.
</li>
<li>
If the zone has an occupancy sensor, is unpopulated, and occupied-standby mode is
permitted: the area and population components of breathing zone outdoor airflow,
and the occupied minimum airflow rate should be zero.
</li>
<li>
Else, if the zone has an occupancy sensor, is unpopulated, but occupied-standby mode
is not permitted: the population components of breathing zone outdoor airflow
should be zero and the occupied minimum airflow rate should be <code>VZonMin_flow</code>.
</li>
<li>
If the zone has a CO2 sensor:
</li>
<ol type=\"i\">
<li>
Specify CO2 setpoint <code>ppmCO2Set</code> according to Section 3.1.1.3 of Guideline 36.
</li>
<li>
During occupied mode, a P-only loop shall maintain CO2 concentration at setpoint;
reset from 0% at set point minus 200 PPM and to 100% at setpoint.
</li>
<li>
Loop is disabled and output set to zero when the zone is not in occupied mode.
</li>
<li>
For cooling-only VAV terminal units, reheat VAV terminal units, constant-volume series
fan-powered terminal units, dual-duct VAV terminal units with mixing control and inlet
airflow sensors, dual-duct VAV terminal units with mixing control and a discharge
airflow sensor, or dual-duct VAV terminal units with cold-duct minimum control:
</li>
<ul>
<li>
The CO2 control loop output shall reset both the occupied minimum airflow setpoint
and the population component of the required breathing zone outdoor airflow in parallel.
The occupied minimum airflow setpoint shall be reset from the zone minimum airflow
setpoint <code>VZonMin_flow</code> at 0% loop output up to maximum cooling airflow
setpoint <code>VZonCooMax_flow</code> at 100% loop output. 
</li>
</ul>

</ol>



</ol>








      
<p>
This sequence sets the thermal zone cooling and heating setpoints. The implementation
is according to the ASHRAE Guideline 36, Section 5.3.2. The calculation is done
following the steps below.
</p>
<h4>Each zone shall have separate occupied and unoccupied heating and cooling
setpoints.</h4>
<h4>The active setpoints shall be determined by the operation mode of the zone
group.</h4>
<ul>
<li>The setpoints shall be the occupied setpoints during occupied, warm-up, and
cooldown modes.</li>
<li>The setpoints shall be the unoccupied setpoints during unoccupied, setback,
and setup modes.</li>
</ul>
<h4>The software shall prevent</h4>
<ul>
<li>The heating setpoint from exceeding the cooling setpoint minus 0.5 &deg;C
(1 &deg;F), i.e. the minimum difference between heating and cooling setpoint
shall be 0.5 &deg;C (1 &deg;F).</li>
<li>The unoccupied heating setpoint from exceeding the occupied heating
setpoint.</li>
<li>The unoccupied cooling setpoint from being less than occupied cooling
setpoint.</li>
</ul>
<h4>Where the zone has a local setpoint adjustment knob/button </h4>
<ul>
<li>The setpoint adjustment offsets established by the occupant shall be software
points that are persistent (e.g. not reset daily), but the actual offset used
in control logic shall be adjusted based on limits and modes as described below.</li>
<li>The adjustment shall be capable of being limited in softare. (a. As a default,
the active occupied cooling setpoint shall be limited between 22 &deg;C
(72 &deg;F) and 27 &deg;C (80 &deg;F); b. As a default, the active occupied
heating setpoint shall be limited between 18 &deg;C (65 &deg;F) and 22 &deg;C
(72 &deg;F);)</li>
<li>The active heating and cooling setpoint shall be independently adjustable,
respecting the limits and anti-overlap logic described above. If zone thermostat
provides only a single setpoint adjustment, then the adjustment shall move both
the same amount, within the limits described above.</li>
<li>The adjustment shall only affect occupied setpoints in occupied mode, warm-up mode
and cooldown mode and shall have no impact on setpoints in all other modes.</li>
<li>At the onset of demand limiting, the local setpoint adjustment value shall
be frozen. Further adjustment of the setpoint by local controls shall be suspended
for the duration of the demand limit event.</li>
</ul>
<h4>Cooling demand limit setpoint adjustment</h4>
<p>The active cooling setpoints for all zones shall be increased when a demand limit
is imposed on the associated zone group. The operator shall have the ability
to exempt individual zones from this adjustment through the normal
Building Automation System (BAS) user interface. Changes due to demand limits
are not cumulative.</p>
<ul>
<li>At Demand Limit Level 1, increase setpoint by 0.5 &deg;C (1 &deg;F).</li>
<li>At Demand Limit Level 2, increase setpoint by 1 &deg;C (2 &deg;F).</li>
<li>At Demand Limit Level 3, increase setpoint by 2 &deg;C (4 &deg;F).</li>
</ul>
<h4>Heating demand limit setpoint adjustment</h4>
<p>The active heating setpoints for all zones shall be decreased when a demand limit
is imposed on the associated zone group. The operator shall have the ability
to exempt individual zones from this adjustment through the normal BAS user
interface. Changes due to demand limits are not cumulative.</p>
<ul>
<li>At Demand Limit Level 1, decrease setpoint by 0.5 &deg;C (1 &deg;F).</li>
<li>At Demand Limit Level 2, decrease setpoint by 1 &deg;C (2 &deg;F).</li>
<li>At Demand Limit Level 3, decrease setpoint by 2 &deg;C (4 &deg;F).</li>
</ul>
<h4>Window switches</h4>
<p>For zones that have operable windows with indicator switches, when the window
switch indicates the window is open, the heating setpoint shall be temporarily
set to 4 &deg;C (40 &deg;F) and the cooling setpoint shall be temporarily
set to 49 &deg;C (120 &deg;F). When the window switch indicates the window is
open during other than Occupied Mode, a Level 4 alarm shall be generated.</p>
<h4>h. Occupancy sensor</h4>
<ul>
<li>When the switch indicates the space has been unpopulated for 5 minutes
continuously during the Occupied Mode, the active heating setpoint shall be
decreased by 0.5 &deg;C (1 &deg;F) and the cooling setpoint shall be increased
by 0.5 &deg;C (1 &deg;F).</li>
<li>When the switch indicated that the space has been populated for 1 minute
continuously, the active heating and cooling setpoints shall be restored to
their previously values.</li>
</ul>
<p>Hierarchy of setpoint adjustments: the following adjustment restrictions
shall prevail in order from highest to lowest priority.</p>
<ul>
<li>Setpoint overlap restriction</li>
<li>Absolute limits on local setpoint adjustment</li>
<li>Window swtiches</li>
<li>Demand limit (a. Occupancy sensors; b. Local setpoint adjustment)</li>
<li>Scheduled setpoints based on zone group mode</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
August 12, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Setpoints;
