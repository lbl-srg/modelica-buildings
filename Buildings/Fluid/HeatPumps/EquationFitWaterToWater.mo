within Buildings.Fluid.HeatPumps;
model EquationFitWaterToWater "Water source heat pump_Equation Fit"
  extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
      dp2_nominal=200,
      dp1_nominal=200,
      show_T=true,
      T1_start = 273.15+25,
      T2_start = 273.15+5,
      m1_flow_nominal= mCon_flow_nominal,
      m2_flow_nominal= mEva_flow_nominal,
      redeclare final Buildings.Fluid.MixingVolumes.MixingVolume
      vol2(
        V=m2_flow_nominal*tau2/rho2_nominal,
        nPorts=2,
       final prescribedHeatFlowRate=true),
      vol1(
        V=m1_flow_nominal*tau1/rho1_nominal,
        nPorts=2,
        final prescribedHeatFlowRate=true));

  parameter Data.EquationFitWaterToWater.Generic_EquationFit per
  "Performance data"
   annotation (choicesAllMatching = true,Placement(transformation(
                    extent={{60,72},{80,92}})));
  parameter Modelica.SIunits.HeatFlowRate QCon_heatflow_nominal=per.QCon_heatflow_nominal*SF
  "Heating load nominal capacity_Heating mode";
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal= per.mCon_flow_nominal*SF
  "Heating mode Condenser mass flow rate nominal capacity";
  parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=per.mEva_flow_nominal*SF
  "Heating mode Evaporator mass flow rate nominal capacity";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_small = QCon_heatflow_nominal*SF*1E-9
  "Small value for heat flow rate or power, used to avoid division by zero";
  parameter Real SF(min=0.2)
  "Load scale factor for heatpump,SF=0.2 means scaling the heatpump down to 20% from the nominal load,SF= 1 means scaling up to 100%";

  Modelica.Blocks.Interfaces.RealInput TEvaSet(final unit="K", displayUnit="degC")
  "Set point for leaving chilled water temperature"
   annotation (Placement(transformation(extent={{-182,-110},{-142,-70}}),
        iconTransformation(extent={{-128,-104},{-100,-76}})));
  Modelica.Blocks.Interfaces.RealInput TConSet(final unit="K", displayUnit="degC")
  "Set point for leaving heating water temperature"
   annotation (Placement(transformation(extent={{-180,70},{-140,110}}),
        iconTransformation(extent={{-128,76},{-100,104}})));
  Modelica.Blocks.Interfaces.IntegerInput uMod
  "HeatPump control input signal,Heating mode= 1, Off=0, Cooling mode=-1"
   annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
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
  Buildings.Fluid.HeatPumps.BaseClasses.EquationFitMethod equFit(per=per,
                                                                SF=SF)
  "EquationFit method which describes the water to water heat pump performance"
   annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloCon
  "Prescribed condenser heat flow rate"
   annotation (Placement(transformation(extent={{-37,12},{-17,32}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloEva
  "Prescribed evaporator heat flow rate"
   annotation (Placement(transformation(extent={{-37,-30},{-17,-10}})));
  Modelica.Blocks.Sources.RealExpression TConEnt(y=Medium1.temperature(
                                                 Medium1.setState_phX(port_a1.p,
                                                 inStream(port_a1.h_outflow))))
  "Condenser entering water temperature"
   annotation (Placement(transformation(extent={{-134,28},{-114,48}})));
   Modelica.Blocks.Sources.RealExpression TEvaEnt(y=Medium2.temperature(
                                                   Medium2.setState_phX(port_a2.p,
                                                   inStream(port_a2.h_outflow))))
   "Evaporator entering water temperature"
    annotation (Placement(transformation(extent={{-134,-64},{-114,-44}})));
   Modelica.Blocks.Sources.RealExpression TConLvg(y=vol1.heatPort.T)
   "Condenser leaving water temperature"
    annotation (Placement(transformation(extent={{-134,44},{-114,64}})));
   Modelica.Blocks.Sources.RealExpression TEvaLvg(y=vol2.heatPort.T)
   "Evaporator leaving water temperature"
    annotation (Placement(transformation(extent={{-134,-50},{-114,-30}})));
   Modelica.Blocks.Sources.RealExpression mConFlo(y=vol1.ports[1].m_flow)
    "Condenser water mass flow rate"
     annotation (Placement(transformation(extent={{-134,14},{-114,34}})));
   Modelica.Blocks.Sources.RealExpression mEvaFlo(y=vol2.ports[1].m_flow)
    "Evaporator mass flow rate"
     annotation (Placement(transformation(extent={{-134,-36},{-114,-16}})));
   Modelica.Blocks.Sources.RealExpression QConFloSet(final y=
        Buildings.Utilities.Math.Functions.smoothMax(
        x1=mConFlo.y*(hConSet- inStream(port_a1.h_outflow)),
        x2=Q_flow_small,
        deltaX=Q_flow_small/10))
  "Setpoint heat flow rate of the condenser"
     annotation (Placement(transformation(extent={{-134,-2},{-114,18}})));
   Modelica.Blocks.Sources.RealExpression QEvaFloSet(final y=
        Buildings.Utilities.Math.Functions.smoothMin(
        x1=mEvaFlo.y*(hEvaSet - inStream(port_a2.h_outflow)),
        x2=-Q_flow_small,
        deltaX=Q_flow_small/100))
  "Setpoint heat flow rate of the evaporator"
     annotation (Placement(transformation(extent={{-134,-20},{-114,0}})));
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

equation
  connect(preHeaFloCon.port,vol1.heatPort)
  annotation (Line(points={{-17,22},{-16,22},{-16,60},{-10,60}},color={191,0,0}));
  connect(preHeaFloEva.port, vol2.heatPort)
  annotation (Line(points={{-17,-20},{20,-20},{20,-60},{12,-60}},color={191,0,0}));
  connect(uMod, equFit.uMod)
  annotation (Line(points={{-160,0},{-96,0},{-96,-0.3},{-81.3,-0.3}},color={255,127,0}));
  connect(TConSet, equFit.TConSet)
  annotation (Line(points={{-160,90},{-88,90},{-88,9.8},{-81,9.8}},color={0,0,111}));
  connect(TEvaSet, equFit.TEvaSet)
  annotation (Line(points={{-162,-90},{-88,-90},{-88,-10.5},{-81.3,-10.5}},color={0,0,127}));
  connect(equFit.QEva_flow, preHeaFloEva.Q_flow)
  annotation (Line(points={{-59,-4},{-42,-4},{-42,-20},{-37,-20}},color={0,0,127}));
  connect(equFit.QEva_flow, QEva_flow)
  annotation (Line(points={{-59,-4},{92,-4},{92,-20},{110,-20}},color={0,0,127}));
  connect(QConFloSet.y, equFit.QConFloSet)
  annotation (Line(points={{-113,8},{-106,8},{-106,1.6},{-81,1.6}},
        color={0,0,127},pattern=LinePattern.Dash));
  connect(QEvaFloSet.y, equFit.QEvaFloSet)
  annotation (Line(points={{-113,-10},{-106,-10},{-106,-2.3},{-81.3,-2.3}},
        color={0,0,127},pattern=LinePattern.Dash));
  connect(equFit.QCon_flow, preHeaFloCon.Q_flow)
  annotation (Line(points={{-59,4},{-42,4},{-42,22},{-37,22}},color={0,0,127}));
  connect(TEvaEnt.y, equFit.TEvaEnt)
  annotation (Line(points={{-113,-54},{-98,-54},{-98,-8.5},{-81.3,-8.5}},color={0,0,127}));
  connect(TEvaLvg.y, equFit.TEvaLvg)
  annotation (Line(points={{-113,-40},{-102,-40},{-102,-6.5},{-81.3,-6.5}},color={0,0,127}));
  connect(TConEnt.y, equFit.TConEnt)
  annotation (Line(points={{-113,38},{-102,38},{-102,5.6},{-81,5.6}},color={0,0,127}));
  connect(TConLvg.y, equFit.TConLvg)
  annotation (Line(points={{-113,54},{-96,54},{-96,7.6},{-81,7.6}},color={0,0,127}));
  connect(mEvaFlo.y, equFit.m2_flow)
  annotation (Line(points={{-113,-26},{-104,-26},{-104,-4.3},{-81.3,-4.3}},color={0,0,127}));
  connect(mConFlo.y, equFit.m1_flow)
  annotation (Line(points={{-113,24},{-104,24},{-104,3.6},{-81,3.6}},color={0,0,127}));
  connect(equFit.P, P)
  annotation (Line(points={{-59,0},{110,0}}, color={0,0,127}));
  connect(equFit.QCon_flow, QCon_flow)
  annotation (Line(points={{-59,4},{92,4},{92,20},{110,20}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-140,
            -100},{100,100}}), graphics={
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
    Diagram(coordinateSystem(extent={{-140,-100},{100,100}})));
end EquationFitWaterToWater;