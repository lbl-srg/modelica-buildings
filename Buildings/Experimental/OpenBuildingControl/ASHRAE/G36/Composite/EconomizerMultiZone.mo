within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Composite;
model EconomizerMultiZone "Multiple zone VAV AHU economizer control sequence"

  parameter Boolean use_enthalpy = true
    "Set to true if enthalpy measurement is used in addition to temperature measurement";
    annotation(Dialog(group="Conditional parameters"));
  parameter Real kPDamLim=1 "Proportional gain of damper limit controller"
    annotation(Dialog(group="Controller parameters"));
  parameter Real kPMod=1 "Proportional gain of modulation controller"
    annotation(Dialog(group="Controller parameters"));
  parameter Modelica.SIunits.Time TiDamLim=300 "Time constant of damper limit controller integrator block"
    annotation(Dialog(group="Controller parameters"));
  parameter Modelica.SIunits.Time TiMod=300 "Time constant of modulation controller integrator block"
    annotation(Dialog(group="Controller parameters"));
  parameter Real retDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the return air damper"
    annotation(Dialog(group="Physical damper position limits"));
  parameter Real retDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the return air damper"
    annotation(Dialog(group="Physical damper position limits"));
  parameter Real outDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the outdoor air damper"
    annotation(Dialog(group="Physical damper position limits"));
  parameter Real outDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the outdoor air damper"
    annotation(Dialog(group="Physical damper position limits"));

  CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Supply air temperature heating setpoint"
    annotation (Placement(transformation(
    extent={{-140,30},{-120,50}}), iconTransformation(extent={{-120,10},{-100,30}})));
  CDL.Interfaces.RealInput TSup(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(
    extent={{-140,50},{-120,70}}), iconTransformation(extent={{-120,30},{-100,50}})));
  CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Outdoor air (OA) temperature"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}}),
    iconTransformation(extent={{-120,110},{-100,130}})));
  CDL.Interfaces.RealInput TOutCut(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "OA temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}}),
      iconTransformation(extent={{-120,90},{-100,110}})));
  CDL.Interfaces.RealInput hOut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}}),
    iconTransformation(extent={{-120,70},{-100,90}})));
  CDL.Interfaces.RealInput hOutCut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  CDL.Interfaces.RealInput VOut_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured outdoor volumetric airflow rate"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));
  CDL.Interfaces.RealInput VOutMinSet_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Minimum outdoor volumetric airflow rate setpoint"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}}),
      iconTransformation(extent={{-120,-30},{-100,-10}})));
  CDL.Interfaces.IntegerInput uFreProSta "Freeze protection status"
    annotation (Placement(transformation(extent={{-140,-130},{-120,-110}}),
      iconTransformation(extent={{-120,-110},{-100,-90}})));
  CDL.Interfaces.IntegerInput uOpeMod "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}}),
      iconTransformation(extent={{-120,-70},{-100,-50}})));
  CDL.Interfaces.IntegerInput uZonSta "Zone state signal"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}}),
      iconTransformation(extent={{-120,-90},{-100,-70}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply fan status"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}}),
      iconTransformation(extent={{-120,-50},{-100,-30}})));

  CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1") "Return air damper position"
    annotation (Placement(transformation(extent={{120,30},{140,50}}),
    iconTransformation(extent={{100,10}, {120,30}})));
  CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1") "Outdoor air damper position"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}}),
    iconTransformation(extent={{100,-30}, {120,-10}})));

  Atomic.EconEnableDisableMultiZone ecoEnaDis(final use_enthalpy=true)
                                     "Multizone VAV AHU economizer enable/disable sequence"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Atomic.EconDamperPositionLimitsMultiZone ecoDamLim(
    final retDamPhyPosMax=retDamPhyPosMax,
    final retDamPhyPosMin=retDamPhyPosMin,
    final outDamPhyPosMax=outDamPhyPosMax,
    final outDamPhyPosMin=outDamPhyPosMin,
    final kPDamLim=kPDamLim,
    final TiDamLim=TiDamLim)
    "Multizone VAV AHU economizer minimum outdoor air requirement damper limit sequence"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Atomic.EconModulationMultiZone ecoMod(
    final kPMod=kPMod,
    final TiMod=TiMod)
    "Multizone VAV AHU economizer damper modulation sequence"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

