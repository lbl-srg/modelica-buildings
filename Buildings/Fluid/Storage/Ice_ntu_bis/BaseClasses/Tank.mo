within Buildings.Fluid.Storage.Ice_ntu_bis.BaseClasses;
model Tank
  Real Cp_liquid = 4184;
  Real T_tank(start=273.15+20);
  Real V_tank = 1000;
  Real rho_tank = 1;


  Modelica.Blocks.Interfaces.RealInput Tin
    annotation (Placement(transformation(extent={{-140,50},{-100,90}})));
  Modelica.Blocks.Interfaces.RealInput m_flow
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput Qbrine
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));

  Qbrine_calc qbrine_calc
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  StateOfCharge soc(SOC_start=0, E_nominal=10000)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation
  der(T_tank) * V_tank * rho_tank = - m_flow * (T_tank - Tin);
  Qbrine=5;
  connect(Tin, qbrine_calc.Tin) annotation (Line(points={{-120,70},{-40,70},{
          -40,35},{-22,35}}, color={0,0,127}));
  connect(qbrine_calc.m_flow, m_flow) annotation (Line(points={{-22,25},{-40,25},
          {-40,0},{-120,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end Tank;
