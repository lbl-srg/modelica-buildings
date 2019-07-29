within Buildings.Fluid.CHPs.BaseClasses;
model OperModeWarmUpEngTem "Energy conversion during warm-up by engine temperature"
  extends Modelica.Blocks.Icons.Block;
  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-98,-98},{-78,-78}})));

  Modelica.Blocks.Interfaces.RealInput mWat_flow(unit="kg/s") "Water flow rate"
    annotation (Placement(transformation(extent={{-138,220},{-98,260}}),
        iconTransformation(extent={{-120,48},{-100,68}})));
  Modelica.Blocks.Interfaces.RealInput TWatIn(unit="K")
    "Water inlet temperature" annotation (Placement(transformation(extent={{-140,
            180},{-100,220}}), iconTransformation(extent={{-120,10},{-100,30}})));
  Modelica.Blocks.Interfaces.RealInput TRoo(unit="K") "Room temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-120,-30},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealInput TEng(unit="K") "Engine temperature"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
        iconTransformation(extent={{-120,-70},{-100,-50}})));
  Modelica.Blocks.Interfaces.RealOutput PEleNet(unit="W")
    "Electric power generation" annotation (Placement(transformation(extent={{540,
            324},{560,344}}), iconTransformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput mFue_flow(unit="kg/s") "Fuel flow rate"
    annotation (Placement(transformation(extent={{540,290},{560,310}}),
        iconTransformation(extent={{100,10},{120,30}})));
  Modelica.Blocks.Interfaces.RealOutput mAir_flow(unit="kg/s") "Air flow rate"
    annotation (Placement(transformation(extent={{540,252},{560,272}}),
        iconTransformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealOutput QGen(unit="W")
    "Heat generation within the engine" annotation (Placement(transformation(
          extent={{540,144},{560,164}}), iconTransformation(extent={{100,-70},{120,
            -50}})));

protected
  Buildings.Utilities.Math.SmoothMax smoothMax(deltaX=0.5)
    "Prevent nagative value if room temperature exceeds engine nominal temperature"
    annotation (Placement(transformation(extent={{80,56},{100,76}})));
  Buildings.Utilities.Math.SmoothMax smoothMax2(deltaX=0.5)
    "Prevent zero  in denominator"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));
  Modelica.Blocks.Logical.GreaterThreshold
                                        greaterThreshold(threshold=5)
    annotation (Placement(transformation(extent={{40,140},{60,160}})));
  CHPs.BaseClasses.EfficiencyCurve etaE(a=per.coeEtaE)
    "Part load electrical efficiency"
    annotation (Placement(transformation(extent={{-20,230},{0,250}})));
  Modelica.Blocks.Math.Division QGroMax "Gross heat input into the system"
    annotation (Placement(transformation(extent={{20,250},{40,270}})));
  Modelica.Blocks.Sources.Constant const(k=1/per.LHVFue)
    annotation (Placement(transformation(extent={{20,286},{40,306}})));
  Modelica.Blocks.Math.Product mFueMax_flow "Maximum fuel flow rate"
    annotation (Placement(transformation(extent={{82,256},{102,276}})));
  Modelica.Blocks.Sources.Constant PEleMax(k=per.PEleMax) "Maximum power"
    annotation (Placement(transformation(extent={{-80,256},{-60,276}})));
  Modelica.Blocks.Math.Add add(k2=-1)
    annotation (Placement(transformation(extent={{-20,-4},{0,-24}})));
  Modelica.Blocks.Math.Gain mFueWarUpMax(k=per.rFue)
    "Maxmimum fuel flow"
    annotation (Placement(transformation(extent={{318,256},{338,276}})));
  Modelica.Blocks.Math.Min mFueWarUp "Fuel flow"
    annotation (Placement(transformation(extent={{380,118},{400,138}})));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Modelica.Blocks.Sources.Constant TEngNom(k=per.TEngNom)
    "Nominal engine temperature"
    annotation (Placement(transformation(extent={{-80,68},{-60,88}})));
  Modelica.Blocks.Math.Add add1(k2=-1)
    annotation (Placement(transformation(extent={{-20,62},{0,82}})));
  Modelica.Blocks.Sources.Constant min1(k=1)
    "Prevent nagative value if room temperature exceeds engine nominal temperature"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Blocks.Math.Gain gain(k=per.kF)
    annotation (Placement(transformation(extent={{160,20},{180,40}})));
  Modelica.Blocks.Math.Add add2
    annotation (Placement(transformation(extent={{202,-6},{222,14}})));
  Modelica.Blocks.Sources.Constant const1(k=1)
    annotation (Placement(transformation(extent={{160,-12},{180,8}})));
  Modelica.Blocks.Math.Product mFueWarUpUnl
    "Unlimited fuel flow during warm up"
    annotation (Placement(transformation(extent={{320,0},{340,20}})));
  Modelica.Blocks.Sources.Constant LHVFue(k=per.LHVFue)
    "Lower heating value of the fuel"
    annotation (Placement(transformation(extent={{380,78},{400,98}})));
  Modelica.Blocks.Math.Product QGro "Gross heat input into the system"
    annotation (Placement(transformation(extent={{420,98},{440,118}})));
  CHPs.BaseClasses.EfficiencyCurve etaQ(a=per.coeEtaQ)
    "Part load thermal efficiency"
    annotation (Placement(transformation(extent={{-20,196},{0,216}})));
  Modelica.Blocks.Math.Product QGen1 "Heat generation within the engine"
    annotation (Placement(transformation(extent={{482,144},{502,164}})));
  Modelica.Blocks.Math.Division division1
    annotation (Placement(transformation(extent={{160,100},{180,120}})));
  Modelica.Blocks.Sources.Constant const2(k=per.kP)
    annotation (Placement(transformation(extent={{120,106},{140,126}})));
  Modelica.Blocks.Math.Product PEleNet1 "Generated electrical power"
    annotation (Placement(transformation(extent={{260,324},{280,344}})));
  Buildings.Utilities.Math.Polynominal mAir_flow1(a=per.coeMasAir)
    "Air flow rate"
    annotation (Placement(transformation(extent={{480,252},{500,272}})));
  Modelica.Blocks.Sources.Constant min2(k=1)
    "Prevent zero  in denominator"
    annotation (Placement(transformation(extent={{20,-44},{40,-24}})));
  Controls.OBC.CDL.Utilities.Assert assMes(message="Room temperature is too close to the nominal engine temperature, simulation should be aborted")
    "Assert function for checking room temperature"
    annotation (Placement(transformation(extent={{82,140},{102,160}})));
equation
  connect(QGroMax.y, mFueMax_flow.u2)
    annotation (Line(points={{41,260},{80,260}}, color={0,0,127}));
  connect(const.y, mFueMax_flow.u1) annotation (Line(points={{41,296},{60,296},{
          60,272},{80,272}}, color={0,0,127}));
  connect(PEleMax.y, etaE.PNet) annotation (Line(points={{-59,266},{-40,266},{-40,
          246},{-22,246}}, color={0,0,127}));
  connect(QGroMax.u1,PEleMax. y)
    annotation (Line(points={{18,266},{-59,266}}, color={0,0,127}));
  connect(etaE.TWatIn, TWatIn) annotation (Line(points={{-22,234},{-80,234},{-80,
          200},{-120,200}}, color={0,0,127}));
  connect(etaE.mWat_flow, mWat_flow)
    annotation (Line(points={{-22,240},{-118,240}}, color={0,0,127}));
  connect(etaE.eta, QGroMax.u2) annotation (Line(points={{1,240},{10,240},{10,
          254},{18,254}}, color={0,0,127}));
  connect(add.u2, TRoo) annotation (Line(points={{-22,-8},{-40,-8},{-40,40},{-120,
          40}}, color={0,0,127}));
  connect(TEngNom.y, add1.u1)
    annotation (Line(points={{-59,78},{-22,78}}, color={0,0,127}));
  connect(add1.u2, TRoo) annotation (Line(points={{-22,66},{-40,66},{-40,40},{-120,
          40}}, color={0,0,127}));
  connect(division.y, gain.u)
    annotation (Line(points={{141,30},{158,30}}, color={0,0,127}));
  connect(gain.y, add2.u1) annotation (Line(points={{181,30},{186,30},{186,10},{
          200,10}}, color={0,0,127}));
  connect(const1.y, add2.u2)
    annotation (Line(points={{181,-2},{200,-2}}, color={0,0,127}));
  connect(add2.y, mFueWarUpUnl.u2)
    annotation (Line(points={{223,4},{318,4}}, color={0,0,127}));
  connect(mFueWarUp.y, QGro.u1) annotation (Line(points={{401,128},{410,128},{410,
          114},{418,114}}, color={0,0,127}));
  connect(LHVFue.y, QGro.u2) annotation (Line(points={{401,88},{410,88},{410,102},
          {418,102}}, color={0,0,127}));
  connect(etaQ.PNet,PEleMax. y) annotation (Line(points={{-22,212},{-40,212},{-40,
          266},{-59,266}}, color={0,0,127}));
  connect(etaQ.mWat_flow, mWat_flow) annotation (Line(points={{-22,206},{-60,206},
          {-60,240},{-118,240}}, color={0,0,127}));
  connect(etaQ.TWatIn, TWatIn)
    annotation (Line(points={{-22,200},{-120,200}}, color={0,0,127}));
  connect(etaQ.eta, QGen1.u1) annotation (Line(points={{1,206},{260,206},{260,
          160},{480,160}}, color={0,0,127}));
  connect(QGro.y, QGen1.u2)
    annotation (Line(points={{441,108},{480,108},{480,148}}, color={0,0,127}));
  connect(mFueMax_flow.y, mFueWarUpMax.u)
    annotation (Line(points={{103,266},{316,266}}, color={0,0,127}));
  connect(mFueWarUpUnl.u1, mFueMax_flow.y) annotation (Line(points={{318,16},{300,
          16},{300,266},{103,266}}, color={0,0,127}));
  connect(mFueWarUpMax.y, mFueWarUp.u1) annotation (Line(points={{339,266},{360,
          266},{360,134},{378,134}}, color={0,0,127}));
  connect(mFueWarUpUnl.y, mFueWarUp.u2) annotation (Line(points={{341,10},{360,10},
          {360,122},{378,122}}, color={0,0,127}));
  connect(division1.u1, const2.y)
    annotation (Line(points={{158,116},{141,116}}, color={0,0,127}));
  connect(division1.u2, division.y) annotation (Line(points={{158,104},{148,104},
          {148,30},{141,30}}, color={0,0,127}));
  connect(PEleNet1.u1, PEleMax.y) annotation (Line(points={{258,340},{-40,
          340},{-40,266},{-59,266}}, color={0,0,127}));
  connect(PEleNet1.y, PEleNet)
    annotation (Line(points={{281,334},{550,334}}, color={0,0,127}));
  connect(QGen1.y, QGen) annotation (Line(points={{503,154},{550,154}},
                      color={0,0,127}));
  connect(mFueWarUp.y, mFue_flow) annotation (Line(points={{401,128},{460,128},
          {460,300},{550,300}},color={0,0,127}));
  connect(mAir_flow1.u, mFue_flow) annotation (Line(points={{478,262},{460,262},
          {460,300},{550,300}}, color={0,0,127}));
  connect(mAir_flow1.y, mAir_flow)
    annotation (Line(points={{501,262},{550,262}}, color={0,0,127}));
  connect(add.u1, TEng) annotation (Line(points={{-22,-20},{-62,-20},{-62,-20},{
          -120,-20}}, color={0,0,127}));
  connect(min1.y, smoothMax.u2) annotation (Line(points={{41,50},{60,50},{60,60},
          {78,60}}, color={0,0,127}));
  connect(add1.y, smoothMax.u1)
    annotation (Line(points={{1,72},{78,72}}, color={0,0,127}));
  connect(smoothMax.y, division.u1) annotation (Line(points={{101,66},{108,66},{
          108,36},{118,36}}, color={0,0,127}));
  connect(add.y, smoothMax2.u1)
    annotation (Line(points={{1,-14},{78,-14}}, color={0,0,127}));
  connect(min2.y, smoothMax2.u2) annotation (Line(points={{41,-34},{60,-34},{60,
          -26},{78,-26}}, color={0,0,127}));
  connect(smoothMax2.y, division.u2) annotation (Line(points={{101,-20},{108,-20},
          {108,24},{118,24}}, color={0,0,127}));
  connect(greaterThreshold.u, add1.y) annotation (Line(points={{38,150},{20,150},
          {20,72},{1,72}}, color={0,0,127}));
  connect(division1.y, PEleNet1.u2) annotation (Line(points={{181,110},{220,110},
          {220,328},{258,328}}, color={0,0,127}));
  connect(greaterThreshold.y, assMes.u)
    annotation (Line(points={{61,150},{80,150}}, color={255,0,255}));
  annotation (
    defaultComponentName="opeModWarUpEngTem",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{540,
            380}})),
    Documentation(info="<html>
<p>
The model defines energy conversion for the warm-up mode that is dependent on the engine temperature (e.g. CHPs with Stirling engines). 
The engine fuel flow rate is a function of the fuel flow rate at the maximum power output, as well as the difference between the nominal engine temperature and the actual engine temperature.   
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
end OperModeWarmUpEngTem;
