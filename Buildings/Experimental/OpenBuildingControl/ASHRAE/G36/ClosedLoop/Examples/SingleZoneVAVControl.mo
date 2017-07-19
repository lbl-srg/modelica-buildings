within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.ClosedLoop.Examples;
model SingleZoneVAVControl
  Atomic.VAVSingleZoneTSupSet setPoiVAV annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Atomic.HeatingCoolingControlLoops conLoo annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Composite.EconomizerSingleZone economizer(use_enthalpy=false)
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Interfaces.RealInput TRoo(unit="K")
    annotation (Placement(transformation(rotation=0, extent={{-159,115},{-149,125}})));
  Modelica.Blocks.Interfaces.RealInput TRooCooSet(unit="K")
    annotation (Placement(transformation(rotation=0, extent={{-159,75},{-149,85}})));
  Modelica.Blocks.Interfaces.RealInput TRooHeaSet(unit="K")
    annotation (Placement(transformation(rotation=0, extent={{-159,95},{-149,105}})));
  CDL.Interfaces.RealOutput yCoo(
    min=conLoo.conSigMin,
    max=conLoo.conSigMin,
    unit="1") annotation (Placement(transformation(rotation=0, extent={{51,-5},{61,5}})));
  CDL.Interfaces.RealOutput yHea(
    min=conLoo.conSigMin,
    max=conLoo.conSigMin,
    unit="1") annotation (Placement(transformation(rotation=0, extent={{51,15},{61,25}})));
  CDL.Interfaces.RealInput TOut(unit="K", quantity="ThermodynamicTemperature")
    annotation (Placement(transformation(rotation=0, extent={{-159,135},{-149,145}})));
  CDL.Interfaces.RealInput TOutCut(unit="K", quantity="ThermodynamicTemperature")
    annotation (Placement(transformation(rotation=0, extent={{-159,15},{-149,25}})));
  CDL.Interfaces.RealInput TSup(unit="K", quantity="ThermodynamicTemperature")
    annotation (Placement(transformation(rotation=0, extent={{-159,-5},{-149,5}})));
  CDL.Interfaces.IntegerInput uFreProSta
    annotation (Placement(transformation(rotation=0, extent={{-159,-15},{-149,-5}})));
  CDL.Interfaces.IntegerInput uOpeMod annotation (Placement(transformation(rotation=0, extent={{-159,-25},{-149,-15}})));
  CDL.Interfaces.BooleanInput uSupFan annotation (Placement(transformation(rotation=0, extent={{-159,55},{-149,65}})));
  CDL.Interfaces.RealInput uVOutMinSet_flow(min=economizer.minVOut_flow, max=economizer.desVOut_flow)
    annotation (Placement(transformation(rotation=0, extent={{-159,25},{-149,35}})));
  CDL.Interfaces.IntegerInput uZonSta annotation (Placement(transformation(rotation=0, extent={{-159,-35},{-149,-25}})));
  CDL.Interfaces.RealOutput yOutDamPos annotation (Placement(transformation(rotation=0, extent={{51,-25},{61,-15}})));
  CDL.Interfaces.RealInput TSetZon(unit="K", displayUnit="degC")
    annotation (Placement(transformation(rotation=0, extent={{-159,143},{-149,153}})));
  CDL.Interfaces.RealOutput y(
    min=0,
    max=1,
    unit="1") annotation (Placement(transformation(rotation=0, extent={{51,95},{61,105}})));
