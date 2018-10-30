within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV;
block Controller "Single Zone AHU controller that composes subsequences for controlling fan speed, economizer, and supply air temperature"
  ModeAndSetPoints
    modSetPoi
    annotation (Placement(transformation(extent={{-160,180},{-140,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc
    "Time to next occupied period"
    annotation (Placement(transformation(extent={{-240,180},{-200,220}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon
    "Measured zone temperatures"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Current occupancy period, true if it is in occupant period"
    annotation (Placement(transformation(extent={{-240,100},{-200,140}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply
    setPoiVAV
    annotation (Placement(transformation(extent={{40,180},{60,200}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID cooPI(controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI, reset=
        Buildings.Controls.OBC.CDL.Types.Reset.Parameter)
    annotation (Placement(transformation(extent={{-30,160},{-10,180}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID heaPI(controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI, reset=
        Buildings.Controls.OBC.CDL.Types.Reset.Parameter)
    annotation (Placement(transformation(extent={{-30,200},{-10,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Average ave
    annotation (Placement(transformation(extent={{-70,180},{-50,200}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Controller
    conEco annotation (Placement(transformation(extent={{120,100},{140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRet
    "Measured return air temperature"
    annotation (Placement(transformation(extent={{-240,60},{-200,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-240,20},{-200,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-240,-20},{-200,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput nOcc "Number of occupants"
    annotation (Placement(transformation(extent={{-240,-60},{-200,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-240,-100},{-200,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupHeaEco
    "Temperature setpoint for heating coil and for economizer"
    annotation (Placement(transformation(extent={{200,230},{220,250}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupCoo
    "Cooling supply air temperature setpoint"
    annotation (Placement(transformation(extent={{200,190},{220,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFan "Fan speed"
    annotation (Placement(transformation(extent={{200,150},{220,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos
    "Return air damper position"
    annotation (Placement(transformation(extent={{200,110},{220,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{200,70},{220,90}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.OutsideAirFlow
    outAirSetPoi
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-240,220},{-200,260}})));
  ZoneState zonSta
    annotation (Placement(transformation(extent={{40,130},{60,150}})));
  CDL.Integers.Sources.Constant conInt(k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.unoccupied)
    "Unoccupied mode"
    annotation (Placement(transformation(extent={{-126,-120},{-106,-100}})));
  CDL.Integers.Equal intEqu
    "Check if current operation mode is unoccupied mode"
    annotation (Placement(transformation(extent={{-90,-120},{-70,-100}})));
  CDL.Logical.Not switch "If in unoccupied mode, switch off"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
equation
  connect(modSetPoi.tNexOcc, tNexOcc) annotation (Line(points={{-161,198},{-190,
          198},{-190,200},{-220,200}},      color={0,0,127}));
  connect(cooPI.y, setPoiVAV.uCoo) annotation (Line(points={{-9,170},{0,170},{0,
          194},{38,194}},            color={0,0,127}));
  connect(heaPI.y, setPoiVAV.uHea) annotation (Line(points={{-9,210},{0,210},{0,
          198},{38,198}},            color={0,0,127}));
  connect(ave.y, setPoiVAV.TZonSet) annotation (Line(points={{-49,190.2},{-14,
          190.2},{-14,190},{38,190}},  color={0,0,127}));
  connect(TRet, conEco.TOutCut) annotation (Line(points={{-220,80},{-90,80},{
          -90,120},{119,120}},  color={0,0,127}));
  connect(conEco.TSup, TSup) annotation (Line(points={{119,114},{-4,114},{-4,40},
          {-220,40}},     color={0,0,127}));
  connect(setPoiVAV.TSupHeaEco, conEco.THeaSupSet) annotation (Line(points={{61,196},
          {92,196},{92,112},{119,112}},       color={0,0,127}));
  connect(setPoiVAV.y, conEco.uSupFanSpe) annotation (Line(points={{61,184},{86,
          184},{86,108},{119,108}},
                                  color={0,0,127}));
  connect(TMix, conEco.TMix) annotation (Line(points={{-220,0},{0,0},{0,106},{
          119,106}},      color={0,0,127}));
  connect(modSetPoi.yOpeMod, conEco.uOpeMod) annotation (Line(points={{-139,187},
          {-134,187},{-134,102},{119,102}},     color={255,127,0}));
  connect(setPoiVAV.TSupHeaEco, TSupHeaEco) annotation (Line(points={{61,196},{
          160,196},{160,240},{210,240}},  color={0,0,127}));
  connect(setPoiVAV.TSupCoo, TSupCoo) annotation (Line(points={{61,190},{166,
          190},{166,200},{210,200}}, color={0,0,127}));
  connect(setPoiVAV.y, yFan) annotation (Line(points={{61,184},{166,184},{166,
          160},{210,160}}, color={0,0,127}));
  connect(conEco.yRetDamPos, yRetDamPos) annotation (Line(points={{141,112},{
          180,112},{180,120},{210,120}}, color={0,0,127}));
  connect(conEco.yOutDamPos, yOutDamPos) annotation (Line(points={{141,108},{
          180,108},{180,80},{210,80}}, color={0,0,127}));
  connect(outAirSetPoi.TDis, TSup) annotation (Line(points={{39,80},{-4,80},{-4,
          40},{-220,40}},      color={0,0,127}));
  connect(outAirSetPoi.uOpeMod, conEco.uOpeMod) annotation (Line(points={{39,72},
          {-134,72},{-134,102},{119,102}},    color={255,127,0}));
  connect(conEco.VOutMinSet_flow, outAirSetPoi.VOutMinSet_flow) annotation (
      Line(points={{119,110},{108,110},{108,80},{61,80}},
                                                       color={0,0,127}));
  connect(TOut, setPoiVAV.TOut) annotation (Line(points={{-220,240},{10,240},{
          10,182},{38,182}}, color={0,0,127}));
  connect(conEco.TOut, setPoiVAV.TOut) annotation (Line(points={{119,122},{10,
          122},{10,182},{38,182}}, color={0,0,127}));
  connect(cooPI.y, zonSta.uCoo) annotation (Line(points={{-9,170},{18,170},{18,
          136},{38,136}}, color={0,0,127}));
  connect(heaPI.y, zonSta.uHea) annotation (Line(points={{-9,210},{0,210},{0,
          198},{14,198},{14,172},{20,172},{20,144},{38,144}}, color={0,0,127}));
  connect(zonSta.yZonSta, conEco.uZonSta) annotation (Line(points={{61,140},{80,
          140},{80,100},{119,100}}, color={255,127,0}));
  connect(conInt.y, intEqu.u2) annotation (Line(points={{-105,-110},{-100,-110},
          {-100,-118},{-92,-118}}, color={255,127,0}));
  connect(intEqu.u1, conEco.uOpeMod) annotation (Line(points={{-92,-110},{-96,
          -110},{-96,-90},{-134,-90},{-134,102},{119,102}}, color={255,127,0}));
  connect(intEqu.y, switch.u)
    annotation (Line(points={{-69,-110},{-62,-110}}, color={255,0,255}));
  connect(switch.y, heaPI.trigger) annotation (Line(points={{-39,-110},{-36,
          -110},{-36,184},{-28,184},{-28,198}}, color={255,0,255}));
  connect(cooPI.trigger, heaPI.trigger) annotation (Line(points={{-28,158},{-28,
          140},{-36,140},{-36,184},{-28,184},{-28,198}}, color={255,0,255}));
  connect(conEco.uSupFan, heaPI.trigger) annotation (Line(points={{119,104},{
          -36,104},{-36,184},{-28,184},{-28,198}}, color={255,0,255}));
  connect(outAirSetPoi.uSupFan, heaPI.trigger) annotation (Line(points={{39,74},
          {-36,74},{-36,184},{-28,184},{-28,198}}, color={255,0,255}));
  connect(modSetPoi.TZonHeaSet, ave.u2) annotation (Line(points={{-139,193},{
          -100,193},{-100,184},{-72,184}}, color={0,0,127}));
  connect(modSetPoi.TZonHeaSet, heaPI.u_s) annotation (Line(points={{-139,193},
          {-100,193},{-100,210},{-32,210}}, color={0,0,127}));
  connect(modSetPoi.TZonCooSet, ave.u1) annotation (Line(points={{-139,197},{
          -80,197},{-80,196},{-72,196}}, color={0,0,127}));
  connect(modSetPoi.TZonCooSet, cooPI.u_s) annotation (Line(points={{-139,197},
          {-80,197},{-80,170},{-32,170}}, color={0,0,127}));
  connect(outAirSetPoi.uWin, uWin) annotation (Line(points={{39,76},{8,76},{8,
          -80},{-220,-80}}, color={255,0,255}));
  connect(modSetPoi.uOcc, uOcc) annotation (Line(points={{-161,186.025},{-166,
          186.025},{-166,120},{-220,120}}, color={255,0,255}));
  connect(TZon, modSetPoi.TZon) annotation (Line(points={{-220,160},{-180,160},
          {-180,195},{-161,195}}, color={0,0,127}));
  connect(TZon, cooPI.u_m) annotation (Line(points={{-220,160},{-180,160},{-180,
          150},{-20,150},{-20,158}}, color={0,0,127}));
  connect(setPoiVAV.TZon, cooPI.u_m) annotation (Line(points={{38,186},{6,186},
          {6,150},{-20,150},{-20,158}}, color={0,0,127}));
  connect(outAirSetPoi.TZon, cooPI.u_m)
    annotation (Line(points={{39,84},{-20,84},{-20,158}}, color={0,0,127}));
  connect(heaPI.u_m, cooPI.u_m) annotation (Line(points={{-20,198},{-20,186},{
          -40,186},{-40,150},{-20,150},{-20,158}}, color={0,0,127}));
  connect(nOcc, outAirSetPoi.nOcc) annotation (Line(points={{-220,-40},{4,-40},
          {4,88},{39,88}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -240},{200,240}}), graphics={
                           Rectangle(
        extent={{-200,-240},{200,240}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-200,-240},{200,240}}),
        graphics={
        Rectangle(
          extent={{-190,90},{-170,70}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-210,80},{-146,50}},
          lineColor={238,46,47},
          fillColor={28,108,200},
          fillPattern=FillPattern.None,
          textString="Future: Adjust based on climate zone"),
        Text(
          extent={{22,78},{86,48}},
          lineColor={238,46,47},
          fillColor={28,108,200},
          fillPattern=FillPattern.None,
          textString="Future: Consider if havOccSen and havWinSen"),
        Text(
          extent={{112,106},{156,80}},
          lineColor={238,46,47},
          fillColor={28,108,200},
          fillPattern=FillPattern.None,
          textString="To Do: Add if hOut",
          textStyle={TextStyle.Bold})}));
end Controller;
