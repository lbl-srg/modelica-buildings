within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers;
block Controller "Single zone VAV AHU economizer control sequence"

  parameter Boolean use_enthalpy = false
    "Set to true if enthalpy measurement is used in addition to temperature measurement"
    annotation(Dialog(enable=not use_fixed_plus_differential_drybulb));
  parameter Boolean use_fixed_plus_differential_drybulb = false
    "Set to true to only evaluate fixed plus differential dry bulb temperature high limit cutoff;
    shall not be used with enthalpy"
    annotation(Dialog(enable=not use_enthalpy));
  parameter Boolean use_TMix=true
    "Set to true if mixed air temperature measurement is enabled";
  parameter Boolean use_G36FrePro=false
    "Set to true if G36 freeze protection is implemented";

  parameter Real delTOutHis(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=1
    "Delta between the temperature hysteresis high and low limit"
    annotation(Dialog(tab="Advanced", group="Hysteresis"));

  parameter Real delEntHis(
    final unit="J/kg",
    final quantity="SpecificEnergy")=1000
    "Delta between the enthalpy hysteresis high and low limits"
    annotation(Dialog(tab="Advanced", group="Hysteresis", enable = use_enthalpy));

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

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeFre=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Freeze protection", enable=use_TMix));

  parameter Real kFre(final unit="1/K") = 0.1
    "Gain for mixed air temperature tracking for freeze protection, used if use_TMix=true"
     annotation(Dialog(group="Freeze protection", enable=use_TMix));

  parameter Real TiFre(
    final unit="s",
    final quantity="Time")=120
    "Time constant of controller for mixed air temperature tracking for freeze protection. Require TiFre < TiMinOut"
     annotation(Dialog(group="Freeze protection",
       enable=use_TMix
         and (controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  parameter Real TdFre(
    final unit="s",
    final quantity="Time")=0.1
     "Time constant of derivative block for freeze protection"
     annotation (Dialog(group="Freeze protection",
       enable=use_TMix and
           (controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
           or controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  parameter Real TFreSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") = 277.15
    "Lower limit for mixed air temperature for freeze protection, used if use_TMix=true"
     annotation(Dialog(group="Freeze protection", enable=use_TMix));

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

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSupSet(
    final unit="K",
    final displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Supply air temperature heating setpoint"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}}),
      iconTransformation(extent={{-120,-12},{-100,8}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}}),
      iconTransformation(extent={{-120,4},{-100,24}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-160,130},{-140,150}}),
      iconTransformation(extent={{-120,84},{-100,104}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCut(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Outdoor air temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
    annotation (Placement(transformation(extent={{-160,110},{-140,130}}),
        iconTransformation(extent={{-120,68},{-100,88}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    if use_fixed_plus_differential_drybulb
    "Used only for fixed plus differential dry bulb temperature high limit cutoff"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}}),
        iconTransformation(extent={{-120,52},{-100,72}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}}),
      iconTransformation(extent={{-120,36},{-100,56}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hCut(final unit="J/kg",
      final quantity="SpecificEnergy")
                                     if use_enthalpy
    "Outdoor air enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}}),
        iconTransformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix(
    final unit="K",
    final displayUnit="degC",
    final quantity = "ThermodynamicTemperature") if use_TMix
    "Measured mixed air temperature, used for freeze protection"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}}),
      iconTransformation(extent={{-120,-54},{-100,-34}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOutMinSet_flow(
    final min=VOutMin_flow,
    final max=VOutDes_flow,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}}),
      iconTransformation(extent={{-120,-26},{-100,-6}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSupFanSpe(
    final min=yFanMin,
    final max=yFanMax,
    final unit="1")
    "Supply fan speed"
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}}),
      iconTransformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonSta "Zone state signal"
    annotation (Placement(transformation(extent={{-162,-110},{-140,-88}}),
        iconTransformation(extent={{-120,-92},{-100,-72}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta if use_G36FrePro
    "Freeze protection status"
    annotation (Placement(transformation(extent={{-162,-130},{-140,-108}}),
        iconTransformation(extent={{-120,-106},{-100,-86}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-162,-90},{-140,-68}}),
        iconTransformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan "Supply fan status"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}}),
      iconTransformation(extent={{-120,-66},{-100,-46}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Return air damper position"
    annotation (Placement(transformation(extent={{140,30},{160,50}}),
    iconTransformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{140,-50},{160,-30}}),
    iconTransformation(extent={{100,-50},{120,-30}})));

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable
    enaDis(
    final retDamPhyPosMax=retDamPhyPosMax,
    final use_enthalpy=use_enthalpy,
    final use_fixed_plus_differential_drybulb=
        use_fixed_plus_differential_drybulb,
    final delTOutHis=delTOutHis,
    final delEntHis=delEntHis,
    final retDamPhyPosMin=retDamPhyPosMin)
    "Single zone VAV AHU economizer enable/disable sequence"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Limits
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
    final yDam_VOutDes_maxSpe=yDam_VOutDes_maxSpe)
    "Single zone VAV AHU economizer minimum outdoor air requirement damper limit sequence"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Modulation
    mod(
    final controllerType=controllerTypeMod,
    final k=kMod,
    final Ti=TiMod,
    final Td=TdMod,
    final uMin=uMin,
    final uMax=uMax)
    "Single zone VAV AHU economizer damper modulation sequence"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Generic.FreezeProtectionMixedAir
    freProTMix(
    final controllerType=controllerTypeFre,
    final k=kFre,
    final Ti=TiFre,
    final Td=TdFre,
    final TFreSet=TFreSet) if use_TMix
    "Block that tracks TMix against a freeze protection setpoint"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Max retDamMinFre
    "Minimum position for return air damper due to freeze protection"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Buildings.Controls.OBC.CDL.Reals.Min outDamMaxFre
    "Maximum control signal for outdoor air damper due to freeze protection"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant noTMix1(k=1) if not use_TMix
    "Ignore min evaluation if there is no TMix sensor"
    annotation (Placement(transformation(extent={{60,-66},{80,-46}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant noTMix(k=0) if not use_TMix
    "Ignore max evaluation if there is no TMix sensor"
    annotation (Placement(transformation(extent={{60,46},{80,66}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta(
    final k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage0)
                                                                                       if not use_G36FrePro
    "Freeze protection status is 0. Used if G36 freeze protection is not implemented"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));

public
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi
    "Heating coil control signal" annotation (Placement(transformation(extent={
            {140,92},{160,112}}), iconTransformation(extent={{100,30},{120,50}})));
equation
  connect(uSupFan, enaDis.uSupFan)
    annotation (Line(points={{-150,-60},{-100,-60},{-100,-34},{-21,-34}},
                                                                       color={255,0,255}));
  connect(uFreProSta, enaDis.uFreProSta)
    annotation (Line(points={{-151,-119},{-60,-119},{-60,-30},{-21,-30}},color={255,127,0}));
  connect(TRet, enaDis.TRet)
                            annotation (Line(points={{-150,100},{-28,100},{-28,
          -24},{-21,-24}},
                     color={0,0,127}));
  connect(hCut, enaDis.hCut) annotation (Line(points={{-150,60},{-40,60},{-40,
          -28},{-21,-28}},
                     color={0,0,127}));
  connect(hOut, enaDis.hOut)
    annotation (Line(points={{-150,80},{-36,80},{-36,-26},{-21,-26}},  color={0,0,127}));
  connect(TCut, enaDis.TCut) annotation (Line(points={{-150,120},{-26,120},{-26,
          -22.2},{-21,-22.2}},
                          color={0,0,127}));
  connect(TOut, enaDis.TOut)
    annotation (Line(points={{-150,140},{-24,140},{-24,-20.6},{-21,-20.6}},
                                                                       color={0,0,127}));
  connect(uSupFan, damLim.uSupFan)
    annotation (Line(points={{-150,-60},{-124,-60},{-124,10},{-102,10}},
                                                                      color={255,0,255}));
  connect(uOpeMod, damLim.uOpeMod)
    annotation (Line(points={{-151,-79},{-122,-79},{-122,1.8},{-102,1.8}},
      color={255,127,0}));
  connect(uFreProSta, damLim.uFreProSta)
    annotation (Line(points={{-151,-119},{-110,-119},{-110,6},{-102,6}},
      color={255,127,0}));
  connect(damLim.yOutDamPosMax, enaDis.uOutDamPosMax)
    annotation (Line(points={{-78,16},{-30,16},{-30,-36},{-21,-36}},
                                                                  color={0,0,127}));
  connect(enaDis.yOutDamPosMax, mod.uOutDamPosMax)
    annotation (Line(points={{2,-24},{10,-24},{10,6},{18,6}}, color={0,0,127}));
  connect(enaDis.yRetDamPosMax, mod.uRetDamPosMax)
    annotation (Line(points={{2,-30},{12,-30},{12,12},{18,12}},  color={0,0,127}));
  connect(damLim.yOutDamPosMin, mod.uOutDamPosMin)
    annotation (Line(points={{-78,4},{18,4}}, color={0,0,127}));
  connect(enaDis.yRetDamPosMin, mod.uRetDamPosMin)
    annotation (Line(points={{2,-36},{14,-36},{14,10},{18,10}},  color={0,0,127}));
  connect(uZonSta, enaDis.uZonSta)
    annotation (Line(points={{-151,-99},{-58,-99},{-58,-32},{-21,-32}},  color={255,127,0}));
  connect(uSupFanSpe, damLim.uSupFanSpe)
    annotation (Line(points={{-150,-20},{-126,-20},{-126,14},{-102,14}},color={0,0,127}));
  connect(VOutMinSet_flow, damLim.VOutMinSet_flow)
    annotation (Line(points={{-150,0},{-130,0},{-130,18},{-102,18}},  color={0,0,127}));
  connect(outDamMaxFre.u2, noTMix1.y)
    annotation (Line(points={{98,-56},{82,-56}}, color={0,0,127}));
  connect(retDamMinFre.u1, noTMix.y)
    annotation (Line(points={{98,56},{82,56}}, color={0,0,127}));
  connect(retDamMinFre.y, yRetDamPos)
    annotation (Line(points={{122,50},{126,50},{126,40},{150,40}}, color={0,0,127}));
  connect(outDamMaxFre.y, yOutDamPos)
    annotation (Line(points={{122,-50},{126,-50},{126,-40},{150,-40}}, color={0,0,127}));
  connect(mod.yRetDamPos, retDamMinFre.u2)
    annotation (Line(points={{41,10},{92,10},{92,44},{98,44}},    color={0,0,127}));
  connect(mod.yOutDamPos, outDamMaxFre.u1)
    annotation (Line(points={{41,6},{94,6},{94,-44},{98,-44}},   color={0,0,127}));
  connect(freProTMix.yFrePro, retDamMinFre.u1)
    annotation (Line(points={{82,-13},{86,-13},{86,56},{98,56}}, color={0,0,127}));
  connect(freProTMix.yFreProInv, outDamMaxFre.u2)
    annotation (Line(points={{82,-7},{88,-7},{88,-56},{98,-56}}, color={0,0,127}));
  connect(freProSta.y, enaDis.uFreProSta)
    annotation (Line(points={{-118,-140},{-40,-140},{-40,-30},{-21,-30}},
                                                                        color={255,127,0}));
  connect(freProSta.y, damLim.uFreProSta)
    annotation (Line(points={{-118,-140},{-114,-140},{-114,6},{-102,6}},
      color={255,127,0}));
  connect(uSupFan, mod.uSupFan)
    annotation (Line(points={{-150,-60},{-100,-60},{-100,-10},{18,-10},{18,1}},
      color={255,0,255}));

  connect(mod.yHeaCoi, yHeaCoi) annotation (Line(points={{41,14},{46,14},{46,
          102},{150,102}},
                      color={0,0,127}));
  connect(damLim.yOutDamPosMin, enaDis.uOutDamPosMin) annotation (Line(points={
          {-78,4},{-34,4},{-34,-38},{-21,-38}}, color={0,0,127}));
  connect(TMix, freProTMix.TMix) annotation (Line(points={{-150,-40},{-80,-40},
          {-80,-60},{40,-60},{40,-10},{58,-10}}, color={0,0,127}));
  connect(TSup, mod.TSup) annotation (Line(points={{-150,40},{0,40},{0,18},{18,
          18}}, color={0,0,127}));
  connect(THeaSupSet, mod.THeaSupSet) annotation (Line(points={{-150,20},{-130,
          20},{-130,34},{-4,34},{-4,16},{18,16}}, color={0,0,127}));
annotation (defaultComponentName = "conEco",
        Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
             graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(points={{-66,-36},{-42,-36},{-4,40},{34,40}}, color={0,0,127},
          thickness=0.5),
        Line(
          points={{-64,40},{-38,40},{2,-40},{66,-40}},
          color={0,0,127},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Line(
          points={{34,40},{34,-36},{34,-36},{66,-36}},
          color={0,0,127},
          thickness=0.5),
        Text(
          extent={{-170,142},{158,104}},
          textColor={0,0,127},
          textString="%name")}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},
            {140,160}}),
        graphics={Rectangle(
          extent={{50,100},{130,-100}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                                  Text(
          extent={{56,-86},{134,-96}},
          textColor={95,95,95},
          textString="Freeze protection based on TMix,
not a part of G36",
          horizontalAlignment=TextAlignment.Left)}),
Documentation(info="<html>
<p>
Single zone VAV AHU economizer control sequence that calculates
outdoor and return air damper positions based on ASHRAE
Guidline 36, PART 5 sections: P.4.d, P.5, P.9, P.3.b, A.17.
</p>
<p>
The sequence consists of three subsequences.
<ul>
<li>
First, the block <code>damLim</code> computes the damper position limits to satisfy
outdoor air requirements. See
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Limits\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Limits</a>
for a description.
</li>
<li>
Second, the block <code>enaDis</code> enables or disables the economizer based on
outdoor temperature and optionally enthalpy, and based on the supply fan status,
freeze protection stage and zone state.
See
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable</a>
for a description.
</li>
<li>
Third, the block <code>mod</code> modulates the outdoor and return damper position
to track the supply air temperature setpoint for heating, subject to the limits of the damper positions
that were computed in the above two blocks.
See
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Modulation\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Modulation</a>
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
