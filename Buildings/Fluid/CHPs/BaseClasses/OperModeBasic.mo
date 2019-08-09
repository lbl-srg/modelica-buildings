within Buildings.Fluid.CHPs.BaseClasses;
model OperModeBasic "Energy conversion for a typical CHP operation"
  extends Modelica.Blocks.Icons.Block;
  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-98,-98},{-78,-78}})));

  Modelica.Blocks.Interfaces.RealInput PEle(unit="W") "Electric power"
    annotation (Placement(transformation(extent={{-138,100},{-98,140}}),
        iconTransformation(extent={{-120,50},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput mWat_flow(unit="kg/s") "Water flow rate"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput TWatIn(unit="K")
    "Water inlet temperature" annotation (Placement(transformation(extent={{-140,
            -36},{-100,4}}), iconTransformation(extent={{-120,-70},{-100,-50}})));
  Modelica.Blocks.Interfaces.RealOutput mFue_flow(unit="kg/s") "Fuel flow rate"
    annotation (Placement(transformation(extent={{180,126},{200,146}}),
        iconTransformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput mAir_flow(unit="kg/s") "Air flow rate"
    annotation (Placement(transformation(extent={{180,72},{200,92}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput QGen(unit="W")
    "Heat generation within the engine" annotation (Placement(transformation(
          extent={{180,-14},{200,6}}), iconTransformation(extent={{100,-70},{120,
            -50}})));

  CHPs.BaseClasses.EfficiencyCurve etaE(a=per.coeEtaE)
    "Part load electrical efficiency"
    annotation (Placement(transformation(extent={{2,74},{22,94}})));
  CHPs.BaseClasses.EfficiencyCurve etaQ(a=per.coeEtaQ)
    "Part load thermal efficiency"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Modelica.Blocks.Math.Division QGro "Gross heat input into the system"
    annotation (Placement(transformation(extent={{42,120},{62,140}})));
protected
  Modelica.Blocks.Math.Product QGen1 "Heat generation within the engine"
    annotation (Placement(transformation(extent={{80,-14},{100,6}})));
  Modelica.Blocks.Sources.Constant const(k=1/per.LHVFue)
    annotation (Placement(transformation(extent={{42,156},{62,176}})));
  Modelica.Blocks.Math.Product mFue_flow1 "Fuel flow rate"
    annotation (Placement(transformation(extent={{110,126},{130,146}})));
  Buildings.Utilities.Math.Polynominal mAir_flow1(a=per.coeMasAir)
    "Air flow rate"
    annotation (Placement(transformation(extent={{150,72},{170,92}})));

equation
  connect(QGro.u1, PEle) annotation (Line(points={{40,136},{-60,136},{-60,120},{
          -118,120}}, color={0,0,127}));
  connect(QGro.y, QGen1.u1)
    annotation (Line(points={{63,130},{78,130},{78,2}}, color={0,0,127}));
  connect(QGen1.y, QGen)
    annotation (Line(points={{101,-4},{190,-4}}, color={0,0,127}));
  connect(QGen, QGen)
    annotation (Line(points={{190,-4},{190,-4}}, color={0,0,127}));
  connect(QGro.y, mFue_flow1.u2)
    annotation (Line(points={{63,130},{108,130}}, color={0,0,127}));
  connect(const.y, mFue_flow1.u1) annotation (Line(points={{63,166},{92,166},{92,
          142},{108,142}}, color={0,0,127}));
  connect(mFue_flow1.y, mFue_flow)
    annotation (Line(points={{131,136},{190,136}}, color={0,0,127}));
  connect(mAir_flow1.u, mFue_flow1.y) annotation (Line(points={{148,82},{140,82},
          {140,136},{131,136}}, color={0,0,127}));
  connect(mAir_flow1.y, mAir_flow)
    annotation (Line(points={{171,82},{190,82}}, color={0,0,127}));
  connect(etaE.TWatIn, TWatIn) annotation (Line(points={{0,78},{-18,78},{-18,-16},
          {-120,-16}}, color={0,0,127}));
  connect(etaE.PNet, PEle) annotation (Line(points={{0,90},{-60,90},{-60,120},{-118,
          120}}, color={0,0,127}));
  connect(etaQ.PNet, PEle) annotation (Line(points={{-2,-4},{-32,-4},{-32,120},{
          -118,120}}, color={0,0,127}));
  connect(mWat_flow, etaE.mWat_flow) annotation (Line(points={{-120,60},{-60,60},
          {-60,84},{0,84}}, color={0,0,127}));
  connect(etaQ.mWat_flow, mWat_flow) annotation (Line(points={{-2,-10},{-60,-10},
          {-60,60},{-120,60}}, color={0,0,127}));
  connect(etaQ.TWatIn, TWatIn)
    annotation (Line(points={{-2,-16},{-120,-16}}, color={0,0,127}));
  connect(etaE.eta, QGro.u2) annotation (Line(points={{23,84},{32,84},{32,124},{
          40,124}}, color={0,0,127}));
  connect(etaQ.eta, QGen1.u2)
    annotation (Line(points={{21,-10},{78,-10}}, color={0,0,127}));
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
