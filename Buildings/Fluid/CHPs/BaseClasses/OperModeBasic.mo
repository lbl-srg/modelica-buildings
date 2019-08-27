within Buildings.Fluid.CHPs.BaseClasses;
model OperModeBasic "Energy conversion for a typical CHP operation"
  extends Modelica.Blocks.Icons.Block;
  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-98,-98},{-78,-78}})));
  Modelica.Blocks.Interfaces.RealInput PEle(unit="W") "Electric power"
    annotation (Placement(transformation(extent={{-140,130},{-100,170}}),
        iconTransformation(extent={{-120,50},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput mWat_flow(unit="kg/s") "Water flow rate"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput TWatIn(unit="K")
    "Water inlet temperature" annotation (Placement(transformation(extent={{-140,
            -36},{-100,4}}), iconTransformation(extent={{-120,-70},{-100,-50}})));
  Modelica.Blocks.Interfaces.RealOutput mFue_flow(unit="kg/s") "Fuel flow rate"
    annotation (Placement(transformation(extent={{180,140},{200,160}}),
        iconTransformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput mAir_flow(unit="kg/s") "Air flow rate"
    annotation (Placement(transformation(extent={{180,70},{200,90}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput QGen(unit="W")
    "Heat generation within the engine" annotation (Placement(transformation(
          extent={{180,10},{200,30}}), iconTransformation(extent={{100,-70},{120,
            -50}})));
  CHPs.BaseClasses.EfficiencyCurve etaE(a=per.coeEtaE)
    "Part load electrical efficiency"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  CHPs.BaseClasses.EfficiencyCurve etaQ(a=per.coeEtaQ)
    "Part load thermal efficiency"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Modelica.Blocks.Math.Division QGro "Gross heat input into the system"
    annotation (Placement(transformation(extent={{20,120},{40,140}})));
protected
  Modelica.Blocks.Math.Product QGen1 "Heat generation within the engine"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Modelica.Blocks.Sources.Constant const(k=1/per.LHVFue)
    annotation (Placement(transformation(extent={{20,160},{40,180}})));
  Modelica.Blocks.Math.Product mFue_flow1 "Fuel flow rate"
    annotation (Placement(transformation(extent={{80,140},{100,160}})));
  Buildings.Utilities.Math.Polynominal mAir_flow1(a=per.coeMasAir)
    "Air flow rate"
    annotation (Placement(transformation(extent={{140,70},{160,90}})));
equation
  connect(QGro.u1, PEle) annotation (Line(points={{18,136},{-70,136},{-70,150},
          {-120,150}},color={0,0,127}));
  connect(QGen1.y, QGen)
    annotation (Line(points={{121,20},{190,20}}, color={0,0,127}));
  connect(QGen, QGen)
    annotation (Line(points={{190,20},{190,20}}, color={0,0,127}));
  connect(QGro.y, mFue_flow1.u2)
    annotation (Line(points={{41,130},{60,130},{60,144},{78,144}},
                                                  color={0,0,127}));
  connect(const.y, mFue_flow1.u1) annotation (Line(points={{41,170},{60,170},{
          60,156},{78,156}},
                           color={0,0,127}));
  connect(mFue_flow1.y, mFue_flow)
    annotation (Line(points={{101,150},{190,150}}, color={0,0,127}));
  connect(mAir_flow1.u, mFue_flow1.y) annotation (Line(points={{138,80},{120,80},
          {120,150},{101,150}}, color={0,0,127}));
  connect(mAir_flow1.y, mAir_flow)
    annotation (Line(points={{161,80},{190,80}}, color={0,0,127}));
  connect(etaE.TWatIn, TWatIn) annotation (Line(points={{-42,84},{-60,84},{-60,
          -16},{-120,-16}},
                       color={0,0,127}));
  connect(etaE.PNet, PEle) annotation (Line(points={{-42,96},{-70,96},{-70,150},
          {-120,150}},
                 color={0,0,127}));
  connect(etaQ.PNet, PEle) annotation (Line(points={{-42,-4},{-70,-4},{-70,150},
          {-120,150}},color={0,0,127}));
  connect(mWat_flow, etaE.mWat_flow) annotation (Line(points={{-120,90},{-42,90}},
                            color={0,0,127}));
  connect(etaQ.mWat_flow, mWat_flow) annotation (Line(points={{-42,-10},{-80,
          -10},{-80,90},{-120,90}},
                               color={0,0,127}));
  connect(etaQ.TWatIn, TWatIn)
    annotation (Line(points={{-42,-16},{-120,-16}},color={0,0,127}));
  connect(etaE.eta, QGro.u2) annotation (Line(points={{-19,90},{0,90},{0,124},{
          18,124}}, color={0,0,127}));
  connect(etaQ.eta, QGen1.u2)
    annotation (Line(points={{-19,-10},{60,-10},{60,14},{98,14}},
                                                 color={0,0,127}));
  connect(QGro.y, QGen1.u1) annotation (Line(points={{41,130},{60,130},{60,26},
          {98,26}}, color={0,0,127}));
  annotation (
    defaultComponentName="opeModBas",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{180,
            200}})),
    Documentation(info="<html>
<p>
The model defines energy conversion for a typical CHP operation that includes the normal mode and warm-up mode based on the time delay (CHPs with internal combustion engines). 
Energy conversion from fuel to the electric power and heat is modeled using system's part-load electrical and thermal efficiencies, based on the empirical data from the manufacturer. 
The curves are described by a 2nd order polynomial, a function of the electric power, water flow rate and water inlet temperature. 
The air flow rate is also modeled using a 2nd order polynomial, a function of the fuel flow rate. 
</p>
</html>", revisions="<html>
<ul>
<li>
June 01, 2019 by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end OperModeBasic;
