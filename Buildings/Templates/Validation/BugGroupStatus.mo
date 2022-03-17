within Buildings.Templates.Validation;
model BugGroupStatus
  extends Modelica.Icons.Example;
  parameter Integer nGro = 1;
  parameter Integer nZonGro[nGro] = fill(1, nGro);

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant zonOcc(k=true);
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uOcc(k=true);
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant tNexOcc(k=1);
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uCooTim(k=1);
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uWarTim(k=1);
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uOccHeaHig(k=true);
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uHigOccCoo(k=true);
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uUnoHeaHig(k=true);
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaSetOff(k=1);
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uEndSetBac(k=true);
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uHigUnoCoo(k=true);
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCooSetOff(k=1);
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uEndSetUp(k=true);
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZon(k=1);
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uWin(k=true);

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.GroupStatus zonGroSta[nGro](final
      numZon=nZonGro)
    "Evaluate zone group status"
    annotation (Placement(transformation(extent={{48,-44},{28,-4}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode opeModSel[nGro](final
      numZon=nZonGro)
    "Operation mode selection for each zone group"
    annotation (Placement(transformation(extent={{28,4},{48,36}})));
equation
  for ig in 1:nGro loop
    for izg in 1:nZonGro[ig] loop
        connect(zonOcc.y, zonGroSta[ig].zonOcc[izg]);
        connect(uOcc.y, zonGroSta[ig].uOcc[izg]);
        connect(tNexOcc.y, zonGroSta[ig].tNexOcc[izg]);
        connect(uCooTim.y, zonGroSta[ig].uCooTim[izg]);
        connect(uWarTim.y, zonGroSta[ig].uWarTim[izg]);
        connect(uOccHeaHig.y, zonGroSta[ig].uOccHeaHig[izg]);
        connect(uHigOccCoo.y, zonGroSta[ig].uHigOccCoo[izg]);
        connect(THeaSetOff.y, zonGroSta[ig].THeaSetOff[izg]);
        connect(uUnoHeaHig.y, zonGroSta[ig].uUnoHeaHig[izg]);
        connect(uEndSetBac.y, zonGroSta[ig].uEndSetBac[izg]);
        connect(TCooSetOff.y, zonGroSta[ig].TCooSetOff[izg]);
        connect(uHigUnoCoo.y, zonGroSta[ig].uHigUnoCoo[izg]);
        connect(uEndSetUp.y, zonGroSta[ig].uEndSetUp[izg]);
        connect(uWin.y, zonGroSta[ig].uWin[izg]);
        connect(TZon.y, zonGroSta[ig].TZon[izg]);
    end for;
  end for;

  connect(zonGroSta.uGroOcc,opeModSel.uOcc) annotation (Line(points={{26,-5},{16,
          -5},{16,34},{26,34}},              color={255,0,255}));
  connect(zonGroSta.nexOcc,opeModSel.tNexOcc) annotation (Line(points={{26,-7},{
          0,-7},{0,32},{26,32}},                  color={0,0,127}));
  connect(zonGroSta.yCooTim,opeModSel.maxCooDowTim) annotation (Line(points={{26,-11},
          {-10,-11},{-10,30},{26,30}},                 color={0,0,127}));
  connect(zonGroSta.yWarTim,opeModSel.maxWarUpTim) annotation (Line(points={{26,-13},
          {-6,-13},{-6,26},{26,26}},              color={0,0,127}));
  connect(zonGroSta.yOccHeaHig,opeModSel.uOccHeaHig) annotation (Line(points={{26,-17},
          {0,-17},{0,24},{26,24}},                      color={255,0,255}));
  connect(zonGroSta.yHigOccCoo,opeModSel.uHigOccCoo) annotation (Line(points={{26,-19},
          {0,-19},{0,28},{26,28}},                      color={255,0,255}));
  connect(zonGroSta.yColZon,opeModSel.totColZon) annotation (Line(points={{26,-22},
          {0,-22},{0,20},{26,20}},                color={255,127,0}));
  connect(zonGroSta.ySetBac,opeModSel.uSetBac) annotation (Line(points={{26,-24},
          {2,-24},{2,18},{26,18}},                color={255,0,255}));
  connect(zonGroSta.yEndSetBac,opeModSel.uEndSetBac) annotation (Line(points={{26,-26},
          {4,-26},{4,16},{26,16}},                      color={255,0,255}));
  connect(zonGroSta.TZonMax,opeModSel.TZonMax) annotation (Line(points={{26,-37},
          {6,-37},{6,14},{26,14}},                color={0,0,127}));
  connect(zonGroSta.TZonMin,opeModSel.TZonMin) annotation (Line(points={{26,-39},
          {8,-39},{8,12},{26,12}},                color={0,0,127}));
  connect(zonGroSta.yHotZon,opeModSel. totHotZon) annotation (Line(points={{26,-29},
          {12,-29},{12,10},{26,10}},              color={255,127,0}));
  connect(zonGroSta.ySetUp,opeModSel. uSetUp) annotation (Line(points={{26,-31},
          {12,-31},{12,8},{26,8}},                color={255,0,255}));
  connect(zonGroSta.yEndSetUp,opeModSel. uEndSetUp) annotation (Line(points={{26,-33},
          {14,-33},{14,6},{26,6}},                color={255,0,255}));
  connect(zonGroSta.yOpeWin,opeModSel. uOpeWin) annotation (Line(points={{26,-43},
          {-2,-43},{-2,22},{26,22}},         color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BugGroupStatus;