equation
  connect(uSupFan, ecoEnaDis.uSupFan)
    annotation (Line(points={{-130,-40},{-80,-40},{-80,-32},{-1,-32}}, color={255,0,255}));
  connect(uFreProSta, ecoEnaDis.uFreProSta)
    annotation (Line(points={{-130,-120},{-60,-120},{-60,-28},{-1,-28}}, color={255,127,0}));
  connect(hOutCut, ecoEnaDis.hOutCut)
    annotation (Line(points={{-130,80},{-46,80},{-46,-26},{-1,-26}}, color={0,0,127}));
  connect(hOut, ecoEnaDis.hOut) annotation (Line(points={{-130,100},{-44,100},{-44,-24},{-1,-24}}, color={0,0,127}));
  connect(TOutCut, ecoEnaDis.TOutCut)
    annotation (Line(points={{-130,120},{-42,120},{-42,-22},{-1,-22}}, color={0,0,127}));
  connect(TOut, ecoEnaDis.TOut) annotation (Line(points={{-130,140},{-40,140},{-40,-20},{-1,-20}}, color={0,0,127}));
  connect(VOutMinSet_flow, ecoDamLim.VOutMinSet_flow)
    annotation (Line(points={{-130,0},{-110,0},{-110,14},{-110,15},{-81,15}},color={0,0,127}));
  connect(VOut_flow, ecoDamLim.VOut_flow)
    annotation (Line(points={{-130,20},{-110,20},{-110,18},{-81,18}},color={0,0,127}));
  connect(uSupFan, ecoDamLim.uSupFan)
    annotation (Line(points={{-130,-40},{-104,-40},{-104,10},{-81,10}},color={255,0,255}));
  connect(uOpeMod, ecoDamLim.uOpeMod)
    annotation (Line(points={{-130,-80},{-102,-80},{-102,4},{-102,5},{-81,5}}, color={255,127,0}));
  connect(uFreProSta, ecoDamLim.uFreProSta)
    annotation (Line(points={{-130,-120},{-100,-120},{-100,2},{-81,2}},color={255,127,0}));
  connect(ecoDamLim.yOutDamPosMax, ecoEnaDis.uOutDamPosMax)
    annotation (Line(points={{-59,17},{-24,17},{-24,16},{-24,-34},{-1,-34}}, color={0,0,127}));
  connect(ecoDamLim.yOutDamPosMin, ecoEnaDis.uOutDamPosMin)
    annotation (Line(points={{-59,15},{-26,15},{-26,12},{-26,-36},{-1,-36}}, color={0,0,127}));
  connect(ecoDamLim.yRetDamPosMin, ecoEnaDis.uRetDamPosMin)
    annotation (Line(points={{-59,10},{-28,10},{-28,8},{-28,-42},{-1,-42}}, color={0,0,127}));
  connect(ecoDamLim.yRetDamPhyPosMax, ecoEnaDis.uRetDamPhyPosMax)
    annotation (Line(points={{-59,6},{-32,6},{-32,2},{-32,-38},{-1,-38}}, color={0,0,127}));
  connect(ecoDamLim.yRetDamPosMax, ecoEnaDis.uRetDamPosMax)
    annotation (Line(points={{-59,8},{-30,8},{-30,-40},{-1,-40}}, color={0,0,127}));
  connect(ecoMod.yRetDamPos, yRetDamPos)
    annotation (Line(points={{81,12},{100,12},{100,40},{130,40}},color={0,0,127}));
  connect(ecoMod.yOutDamPos, yOutDamPos)
    annotation (Line(points={{81,8},{100,8},{100,-40},{130,-40}},color={0,0,127}));
  connect(ecoEnaDis.yOutDamPosMax, ecoMod.uOutDamPosMax)
    annotation (Line(points={{22,-25.2},{50,-25.2},{50,-10},{50,11},{59,11}}, color={0,0,127}));
  connect(ecoEnaDis.yRetDamPosMax, ecoMod.uRetDamPosMax)
    annotation (Line(points={{22,-32},{52,-32},{52,4},{59,4}}, color={0,0,127}));
  connect(ecoDamLim.yOutDamPosMin, ecoMod.uOutDamPosMin)
    annotation (Line(points={{-59,15},{-20,15},{20,15},{20,12},{20,8},{59,8}},
      color={0,0,127}));
  connect(TSup, ecoMod.TSup) annotation (Line(points={{-130,60},{50,60},{50,16},{59,16}},color={0,0,127}));
  connect(yOutDamPos, yOutDamPos) annotation (Line(points={{130,-40},{130,-40}}, color={0,0,127}));
  connect(yRetDamPos, yRetDamPos) annotation (Line(points={{130,40},{130,40}}, color={0,0,127}));
  connect(ecoEnaDis.yRetDamPosMin, ecoMod.uRetDamPosMin)
    annotation (Line(points={{22,-38},{54,-38},{54,0},{54,1},{59,1}}, color={0,0,127}));
  connect(uZonSta, ecoEnaDis.uZonSta)
    annotation (Line(points={{-130,-100},{-58,-100},{-58,-30},{-1,-30}}, color={255,127,0}));
  connect(THeaSet, ecoMod.THeaSet) annotation (Line(points={{-130,40},{40,40},{40,19},{59,19}}, color={0,0,127}));
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
          extent={{-170,150},{158,112}},
          lineColor={0,0,127},
          textString="%name")}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-140},{120,140}})),
Documentation(info="<html>
<p>
Multiple zone VAV AHU economizer control sequence that calculates
outdoor and return air damper positions based on ASHRAE
Guidline 36, PART5 sections: N.2.c, N.5, N.6.c, N.7, A.17, N.12.
</p>
<p>
The sequence comprises the following atomic sequences:
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconDamperPositionLimitsMultiZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconDamperPositionLimitsMultiZone</a>,
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconEnableDisableMultiZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconEnableDisableMultiZone</a>,
and <a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconModulationMultiZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconModulationMultiZone</a>.
</p>
<p>
The figure below shows the block diagram of the control sequence.
</p>
<p align=\"center\">
<img alt=\"Image of the multizone AHU modulation sequence control diagram\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/Composite/EconCompositeMultiZone.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
June 28, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconomizerMultiZone;
