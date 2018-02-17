within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers;
model Controller "Single zone VAV AHU economizer control sequence"

  parameter Boolean use_enthalpy = false
    "Set to true if enthalpy measurement is used in addition to temperature measurement";
  parameter Boolean use_TMix=true
    "Set to true if mixed air temperature measurement is enabled";
  parameter Boolean use_G36FrePro=false
    "Set to true if G36 freeze protection is implemented";

  parameter Modelica.SIunits.TemperatureDifference delTOutHis=1
    "Delta between the temperature hysteresis high and low limit"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Hysteresis"));

  parameter Modelica.SIunits.SpecificEnergy delEntHis=1000
    "Delta between the enthalpy hysteresis high and low limits"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Hysteresis", enable = use_enthalpy));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeMod=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Modulation"));

  parameter Real kMod(final unit="1/K")=1 "Gain of modulation controller"
    annotation(Dialog(group="Modulation"));

  parameter Modelica.SIunits.Time TiMod=300
    "Time constant of modulation controller integrator block"
    annotation (Dialog(group="Modulation",
      enable=controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.SIunits.Time TdMod=0.1
    "Time constant of derivative block for modulation controller"
    annotation (Dialog(group="Modulation",
      enable=controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real uMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Lower limit of controller output uTSup at which the dampers are at their limits";
  parameter Real uMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Upper limit of controller output uTSup at which the dampers are at their limits";

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeFre=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Freeze protection", enable=use_TMix));

  parameter Real kFre(final unit="1/K") = 0.1
    "Gain for mixed air temperature tracking for freeze protection, used if use_TMix=true"
     annotation(Dialog(group="Freeze protection", enable=use_TMix));

  parameter Modelica.SIunits.Time TiFre=120
    "Time constant of controller for mixed air temperature tracking for freeze protection. Require TiFre < TiMinOut"
     annotation(Dialog(group="Freeze protection",
       enable=use_TMix
         and (controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

   parameter Modelica.SIunits.Time TdFre=0.1
     "Time constant of derivative block for freeze protection"
     annotation (Dialog(group="Freeze protection",
       enable=use_TMix and
           (controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
           or controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  parameter Modelica.SIunits.Temperature TFreSet = 277.15
    "Lower limit for mixed air temperature for freeze protection, used if use_TMix=true"
     annotation(Dialog(group="Freeze protection", enable=use_TMix));

  parameter Real yFanMin(
    final min=0,
    final max=1,
    final unit="1") = 0.1 "Minimum supply fan operation speed"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real yFanMax(
    final min=0,
    final max=1,
    final unit="1") = 0.9 "Maximum supply fan operation speed"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Modelica.SIunits.VolumeFlowRate VOutMin_flow=1.0
    "Calculated minimum outdoor airflow rate"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Modelica.SIunits.VolumeFlowRate VOutDes_flow=2.0
    "Calculated design outdoor airflow rate"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real minVOutMinFansSpePos(
    final min=outDamPhyPosMin,
    final max=outDamPhyPosMax,
    final unit="1") = 0.4
    "OA damper position to supply minimum outdoor airflow at minimum fan speed"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real yDam_VOutMin_maxSpe(
    final min=outDamPhyPosMin,
    final max=outDamPhyPosMax,
    final unit="1") = 0.3
    "OA damper position to supply minimum outdoor airflow at maximum fan speed"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real yDam_VOutDes_minSpe(
    final min=minVOutMinFansSpePos,
    final max=outDamPhyPosMax,
    final unit="1") = 0.9
    "OA damper position to supply design outdoor airflow at minimum fan speed"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real yDam_VOutDes_maxSpe(
    final min=yDam_VOutMin_maxSpe,
    final max=outDamPhyPosMax,
    final unit="1") = 0.8
    "OA damper position to supply design outdoor airflow at maximum fan speed"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real outDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the outdoor air (OA) damper"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Physical damper position limits"));
  parameter Real outDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the outdoor air damper"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Physical damper position limits"));
  parameter Real retDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the return air damper"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Physical damper position limits"));
  parameter Real retDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the return air damper"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Physical damper position limits"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSupSet(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Supply air temperature heating setpoint"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}}),
      iconTransformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}}),
      iconTransformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Outdoor air (OA) temperature"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}}),
      iconTransformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutCut(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "OA temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}}),
      iconTransformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}}),
      iconTransformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOutCut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix(
    final unit="K",
    final quantity = "ThermodynamicTemperature") if use_TMix
    "Measured mixed air temperature, used for freeze protection"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}}),
      iconTransformation(extent={{-120,-50},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOutMinSet_flow(
    final min=VOutMin_flow,
    final max=VOutDes_flow,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSupFanSpe(
    final min=yFanMin,
    final max=yFanMax,
    final unit="1")
    "Supply fan speed"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}}),
      iconTransformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonSta "Zone state signal"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}}),
        iconTransformation(extent={{-120,-110},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta if use_G36FrePro
    "Freeze protection status"
    annotation (Placement(transformation(extent={{-140,-130},{-120,-110}}),
      iconTransformation(extent={{-120,-130},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}}),
      iconTransformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan "Supply fan status"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}}),
      iconTransformation(extent={{-120,-70},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Return air damper position"
    annotation (Placement(transformation(extent={{160,30},{180,50}}),
    iconTransformation(extent={{100,10}, {120,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{160,-50},{180,-30}}),
    iconTransformation(extent={{100,-30}, {120,-10}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Enable enaDis(
    final retDamPhyPosMax=retDamPhyPosMax,
    final use_enthalpy=use_enthalpy,
    final delTOutHis=delTOutHis,
    final delEntHis=delEntHis,
    final retDamPhyPosMin=retDamPhyPosMin)
    "Single zone VAV AHU economizer enable/disable sequence"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Limits damLim(
    final yFanMin=yFanMin,
    final yFanMax=yFanMax,
    final outDamPhyPosMax=outDamPhyPosMax,
    final outDamPhyPosMin=outDamPhyPosMin,
    final VOutMin_flow=VOutMin_flow,
    final VOutDes_flow=VOutDes_flow,
    final minVOutMinFansSpePos=minVOutMinFansSpePos,
    final yDam_VOutMin_maxSpe=yDam_VOutMin_maxSpe,
    final yDam_VOutDes_minSpe=yDam_VOutDes_minSpe,
    final yDam_VOutDes_maxSpe=yDam_VOutDes_maxSpe)
    "Single zone VAV AHU economizer minimum outdoor air requirement damper limit sequence"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Modulation
    mod(
    final controllerType=controllerTypeMod,
    final k=kMod,
    final Ti=TiMod,
    final Td=TdMod,
    final uMin=uMin,
    final uMax=uMax)
    "Single zone VAV AHU economizer damper modulation sequence"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.FreezeProtectionMixedAir freProTMix(
    final controllerType=controllerTypeFre,
    final k=kFre,
    final Ti=TiFre,
    final Td=TdFre,
    final TFreSet=TFreSet) if use_TMix
    "Block that tracks TMix against a freeze protection setpoint"
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Max retDamMinFre
    "Minimum position for return air damper due to freeze protection"
    annotation (Placement(transformation(extent={{120,40},{140,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Min outDamMaxFre
    "Maximum control signal for outdoor air damper due to freeze protection"
    annotation (Placement(transformation(extent={{120,-60},{140,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant noTMix1(k=1) if not use_TMix
    "Ignore min evaluation if there is no TMix sensor"
    annotation (Placement(transformation(extent={{80,-66},{100,-46}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant noTMix(k=0) if not use_TMix
    "Ignore max evaluation if there is no TMix sensor"
    annotation (Placement(transformation(extent={{80,46},{100,66}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage0) if not use_G36FrePro
    "Freeze protection status is 0. Used if G36 freeze protection is not implemented"
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));

equation
  connect(uSupFan, enaDis.uSupFan)
    annotation (Line(points={{-130,-40},{-80,-40},{-80,-32},{-1,-32}}, color={255,0,255}));
  connect(uFreProSta, enaDis.uFreProSta)
    annotation (Line(points={{-130,-120},{-60,-120},{-60,-28},{-1,-28}}, color={255,127,0}));
  connect(hOutCut, enaDis.hOutCut)
    annotation (Line(points={{-130,80},{-46,80},{-46,-26},{-1,-26}}, color={0,0,127}));
  connect(hOut, enaDis.hOut)
    annotation (Line(points={{-130,100},{-44,100},{-44,-24},{-1,-24}}, color={0,0,127}));
  connect(TOutCut, enaDis.TOutCut)
    annotation (Line(points={{-130,120},{-42,120},{-42,-22},{-1,-22}}, color={0,0,127}));
  connect(TOut, enaDis.TOut)
    annotation (Line(points={{-130,140},{-40,140},{-40,-20},{-1,-20}}, color={0,0,127}));
  connect(uSupFan, damLim.uSupFan)
    annotation (Line(points={{-130,-40},{-104,-40},{-104,8},{-81,8}}, color={255,0,255}));
  connect(uOpeMod, damLim.uOpeMod)
    annotation (Line(points={{-130,-80},{-102,-80},{-102,4},{-102,5},{-81,5}}, color={255,127,0}));
  connect(uFreProSta, damLim.uFreProSta)
    annotation (Line(points={{-130,-120},{-90,-120},{-90,2},{-81,2}}, color={255,127,0}));
  connect(damLim.yOutDamPosMax, enaDis.uOutDamPosMax)
    annotation (Line(points={{-59,6},{-28,6},{-28,-34},{-1,-34}}, color={0,0,127}));
  connect(damLim.yOutDamPosMin, enaDis.uOutDamPosMin)
    annotation (Line(points={{-59,14},{-26,14},{-26,12},{-26,-36},{-1,-36}}, color={0,0,127}));
  connect(enaDis.yOutDamPosMax, mod.uOutDamPosMax)
    annotation (Line(points={{22,-25.2},{30,-25.2},{30,6},{39,6}},  color={0,0,127}));
  connect(enaDis.yRetDamPosMax, mod.uRetDamPosMax)
    annotation (Line(points={{22,-32},{32,-32},{32,13},{39,13}}, color={0,0,127}));
  connect(damLim.yOutDamPosMin, mod.uOutDamPosMin)
    annotation (Line(points={{-59,14},{0,14},{0,3},{39,3}}, color={0,0,127}));
  connect(THeaSupSet, mod.THeaSupSet)
    annotation (Line(points={{-130,40},{32,40},{32,17},{39,17}}, color={0,0,127}));
  connect(TSup, mod.TSup)
    annotation (Line(points={{-130,60},{30,60},{30,20},{39,20}}, color={0,0,127}));
  connect(enaDis.yRetDamPosMin, mod.uRetDamPosMin)
    annotation (Line(points={{22,-38},{34,-38},{34,10},{39,10}}, color={0,0,127}));
  connect(uZonSta, enaDis.uZonSta)
    annotation (Line(points={{-130,-100},{-58,-100},{-58,-30},{-1,-30}}, color={255,127,0}));
  connect(uSupFanSpe, damLim.uSupFanSpe)
    annotation (Line(points={{-130,0},{-106,0},{-106,13.8},{-81,13.8}}, color={0,0,127}));
  connect(VOutMinSet_flow, damLim.VOutMinSet_flow)
    annotation (Line(points={{-130,20},{-106,20},{-106,17},{-81,17}}, color={0,0,127}));
  connect(outDamMaxFre.u2, noTMix1.y)
    annotation (Line(points={{118,-56},{101,-56}}, color={0,0,127}));
  connect(retDamMinFre.u1, noTMix.y)
    annotation (Line(points={{118,56},{101,56}}, color={0,0,127}));
  connect(retDamMinFre.y, yRetDamPos)
    annotation (Line(points={{141,50},{150,50},{150,40},{170,40}}, color={0,0,127}));
  connect(outDamMaxFre.y, yOutDamPos)
    annotation (Line(points={{141,-50},{150,-50},{150,-40},{170,-40}}, color={0,0,127}));
  connect(mod.yRetDamPos, retDamMinFre.u2)
    annotation (Line(points={{61,12},{110,12},{110,44},{118,44}}, color={0,0,127}));
  connect(mod.yOutDamPos, outDamMaxFre.u1)
    annotation (Line(points={{61,8},{110,8},{110,-44},{118,-44}},color={0,0,127}));
  connect(freProTMix.yFrePro, retDamMinFre.u1)
    annotation (Line(points={{101,-4},{106,-4},{106,56},{118,56}}, color={0,0,127}));
  connect(freProTMix.yFreProInv, outDamMaxFre.u2)
    annotation (Line(points={{101,-16},{106,-16},{106,-56},{118,-56}}, color={0,0,127}));
  connect(TMix, freProTMix.TMix)
    annotation (Line(points={{-130,-20},{-90,-20},{-90,-60},{60,-60},{60,-10},{79,-10}},
      color={0,0,127}));
  connect(freProSta.y, enaDis.uFreProSta)
    annotation (Line(points={{-99,-150},{-40,-150},{-40,-28},{-1,-28}}, color={255,127,0}));
  connect(freProSta.y, damLim.uFreProSta)
    annotation (Line(points={{-99,-150},{-94,-150},{-94,2},{-81,2}}, color={255,127,0}));
  connect(uSupFan, mod.uSupFan)
    annotation (Line(points={{-130,-40},{-80,-40},{-80,-10},{20,-10},{20,0},{39,0}},
      color={255,0,255}));

annotation (defaultComponentName = "conEco",
        Icon(graphics={Rectangle(
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
          lineColor={0,0,127},
          textString="%name")}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-180},{160,160}}),
        graphics={Rectangle(
          extent={{70,100},{150,-100}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                                  Text(
          extent={{76,-86},{154,-96}},
          lineColor={95,95,95},
          textString="Freeze protection based on TMix,
not a part of G36",
          horizontalAlignment=TextAlignment.Left)}),
Documentation(info="<html>
<p>
Single zone VAV AHU economizer control sequence that calculates
outdoor and return air damper positions based on ASHRAE
Guidline 36, PART5 sections: P.4.d, P.5, P.9, P.3.b, A.17.
</p>
<p>
The sequence consists of three subsequences.
<ul>
<li>
First, the block <code>damLim</code> computes the damper position limits to satisfy
outdoor air requirements. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Limits\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Limits</a>
for a description.
</li>
<li>
Second, the block <code>enaDis</code> enables or disables the economizer based on
outdoor temperature and optionally enthalpy, and based on the supply fan status,
freeze protection stage and zone state.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Enable\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Enable</a>
for a description.
</li>
<li>
Third, the block <code>mod</code> modulates the outdoor and return damper position
to track the supply air temperature setpoint for heating, subject to the limits of the damper positions
that were computed in the above two blocks.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Modulation\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Modulation</a>
for a description.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
June 28, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
