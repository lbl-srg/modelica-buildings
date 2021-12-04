within Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses;
model ModificationFactor "Factor to modify nominal capacity"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer nBeams(min=1) "Number of beams in parallel";

  parameter Data.Generic per "Performance data"
    annotation (choicesAllMatching = true,
    Placement(transformation(extent={{60,-80},{80,-60}})));

  Modelica.Blocks.Interfaces.RealInput TWat(
    final unit="K",
    displayUnit="degC") "Temperature of the water entering the beams"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealInput mWat_flow(
    final unit="kg/s") "Mass flow rate of the water entering the beams"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}})));
  Modelica.Blocks.Interfaces.RealInput mAir_flow(
    final unit="kg/s") "Mass flow rate of the primary air entering the beams"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}})));

  Modelica.Blocks.Interfaces.RealInput TRoo(
    final unit="K",
    displayUnit="degC") "Room air temperature"
    annotation (Placement(transformation(extent={{-140,-108},{-100,-68}})));

  Modelica.Blocks.Interfaces.RealOutput y(final unit="1")
    "Total modification factor"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  Modelica.Blocks.Sources.Constant temDif_nom(
    final k=1/per.dT_nominal)
    "Nominal temperature difference between water and room air"
    annotation (Placement(transformation(extent={{-70,-80},{-50,-60}})));
  Modelica.Blocks.Sources.Constant watFlo_nom(final k=1/(nBeams*per.mWat_flow_nominal))
                                     "Nominal water mass flow rate"
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
  Modelica.Blocks.Sources.Constant airFlo_nom(final k=1/(nBeams*per.mAir_flow_nominal))
                                     "Nominal water mass flow rate"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));

  DerivativesCubicSpline temDif_mod(
    final xd=per.dT.r_dT,
    final yd=per.dT.f)
    "Derivatives of the cubic spline for the temperature difference between room and water"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  DerivativesCubicSpline watFlo_mod(
    final xd=per.water.r_V,
    final yd=per.water.f) "Derivatives of the cubic spline for the water flow"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  DerivativesCubicSpline airFlo_mod(
    final xd=per.primaryAir.r_V,
    final yd=per.primaryAir.f)
    "Derivatives of the cubic spline for the air flow"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

  Modelica.Blocks.Math.Product pro_3
    "Ratio of actual/nominal temperature difference"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Blocks.Math.Product pro_2 "Ratio of actual/nominal water flow rate"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Modelica.Blocks.Math.Product pro_1 "Ratio of actual/nominal air flow rate"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));

  Modelica.Blocks.Math.MultiProduct mulPro(final nu=3)
    "Product of the three modification factors"
    annotation (Placement(transformation(extent={{64,-6},{76,6}})));

  Modelica.Blocks.Math.Add add(final k1=+1, final k2=-1)
    "Temperature difference between water and room air"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));

equation
  connect(mAir_flow, pro_1.u1) annotation (Line(points={{-120,30},{-72,30},{-20,
          30},{-20,26},{-12,26}}, color={0,0,127}));
  connect(airFlo_nom.y, pro_1.u2) annotation (Line(points={{-49,0},{-20,0},{-20,
          14},{-12,14}},     color={0,0,127}));
  connect(pro_1.y, airFlo_mod.u)
    annotation (Line(points={{11,20},{14.5,20},{18,20}}, color={0,0,127}));
  connect(mulPro.y, y)
    annotation (Line(points={{77.02,0},{110,0}}, color={0,0,127}));
  connect(mWat_flow, pro_2.u1) annotation (Line(points={{-120,90},{-72,90},{-20,
          90},{-20,86},{-12,86}}, color={0,0,127}));
  connect(pro_2.y, watFlo_mod.u)
    annotation (Line(points={{11,80},{18,80}}, color={0,0,127}));
  connect(watFlo_nom.y, pro_2.u2) annotation (Line(points={{-49,60},{-20,60},{
          -20,74},{-12,74}},
                         color={0,0,127}));
  connect(TWat, add.u1) annotation (Line(points={{-120,-30},{-60,-30},{-60,-34},
          {-52,-34}}, color={0,0,127}));
  connect(add.u2, TRoo) annotation (Line(points={{-52,-46},{-66,-46},{-80,-46},{
          -80,-88},{-120,-88}}, color={0,0,127}));
  connect(temDif_nom.y, pro_3.u2) annotation (Line(points={{-49,-70},{-20,-70},
          {-20,-46},{-12,-46}}, color={0,0,127}));
  connect(add.y, pro_3.u1) annotation (Line(points={{-29,-40},{-20,-40},{-20,
          -34},{-12,-34}}, color={0,0,127}));
  connect(pro_3.y, temDif_mod.u)
    annotation (Line(points={{11,-40},{14.5,-40},{18,-40}}, color={0,0,127}));
  connect(watFlo_mod.y, mulPro.u[1]) annotation (Line(points={{41,80},{60,80},{60,
          2.8},{64,2.8}}, color={0,0,127}));
  connect(airFlo_mod.y, mulPro.u[2]) annotation (Line(points={{41,20},{56,20},{56,
          4.44089e-16},{64,4.44089e-16}}, color={0,0,127}));
  connect(temDif_mod.y, mulPro.u[3]) annotation (Line(points={{41,-40},{50,-40},
          {60,-40},{60,-2.8},{64,-2.8}}, color={0,0,127}));
  annotation ( defaultComponentName="mod",
            Documentation(info="<html>
<p>
This model determines the three modification factors described in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.UsersGuide\">
Buildings.Fluid.HeatExchangers.ActiveBeams.UsersGuide</a>
by comparing the actual values of air mass flow rate,
water mass flow rate and room-water temperature difference with the nominal values.
The three modification factors are then multiplied.
Input to this model are the total mass flow rates of all parallel beams combined.
</p>
</html>", revisions="<html>
<ul>
<li>
June 13, 2016, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
May 20, 2016, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{100,100},{-100,-100}},
          textColor={0,0,0},
          textString="f")}));
end ModificationFactor;
