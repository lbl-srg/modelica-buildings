within Buildings.Fluid.HeatPumps.BaseClasses;
partial model PartialHeatpumpPerformanceCurves
  "Partial model for water to water heat pumps"
  extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
        dp2_nominal=200,
        dp1_nominal=200,
        show_T=true,
        T1_start = 273.15+25,
        T2_start = 273.15+5,
        m1_flow_nominal= mCon_flow_nominal,
        m2_flow_nominal= mEva_flow_nominal,
      redeclare final Buildings.Fluid.MixingVolumes.MixingVolume
        vol2( V=m2_flow_nominal*tau2/rho2_nominal,
              nPorts=2,
              final prescribedHeatFlowRate=true),
        vol1( V=m1_flow_nominal*tau1/rho1_nominal,
              nPorts=2,
              final prescribedHeatFlowRate=true));

  parameter Modelica.SIunits.HeatFlowRate QCon_flow_nominal
  "Heating load nominal capacity_Heating mode";
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal
  "Heating mode Condenser mass flow rate nominal capacity";
  parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal
  "Heating mode Evaporator mass flow rate nominal capacity";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_small = QCon_flow_nominal*scaling_factor*1E-9
  "Small value for heat flow rate or power, used to avoid division by zero";
  parameter Real scaling_factor
   "Scaling factor for heat pump capacity";

  Modelica.Blocks.Interfaces.RealInput TEvaSet(final unit="K", displayUnit="degC")
  "Set point for leaving chilled water temperature"
   annotation (Placement(transformation(extent={{-140,-110},{-100,-70}}),
        iconTransformation(extent={{-128,-104},{-100,-76}})));
  Modelica.Blocks.Interfaces.RealInput TConSet(final unit="K", displayUnit="degC")
  "Set point for leaving heating water temperature"
   annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
        iconTransformation(extent={{-128,76},{-100,104}})));
  Modelica.Blocks.Interfaces.IntegerInput uMod
  "HeatPump control input signal,Heating mode= 1, Off=0, Cooling mode=-1"
   annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-128,-14},{-100,14}})));
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
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    "Prescribed heating heat flow rate"
    annotation (Placement(transformation(extent={{59,12},{39,32}})));
  HeatTransfer.Sources.PrescribedHeatFlow preCooFlo
    "Prescribed cooling flow rate"
    annotation (Placement(transformation(extent={{59,-30},{39,-10}})));
  Modelica.Blocks.Sources.RealExpression TConEnt(y=Medium1.temperature(
                                                 Medium1.setState_phX(port_a1.p,
                                                 inStream(port_a1.h_outflow))))
  "Condenser entering water temperature"
   annotation (Placement(transformation(extent={{-78,30},{-58,50}})));
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

   Modelica.Blocks.Sources.RealExpression QCon_flow_set(final y=
        Buildings.Utilities.Math.Functions.smoothMax(
        x1=m1_flow*(hConSet - inStream(port_a1.h_outflow)),
        x2=Q_flow_small,
        deltaX=Q_flow_small/10))
   "Setpoint heat flow rate of the condenser"
    annotation (Placement(transformation(extent={{-78,14},{-58,34}})));
   Modelica.Blocks.Sources.RealExpression QEva_flow_set(final y=
        Buildings.Utilities.Math.Functions.smoothMin(
        x1=m2_flow*(hEvaSet - inStream(port_a2.h_outflow)),
        x2=-Q_flow_small,
        deltaX=Q_flow_small/100))
   "Setpoint heat flow rate of the evaporator"
    annotation (Placement(transformation(extent={{-78,-34},{-58,-14}})));
equation
  connect(preHeaFlo.port, vol1.heatPort) annotation (Line(points={{39,22},{-14,
          22},{-14,60},{-10,60}}, color={191,0,0}));
  connect(preCooFlo.port, vol2.heatPort) annotation (Line(points={{39,-20},{20,
          -20},{20,-60},{12,-60}}, color={191,0,0}));
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
</html>"),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})));
end PartialHeatpumpPerformanceCurves;
