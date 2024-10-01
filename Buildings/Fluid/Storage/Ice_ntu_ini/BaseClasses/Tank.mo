within Buildings.Fluid.Storage.Ice_ntu_ini.BaseClasses;
model Tank
  Modelica.Blocks.Interfaces.RealInput m_flow
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealInput Tin
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));

  replaceable parameter Buildings.Fluid.Storage.Ice_ntu_ini.Data.Tank.Generic per
    "Performance data" annotation (choicesAllMatching=true, Placement(
        transformation(extent={{40,60},{60,80}}, rotation=0)));
  UA ua(final per=per)
        annotation (Placement(transformation(extent={{40,20},{60,40}})));
    Real eps;
    Real Qbrine_max;
    Modelica.Units.SI.Temperature Tenv = 20+273.15;


  Modelica.Blocks.Interfaces.RealOutput Qbrine
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  soc_calc soc_calc1(Vtank=per.Vtank, Hf=per.Hf)
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Interfaces.RealOutput Ttank
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput SOC
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=Qbrine)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.RealExpression Qenv(y=1/52*(Tenv - Ttank))
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-38,-40},{-18,-20}})));
  Modelica.Blocks.Interfaces.RealOutput Tout
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
equation
  eps = Buildings.Fluid.Storage.Ice_ntu_ini.BaseClasses.calc_NTU(ua.UAhx, m_flow, Tin);
  Qbrine_max = m_flow * Buildings.Media.Antifreeze.Validation.BaseClasses.PropyleneGlycolWater.testSpecificHeatCapacityCp_TX_a(T=(Tin+Ttank)/2, X_a=0.3) * (Tin-Ttank);
  Qbrine = eps * Qbrine_max;
  Tout = Tin - eps * (Tin-Ttank);

  connect(Tin, ua.Tin) annotation (Line(points={{-120,50},{-72,50},{-72,35},{38,
          35}}, color={0,0,127}));
  connect(soc_calc1.T_tank, Ttank) annotation (Line(points={{21,-35},{40,-35},{40,
          0},{110,0}},     color={0,0,127}));
  connect(soc_calc1.SOC_out, SOC) annotation (Line(points={{21,-39},{80,-39},{80,
          -50},{110,-50}}, color={0,0,127}));
  connect(soc_calc1.SOC_out, ua.SOC) annotation (Line(points={{21,-39},{30,-39},
          {30,25},{38,25}}, color={0,0,127}));
  connect(realExpression.y, add.u1) annotation (Line(points={{-59,-10},{-48,-10},
          {-48,-24},{-40,-24}}, color={0,0,127}));
  connect(Qenv.y, add.u2) annotation (Line(points={{-59,-50},{-48,-50},{-48,-36},
          {-40,-36}}, color={0,0,127}));
  connect(add.y, soc_calc1.Q)
    annotation (Line(points={{-17,-30},{-2,-30}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Tank;
