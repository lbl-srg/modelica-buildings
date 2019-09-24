within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes;
block Down
  "Sequence for controlling devices when there is a stage-down command"

  parameter Integer nChi=2 "Total number of chillers in the plant";
  parameter Integer nSta=3
    "Total stages, zero stage should be seem as one stage";
  parameter Boolean haveWSE=true
    "Flag of waterside economizer: true=have WSE, false=no WSE";
  parameter Boolean havePonChi=false
    "Flag to indicate if there is pony chiller"
    annotation (Dialog(tab="Pony chiller"));
  parameter Integer upOnOffSta=0
    "Index of stage when staging up to the stage, need to turn off small chiller. When no stage chang need the change, set it to zeros"
    annotation (Dialog(tab="Pony chiller", enable=havePonChi));
  parameter Integer dowOnOffSta=0
    "Index of stage when staging down to the stage, need to turn on small chiller. When no stage chang need the change, set it to zeros"
    annotation (Dialog(tab="Pony chiller", enable=havePonChi));
  parameter Real chiDemRedFac=0.75
    "Demand reducing factor of current operating chillers"
    annotation (Dialog(group="Chiller demand limit"));
  parameter Modelica.SIunits.Time holChiDemTim=300
    "Time of actual demand less than center percentage of currnet load"
    annotation (Dialog(group="Chiller demand limit"));
  parameter Modelica.SIunits.Time chaChiWatIsoTim=300
    "Time to slowly change isolation valve"
    annotation (Dialog(group="Chilled water isolation valve"));
  parameter Modelica.SIunits.Time waiTim=30
    "Waiting time after enabling next head pressure control"
    annotation (Dialog(group="Head pressure control"));
  parameter Boolean isHeadered=true
    "Flag of headered condenser water pumps design: true=headered, false=dedicated"
    annotation (Dialog(group="Enable condenser water pump"));
  parameter Real chiNum[nSta]={0,1,2}
    "Total number of operating chillers at each stage"
    annotation (Dialog(group="Enable condenser water pump"));
  parameter Real uLow=0.005 "if y=true and u<uLow, switch to y=false"
    annotation (Dialog(group="Enable condenser water pump"));
  parameter Real uHigh=0.015 "if y=false and u>uHigh, switch to y=true"
    annotation (Dialog(group="Enable condenser water pump"));
  parameter Modelica.SIunits.VolumeFlowRate minFloSet[nSta]={0,0.0089,0.0177}
    "Minimum flow rate at each chiller stage"
    annotation (Dialog(group="Reset minimum bypass"));
  parameter Modelica.SIunits.Time aftByPasSetTim=60
    annotation (Dialog(group="Reset minimum bypass"));
  parameter Modelica.SIunits.VolumeFlowRate minFloDif=0.01
    "Minimum flow rate difference to check if bybass flow achieves setpoint"
    annotation (Dialog(group="Reset minimum bypass"));
  parameter Modelica.SIunits.Time byPasSetTim=300
    annotation (Dialog(group="Reset minimum bypass"));
  parameter Modelica.SIunits.Time proOnTim=300
    "Enabled chiller operation time to indicate if it is proven on"
    annotation (Dialog(group="Disable last chiller"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiPri[nChi]
    "Chiller enabling priority"
    annotation (Placement(transformation(extent={{-260,320},{-220,360}}),
      iconTransformation(extent={{-240,200},{-200,240}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow
    "Stage down status: true=stage-down"
    annotation (Placement(transformation(extent={{-260,360},{-220,400}}),
      iconTransformation(extent={{-240,160},{-200,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiLoa[nChi](
    each final quantity="HeatFlowRate",
    each final unit="W")
    "Current chiller load"
    annotation (Placement(transformation(extent={{-260,240},{-220,280}}),
      iconTransformation(extent={{-240,120},{-200,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
    annotation (Placement(transformation(extent={{-260,210},{-220,250}}),
      iconTransformation(extent={{-240,80},{-200,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VBypas_flow(
    final unit="m3/s")
    "Measured bypass flow rate"
    annotation (Placement(transformation(extent={{-260,180},{-220,220}}),
      iconTransformation(extent={{-240,40},{-200,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta
    "Current stage index"
    annotation (Placement(transformation(extent={{-260,150},{-220,190}}),
      iconTransformation(extent={{-240,0},{-200,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiHeaCon[nChi]
    "Chillers head pressure control status"
    annotation (Placement(transformation(extent={{-260,120},{-220,160}}),
      iconTransformation(extent={{-240,-40},{-200,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[nChi](
    each final min=0,
    each final max=1,
    each final unit="1")
    "Chilled water isolation valve position"
    annotation (Placement(transformation(extent={{-260,90},{-220,130}}),
      iconTransformation(extent={{-240,-80},{-200,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatReq[nChi]
    "Chilled water requst status for each chiller"
    annotation (Placement(transformation(extent={{-260,-30},{-220,10}}),
      iconTransformation(extent={{-240,-120},{-200,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatReq[nChi]
    "Condenser water requst status for each chiller"
    annotation (Placement(transformation(extent={{-260,-150},{-220,-110}}),
      iconTransformation(extent={{-240,-160},{-200,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE
    "Water side economizer status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-260,-300},{-220,-260}}),
      iconTransformation(extent={{-240,-200},{-200,-160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe(
    each final min=0,
    each final max=1,
    each final unit="1")
    "Current condenser water pump speed"
    annotation (Placement(transformation(extent={{-260,-330},{-220,-290}}),
      iconTransformation(extent={{-240,-240},{-200,-200}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Indicate stage-down status: true=in stage-down process"
    annotation (Placement(transformation(extent={{320,370},{340,390}}),
      iconTransformation(extent={{200,180},{220,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiDem[nChi](
    each final quantity="HeatFlowRate",
    each final unit="W")
    "Chiller demand setpoint"
    annotation (Placement(transformation(extent={{320,250},{340,270}}),
      iconTransformation(extent={{200,140},{220,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chiller enabling status"
    annotation (Placement(transformation(extent={{320,210},{340,230}}),
      iconTransformation(extent={{200,100},{220,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatIsoVal[nChi](
    each final min=0,
    each final max=1,
    each final unit="1")
    "Chiller chilled water isolation valve position"
    annotation (Placement(transformation(extent={{320,50},{340,70}}),
      iconTransformation(extent={{200,50},{220,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiHeaCon[nChi]
    "Chiller head pressure control enabling status"
    annotation (Placement(transformation(extent={{320,-110},{340,-90}}),
      iconTransformation(extent={{200,10},{220,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTowStaDow
    "Tower stage down status: true=stage down cooling tower"
    annotation (Placement(transformation(extent={{320,-150},{340,-130}}),
      iconTransformation(extent={{200,-40},{220,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaPum
    "Lead pump status"
    annotation (Placement(transformation(extent={{320,-170},{340,-150}}),
      iconTransformation(extent={{200,-80},{220,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatPumSpeSet(
    each final min=0,
    each final max=1,
    each final unit="1")
    "Condenser water pump speed"
    annotation (Placement(transformation(extent={{320,-200},{340,-180}}),
      iconTransformation(extent={{200,-120},{220,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yConWatPumNum
    "Number of operating condenser water pumps"
    annotation (Placement(transformation(extent={{320,-230},{340,-210}}),
      iconTransformation(extent={{200,-160},{220,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatBypSet(
    final unit="m3/s")
    "Chilled water minimum flow bypass setpoint"
    annotation (Placement(transformation(extent={{320,-340},{340,-320}}),
      iconTransformation(extent={{200,-200},{220,-180}})));

protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.NextChiller
    nexChi(
    final nChi=nChi,
    final havePonChi=havePonChi,
    final upOnOffSta=upOnOffSta,
    final dowOnOffSta=dowOnOffSta) "Identify next enabling chiller"
    annotation (Placement(transformation(extent={{20,280},{40,300}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DownStart
    staDow(
    final nChi=nChi,
    final nSta=nSta,
    final chiDemRedFac=chiDemRedFac,
    final holChiDemTim=holChiDemTim,
    final minFloSet=minFloSet,
    final aftByPasSetTim=aftByPasSetTim,
    final minFloDif=minFloDif,
    final byPasSetTim=byPasSetTim,
    final waiTim=waiTim,
    final chaChiWatIsoTim=chaChiWatIsoTim,
    final proOnTim=proOnTim) "Start stage-down process"
    annotation (Placement(transformation(extent={{120,220},{140,240}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(final k=false)
    "False constant"
    annotation (Placement(transformation(extent={{-100,310},{-80,330}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor curDisChi(final nin=nChi)
    "Current disabling chiller"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold lesEquThr(
    final threshold=0.5)
    "Convert real input to boolean output"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal
    disChiIsoVal(
    final nChi=nChi,
    final chaChiWatIsoTim=chaChiWatIsoTim,
    final iniValPos=1,
    final endValPos=0) "Disable isolation valve of the chiller being disabled"
    annotation (Placement(transformation(extent={{260,50},{280,70}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi2 "Logical switch"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{200,10},{220,30}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep4(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi[nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{200,70},{220,90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-180,-140},{-160,-120}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor curDisChi1(final nin=nChi)
    "Current disabling chiller"
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold lesEquThr1(
    final threshold=0.5)
    "Check if the disabled chiller is not requiring condenser water"
    annotation (Placement(transformation(extent={{20,-140},{40,-120}})));
  Buildings.Controls.OBC.CDL.Logical.And3 and5 "Logical and"
    annotation (Placement(transformation(extent={{100,-140},{120,-120}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.HeadControl
    disHeaCon(
    final nChi=nChi,
    final thrTimEnb=0,
    final waiTim=0,
    final heaStaCha=false)
    "Disable head pressure control of the chiller being disabled"
    annotation (Placement(transformation(extent={{260,-110},{280,-90}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi [nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{200,-80},{220,-60}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableCWPump
    enaNexCWP
    "Identify correct stage number for enabling next condenser water pump"
    annotation (Placement(transformation(extent={{160,-200},{180,-180}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller
    conWatPumCon(
    final isHeadered=isHeadered,
    final haveWSE=haveWSE,
    final nSta=nSta,
    final chiNum=chiNum,
    final uLow=uLow,
    final uHigh=uHigh)
    "Enabling next condenser water pump or change pump speed"
    annotation (Placement(transformation(extent={{220,-220},{240,-200}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr  mulOr(final nu=nChi) "Multiple or"
    annotation (Placement(transformation(extent={{-20,-230},{0,-210}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(final nu=nChi) "Multiple or"
    annotation (Placement(transformation(extent={{-20,-260},{0,-240}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences.FlowSetpoint
    minBypSet(
    final nSta=nSta,
    final byPasSetTim=byPasSetTim,
    final minFloSet=minFloSet) "Reset minimum bypass flow setpoint"
    annotation (Placement(transformation(extent={{260,-340},{280,-320}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-180,370},{-160,390}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{-120,370},{-100,390}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ResetMinBypass
    minBypSet1(
    final aftByPasSetTim=aftByPasSetTim,
    final minFloDif=minFloDif)
    "Check if minium bypass has been reset"
    annotation (Placement(transformation(extent={{260,-380},{280,-360}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{260,-270},{280,-250}})));

equation
  connect(uSta, staDow.uSta) annotation (Line(points={{-240,170},{-120,170},{
          -120,230},{118,230}},  color={255,127,0}));
  connect(nexChi.uChiPri, uChiPri) annotation (Line(points={{18,298},{-140,298},
          {-140,340},{-240,340}},      color={255,127,0}));
  connect(uChi, nexChi.uChiEna) annotation (Line(points={{-240,230},{-140,230},{
          -140,294},{18,294}},    color={255,0,255}));
  connect(con.y, nexChi.uStaUp) annotation (Line(points={{-78,320},{-60,320},{
          -60,290},{18,290}},     color={255,0,255}));
  connect(uSta, nexChi.uChiSta) annotation (Line(points={{-240,170},{-120,170},
          {-120,286},{18,286}}, color={255,127,0}));
  connect(nexChi.yOnOff, staDow.uOnOff) annotation (Line(points={{41,290},{60,
          290},{60,229},{118,229}},         color={255,0,255}));
  connect(nexChi.yEnaSmaChi, staDow.nexEnaChi) annotation (Line(points={{41,281},
          {90,281},{90,227},{118,227}}, color={255,127,0}));
  connect(staDow.uChiHeaCon, uChiHeaCon) annotation (Line(points={{118,225},{
          -40,225},{-40,140},{-240,140}},   color={255,0,255}));
  connect(staDow.uChiWatIsoVal, uChiWatIsoVal) annotation (Line(points={{118,223},
          {0,223},{0,110},{-240,110}},            color={0,0,127}));
  connect(nexChi.yLasDisChi, staDow.nexDisChi) annotation (Line(points={{41,286},
          {80,286},{80,221},{118,221}}, color={255,127,0}));
  connect(uChiWatReq, booToRea1.u)
    annotation (Line(points={{-240,-10},{-182,-10}}, color={255,0,255}));
  connect(booToRea1.y, curDisChi.u)
    annotation (Line(points={{-158,-10},{-22,-10}},  color={0,0,127}));
  connect(curDisChi.y, lesEquThr.u)
    annotation (Line(points={{2,-10},{18,-10}},      color={0,0,127}));
  connect(nexChi.yOnOff, logSwi2.u2) annotation (Line(points={{41,290},{60,290},
          {60,20},{98,20}},           color={255,0,255}));
  connect(staDow.yReaDemLim, and4.u1) annotation (Line(points={{142,221},{152,
          221},{152,100},{0,100},{0,30},{18,30}},           color={255,0,255}));
  connect(and4.y, logSwi2.u1) annotation (Line(points={{42,30},{90,30},{90,28},{
          98,28}},             color={255,0,255}));
  connect(nexChi.yLasDisChi, curDisChi.index) annotation (Line(points={{41,286},
          {80,286},{80,120},{-80,120},{-80,-30},{-10,-30},{-10,-22}},
        color={255,127,0}));
  connect(lesEquThr.y, and1.u2) annotation (Line(points={{42,-10},{180,-10},{180,
          12},{198,12}},      color={255,0,255}));
  connect(logSwi2.y, and1.u1)
    annotation (Line(points={{122,20},{198,20}},  color={255,0,255}));
  connect(nexChi.yLasDisChi, disChiIsoVal.nexChaChi) annotation (Line(points={{
          41,286},{80,286},{80,68},{258,68}}, color={255,127,0}));
  connect(and1.y,disChiIsoVal.uUpsDevSta)  annotation (Line(points={{222,20},{240,
          20},{240,55},{258,55}},     color={255,0,255}));
  connect(nexChi.yOnOff, booRep4.u) annotation (Line(points={{41,290},{60,290},{
          60,80},{98,80}},            color={255,0,255}));
  connect(booRep4.y, swi.u2)
    annotation (Line(points={{122,80},{198,80}},  color={255,0,255}));
  connect(uChiWatIsoVal, swi.u3) annotation (Line(points={{-240,110},{140,110},{
          140,72},{198,72}},   color={0,0,127}));
  connect(staDow.yChiWatIsoVal, swi.u1) annotation (Line(points={{142,230},{156,
          230},{156,88},{198,88}},  color={0,0,127}));
  connect(swi.y, disChiIsoVal.uChiWatIsoVal) annotation (Line(points={{222,80},{
          240,80},{240,65},{258,65}},  color={0,0,127}));
  connect(uConWatReq, booToRea2.u)
    annotation (Line(points={{-240,-130},{-182,-130}},
                                                     color={255,0,255}));
  connect(booToRea2.y, curDisChi1.u)
    annotation (Line(points={{-158,-130},{-22,-130}},color={0,0,127}));
  connect(curDisChi1.y, lesEquThr1.u)
    annotation (Line(points={{2,-130},{18,-130}},    color={0,0,127}));
  connect(logSwi2.y, and5.u1) annotation (Line(points={{122,20},{130,20},{130,-20},
          {70,-20},{70,-122},{98,-122}},       color={255,0,255}));
  connect(disChiIsoVal.yEnaChiWatIsoVal, and5.u2) annotation (Line(points={{282,66},
          {300,66},{300,-28},{90,-28},{90,-130},{98,-130}},      color={255,0,
          255}));
  connect(lesEquThr1.y, and5.u3) annotation (Line(points={{42,-130},{72,-130},{72,
          -138},{98,-138}},      color={255,0,255}));
  connect(uChi, staDow.uChi) annotation (Line(points={{-240,230},{-140,230},{
          -140,233},{118,233}}, color={255,0,255}));
  connect(nexChi.yLasDisChi, curDisChi1.index) annotation (Line(points={{41,286},
          {80,286},{80,120},{-80,120},{-80,-152},{-10,-152},{-10,-142}},
        color={255,127,0}));
  connect(nexChi.yOnOff, booRep1.u) annotation (Line(points={{41,290},{60,290},{
          60,-70},{98,-70}},        color={255,0,255}));
  connect(booRep1.y, logSwi.u2)
    annotation (Line(points={{122,-70},{198,-70}},
                                                color={255,0,255}));
  connect(uChiHeaCon, logSwi.u3) annotation (Line(points={{-240,140},{-40,140},{
          -40,-90},{180,-90},{180,-78},{198,-78}},
                                            color={255,0,255}));
  connect(staDow.yChiHeaCon, logSwi.u1) annotation (Line(points={{142,235},{160,
          235},{160,-62},{198,-62}},
                                  color={255,0,255}));
  connect(and5.y, disHeaCon.uUpsDevSta) annotation (Line(points={{122,-130},{
          220,-130},{220,-92},{258,-92}},
                                 color={255,0,255}));
  connect(nexChi.yLasDisChi, disHeaCon.nexChaChi) annotation (Line(points={{41,
          286},{80,286},{80,-104},{258,-104}}, color={255,127,0}));
  connect(logSwi.y, disHeaCon.uChiHeaCon) annotation (Line(points={{222,-70},{
          240,-70},{240,-108},{258,-108}},
                                color={255,0,255}));
  connect(disHeaCon.yEnaHeaCon, enaNexCWP.uUpsDevSta) annotation (Line(points={
          {282,-94},{300,-94},{300,-140},{140,-140},{140,-182},{158,-182}},
        color={255,0,255}));
  connect(con.y, enaNexCWP.uStaUp) annotation (Line(points={{-78,320},{-60,320},
          {-60,-188},{158,-188}},color={255,0,255}));
  connect(uSta, enaNexCWP.uChiSta) annotation (Line(points={{-240,170},{-120,
          170},{-120,-198},{158,-198}}, color={255,127,0}));
  connect(enaNexCWP.yChiSta, conWatPumCon.uChiSta) annotation (Line(points={{
          182,-190},{200,-190},{200,-211},{218,-211}}, color={255,127,0}));
  connect(mulOr.y, conWatPumCon.uLeaChiOn) annotation (Line(points={{1.7,-220},{
          180,-220},{180,-206},{218,-206}},
                                      color={255,0,255}));
  connect(mulOr1.y, conWatPumCon.uLeaConWatReq) annotation (Line(points={{2,-250},
          {190,-250},{190,-208},{218,-208}},  color={255,0,255}));
  connect(uChi, mulOr.u) annotation (Line(points={{-240,230},{-140,230},{-140,-220},
          {-22,-220}},                        color={255,0,255}));
  connect(uConWatReq, mulOr1.u) annotation (Line(points={{-240,-130},{-190,-130},
          {-190,-250},{-22,-250}},            color={255,0,255}));
  connect(conWatPumCon.uWSE, uWSE) annotation (Line(points={{218,-214},{200,-214},
          {200,-280},{-240,-280}}, color={255,0,255}));
  connect(conWatPumCon.uConWatPumSpe, uConWatPumSpe) annotation (Line(points={{218,
          -219},{210,-219},{210,-310},{-240,-310}}, color={0,0,127}));
  connect(con.y, minBypSet.uStaUp) annotation (Line(points={{-78,320},{-60,320},
          {-60,-321},{258,-321}}, color={255,0,255}));
  connect(uSta, minBypSet.uSta) annotation (Line(points={{-240,170},{-120,170},{
          -120,-330},{258,-330}}, color={255,127,0}));
  connect(nexChi.yOnOff, minBypSet.uOnOff) annotation (Line(points={{41,290},{
          60,290},{60,-337},{258,-337}},
                                      color={255,0,255}));
  connect(staDow.yChiDem, yChiDem) annotation (Line(points={{142,239},{239.5,
          239},{239.5,260},{330,260}},
                                  color={0,0,127}));
  connect(staDow.yChi, yChi) annotation (Line(points={{142,225},{240,225},{240,
          220},{330,220}},
                      color={255,0,255}));
  connect(disChiIsoVal.yChiWatIsoVal, yChiWatIsoVal)
    annotation (Line(points={{282,54},{306,54},{306,60},{330,60}},
                                                 color={0,0,127}));
  connect(disHeaCon.yChiHeaCon, yChiHeaCon) annotation (Line(points={{282,-106},
          {310,-106},{310,-100},{330,-100}}, color={255,0,255}));
  connect(conWatPumCon.yConWatPumSpeSet, yConWatPumSpeSet) annotation (Line(
        points={{241,-207},{300,-207},{300,-190},{330,-190}}, color={0,0,127}));
  connect(conWatPumCon.yConWatPumNum, yConWatPumNum) annotation (Line(points={{242,
          -213},{300,-213},{300,-220},{330,-220}}, color={255,127,0}));
  connect(minBypSet.yChiWatBypSet, yChiWatBypSet)
    annotation (Line(points={{281,-330},{330,-330}}, color={0,0,127}));
  connect(conWatPumCon.yLeaPum, yLeaPum)
    annotation (Line(points={{242,-201},{280,-201},{280,-160},{330,-160}},
      color={255,0,255}));
  connect(uStaDow, edg.u)
    annotation (Line(points={{-240,380},{-182,380}}, color={255,0,255}));
  connect(edg.y, lat.u)
    annotation (Line(points={{-158,380},{-122,380}}, color={255,0,255}));
  connect(lat.y, minBypSet1.uStaCha) annotation (Line(points={{-98,380},{-80,
          380},{-80,360},{-200,360},{-200,-366},{258,-366}},
                                                        color={255,0,255}));
  connect(minBypSet.yChiWatBypSet, minBypSet1.VMinChiWat_setpoint) annotation (
      Line(points={{281,-330},{300,-330},{300,-350},{250,-350},{250,-378},{258,
          -378}}, color={0,0,127}));
  connect(VBypas_flow, minBypSet1.VChiWat_flow) annotation (Line(points={{-240,
          200},{-100,200},{-100,-374},{258,-374}}, color={0,0,127}));
  connect(VBypas_flow, staDow.VChiWat_flow) annotation (Line(points={{-240,200},
          {-100,200},{-100,231},{118,231}}, color={0,0,127}));
  connect(uChiLoa, staDow.uChiLoa) annotation (Line(points={{-240,260},{-100,
          260},{-100,235},{118,235}},
                                 color={0,0,127}));
  connect(lat.y, staDow.uStaDow) annotation (Line(points={{-98,380},{-80,380},{
          -80,360},{-200,360},{-200,239},{118,239}},
                                                 color={255,0,255}));
  connect(lat.y, nexChi.uStaDow) annotation (Line(points={{-98,380},{-80,380},{
          -80,360},{-200,360},{-200,282},{18,282}},
                                                color={255,0,255}));
  connect(lat.y, disChiIsoVal.uStaCha) annotation (Line(points={{-98,380},{-80,
          380},{-80,360},{-200,360},{-200,52},{258,52}},
                                                    color={255,0,255}));
  connect(lat.y, and4.u2) annotation (Line(points={{-98,380},{-80,380},{-80,360},
          {-200,360},{-200,22},{18,22}}, color={255,0,255}));
  connect(lat.y, logSwi2.u3) annotation (Line(points={{-98,380},{-80,380},{-80,360},
          {-200,360},{-200,12},{98,12}}, color={255,0,255}));
  connect(lat.y, disHeaCon.uStaCha) annotation (Line(points={{-98,380},{-80,380},
          {-80,360},{-200,360},{-200,-96},{258,-96}}, color={255,0,255}));
  connect(lat.y, minBypSet.uStaDow) annotation (Line(points={{-98,380},{-80,380},
          {-80,360},{-200,360},{-200,-339},{258,-339}}, color={255,0,255}));
  connect(minBypSet1.yMinBypRes, lat.u0) annotation (Line(points={{281,-370},{300,
          -370},{300,-390},{-130,-390},{-130,374},{-121,374}}, color={255,0,255}));
  connect(lat.y, enaNexCWP.uStaDow) annotation (Line(points={{-98,380},{-80,380},
          {-80,360},{-200,360},{-200,-192},{158,-192}}, color={255,0,255}));

  connect(lat.y, y)
    annotation (Line(points={{-98,380},{330,380}}, color={255,0,255}));
  connect(disHeaCon.yEnaHeaCon, yTowStaDow) annotation (Line(points={{282,-94},
          {300,-94},{300,-140},{330,-140}},color={255,0,255}));
  connect(disHeaCon.yEnaHeaCon, and2.u2) annotation (Line(points={{282,-94},{
          300,-94},{300,-140},{140,-140},{140,-268},{258,-268}},
                                                             color={255,0,255}));
  connect(conWatPumCon.yPumSpeChe, and2.u1) annotation (Line(points={{242,-219},
          {250,-219},{250,-260},{258,-260}}, color={255,0,255}));
  connect(and2.y, minBypSet.uUpsDevSta) annotation (Line(points={{282,-260},{
          300,-260},{300,-300},{240,-300},{240,-323},{258,-323}},
                                                              color={255,0,255}));
  connect(and2.y, minBypSet1.uUpsDevSta) annotation (Line(points={{282,-260},{
          300,-260},{300,-300},{240,-300},{240,-362},{258,-362}},
                                                              color={255,0,255}));
annotation (
  defaultComponentName="dowProCon",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-400},{320,400}})),
    Icon(coordinateSystem(extent={{-200,-200},{200,200}}), graphics={
        Rectangle(
        extent={{-200,-200},{200,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-240,270},{200,210}},
          lineColor={0,0,255},
          textString="%name")}));
end Down;
