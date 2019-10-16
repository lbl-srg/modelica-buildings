within Buildings.Fluid.CHPs.BaseClasses;
model EnergyConversion "Energy conversion control volume"
   extends Modelica.Blocks.Icons.Block;
   replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  replaceable package Medium = Buildings.Media.Water "Medium model";
  CHPs.BaseClasses.Interfaces.ModeTypeInput opeMod "Operation mode" annotation (
     Placement(transformation(extent={{-180,60},{-140,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput PEle(unit="W") "Electric power demand"
    annotation (Placement(transformation(extent={{-180,20},{-140,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput TWatIn(unit="K")
    "Water inlet temperature" annotation (Placement(transformation(extent={{-180,
            -40},{-140,0}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput mWat_flow(unit="kg/s") "Water flow rate"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput TEng(unit="K") "Engine temperature"
    annotation (Placement(transformation(extent={{-178,-120},{-138,-80}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput PEleNet(unit="W")
    "Electric power generation" annotation (Placement(transformation(extent={{140,70},
            {160,90}}),       iconTransformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput mFue_flow(unit="kg/s") "Fuel flow rate"
    annotation (Placement(transformation(extent={{140,10},{160,30}}),
        iconTransformation(extent={{100,10},{120,30}})));
  Modelica.Blocks.Interfaces.RealOutput mAir_flow(unit="kg/s") "Air flow rate"
    annotation (Placement(transformation(extent={{140,-50},{160,-30}}),
        iconTransformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealOutput QGen(unit="W") "Heat generation"
    annotation (Placement(transformation(extent={{140,-110},{160,-90}}),
        iconTransformation(extent={{100,-70},{120,-50}})));
protected
  CHPs.BaseClasses.AssertFuel assFue(per=per)
    "Assert if fuel flow rate is outside boundaries"
    annotation (Placement(transformation(extent={{120,40},{140,60}})));
  CHPs.BaseClasses.OperModeBasic opeModBas(per=per)
    "Typical energy conversion mode"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  CHPs.BaseClasses.OperModeWarmUpEngTem opeModWarUpEngTem(per=per)
    "Warm-up by engine temperature"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Logical.Switch switch
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Sources.BooleanExpression booExp(y=opeMod ==CHPs.BaseClasses.Types.Mode.WarmUp
         or opeMod ==CHPs.BaseClasses.Types.Mode.Normal)
    "Check if warm up mode or normal operation mode"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Modelica.Blocks.Sources.BooleanExpression booExp1(y=opeMod ==CHPs.BaseClasses.Types.Mode.WarmUp
         and per.warmUpByTimeDelay) "Check if warm up mode by time delay"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.Constant const1(k=0)
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.BooleanExpression booExp3(y=opeMod ==CHPs.BaseClasses.Types.Mode.WarmUp
         and not per.warmUpByTimeDelay)
    "Check if typical operation or warm-up by engine temperature"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Modelica.Blocks.Logical.Switch switch3
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Modelica.Blocks.Logical.Switch switch4
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));
  Modelica.Blocks.Logical.Switch switch5
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
  Modelica.Blocks.Sources.Constant Troo(k=273.15 + 15)
    "Temperature used to calculate warm-up by engine temperature mode"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
equation
  connect(opeModBas.mWat_flow, mWat_flow) annotation (Line(points={{-21,-10},{-80,
          -10},{-80,-60},{-160,-60}},color={0,0,127}));
  connect(opeModBas.TWatIn, TWatIn) annotation (Line(points={{-21,-16},{-60,-16},
          {-60,-20},{-160,-20}},     color={0,0,127}));
  connect(opeModWarUpEngTem.TEng, TEng) annotation (Line(points={{-21,-56},{-30,
          -56},{-30,-100},{-158,-100}},
                                      color={0,0,127}));
  connect(opeModWarUpEngTem.TWatIn, TWatIn) annotation (Line(points={{-21,-48},{
          -60,-48},{-60,-20},{-160,-20}},color={0,0,127}));
  connect(const.y, switch.u3) annotation (Line(points={{-99,0},{-80,0},{-80,12},
          {-62,12}}, color={0,0,127}));
  connect(PEle, switch.u1) annotation (Line(points={{-160,40},{-80,40},{-80,28},
          {-62,28}}, color={0,0,127}));
  connect(booExp.y, switch.u2) annotation (Line(points={{-99,20},{-62,20}},
                     color={255,0,255}));
  connect(booExp1.y, switch1.u2)
    annotation (Line(points={{-39,50},{-22,50}},
                                               color={255,0,255}));
  connect(switch.y, switch1.u3)
    annotation (Line(points={{-39,20},{-30,20},{-30,42},{-22,42}},
                                               color={0,0,127}));
  connect(switch.y, opeModBas.PEle) annotation (Line(points={{-39,20},{-30,20},{
          -30,-4},{-21,-4}},
                           color={0,0,127}));
  connect(switch1.u1, const1.y) annotation (Line(points={{-22,58},{-30,58},{-30,
          80},{-59,80}},     color={0,0,127}));
  connect(booExp3.y, switch2.u2) annotation (Line(points={{61,50},{70,50},{70,80},
          {78,80}},        color={255,0,255}));
  connect(opeModWarUpEngTem.PEleNet, switch2.u1) annotation (Line(points={{1,-44},
          {30,-44},{30,88},{78,88}},           color={0,0,127}));
  connect(switch2.y, PEleNet)
    annotation (Line(points={{101,80},{150,80}},   color={0,0,127}));
  connect(switch1.y, switch2.u3) annotation (Line(points={{1,50},{20,50},{20,72},
          {78,72}},             color={0,0,127}));
  connect(booExp3.y, switch3.u2) annotation (Line(points={{61,50},{70,50},{70,20},
          {78,20}},      color={255,0,255}));
  connect(switch4.u2, booExp3.y) annotation (Line(points={{78,-40},{70,-40},{70,
          50},{61,50}},
                     color={255,0,255}));
  connect(switch5.u2, booExp3.y) annotation (Line(points={{78,-100},{70,-100},{70,
          50},{61,50}},  color={255,0,255}));
  connect(switch3.y, mFue_flow)
    annotation (Line(points={{101,20},{150,20}}, color={0,0,127}));
  connect(switch4.y, mAir_flow)
    annotation (Line(points={{101,-40},{150,-40}},
                                               color={0,0,127}));
  connect(switch5.y, QGen)
    annotation (Line(points={{101,-100},{150,-100}},
                                                   color={0,0,127}));
  connect(opeModBas.mFue_flow, switch3.u3) annotation (Line(points={{1,-4},{20,-4},
          {20,12},{78,12}},             color={0,0,127}));
  connect(opeModWarUpEngTem.mFue_flow, switch3.u1) annotation (Line(points={{1,-48},
          {40,-48},{40,28},{78,28}},         color={0,0,127}));
  connect(opeModBas.mAir_flow, switch4.u3) annotation (Line(points={{1,-10},{60,
          -10},{60,-48},{78,-48}},
                                color={0,0,127}));
  connect(opeModWarUpEngTem.mAir_flow, switch4.u1) annotation (Line(points={{1,-52},
          {50,-52},{50,-32},{78,-32}},       color={0,0,127}));
  connect(opeModWarUpEngTem.QGen, switch5.u1) annotation (Line(points={{1,-56},{
          40,-56},{40,-92},{78,-92}},     color={0,0,127}));
  connect(opeModBas.QGen, switch5.u3) annotation (Line(points={{1,-16},{20,-16},
          {20,-108},{78,-108}},                  color={0,0,127}));
  connect(Troo.y, opeModWarUpEngTem.TRoo)
    annotation (Line(points={{-59,-80},{-40,-80},{-40,-52},{-21,-52}},
                                                       color={0,0,127}));
  connect(assFue.mFue_flow, switch3.y) annotation (Line(points={{118,50},{110,
          50},{110,20},{101,20}},
                              color={0,0,127}));
  connect(mWat_flow, opeModWarUpEngTem.mWat_flow) annotation (Line(points={{-160,
          -60},{-80,-60},{-80,-44.2},{-21,-44.2}},   color={0,0,127}));
  annotation (
    defaultComponentName="eneCon",
    Diagram(coordinateSystem(extent={{-140,-120},{140,120}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
The model defines energy conversion that occurs during the normal mode and warm-up mode. The model <a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.OperModeWarmUpEngTem\">
Buildings.Fluid.CHPs.BaseClasses.OperModeWarmUpEngTem</a> is used only for the warm-up mode dependent on the engine temperature. 
The model <a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.OperModeBasic\">
Buildings.Fluid.CHPs.BaseClasses.OperModeBasic</a> is used for all other cases (the normal mode and warm-up mode based on a time delay).
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
