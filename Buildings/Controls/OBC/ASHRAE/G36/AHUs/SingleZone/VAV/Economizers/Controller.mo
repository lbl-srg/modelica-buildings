within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers;
block Controller "Single zone VAV AHU economizer control sequence"
  parameter Boolean have_heaCoi=true
    "True if the air handling unit has heating coil";
  parameter Boolean use_enthalpy = false
    "Set to true if enthalpy measurement is used in addition to temperature measurement"
    annotation(Dialog(enable=not use_fixed_plus_differential_drybulb));
  parameter Boolean use_fixed_plus_differential_drybulb = false
    "Set to true to only evaluate fixed plus differential dry bulb temperature high limit cutoff;
    shall not be used with enthalpy"
    annotation(Dialog(enable=not use_enthalpy));
  parameter Real uMin(
    final min=0.1,
    final max=0.9,
    final unit="1") = 0.1
    "Lower limit of controller output at which the dampers are at their limits";
  parameter Real uMax(
    final min=0.1,
    final max=1,
    final unit="1") = 0.9
    "Upper limit of controller output at which the dampers are at their limits";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeMod=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Modulation"));

  parameter Real kMod(final unit="1/K")=1 "Gain of modulation controller"
    annotation(Dialog(group="Modulation"));
  parameter Real TiMod(
    final unit="s",
    final quantity="Time")=300
    "Time constant of modulation controller integrator block"
    annotation (Dialog(group="Modulation",
      enable=controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdMod(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for modulation controller"
    annotation (Dialog(group="Modulation",
      enable=controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real delTOutHys(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=1
    "Delta between the temperature hysteresis high and low limit"
    annotation(Dialog(tab="Advanced", group="Hysteresis"));

  parameter Real delEntHys(
    final unit="J/kg",
    final quantity="SpecificEnergy")=1000
    "Delta between the enthalpy hysteresis high and low limits"
    annotation(Dialog(tab="Advanced", group="Hysteresis", enable = use_enthalpy));
  parameter Real floHys=0.01
    "Near zero flow rate, below which the flow rate or difference will be seen as zero"
    annotation (Dialog(tab="Advanced", group="Hysteresis"));

  parameter Real yFanMin(
    final min=0,
    final max=1,
    final unit="1") = 0.1 "Minimum supply fan operation speed"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real yFanMax(
    final min=0,
    final max=1,
    final unit="1") = 0.9 "Maximum supply fan operation speed"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real VOutMin_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=1.0
    "Calculated minimum outdoor airflow rate"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real VOutDes_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=2.0
    "Calculated design outdoor airflow rate"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real yDam_VOutMin_minSpe(
    final min=outDamPhyPosMin,
    final max=outDamPhyPosMax,
    final unit="1") = 0.4
    "Outdoor air damper position to supply minimum outdoor airflow at minimum fan speed"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real yDam_VOutMin_maxSpe(
    final min=outDamPhyPosMin,
    final max=outDamPhyPosMax,
    final unit="1") = 0.3
    "Outdoor air damper position to supply minimum outdoor airflow at maximum fan speed"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real yDam_VOutDes_minSpe(
    final min=yDam_VOutMin_minSpe,
    final max=outDamPhyPosMax,
    final unit="1") = 0.9
    "Outdoor air damper position to supply design outdoor airflow at minimum fan speed"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real yDam_VOutDes_maxSpe(
    final min=yDam_VOutMin_maxSpe,
    final max=outDamPhyPosMax,
    final unit="1") = 0.8
    "Outdoor air damper position to supply design outdoor airflow at maximum fan speed"
    annotation(Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real outDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the outdoor air damper"
    annotation(Dialog(tab="Commissioning", group="Physical damper position limits"));
  parameter Real outDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the outdoor air damper"
    annotation(Dialog(tab="Commissioning", group="Physical damper position limits"));
  parameter Real retDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the return air damper"
    annotation(Dialog(tab="Commissioning", group="Physical damper position limits"));
  parameter Real retDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the return air damper"
    annotation(Dialog(tab="Commissioning", group="Physical damper position limits"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupHeaEco(
    final unit="K",
    final displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Supply air temperature heating setpoint"
    annotation (Placement(transformation(extent={{-180,20},{-140,60}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-180,50},{-140,90}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-180,200},{-140,240}}),
      iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCut(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Outdoor air temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
    annotation (Placement(transformation(extent={{-180,170},{-140,210}}),
        iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if use_fixed_plus_differential_drybulb
    "Used only for fixed plus differential dry bulb temperature high limit cutoff"
    annotation (Placement(transformation(extent={{-182,138},{-140,180}}),
        iconTransformation(extent={{-140,110},{-100,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-180,110},{-140,150}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hCut(final unit="J/kg",
      final quantity="SpecificEnergy") if use_enthalpy
    "Outdoor air enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-180,80},{-140,120}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOutMinSet_flow(
    final min=VOutMin_flow,
    final max=VOutDes_flow,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-180,-10},{-140,30}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSupFanSpe(
    final min=yFanMin,
    final max=yFanMax,
    final unit="1")
    "Supply fan speed"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonSta "Zone state signal"
    annotation (Placement(transformation(extent={{-180,-170},{-140,-130}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta
    "Freeze protection status"
    annotation (Placement(transformation(extent={{-180,-200},{-140,-160}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-180,-140},{-140,-100}}),
        iconTransformation(extent={{-140,-170},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan "Supply fan status"
    annotation (Placement(transformation(extent={{-180,-110},{-140,-70}}),
      iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPosMin(
    final min=0,
    final max=1,
    final unit="1") "Minimum outdoor damper position"
    annotation (Placement(transformation(extent={{140,160},{180,200}}),
        iconTransformation(extent={{100,140},{140,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi(
    final unit="1",
    final min=0,
    final max=1) if have_heaCoi
    "Heating coil control signal"
    annotation (Placement(transformation(extent={{140,100},{180,140}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Return air damper position"
    annotation (Placement(transformation(extent={{140,30},{180,70}}),
    iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{140,-60},{180,-20}}),
    iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable
    enaDis(
    final retDamPhyPosMax=retDamPhyPosMax,
    final use_enthalpy=use_enthalpy,
    final use_fixed_plus_differential_drybulb=use_fixed_plus_differential_drybulb,
    final delTOutHys=delTOutHys,
    final delEntHys=delEntHys,
    final retDamPhyPosMin=retDamPhyPosMin)
    "Single zone VAV AHU economizer enable/disable sequence"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Limits
    damLim(
    final yFanMin=yFanMin,
    final yFanMax=yFanMax,
    final outDamPhyPosMax=outDamPhyPosMax,
    final outDamPhyPosMin=outDamPhyPosMin,
    final VOutMin_flow=VOutMin_flow,
    final VOutDes_flow=VOutDes_flow,
    final yDam_VOutMin_minSpe=yDam_VOutMin_minSpe,
    final yDam_VOutMin_maxSpe=yDam_VOutMin_maxSpe,
    final yDam_VOutDes_minSpe=yDam_VOutDes_minSpe,
    final yDam_VOutDes_maxSpe=yDam_VOutDes_maxSpe,
    final floHys=floHys)
    "Single zone VAV AHU economizer minimum outdoor air requirement damper limit sequence"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Modulation
    mod(
    final have_heaCoi=have_heaCoi,
    final controllerType=controllerTypeMod,
    final k=kMod,
    final Ti=TiMod,
    final Td=TdMod,
    final uMin=uMin,
    final uMax=uMax)
    "Single zone VAV AHU economizer damper modulation sequence"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

equation
  connect(uSupFan, enaDis.uSupFan)
    annotation (Line(points={{-160,-90},{-120,-90},{-120,-45},{-42,-45}}, color={255,0,255}));
  connect(uFreProSta, enaDis.uFreProSta)
    annotation (Line(points={{-160,-180},{-66,-180},{-66,-41},{-42,-41}},color={255,127,0}));
  connect(TRet, enaDis.TRet) annotation (Line(points={{-161,159},{-54,159},{-54,
          -35},{-42,-35}}, color={0,0,127}));
  connect(hCut, enaDis.hCut) annotation (Line(points={{-160,100},{-70,100},{-70,
          -39},{-42,-39}}, color={0,0,127}));
  connect(hOut, enaDis.hOut)
    annotation (Line(points={{-160,130},{-66,130},{-66,-37},{-42,-37}},color={0,0,127}));
  connect(TCut, enaDis.TCut) annotation (Line(points={{-160,190},{-50,190},{-50,
          -33},{-42,-33}},     color={0,0,127}));
  connect(TOut, enaDis.TOut)
    annotation (Line(points={{-160,220},{-46,220},{-46,-31},{-42,-31}}, color={0,0,127}));
  connect(uSupFan, damLim.uSupFan)
    annotation (Line(points={{-160,-90},{-120,-90},{-120,10},{-102,10}}, color={255,0,255}));
  connect(uOpeMod, damLim.uOpeMod)
    annotation (Line(points={{-160,-120},{-116,-120},{-116,1.8},{-102,1.8}},
      color={255,127,0}));
  connect(uFreProSta, damLim.uFreProSta)
    annotation (Line(points={{-160,-180},{-110,-180},{-110,6},{-102,6}},
      color={255,127,0}));
  connect(damLim.yOutDamPosMax, enaDis.uOutDamPosMax)
    annotation (Line(points={{-78,16},{-58,16},{-58,-47},{-42,-47}}, color={0,0,127}));
  connect(enaDis.yOutDamPosMax, mod.uOutDamPosMax)
    annotation (Line(points={{-18,-34},{-4,-34},{-4,-4},{18,-4}}, color={0,0,127}));
  connect(enaDis.yRetDamPosMax, mod.uRetDamPosMax)
    annotation (Line(points={{-18,-40},{0,-40},{0,2},{18,2}}, color={0,0,127}));
  connect(damLim.yOutDamPosMin, mod.uOutDamPosMin)
    annotation (Line(points={{-78,4},{-62,4},{-62,-6},{18,-6}}, color={0,0,127}));
  connect(enaDis.yRetDamPosMin, mod.uRetDamPosMin)
    annotation (Line(points={{-18,-46},{4,-46},{4,0},{18,0}}, color={0,0,127}));
  connect(uZonSta, enaDis.uZonSta)
    annotation (Line(points={{-160,-150},{-70,-150},{-70,-43},{-42,-43}},color={255,127,0}));
  connect(uSupFanSpe, damLim.uSupFanSpe)
    annotation (Line(points={{-160,-20},{-126,-20},{-126,14},{-102,14}},color={0,0,127}));
  connect(VOutMinSet_flow, damLim.VOutMinSet_flow)
    annotation (Line(points={{-160,10},{-130,10},{-130,18},{-102,18}},color={0,0,127}));
  connect(mod.yHeaCoi, yHeaCoi) annotation (Line(points={{42,6},{50,6},{50,120},
          {160,120}}, color={0,0,127}));
  connect(damLim.yOutDamPosMin, enaDis.uOutDamPosMin) annotation (Line(points={{-78,4},
          {-62,4},{-62,-49},{-42,-49}}, color={0,0,127}));
  connect(TSup, mod.TSup) annotation (Line(points={{-160,70},{0,70},{0,8},{18,8}},
                color={0,0,127}));
  connect(TSupHeaEco,mod.TSupHeaEco)  annotation (Line(points={{-160,40},{-4,40},
          {-4,6},{18,6}}, color={0,0,127}));
  connect(uSupFan, mod.uSupFan) annotation (Line(points={{-160,-90},{-120,-90},{
          -120,-9},{18,-9}}, color={255,0,255}));
  connect(mod.yRetDamPos, yRetDamPos) annotation (Line(points={{42,0},{60,0},{60,
          50},{160,50}}, color={0,0,127}));
  connect(mod.yOutDamPos, yOutDamPos) annotation (Line(points={{42,-6},{60,-6},{
          60,-40},{160,-40}}, color={0,0,127}));
  connect(damLim.yOutDamPosMin, yOutDamPosMin) annotation (Line(points={{-78,4},
          {-40,4},{-40,180},{160,180}}, color={0,0,127}));

annotation (defaultComponentName = "conEco",
        Icon(coordinateSystem(extent={{-100,-200},{100,200}}),
             graphics={Rectangle(
        extent={{-100,-200},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(points={{-66,-118},{-32,-118},{20,120},{60,120}}, color={0,0,127},
          thickness=0.5),
        Line(
          points={{-68,120},{-40,120},{28,-120},{90,-120}},
          color={0,0,127},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Line(
          points={{60,120},{60,-36},{60,-104},{88,-104}},
          color={0,0,127},
          thickness=0.5),
        Text(
          extent={{-100,240},{100,200}},
          lineColor={0,0,255},
          textString="%name")}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-240},
            {140,240}})),
Documentation(info="<html>
<p>
Single zone VAV AHU economizer control sequence that calculates
outdoor and return air damper positions based on Section 5.18.5, 5.18.6, 5.18.7, 5.1.17
of ASHRAE Guidline 36, May 2020.
</p>
<p>
The sequence consists of three subsequences.
<ul>
<li>
First, the block <code>damLim</code> computes the damper position limits to satisfy
outdoor air requirements. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Limits\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Limits</a>
for a description.
</li>
<li>
Second, the block <code>enaDis</code> enables or disables the economizer based on
outdoor temperature and optionally enthalpy, and based on the supply fan status,
freeze protection stage and zone state.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable</a>
for a description.
</li>
<li>
Third, the block <code>mod</code> modulates the outdoor and return damper position
to track the supply air temperature setpoint for heating, subject to the limits of the damper positions
that were computed in the above two blocks.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Modulation\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Modulation</a>
for a description.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
July 30, 2019, by Kun Zhang:<br/>
Added fixed plus differential dry bulb temperature high limit cut off.
</li>
<li>
October 31, 2018, by David Blum:<br/>
Added heating coil output.
</li>
<li>
June 28, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
