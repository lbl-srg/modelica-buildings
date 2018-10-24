within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV;
block Controller "Single Zone AHU controller that composes subsequences for controlling fan speed, economizer, and supply air temperature"
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints
    modSetPoi(numZon=1)
    annotation (Placement(transformation(extent={{-160,178},{-140,198}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc
    "Time to next occupied period"
    annotation (Placement(transformation(extent={{-240,178},{-200,218}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[size(modSetPoi.TZon, 1)]
    "Measured zone temperatures"
    annotation (Placement(transformation(extent={{-240,138},{-200,178}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Current occupancy period, true if it is in occupant period"
    annotation (Placement(transformation(extent={{-240,98},{-200,138}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply
    setPoiVAV
    annotation (Placement(transformation(extent={{-20,178},{0,198}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID cooPI(controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
    annotation (Placement(transformation(extent={{-70,158},{-50,178}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID heaPI(controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
    annotation (Placement(transformation(extent={{-70,198},{-50,218}})));
  Buildings.Controls.OBC.CDL.Continuous.Average ave
    annotation (Placement(transformation(extent={{-110,178},{-90,198}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Controller
    conEco annotation (Placement(transformation(extent={{40,98},{60,118}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRet
    "Measured return air temperature"
    annotation (Placement(transformation(extent={{-240,60},{-200,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-240,20},{-200,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-240,-20},{-200,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput nOcc[size(outAirSetPoi.nOcc,
    1)] "Number of occupants"
    annotation (Placement(transformation(extent={{-240,-60},{-200,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSup
    "Volume flow of supply air"
    annotation (Placement(transformation(extent={{-238,-140},{-198,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin[size(outAirSetPoi.uWin,
    1)] "Window status, true if open, false if closed"
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
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.FanOnOff fanOnOff
    annotation (Placement(transformation(extent={{-20,140},{0,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-240,220},{-200,260}})));
equation
  connect(modSetPoi.tNexOcc, tNexOcc) annotation (Line(points={{-161,196},{
          -170,196},{-170,198},{-220,198}}, color={0,0,127}));
  connect(modSetPoi.TZon, TZon) annotation (Line(points={{-161,193},{-170,193},
          {-170,158},{-220,158}}, color={0,0,127}));
  connect(modSetPoi.uOcc, uOcc) annotation (Line(points={{-161,184.025},{-166,
          184.025},{-166,118},{-220,118}}, color={255,0,255}));
  connect(modSetPoi.TZonCooSet[1], cooPI.u_s) annotation (Line(points={{-139,
          195},{-120.5,195},{-120.5,168},{-72,168}}, color={0,0,127}));
  connect(TZon[1], cooPI.u_m) annotation (Line(points={{-220,158},{-170,158},
          {-170,150},{-60,150},{-60,156}}, color={0,0,127}));
  connect(cooPI.y, setPoiVAV.uCoo) annotation (Line(points={{-49,168},{-40,
          168},{-40,192},{-22,192}}, color={0,0,127}));
  connect(modSetPoi.TZonHeaSet[1], heaPI.u_s) annotation (Line(points={{-139,
          191},{-130,191},{-130,208},{-72,208}}, color={0,0,127}));
  connect(heaPI.u_m, cooPI.u_m) annotation (Line(points={{-60,196},{-60,186},
          {-80,186},{-80,150},{-60,150},{-60,156}}, color={0,0,127}));
  connect(heaPI.y, setPoiVAV.uHea) annotation (Line(points={{-49,208},{-40,
          208},{-40,196},{-22,196}}, color={0,0,127}));
  connect(ave.u2, modSetPoi.TZonHeaSet[1]) annotation (Line(points={{-112,182},
          {-118,182},{-118,191},{-139,191}}, color={0,0,127}));
  connect(ave.u1, modSetPoi.TZonCooSet[1]) annotation (Line(points={{-112,194},
          {-120,194},{-120,195},{-139,195}}, color={0,0,127}));
  connect(ave.y, setPoiVAV.TZonSet) annotation (Line(points={{-89,188.2},{-54,
          188.2},{-54,188},{-22,188}}, color={0,0,127}));
  connect(setPoiVAV.TZon, TZon[1]) annotation (Line(points={{-22,184},{-36,
          184},{-36,150},{-170,150},{-170,158},{-220,158}}, color={0,0,127}));
  connect(TRet, conEco.TOutCut) annotation (Line(points={{-220,80},{-130,80},
          {-130,118},{39,118}}, color={0,0,127}));
  connect(conEco.TSup, TSup) annotation (Line(points={{39,112},{-44,112},{-44,
          40},{-220,40}}, color={0,0,127}));
  connect(setPoiVAV.TSupHeaEco, conEco.THeaSupSet) annotation (Line(points={{
          1,194},{20,194},{20,110},{39,110}}, color={0,0,127}));
  connect(setPoiVAV.y, conEco.uSupFanSpe) annotation (Line(points={{1,182},{8,
          182},{8,106},{39,106}}, color={0,0,127}));
  connect(TMix, conEco.TMix) annotation (Line(points={{-220,0},{-40,0},{-40,
          104},{39,104}}, color={0,0,127}));
  connect(modSetPoi.yOpeMod, conEco.uOpeMod) annotation (Line(points={{-139,
          185},{-136,185},{-136,100},{39,100}}, color={255,127,0}));
  connect(setPoiVAV.TSupHeaEco, TSupHeaEco) annotation (Line(points={{1,194},
          {120,194},{120,240},{210,240}}, color={0,0,127}));
  connect(setPoiVAV.TSupCoo, TSupCoo) annotation (Line(points={{1,188},{126,
          188},{126,200},{210,200}}, color={0,0,127}));
  connect(setPoiVAV.y, yFan) annotation (Line(points={{1,182},{126,182},{126,
          160},{210,160}}, color={0,0,127}));
  connect(conEco.yRetDamPos, yRetDamPos) annotation (Line(points={{61,110},{
          140,110},{140,120},{210,120}}, color={0,0,127}));
  connect(conEco.yOutDamPos, yOutDamPos) annotation (Line(points={{61,106},{
          140,106},{140,80},{210,80}}, color={0,0,127}));
  connect(outAirSetPoi.nOcc, nOcc[1]) annotation (Line(points={{-1,88},{-36,
          88},{-36,-40},{-220,-40}}, color={0,0,127}));
  connect(outAirSetPoi.TZon, cooPI.u_m) annotation (Line(points={{-1,84},{
          -170,84},{-170,150},{-60,150},{-60,156}}, color={0,0,127}));
  connect(outAirSetPoi.TDis, TSup) annotation (Line(points={{-1,80},{-44,80},
          {-44,40},{-220,40}}, color={0,0,127}));
  connect(outAirSetPoi.uWin, uWin[1]) annotation (Line(points={{-1,76},{-30,
          76},{-30,-80},{-220,-80}}, color={255,0,255}));
  connect(outAirSetPoi.uOpeMod, conEco.uOpeMod) annotation (Line(points={{-1,
          72},{-136,72},{-136,100},{39,100}}, color={255,127,0}));
  connect(conEco.VOutMinSet_flow, outAirSetPoi.VOutMinSet_flow) annotation (
      Line(points={{39,108},{28,108},{28,80},{21,80}}, color={0,0,127}));
  connect(fanOnOff.uOpeMod, conEco.uOpeMod) annotation (Line(points={{-22,150},
          {-26,150},{-26,100},{39,100}}, color={255,127,0}));
  connect(fanOnOff.ySupFan, outAirSetPoi.uSupFan) annotation (Line(points={{1,
          150},{6,150},{6,96},{-8,96},{-8,74},{-1,74}}, color={255,0,255}));
  connect(conEco.uSupFan, outAirSetPoi.uSupFan) annotation (Line(points={{39,
          102},{6,102},{6,96},{-8,96},{-8,74},{-1,74}}, color={255,0,255}));
  connect(TOut, setPoiVAV.TOut) annotation (Line(points={{-220,240},{-30,240},{
          -30,180},{-22,180}}, color={0,0,127}));
  connect(conEco.TOut, setPoiVAV.TOut) annotation (Line(points={{39,120},{-30,
          120},{-30,180},{-22,180}}, color={0,0,127}));
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
          extent={{-100,128},{-80,108}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,118},{-56,88}},
          lineColor={238,46,47},
          fillColor={28,108,200},
          fillPattern=FillPattern.None,
          textString="Future: Adjust based on climate zone"),
        Text(
          extent={{-174,188},{-110,158}},
          lineColor={238,46,47},
          fillColor={28,108,200},
          fillPattern=FillPattern.None,
          textString="TODO: remove numZon(min=2)",
          textStyle={TextStyle.Bold}),
        Text(
          extent={{-18,78},{46,48}},
          lineColor={238,46,47},
          fillColor={28,108,200},
          fillPattern=FillPattern.None,
          textString="Future: Consider if havOccSen and havWinSen"),
        Text(
          extent={{32,106},{76,80}},
          lineColor={238,46,47},
          fillColor={28,108,200},
          fillPattern=FillPattern.None,
          textString="To Do: Add if hOut",
          textStyle={TextStyle.Bold})}));
end Controller;
