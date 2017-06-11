within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.CompositeSequences;
model EconomizerMultiZone "Economizer control block"

  AtomicSequences.EconEnableDisableMultiZone econEnableDisable
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  AtomicSequences.EconDamperPositionLimitsMultiZone
                                           ecoEnaDis
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  CDL.Interfaces.RealInput TCooSet
    "Output of a ***TSupSet sequence. The economizer modulates to the TCoo rather 
    than to the THea. If Zone State is Cooling, economizer modulates to a temperature 
    slightly lower than the TCoo [PART5.P.1]."
    annotation (Placement(transformation(extent={{-160,60},{-140,80}}),
        iconTransformation(extent={{-120,60},{-100,80}})));
  CDL.Interfaces.RealInput TSup
    "Measured supply air temperature. Sensor output."
    annotation (Placement(transformation(extent={{-160,50},{-140,70}}),
        iconTransformation(extent={{-120,40},{-100,60}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply Fan Status, on or off"
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}}),
        iconTransformation(extent={{-120,-80},{-100,-60}})));
  CDL.Interfaces.RealInput TOut "Outdoor temperature"
    annotation (Placement(transformation(extent={{-160,120},{-140,140}}),
    iconTransformation(extent={{-120,80},{-100,100}})));
  CDL.Interfaces.RealOutput yRetDamPos "Return air damper position"
    annotation (Placement(transformation(extent={{160,30},{180,50}}),
    iconTransformation(extent={{100,10}, {120,30}})));
  CDL.Interfaces.RealOutput yOutDamPos "Economizer damper position"
    annotation (Placement(transformation(extent={{160,-30},{180,-10}}),
    iconTransformation(extent={{100,-30}, {120,-10}})));
  CDL.Interfaces.RealInput uVOut
    "Measured outdoor airflow rate. Sensor output. Location: after the economizer damper intake."
    annotation (Placement(transformation(extent={{-160,20},{-140,40}}),
        iconTransformation(extent={{-120,0},{-100,20}})));
  CDL.Interfaces.RealInput uVOutMinSet
    "Minimum outdoor airflow requirement, output of a separate sequence that calculates this value based on ASHRAE Standard 62.1-2013 or California Title 24"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}}),
        iconTransformation(extent={{-120,20},{-100,40}})));
  CDL.Interfaces.IntegerInput uFreProSta "Freeze Protection Status" annotation (Placement(
        transformation(extent={{-160,-102},{-140,-82}}),  iconTransformation(extent={{-120,
            -90},{-100,-70}})));
  CDL.Interfaces.IntegerInput uAHUMode
    "AHU System Mode [fixme: Integer, see documentation for mapping]" annotation (Placement(
        transformation(extent={{-160,-70},{-140,-50}}),   iconTransformation(extent={{-120,
            -60},{-100,-40}})));
  CDL.Interfaces.RealInput TOutCut(unit="K", displayUnit="degC")
    "Outdoor temperature high limit cutoff [fixme: see #777]" annotation (
      Placement(transformation(extent={{-160,110},{-140,130}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
  CDL.Interfaces.RealInput hOut(unit="J/kg", displayUnit="kJ/kg", quantity="SpecificEnthalpy") if fixEnt
    "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}}),
        iconTransformation(extent={{-120,50},{-100,70}})));
  CDL.Interfaces.IntegerInput uZoneState
    "Zone state input (0=Heating, 1=Deadband, 2=Cooling)"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}}), iconTransformation(extent={{-120,-10},{-100,10}})));
  CDL.Interfaces.RealInput hOutCut(unit="J/kg", displayUnit="kJ/kg") if fixEnt
    "Outdoor enthalpy high limit cutoff [fixme: see #777]"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}}),
        iconTransformation(extent={{-120,30},{-100,50}})));
  AtomicSequences.EconModulationMultiZone ecoMod
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
equation
  connect(econEnableDisable.uOutDamPosMax, ecoEnaDis.yOutDamPosMax) annotation (
     Line(points={{-21,-54},{-42,-54},{-42,37},{-59,37}}, color={0,0,127}));
  connect(econEnableDisable.uOutDamPosMin, ecoEnaDis.yOutDamPosMin) annotation (
     Line(points={{-21,-56},{-40,-56},{-40,-38},{-40,33},{-59,33}},    color={0,
          0,127}));
  connect(TOut, econEnableDisable.TOut) annotation (Line(points={{-150,130},{
          -20,130},{-20,-40},{-21,-40}},
                                     color={0,0,127}));
  connect(uSupFan, ecoEnaDis.uSupFan) annotation (Line(points={{-150,-10},{-92,
          -10},{-92,30},{-81,30}},
                              color={255,0,255}));
  connect(uVOut, ecoEnaDis.uVOut) annotation (Line(points={{-150,30},{-150,30},
          {-120,30},{-120,38},{-81,38}},
                         color={0,0,127}));
  connect(uVOutMinSet, ecoEnaDis.uVOutMinSet) annotation (Line(points={{-150,40},
          {-98,40},{-98,35},{-81,35}}, color={0,0,127}));
  connect(uAHUMode, ecoEnaDis.uAHUMode) annotation (Line(points={{-150,-60},{
          -116,-60},{-116,25},{-81,25}}, color={255,127,0}));
  connect(uFreProSta, ecoEnaDis.uFreProSta) annotation (Line(points={{-150,-92},
          {-140,-92},{-90,-92},{-90,-40},{-90,-40},{-90,22},{-81,22}}, color={
          255,127,0}));
  connect(uZoneState, econEnableDisable.uZoneState) annotation (Line(points={{
          -150,-80},{-88,-80},{-88,-50},{-21,-50}}, color={255,127,0}));
  connect(uFreProSta, econEnableDisable.uFreProSta) annotation (Line(points={{
          -150,-92},{-85.5,-92},{-85.5,-48},{-21,-48}}, color={255,127,0}));
  connect(TCooSet, ecoMod.TCooSet) annotation (Line(points={{-150,70},{22,70},{
          22,36},{22,19},{30,19},{39,19}}, color={0,0,127}));
  connect(TSup, ecoMod.TSup) annotation (Line(points={{-150,60},{0,60},{0,16},{
          39,16}}, color={0,0,127}));
  connect(econEnableDisable.yOutDamPosMax, ecoMod.uOutDamPosMax) annotation (
      Line(points={{2,-44},{22,-44},{22,11},{39,11}}, color={0,0,127}));
  connect(econEnableDisable.yRetDamPosMax, ecoMod.uRetDamPosMax) annotation (
      Line(points={{2,-52},{2,4},{4,4},{40,4},{40,4},{39,4}}, color={0,0,127}));
  connect(econEnableDisable.yRetDamPosMin, ecoMod.uRetDamPosMin) annotation (
      Line(points={{2,-58},{22,-58},{22,1},{39,1}}, color={0,0,127}));
  connect(uSupFan, econEnableDisable.uSupFan) annotation (Line(points={{-150,
          -10},{-92,-10},{-92,-52},{-21,-52}}, color={255,0,255}));
  connect(econEnableDisable.uRetDamPosMin, ecoEnaDis.yRetDamPosMin) annotation
    (Line(points={{-21,-62},{-40,-62},{-40,29},{-59,29}}, color={0,0,127}));
  connect(econEnableDisable.uRetDamPosMin, ecoEnaDis.yRetDamPosMin) annotation
    (Line(points={{-21,-62},{-40,-62},{-40,29},{-59,29}}, color={0,0,127}));
  connect(econEnableDisable.uRetDamPhyPosMax, ecoEnaDis.yRetDamPhyPosMax)
    annotation (Line(points={{-21,-58},{-40,-58},{-40,24.6},{-59,24.6}}, color=
          {0,0,127}));
  connect(ecoEnaDis.yOutDamPosMin, ecoMod.uOutDamPosMin) annotation (Line(
        points={{-59,33},{-10.5,33},{-10.5,8},{39,8}}, color={0,0,127}));
  connect(TOutCut, econEnableDisable.TOutCut) annotation (Line(points={{-150,
          120},{-32,120},{-32,-42},{-21,-42}}, color={0,0,127}));
  connect(hOut, econEnableDisable.hOut) annotation (Line(points={{-150,100},{
          -34,100},{-34,-44},{-21,-44}}, color={0,0,127}));
  connect(hOutCut, econEnableDisable.hOutCut) annotation (Line(points={{-150,90},
          {-36,90},{-36,-46},{-21,-46}}, color={0,0,127}));
  connect(ecoMod.yRetDamPos, yRetDamPos) annotation (Line(points={{61,12},{112,
          12},{112,40},{170,40}}, color={0,0,127}));
  connect(ecoMod.yOutDamPos, yOutDamPos) annotation (Line(points={{61,8},{113.5,
          8},{113.5,-20},{170,-20}}, color={0,0,127}));
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
          thickness=0.5),
        Text(
          extent={{100,62},{170,26}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRetDamPos",
          fontSize=40),
        Text(
          extent={{100,18},{170,-18}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yOutDamPos",
          fontSize=40)}), Diagram(coordinateSystem(preserveAspectRatio=false, extent={
            {-140,-140},{160,140}})));
end EconomizerMultiZone;
