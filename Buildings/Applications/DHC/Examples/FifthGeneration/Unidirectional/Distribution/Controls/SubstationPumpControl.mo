within Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Distribution.Controls;
model SubstationPumpControl
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  parameter Modelica.SIunits.TemperatureDifference dT = 5
    "Temperature difference in and out";
  parameter Real yMin = 0.01;

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    displayUnit="degC") "District supply water temperature"
    annotation (Placement(transformation(extent={{-200,46},{-160,86}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRet(
    final unit="K",
    displayUnit="degC") "District return water temperature"
    annotation (Placement(transformation(extent={{-200,0},{-160,40}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput modInd "Mode index"
    annotation (Placement(transformation(extent={{-200,90},{-160,130}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealOutput yPum(unit="kg/s") "Pump mass flow rate"
    annotation (Placement(transformation(extent={{160,80},{180,100}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput pumSpe(unit="1") "Pump speed"
    annotation (Placement(transformation(extent={{160,120},{180,140}}),
        iconTransformation(extent={{100,-70},{120,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Gain norMas(final k=m_flow_nominal)
    "Normalization of mass flow rate"
    annotation (Placement(transformation(extent={{120,80},{140,100}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID_dT(
    reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    yMax=1,
    k=0.5,
    Ti=240,
    reverseAction=true,
    yMin=yMin,
    y_reset=0)
    annotation (Placement(transformation(extent={{-40,130},{-20,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Add appHea(k1=-1)
    "Approach temperature for heating mode"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant temDif(k=dT)
    "Temperature difference set point"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID_TMax(
    reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    yMax=1,
    k=0.5,
    Ti=240,
    yMin=yMin,
    y_reset=yMin)
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(k=1, p=dT)
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(k=1, p=(-1)*dT)
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID_TMin(
    reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    yMax=1,
    k=0.5,
    Ti=240,
    reverseAction=true,
    yMin=yMin,
    y_reset=yMin)
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Modelica.Blocks.Sources.BooleanExpression noLoa(y=modInd == 0)
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  Modelica.Blocks.Sources.BooleanExpression cooModFla(y=modInd == -1)
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Modelica.Blocks.Sources.BooleanExpression heaModFla(y=modInd == 1)
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax cooModCon(nin=2)
    "Control output when in cooling mode"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax heaModCon(nin=2)
    "Control output when in heating mode"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch pumConWitLoa
    "Pump modulation control when there is load"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch pumCon "Pump modulation control"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{20,130},{40,150}})));

equation
  connect(norMas.y, yPum)
    annotation (Line(points={{142,90},{170,90}}, color={0,0,127}));
  connect(appHea.y,abs. u)
    annotation (Line(points={{-98,60},{-82,60}}, color={0,0,127}));
  connect(abs.y,conPID_dT. u_m)
    annotation (Line(points={{-58,60},{-30,60},{-30,128}}, color={0,0,127}));
  connect(temDif.y,conPID_dT. u_s)
    annotation (Line(points={{-118,140},{-42,140}}, color={0,0,127}));
  connect(addPar.y,conPID_TMax. u_s)
    annotation (Line(points={{-98,-10},{-42,-10}},color={0,0,127}));
  connect(not1.y,conPID_TMax. trigger)
    annotation (Line(points={{-58,20},{-50,20},{-50,-32},{-38,-32},{-38,-22}},
      color={255,0,255}));
  connect(addPar1.y,conPID_TMin. u_s)
    annotation (Line(points={{-98,-90},{-42,-90}},color={0,0,127}));
  connect(not2.y,conPID_TMin. trigger)
    annotation (Line(points={{-58,-60},{-50,-60},{-50,-110},{-38,-110},{-38,
          -102}},
      color={255,0,255}));
  connect(noLoa.y,conPID_dT. trigger)
    annotation (Line(points={{-119,110},{-38,110},{-38,128}}, color={255,0,255}));
  connect(cooModFla.y,not1. u)
    annotation (Line(points={{-99,20},{-82,20}}, color={255,0,255}));
  connect(heaModFla.y,not2. u)
    annotation (Line(points={{-99,-60},{-82,-60}}, color={255,0,255}));
  connect(conPID_dT.y,cooModCon. u[1])
    annotation (Line(points={{-18,140},{0,140},{0,-9},{18,-9}}, color={0,0,127}));
  connect(conPID_TMax.y,cooModCon. u[2])
    annotation (Line(points={{-18,-10},{0,-10},{0,-11},{18,-11}}, color={0,0,127}));
  connect(conPID_dT.y,heaModCon. u[1])
    annotation (Line(points={{-18,140},{0,140},{0,-89},{18,-89}},  color={0,0,127}));
  connect(conPID_TMin.y,heaModCon. u[2])
    annotation (Line(points={{-18,-90},{0,-90},{0,-91},{18,-91}},
      color={0,0,127}));
  connect(not1.y, pumConWitLoa.u2)
    annotation (Line(points={{-58,20},{78,20}}, color={255,0,255}));
  connect(cooModCon.y, pumConWitLoa.u3)
    annotation (Line(points={{42,-10},{60,-10},{60,12},{78,12}}, color={0,0,127}));
  connect(heaModCon.y, pumConWitLoa.u1)
    annotation (Line(points={{42,-90},{52,-90},{52,28},{78,28}}, color={0,0,127}));
  connect(TSup, appHea.u1)
    annotation (Line(points={{-180,66},{-122,66}}, color={0,0,127}));
  connect(TRet, appHea.u2)
    annotation (Line(points={{-180,20},{-132,20},{-132,54},{-122,54}}, color={0,0,127}));
  connect(TSup, addPar.u)
    annotation (Line(points={{-180,66},{-140,66},{-140,-10},{-122,-10}},
      color={0,0,127}));
  connect(TRet, conPID_TMax.u_m)
    annotation (Line(points={{-180,20},{-132,20},{-132,-40},{-30,-40},{-30,-22}},
      color={0,0,127}));
  connect(TSup, addPar1.u)
    annotation (Line(points={{-180,66},{-140,66},{-140,-90},{-122,-90}}, color={0,0,127}));
  connect(TRet, conPID_TMin.u_m)
    annotation (Line(points={{-180,20},{-132,20},{-132,-120},{-30,-120},{-30,-102}},
      color={0,0,127}));
  connect(noLoa.y, pumCon.u2)
    annotation (Line(points={{-119,110},{-20,110},{-20,90},{78,90}}, color={255,0,255}));
  connect(con.y, pumCon.u1)
    annotation (Line(points={{42,140},{60,140},{60,98},{78,98}}, color={0,0,127}));
  connect(pumCon.y, norMas.u)
    annotation (Line(points={{102,90},{118,90}}, color={0,0,127}));
  connect(pumCon.y, pumSpe)
    annotation (Line(points={{102,90},{110,90},{110,130},{170,130}},  color={0,0,127}));
  connect(pumConWitLoa.y, pumCon.u3)
    annotation (Line(points={{102,20},{120,20},{120,40},{60,40},{60,82},{78,82}},
      color={0,0,127}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{160,160}})));
end SubstationPumpControl;
