within Buildings.Fluid.CHPs.BaseClasses;
model EnergyConversion "Energy conversion control volume"
  extends Modelica.Blocks.Icons.Block;

  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{106,100},{126,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput PEle(
    final unit="W") "Power demand"
    annotation (Placement(transformation(extent={{-180,100},{-140,140}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Fluid.CHPs.BaseClasses.Interfaces.ModeTypeInput opeMod
    "Operation mode"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
      iconTransformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mWat_flow(
    final unit="kg/s",
    final quantity="MassFlowRate") "Water mass flow rate"
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWatIn(
    final unit="K",
    displayUnit="degC")
    "Water inlet temperature"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
      iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRoo(
    final unit="K",
    displayUnit="degC") "Room temperature"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEng(
    final unit="K",
    displayUnit="degC") if not per.warmUpByTimeDelay
    "Engine temperature"
    annotation (Placement(transformation(extent={{-180,-110},{-140,-70}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PEleNet(
    final unit="W") "Net power output"
    annotation (Placement(transformation(extent={{140,60},{180,100}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mFue_flow(
    final unit="kg/s",
    final quantity="MassFlowRate") "Fuel mass flow rate"
    annotation (Placement(transformation(extent={{140,0},{180,40}}),
      iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mAir_flow(
    final unit="kg/s",
    final quantity="MassFlowRate") "Air mass flow rate"
    annotation (Placement(transformation(extent={{140,-60},{180,-20}}),
      iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QGen_flow(final unit="W")
    "Heat generation rate"
    annotation (Placement(transformation(extent={{140,-120},
      {180,-80}}), iconTransformation(extent={{100,-100},{140,-60}})));

protected
  Buildings.Fluid.CHPs.BaseClasses.AssertFuelFlow assFue(
    final dmFueMax_flow=per.dmFueMax_flow) if per.use_fuelRateLimit
    "Assert if fuel flow rate is outside boundaries"
    annotation (Placement(transformation(extent={{110,30},{130,50}})));
  Buildings.Fluid.CHPs.BaseClasses.EnergyConversionNormal opeModBas(final per=
        per) "Typical energy conversion mode"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Fluid.CHPs.BaseClasses.EnergyConversionWarmUp opeModWarUpEngTem(
      final per=per) if not per.warmUpByTimeDelay "Warm-up by engine temperature"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch switch
    "Switch to zero power output if not in (normal or warm-up mode)"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Modelica.Blocks.Sources.BooleanExpression booExp(
    final y=opeMod ==CHPs.BaseClasses.Types.Mode.WarmUp or
            opeMod ==CHPs.BaseClasses.Types.Mode.Normal)
    "True if active mode is (warm-up or normal)"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch switch2
    "Switch between warm-up and normal value"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch switch3
    "Switch between warm-up and normal value"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch switch4
    "Switch between warm-up and normal value"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch switch5
    "Switch between warm-up and normal value"
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant PEleTimeDel(final k=0)
               if per.warmUpByTimeDelay
    "Zero power output in case of warm-up by time delay"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant delWarUp(
    final k=per.warmUpByTimeDelay) "Warm-up by time delay"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  Modelica.Blocks.Sources.BooleanExpression wamUpMod(
    final y=opeMod == CHPs.BaseClasses.Types.Mode.WarmUp)
    "Check whether warm-up mode is active"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not engTemWarUp
    "Warm-up based on engine temperature"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "True if warm-up mode and warm-up based on engine temperature"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dumTimDel(
    final k=0) if per.warmUpByTimeDelay
    "Set dummy value in case of warm-up by time delay"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));

equation
  connect(opeModBas.mWat_flow, mWat_flow) annotation (Line(points={{-22,0},{-120,
          0},{-120,20},{-160,20}},        color={0,0,127}));
  connect(opeModBas.TWatIn, TWatIn) annotation (Line(points={{-22,-6},{-100,-6},
          {-100,-20},{-160,-20}},color={0,0,127}));
  connect(opeModWarUpEngTem.TEng, TEng) annotation (Line(points={{-22,-58},{-110,
          -58},{-110,-90},{-160,-90}},  color={0,0,127}));
  connect(opeModWarUpEngTem.TWatIn, TWatIn) annotation (Line(points={{-22,-47},{
          -100,-47},{-100,-20},{-160,-20}},
                                         color={0,0,127}));
  connect(const.y, switch.u3) annotation (Line(points={{-78,70},{-70,70},{-70,
          92},{-62,92}},
                     color={0,0,127}));
  connect(PEle, switch.u1) annotation (Line(points={{-160,120},{-70,120},{-70,
          108},{-62,108}},
                     color={0,0,127}));
  connect(booExp.y, switch.u2) annotation (Line(points={{-79,100},{-62,100}},
          color={255,0,255}));
  connect(switch.y, opeModBas.PEle) annotation (Line(points={{-38,100},{-30,100},
          {-30,6},{-22,6}},  color={0,0,127}));
  connect(opeModWarUpEngTem.PEleNet, switch2.u1) annotation (Line(points={{2,-42},
          {20,-42},{20,88},{78,88}}, color={0,0,127}));
  connect(switch2.y, PEleNet) annotation (Line(points={{102,80},{160,80}},
          color={0,0,127}));
  connect(switch3.y, mFue_flow) annotation (Line(points={{102,20},{160,20}},
          color={0,0,127}));
  connect(switch4.y, mAir_flow) annotation (Line(points={{102,-40},{160,-40}},
          color={0,0,127}));
  connect(switch5.y, QGen_flow)
    annotation (Line(points={{102,-100},{160,-100}}, color={0,0,127}));
  connect(opeModBas.mFue_flow, switch3.u3) annotation (Line(points={{2,6},{60,6},
          {60,12},{78,12}},     color={0,0,127}));
  connect(opeModWarUpEngTem.mFue_flow, switch3.u1) annotation (Line(points={{2,-47},
          {26,-47},{26,28},{78,28}}, color={0,0,127}));
  connect(opeModBas.mAir_flow, switch4.u3) annotation (Line(points={{2,0},{60,0},
          {60,-48},{78,-48}},      color={0,0,127}));
  connect(opeModWarUpEngTem.mAir_flow, switch4.u1) annotation (Line(points={{2,-53},
          {40,-53},{40,-32},{78,-32}},  color={0,0,127}));
  connect(opeModWarUpEngTem.QGen_flow, switch5.u1) annotation (Line(points={{2,-58},
          {32,-58},{32,-92},{78,-92}},      color={0,0,127}));
  connect(opeModBas.QGen_flow, switch5.u3) annotation (Line(points={{2.2,-6},{54,
          -6},{54,-108},{78,-108}},     color={0,0,127}));
  connect(mWat_flow, opeModWarUpEngTem.mWat_flow) annotation (Line(points={{-160,20},
          {-120,20},{-120,-42},{-22,-42}},     color={0,0,127}));
  connect(switch3.y, assFue.mFue_flow) annotation (Line(points={{102,20},{104,20},
          {104,40},{108,40}}, color={0,0,127}));
  connect(PEleTimeDel.y, switch2.u1) annotation (Line(points={{2,100},{60,100},{
          60,88},{78,88}}, color={0,0,127}));
  connect(switch.y, switch2.u3) annotation (Line(points={{-38,100},{-30,100},{-30,
          72},{78,72}}, color={0,0,127}));
  connect(TRoo, opeModWarUpEngTem.TRoo) annotation (Line(points={{-160,-60},{-120,
          -60},{-120,-53},{-22,-53}},    color={0,0,127}));
  connect(delWarUp.y, engTemWarUp.u)
    annotation (Line(points={{-78,-110},{-62,-110}}, color={255,0,255}));
  connect(engTemWarUp.y, and1.u2) annotation (Line(points={{-38,-110},{-30,-110},
          {-30,-88},{-22,-88}}, color={255,0,255}));
  connect(wamUpMod.y, and1.u1) annotation (Line(points={{-79,40},{-60,40},{-60,
          -80},{-22,-80}},
                      color={255,0,255}));
  connect(and1.y, switch3.u2) annotation (Line(points={{2,-80},{70,-80},{70,20},
          {78,20}}, color={255,0,255}));
  connect(and1.y, switch4.u2) annotation (Line(points={{2,-80},{70,-80},{70,-40},
          {78,-40}}, color={255,0,255}));
  connect(and1.y, switch5.u2) annotation (Line(points={{2,-80},{70,-80},{70,-100},
          {78,-100}}, color={255,0,255}));
  connect(wamUpMod.y, switch2.u2) annotation (Line(points={{-79,40},{-60,40},{
          -60,80},{78,80}},
                        color={255,0,255}));
  connect(dumTimDel.y, switch3.u1) annotation (Line(points={{2,40},{26,40},{26,28},
          {78,28}}, color={0,0,127}));
  connect(dumTimDel.y, switch4.u1) annotation (Line(points={{2,40},{40,40},{40,-32},
          {78,-32}}, color={0,0,127}));
  connect(dumTimDel.y, switch5.u1) annotation (Line(points={{2,40},{32,40},{32,-92},
          {78,-92}}, color={0,0,127}));

annotation (
  defaultComponentName="eneCon",
  Diagram(coordinateSystem(extent={{-140,-140},{140,140}})),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Documentation(info="<html>
<p>
The model defines energy conversion that occurs during the normal mode and warm-up mode.
The model
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.EnergyConversionWarmUp\">
Buildings.Fluid.CHPs.BaseClasses.EnergyConversionWarmUp</a>
is used only for the
warm-up mode dependent on the engine temperature (case of Stirling engines).
The model
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.EnergyConversionNormal\">
Buildings.Fluid.CHPs.BaseClasses.EnergyConversionNormal</a>
is used for all other cases,
i.e. the normal mode, and the warm-up mode based on a time delay (case of internal
combustion engines).
</p>
</html>", revisions="<html>
<ul>
<li>
April 8, 2020, by Antoine Gautier:<br/>
Refactored implementation.
</li>
<li>
June 1, 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnergyConversion;
