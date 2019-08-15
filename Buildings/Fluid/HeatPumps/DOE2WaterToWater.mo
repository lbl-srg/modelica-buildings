within Buildings.Fluid.HeatPumps;
model DOE2WaterToWater "Water source heat pump_Performance curve"
   extends Buildings.Fluid.HeatPumps.BaseClasses.PartialHeatpumpPerformanceCurve(
     QCon_flow_nominal=-QEva_heatflow_nominal + P_nominal,
     mCon_flow_nominal=per.mCon_flow_nominal*SF,
     mEva_flow_nominal= per.mEva_flow_nominal*SF,
     Q_flow_small=QCon_flow_nominal*1E-9*SF,
     SF=SF);

   parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic per
   "Performance data"
    annotation (choicesAllMatching= true,
                   Placement(transformation(extent={{80,80},{100,100}})));
   parameter Real SF
   "Load scale factor for heatpump,SF=0.2 means scaling the heatpump down to 20% from the nominal load,SF= 1 means scaling up to 100%";
   final parameter Modelica.SIunits.Power
     P_nominal = -QEva_heatflow_nominal/COP_nominal
   "Nominal power of the compressor"
    annotation (Dialog(group="Nominal condition"));
   final parameter Modelica.SIunits.HeatFlowRate
     QEva_heatflow_nominal= per.QEva_flow_nominal*SF
   "Nominal heat flow at the evaporator"
    annotation (Dialog(group="Nominal condition"));
   final parameter Modelica.SIunits.Efficiency
     COP_nominal=per.COP_nominal
   "Reference coefficient  of performance"
    annotation (Dialog(group="Nominal condition"));
   Modelica.Blocks.Interfaces.RealOutput QEva_flow(final unit="W")
   "Evaporator heat flow rate"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}}),iconTransformation(
    extent={{100,-100},{120,-80}})));
   Modelica.Blocks.Interfaces.RealOutput P(final unit="W")
   "Electric power consumed by compressor"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(
       extent={{100,-10},{120,10}})));
   BaseClasses.DOE2Method doe2(per=per,
                               SF=SF)
   "DOE2 method which describes the water to water heat pump performance"
    annotation (Placement(transformation(extent={{-2,-10},{18,10}})));
   Modelica.SIunits.SpecificEnthalpy hEvaSet=
      Medium2.specificEnthalpy_pTX(
       p=port_b2.p,
       T=TEvaSet,
       X=cat( 1, port_b2.Xi_outflow,
              {1 - sum(port_b2.Xi_outflow)}))
   "Chilled water setpoint enthalpy";
   Modelica.SIunits.SpecificEnthalpy hConSet=
      Medium1.specificEnthalpy_pTX(
       p=port_b1.p,
       T=TConSet,
       X=cat( 1, port_b1.Xi_outflow,
              {1 - sum(port_b1.Xi_outflow)}))
   "Heating water setpoint enthalpy";
   Modelica.Blocks.Sources.RealExpression TEvaLvg(y=vol2.heatPort.T)
   "Evaporator leaving water temperature"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
