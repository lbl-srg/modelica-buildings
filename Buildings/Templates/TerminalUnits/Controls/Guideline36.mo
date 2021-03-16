within Buildings.Templates.TerminalUnits.Controls;
block Guideline36
  extends Buildings.Templates.Interfaces.ControllerTerminalUnit;

  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller terUniCon
    "Terminal unit controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME(k=1)
    "nOcc should be Boolean"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures
    TZonSet
    "Compute zone temperature set points"
    annotation (Placement(transformation(extent={{-60,-54},{-40,-26}})));
  BaseClasses.Connectors.SubBusOutput busOut annotation (Placement(
        transformation(extent={{30,0},{70,40}}), iconTransformation(extent={{
            -442,-118},{-422,-98}})));
  BaseClasses.Connectors.SubBusSoftware busSof annotation (Placement(
        transformation(extent={{30,-40},{70,0}}), iconTransformation(extent={{
            -446,-20},{-426,0}})));
equation
  connect(busTer.inp.ppmCO2, terUniCon.ppmCO2) annotation (Line(
      points={{-200.1,0.1},{-20,0.1},{-20,6},{-12,6}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.uWin, terUniCon.uWin) annotation (Line(
      points={{-200.1,0.1},{-20,0.1},{-20,2},{-12,2}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.TZon, terUniCon.TZon) annotation (Line(
      points={{-200.1,0.1},{-56,0.1},{-56,0},{-12,0}},
      color={255,204,51},
      thickness=0.5));
  connect(FIXME.y, terUniCon.nOcc) annotation (Line(points={{-38,30},{-30,30},{-30,
          4},{-12,4}}, color={0,0,127}));
  connect(busTer.inp.VDis_flow, terUniCon.VDis_flow) annotation (Line(
      points={{-200.1,0.1},{-20,0.1},{-20,-2},{-12,-2}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.yDam_actual, terUniCon.yDam_actual) annotation (Line(
      points={{-200.1,0.1},{-20,0.1},{-20,-4},{-12,-4}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.TDis, terUniCon.TDis) annotation (Line(
      points={{-200.1,0.1},{-20,0.1},{-20,-6},{-12,-6}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.TSup, terUniCon.TSupAHU) annotation (Line(
      points={{-200.1,0.1},{-20,0.1},{-20,-8},{-12,-8}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.sof.uOpeMod, terUniCon.uOpeMod) annotation (Line(
      points={{-200.1,0.1},{-20,0.1},{-20,-10},{-12,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(TZonSet.TZonCooSet, terUniCon.TZonCooSet) annotation (Line(points={{-38,
          -32},{-22,-32},{-22,8},{-12,8}}, color={0,0,127}));
  connect(TZonSet.TZonHeaSet, terUniCon.TZonHeaSet) annotation (Line(points={{-38,
          -40},{-24,-40},{-24,10},{-12,10}}, color={0,0,127}));
  connect(busTer.sof.uOpeMod, TZonSet.uOpeMod) annotation (Line(
      points={{-200.1,0.1},{-80,0.1},{-80,-27},{-62,-27}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.sof.TZonCooSetOcc, TZonSet.TZonCooSetOcc) annotation (Line(
      points={{-200.1,0.1},{-80,0.1},{-80,-31},{-62,-31}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.sof.TZonCooSetUno, TZonSet.TZonCooSetUno) annotation (Line(
      points={{-200.1,0.1},{-80,0.1},{-80,-33},{-62,-33}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.sof.TZonHeaSetOcc, TZonSet.TZonHeaSetOcc) annotation (Line(
      points={{-200.1,0.1},{-80,0.1},{-80,-36},{-62,-36}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.sof.TZonHeaSetUno, TZonSet.TZonHeaSetUno) annotation (Line(
      points={{-200.1,0.1},{-80,0.1},{-80,-38},{-62,-38}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.sof.dTSetAdj, TZonSet.setAdj) annotation (Line(
      points={{-200.1,0.1},{-80,0.1},{-80,-41},{-62,-41}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.sof.dTHeaSetAdj, TZonSet.heaSetAdj) annotation (Line(
      points={{-200.1,0.1},{-80,0.1},{-80,-43},{-62,-43}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.sof.uCooDemLimLev, TZonSet.uCooDemLimLev) annotation (Line(
      points={{-200.1,0.1},{-80,0.1},{-80,-46},{-62,-46}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.sof.uHeaDemLimLev, TZonSet.uHeaDemLimLev) annotation (Line(
      points={{-200.1,0.1},{-80,0.1},{-80,-48},{-62,-48}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.uOcc, TZonSet.uOccSen) annotation (Line(
      points={{-200.1,0.1},{-80,0.1},{-80,-51},{-62,-51}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.inp.uWin, TZonSet.uWinSta) annotation (Line(
      points={{-200.1,0.1},{-80,0.1},{-80,-53},{-62,-53}},
      color={255,204,51},
      thickness=0.5));
  connect(terUniCon.yDam, busOut.yDam)
    annotation (Line(points={{12,6},{16,6},{16,20},{50,20}}, color={0,0,127}));
  connect(terUniCon.yVal, busOut.yVal) annotation (Line(points={{12,1},{20,1},{
          20,16},{50,16},{50,20}}, color={0,0,127}));
  connect(terUniCon.yZonTemResReq, busSof.yZonTemResReq) annotation (Line(
        points={{12,-4},{20,-4},{20,-20},{50,-20}}, color={255,127,0}));
  connect(terUniCon.yZonPreResReq, busSof.yZonPreResReq) annotation (Line(
        points={{12,-8},{16,-8},{16,-24},{50,-24},{50,-20}}, color={255,127,0}));
  connect(busOut, busTer.out) annotation (Line(
      points={{50,20},{80,20},{80,60},{-180,60},{-180,0.1},{-200.1,0.1}},
      color={255,204,51},
      thickness=0.5));
  connect(busSof, busTer.sof) annotation (Line(
      points={{50,-20},{80,-20},{80,-60},{-180,-60},{-180,0.1},{-200.1,0.1}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Guideline36;
