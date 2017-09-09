within Buildings.Controls.OBC.ASHRAE.G36.AHU.Economizer;
model EconomizerSingleZone "Single zone VAV AHU economizer control sequence"

  parameter Boolean use_enthalpy = true
    "Set to true if enthalpy measurement is used in addition to temperature measurement";
  parameter Modelica.SIunits.TemperatureDifference delTOutHis=1
    "Delta between the temperature hysteresis high and low limit"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Hysteresis"));
  parameter Modelica.SIunits.SpecificEnergy delEntHis=1000
    "Delta between the enthalpy hysteresis high and low limits"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Hysteresis", enable = use_enthalpy));
  parameter Real kPMod=1 "Gain of modulation controller"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Controller"));
  parameter Modelica.SIunits.Time TiMod=300 "Time constant of modulation controller integrator block"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Controller"));
  parameter Real minFanSpe(
    final min=0,
    final max=1,
    final unit="1") = 0.1 "Minimum supply fan operation speed"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real maxFanSpe(
    final min=0,
    final max=1,
    final unit="1") = 0.9 "Maximum supply fan operation speed"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Modelica.SIunits.VolumeFlowRate minVOut_flow=1.0 "Calculated minimum outdoor airflow rate"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Modelica.SIunits.VolumeFlowRate desVOut_flow=2.0 "Calculated design outdoor airflow rate"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real minVOutMinFansSpePos(
    final min=minVOutMaxFanSpePos,
    final max=desVOutMinFanSpePos,
    final unit="1") = 0.4
    "OA damper position to supply minimum outdoor airflow at minimum fan speed"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real minVOutMaxFanSpePos(
    final min=outDamPhyPosMin,
    final max=minVOutMinFansSpePos,
    final unit="1") = 0.3
    "OA damper position to supply minimum outdoor airflow at maximum fan speed"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real desVOutMinFanSpePos(
    final min=desVOutMaxFanSpePos,
    final max=outDamPhyPosMax,
    final unit="1") = 0.9
    "OA damper position to supply design outdoor airflow at minimum fan speed"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Damper position limits"));
  parameter Real desVOutMaxFanSpePos(
    final min=minVOutMaxFanSpePos,
    final max=desVOutMinFanSpePos,
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

  CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Supply air temperature Healing setpoint" annotation (Placement(transformation(
    extent={{-140,30},{-120,50}}), iconTransformation(extent={{-120,10},{-100,30}})));
  CDL.Interfaces.RealInput TSup(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Measured supply air temperature" annotation (Placement(transformation(
    extent={{-140,50},{-120,70}}), iconTransformation(extent={{-120,30},{-100,50}})));
  CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Outdoor air (OA) temperature" annotation (Placement(transformation(extent={{-140,130},{-120,150}}),
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
    "Outdoor air enthalpy" annotation (Placement(transformation(extent={{-140,90},{-120,110}}),
    iconTransformation(extent={{-120,70},{-100,90}})));
  CDL.Interfaces.RealInput hOutCut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  CDL.Interfaces.RealInput uVOutMinSet_flow(
    final min=minVOut_flow,
    final max=desVOut_flow,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));
  CDL.Interfaces.RealInput uSupFanSpe(
    final min=minFanSpe,
    final max=maxFanSpe,
    final unit="1")
    "Supply fan speed"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}}),
      iconTransformation(extent={{-120,-30},{-100,-10}})));
  CDL.Interfaces.IntegerInput uZonSta "Zone state signal"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}}),
        iconTransformation(extent={{-120,-90},{-100,-70}})));
  CDL.Interfaces.IntegerInput uFreProSta "Freeze protection status"
    annotation (Placement(transformation(extent={{-140,-130},{-120,-110}}),
      iconTransformation(extent={{-120,-110},{-100,-90}})));
  CDL.Interfaces.IntegerInput uOpeMod "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}}),
      iconTransformation(extent={{-120,-70},{-100,-50}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply fan status"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));

  CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Return air damper position"
    annotation (Placement(transformation(extent={{120,30},{140,50}}),
    iconTransformation(extent={{100,10}, {120,30}})));
  CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}}),
    iconTransformation(extent={{100,-30}, {120,-10}})));

  Controls.OBC.ASHRAE.G36.Atomic.EconEnableDisableSingleZone ecoEnaDis(
    final retDamPhyPosMax=retDamPhyPosMax,
    final use_enthalpy=use_enthalpy,
    final delTOutHis=delTOutHis,
    final delEntHis=delEntHis,
    final retDamPhyPosMin=retDamPhyPosMin)
    "Single zone VAV AHU economizer enable/disable sequence"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Controls.OBC.ASHRAE.G36.Atomic.EconDamperPositionLimitsSingleZone ecoDamLim(
    final minFanSpe=minFanSpe,
    final maxFanSpe=maxFanSpe,
    final outDamPhyPosMax=outDamPhyPosMax,
    final outDamPhyPosMin=outDamPhyPosMin,
    final minVOut_flow=minVOut_flow,
    final desVOut_flow=desVOut_flow,
    final minVOutMinFansSpePos=minVOutMinFansSpePos,
    final minVOutMaxFanSpePos=minVOutMaxFanSpePos,
    final desVOutMinFanSpePos=desVOutMinFanSpePos,
    final desVOutMaxFanSpePos=desVOutMaxFanSpePos)
    "Single zone VAV AHU economizer minimum outdoor air requirement damper limit sequence"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Controls.OBC.ASHRAE.G36.Atomic.EconModulationSingleZone ecoMod(
    final kPMod=kPMod,
    final TiMod=TiMod)
    "Single zone VAV AHU economizer damper modulation sequence"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

