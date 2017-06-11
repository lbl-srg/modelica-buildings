within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.CompositeSequences;
model EconomizerMultiZone "Economizer control block"

  parameter Boolean fixEnt = true
    "Set to true if there is an enthalpy sensor and the economizer uses fixed enthalpy + fixed dry bulb temperature sensors";
  AtomicSequences.EconDamperPositionLimitsMultiZone ecoEnaDis
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
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
  CDL.Interfaces.RealInput hOut(unit="J/kg", displayUnit="kJ/kg", quantity="SpecificEnthalpy") if fixEnt
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
  AtomicSequences.EconModulationMultiZone ecoMod
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  AtomicSequences.EconEnableDisableMultiZone econEnableDisableMultiZone(fixEnt=true)
    annotation (Placement(transformation(extent={{-18,-20},{2,0}})));
equation
  connect(uSupFan, ecoEnaDis.uSupFan) annotation (Line(points={{-150,-10},{-100,
          -10},{-100,30},{-81,30}},
                              color={255,0,255}));
  connect(uVOut, ecoEnaDis.uVOut) annotation (Line(points={{-150,30},{-150,30},{
          -120,30},{-120,38},{-81,38}},
                         color={0,0,127}));
  connect(uVOutMinSet, ecoEnaDis.uVOutMinSet) annotation (Line(points={{-150,40},
          {-98,40},{-98,35},{-81,35}}, color={0,0,127}));
  connect(uAHUMode, ecoEnaDis.uAHUMode) annotation (Line(points={{-150,-60},{-116,
          -60},{-116,25},{-81,25}}, color={255,127,0}));
  connect(uFreProSta, ecoEnaDis.uFreProSta) annotation (Line(points={{-150,-100},
          {-150,-100},{-90,-100},{-90,-40},{-90,22},{-81,22}},
                                                             color={255,127,0}));
  connect(TCooSet, ecoMod.TCooSet) annotation (Line(points={{-150,70},{22,70},{22,
          36},{22,19},{30,19},{39,19}}, color={0,0,127}));
  connect(TSup, ecoMod.TSup) annotation (Line(points={{-150,60},{0,60},{0,16},{39,
          16}}, color={0,0,127}));
  connect(ecoEnaDis.yOutDamPosMin, ecoMod.uOutDamPosMin) annotation (Line(
        points={{-59,33},{-10.5,33},{-10.5,8},{39,8}}, color={0,0,127}));
  connect(ecoMod.yRetDamPos, yRetDamPos) annotation (Line(points={{61,12},{112,12},
          {112,40},{170,40}}, color={0,0,127}));
  connect(ecoMod.yOutDamPos, yOutDamPos) annotation (Line(points={{61,8},{113.5,
          8},{113.5,-20},{170,-20}}, color={0,0,127}));
  connect(ecoEnaDis.yRetDamPhyPosMax, econEnableDisableMultiZone.uRetDamPhyPosMax)
    annotation (Line(points={{-59,24.6},{-48.5,24.6},{-48.5,-18},{-19,-18}},
        color={0,0,127}));
  connect(ecoEnaDis.yRetDamPosMax, econEnableDisableMultiZone.uRetDamPosMax)
    annotation (Line(points={{-59,26.8},{-48.5,26.8},{-48.5,-20},{-19,-20}},
        color={0,0,127}));
  connect(ecoEnaDis.yRetDamPosMin, econEnableDisableMultiZone.uRetDamPosMin)
    annotation (Line(points={{-59,29},{-48.5,29},{-48.5,-22},{-19,-22}}, color={
          0,0,127}));
  connect(ecoEnaDis.yOutDamPosMin, econEnableDisableMultiZone.uOutDamPosMin)
    annotation (Line(points={{-59,33},{-48.5,33},{-48.5,-16},{-19,-16}}, color={
          0,0,127}));
  connect(ecoEnaDis.yOutDamPosMax, econEnableDisableMultiZone.uOutDamPosMax)
    annotation (Line(points={{-59,37},{-54,37},{-54,38},{-50,38},{-50,-14},{-19,
          -14}}, color={0,0,127}));
  connect(uSupFan, econEnableDisableMultiZone.uSupFan) annotation (Line(points={
          {-150,-10},{-94,-10},{-94,-12},{-19,-12}}, color={255,0,255}));
  connect(uZoneState, econEnableDisableMultiZone.uZoneState) annotation (Line(
        points={{-150,-80},{-84,-80},{-84,-10},{-19,-10}}, color={255,127,0}));
  connect(uFreProSta, econEnableDisableMultiZone.uFreProSta) annotation (Line(
        points={{-150,-100},{-82,-100},{-82,-8},{-19,-8}},
                                                         color={255,127,0}));
  connect(hOutCut, econEnableDisableMultiZone.hOutCut) annotation (Line(points={
          {-150,90},{-84,90},{-84,-6},{-19,-6}}, color={0,0,127}));
  connect(hOut, econEnableDisableMultiZone.hOut) annotation (Line(points={{-150,
          100},{-84,100},{-84,-4},{-19,-4}}, color={0,0,127}));
  connect(TOutCut, econEnableDisableMultiZone.TOutCut) annotation (Line(points={
          {-150,120},{-84,120},{-84,-2},{-19,-2}}, color={0,0,127}));
  connect(TOut, econEnableDisableMultiZone.TOut) annotation (Line(points={{-150,
          130},{-84,130},{-84,0},{-19,0}}, color={0,0,127}));
  connect(econEnableDisableMultiZone.yOutDamPosMax, ecoMod.uOutDamPosMax)
    annotation (Line(points={{4,-4},{22,-4},{22,11},{39,11}}, color={0,0,127}));
  connect(econEnableDisableMultiZone.yRetDamPosMax, ecoMod.uRetDamPosMax)
    annotation (Line(points={{4,-12},{22,-12},{22,4},{39,4}}, color={0,0,127}));
  connect(econEnableDisableMultiZone.yRetDamPosMin, ecoMod.uRetDamPosMin)
    annotation (Line(points={{4,-18},{22,-18},{22,1},{39,1}}, color={0,0,127}));
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
