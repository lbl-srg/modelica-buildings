within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Composite;
model EconomizerMultiZone "Multiple zone VAV AHU economizer control sequence"

  parameter Boolean use_enthalpy = true
    "Set to true if enthalpy measurement is used in addition to temperature measurement";
  parameter Real kPIDamLim=1 "Gain of damper limit controller";
  parameter Real kPIMod=1 "Gain of modulation controller";
  parameter Modelica.SIunits.Time TiPIDamLim=0.9 "Time constant of damper limit controller integrator block";
  parameter Modelica.SIunits.Time TiPIMod=300 "Time constant of modulation controller integrator block";

  CDL.Interfaces.RealInput TCooSet(unit="K", quantity = "ThermodynamicTemperature")
    "Supply air temperature cooling setpoint" annotation (Placement(transformation(
    extent={{-140,30},{-120,50}}), iconTransformation(extent={{-120,10},{-100,30}})));
  CDL.Interfaces.RealInput TSup(unit="K", quantity = "ThermodynamicTemperature")
    "Measured supply air temperature" annotation (Placement(transformation(
    extent={{-140,50},{-120,70}}), iconTransformation(extent={{-120,30},{-100,50}})));
  CDL.Interfaces.RealInput TOut(unit="K", quantity = "ThermodynamicTemperature")
    "Outdoor air (OA) temperature" annotation (Placement(transformation(extent={{-140,130},{-120,150}}),
    iconTransformation(extent={{-120,110},{-100,130}})));
  CDL.Interfaces.RealInput TOutCut(unit="K", quantity = "ThermodynamicTemperature")
    "OA temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}}),
        iconTransformation(extent={{-120,90},{-100,110}})));
  CDL.Interfaces.RealInput hOut(unit="J/kg", quantity="SpecificEnergy") if use_enthalpy
    "Outdoor air enthalpy" annotation (Placement(transformation(extent={{-140,90},{-120,110}}),
    iconTransformation(extent={{-120,70},{-100,90}})));
  CDL.Interfaces.RealInput hOutCut(unit="J/kg", quantity="SpecificEnergy") if use_enthalpy
    "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}}),
        iconTransformation(extent={{-120,50},{-100,70}})));
  CDL.Interfaces.RealInput VOut_flow(unit="m3/s")
    "Measured outdoor volumetirc airflow rate [fixme: which quantity attribute should we use? add for all V]"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  CDL.Interfaces.RealInput VOut_flowMinSet(unit="m3/s")
    "Minimum outdoor volumetric airflow rate setpoint"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}}),
        iconTransformation(extent={{-120,-30},{-100,-10}})));
  CDL.Interfaces.IntegerInput uFreProSta "Freeze protection status"
    annotation (Placement(transformation(extent={{-140,-130},{-120,-110}}),
      iconTransformation(extent={{-120,-110},{-100,-90}})));
  CDL.Interfaces.IntegerInput uOperationMode "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}}),
      iconTransformation(extent={{-120,-70},{-100,-50}})));
  CDL.Interfaces.IntegerInput uZoneState "Zone state input"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}}),
    iconTransformation(extent={{-120,-90},{-100,-70}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply fan status"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));

  CDL.Interfaces.RealOutput yRetDamPos "Return air damper position"
    annotation (Placement(transformation(extent={{120,30},{140,50}}),
    iconTransformation(extent={{100,10}, {120,30}})));
  CDL.Interfaces.RealOutput yOutDamPos "Outdoor air damper position"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}}),
    iconTransformation(extent={{100,-30}, {120,-10}})));

  Atomic.EconEnableDisableMultiZone econEnableDisableMultiZone(
    final delEntHis=delEntHis,
    final delTemHis=delTemHis,
    use_enthalpy=use_enthalpy)
    "Multizone VAV AHU economizer enable/disable sequence"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Atomic.EconDamperPositionLimitsMultiZone ecoDamLim(
    retDamPhyPosMax=0.9,
    retDamPhyPosMin=0,
    outDamPhyPosMax=0.9,
    outDamPhyPosMin=0,
    kPIDamLim=kPIDamLim,
    TiPIDamLim=TiPIDamLim)
    "Multizone VAV AHU economizer minimum outdoor air requirement damper limit sequence"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Atomic.EconModulationMultiZone ecoMod(kPIMod=kPIMod, TiPIMod=TiPIMod)
    "Multizone VAV AHU economizer damper modulation sequence"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

protected
  parameter Real delEntHis(unit="J/kg", quantity="SpecificEnergy")=1000
    "Delta between the enthalpy hysteresis high and low limits"
    annotation(Evaluate=true, Dialog(group="Enthalpy sensor in use", enable = use_enthalpy));
  parameter Modelica.SIunits.Temperature delTemHis=1
    "Delta between the temperature hysteresis high and low limits";

