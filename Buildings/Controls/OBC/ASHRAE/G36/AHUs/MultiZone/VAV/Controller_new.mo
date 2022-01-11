within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV;
block Controller_new "Multizone VAV air handling unit controller"
  FreezeProtection frePro "Freeze protection"
    annotation (Placement(transformation(extent={{90,-198},{110,-158}})));
  PlantRequests plaReq "Plant requests"
    annotation (Placement(transformation(extent={{0,-360},{20,-340}})));
  Economizers.Controller ecoCon "Economizer controller"
    annotation (Placement(transformation(extent={{92,-102},{112,-62}})));
  SetPoints.SupplyFan conSupFan "Supply fan "
    annotation (Placement(transformation(extent={{-200,380},{-180,400}})));
  SetPoints.SupplySignals supSig "Heating and cooling valve position"
    annotation (Placement(transformation(extent={{0,280},{20,300}})));
  SetPoints.SupplyTemperature conTSupSet "Supply temperature setpoint"
    annotation (Placement(transformation(extent={{-120,320},{-100,340}})));
  SetPoints.OutdoorAirFlow.AHU outAirSet "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  CDL.Interfaces.IntegerInput uOpeMod[nZonGro] "Zone group operation mode"
    annotation (Placement(transformation(extent={{-380,420},{-340,460}}),
        iconTransformation(extent={{-366,420},{-326,460}})));
  CDL.Continuous.MultiMin mulMin(nin=nZonGro)
    "Find the highest priotity operating mode"
    annotation (Placement(transformation(extent={{-280,430},{-260,450}})));
  CDL.Conversions.IntegerToReal intToRea[nZonGro] "Convert integer to real"
    annotation (Placement(transformation(extent={{-320,430},{-300,450}})));
  CDL.Conversions.RealToInteger ahuMod "Air handling operating mode"
    annotation (Placement(transformation(extent={{-240,430},{-220,450}})));
  CDL.Interfaces.IntegerInput uZonPreResReq
    "Zone static pressure reset requests" annotation (Placement(transformation(
          extent={{-380,380},{-340,420}}), iconTransformation(extent={{-356,380},
            {-316,420}})));
  CDL.Interfaces.RealInput ducStaPre "Measured duct static pressure"
    annotation (Placement(transformation(extent={{-380,340},{-340,380}}),
        iconTransformation(extent={{-362,340},{-322,380}})));
  CDL.Interfaces.RealInput TOut "Outdoor air temperature" annotation (Placement(
        transformation(extent={{-380,310},{-340,350}}), iconTransformation(
          extent={{-370,306},{-330,346}})));
  CDL.Interfaces.IntegerInput uZonTemResReq
    "Zone cooling supply air temperature reset request" annotation (Placement(
        transformation(extent={{-380,260},{-340,300}}), iconTransformation(
          extent={{-366,260},{-326,300}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply fan status" annotation (Placement(
        transformation(extent={{-380,220},{-340,260}}), iconTransformation(
          extent={{-334,220},{-294,260}})));
  CDL.Interfaces.RealInput TSup "Measured supply air temperature" annotation (
      Placement(transformation(extent={{-380,180},{-340,220}}),
        iconTransformation(extent={{-370,178},{-330,218}})));
  CDL.Interfaces.RealInput                        sumDesZonPop(final min=0,
      final unit="1")
    "Sum of the design population of the zones in the group"
    annotation (Placement(transformation(extent={{-380,150},{-340,190}}),
        iconTransformation(extent={{-240,170},{-200,210}})));
  CDL.Interfaces.RealInput                        VSumDesPopBreZon_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of the population component design breathing zone flow rate"
    annotation (Placement(transformation(extent={{-380,120},{-340,160}}),
        iconTransformation(extent={{-240,140},{-200,180}})));
  CDL.Interfaces.RealInput                        VSumDesAreBreZon_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of the area component design breathing zone flow rate"
    annotation (Placement(transformation(extent={{-380,90},{-340,130}}),
        iconTransformation(extent={{-240,110},{-200,150}})));
  CDL.Interfaces.RealInput                        uDesSysVenEff(final min=0,
      final unit="1")
    "Design system ventilation efficiency, equals to the minimum of all zones ventilation efficiency"
    annotation (Placement(transformation(extent={{-380,60},{-340,100}}),
        iconTransformation(extent={{-240,80},{-200,120}})));
  CDL.Interfaces.RealInput                        VSumUncOutAir_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of all zones required uncorrected outdoor airflow rate"
    annotation (Placement(transformation(extent={{-380,30},{-340,70}}),
        iconTransformation(extent={{-240,50},{-200,90}})));
  CDL.Interfaces.RealInput                        VSumSysPriAir_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "System primary airflow rate, equals to the sum of the measured discharged flow rate of all terminal units"
    annotation (Placement(transformation(extent={{-380,0},{-340,40}}),
        iconTransformation(extent={{-240,20},{-200,60}})));
  CDL.Interfaces.RealInput                        uOutAirFra_max(final min=0,
      final unit="1")
    "Maximum zone outdoor air fraction, equals to the maximum of primary outdoor air fraction of all zones"
    annotation (Placement(transformation(extent={{-380,-30},{-340,10}}),
        iconTransformation(extent={{-240,-10},{-200,30}})));
  CDL.Interfaces.BooleanOutput ySupFan "Supply fan enabling status" annotation
    (Placement(transformation(extent={{360,420},{400,460}}), iconTransformation(
          extent={{186,402},{226,442}})));
  CDL.Interfaces.RealOutput ySupFanSpe "Supply fan speed setpoint" annotation (
      Placement(transformation(extent={{360,390},{400,430}}),
        iconTransformation(extent={{180,368},{220,408}})));
  CDL.Interfaces.RealOutput yHeaCoi if have_heatingCoil
    "Heating coil valve position" annotation (Placement(transformation(extent={
            {360,320},{400,360}}), iconTransformation(extent={{340,320},{380,
            360}})));
  CDL.Interfaces.RealOutput yCooCoi "Cooling coil valve position" annotation (
      Placement(transformation(extent={{360,290},{400,330}}),
        iconTransformation(extent={{278,290},{318,330}})));
  CDL.Interfaces.IntegerOutput yChiWatResReq "Chilled water reset request"
    annotation (Placement(transformation(extent={{360,-320},{400,-280}}),
        iconTransformation(extent={{338,-320},{378,-280}})));
  CDL.Interfaces.IntegerOutput yChiPlaReq "Chiller plant request" annotation (
      Placement(transformation(extent={{360,-350},{400,-310}}),
        iconTransformation(extent={{308,-348},{348,-308}})));
  CDL.Interfaces.IntegerOutput yHotWatResReq "Hot water reset request"
    annotation (Placement(transformation(extent={{360,-390},{400,-350}}),
        iconTransformation(extent={{346,-388},{386,-348}})));
  CDL.Interfaces.IntegerOutput yHotWatPlaReq "Hot water plant request"
    annotation (Placement(transformation(extent={{360,-420},{400,-380}}),
        iconTransformation(extent={{212,-416},{252,-376}})));
  CDL.Interfaces.RealInput uCooCoi "Cooling coil valve position" annotation (
      Placement(transformation(extent={{-380,-390},{-340,-350}}),
        iconTransformation(extent={{-330,-388},{-290,-348}})));
  CDL.Interfaces.RealInput uHeaCoi if have_heatingCoil
    "Heating coil valve position" annotation (Placement(transformation(extent={
            {-380,-420},{-340,-380}}), iconTransformation(extent={{-330,-388},{
            -290,-348}})));
equation
  connect(uOpeMod, intToRea.u)
    annotation (Line(points={{-360,440},{-322,440}}, color={255,127,0}));
  connect(intToRea.y, mulMin.u)
    annotation (Line(points={{-298,440},{-282,440}}, color={0,0,127}));
  connect(mulMin.y, ahuMod.u)
    annotation (Line(points={{-258,440},{-242,440}}, color={0,0,127}));
  connect(conSupFan.uZonPreResReq, uZonPreResReq) annotation (Line(points={{
          -202,387},{-280,387},{-280,400},{-360,400}}, color={255,127,0}));
  connect(ducStaPre, conSupFan.ducStaPre) annotation (Line(points={{-360,360},{
          -280,360},{-280,382},{-202,382}}, color={0,0,127}));
  connect(conTSupSet.TOut, TOut) annotation (Line(points={{-122,337},{-300,337},
          {-300,330},{-360,330}}, color={0,0,127}));
  connect(conTSupSet.uZonTemResReq, uZonTemResReq) annotation (Line(points={{
          -122,333},{-290,333},{-290,280},{-360,280}}, color={255,127,0}));
  connect(uSupFan, conTSupSet.uSupFan) annotation (Line(points={{-360,240},{
          -280,240},{-280,327},{-122,327}}, color={255,0,255}));
  connect(uSupFan, supSig.uSupFan) annotation (Line(points={{-360,240},{-280,
          240},{-280,295},{-2,295}}, color={255,0,255}));
  connect(conTSupSet.TSupSet, supSig.TSupSet) annotation (Line(points={{-98,330},
          {-80,330},{-80,290},{-2,290}}, color={0,0,127}));
  connect(supSig.TSup, TSup) annotation (Line(points={{-2,285},{-270,285},{-270,
          200},{-360,200}}, color={0,0,127}));
  connect(sumDesZonPop, outAirSet.sumDesZonPop) annotation (Line(points={{-360,
          170},{-20,170},{-20,79},{-2,79}}, color={0,0,127}));
  connect(VSumDesPopBreZon_flow, outAirSet.VSumDesPopBreZon_flow) annotation (
      Line(points={{-360,140},{-28,140},{-28,77},{-2,77}}, color={0,0,127}));
  connect(VSumDesAreBreZon_flow, outAirSet.VSumDesAreBreZon_flow) annotation (
      Line(points={{-360,110},{-36,110},{-36,75},{-2,75}}, color={0,0,127}));
  connect(uDesSysVenEff, outAirSet.uDesSysVenEff) annotation (Line(points={{
          -360,80},{-42,80},{-42,73},{-2,73}}, color={0,0,127}));
  connect(VSumUncOutAir_flow, outAirSet.VSumUncOutAir_flow) annotation (Line(
        points={{-360,50},{-42,50},{-42,71},{-2,71}}, color={0,0,127}));
  connect(VSumSysPriAir_flow, outAirSet.VSumSysPriAir_flow) annotation (Line(
        points={{-360,20},{-36,20},{-36,69},{-2,69}}, color={0,0,127}));
  connect(uOutAirFra_max, outAirSet.uOutAirFra_max) annotation (Line(points={{
          -360,-10},{-28,-10},{-28,67},{-2,67}}, color={0,0,127}));
  connect(uSupFan, outAirSet.uSupFan) annotation (Line(points={{-360,240},{-280,
          240},{-280,63},{-2,63}}, color={255,0,255}));
  connect(ahuMod.y, conSupFan.uOpeMod) annotation (Line(points={{-218,440},{
          -210,440},{-210,398},{-202,398}}, color={255,127,0}));
  connect(ahuMod.y, conTSupSet.uOpeMod) annotation (Line(points={{-218,440},{
          -210,440},{-210,323},{-122,323}}, color={255,127,0}));
  connect(ahuMod.y, outAirSet.uOpeMod) annotation (Line(points={{-218,440},{
          -210,440},{-210,61},{-2,61}}, color={255,127,0}));
  connect(conSupFan.ySupFan, ySupFan) annotation (Line(points={{-178,397},{-80,
          397},{-80,440},{380,440}}, color={255,0,255}));
  connect(conSupFan.ySupFanSpe, ySupFanSpe) annotation (Line(points={{-178,390},
          {-70,390},{-70,410},{380,410}}, color={0,0,127}));
  connect(supSig.yHea, yHeaCoi) annotation (Line(points={{22,290},{150,290},{
          150,340},{380,340}}, color={0,0,127}));
  connect(supSig.yCoo, yCooCoi) annotation (Line(points={{22,286},{160,286},{
          160,310},{380,310}}, color={0,0,127}));
  connect(plaReq.yChiWatResReq, yChiWatResReq) annotation (Line(points={{22,
          -342},{200,-342},{200,-300},{380,-300}}, color={255,127,0}));
  connect(plaReq.yChiPlaReq, yChiPlaReq) annotation (Line(points={{22,-347},{
          210,-347},{210,-330},{380,-330}}, color={255,127,0}));
  connect(plaReq.yHotWatResReq, yHotWatResReq) annotation (Line(points={{22,
          -353},{210,-353},{210,-370},{380,-370}}, color={255,127,0}));
  connect(plaReq.yHotWatPlaReq, yHotWatPlaReq) annotation (Line(points={{22,
          -358},{200,-358},{200,-400},{380,-400}}, color={255,127,0}));
  connect(TSup, plaReq.TSup) annotation (Line(points={{-360,200},{-270,200},{
          -270,-342},{-2,-342}}, color={0,0,127}));
  connect(conTSupSet.TSupSet, plaReq.TSupSet) annotation (Line(points={{-98,330},
          {-80,330},{-80,-347},{-2,-347}}, color={0,0,127}));
  connect(plaReq.uCooCoi, uCooCoi) annotation (Line(points={{-2,-353},{-270,
          -353},{-270,-370},{-360,-370}}, color={0,0,127}));
  connect(uHeaCoi, plaReq.uHeaCoi) annotation (Line(points={{-360,-400},{-260,
          -400},{-260,-358},{-2,-358}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-340,
            -480},{360,480}})), Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-340,-480},{360,480}})));
end Controller_new;