equation
  connect(uSupFan, ecoEnaDis.uSupFan)
    annotation (Line(points={{-130,-40},{-80,-40},{-80,-32},{-1,-32}}, color={255,0,255}));
  connect(uFreProSta, ecoEnaDis.uFreProSta)
    annotation (Line(points={{-130,-120},{-60,-120},{-60,-28},{-1,-28}}, color={255,127,0}));
  connect(hOutCut, ecoEnaDis.hOutCut)
    annotation (Line(points={{-130,80},{-46,80},{-46,-26},{-1,-26}}, color={0,0,127}));
  connect(hOut, ecoEnaDis.hOut)
    annotation (Line(points={{-130,100},{-44,100},{-44,-24},{-1,-24}}, color={0,0,127}));
  connect(TOutCut, ecoEnaDis.TOutCut)
    annotation (Line(points={{-130,120},{-42,120},{-42,-22},{-1,-22}}, color={0,0,127}));
  connect(TOut, ecoEnaDis.TOut)
    annotation (Line(points={{-130,140},{-40,140},{-40,-20},{-1,-20}}, color={0,0,127}));
  connect(uSupFan, ecoDamLim.uSupFan)
    annotation (Line(points={{-130,-40},{-104,-40},{-104,8},{-81,8}},  color={255,0,255}));
  connect(uOpeMod, ecoDamLim.uOpeMod)
    annotation (Line(points={{-130,-80},{-102,-80},{-102,4},{-102,5},{-81,5}}, color={255,127,0}));
  connect(uFreProSta, ecoDamLim.uFreProSta)
    annotation (Line(points={{-130,-120},{-100,-120},{-100,2},{-81,2}},color={255,127,0}));
  connect(ecoDamLim.yOutDamPosMax, ecoEnaDis.uOutDamPosMax)
    annotation (Line(points={{-59,6},{-24,6},{-24,-34},{-1,-34}},            color={0,0,127}));
  connect(ecoDamLim.yOutDamPosMin, ecoEnaDis.uOutDamPosMin)
    annotation (Line(points={{-59,14},{-26,14},{-26,12},{-26,-36},{-1,-36}}, color={0,0,127}));
  connect(ecoMod.yRetDamPos, yRetDamPos)
    annotation (Line(points={{81,12},{100,12},{100,40},{130,40}},color={0,0,127}));
  connect(ecoMod.yOutDamPos, yOutDamPos)
    annotation (Line(points={{81,8},{100,8},{100,-40},{130,-40}},color={0,0,127}));
  connect(ecoEnaDis.yOutDamPosMax, ecoMod.uOutDamPosMax)
    annotation (Line(points={{22,-25.2},{50,-25.2},{50,-10},{50,11},{59,11}}, color={0,0,127}));
  connect(ecoEnaDis.yRetDamPosMax, ecoMod.uRetDamPosMax)
    annotation (Line(points={{22,-32},{52,-32},{52,4},{59,4}}, color={0,0,127}));
  connect(ecoDamLim.yOutDamPosMin, ecoMod.uOutDamPosMin)
    annotation (Line(points={{-59,14},{-20,14},{20,14},{20,12},{20,8},{59,8}},
      color={0,0,127}));
  connect(THeaSet, ecoMod.THeaSet) annotation (Line(points={{-130,40},{52,40},{52,19},{59,19}},
      color={0,0,127}));
  connect(TSup, ecoMod.TSup) annotation (Line(points={{-130,60},{50,60},{50,16},{59,16}},color={0,0,127}));
  connect(ecoEnaDis.yRetDamPosMin, ecoMod.uRetDamPosMin)
    annotation (Line(points={{22,-38},{54,-38},{54,0},{54,1},{59,1}}, color={0,0,127}));
  connect(uZonSta, ecoEnaDis.uZonSta)
    annotation (Line(points={{-130,-100},{-58,-100},{-58,-30},{-1,-30}}, color={255,127,0}));
  connect(uSupFanSpe, ecoDamLim.uSupFanSpe)
    annotation (Line(points={{-130,0},{-106,0},{-106,13.8},{-81,13.8}}, color={0,0,127}));
  connect(uVOutMinSet_flow, ecoDamLim.uVOutMinSet_flow)
    annotation (Line(points={{-130,20},{-106,20},{-106,17},{-81,17}}, color={0,0,127}));
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
Single zone VAV AHU economizer control sequence that calculates
outdoor and return air damper positions based on ASHRAE
Guidline 36, PART5 sections: P.4.d, P.5, P.9, P.3.b, A.17.
</p>
<p>
The sequence comprises the following atomic sequences:
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHU.Economizer.Subsequences.EconDamperPositionLimitsSingleZone\">
Buildings.Controls.OBC.ASHRAE.G36.AHU.Economizer.Subsequences.EconDamperPositionLimitsSingleZone</a>,
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHU.Economizer.Subsequences.EconEnableDisableSingleZone\">
Buildings.Controls.OBC.ASHRAE.G36.AHU.Economizer.Subsequences.EconEnableDisableSingleZone</a>,
and <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHU.Economizer.Subsequences.EconModulationSingleZone\">
Buildings.Controls.OBC.ASHRAE.G36.AHU.Economizer.Subsequences.EconModulationSingleZone</a>.
</p>
<p>
The figure below shows the block diagram of the control sequence.
</p>
<p align=\"center\">
<img alt=\"Image of the multizone AHU modulation sequence control diagram\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/TerminalUnit/EconCompositeSingleZone.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
June 28, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconomizerSingleZone;
