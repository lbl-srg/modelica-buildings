within Buildings.Fluid.Storage.Ice_ntu_bis.BaseClasses;
model Qbrine_calc
  Modelica.Blocks.Interfaces.RealInput m_flow
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealInput Tin
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput Ttank
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  UA ua annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Interfaces.RealInput SOC "State of charge"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}})));
    Real eps;
    Real Qbrine_max;

  Modelica.Blocks.Interfaces.RealOutput Qbrine
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  eps = Buildings.Fluid.Storage.Ice_ntu_bis.BaseClasses.calc_NTU(
    ua.UAhx,
    m_flow,
    Tin);
  Qbrine_max = m_flow * Buildings.Media.Antifreeze.Validation.BaseClasses.PropyleneGlycolWater.testSpecificHeatCapacityCp_TX_a(T=(Tin+Ttank)/2, X_a=0.3) * (Tin-Ttank);
  Qbrine = eps * Qbrine_max;

  connect(Tin, ua.Tin) annotation (Line(points={{-120,50},{-50,50},{-50,5},{-42,
          5}},  color={0,0,127}));
  connect(SOC, ua.SOC) annotation (Line(points={{-120,-90},{-60,-90},{-60,-6},{
          -42,-6},{-42,-5}},
                color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Qbrine_calc;