equation
  connect(conLoo.yHea, setPoiVAV.uHea)
    annotation (Line(points={{-99,94},{-80,94},{-80,78},{-42,78}},  color={0,0,127}));
  connect(conLoo.yCoo, setPoiVAV.uCoo)
    annotation (Line(points={{-99,86},{-70,86},{-70,74},{-42,74}},  color={0,0,127}));
  connect(setPoiVAV.THeaEco, economizer.TCooSet)
    annotation (Line(points={{-19,76},{-10,76},{-10,-28},{-1,-28}}, color={0,0,127}));
  connect(setPoiVAV.y, economizer.uSupFanSpe)
    annotation (Line(points={{-19,64},{-10,64},{-10,-32},{-1,-32}}, color={0,0,127}));
  connect(TRoo, conLoo.TRoo)
    annotation (Line(points={{-154,120},{-154,118},{-130,118},{-126,118},{-126,86},{-121,86}}, color={0,0,127}));
  connect(TRooCooSet, conLoo.TRooCooSet)
    annotation (Line(points={{-154,80},{-146,80},{-146,92},{-121,92}}, color={0,0,127}));
  connect(TRooHeaSet, conLoo.TRooHeaSet)
    annotation (Line(points={{-154,100},{-146,100},{-146,96},{-121,96}}, color={0,0,127}));
  connect(yCoo, conLoo.yCoo) annotation (Line(points={{56,0},{56,0},{-80,0},{-80,86},{-99,86}}, color={0,0,127}));
  connect(yHea, conLoo.yHea) annotation (Line(points={{56,20},{-100,20},{-100,94},{-99,94}}, color={0,0,127}));
  connect(TOut, economizer.TOut)
    annotation (Line(points={{-154,140},{-10,140},{-10,-18},{-1,-18}}, color={255,204,51}));
  connect(TOutCut, economizer.TOutCut)
    annotation (Line(points={{-154,20},{-154,20},{-118,20},{-60,20},{-60,-20},{-1,-20}}, color={0,0,127}));
  connect(TSup, economizer.TSup)
    annotation (Line(points={{-154,0},{-154,0},{-134,0},{-134,0},{-68,0},{-68,-26},{-1,-26}}, color={0,0,127}));
  connect(uFreProSta, economizer.uFreProSta) annotation (Line(points={{-154,-10},{-154,-10},{-80,-10},{-80,-10},{-40,
          -10},{-40,-40},{-1,-40}}, color={255,127,0}));
  connect(uOpeMod, economizer.uOpeMod) annotation (Line(points={{-154,-20},{-154,-20},{-100,-20},{-100,-20},{-50,-20},{
          -50,-36},{-1,-36}}, color={255,127,0}));
  connect(uSupFan, economizer.uSupFan) annotation (Line(points={{-154,60},{-154,60},{-152,60},{-152,60},{-134,60},{-68,
          60},{-68,-34},{-1,-34}}, color={255,0,255}));
  connect(uVOutMinSet_flow, economizer.uVOutMinSet_flow)
    annotation (Line(points={{-154,30},{24,30},{24,-30},{-1,-30}}, color={0,0,127}));
  connect(uZonSta, economizer.uZonSta) annotation (Line(points={{-154,-30},{-154,-30},{-140,-30},{-140,-30},{-70,-30},{
          -70,-38},{-1,-38}}, color={255,127,0}));
  connect(yOutDamPos, economizer.yOutDamPos)
    annotation (Line(points={{56,-20},{36,-20},{36,-32},{21,-32}}, color={0,0,127}));
  connect(TOut, setPoiVAV.TOut) annotation (Line(points={{-154,140},{-52,140},{-52,62},{-42,62}}, color={255,204,51}));
  connect(TSetZon, setPoiVAV.TSetZon)
    annotation (Line(points={{-154,148},{-60,148},{-60,70},{-42,70}}, color={0,0,127}));
  connect(TRoo, setPoiVAV.TZon)
    annotation (Line(points={{-154,120},{-154,118},{-126,118},{-84,118},{-84,66},{-42,66}}, color={0,0,127}));
  connect(y, setPoiVAV.y) annotation (Line(points={{56,100},{16,100},{16,64},{-19,64}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-150,-50},{50,150}})), Icon(coordinateSystem(extent={{-150,-50},{50,150}})));
end SingleZoneVAVControl;
