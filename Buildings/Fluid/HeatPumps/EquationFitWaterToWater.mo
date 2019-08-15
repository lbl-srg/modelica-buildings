within Buildings.Fluid.HeatPumps;
model EquationFitWaterToWater "Model for a water to water heat pump using performance curves to predict the heating and cooling loads"
  extends Buildings.Fluid.HeatPumps.BaseClasses.PartialHeatpumpWithPerformanceCurves(
     QCon_flow_nominal=per.QCon_flow_nominal*scaling_factor,
     mCon_flow_nominal=per.mCon_flow_nominal*scaling_factor,
     mEva_flow_nominal=per.mEva_flow_nominal*scaling_factor,
     Q_flow_small=QCon_flow_nominal*1E-9*scaling_factor);

  parameter Data.EquationFitWaterToWater.Generic per "Performance data"
   annotation (choicesAllMatching=true, Placement(transformation(extent={{60,72},
            {80,92}})));

  Modelica.Blocks.Interfaces.RealOutput P(final unit="W")
  "Compressor Power "
   annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-12},{120,8}})));
  Modelica.Blocks.Interfaces.RealOutput QEva_flow(final unit="W")
  "Evaporator heat flow rate"
   annotation (Placement(transformation(extent={{100,-30},{120,-10}}),
        iconTransformation(extent={{100,-100},{120,-80}})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow(final unit="W")
  "Condenser heat flow rate"
   annotation (Placement(transformation(extent={{100,10},{120,30}}),
        iconTransformation(extent={{100,78},{120,98}})));
  Buildings.Fluid.HeatPumps.BaseClasses.EquationFitMethod equFit(per=per,
                                                      scaling_factor=scaling_factor)
  "EquationFit method which describes the water to water heat pump performance"
   annotation (Placement(transformation(extent={{-18,-10},{2,10}})));
   Modelica.Blocks.Sources.RealExpression mCon_flow(y=vol1.ports[1].m_flow)
    "Condenser water mass flow rate"
    annotation (Placement(transformation(extent={{-78,-2},{-58,18}})));
   Modelica.Blocks.Sources.RealExpression mEva_flow(y=vol2.ports[1].m_flow)
    "Evaporator mass flow rate"
    annotation (Placement(transformation(extent={{-78,-20},{-58,0}})));
   Modelica.SIunits.SpecificEnthalpy hEvaSet=
      Medium2.specificEnthalpy_pTX(
       p=port_b2.p,
       T=TEvaSet,
       X=cat( 1,  port_b2.Xi_outflow,
             {1 - sum(port_b2.Xi_outflow)}))
   "Chilled water setpoint enthalpy";
   Modelica.SIunits.SpecificEnthalpy hConSet=
      Medium1.specificEnthalpy_pTX(
       p=port_b1.p,
       T=TConSet,
       X=cat( 1,  port_b1.Xi_outflow,
              {1 - sum(port_b1.Xi_outflow)}))
   "Heating water setpoint enthalpy";
   Modelica.Blocks.Sources.RealExpression TEvaEnt(y=Medium2.temperature(
        Medium2.setState_phX(port_a2.p, inStream(port_a2.h_outflow))))
  "Evaporator entering water temperature"
   annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
equation
  connect(equFit.QEva_flow, QEva_flow)
  annotation (Line(points={{3,-4},{92,-4},{92,-20},{110,-20}},  color={0,0,127}));
  connect(mEva_flow.y, equFit.m2_flow)
  annotation (Line(points={{-57,-10},{-54,-10},
          {-54,-2.7},{-18.9,-2.7}}, color={0,0,127}));
  connect(mCon_flow.y, equFit.m1_flow)
  annotation (Line(points={{-57,8},{-54,8},
          {-54,2},{-19,2}}, color={0,0,127}));
  connect(equFit.P, P)
  annotation (Line(points={{3,0},{110,0}},   color={0,0,127}));
  connect(equFit.QCon_flow, QCon_flow)
  annotation (Line(points={{3,4},{92,4},{92,20},{110,20}},   color={0,0,127}));
  connect(equFit.QCon_flow, preHeaFloCon.Q_flow)
  annotation (Line(points={{3,4},{72,4},{72,22},{59,22}}, color={0,0,127}));
  connect(equFit.QEva_flow, preHeaFloEva.Q_flow)
  annotation (Line(points={{3,-4},
          {72,-4},{72,-20},{59,-20}}, color={0,0,127}));
  connect(uMod, equFit.uMod)
  annotation (Line(points={{-120,0},{-70,0},{-70,-0.3},
          {-19.3,-0.3}}, color={255,127,0}));
  connect(TConSet, equFit.TConSet)
  annotation (Line(points={{-120,90},{-26,90},{
          -26,9.8},{-19,9.8}}, color={0,0,127}));
  connect(TEvaSet, equFit.TEvaSet)
  annotation (Line(points={{-120,-90},{-26,-90},
          {-26,-9.9},{-18.9,-9.9}}, color={0,0,127}));
  connect(TEvaEnt.y, equFit.TEvaEnt)
  annotation (Line(points={{-59,-40},{-32,-40},
          {-32,-7.5},{-18.9,-7.5}}, color={0,0,127}));
  connect(QCon_flow_set.y, equFit.QCon_flow_set)
  annotation (Line(points={{-57,24},
          {-40,24},{-40,4.4},{-19,4.4}}, color={0,0,127}));
  connect(TConEnt.y, equFit.TConEnt)
  annotation (Line(points={{-57,40},{-32,40},
          {-32,6.8},{-19,6.8}}, color={0,0,127}));
  connect(QEva_flow_set.y, equFit.QEva_flow_set)
  annotation (Line(points={{-57,-24},
          {-40,-24},{-40,-5.1},{-18.9,-5.1}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-120,-100},
            {100,100}}),       graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,0}),
        Rectangle(
          extent={{-56,68},{58,50}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,-52},{58,-70}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-103,64},{98,54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,54},{98,64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-101,-56},{100,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-66},{0,-56}},
          lineColor={0,0,127},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,0},{-52,-12},{-32,-12},{-42,0}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{-42,0},{-52,10},{-32,10},{-42,0}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          extent={{-44,50},{-40,10}},
          lineColor={ERROR,
                          0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-12},{-40,-52}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,50},{42,-52}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{18,22},{62,-20}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{40,22},{22,-10},{58,-10},{40,22}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{0,-70},{0,-90},{-100,-90}},color={0,0,255}),
        Line(points={{0,68},{0,90},{-100,90}},   color={0,0,255}),
        Line(points={{112,-6}}, color={28,108,200}),
        Line(points={{2,68},{2,90},{100,90},{102,86}}, color={28,108,200}),
        Line(points={{64,0},{108,0}}, color={28,108,200}),
        Line(points={{2,-90}}, color={28,108,200}),
        Line(points={{2,-70},{2,-90},{106,-90}}, color={28,108,200})}),
  defaultComponentName="heaPum",
  Documentation(info="<html>
  <p>
  Model for a water to water heat pump using the equation fit model as described
  in the EnergyPlus9.0.1 engineering reference documentation section 16.6.1: Water to water heat pump model. The model is based on J.Hui (2002), S.Arun. (2004) and C.Tang (2005).
  </p>
  <p>
  The model uses four non-dimensional equations or curves stated in <a href=\"Buildings.Fluid.HeatPumps.BaseClasses.EquationFitMethod\">
  Buildings.Fluid.HeatPumps.BaseClasses.EquationFitMethod</a> to predict the heat pump performance in either cooling or
  heating modes. The methodology involved using the generalized least square method to create a set of performance
  coefficients for the heating and cooling load ratios <code>HLRC</code>, <code>CLRC</code> and for the compressor power ratios <code>PHC</code>, <code>PCC</code> for heating and cooling modes respectively from the catalog data at indicated reference conditions. These respective coefficients
  and indicated reference conditions are used in the model to simulate the heat pump performance.
  The variables include load side inlet temperature, source side inlet temperature,
  load side water flow rate and source side water flow rate. Source and load sides are terms which
  separates between thermal source and building load sides within the heat pump. For ex. when the control integer signal <code>uMod</code>= 1,
  the heat pump is controlled to meet the condenser outlet temperature i.e. supply heating temperature to the building,
  the source side is the evaporator and the load side is the condenser.
  Likewise, in case of <code>uMod</code>=-1, the heat pump is controlled to meet the evaporator leaving water temperature,
  accordingly, the source side is the condenser and the load side is the evaporator.
  </p>
  <p>
  The heating and cooling performance coefficients are stored in the data record <code>per</code> and are available from <a href=\"Buildings.Fluid.HeatPumps.Data.EquationFitWaterToWater\">
  Buildings.Fluid.HeatPumps.Data.EquationFitWaterToWater</a>.
  </p>
  <p>
  The model takes as input signals; the set point for either the leaving water temperature for the
  condenser or the evaporator which is met if the heat pump has sufficient capacity and the integer input <code>uMod</code> which identifies the heat pump operational mode.
  </p>
  <p>
  The electric power only includes the power for the compressor, but not any power for pumps or fans.
  </p>
  <h4>References</h4>
  <p>
  C.Tang
   <i>
  Equation fit based models of water source heat pumps.
  </i>
  Master Thesis. Oklahoma State University, Oklahoma, USA. 2005.
  </p>
    </html>", revisions="<html>
  <ul>
  <li>
  May 19, 2019, by Hagar Elarga:<br/>
  First implementation.
  </li>
  </ul>
<<<<<<< HEAD
</html>"),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})));
end EquationFitWaterToWater;
=======
  </html>"),
    Diagram(coordinateSystem(extent={{-140,-100},{100,100}})));
end EquationFitWaterToWater;
>>>>>>> a0a6e3243ce88d6fc208f457a4eb852b9e13e4c4
