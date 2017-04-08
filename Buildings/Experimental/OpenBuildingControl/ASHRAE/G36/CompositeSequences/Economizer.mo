within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.CompositeSequences;
model Economizer "Economizer control block"

  AtomicSequences.EconEnableDisable econEnableDisable
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  AtomicSequences.EconDamPosLimits ecoEnaDis
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  AtomicSequences.EconModulation ecoMod
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  CDL.Interfaces.RealInput TCooSet
    "Output of a ***TSupSet sequence. The economizer modulates to the TCoo rather 
    than to the THea. If Zone State is Cooling, economizer modulates to a temperature 
    slightly lower than the TCoo [PART5.P.1]."
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  CDL.Interfaces.RealInput TSup
    "Measured supply air temperature. Sensor output."
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  CDL.Interfaces.RealInput uCoo(min=0, max=1)
    "Cooling control signal."
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  CDL.Interfaces.RealInput uHea(min=0, max=1)
    "Heating control signal."
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply Fan Status, on or off"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  CDL.Interfaces.RealInput TOut(unit="K", displayUnit="degC")
    "Outdoor temperature" annotation (Placement(transformation(extent={{-120,90},
            {-100,110}}),      iconTransformation(extent={{-120,90},{-100,110}})));
  CDL.Interfaces.BooleanInput uFre(start=false) "Freezestat status" annotation (
     Placement(transformation(extent={{-120,-90},{-100,-70}}),
                                                             iconTransformation(
          extent={{-120,-90},{-100,-70}})));
  CDL.Interfaces.RealOutput yRetDamPos "Return air damper position"
                                               annotation (Placement(
        transformation(extent={{100,10},{120,30}}), iconTransformation(extent={{100,10},
            {120,30}})));
  CDL.Interfaces.RealOutput yEcoDamPos "Economizer damper position"
                                                annotation (Placement(
        transformation(extent={{100,-30},{120,-10}}), iconTransformation(extent={{100,-30},
            {120,-10}})));
  CDL.Interfaces.BooleanInput uAHUMod
    "AHU Mode, fixme: see pg. 103 in G36 for the full list of modes, here we use true = \"occupied\""
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  CDL.Interfaces.RealInput uVOut
    "Measured outdoor airflow rate. Sensor output. Location: after the economizer damper intake."
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  CDL.Interfaces.RealInput uVOutMinSet
    "Minimum outdoor airflow requirement, output of a separate sequence that calculates this value based on ASHRAE Standard 62.1-2013 or California Title 24"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
equation
  connect(econEnableDisable.uEcoDamPosMax, ecoEnaDis.yEcoDamPosMax) annotation (
     Line(points={{-22,-58},{-42,-58},{-42,31},{-59,31}}, color={0,0,127}));
  connect(econEnableDisable.uEcoDamPosMin, ecoEnaDis.yEcoDamPosMin) annotation (
     Line(points={{-22,-54},{-40,-54},{-40,22},{-40,33.2},{-59,33.2}}, color={0,
          0,127}));
  connect(ecoEnaDis.yRetDamPosMin, ecoMod.uRetDamPosMin) annotation (Line(
        points={{-59,28},{-26,28},{-26,-7},{38,-7}}, color={0,0,127}));
  connect(ecoEnaDis.yRetDamPosMax, ecoMod.uRetDamPosMax) annotation (Line(
        points={{-59,26},{-30,26},{-30,-10},{38,-10}}, color={0,0,127}));
  connect(ecoEnaDis.yEcoDamPosMin, ecoMod.uEcoDamPosMin) annotation (Line(
        points={{-59,33.2},{-20,33.2},{-20,32},{-20,32},{-20,-1},{38,-1}},
        color={0,0,127}));
  connect(econEnableDisable.yEcoDamPosMax, ecoMod.uEcoDamPosMax) annotation (
      Line(points={{1.9,-49.9},{10,-49.9},{10,-4},{38,-4}}, color={0,0,127}));
  connect(ecoMod.yRetDamPos, yRetDamPos) annotation (Line(points={{61,12},{80,12},
          {80,20},{110,20}}, color={0,0,127}));
  connect(ecoMod.yEcoDamPos, yEcoDamPos) annotation (Line(points={{61,8},{80,8},
          {80,-20},{110,-20}}, color={0,0,127}));
  connect(TCooSet, ecoMod.TCooSet) annotation (Line(points={{-110,80},{-46,80},{
          20,80},{20,18},{38,18}}, color={0,0,127}));
  connect(TSup, ecoMod.TSup) annotation (Line(points={{-110,60},{10,60},{10,14},
          {38,14}}, color={0,0,127}));
  connect(uCoo, ecoMod.uCoo) annotation (Line(points={{-110,-20},{-36,-20},{-36,
          10},{38,10}}, color={0,0,127}));
  connect(uHea, ecoMod.uHea) annotation (Line(points={{-110,-40},{-38,-40},{-38,
          6},{38,6}}, color={0,0,127}));
  connect(TOut, econEnableDisable.TOut) annotation (Line(points={{-110,100},{-40,
          100},{-40,-42},{-22,-42}}, color={0,0,127}));
  connect(TSup, econEnableDisable.TSup) annotation (Line(points={{-110,60},{-50,
          60},{-50,-46},{-22,-46}}, color={0,0,127}));
  connect(uSupFan, ecoEnaDis.uSupFan) annotation (Line(points={{-110,-60},{-96,-60},
          {-96,30},{-82,30}}, color={255,0,255}));
  connect(uVOut, ecoEnaDis.uVOut) annotation (Line(points={{-110,20},{-98,20},{-98,
          34},{-82,34}}, color={0,0,127}));
  connect(uVOutMinSet, ecoEnaDis.uVOutMinSet) annotation (Line(points={{-110,40},
          {-98,40},{-98,38},{-82,38}}, color={0,0,127}));
  connect(uAHUMod, ecoEnaDis.uAHUMod) annotation (Line(points={{-110,0},{-96,0},
          {-96,26},{-82,26}}, color={255,0,255}));
  connect(uFre, econEnableDisable.uFre) annotation (Line(points={{-110,-80},{-66,
          -80},{-66,-50},{-22,-50}}, color={255,0,255}));
  connect(uSupFan, ecoMod.uSupFan) annotation (Line(points={{-110,-60},{-36,-60},
          {-36,3},{38,3}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
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
          textString="yEcoDamPos",
          fontSize=40)}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end Economizer;
