within Buildings.Templates.Plants.Controls.Setpoints;
block PlantReset
  "Plant reset logic"
  parameter Integer nSenDpRem(final min=1)
    "Number of remote loop differential pressure sensors used for pump speed control"
    annotation (Evaluate=true);
  parameter Real dpSet_max[nSenDpRem](
    each final min=5*6894,
    each unit="Pa")
    "Maximum differential pressure setpoint";
  parameter Real dpSet_min(
    final min=0,
    final unit="Pa")=5*6894
    "Minimum value to which the differential pressure can be reset";
  parameter Real TSup_nominal(
    final min=273.15,
    final unit="K",
    displayUnit="degC")
    "Design supply temperature";
  parameter Real TSupSetLim(
    final min=273.15,
    final unit="K",
    displayUnit="degC")
    "Limit value to which the supply temperature can be reset";
  parameter Real dtHol(
    final min=0,
    final unit="s")=900
    "Minimum hold time during stage change"
    annotation (Dialog(tab="Advanced"));
  parameter Real resDp_max(
    final max=1,
    final min=0,
    final unit="1")=0.5
    "Upper limit of plant reset interval for differential pressure reset"
    annotation (Dialog(tab="Advanced"));
  parameter Real resTSup_min(
    final max=1,
    final min=0,
    final unit="1")=resDp_max
    "Lower limit of plant reset interval for supply temperature reset"
    annotation (Dialog(tab="Advanced"));
  parameter Real res_init(
    final max=1,
    final min=0,
    final unit="1")=1
    "Initial reset value"
    annotation (Dialog(tab="Advanced",group="Trim and respond"));
  parameter Real res_min(
    final max=1,
    final min=0,
    final unit="1")=0
    "Minimum reset value"
    annotation (Dialog(tab="Advanced",group="Trim and respond"));
  parameter Real res_max(
    final max=1,
    final min=0,
    final unit="1")=1
    "Maximum reset value"
    annotation (Dialog(tab="Advanced",group="Trim and respond"));
  parameter Real dtDel(
    final min=100*1E-15,
    final unit="s")=900
    "Delay time before the reset begins"
    annotation (Dialog(tab="Advanced",group="Trim and respond"));
  parameter Real dtRes(
    final min=1E-3,
    final unit="s")=300
    "Sample period of component"
    annotation (Dialog(tab="Advanced",group="Trim and respond"));
  parameter Integer nReqResIgn(min=0)=2
    "Number of ignored requests"
    annotation (Dialog(tab="Advanced",group="Trim and respond"));
  parameter Real tri(
    final max=0,
    final unit="1")=-0.02
    "Trim amount"
    annotation (Dialog(tab="Advanced",group="Trim and respond"));
  parameter Real rsp(
    final min=0,
    final unit="1")=0.03
    "Respond amount (must have opposite sign of trim amount)"
    annotation (Dialog(tab="Advanced",group="Trim and respond"));
  parameter Real rsp_max(
    final min=0,
    final unit="1")=0.07
    "Maximum response per reset period (must have same sign as respond amount)"
    annotation (Dialog(tab="Advanced",group="Trim and respond"));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nReqRes
    "Sum of reset requests of all loads served"
    annotation (Placement(transformation(extent={{-200,120},{-160,160}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ena
    "Plant enable"
    annotation (Placement(transformation(extent={{-200,80},{-160,120}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1StaPro
    "Staging process in progress"
    annotation (Placement(transformation(extent={{-200,20},{-160,60}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupSet(
    final unit="K",
    displayUnit="degC")
    "Supply temperature setpoint"
    annotation (Placement(transformation(extent={{160,-120},{200,-80}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpSet[nSenDpRem](
    each final min=0,
    each final unit="Pa")
    "Differential pressure setpoint"
    annotation (Placement(transformation(extent={{160,-40},{200,0}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.TrimAndRespond triRes(
    final delTim=dtDel,
    final iniSet=res_init,
    final maxRes=rsp_max,
    final maxSet=res_max,
    final minSet=res_min,
    final numIgnReq=nReqResIgn,
    final resAmo=rsp,
    final samplePeriod=dtRes,
    final triAmo=tri)
    "Compute plant reset with trim and respond logic "
    annotation (Placement(transformation(extent={{-50,90},{-30,110}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truHol(
    final falseHoldDuration=0, final trueHoldDuration=dtHol)
    "Hold true value of input signal for given time"
    annotation (Placement(transformation(extent={{-130,30},{-110,50}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    "Fixed value at stage change"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Buildings.Controls.OBC.CDL.Reals.Switch res
    "Switch between actual and fixed value to compute actual reset"
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
  Buildings.Controls.OBC.CDL.Reals.Line resTSup
    "Supply temperature reset"
    annotation (Placement(transformation(extent={{120,-110},{140,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Line resDp[nSenDpRem]
    "Differential pressure reset"
    annotation (Placement(transformation(extent={{120,-30},{140,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=0)
    "Constant"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(
    final k=1)
    "Constant"
    annotation (Placement(transformation(extent={{-10,-130},{10,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant resDpMax(
    final k=resDp_max)
    "Constant"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep(
    final nout=nSenDpRem)
    "Replicate signal"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep1(
    final nout=nSenDpRem)
    "Replicate signal"
    annotation (Placement(transformation(extent={{70,30},{90,50}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep2(
    final nout=nSenDpRem)
    "Replicate signal"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpSetMax[nSenDpRem](
    final k=dpSet_max)
    "Constant"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant resTSupMin(
    final k=resTSup_min)
    "Constant"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSupSetNom(
    final k=TSup_nominal)
    "Constant"
    annotation (Placement(transformation(extent={{-90,-150},{-70,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpSetMin(
    final k=dpSet_min)
    "Constant"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep3(
    final nout=nSenDpRem)
    "Replicate signal"
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSupSetMinMax(final k=
        TSupSetLim) "Constant"
    annotation (Placement(transformation(extent={{-90,-110},{-70,-90}})));
equation
  connect(u1StaPro, truHol.u)
    annotation (Line(points={{-180,40},{-132,40}},color={255,0,255}));
  connect(triRes.y, triSam.u)
    annotation (Line(points={{-28,100},{-12,100}},color={0,0,127}));
  connect(u1StaPro, triSam.trigger)
    annotation (Line(points={{-180,40},{-140,40},{-140,80},{0,80},{0,88}},color={255,0,255}));
  connect(truHol.y, res.u2)
    annotation (Line(points={{-108,40},{20,40},{20,60},{28,60}},color={255,0,255}));
  connect(triSam.y, res.u1)
    annotation (Line(points={{12,100},{20,100},{20,68},{28,68}},color={0,0,127}));
  connect(triRes.y, res.u3)
    annotation (Line(points={{-28,100},{-20,100},{-20,52},{28,52}},color={0,0,127}));
  connect(nReqRes, triRes.numOfReq)
    annotation (Line(points={{-180,140},{-80,140},{-80,92},{-52,92}},color={255,127,0}));
  connect(resTSup.y, TSupSet)
    annotation (Line(points={{142,-100},{180,-100}},color={0,0,127}));
  connect(resDp.y, dpSet)
    annotation (Line(points={{142,-20},{180,-20}},color={0,0,127}));
  connect(one.y, resTSup.x2)
    annotation (Line(points={{12,-120},{100,-120},{100,-104},{118,-104}},color={0,0,127}));
  connect(res.y, resTSup.u)
    annotation (Line(points={{52,60},{104,60},{104,-100},{118,-100}},color={0,0,127}));
  connect(zer.y, rep.u)
    annotation (Line(points={{12,0},{28,0}},color={0,0,127}));
  connect(rep.y, resDp.x1)
    annotation (Line(points={{52,0},{80,0},{80,-12},{118,-12}},color={0,0,127}));
  connect(res.y, rep1.u)
    annotation (Line(points={{52,60},{60,60},{60,40},{68,40}},color={0,0,127}));
  connect(rep1.y, resDp.u)
    annotation (Line(points={{92,40},{100,40},{100,-20},{118,-20}},color={0,0,127}));
  connect(rep2.y, resDp.x2)
    annotation (Line(points={{52,-40},{80,-40},{80,-24},{118,-24}},color={0,0,127}));
  connect(dpSetMax.y, resDp.f2)
    annotation (Line(points={{-68,-60},{100,-60},{100,-28},{118,-28}},color={0,0,127}));
  connect(TSupSetNom.y, resTSup.f2)
    annotation (Line(points={{-68,-140},{104,-140},{104,-108},{118,-108}},color={0,0,127}));
  connect(dpSetMin.y, rep3.u)
    annotation (Line(points={{-68,20},{-52,20}},color={0,0,127}));
  connect(rep3.y, resDp.f1)
    annotation (Line(points={{-28,20},{76,20},{76,-16},{118,-16}},color={0,0,127}));
  connect(TSupSetMinMax.y, resTSup.f1)
    annotation (Line(points={{-68,-100},{80,-100},{80,-96},{118,-96}},color={0,0,127}));
  connect(resTSupMin.y, resTSup.x1)
    annotation (Line(points={{12,-80},{80,-80},{80,-92},{118,-92}},color={0,0,127}));
  connect(resDpMax.y, rep2.u)
    annotation (Line(points={{12,-40},{28,-40}},color={0,0,127}));
  connect(u1Ena, triRes.uDevSta) annotation (Line(points={{-180,100},{-60,100},
          {-60,108},{-52,108}}, color={255,0,255}));
  annotation (
    defaultComponentName="res",
    Icon(
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(
      coordinateSystem(
        extent={{-160,-160},{160,160}})),
    Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PlantReset;