equation
  connect(port_a2, port_a2)
  annotation (Line(points={{100,-60},{105,-60},{105,-60},{100,-60}},color={0,127,255}));
  connect(doe2.QCon_flow, QCon_flow)
  annotation (Line(points={{19,4},{86,4},{86,20},{110,20}},  color={0,0,127}));
  connect(doe2.P, P)
  annotation (Line(points={{19,0},{110,0}},  color={0,0,127}));
  connect(doe2.QEva_flow, QEva_flow)
  annotation (Line(points={{19,-4},{86,-4},{86,-20},{110,-20}},  color={0,0,127}));
  connect(TConEnt.y, doe2.TConEnt) annotation (Line(points={{-57,40},{-22,40},{-22,
          7.4},{-3,7.4}}, color={0,0,127}));
  connect(QConFloSet.y, doe2.QConFloSet) annotation (Line(points={{-57,24},{-40,
          24},{-40,2.2},{-3,2.2}}, color={0,0,127}));
  connect(QEvaFloSet.y, doe2.QEvaFloSet) annotation (Line(points={{-57,-24},{-40,
          -24},{-40,-2.6},{-3,-2.6}}, color={0,0,127}));
  connect(TEvaLvg.y, doe2.TEvaLvg) annotation (Line(points={{-59,-40},{-22,-40},
          {-22,-6},{-3,-6}}, color={0,0,127}));
  connect(TEvaSet, doe2.TEvaSet) annotation (Line(points={{-120,-90},{-18,-90},{
          -18,-10},{-3,-10}}, color={0,0,127}));
  connect(TConSet, doe2.TConSet) annotation (Line(points={{-120,90},{-18,90},{-18,
          10},{-3,10}}, color={0,0,127}));
  connect(doe2.QCon_flow, preHeaFloCon.Q_flow)
    annotation (Line(points={{19,4},{72,4},{72,22},{59,22}}, color={0,0,127}));
  connect(doe2.QEva_flow, preHeaFloEva.Q_flow) annotation (Line(points={{19,-4},
          {72,-4},{72,-20},{59,-20}}, color={0,0,127}));
  connect(uMod, doe2.uMod) annotation (Line(points={{-120,0},{-62,0},{-62,-0.2},
          {-3,-0.2}}, color={255,127,0}));
  annotation (Dialog(group="Nominal condition"),
               choicesAllMatching=true,Placement(transformation(extent={{48,66},{68,86}})),
              Icon(coordinateSystem(preserveAspectRatio=false,extent={{-120,-100},
            {100,100}}),
                   graphics={
        Rectangle(
          extent={{-92,96},{94,-94}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          extent={{-66,78},{70,50}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,-46},{70,-74}},
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
          lineColor={0,0,0},
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
        Line(points={{0,68},{0,90},{90,90},{100,90}},
                                                 color={0,0,255}),
        Line(points={{0,-70},{0,-84},{0,-90},{100,-90}}, color={28,108,200}),
        Line(points={{60,0},{104,0}}, color={28,108,200})}),
defaultComponentName="heaPumDOE2",
Documentation(info="<html>
  <p>
  Model of a water to water heat pump, based on the DOE-2.1 chiller model,
  the EnergyPlus chiller model <code>Chiller:Electric:EIR</code> and from <a href=\"Buildings.Fluid.Chillers.ElectricEIR\">
  Buildings.Fluid.Chillers.ElectricEIR</a>.
  </p>
  <p>
  This model uses three functions stated in <a href=\"Buildings.Fluid.HeatPumps.BaseClasses.DOE2Method\">
  Buildings.Fluid.HeatPupms.BaseClasses.DOE2Method</a>. to predict the thermal capacity and the compressor power consumption through
  three operational modes executed by a control input signal <code>uMod</code>=1 heating mode, <code>uMod</code>=-1 cooling mode and
  <code>uMod</code>=0 shutoff.
  </p>
  <ul>
  <li>
  A biquadratic function is used to predict the thermal capacity as a function of
  condenser entering and evaporator leaving fluid temperature.
  </li>
  <li>
  A quadratic function is used to predict power input to the thermal capacity
  ratio with respect to the part load ratio.
  </li>
  <li>
  A biquadratic function is used to predict power input to the thermal capacity ratio as a function of
  condenser entering and evaporator leaving fluid temperature.
  </li>
  </ul>
  <p>
  The model takes two input signals; the first is set point either for the leaving water temperature of the
  condenser or the evaporator which is met if the heat pump has sufficient capacity and the second is the
  integer input <code>uMod</code>.
  The model has a built-in, ideal temperature control.
  </p>
  <p>
  The model can be parametrized to compute a transient
  or steady-state response.
  The transient response of the heatpump is computed using a first
  order differential equation for the evaporator and condenser fluid volumes.
  The heatpump outlet temperatures are equal to the temperatures of these lumped volumes.
  </p>
  <h4>References</h4>
  <ul>
  <li>
  Hydeman, M. and K.L. Gillespie. 2002. Tools and Techniques to Calibrate Electric Chiller
  Component Models. <i>ASHRAE Transactions</i>, AC-02-9-1.
  </li>
  </ul>
  </html>",
  revisions="<html>
  <ul>
  <li>
  June 21, 2019, by Hagar Elarga:<br/>
  First implementation.
  Refactored ,<a href=\"Buildings.Fluid.Chillers.ElectricEIR\">ElectricEIR EIR chiller</a>
  model to include simultaneous heating and cooling modes.
  </li>
  </ul>
</html>"),
<<<<<<< HEAD
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})));
end DOE2WaterToWater;
=======
    Diagram(coordinateSystem(extent={{-160,-100},{100,100}})));
end DOE2WaterToWater;
>>>>>>> a0a6e3243ce88d6fc208f457a4eb852b9e13e4c4
