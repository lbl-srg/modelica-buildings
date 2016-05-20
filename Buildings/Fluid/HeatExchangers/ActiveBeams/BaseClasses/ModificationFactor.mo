within Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses;
model ModificationFactor
  extends Modelica.Blocks.Icons.Block;

  //adding the three blocks of DerivativesCubicSpline for the three variables

  DerivativesCubicSpline temDif_mod
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  DerivativesCubicSpline watFlo_mod
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  DerivativesCubicSpline airFlo_mod
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

  //adding the inputs of actual values of the three variables
  Modelica.Blocks.Interfaces.RealInput watTem
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealInput watFlo
    annotation (Placement(transformation(extent={{-140,10},{-100,50}})));
  Modelica.Blocks.Interfaces.RealInput airFlo
    annotation (Placement(transformation(extent={{-140,70},{-100,110}})));
  Modelica.Blocks.Interfaces.RealInput rooTem
    annotation (Placement(transformation(extent={{-140,-108},{-100,-68}})));

   //nominal values
  Modelica.Blocks.Sources.Constant temDif_nom
    annotation (Placement(transformation(extent={{-70,-80},{-50,-60}})));
  Modelica.Blocks.Sources.Constant watFlo_nom
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Modelica.Blocks.Sources.Constant airFlo_nom
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));

  //the Product blocks calculate the ratio actual/nominal
  Modelica.Blocks.Math.Product pro_3
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Blocks.Math.Product pro_2
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Modelica.Blocks.Math.Product pro_1
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));

  Modelica.Blocks.Math.MultiProduct mulPro(nu=3)
    annotation (Placement(transformation(extent={{64,-6},{76,6}})));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Math.Add add(k1=+1, k2=-1)
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
equation
  connect(airFlo, pro_1.u1) annotation (Line(points={{-120,90},{-72,90},{-20,90},
          {-20,86},{-12,86}}, color={0,0,127}));
  connect(airFlo_nom.y, pro_1.u2) annotation (Line(points={{-49,60},{-20,60},{
          -20,74},{-12,74}}, color={0,0,127}));
  connect(pro_1.y, airFlo_mod.u)
    annotation (Line(points={{11,80},{14.5,80},{18,80}}, color={0,0,127}));
  connect(airFlo_mod.y, mulPro.u[1]) annotation (Line(points={{41,80},{60,80},{
          60,2.8},{64,2.8}}, color={0,0,127}));
  connect(mulPro.y, y)
    annotation (Line(points={{77.02,0},{110,0}}, color={0,0,127}));
  connect(watFlo, pro_2.u1) annotation (Line(points={{-120,30},{-72,30},{-20,30},
          {-20,26},{-12,26}}, color={0,0,127}));
  connect(pro_2.y, watFlo_mod.u)
    annotation (Line(points={{11,20},{18,20}}, color={0,0,127}));
  connect(watFlo_mod.y, mulPro.u[2]) annotation (Line(points={{41,20},{50,20},{
          50,4.44089e-016},{64,4.44089e-016}}, color={0,0,127}));
  connect(watFlo_nom.y, pro_2.u2) annotation (Line(points={{-49,0},{-20,0},{-20,
          14},{-12,14}}, color={0,0,127}));
  connect(watTem, add.u1) annotation (Line(points={{-120,-30},{-60,-30},{-60,
          -34},{-52,-34}}, color={0,0,127}));
  connect(add.u2, rooTem) annotation (Line(points={{-52,-46},{-66,-46},{-80,-46},
          {-80,-88},{-120,-88}}, color={0,0,127}));
  connect(temDif_nom.y, pro_3.u2) annotation (Line(points={{-49,-70},{-20,-70},
          {-20,-46},{-12,-46}}, color={0,0,127}));
  connect(add.y, pro_3.u1) annotation (Line(points={{-29,-40},{-20,-40},{-20,
          -34},{-12,-34}}, color={0,0,127}));
  connect(temDif_mod.y, mulPro.u[3]) annotation (Line(points={{41,-40},{60,-40},
          {60,-2.8},{64,-2.8}}, color={0,0,127}));
  connect(pro_3.y, temDif_mod.u)
    annotation (Line(points={{11,-40},{14.5,-40},{18,-40}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), defaultComponentName="mod",
            Documentation(info="<html>
<p>
This model determines the three modification factors described in <a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.ActiveBeamCoo\">
Buildings.Fluid.HeatExchangers.ActiveBeams.ActiveBeamCoo</a> by comparing the actual values of air mass flow rate, water mass flow rate and room-water temperature difference with the rated values.
The three modification factors are then multiplied.

</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{100,100},{-100,-100}},
          lineColor={0,0,0},
          textString="f")}));
end ModificationFactor;
