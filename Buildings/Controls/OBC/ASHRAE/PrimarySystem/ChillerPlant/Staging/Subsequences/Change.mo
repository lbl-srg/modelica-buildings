within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Change "Calculates the chiller stage signal"

  parameter Integer nSta = 3
    "Number of chiller stages";

  parameter Integer nChi = 2
    "Number of chillers";

  parameter Integer staMat[nSta, nChi] = {{1,0},{0,1},{1,1}}
    "Staging matrix with stage as row index and chiller as column index";

  parameter Modelica.SIunits.Power chiDesCap[nChi]
    "Design chiller capacities vector";

  parameter Modelica.SIunits.Power chiMinCap[nChi]
    "Chiller minimum cycling loads vector";

  parameter Integer chiTyp[nChi]={
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.variableSpeedCentrifugal}
    "Chiller type. Recommended staging order: positive displacement, variable speed centrifugal, constant speed centrifugal";

  parameter Modelica.SIunits.Time avePer = 300
  "Time period for the rolling average";

  parameter Modelica.SIunits.Time holPer = 900
  "Time period for the value hold at stage change";






  parameter Boolean anyVsdCen = true
    "Plant contains at least one variable speed centrifugal chiller";

  parameter Real posDisMult(
    final unit = "1",
    final min = 0,
    final max = 1)=0.8
    "Positive displacement chiller type staging multiplier";

  parameter Real conSpeCenMult(
    final unit = "1",
    final min = 0,
    final max = 1)=0.9
    "Constant speed centrifugal chiller type staging multiplier";

  parameter Real varSpeStaMin(
    final unit = "1",
    final min = 0.1,
    final max = 1)=0.45
    "Minimum stage up or down part load ratio for variable speed centrifugal stage types"
    annotation(Evaluate=true, Dialog(enable=anyVsdCen));

  parameter Real varSpeStaMax(
    final unit = "1",
    final min = varSpeStaMin,
    final max = 1)=0.9
    "Maximum stage up or down part load ratio for variable speed centrifugal stage types"
    annotation(Evaluate=true, Dialog(enable=anyVsdCen));






  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiAva[nChi]
    "Chiller availability status vector"
    annotation (Placement(transformation(extent={{-460,250},{-420,290}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Configurator conf(
    final nSta = nSta,
    final nChi = nChi,
    final chiDesCap = chiDesCap,
    final chiMinCap = chiMinCap,
    final staMat = staMat)
    "Configures chiller staging variables such as capacity and stage type vectors"
    annotation (Placement(transformation(extent={{-400,260},{-380,280}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Status sta(
    nSta=nSta,
    nChi=nChi,
    staMat=staMat)
    annotation (Placement(transformation(extent={{-340,220},{-320,240}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.CapacityRequirement capReq(
    final avePer = avePer,
    final holPer = holPer)
    annotation (Placement(transformation(extent={{-340,180},{-320,200}})));

  CDL.Interfaces.BooleanInput                        chaPro
    "Stage change process status, true = on, false = off"
    annotation (Placement(transformation(extent={{-460,210},{-420,250}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  CDL.Interfaces.RealInput                        TChiWatSupSet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-460,180},{-420,220}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  CDL.Interfaces.RealInput                        TChiWatRet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-460,150},{-420,190}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  CDL.Interfaces.RealInput                        VChiWat_flow(final quantity="VolumeFlowRate",
      final unit="m3/s")
                       "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-460,120},{-420,160}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Capacities cap(nSta=nSta)
    annotation (Placement(transformation(extent={{-300,260},{-280,280}})));
  PartLoadRatios PLRs(
    anyVsdCen=anyVsdCen,
    nSta=nSta,
    posDisMult=posDisMult,
    conSpeCenMult=conSpeCenMult,
    varSpeStaMin=varSpeStaMin,
    varSpeStaMax=varSpeStaMax)
    annotation (Placement(transformation(extent={{-220,204},{-200,224}})));
equation
  connect(uChiAva, conf.uChiAva)
    annotation (Line(points={{-440,270},{-402,270}}, color={255,0,255}));
  connect(conf.yAva, sta.uAva) annotation (Line(points={{-378,266},{-360,266},{-360,
          224},{-342,224}}, color={255,0,255}));
  connect(chaPro, capReq.chaPro) annotation (Line(points={{-440,230},{-380,230},
          {-380,198},{-342,198}}, color={255,0,255}));
  connect(TChiWatSupSet, capReq.TChiWatSupSet) annotation (Line(points={{-440,200},
          {-390,200},{-390,193},{-342,193}}, color={0,0,127}));
  connect(TChiWatRet, capReq.TChiWatRet) annotation (Line(points={{-440,170},{-390,
          170},{-390,187},{-342,187}}, color={0,0,127}));
  connect(VChiWat_flow, capReq.VChiWat_flow) annotation (Line(points={{-440,140},
          {-360,140},{-360,182},{-342,182}}, color={0,0,127}));
  connect(conf.yDesCap, cap.uDesCap) annotation (Line(points={{-378,278},{-340,278},
          {-340,279},{-302,279}}, color={0,0,127}));
  connect(conf.yMinCap, cap.uMinCap) annotation (Line(points={{-378,274},{-340,274},
          {-340,276},{-302,276}}, color={0,0,127}));
  connect(sta.y, cap.u) annotation (Line(points={{-318,227},{-312,227},{-312,273},
          {-302,273}}, color={255,127,0}));
  connect(sta.yUp, cap.uUp) annotation (Line(points={{-318,224},{-310,224},{-310,
          270},{-302,270}}, color={255,127,0}));
  connect(sta.yDown, cap.uDown) annotation (Line(points={{-318,221},{-308,221},{
          -308,267},{-302,267}}, color={255,127,0}));
  connect(sta.yHig, cap.uHig) annotation (Line(points={{-318,236},{-306,236},{-306,
          264},{-302,264}}, color={255,0,255}));
  connect(sta.yLow, cap.uLow) annotation (Line(points={{-318,233},{-304,233},{-304,
          261},{-302,261}}, color={255,0,255}));
  annotation (defaultComponentName = "staCha",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}), Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-420,-300},{420,300}})),
Documentation(info="<html>
<p>
Outputs the chiller stage change signal

fixme: elaborate

</p>
</html>",
revisions="<html>
<ul>
<li>
January xx, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Change;
