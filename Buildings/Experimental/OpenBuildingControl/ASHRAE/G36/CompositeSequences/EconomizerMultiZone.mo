within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.CompositeSequences;
model EconomizerMultiZone "Economizer control block"

  AtomicSequences.EconEnableDisableMultiZone econEnableDisable
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  AtomicSequences.EconDamperPositionLimitsMultiZone
                                           ecoEnaDis
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  AtomicSequences.EconModulationSingleZone
                                 ecoMod
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  CDL.Interfaces.RealInput TCooSet
    "Output of a ***TSupSet sequence. The economizer modulates to the TCoo rather 
    than to the THea. If Zone State is Cooling, economizer modulates to a temperature 
    slightly lower than the TCoo [PART5.P.1]."
    annotation (Placement(transformation(extent={{-160,46},{-140,66}}),
        iconTransformation(extent={{-120,60},{-100,80}})));
  CDL.Interfaces.RealInput TSup
    "Measured supply air temperature. Sensor output."
    annotation (Placement(transformation(extent={{-160,28},{-140,48}}),
        iconTransformation(extent={{-120,40},{-100,60}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply Fan Status, on or off"
    annotation (Placement(transformation(extent={{-120,-12},{-100,8}}),
        iconTransformation(extent={{-120,-80},{-100,-60}})));
  CDL.Interfaces.RealInput TOut "Outdoor temperature"
    annotation (Placement(transformation(extent={{-160,120},{-140,140}}),
    iconTransformation(extent={{-120,80},{-100,100}})));
  CDL.Interfaces.RealOutput yRetDamPos "Return air damper position"
    annotation (Placement(transformation(extent={{100,10},{120,30}}),
    iconTransformation(extent={{100,10}, {120,30}})));
  CDL.Interfaces.RealOutput yOutDamPos "Economizer damper position"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}}),
    iconTransformation(extent={{100,-30}, {120,-10}})));
  CDL.Interfaces.RealInput uVOut
    "Measured outdoor airflow rate. Sensor output. Location: after the economizer damper intake."
    annotation (Placement(transformation(extent={{-160,-6},{-140,14}}),
        iconTransformation(extent={{-120,0},{-100,20}})));
  CDL.Interfaces.RealInput uVOutMinSet
    "Minimum outdoor airflow requirement, output of a separate sequence that calculates this value based on ASHRAE Standard 62.1-2013 or California Title 24"
    annotation (Placement(transformation(extent={{-160,8},{-140,28}}),
        iconTransformation(extent={{-120,20},{-100,40}})));
  CDL.Interfaces.IntegerInput uFreProSta "Freeze Protection Status" annotation (Placement(
        transformation(extent={{-122,-26},{-100,-4}}),    iconTransformation(extent={{-120,
            -90},{-100,-70}})));
  CDL.Interfaces.IntegerInput uAHUMode
    "AHU System Mode [fixme: Integer, see documentation for mapping]" annotation (Placement(
        transformation(extent={{-120,-42},{-100,-22}}),   iconTransformation(extent={{-120,
            -60},{-100,-40}})));
  CDL.Interfaces.RealInput TOutCut(unit="K", displayUnit="degC")
    "Outdoor temperature high limit cutoff [fixme: see #777]" annotation (
      Placement(transformation(extent={{-166,98},{-140,124}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
  CDL.Interfaces.RealInput hOut(unit="J/kg", displayUnit="kJ/kg", quantity="SpecificEnthalpy") if fixEnt
    "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-160,84},{-140,104}}),
        iconTransformation(extent={{-120,50},{-100,70}})));
  CDL.Interfaces.IntegerInput uZoneState
    "Zone state input (0=Heating, 1=Deadband, 2=Cooling)"
    annotation (Placement(transformation(extent={{-152,-58},{-128,-34}}), iconTransformation(extent={{-120,-10},{-100,10}})));
  CDL.Interfaces.RealInput hOutCut(unit="J/kg", displayUnit="kJ/kg") if fixEnt
    "Outdoor enthalpy high limit cutoff [fixme: see #777]"
    annotation (Placement(transformation(extent={{-166,66},{-142,90}}),
        iconTransformation(extent={{-120,30},{-100,50}})));
equation
  connect(econEnableDisable.uOutDamPosMax, ecoEnaDis.yOutDamPosMax) annotation (
     Line(points={{-21,-52},{-42,-52},{-42,36},{-59,36}}, color={0,0,127}));
  connect(econEnableDisable.uOutDamPosMin, ecoEnaDis.yOutDamPosMin) annotation (
     Line(points={{-21,-54},{-40,-54},{-40,22},{-40,32},{-59,32}},     color={0,
          0,127}));
  connect(ecoEnaDis.yRetDamPosMin, ecoMod.uRetDamPosMin) annotation (Line(
        points={{-59,28},{-26,28},{-26,3.07143},{39.3571,3.07143}},
                                                     color={0,0,127}));
  connect(ecoEnaDis.yRetDamPosMax, ecoMod.uRetDamPosMax) annotation (Line(
        points={{-59,24},{-30,24},{-30,1.07143},{39.3571,1.07143}},
                                                       color={0,0,127}));
  connect(ecoEnaDis.yOutDamPosMin, ecoMod.uOutDamPosMin) annotation (Line(
        points={{-59,32},{-20,32},{-20,7.21429},{39.3571,7.21429}},
        color={0,0,127}));
  connect(econEnableDisable.yOutDamPosMax2, ecoMod.uOutDamPosMax) annotation (
      Line(points={{1.9,-51.2222},{10,-51.2222},{10,5.21429},{39.3571,5.21429}},
        color={0,0,127}));
  connect(ecoMod.yRetDamPos, yRetDamPos) annotation (Line(points={{60.7143,
          11.4286},{80,11.4286},{80,20},{110,20}},
                             color={0,0,127}));
  connect(ecoMod.yOutDamPos, yOutDamPos) annotation (Line(points={{60.7143,
          8.57143},{80,8.57143},{80,-20},{110,-20}},
                               color={0,0,127}));
  connect(TCooSet, ecoMod.TCooSet) annotation (Line(points={{-150,56},{-150,58},
          {-124,58},{-124,58},{20,58},{20,17.7857},{39.2143,17.7857}},
                                   color={0,0,127}));
  connect(TSup, ecoMod.TSup) annotation (Line(points={{-150,38},{10,38},{10,
          16.2143},{39.3571,16.2143}},
                    color={0,0,127}));
  connect(TOut, econEnableDisable.TOut) annotation (Line(points={{-150,130},{
          -40,130},{-40,-40},{-21,-40}},
                                     color={0,0,127}));
  connect(uSupFan, ecoEnaDis.uSupFan) annotation (Line(points={{-110,-2},{-88,-2},
          {-88,28},{-81,28},{-81,30}},
                              color={255,0,255}));
  connect(uVOut, ecoEnaDis.uVOut) annotation (Line(points={{-150,4},{-150,46},{
          -82,46},{-82,38},{-81,38}},
                         color={0,0,127}));
  connect(uVOutMinSet, ecoEnaDis.uVOutMinSet) annotation (Line(points={{-150,18},
          {-98,18},{-98,35},{-81,35}}, color={0,0,127}));
  connect(uSupFan, ecoMod.uSupFan) annotation (Line(points={{-110,-2},{-36,-2},
          {-36,9.5},{39.3571,9.5}},
                           color={255,0,255}));
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
