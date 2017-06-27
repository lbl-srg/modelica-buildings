within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.CompositeSequences;
model EconomizerMultiZone "Economizer control block"

  parameter Boolean fixEnt = true
    "Set to true if there is an enthalpy sensor and the economizer uses fixed enthalpy + fixed dry bulb temperature sensors";
  CDL.Interfaces.RealInput TCooSet
    "Output of a ***TSupSet sequence. The economizer modulates to the TCoo rather 
    than to the THea. If Zone State is Cooling, economizer modulates to a temperature 
    slightly lower than the TCoo [PART5.P.1]."
    annotation (Placement(transformation(extent={{-160,60},{-140,80}}),
        iconTransformation(extent={{-120,10},{-100,30}})));
  CDL.Interfaces.RealInput TSup
    "Measured supply air temperature. Sensor output."
    annotation (Placement(transformation(extent={{-160,50},{-140,70}}),
        iconTransformation(extent={{-120,30},{-100,50}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply Fan Status, on or off"
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));
  CDL.Interfaces.RealInput TOut "Outdoor temperature"
    annotation (Placement(transformation(extent={{-160,120},{-140,140}}),
    iconTransformation(extent={{-120,110},{-100,130}})));
  CDL.Interfaces.RealOutput yRetDamPos "Return air damper position"
    annotation (Placement(transformation(extent={{160,30},{180,50}}),
    iconTransformation(extent={{100,10}, {120,30}})));
  CDL.Interfaces.RealOutput yOutDamPos "Economizer damper position"
    annotation (Placement(transformation(extent={{160,-30},{180,-10}}),
    iconTransformation(extent={{100,-30}, {120,-10}})));
  CDL.Interfaces.RealInput uVOut
    "Measured outdoor airflow rate. Sensor output. Location: after the economizer damper intake."
    annotation (Placement(transformation(extent={{-160,20},{-140,40}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  CDL.Interfaces.RealInput uVOutMinSet
    "Minimum outdoor airflow requirement, output of a separate sequence that calculates this value based on ASHRAE Standard 62.1-2013 or California Title 24"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}}),
        iconTransformation(extent={{-120,-30},{-100,-10}})));
  CDL.Interfaces.IntegerInput uFreProSta "Freeze Protection Status" annotation (Placement(
        transformation(extent={{-160,-110},{-140,-90}}),  iconTransformation(extent={{-120,
            -110},{-100,-90}})));
  CDL.Interfaces.IntegerInput uAHUMode
    "AHU System Mode [fixme: Integer, see documentation for mapping]" annotation (Placement(
        transformation(extent={{-160,-70},{-140,-50}}),   iconTransformation(extent={{-120,
            -70},{-100,-50}})));
  CDL.Interfaces.RealInput TOutCut(unit="K", displayUnit="degC")
    "Outdoor temperature high limit cutoff [fixme: see #777]" annotation (
      Placement(transformation(extent={{-160,110},{-140,130}}),
        iconTransformation(extent={{-120,90},{-100,110}})));
  CDL.Interfaces.RealInput hOut(unit="J/kg", quantity="SpecificEnergy") if fixEnt
    "Outdoor air enthalpy"
    annotation (Evaluate=true, Dialog(group="Enthalpy sensor in use", enable = fixEnt),
    Placement(transformation(extent={{-160,90},{-140,110}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
  CDL.Interfaces.IntegerInput uZoneState
    "Zone state input (0=Heating, 1=Deadband, 2=Cooling)"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}}), iconTransformation(extent={{-120,
            -90},{-100,-70}})));
  CDL.Interfaces.RealInput hOutCut(unit="J/kg", displayUnit="kJ/kg") if fixEnt
    "Outdoor enthalpy high limit cutoff [fixme: see #777]"
    annotation (Evaluate=true, Dialog(group="Enthalpy sensor in use", enable = fixEnt),
    Placement(transformation(extent={{-160,80},{-140,100}}),
        iconTransformation(extent={{-120,50},{-100,70}})));
  AtomicSequences.EconEnableDisableMultiZone econEnableDisableMultiZone(fixEnt=true)
    "Block that determines whether the economizer is enabled or disabled"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  AtomicSequences.EconDamperPositionLimitsMultiZone ecoDamLim
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  AtomicSequences.EconModulationMultiZone ecoMod
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
equation
  connect(uSupFan, econEnableDisableMultiZone.uSupFan) annotation (Line(points={{-150,
          -10},{-94,-10},{-94,-12},{-21,-12}},       color={255,0,255}));
  connect(uZoneState, econEnableDisableMultiZone.uZoneState) annotation (Line(
        points={{-150,-80},{-84,-80},{-84,-10},{-21,-10}}, color={255,127,0}));
  connect(uFreProSta, econEnableDisableMultiZone.uFreProSta) annotation (Line(
        points={{-150,-100},{-82,-100},{-82,-8},{-21,-8}},
                                                         color={255,127,0}));
  connect(hOutCut, econEnableDisableMultiZone.hOutCut) annotation (Line(points={{-150,90},
          {-60,90},{-60,-6},{-21,-6}},           color={0,0,127}));
  connect(hOut, econEnableDisableMultiZone.hOut) annotation (Line(points={{-150,
          100},{-60,100},{-60,-4},{-21,-4}}, color={0,0,127}));
  connect(TOutCut, econEnableDisableMultiZone.TOutCut) annotation (Line(points={{-150,
          120},{-60,120},{-60,-2},{-21,-2}},       color={0,0,127}));
  connect(TOut, econEnableDisableMultiZone.TOut) annotation (Line(points={{-150,
          130},{-60,130},{-60,0},{-21,0}}, color={0,0,127}));
  connect(uVOutMinSet, ecoDamLim.uVOutMinSet) annotation (Line(points={{-150,40},{-120,40},{-120,36},{-120,35},{-101,35}},
                                          color={0,0,127}));
  connect(uVOut, ecoDamLim.uVOut) annotation (Line(points={{-150,30},{-130,30},{-130,38},{-101,38}},
                                color={0,0,127}));
  connect(uSupFan, ecoDamLim.uSupFan) annotation (Line(points={{-150,-10},{-124,
          -10},{-124,30},{-101,30}}, color={255,0,255}));
  connect(uAHUMode, ecoDamLim.uAHUMode) annotation (Line(points={{-150,-60},{-122,-60},{-122,24},{-122,24},{-122,25},{
          -101,25}},                                          color={255,127,0}));
  connect(uFreProSta, ecoDamLim.uFreProSta) annotation (Line(points={{-150,-100},
          {-120,-100},{-120,22},{-101,22}}, color={255,127,0}));
  connect(ecoDamLim.yOutDamPosMax, econEnableDisableMultiZone.uOutDamPosMax)
    annotation (Line(points={{-79,37},{-44,37},{-44,36},{-44,-14},{-21,-14}},
                                                                         color=
          {0,0,127}));
  connect(ecoDamLim.yOutDamPosMin, econEnableDisableMultiZone.uOutDamPosMin)
    annotation (Line(points={{-79,33},{-46,33},{-46,32},{-46,-16},{-21,-16}},
                                                                         color=
          {0,0,127}));
  connect(ecoDamLim.yRetDamPosMin, econEnableDisableMultiZone.uRetDamPosMin)
    annotation (Line(points={{-79,29},{-48,29},{-48,28},{-48,-22},{-21,-22}},
                                                                         color=
          {0,0,127}));
  connect(ecoDamLim.yRetDamPhyPosMax, econEnableDisableMultiZone.uRetDamPhyPosMax)
    annotation (Line(points={{-79,23},{-52,23},{-52,22},{-52,-18},{-21,-18}},
                      color={0,0,127}));
  connect(ecoDamLim.yRetDamPosMax, econEnableDisableMultiZone.uRetDamPosMax)
    annotation (Line(points={{-79,26},{-50,26},{-50,-20},{-21,-20}},
                      color={0,0,127}));
  connect(ecoMod.yRetDamPos, yRetDamPos) annotation (Line(points={{81,12},{120,
          12},{120,40},{170,40}}, color={0,0,127}));
  connect(ecoMod.yOutDamPos, yOutDamPos) annotation (Line(points={{81,8},{120,8},
          {120,-20},{170,-20}}, color={0,0,127}));
  connect(econEnableDisableMultiZone.yOutDamPosMax, ecoMod.uOutDamPosMax)
    annotation (Line(points={{2,-5.2},{30,-5.2},{30,10},{30,11},{59,11}},
                                                                  color={0,0,
          127}));
  connect(econEnableDisableMultiZone.yRetDamPosMax, ecoMod.uRetDamPosMax)
    annotation (Line(points={{2,-12},{30,-12},{30,4},{59,4}}, color={0,0,127}));
  connect(econEnableDisableMultiZone.yRetDamPosMin, ecoMod.uRetDamPosMin)
    annotation (Line(points={{2,-18},{30,-18},{30,0},{30,1},{59,1}},
                                                              color={0,0,127}));
  connect(ecoDamLim.yOutDamPosMin, ecoMod.uOutDamPosMin) annotation (Line(
        points={{-79,33},{-30,33},{-30,20},{20,20},{20,8},{59,8}}, color={0,0,
          127}));
  connect(TCooSet, ecoMod.TCooSet) annotation (Line(points={{-150,70},{40,70},{
          40,19},{59,19}}, color={0,0,127}));
  connect(TSup, ecoMod.TSup) annotation (Line(points={{-150,60},{30,60},{30,16},
          {59,16}}, color={0,0,127}));
  annotation (Icon(graphics={Rectangle(
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
                          Diagram(coordinateSystem(preserveAspectRatio=false, extent={
            {-140,-140},{160,140}})));
end EconomizerMultiZone;
