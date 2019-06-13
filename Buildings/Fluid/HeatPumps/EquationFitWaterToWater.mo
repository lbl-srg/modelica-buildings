within Buildings.Fluid.HeatPumps;
model EquationFitWaterToWater "Water source heat pump_Equation Fit"

  extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
    dp2_nominal=200,
    dp1_nominal=200,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true,
   T1_start = 273.15+25,
   T2_start = 273.15+5,
   m1_flow_nominal= mCon_flow_nominal,
   m2_flow_nominal= mEva_flow_nominal,
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol2(
      V=m2_flow_nominal*tau2/rho2_nominal,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      nPorts=2,
    final prescribedHeatFlowRate=true),
    vol1(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      V=m1_flow_nominal*tau1/rho1_nominal,
    final prescribedHeatFlowRate=true));

  parameter Data.EquationFitWaterToWater.Generic_EquationFit per
    "Performance data"
    annotation (choicesAllMatching = true,
                Placement(transformation(extent={{40,80},{60,100}})));

  BaseClasses.EquationFitEqu equationfit(per=per)
    annotation (Placement(transformation(extent={{-82,-12},{-58,14}})));


   parameter Modelica.SIunits.HeatFlowRate   QCon_heatflow_nominal=per.QCon_heatflow_nominal
   "Heating load nominal capacity_Heating mode";
   parameter Modelica.SIunits.MassFlowRate   mCon_flow_nominal= per.mCon_flow_nominal
   "Heating mode Condenser mass flow rate nominal capacity";
   parameter Modelica.SIunits.MassFlowRate   mEva_flow_nominal=per.mEva_flow_nominal
   "Heating mode Evaporator mass flow rate nominal capacity";
   parameter Modelica.SIunits.HeatFlowRate   Q_flow_small = QCon_heatflow_nominal*1E-9
     "Small value for heat flow rate or power, used to avoid division by zero";

  Modelica.Blocks.Interfaces.RealInput TEvaSet(final unit="K", displayUnit="degC")
    "Set point for leaving chilled water temperature" annotation (Placement(
        transformation(extent={{-182,-110},{-142,-70}}), iconTransformation(
          extent={{-182,-110},{-142,-70}})));
  Modelica.Blocks.Interfaces.RealInput TConSet(final unit="K", displayUnit="degC")
    "Set point for leaving heating water temperature" annotation (Placement(
        transformation(extent={{-180,70},{-140,110}}), iconTransformation(
          extent={{-180,70},{-140,110}})));
  Modelica.Blocks.Interfaces.IntegerInput uMod "Heating mode= 1, Off=0, Cooling mode=-1"
    annotation (Placement(transformation(extent={{-180,-18},{-140,22}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloCon
  "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-37,20},{-17,40}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloEva
  "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-27,-30},{-7,-10}})));

  Modelica.Blocks.Sources.RealExpression hSet_Con(final y=Medium1.specificEnthalpy_pTX(
        p=port_b1.p,
        T=TConSet,
        X=cat(
          1,
          port_b1.Xi_outflow,
          {1 - sum(port_b1.Xi_outflow)}))) "Heating water setpoint enthalpy" annotation (Placement(transformation(extent={{-134,58},
            {-114,78}})));
  Modelica.Blocks.Sources.RealExpression hSet_Eva(final y=Medium2.specificEnthalpy_pTX(
        p=port_b2.p,
        T=TEvaSet,
        X=cat(
          1,
          port_b2.Xi_outflow,
          {1 - sum(port_b2.Xi_outflow)}))) "Cooled water setpoint enthalpy" annotation (Placement(transformation(extent={{-134,
            -80},{-114,-60}})));
  Modelica.Blocks.Sources.RealExpression QCon_flow_Set(final y=
        Buildings.Utilities.Math.Functions.smoothMax(
        x1=mCon_flow.y*(hSet_Con.y - inStream(port_a1.h_outflow)),
        x2=Q_flow_small,
        deltaX=Q_flow_small/10)) "Setpoint heat flow rate of the condenser"
    annotation (Placement(transformation(extent={{-134,-2},{-114,18}})));
  Modelica.Blocks.Sources.RealExpression QEva_flow_Set(y=
        Buildings.Utilities.Math.Functions.smoothMin(
        x1=mEva_flow.y*(hSet_Eva.y - inStream(port_a2.h_outflow)),
        x2=-Q_flow_small,
        deltaX=Q_flow_small/100)) "Setpoint heat flow rate of the evaporator " annotation (Placement(transformation(extent={{-134,
            -18},{-114,2}})));

  Modelica.Blocks.Interfaces.RealOutput P "Compressor Power " annotation (Placement(transformation(extent={{142,10},{162,30}})));
  Modelica.Blocks.Interfaces.RealOutput QEva_flow "Evaporator heat flow rate"
    annotation (Placement(transformation(extent={{142,-42},{162,-22}})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow "Condenser heat flow rate"
    annotation (Placement(transformation(extent={{142,-14},{162,6}})));

  Modelica.Blocks.Sources.RealExpression TConEnt(y=Medium1.temperature(
                                                 Medium1.setState_phX(port_a1.p,
                                                  inStream(port_a1.h_outflow))))
    annotation (Placement(transformation(extent={{-134,28},{-114,48}})));
  Modelica.Blocks.Sources.RealExpression TConLvg(y=vol1.heatPort.T) annotation (Placement(transformation(extent={{-134,44},{-114,64}})));
  Modelica.Blocks.Sources.RealExpression TEvaEnt(y=Medium2.temperature(
                                                 Medium2.setState_phX(port_a2.p,
                                                 inStream(port_a2.h_outflow))))
    annotation (Placement(transformation(extent={{-134,-64},{-114,-44}})));
  Modelica.Blocks.Sources.RealExpression TEvaLvg(y=vol2.heatPort.T) annotation (Placement(transformation(extent={{-134,-50},{-114,-30}})));
  Modelica.Blocks.Sources.RealExpression mCon_flow(y=vol1.ports[1].m_flow)
    annotation (Placement(transformation(extent={{-134,14},{-114,34}})));
  Modelica.Blocks.Sources.RealExpression mEva_flow(y=vol2.ports[1].m_flow)
    annotation (Placement(transformation(extent={{-134,-36},{-114,-16}})));

equation

  connect(preHeaFloCon.port,vol1.heatPort)  annotation (Line(points={{-17,30},{-16,30},{-16,60},{-10,60}}, color={191,0,0}));
  connect(preHeaFloEva.port, vol2.heatPort) annotation (Line(points={{-7,-20},{20,-20},{20,-60},{12,-60}},  color={191,0,0}));

  connect(uMod, equationfit.uMod) annotation (Line(points={{-160,2},{-96,2},{
          -96,0.61},{-83.08,0.61}},                                                                    color={255,127,0}));
  connect(TConSet, equationfit.TConSet) annotation (Line(points={{-160,90},{-88,
          90},{-88,14},{-83.2,14}},                      color={0,0,111}));
  connect(TEvaSet, equationfit.TEvaSet) annotation (Line(points={{-162,-90},{
          -88,-90},{-88,-11.74},{-82.96,-11.74}},                                                                    color={0,0,127}));
  connect(equationfit.QEva_flow, preHeaFloEva.Q_flow) annotation (Line(points={{-56.8,
          -3.94},{-42,-3.94},{-42,-20},{-27,-20}},       color={0,0,127}));
  connect(equationfit.QEva_flow, QEva_flow) annotation (Line(points={{-56.8,
          -3.94},{122,-3.94},{122,-32},{152,-32}},
                                            color={0,0,127}));
  connect(QCon_flow_Set.y, equationfit.QCon_flow_Set)
  annotation (Line(points={{-113,8},{-106,8},{-106,3.6},{-83.2,3.6}},      color={0,0,127},pattern=LinePattern.Dash));
  connect(QEva_flow_Set.y, equationfit.QEva_flow_Set)
  annotation (Line(points={{-113,-8},{-106,-8},{-106,-1.73},{-83.08,-1.73}},   color={0,0,127},pattern=LinePattern.Dash));
  connect(equationfit.QCon_flow, QCon_flow) annotation (Line(points={{-56.8,1},
          {128,1},{128,-4},{152,-4}}, color={0,0,127}));
  connect(equationfit.QCon_flow, preHeaFloCon.Q_flow) annotation (Line(points={{-56.8,1},
          {-42,1},{-42,30},{-37,30}},          color={0,0,127}));
  connect(TEvaEnt.y, equationfit.TEvaEnt) annotation (Line(points={{-113,-54},{
          -98,-54},{-98,-9.4},{-82.96,-9.4}},                                                                      color={0,0,127}));
  connect(TEvaLvg.y, equationfit.TEvaLvg) annotation (Line(points={{-113,-40},{
          -102,-40},{-102,-6.93},{-83.08,-6.93}},                                                                    color={0,0,127}));
  connect(TConEnt.y, equationfit.TConEnt) annotation (Line(points={{-113,38},{
          -102,38},{-102,8.8},{-83.2,8.8}},                                                                      color={0,0,127}));
  connect(TConLvg.y, equationfit.TConLvg) annotation (Line(points={{-113,54},{
          -96,54},{-96,12},{-83.2,12},{-83.2,11.4}},                                                                       color={0,0,127}));
  connect(mEva_flow.y, equationfit.m2_flow) annotation (Line(points={{-113,-26},
          {-104,-26},{-104,-4.07},{-83.08,-4.07}},
                                                 color={0,0,127}));
  connect(mCon_flow.y, equationfit.m1_flow) annotation (Line(points={{-113,24},
          {-104,24},{-104,6.2},{-83.2,6.2}},  color={0,0,127}));
  connect(equationfit.P, P) annotation (Line(points={{-56.8,6.2},{132,6.2},{132,
          20},{152,20}},          color={0,0,127}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
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
          lineColor={<p>0,0,0},
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
        Line(points={{0,68},{0,90},{-100,90}},   color={0,0,255})}),
    defaultComponentName="heaPum",
    Documentation(info="<html>
<p>
    Model for a water to water heat pump using the equation fit model as described
in the EnergyPlus HeatPump: Waterto Water equationfit model and based on (J.Hui 2002, S.Arun. 2004 and C.Tang 2004).
</p>
<p>
The model uses four non-dimensional equations or curves to predict the heat pump performance in either cooling or heating modes.
The methodology involved using the generalized least square method to create a set of performance
coefficients (A1 to A10) and (B1 to B10) from the catalog data at indicated reference conditions. These respective coefficients
and indicated reference conditions are used in the model to simulate the heat pump performance.
The variables include load side inlet temperature, source side inlet temperature,
load side water flow rate and source side water flow rate. Source and load are identified based on the thermal dominated mode,
for ex. in case of heating dominated mode, the source is the evaporator and load is the condenser.
</p>

<p>
The heating and cooling coefficients are stored in the data record per and are available from <a href=\"Buildings.Fluid.HeatPumo.Data.WatertoWaterEquationFit\">
Buildings.Fluid.HeatPumo.Data.WatertoWaterEquationFit</a>.
</p>

<h4>Implementation</h4>
This model uses four functions to predict capacity and power consumption for heating and cooling dominated modes:

<ul>
<li>
The heating dominated mode:

<p align=\"left\" style=\"font-style:italic;\">
(Q&#775;<sub>Con</sub>)/(Q&#775;<sub>Con,nominal</sub>) = A<sub>1</sub>+ A<sub>2</sub>[T<sub>Con,Ent</sub>/T<sub>Con,nominal</sub>]+
A<sub>3</sub>[T<sub>Eva,Ent</sub>/T<sub>Eva,nominal</sub>]+ A<sub>4</sub>[V&#775;<sub>Con,Ent</sub>/V&#775;<sub>Con,nominal</sub>]+
+ A<sub>5</sub>[V&#775;<sub>Eva,Ent</sub>/V&#775;<sub>Eva,nominal</sub>]

<p align=\"left\" style=\"font-style:italic;\">
(Power<sub>Con</sub>)/(Power<sub>Con,nominal</sub>) = B<sub>1</sub>+ B<sub>2</sub>[T<sub>Con,Ent</sub>/T<sub>Con,nominal</sub>]+
B<sub>3</sub>[T<sub>Eva,Ent</sub>/T<sub>Eva,nominal</sub>]+ B<sub>4</sub>[V&#775;<sub>Con,Ent</sub>/V&#775;<sub>Con,nominal</sub>]+
+ B<sub>5</sub>[V&#775;<sub>Eva,Ent</sub>/V&#775;<sub>Eva,nominal</sub>]

</li>
</ul>


<ul>
<li>
The cooling dominated mode:

<p align=\"left\" style=\"font-style:italic;\">
(Q&#775;<sub>Eva</sub>)/(Q&#775;<sub>Eva,nominal</sub>) = A<sub>6</sub>+ A<sub>7</sub>[T<sub>Con,Ent</sub>/T<sub>Con,nominal</sub>]+
A<sub>8</sub>[T<sub>Eva,Ent</sub>/T<sub>Eva,nominal</sub>]+ A<sub>9</sub>[V&#775;<sub>Con,Ent</sub>/V&#775;<sub>Con,nominal</sub>]+
+ A<sub>10</sub>[V&#775;<sub>Eva,Ent</sub>/V&#775;<sub>Eva,nominal</sub>]


<p align=\"left\" style=\"font-style:italic;\">
(Power<sub>Eva</sub>)/(Power<sub>Eva,nominal</sub>) = B<sub>6</sub>+ B<sub>7</sub>[T<sub>Con,Ent</sub>/T<sub>Con,nominal</sub>]+
B<sub>8</sub>[T<sub>Eva,Ent</sub>/T<sub>Eva,nominal</sub>]+ B<sub>9</sub>[V&#775;<sub>Con,Ent</sub>/V&#775;<sub>Con,nominal</sub>]+
+ B<sub>10</sub>[V&#775;<sub>Eva,Ent</sub>/V&#775;<sub>Eva,nominal</sub>]


</li>
</ul>


<p>
For these four equations, the inlet conditions or variables are divided by the reference conditions.
This formulation allows the coefficients to fall into smaller range of values. Moreover, the value of the coefficient
indirectly represents the sensitivity of the output to that particular inlet variable.
</p>
<p>
The model takes as an input the set point for either the leaving water temperature for the
condenser or the evaporator which is met if the heat pump has sufficient capacity. In addition to the integer input which identifies the heat pump operational mode:
(+1) for heating dominated mode, (-1) for cooling dominated mode, (0) for shut off the system.
</p>

<p>
In addition, the electric power only includes the power for the compressor, but not any power for pumps or fans.
</p>


<h4>References</h4>
<p>
C.C Tang
 <i>
Equation fit based models of water source heat pumps.
  </i>
Master Thesis. Oklahoma State University, Oklahoma, USA. 2005.
</p>
  </html>", revisions="<html>
<ul>
<li>
May 3, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-100},{140,100}})));
end EquationFitWaterToWater;
