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

  parameter Boolean hasWSE = true
    "true = plant has a WSE, false = plant does not have WSE";

  parameter Modelica.SIunits.Time delayStaCha = 15*60
    "Delay stage change";

  parameter Modelica.SIunits.Time shortDelay = 10*60
    "Short stage 0 to 1 delay";

  parameter Modelica.SIunits.Time longDelay = 20*60
    "Long stage 0 to 1 delay";

  parameter Modelica.SIunits.TemperatureDifference smallTDif = 1
    "Offset between the chilled water supply temperature and its setpoint";

  parameter Modelica.SIunits.TemperatureDifference largeTDif = 2
    "Offset between the chilled water supply temperature and its setpoint";

  parameter Modelica.SIunits.TemperatureDifference TDif = 1
    "Offset between the chilled water supply temperature and its setpoint";

  parameter Modelica.SIunits.PressureDifference dpDif = 2 * 6895
    "Offset between the chilled water pump Diferential static pressure and its setpoint";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiAva[nChi]
    "Chiller availability status vector"
    annotation (Placement(transformation(extent={{-460,30},{-420,70}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Configurator conf(
    final nSta = nSta,
    final nChi = nChi,
    final chiDesCap = chiDesCap,
    final chiMinCap = chiMinCap,
    final staMat = staMat)
    "Configures chiller staging variables such as capacity and stage type vectors"
    annotation (Placement(transformation(extent={{-400,40},{-380,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Status sta(
    nSta=nSta,
    nChi=nChi,
    staMat=staMat)
    annotation (Placement(transformation(extent={{-340,0},{-320,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.CapacityRequirement capReq(
    final avePer = avePer,
    final holPer = holPer)
    annotation (Placement(transformation(extent={{-340,240},{-320,260}})));

  CDL.Interfaces.BooleanInput                        chaPro
    "Stage change process status, true = on, false = off"
    annotation (Placement(transformation(extent={{-460,60},{-420,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  CDL.Interfaces.RealInput                        TChiWatSupSet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-460,260},{-420,300}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  CDL.Interfaces.RealInput                        TChiWatRet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-460,230},{-420,270}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  CDL.Interfaces.RealInput                        VChiWat_flow(final quantity="VolumeFlowRate",
      final unit="m3/s")
                       "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-460,200},{-420,240}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Capacities cap(nSta=nSta)
    annotation (Placement(transformation(extent={{-290,40},{-270,60}})));
  PartLoadRatios PLRs(
    anyVsdCen=anyVsdCen,
    nSta=nSta,
    posDisMult=posDisMult,
    conSpeCenMult=conSpeCenMult,
    varSpeStaMin=varSpeStaMin,
    varSpeStaMax=varSpeStaMax)
    annotation (Placement(transformation(extent={{-200,22},{-180,42}})));
  CDL.Interfaces.RealInput                        uLifMin(final unit="K",
      final quantity="ThermodynamicTemperature") if
                                                  anyVsdCen
    "Minimum chiller lift"
    annotation (Placement(transformation(extent={{-460,100},{-420,140}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  CDL.Interfaces.RealInput                        uLif(final unit="K", final
      quantity="ThermodynamicTemperature") if     anyVsdCen
    "Chiller lift"
    annotation (Placement(transformation(extent={{-460,160},{-420,200}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  CDL.Interfaces.RealInput                        uLifMax(final unit="K",
      final quantity="ThermodynamicTemperature") if
                                                  anyVsdCen
    "Maximum chiller lift"
    annotation (Placement(transformation(extent={{-460,130},{-420,170}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Up staUp(
    hasWSE=hasWSE,
    delayStaCha=delayStaCha,
    shortDelay=shortDelay,
    longDelay=longDelay,
    smallTDif=smallTDif,
    largeTDif=largeTDif,
    TDif=TDif,
    dpDif=dpDif)
    annotation (Placement(transformation(extent={{-64,184},{-44,204}})));
equation
  connect(uChiAva, conf.uChiAva)
    annotation (Line(points={{-440,50},{-402,50}},   color={255,0,255}));
  connect(conf.yAva, sta.uAva) annotation (Line(points={{-378,42},{-360,42},{-360,
          4},{-342,4}},     color={255,0,255}));
  connect(chaPro, capReq.chaPro) annotation (Line(points={{-440,80},{-380,80},{
          -380,242},{-342,242}},  color={255,0,255}));
  connect(TChiWatSupSet, capReq.TChiWatSupSet) annotation (Line(points={{-440,
          280},{-390,280},{-390,259},{-342,259}},
                                             color={0,0,127}));
  connect(TChiWatRet, capReq.TChiWatRet) annotation (Line(points={{-440,250},{
          -390,250},{-390,254},{-342,254}},
                                       color={0,0,127}));
  connect(VChiWat_flow, capReq.VChiWat_flow) annotation (Line(points={{-440,220},
          {-360,220},{-360,249},{-342,249}}, color={0,0,127}));
  connect(conf.yDesCap, cap.uDesCap) annotation (Line(points={{-378,58},{-340,58},
          {-340,59},{-292,59}},   color={0,0,127}));
  connect(conf.yMinCap, cap.uMinCap) annotation (Line(points={{-378,54},{-340,54},
          {-340,56},{-292,56}},   color={0,0,127}));
  connect(sta.y, cap.u) annotation (Line(points={{-318,19},{-308,19},{-308,53},{
          -292,53}},   color={255,127,0}));
  connect(sta.yUp, cap.uUp) annotation (Line(points={{-318,16},{-304,16},{-304,50},
          {-292,50}},       color={255,127,0}));
  connect(sta.yDown, cap.uDown) annotation (Line(points={{-318,13},{-300,13},{-300,
          47},{-292,47}},        color={255,127,0}));
  connect(sta.yHig, cap.uHig) annotation (Line(points={{-318,7},{-298,7},{-298,44},
          {-292,44}},       color={255,0,255}));
  connect(capReq.y, PLRs.uCapReq) annotation (Line(points={{-318,250},{-220,250},
          {-220,46},{-202,46}},   color={0,0,127}));
  connect(cap.yDes, PLRs.uCapDes) annotation (Line(points={{-268,58},{-252,58},{
          -252,44},{-202,44}},    color={0,0,127}));
  connect(cap.yUpDes, PLRs.uUpCapDes) annotation (Line(points={{-268,54},{-254,54},
          {-254,42},{-202,42}},        color={0,0,127}));
  connect(cap.yDowDes, PLRs.uDowCapDes) annotation (Line(points={{-268,50},{-256,
          50},{-256,40},{-202,40}},    color={0,0,127}));
  connect(cap.yMin, PLRs.uCapMin) annotation (Line(points={{-268,46},{-258,46},{
          -258,37},{-202,37}},    color={0,0,127}));
  connect(cap.yUpMin, PLRs.uUpCapMin) annotation (Line(points={{-268,42},{-260,42},
          {-260,35},{-202,35}},        color={0,0,127}));
  connect(uLif, PLRs.uLif) annotation (Line(points={{-440,180},{-226,180},{-226,
          32},{-202,32}},   color={0,0,127}));
  connect(uLifMax, PLRs.uLifMax) annotation (Line(points={{-440,150},{-232,150},
          {-232,30},{-202,30}},
                            color={0,0,127}));
  connect(uLifMin, PLRs.uLifMin) annotation (Line(points={{-440,120},{-240,120},
          {-240,28},{-202,28}},
                            color={0,0,127}));
  connect(conf.yTyp, PLRs.uTyp) annotation (Line(points={{-378,46},{-340,46},{-340,
          28},{-270,28},{-270,24},{-202,24}},          color={255,127,0}));
  connect(sta.y, PLRs.u) annotation (Line(points={{-318,19},{-270,19},{-270,20},
          {-202,20}},  color={255,127,0}));
  connect(sta.yUp, PLRs.uUp) annotation (Line(points={{-318,16},{-264,16},{-264,
          18},{-202,18}},   color={255,127,0}));
  connect(sta.yDown, PLRs.uDown) annotation (Line(points={{-318,13},{-260,13},{-260,
          16},{-202,16}},         color={255,127,0}));
  connect(sta.yLow, cap.uLow) annotation (Line(points={{-318,4},{-296,4},{-296,41},
          {-292,41}}, color={255,0,255}));
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
