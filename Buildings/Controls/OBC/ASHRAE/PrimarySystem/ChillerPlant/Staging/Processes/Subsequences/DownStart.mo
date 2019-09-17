within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences;
block DownStart "Sequence starting stage-down process"

  parameter Integer nChi = 2 "Total number of chillers";
  parameter Integer nSta = 3 "Total nunber of stages, zero stage should be count as one stage";
  parameter Real chiDemRedFac=0.75
    "Demand reducing factor of current operating chillers"
    annotation (Dialog(group="Demand limit"));
  parameter Modelica.SIunits.Time holChiDemTim=300
    "Time of actual demand less than center percentage of currnet load"
    annotation (Dialog(group="Demand limit"));
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
  parameter Modelica.SIunits.Time thrTimEnb=10
    "Threshold time to enable head pressure control after condenser water pump being reset"
    annotation (Dialog(group="Head pressure control"));
  parameter Modelica.SIunits.Time waiTim=30
    "Waiting time after enabling next head pressure control"
    annotation (Dialog(group="Head pressure control"));
  parameter Modelica.SIunits.Time chaChiWatIsoTim=300
    "Time to slowly change isolation valve"
    annotation (Dialog(group="Chilled water isolation valve"));
  parameter Modelica.SIunits.Time proOnTim=300
    "Enabled chiller operation time to indicate if it is proven on"
    annotation (Dialog(group="Disable last chiller"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow
    "Stage down status: true=stage-down"
    annotation (Placement(transformation(extent={{-200,170},{-160,210}}),
      iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiLoa[nChi](
    each final quantity="HeatFlowRate",
    each final unit="W") "Current chiller load"
    annotation (Placement(transformation(extent={{-200,130},{-160,170}}),
      iconTransformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
      iconTransformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VBypas_flow(
    final unit="m3/s") "Measured bypass flow rate"
    annotation (Placement(transformation(extent={{-200,70},{-160,110}}),
      iconTransformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta "Current stage index"
    annotation (Placement(transformation(extent={{-200,30},{-160,70}}),
      iconTransformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "Indicate if the stage require one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{-200,0},{-160,40}}),
      iconTransformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uNexEnaChi
    "Index of next enabling chiller"
    annotation (Placement(transformation(extent={{-200,-40},{-160,0}}),
      iconTransformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiHeaCon[nChi]
    "Chillers head pressure control status"
    annotation (Placement(transformation(extent={{-200,-70},{-160,-30}}),
      iconTransformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[nChi](
    each final min=0,
    each final max=1,
    each final unit="1") "Chilled water isolation valve position"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
      iconTransformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uNexDisChi
    "Next disabling chiller when there is any stage up that need one chiller on and another off"
    annotation (Placement(transformation(extent={{-200,-190},{-160,-150}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiDem[nChi](
    each final quantity="HeatFlowRate",
    each final unit="W") "Chiller demand setpoint"
    annotation (Placement(transformation(extent={{180,130},{200,150}}),
      iconTransformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiHeaCon[nChi]
    "Chiller head pressure control enabling status"
    annotation (Placement(transformation(extent={{180,-30},{200,-10}}),
      iconTransformation(extent={{100,40},{120,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatIsoVal[nChi](
    each final min=0,
    each final max=1,
    each final unit="1")
    "Chiller chilled water isolation valve position"
    annotation (Placement(transformation(extent={{180,-80},{200,-60}}),
      iconTransformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chiller enabling status"
    annotation (Placement(transformation(extent={{180,-160},{200,-140}}),
      iconTransformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yReaDemLim
    "Release demand limit"
    annotation (Placement(transformation(extent={{180,-190},{200,-170}}),
      iconTransformation(extent={{100,-100},{120,-80}})));

protected
  final parameter Boolean heaStaCha=true
    "Flag to indicate if next head pressure control should be ON or OFF: true = in stage-up process"
    annotation (Dialog(group="Head pressure control"));
  final parameter Real iniValPos=0
    "Initial valve position, if it needs to turn on chiller, the value should be 0"
    annotation (Dialog(group="Chilled water isolation valve"));
  final parameter Real endValPos=1
    "Ending valve position, if it needs to turn on chiller, the value should be 1"
    annotation (Dialog(group="Chilled water isolation valve"));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Processes.Subsequences.ReduceDemand
    chiDemRed(
    final nChi=nChi,
    final chiDemRedFac=chiDemRedFac,
    final holChiDemTim=holChiDemTim) "Reduce chiller demand"
    annotation (Placement(transformation(extent={{0,160},{20,180}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Processes.Subsequences.ResetMinBypass
    minBypRes(final aftByPasSetTim=aftByPasSetTim, final minFloDif=minFloDif)
    "Slowly change the minimum flow bypass setpoint"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Processes.Subsequences.EnableHeadControl
    enaHeaCon(
    final nChi=nChi,
    final thrTimEnb=thrTimEnb,
    final waiTim=waiTim,
    final heaStaCha=heaStaCha)
    "Enable head pressure control of the chiller being enabled"
    annotation (Placement(transformation(extent={{0,-26},{20,-6}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Processes.Subsequences.EnableChiIsoVal
    enaChiIsoVal(
    final nChi=nChi,
    final chaChiWatIsoTim=chaChiWatIsoTim,
    final iniValPos=iniValPos,
    final endValPos=endValPos) "Enable chiller chilled water isolation valve "
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Processes.Subsequences.DisableChiller
    disChi(final nChi=nChi, final proOnTim=proOnTim) "Disable last chiller"
    annotation (Placement(transformation(extent={{0,-160},{20,-140}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-100,180},{-80,200}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences.FlowSetpoint minBypSet(
    final nSta=nSta,
    final byPasSetTim=byPasSetTim,
    final minFloSet=minFloSet) "Reset minimum bypass flow setpoint"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3(final k=false)
    "False constant"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch heaPreCon[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiDem[nChi] "Chiller demand"
    annotation (Placement(transformation(extent={{140,130},{160,150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep4(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiWatIsoVal[nChi]
    "Chilled water isolation valve"
    annotation (Placement(transformation(extent={{140,-80},{160,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{60,-190},{80,-170}})));

equation
  connect(chiDemRed.uChiLoa, uChiLoa)
    annotation (Line(points={{-2,170},{-100,170},{-100,150},{-180,150}},
      color={0,0,127}));
  connect(chiDemRed.uChi, uChi)
    annotation (Line(points={{-2,164},{-40,164},{-40,120},{-180,120}}, color={255,0,255}));
  connect(con3.y, minBypSet.uStaUp)
    annotation (Line(points={{-78,70},{-60,70},{-60,59},{-1,59}},
      color={255,0,255}));
  connect(chiDemRed.yChiDemRed, minBypSet.uUpsDevSta)
    annotation (Line(points={{21,166},{30,166},{30,80},{-20,80},{-20,54},{-2,54}},
      color={255,0,255}));
  connect(minBypSet.uSta, uSta)
    annotation (Line(points={{-2,50},{-180,50}}, color={255,127,0}));
  connect(minBypSet.uStaDow, uStaDow)
    annotation (Line(points={{-1,41},{-140,41},{-140,190},{-180,190}},
      color={255,0,255}));
  connect(minBypSet.uOnOff, uOnOff)
    annotation (Line(points={{-1,43},{-80,43},{-80,20},{-180,20}},
      color={255,0,255}));
  connect(chiDemRed.yChiDemRed, minBypRes.uUpsDevSta)
    annotation (Line(points={{21,166},{30,166},{30,108},{58,108}},
      color={255,0,255}));
  connect(uStaDow, minBypRes.uStaCha)
    annotation (Line(points={{-180,190},{-140,190},{-140,104},{58,104}},
      color={255,0,255}));
  connect(minBypSet.yChiWatBypSet, minBypRes.VBypas_setpoint)
    annotation (Line(points={{21,50},{40,50},{40,92},{58,92}}, color={0,0,127}));
  connect(VBypas_flow, minBypRes.VBypas_flow)
    annotation (Line(points={{-180,90},{-60,90},{-60,96},{58,96}}, color={0,0,127}));
  connect(minBypRes.yMinBypRes, enaHeaCon.uUpsDevSta)
    annotation (Line(points={{81,100},{100,100},{100,0},{-20,0},{-20,-8},{-2,-8}},
      color={255,0,255}));
  connect(uStaDow, enaHeaCon.uStaCha)
    annotation (Line(points={{-180,190},{-140,190},{-140,-12},{-2,-12}},
      color={255,0,255}));
  connect(enaHeaCon.uNexChaChi,uNexEnaChi)
    annotation (Line(points={{-2,-20},{-180,-20}}, color={255,127,0}));
  connect(enaHeaCon.uChiHeaCon, uChiHeaCon)
    annotation (Line(points={{-2,-24},{-20,-24},{-20,-50},{-180,-50}},
      color={255,0,255}));
  connect(uNexEnaChi, enaChiIsoVal.uNexChaChi)
    annotation (Line(points={{-180,-20},{-60,-20},{-60,-92},{-2,-92}},
      color={255,127,0}));
  connect(enaChiIsoVal.uChiWatIsoVal, uChiWatIsoVal)
    annotation (Line(points={{-2,-96},{-100,-96},{-100,-80},{-180,-80}},
      color={0,0,127}));
  connect(enaHeaCon.yEnaHeaCon, enaChiIsoVal.yUpsDevSta)
    annotation (Line(points={{21,-10},{30,-10},{30,-60},{-20,-60},{-20,-104},{-2,-104}},
      color={255,0,255}));
  connect(uStaDow, enaChiIsoVal.uStaCha)
    annotation (Line(points={{-180,190},{-140,190},{-140,-108},{-2,-108}},
      color={255,0,255}));
  connect(uNexEnaChi, disChi.uNexEnaChi)
    annotation (Line(points={{-180,-20},{-60,-20},{-60,-140},{-2,-140}},
      color={255,127,0}));
  connect(uStaDow, disChi.uStaDow) annotation (Line(points={{-180,190},{-140,190},
          {-140,-144},{-2,-144}}, color={255,0,255}));
  connect(enaChiIsoVal.yEnaChiWatIsoVal, disChi.uEnaChiWatIsoVal) annotation (
      Line(points={{21,-94},{30,-94},{30,-120},{-20,-120},{-20,-148},{-2,-148}},
        color={255,0,255}));
  connect(uChi, disChi.uChi) annotation (Line(points={{-180,120},{-40,120},{-40,
          -152},{-2,-152}}, color={255,0,255}));
  connect(uOnOff, disChi.uOnOff) annotation (Line(points={{-180,20},{-80,20},{-80,
          -156},{-2,-156}}, color={255,0,255}));
  connect(disChi.uNexDisChi, uNexDisChi) annotation (Line(points={{-2,-160},{-80,
          -160},{-80,-170},{-180,-170}}, color={255,127,0}));
  connect(uStaDow, and2.u1)
    annotation (Line(points={{-180,190},{-102,190}}, color={255,0,255}));
  connect(and2.y, chiDemRed.uDemLim) annotation (Line(points={{-79,190},{-40,190},
          {-40,176},{-2,176}}, color={255,0,255}));
  connect(uOnOff, booRep4.u)
    annotation (Line(points={{-180,20},{58,20}}, color={255,0,255}));
  connect(booRep4.y, chiDem.u2) annotation (Line(points={{82,20},{120,20},{120,
          140},{138,140}},
                      color={255,0,255}));
  connect(chiDemRed.yChiDem, chiDem.u1) annotation (Line(points={{21,174},{80,174},
          {80,148},{138,148}}, color={0,0,127}));
  connect(uChiLoa, chiDem.u3) annotation (Line(points={{-180,150},{-100,150},{-100,
          132},{138,132}}, color={0,0,127}));
  connect(booRep4.y, heaPreCon.u2) annotation (Line(points={{82,20},{120,20},{
          120,-20},{138,-20}},
                           color={255,0,255}));
  connect(enaHeaCon.yChiHeaCon, heaPreCon.u1) annotation (Line(points={{21,-22},
          {80,-22},{80,-12},{138,-12}}, color={255,0,255}));
  connect(uChiHeaCon, heaPreCon.u3) annotation (Line(points={{-180,-50},{80,-50},
          {80,-28},{138,-28}},  color={255,0,255}));
  connect(booRep4.y, chiWatIsoVal.u2) annotation (Line(points={{82,20},{120,20},
          {120,-70},{138,-70}}, color={255,0,255}));
  connect(enaChiIsoVal.yChiWatIsoVal, chiWatIsoVal.u1) annotation (Line(points={
          {21,-100},{60,-100},{60,-62},{138,-62}}, color={0,0,127}));
  connect(uChiWatIsoVal, chiWatIsoVal.u3) annotation (Line(points={{-180,-80},{-100,
          -80},{-100,-78},{138,-78}}, color={0,0,127}));
  connect(chiDem.y, yChiDem)
    annotation (Line(points={{162,140},{190,140}}, color={0,0,127}));
  connect(heaPreCon.y, yChiHeaCon)
    annotation (Line(points={{162,-20},{190,-20}}, color={255,0,255}));
  connect(chiWatIsoVal.y, yChiWatIsoVal)
    annotation (Line(points={{162,-70},{190,-70}}, color={0,0,127}));
  connect(disChi.yChi, yChi)
    annotation (Line(points={{21,-150},{190,-150}}, color={255,0,255}));
  connect(disChi.yReaDemLim, not1.u) annotation (Line(points={{21,-158},{40,-158},
          {40,-180},{58,-180}}, color={255,0,255}));
  connect(not1.y, and2.u2) annotation (Line(points={{82,-180},{100,-180},{100,
          -200},{-120,-200},{-120,182},{-102,182}},
                                              color={255,0,255}));

  connect(disChi.yReaDemLim, yReaDemLim) annotation (Line(points={{21,-158},{120,
          -158},{120,-180},{190,-180}}, color={255,0,255}));
annotation (
  defaultComponentName="staDow",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-200},{180,220}})),
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}));
end DownStart;
