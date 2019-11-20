within Buildings.Fluid.CHPs.BaseClasses;
model EnergyConversion "Energy conversion control volume"
  extends Modelica.Blocks.Icons.Block;

  replaceable package Medium = Buildings.Media.Water "Medium model";
  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));

  Buildings.Fluid.CHPs.BaseClasses.Interfaces.ModeTypeInput opeMod
    "Operation mode"
    annotation (Placement(transformation(extent={{-180,60},{-140,100}}),
      iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PEle(
    final unit="W") "Electric power demand"
    annotation (Placement(transformation(extent={{-180,20},{-140,60}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWatIn(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Water inlet temperature"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mWat_flow(
    final unit="kg/s",
    final quantity="MassFlowRate") "Water flow rate"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEng(
    final unit="K",
    final quantity="ThermodynamicTemperature") if per.warmUpByTimeDelay
    "Engine temperature"
    annotation (Placement(transformation(extent={{-180,-120},{-140,-80}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PEleNet(
    final unit="W") "Electric power generation"
    annotation (Placement(transformation(extent={{140,60},{180,100}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mFue_flow(
    final unit="kg/s",
    final quantity="MassFlowRate") "Fuel flow rate"
    annotation (Placement(transformation(extent={{140,0},{180,40}}),
      iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mAir_flow(
    final unit="kg/s",
    final quantity="MassFlowRate") "Air flow rate"
    annotation (Placement(transformation(extent={{140,-60},{180,-20}}),
      iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QGen(
    final unit="W") "Heat generation"
    annotation (Placement(transformation(extent={{140,-120},{180,-80}}),
      iconTransformation(extent={{100,-100},{140,-60}})));

protected
  Buildings.Fluid.CHPs.BaseClasses.AssertFuel assFue(final per=per)
    "Assert if fuel flow rate is outside boundaries"
    annotation (Placement(transformation(extent={{120,40},{140,60}})));
  Buildings.Fluid.CHPs.BaseClasses.OperModeBasic opeModBas(final per=per)
    "Typical energy conversion mode"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.Fluid.CHPs.BaseClasses.OperModeWarmUpEngTem opeModWarUpEngTem(
    final per=per) if per.warmUpByTimeDelay
    "Warm-up by engine temperature"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch switch
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Sources.BooleanExpression booExp(
    final y=opeMod ==CHPs.BaseClasses.Types.Mode.WarmUp or
            opeMod ==CHPs.BaseClasses.Types.Mode.Normal)
    "Check if warm up mode or normal operation mode"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Modelica.Blocks.Sources.BooleanExpression booExp1(
    final y=opeMod ==CHPs.BaseClasses.Types.Mode.WarmUp and
            per.warmUpByTimeDelay) "Check if warm up mode by time delay"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const1(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.BooleanExpression booExp3(
    final y=opeMod ==CHPs.BaseClasses.Types.Mode.WarmUp and
          not per.warmUpByTimeDelay)
    "Check if it is typical operation or warm-up by engine temperature"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Controls.OBC.CDL.Logical.Switch switch2
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch switch3
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch switch4
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch switch5
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant Troo(
    final k=273.15 + 15) if per.warmUpByTimeDelay
    "Temperature used to calculate warm-up by engine temperature mode"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const2(
    final k=0) if not per.warmUpByTimeDelay "Zero constant"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));

equation
  connect(opeModBas.mWat_flow, mWat_flow) annotation (Line(points={{-22,-10},{
          -80,-10},{-80,-60},{-160,-60}},
                                     color={0,0,127}));
  connect(opeModBas.TWatIn, TWatIn) annotation (Line(points={{-22,-16},{-60,-16},
          {-60,-20},{-160,-20}}, color={0,0,127}));
  connect(opeModWarUpEngTem.TEng, TEng) annotation (Line(points={{-22,-58},{-30,
          -58},{-30,-100},{-160,-100}}, color={0,0,127}));
  connect(opeModWarUpEngTem.TWatIn, TWatIn) annotation (Line(points={{-22,-47},{
          -60,-47},{-60,-20},{-160,-20}},color={0,0,127}));
  connect(const.y, switch.u3) annotation (Line(points={{-98,0},{-80,0},{-80,12},
          {-62,12}}, color={0,0,127}));
  connect(PEle, switch.u1) annotation (Line(points={{-160,40},{-80,40},{-80,28},
          {-62,28}}, color={0,0,127}));
  connect(booExp.y, switch.u2) annotation (Line(points={{-99,20},{-62,20}},
          color={255,0,255}));
  connect(booExp1.y, switch1.u2) annotation (Line(points={{-39,50},{-22,50}},
          color={255,0,255}));
  connect(switch.y, switch1.u3) annotation (Line(points={{-38,20},{-30,20},
          {-30,42},{-22,42}}, color={0,0,127}));
  connect(switch.y, opeModBas.PEle) annotation (Line(points={{-38,20},{-30,20},
          {-30,-4},{-22,-4}},color={0,0,127}));
  connect(switch1.u1, const1.y) annotation (Line(points={{-22,58},{-30,58},{-30,
          80},{-58,80}}, color={0,0,127}));
  connect(booExp3.y, switch2.u2) annotation (Line(points={{61,50},{70,50},{70,80},
          {78,80}}, color={255,0,255}));
  connect(opeModWarUpEngTem.PEleNet, switch2.u1) annotation (Line(points={{2,-42},
          {30,-42},{30,88},{78,88}}, color={0,0,127}));
  connect(switch2.y, PEleNet) annotation (Line(points={{102,80},{160,80}},
          color={0,0,127}));
  connect(switch1.y, switch2.u3) annotation (Line(points={{2,50},{20,50},{20,72},
          {78,72}}, color={0,0,127}));
  connect(booExp3.y, switch3.u2) annotation (Line(points={{61,50},{70,50},{70,20},
          {78,20}}, color={255,0,255}));
  connect(switch4.u2, booExp3.y) annotation (Line(points={{78,-40},{70,-40},{70,
          50},{61,50}}, color={255,0,255}));
  connect(switch5.u2, booExp3.y) annotation (Line(points={{78,-100},{70,-100},{70,
          50},{61,50}}, color={255,0,255}));
  connect(switch3.y, mFue_flow) annotation (Line(points={{102,20},{160,20}},
          color={0,0,127}));
  connect(switch4.y, mAir_flow) annotation (Line(points={{102,-40},{160,-40}},
          color={0,0,127}));
  connect(switch5.y, QGen) annotation (Line(points={{102,-100},{160,-100}},
          color={0,0,127}));
  connect(opeModBas.mFue_flow, switch3.u3) annotation (Line(points={{2,-4},{20,
          -4},{20,12},{78,12}},
                            color={0,0,127}));
  connect(opeModWarUpEngTem.mFue_flow, switch3.u1) annotation (Line(points={{2,-47},
          {40,-47},{40,28},{78,28}}, color={0,0,127}));
  connect(opeModBas.mAir_flow, switch4.u3) annotation (Line(points={{2,-10},{60,
          -10},{60,-48},{78,-48}}, color={0,0,127}));
  connect(opeModWarUpEngTem.mAir_flow, switch4.u1) annotation (Line(points={{2,-53},
          {50,-53},{50,-32},{78,-32}},  color={0,0,127}));
  connect(opeModWarUpEngTem.QGen, switch5.u1) annotation (Line(points={{2,-58},{
          40,-58},{40,-92},{78,-92}}, color={0,0,127}));
  connect(opeModBas.QGen, switch5.u3) annotation (Line(points={{2.2,-16},{20,-16},
          {20,-108},{78,-108}}, color={0,0,127}));
  connect(Troo.y, opeModWarUpEngTem.TRoo) annotation (Line(points={{-58,-80},{-40,
          -80},{-40,-53},{-22,-53}}, color={0,0,127}));
  connect(assFue.mFue_flow, switch3.y) annotation (Line(points={{118,50},{110,50},
          {110,20},{102,20}}, color={0,0,127}));
  connect(mWat_flow, opeModWarUpEngTem.mWat_flow) annotation (Line(points={{-160,
          -60},{-80,-60},{-80,-42},{-22,-42}}, color={0,0,127}));
  connect(const2.y, switch2.u1) annotation (Line(points={{2,100},{10,100},{10,88},
          {78,88}}, color={0,0,127}));
  connect(const2.y, switch3.u1) annotation (Line(points={{2,100},{10,100},{10,28},
          {78,28}}, color={0,0,127}));
  connect(const2.y, switch4.u1) annotation (Line(points={{2,100},{10,100},{10,-32},
          {78,-32}}, color={0,0,127}));
  connect(const2.y, switch5.u1) annotation (Line(points={{2,100},{10,100},{10,-92},
          {78,-92}}, color={0,0,127}));

annotation (
  defaultComponentName="eneCon",
  Diagram(coordinateSystem(extent={{-140,-120},{140,120}})),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Documentation(info="<html>
<p>
The model defines energy conversion that occurs during the normal mode and warm-up mode. 
The model <a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.OperModeWarmUpEngTem\">
Buildings.Fluid.CHPs.BaseClasses.OperModeWarmUpEngTem</a> is used only for the 
warm-up mode dependent on the engine temperature. 
The model <a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.OperModeBasic\">
Buildings.Fluid.CHPs.BaseClasses.OperModeBasic</a> is used for all other cases 
(the normal mode and warm-up mode based on a time delay).
</p>
</html>", revisions="<html>
<ul>
<li>
June 01, 2019 by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnergyConversion;
