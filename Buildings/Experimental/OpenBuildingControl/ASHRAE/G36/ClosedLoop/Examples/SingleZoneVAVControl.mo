within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.ClosedLoop.Examples;
model SingleZoneVAVControl
  Atomic.VAVSingleZoneTSupSet setPoiVAV annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Atomic.HeatingCoolingControlLoops conLoo annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  Composite.EconomizerSingleZone economizer(use_enthalpy=false)
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Interfaces.RealInput TRoo(unit="K")
    annotation (Placement(transformation(rotation=0, extent={{-155,115},{-145,125}})));
  Modelica.Blocks.Interfaces.RealInput TRooCooSet(unit="K")
    annotation (Placement(transformation(rotation=0, extent={{-155,75},{-145,85}})));
  Modelica.Blocks.Interfaces.RealInput TRooHeaSet(unit="K")
    annotation (Placement(transformation(rotation=0, extent={{-155,95},{-145,105}})));
  CDL.Interfaces.RealOutput yCoo(
    min=conLoo.conSigMin,
    max=conLoo.conSigMin,
    unit="1") annotation (Placement(transformation(rotation=0, extent={{45,-15},{55,-5}})));
  CDL.Interfaces.RealOutput yHea(
    min=conLoo.conSigMin,
    max=conLoo.conSigMin,
    unit="1") annotation (Placement(transformation(rotation=0, extent={{45,5},{55,15}})));
  CDL.Interfaces.RealInput TOut(unit="K", quantity="ThermodynamicTemperature")
    annotation (Placement(transformation(rotation=0, extent={{45,125},{55,135}})));
  CDL.Interfaces.RealInput TOutCut(unit="K", quantity="ThermodynamicTemperature")
    annotation (Placement(transformation(rotation=0, extent={{-45,-55},{-35,-45}})));
  CDL.Interfaces.RealInput TSup(unit="K", quantity="ThermodynamicTemperature")
    annotation (Placement(transformation(rotation=0, extent={{-15,-55},{-5,-45}})));
  CDL.Interfaces.IntegerInput uFreProSta annotation (Placement(transformation(rotation=0, extent={{5,-55},{15,-45}})));
  CDL.Interfaces.IntegerInput uOpeMod annotation (Placement(transformation(rotation=0, extent={{25,-55},{35,-45}})));
  CDL.Interfaces.BooleanInput uSupFan annotation (Placement(transformation(rotation=0, extent={{-65,-55},{-55,-45}})));
  CDL.Interfaces.RealInput uVOutMinSet_flow(min=economizer.minVOut_flow, max=economizer.desVOut_flow)
    annotation (Placement(transformation(rotation=0, extent={{45,-35},{55,-25}})));
  CDL.Interfaces.IntegerInput uZonSta annotation (Placement(transformation(rotation=0, extent={{45,-55},{55,-45}})));
  CDL.Interfaces.RealOutput yOutDamPos annotation (Placement(transformation(rotation=0, extent={{45,-15},{55,-5}})));
  CDL.Interfaces.RealInput TSetZon(unit="K", displayUnit="degC")
    annotation (Placement(transformation(rotation=0, extent={{-35,145},{-25,155}})));
  CDL.Interfaces.RealOutput y(
    min=0,
    max=1,
    unit="1") annotation (Placement(transformation(rotation=0, extent={{45,95},{55,105}})));
equation
  connect(conLoo.yHea, setPoiVAV.uHea)
    annotation (Line(points={{-119,74},{-80,74},{-80,78},{-42,78}}, color={0,0,127}));
  connect(conLoo.yCoo, setPoiVAV.uCoo)
    annotation (Line(points={{-119,66},{-70,66},{-70,74},{-42,74}}, color={0,0,127}));
  connect(setPoiVAV.THeaEco, economizer.TCooSet)
    annotation (Line(points={{-19,76},{-10,76},{-10,-28},{-1,-28}}, color={0,0,127}));
  connect(setPoiVAV.y, economizer.uSupFanSpe)
    annotation (Line(points={{-19,64},{-10,64},{-10,-32},{-1,-32}}, color={0,0,127}));
  connect(TRoo, conLoo.TRoo) annotation (Line(points={{-150,120},{-150,66},{-141,66}}, color={0,0,127}));
  connect(TRooCooSet, conLoo.TRooCooSet)
    annotation (Line(points={{-150,80},{-146,80},{-146,72},{-141,72}}, color={0,0,127}));
  connect(TRooHeaSet, conLoo.TRooHeaSet)
    annotation (Line(points={{-150,100},{-146,100},{-146,76},{-141,76}}, color={0,0,127}));
  connect(yCoo, conLoo.yCoo)
    annotation (Line(points={{50,-10},{-2,-10},{-2,8},{-80,8},{-80,66},{-119,66}}, color={0,0,127}));
  connect(yHea, conLoo.yHea) annotation (Line(points={{50,10},{-100,10},{-100,74},{-119,74}}, color={0,0,127}));
  connect(TOut, economizer.TOut) annotation (Line(points={{50,130},{-10,130},{-10,-18},{-1,-18}}, color={255,204,51}));
  connect(TOutCut, economizer.TOutCut) annotation (Line(points={{-40,-50},{-40,-20},{-1,-20}}, color={0,0,127}));
  connect(TSup, economizer.TSup) annotation (Line(points={{-10,-50},{-10,-26},{-1,-26}}, color={0,0,127}));
  connect(uFreProSta, economizer.uFreProSta) annotation (Line(points={{10,-50},{10,-40},{-1,-40}}, color={255,127,0}));
  connect(uOpeMod, economizer.uOpeMod) annotation (Line(points={{30,-50},{30,-36},{-1,-36}}, color={255,127,0}));
  connect(uSupFan, economizer.uSupFan) annotation (Line(points={{-60,-50},{-60,-34},{-1,-34}}, color={255,0,255}));
  connect(uVOutMinSet_flow, economizer.uVOutMinSet_flow) annotation (Line(points={{50,-30},{-1,-30}}, color={0,0,127}));
  connect(uZonSta, economizer.uZonSta) annotation (Line(points={{50,-50},{50,-38},{-1,-38}}, color={255,127,0}));
  connect(yOutDamPos, economizer.yOutDamPos)
    annotation (Line(points={{50,-10},{36,-10},{36,-32},{21,-32}}, color={0,0,127}));
  connect(TOut, setPoiVAV.TOut) annotation (Line(points={{50,130},{-52,130},{-52,62},{-42,62}}, color={255,204,51}));
  connect(TSetZon, setPoiVAV.TSetZon)
    annotation (Line(points={{-30,150},{-36,150},{-36,70},{-42,70}}, color={0,0,127}));
  connect(TRoo, setPoiVAV.TZon) annotation (Line(points={{-150,120},{-150,66},{-42,66}}, color={0,0,127}));
  connect(y, setPoiVAV.y) annotation (Line(points={{50,100},{16,100},{16,64},{-19,64}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-150,-50},{50,150}})), Icon(coordinateSystem(extent={{-150,-50},{50,150}})));
end SingleZoneVAVControl;
