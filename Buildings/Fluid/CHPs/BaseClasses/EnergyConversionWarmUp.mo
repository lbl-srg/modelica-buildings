within Buildings.Fluid.CHPs.BaseClasses;
model EnergyConversionWarmUp
  "Energy conversion during warm-up mode based on engine temperature"
  extends Modelica.Blocks.Icons.Block;

  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-80,340},{-60,360}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput mWat_flow(
    final unit="kg/s",
    final quantity="MassFlowRate") "Water mass flow rate"
    annotation (Placement(transformation(extent={{-140,220},{-100,260}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWatIn(
    final unit="K",
    displayUnit="degC") "Water inlet temperature"
    annotation (Placement(transformation(extent={{-140,180},{-100,220}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRoo(
    final unit="K",
    displayUnit="degC") "Room temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEng(
    final unit="K",
    displayUnit="degC") "Engine temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PEleNet(
    final unit="W") "Electric power generation"
    annotation (Placement(transformation(extent={{540,320},{580,360}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mFue_flow(
    final unit="kg/s",
    final quantity="MassFlowRate") "Fuel mass flow rate"
    annotation (Placement(transformation(extent={{540,280},{580,320}}),
      iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mAir_flow(
    final unit="kg/s",
    final quantity="MassFlowRate") "Air mass flow rate"
    annotation (Placement(transformation(extent={{540,220},{580,260}}),
      iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QGen_flow(final unit="W")
    "Heat generation rate within the engine"
    annotation (Placement(transformation(extent={{540,140},{580,180}}),
      iconTransformation(extent={{100,-100},{140,-60}})));

protected
  Buildings.Utilities.Math.SmoothMax smoothMax(
    final deltaX=0.5)
    "Prevent negative value if room temperature exceeds engine nominal temperature"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Buildings.Utilities.Math.SmoothMax smoothMax2(
    final deltaX=0.5)
    "Prevent zero in denominator"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis temChe(
    final uLow=4.8,
    final uHigh=5.2)
    "Check if room temperature is not close to the nominal engine temperature by less than 5 Kelvin"
    annotation (Placement(transformation(extent={{40,130},{60,150}})));
  Buildings.Fluid.CHPs.BaseClasses.EfficiencyCurve etaE(
    final a=per.coeEtaE) "Part load electrical efficiency"
    annotation (Placement(transformation(extent={{-20,230},{0,250}})));
  Buildings.Controls.OBC.CDL.Reals.Divide QGroMax
    "Gross heat input into the system"
    annotation (Placement(transformation(extent={{40,250},{60,270}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant PEleMax(
    final k=per.PEleMax) "Maximum power"
    annotation (Placement(transformation(extent={{-80,290},{-60,310}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter maxFueFlo(
    final k=per.rFue) "Maximum fuel mass flow rate"
    annotation (Placement(transformation(extent={{320,250},{340,270}})));
  Buildings.Controls.OBC.CDL.Reals.Min fueFlo "Fuel flow"
    annotation (Placement(transformation(extent={{380,130},{400,150}})));
  Buildings.Controls.OBC.CDL.Reals.Divide division
    "First input divided by second input"
    annotation (Placement(transformation(extent={{140,30},{160,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TEngNom(
    y(final unit="K", displayUnit="degC"),
    final k=per.TEngNom) "Nominal engine temperature"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    "Difference between nominal engine temperature and room temperature"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant min1(final k=1)
    "Prevent negative value if room temperature exceeds engine nominal temperature"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gain(final k=per.kF)
    "Gain by factor of warm-up fuel coefficient"
    annotation (Placement(transformation(extent={{200,30},{220,50}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2 "Add up two inputs"
    annotation (Placement(transformation(extent={{260,-10},{280,10}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply unlFueFloWarUp
    "Unlimited fuel mass flow rate during warm-up"
    annotation (Placement(transformation(extent={{320,30},{340,50}})));
  Buildings.Fluid.CHPs.BaseClasses.EfficiencyCurve etaQ(
    final a=per.coeEtaQ) "Part load thermal efficiency"
    annotation (Placement(transformation(extent={{-20,180},{0,200}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply heaGen
    "Heat generation within the engine"
    annotation (Placement(transformation(extent={{500,150},{520,170}})));
  Buildings.Controls.OBC.CDL.Reals.Divide division1
    "First input divided by second input"
    annotation (Placement(transformation(extent={{200,80},{220,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant powCoe(
    final k=per.kP) "Warm-up power coefficient"
    annotation (Placement(transformation(extent={{140,110},{160,130}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply PEleNet1
    "Generated electrical power"
    annotation (Placement(transformation(extent={{260,330},{280,350}})));
  Buildings.Utilities.Math.Polynomial masFloAir(final a=per.coeMasAir)
    "Air mass flow rate"
    annotation (Placement(transformation(extent={{500,230},{520,250}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant min2(final k=1)
    "Prevent zero  in denominator"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Room temperature is too close to the nominal engine temperature, simulation should be aborted")
    "Assert function for checking room temperature"
    annotation (Placement(transformation(extent={{80,130},{100,150}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter masFloFue(final k=1
        /per.LHVFue) "Fuel mass flow rate computation"
    annotation (Placement(transformation(extent={{80,250},{100,270}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter heaGro(final k=per.LHVFue)
    "Gross heat input into the system"
    annotation (Placement(transformation(extent={{440,130},{460,150}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub2
    "Difference between room temperature and engine temperature"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

equation
  connect(PEleMax.y, etaE.PNet) annotation (Line(points={{-58,300},{-40,300},{-40,
          246},{-22,246}}, color={0,0,127}));
  connect(QGroMax.u1,PEleMax. y) annotation (Line(points={{38,266},{-40,266},{-40,
          300},{-58,300}},      color={0,0,127}));
  connect(etaE.TWatIn, TWatIn) annotation (Line(points={{-22,234},{-80,234},{-80,
          200},{-120,200}}, color={0,0,127}));
  connect(etaE.mWat_flow, mWat_flow) annotation (Line(points={{-22,240},
          {-120,240}}, color={0,0,127}));
  connect(etaE.eta, QGroMax.u2) annotation (Line(points={{2,240},{20,240},{20,254},
          {38,254}}, color={0,0,127}));
  connect(TEngNom.y, sub1.u1) annotation (Line(points={{-58,100},{-40,100},
          {-40,86},{-22,86}}, color={0,0,127}));
  connect(sub1.u2, TRoo) annotation (Line(points={{-22,74},{-40,74},{-40,40},{-120,
          40}}, color={0,0,127}));
  connect(division.y, gain.u) annotation (Line(points={{162,40},{198,40}},
          color={0,0,127}));
  connect(gain.y, add2.u1) annotation (Line(points={{222,40},{240,40},{240,6},{258,
          6}}, color={0,0,127}));
  connect(add2.y, unlFueFloWarUp.u2) annotation (Line(points={{282,0},{300,0},{300,
          34},{318,34}}, color={0,0,127}));
  connect(etaQ.PNet,PEleMax. y) annotation (Line(points={{-22,196},{-40,196},{-40,
          300},{-58,300}}, color={0,0,127}));
  connect(etaQ.mWat_flow, mWat_flow) annotation (Line(points={{-22,190},{-60,190},
          {-60,240},{-120,240}}, color={0,0,127}));
  connect(etaQ.TWatIn, TWatIn) annotation (Line(points={{-22,184},{-80,184},
          {-80,200},{-120,200}}, color={0,0,127}));
  connect(etaQ.eta, heaGen.u1) annotation (Line(points={{2,190},{480,190},{480,166},
          {498,166}}, color={0,0,127}));
  connect(maxFueFlo.y, fueFlo.u1) annotation (Line(points={{342,260},{360,260},{
          360,146},{378,146}}, color={0,0,127}));
  connect(unlFueFloWarUp.y, fueFlo.u2) annotation (Line(points={{342,40},{360,40},
          {360,134},{378,134}}, color={0,0,127}));
  connect(division1.u1,powCoe. y) annotation (Line(points={{198,96},{180,96},
          {180,120},{162,120}}, color={0,0,127}));
  connect(division1.u2, division.y) annotation (Line(points={{198,84},{180,84},{
          180,40},{162,40}},  color={0,0,127}));
  connect(PEleNet1.u1, PEleMax.y) annotation (Line(points={{258,346},{-40,346},{
          -40,300},{-58,300}}, color={0,0,127}));
  connect(PEleNet1.y, PEleNet) annotation (Line(points={{282,340},{560,340}},
          color={0,0,127}));
  connect(heaGen.y, QGen_flow)
    annotation (Line(points={{522,160},{560,160}}, color={0,0,127}));
  connect(fueFlo.y, mFue_flow) annotation (Line(points={{402,140},{420,140},{420,
          300},{560,300}}, color={0,0,127}));
  connect(masFloAir.y, mAir_flow) annotation (Line(points={{521,240},{560,240}},
          color={0,0,127}));
  connect(min1.y, smoothMax.u2) annotation (Line(points={{42,40},{60,40},{60,54},
          {78,54}}, color={0,0,127}));
  connect(sub1.y, smoothMax.u1) annotation (Line(points={{2,80},{20,80},{20,66},
          {78,66}}, color={0,0,127}));
  connect(smoothMax.y, division.u1) annotation (Line(points={{101,60},{120,60},{
          120,46},{138,46}}, color={0,0,127}));
  connect(min2.y, smoothMax2.u2) annotation (Line(points={{42,-40},{60,-40},{60,
          -6},{78,-6}}, color={0,0,127}));
  connect(smoothMax2.y, division.u2) annotation (Line(points={{101,0},{120,0},{120,
          34},{138,34}}, color={0,0,127}));
  connect(temChe.u, sub1.y) annotation (Line(points={{38,140},{20,140},{20,80},{
          2,80}}, color={0,0,127}));
  connect(division1.y, PEleNet1.u2) annotation (Line(points={{222,90},{240,90},{
          240,334},{258,334}},  color={0,0,127}));
  connect(temChe.y, assMes.u) annotation (Line(points={{62,140},{78,140}},
          color={255,0,255}));
  connect(min2.y, add2.u2) annotation (Line(points={{42,-40},{240,-40},{240,-6},
          {258,-6}}, color={0,0,127}));
  connect(fueFlo.y,masFloAir. u) annotation (Line(points={{402,140},{420,140},{420,
          240},{498,240}}, color={0,0,127}));
  connect(QGroMax.y, masFloFue.u)
    annotation (Line(points={{62,260},{78,260}}, color={0,0,127}));
  connect(masFloFue.y, maxFueFlo.u)
    annotation (Line(points={{102,260},{318,260}}, color={0,0,127}));
  connect(masFloFue.y, unlFueFloWarUp.u1) annotation (Line(points={{102,260},{300,
          260},{300,46},{318,46}}, color={0,0,127}));
  connect(heaGro.y, heaGen.u2) annotation (Line(points={{462,140},{480,140},{480,
          154},{498,154}}, color={0,0,127}));
  connect(fueFlo.y, heaGro.u)
    annotation (Line(points={{402,140},{438,140}}, color={0,0,127}));
  connect(TRoo, sub2.u2) annotation (Line(points={{-120,40},{-40,40},{-40,-6},{-22,
          -6}}, color={0,0,127}));
  connect(TEng, sub2.u1) annotation (Line(points={{-120,-40},{-60,-40},{-60,6},{
          -22,6}}, color={0,0,127}));
  connect(sub2.y, smoothMax2.u1)
    annotation (Line(points={{2,0},{60,0},{60,6},{78,6}}, color={0,0,127}));

annotation (
  defaultComponentName="opeModWarUpEngTem",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{540,380}})),
  Documentation(info="<html>
<p>
The model defines energy conversion for the warm-up mode that is dependent on the
engine temperature (e.g. CHPs with Stirling engines).
The engine fuel flow rate is a function of the fuel flow rate at the maximum power
output, as well as the difference between the nominal engine temperature and the
actual engine temperature.
Energy conversion from fuel to the electric power and heat is modeled using
system's part-load electrical and thermal efficiencies, based on the empirical
data from the manufacturer.
The curves are described by a fifth order polynomial, a function of the electric
power, water flow rate and water inlet temperature.
The air flow rate is modeled using a second order polynomial, a function of
the fuel flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
June 1, 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnergyConversionWarmUp;