equation
  connect(uSupFan, econEnableDisableMultiZone.uSupFan)
    annotation (Line(points={{-130,-40},{-80,-40},{-80,-32},{-1,-32}},color={255,0,255}));
  connect(uZoneState, econEnableDisableMultiZone.uZoneState)
    annotation (Line(points={{-130,-100},{-70,-100},{-70,-30},{-1,-30}},color={255,127,0}));
  connect(uFreProSta, econEnableDisableMultiZone.uFreProSta)
    annotation (Line(points={{-130,-120},{-60,-120},{-60,-28},{-1,-28}},color={255,127,0}));
  connect(hOutCut, econEnableDisableMultiZone.hOutCut)
    annotation (Line(points={{-130,80},{-46,80},{-46,-26},{-1,-26}},color={0,0,127}));
  connect(hOut, econEnableDisableMultiZone.hOut)
    annotation (Line(points={{-130,100},{-44,100},{-44,-24},{-1,-24}},color={0,0,127}));
  connect(TOutCut, econEnableDisableMultiZone.TOutCut)
    annotation (Line(points={{-130,120},{-42,120},{-42,-22},{-1,-22}},color={0,0,127}));
  connect(TOut, econEnableDisableMultiZone.TOut)
    annotation (Line(points={{-130,140},{-40,140},{-40,-20},{-1,-20}},color={0,0,127}));
  connect(VOut_flowMinSet, ecoDamLim.VOut_flowMinSet)
    annotation (Line(points={{-130,0},{-110,0},{-110,14},{-110,15},{-81,15}},color={0,0,127}));
  connect(VOut_flow, ecoDamLim.VOut_flow)
    annotation (Line(points={{-130,20},{-110,20},{-110,18},{-81,18}},color={0,0,127}));
  connect(uSupFan, ecoDamLim.uSupFan)
    annotation (Line(points={{-130,-40},{-104,-40},{-104,10},{-81,10}},color={255,0,255}));
  connect(uOperationMode, ecoDamLim.uOperationMode)
    annotation (Line(points={{-130,-80},{-102,-80},{-102,4},{-102,5},{-81,5}}, color={255,127,0}));
  connect(uFreProSta, ecoDamLim.uFreProSta)
    annotation (Line(points={{-130,-120},{-100,-120},{-100,2},{-81,2}},color={255,127,0}));
  connect(ecoDamLim.yOutDamPosMax, econEnableDisableMultiZone.uOutDamPosMax)
    annotation (Line(points={{-59,17},{-24,17},{-24,16},{-24,-34},{-1,-34}},
    color={0,0,127}));
  connect(ecoDamLim.yOutDamPosMin, econEnableDisableMultiZone.uOutDamPosMin)
    annotation (Line(points={{-59,15},{-26,15},{-26,12},{-26,-36},{-1,-36}},
    color={0,0,127}));
  connect(ecoDamLim.yRetDamPosMin, econEnableDisableMultiZone.uRetDamPosMin)
    annotation (Line(points={{-59,10},{-28,10},{-28,8},{-28,-42},{-1,-42}},
                                                                         color={0,0,127}));
  connect(ecoDamLim.yRetDamPhyPosMax, econEnableDisableMultiZone.uRetDamPhyPosMax)
    annotation (Line(points={{-59,6},{-32,6},{-32,2},{-32,-38},{-1,-38}},color={0,0,127}));
  connect(ecoDamLim.yRetDamPosMax, econEnableDisableMultiZone.uRetDamPosMax)
    annotation (Line(points={{-59,8},{-30,8},{-30,-40},{-1,-40}},color={0,0,127}));
  connect(ecoMod.yRetDamPos, yRetDamPos)
    annotation (Line(points={{81,12},{100,12},{100,40},{130,40}},color={0,0,127}));
  connect(ecoMod.yOutDamPos, yOutDamPos)
    annotation (Line(points={{81,8},{100,8},{100,-40},{130,-40}},color={0,0,127}));
  connect(econEnableDisableMultiZone.yOutDamPosMax, ecoMod.uOutDamPosMax)
    annotation (Line(points={{22,-25.2},{50,-25.2},{50,-10},{50,11},{59,11}},
    color={0,0,127}));
  connect(econEnableDisableMultiZone.yRetDamPosMax, ecoMod.uRetDamPosMax)
    annotation (Line(points={{22,-32},{52,-32},{52,4},{59,4}},color={0,0,127}));
  connect(ecoDamLim.yOutDamPosMin, ecoMod.uOutDamPosMin)
    annotation (Line(points={{-59,15},{-20,15},{20,15},{20,12},{20,8},{59,8}},
      color={0,0,127}));
  connect(TCooSet, ecoMod.TCooSet) annotation (Line(points={{-130,40},{52,40},{52,19},{59,19}},
      color={0,0,127}));
  connect(TSup, ecoMod.TSup) annotation (Line(points={{-130,60},{50,60},{50,16},{59,16}},color={0,0,127}));
  connect(yOutDamPos, yOutDamPos) annotation (Line(points={{130,-40},{130,-40}}, color={0,0,127}));
  connect(yRetDamPos, yRetDamPos) annotation (Line(points={{130,40},{130,40}}, color={0,0,127}));
  connect(econEnableDisableMultiZone.yRetDamPosMin, ecoMod.uRetDamPosMin)
    annotation (Line(points={{22,-38},{54,-38},{54,0},{54,1},{59,1}}, color={0,0,127}));
  annotation (defaultComponentName = "multiZoneEconomizer",
        Icon(graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(points={{-66,-36},{-42,-36},{-4,40},{34,40}}, color={28,108,200},
          thickness=0.5),
        Line(
          points={{-64,40},{-38,40},{2,-40},{66,-40}},
          color={28,108,200},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Line(
          points={{34,40},{34,-36},{34,-36},{66,-36}},
          color={28,108,200},
          thickness=0.5)}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-140},{120,140}})),
  Documentation(info="<html>
  <p>
  This is multiple zone VAV AHU economizer control sequence. It calculates
  outdoor and return air damper positions based on ASHRAE
  Guidline 36, sections: PART5 N.2.c, N.5, N.6.c, N.7, A.17, N.12.
  The sequence comprises the following atomic sequences:
  <code>EconDamperPositionLimitsMultiZone</code>,
  <code>EconEnableDisableMultiZone</code>, and
  <code>EconModulationMultiZone</code>.
  </p>
  <p>
  The structure of the economizer control sequence: [fixme: how do I remove the grey area from the image?]
  </p>
  <p align=\"center\">
  <img alt=\"Image of the multizone AHU modulation sequence control diagram\"
  src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/Composite/EconCompositeSequenceMultiZone.png\"/>
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
