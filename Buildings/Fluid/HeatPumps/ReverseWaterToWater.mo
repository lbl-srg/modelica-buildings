within Buildings.Fluid.HeatPumps;
model ReverseWaterToWater
  "Model for a reverse water to water heat pump based on the equation fit method"
  extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
          show_T=true,
          m1_flow_nominal=per.mLoa_flow*scaling_factor,
          m2_flow_nominal=per.mSou_flow*scaling_factor,
       redeclare final Buildings.Fluid.MixingVolumes.MixingVolume
          vol1(final prescribedHeatFlowRate=true),
       redeclare final Buildings.Fluid.MixingVolumes.MixingVolume
          vol2(final prescribedHeatFlowRate=true));

  parameter Data.ReverseWaterToWater.Generic per
   "Performance data"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{70,72},
            {90,92}})));
  parameter Boolean reverseCycle=true
  "= true, if the heat pump can be reversed to also operate in cooling mode"
    annotation(Evaluate=true);
  parameter Real scaling_factor = 1
   "Scaling factor for heat pump capacity";
  parameter Real a[:] = {1}
   "Coefficients for efficiency curve (need p(a=a, PLR=1)=1)"
    annotation (Dialog(group="Efficiency"));
  parameter Modelica.SIunits.HeatFlowRate Q_flow_small = per.QHea_flow_nominal*scaling_factor*1E-9
   "Small value for heat flow rate or power, used to avoid division by zero"
   annotation(Dialog(tab="Advanced"));

  Modelica.Blocks.Interfaces.IntegerInput uMod
   "Control input signal, cooling mode=-1, off=0, heating mode=+1"
    annotation (Placement(transformation(extent={{-124,-12},{-100,12}}),
          iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput THeaLoaSet(
    final unit="K",
    displayUnit="degC")
   "Set point for leaving heating water temperature if uMod = 1"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
          iconTransformation(extent={{-128,76},{-100,104}})));
  Modelica.Blocks.Interfaces.RealInput TCooLoaSet(
    final unit="K",
    displayUnit="degC") if reverseCycle
   "Set point for leaving chilled water temperature if uMod = -1"
    annotation (Placement(transformation(extent={{-140,-108},{-100,-68}}),
          iconTransformation(extent={{-128,-104},{-100,-76}})));
  Modelica.Blocks.Interfaces.RealOutput P(final unit="W")
   "Compressor power "
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-12},{120,8}})));
  Modelica.Blocks.Interfaces.RealOutput QSou_flow(final unit="W")
   "Heat flow rate at the source heat exchanger"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}}),
        iconTransformation(extent={{100,-100},{120,-80}})));
  Modelica.Blocks.Interfaces.RealOutput QLoa_flow(final unit="W")
   "Heat flow rate at the load heat exchanger"
    annotation (Placement(transformation(extent={{100,10},{120,30}}),
        iconTransformation(extent={{100,80},{120,100}})));
  BaseClasses.ReverseWaterToWater equFit(final a=a,
                                         final per=per,
                                         final scaling_factor=scaling_factor,
                                         final reverseCycle=reverseCycle)
   "Performance model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

protected
  constant Modelica.SIunits.SpecificEnergy h1_default=
     Medium1.specificEnthalpy_pTX(
       Medium1.p_default,
       Medium1.T_default,
       Medium1.X_default)
  "Default enthalpy for Medium 1";

  Modelica.Blocks.Sources.RealExpression mLoa_flow(y=port_a1.m_flow)
   "Load water mass flow rate"
    annotation (Placement(transformation(extent={{-78,-2},{-58,18}})));
  Modelica.Blocks.Sources.RealExpression mSou_flow(y=port_a2.m_flow)
   "Source water mass flow rate"
    annotation (Placement(transformation(extent={{-78,-20},{-58,0}})));
  Modelica.SIunits.SpecificEnthalpy hCooSet=
    if (reverseCycle and uMod == -1)
    then
      Medium1.specificEnthalpy_pTX(
              p=port_b1.p,
              T=TCooSet_internal,
              X=cat(1,
                    port_b1.Xi_outflow,
                    {1 - sum(port_b1.Xi_outflow)}))
    else h1_default
   "Chilled water setpoint enthalpy";
  Modelica.SIunits.SpecificEnthalpy hHeaSet=
    if uMod == 1
    then
      Medium1.specificEnthalpy_pTX(
              p=port_b1.p,
              T=THeaLoaSet,
              X=cat(1,
                    port_b1.Xi_outflow,
                    {1 - sum(port_b1.Xi_outflow)}))
    else h1_default
   "Heating water setpoint enthalpy";
  Modelica.Blocks.Sources.RealExpression TSouEnt(
    final y=Medium2.temperature(
      Medium2.setState_phX(port_a2.p,
                           inStream(port_a2.h_outflow),
                           inStream(port_a2.Xi_outflow))))
   "Source side entering water temperature"
    annotation (Placement(transformation(extent={{-78,-50},{-58,-30}})));
  Modelica.Blocks.Sources.RealExpression TLoaEnt(
    final y=Medium1.temperature(
      Medium1.setState_phX(port_a1.p,
                          inStream(port_a1.h_outflow),
                          inStream(port_a1.Xi_outflow))))
   "Load side entering water temperature"
    annotation (Placement(transformation(extent={{-78,30},{-58,50}})));
  Modelica.Blocks.Sources.RealExpression QHea_flow_set(
    final y= if (uMod == 1)
      then
        Buildings.Utilities.Math.Functions.smoothMax(
          x1=m1_flow*(hHeaSet - inStream(port_a1.h_outflow)),
          x2=Q_flow_small,
          deltaX=Q_flow_small/10)
      else
        0)
   "Heating load setpoint heat flow rate"
    annotation (Placement(transformation(extent={{-78,12},{-58,32}})));
  Modelica.Blocks.Sources.RealExpression QCoo_flow_set(
    final y= if (uMod == -1)
             then
               Buildings.Utilities.Math.Functions.smoothMin(
                 x1=m1_flow*(hCooSet - inStream(port_a1.h_outflow)),
                 x2=-Q_flow_small,
                 deltaX=Q_flow_small/10)
             else
               0) if
      reverseCycle
   "Setpoint cooling flow rate for the load"
    annotation (Placement(transformation(extent={{-78,-36},{-58,-16}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloLoa
   "Prescribed load side heat flow rate"
    annotation (Placement(transformation(extent={{59,10},{39,30}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloSou
   "Prescribed source side heat flow rate"
    annotation (Placement(transformation(extent={{59,-70},{39,-50}})));

  Buildings.Controls.OBC.CDL.Integers.LessThreshold lesThr(
    final threshold=0) if
       not reverseCycle
    "Indicator, outputs true if in cooling mode"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert aleMes(
    message="uMod cannot be -1 if reverseCycle is false.") if
         not reverseCycle
    "Generate alert message if control input is not valid"
    annotation (Placement(transformation(extent={{-52,-90},{-32,-70}})));
  Modelica.Blocks.Interfaces.RealInput TCooSet_internal(final unit= "K")
   "Needed to connect the conditional connector";

equation
  connect(TCooLoaSet, TCooSet_internal);
  if not reverseCycle then
    TCooSet_internal = Medium1.T_default;
  end if;

  connect(equFit.QSou_flow,QSou_flow)
  annotation (Line(points={{11,-4},{92,-4},{92,-20},{110,-20}}, color={0,0,127}));
  connect(mSou_flow.y, equFit.m2_flow)
  annotation (Line(points={{-57,-10},{-54,-10},{-54,-2.4},{-11,-2.4}},color={0,0,127}));
  connect(mLoa_flow.y, equFit.m1_flow)
  annotation (Line(points={{-57,8},{-54,8},{-54,2.2},{-11,2.2}},color={0,0,127}));
  connect(equFit.QLoa_flow,QLoa_flow)
  annotation (Line(points={{11,4},{92,4},{92,20},{110,20}},color={0,0,127}));
  connect(equFit.QLoa_flow,preHeaFloLoa.Q_flow)
  annotation (Line(points={{11,4},{72,4},{72,20},{59,20}},color={0,0,127}));
  connect(TSouEnt.y,equFit.TSouEnt)
  annotation (Line(points={{-57,-40},{-32,-40},{-32,-6.8},{-11,-6.8}},color={0,0,127}));
  connect(QHea_flow_set.y, equFit.QHea_flow_set)
  annotation (Line(points={{-57,22},{-40,22},{-40,4.8},{-11,4.8}}, color={0,0,127}));
  connect(TLoaEnt.y,equFit.TLoaEnt)
  annotation (Line(points={{-57,40},{-32,40},{-32,7.2},{-11,7.2}},color={0,0,127}));
  connect(QCoo_flow_set.y, equFit.QCoo_flow_set)
  annotation (Line(points={{-57,-26},{-40,-26},{-40,-4.6},{-11,-4.6}}, color={0,0,127}));
  connect(equFit.P, P)
  annotation (Line(points={{11,0},{110,0}},color={0,0,127}));
  connect(uMod, equFit.uMod)
  annotation (Line(points={{-112,0},{-11,0}}, color={255,127,0}));
  connect(equFit.QSou_flow, preHeaFloSou.Q_flow)
  annotation (Line(points={{11,-4},{72,-4},{72,-60},{59,-60}}, color={0,0,127}));
  connect(vol1.heatPort, preHeaFloLoa.port)
  annotation (Line(points={{-10,60},{-14,60},{-14,20},{39,20}}, color={191,0,0}));
  connect(vol2.heatPort, preHeaFloSou.port)
  annotation (Line(points={{12,-60},{39,-60}},                   color={191,0,0}));

  connect(aleMes.u, lesThr.y)
    annotation (Line(points={{-54,-80},{-58,-80}}, color={255,0,255}));
  connect(lesThr.u, uMod) annotation (Line(points={{-82,-80},{-88,-80},{-88,0},{
          -112,0}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
     graphics={
        Ellipse(
          extent={{32,12},{68,-22}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
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
        Line(points={{0,-70},{0,-90},{-100,-90}},color={0,0,255}),
        Line(points={{0,68},{0,90},{-100,90}},   color={0,0,255}),
        Line(points={{112,-6}}, color={28,108,200}),
        Line(points={{2,68},{2,90},{100,90},{102,86}}, color={28,108,200}),
        Line(points={{64,0},{108,0}}, color={28,108,200}),
        Line(points={{2,-90}}, color={28,108,200}),
        Line(points={{2,-70},{2,-90},{106,-90}}, color={28,108,200}),
        Line(points={{24,-18},{6,-18},{6,-52}}, color={238,46,47}),
        Line(points={{24,6},{6,6},{6,50}}, color={238,46,47}),
        Rectangle(
          extent={{24,18},{26,-24}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,11},{-21,-12},{17,-12},{0,11}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={44,-3},
          rotation=90),
        Ellipse(extent={{22,2},{28,10}}, lineColor={255,0,0}),
        Ellipse(extent={{22,-22},{28,-14}}, lineColor={255,0,0}),
        Line(points={{32,-4},{26,-4},{26,-4}}, color={255,0,0})}),
        Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false)),
  defaultComponentName="heaPum",
  Documentation(info="<html>
<p>
Model for a reverse water to water heat pump using the equation fit method.
</p>
<h4>Theory of operation</h4>
<p>
The reverse heat pump is a mechanical reverse cycle device that is used to transfer heat from one medium to another where
the function of the two heat exchangers can be reversed, e.g., each can operate as evaporator or condenser.
</p>
<p>
Source and load are terms which identify the two heat exchangers of the heat pump. The load heat exchanger is connected to the building thermal loads,
while the source heat exchanger extracts or rejects heat from/to the water, based on the heat pump operational heating or cooling mode.
</p>
<p>
The model is based on the model described in the EnergyPlus 9.0.1 Engineering Reference, Section 16.6.1: Water to water heat pump model
and the model based on C.Tang (2005).
It uses four non-dimensional curves described in <a href=\"Buildings.Fluid.HeatPumps.BaseClasses.ReverseWaterToWater\">
Buildings.Fluid.HeatPumps.BaseClasses.ReverseWaterToWater</a> to predict the heat pump performance.
</p>
<p>
The model takes the following control signals:
</p>
<ul>
<li>
The integer input <code>uMod</code> which controls the heat pump operational mode.
If <code>reverseCycle = true</code> the signal can take on the values <i>-1</i>
for cooling mode,
<i>0</i> for off and
<i>+1</i> for heating mode.<br/>
If <code>reverseCycle = false</code> and <code>uMod = -1</code>, the model stops with an error message.
</li>
<li>
The input <code>THeaLoaSet</code> is the set point for the leaving water temperature at port <code>port_b1</code>
if <code>uMod = 1</code>. For other values of <code>uMod</code>, this input is ignored.
</li>
<li>
If <code>reverseCycle = true</code>, the input connector <code>TCooLoaSet</code> is enable.
This input is the set point for the leaving water temperature at port <code>port_b1</code>
if <code>uMod = -1</code>. For other values of <code>uMod</code>, this input is ignored.
</li>
</ul>
<p>
The heating and cooling performance coefficients are stored in the data record <code>per</code> and are available from
<a href=\"Buildings.Fluid.HeatPumps.Data.ReverseWaterToWater\">
Buildings.Fluid.HeatPumps.Data.ReverseWaterToWater</a>.
</p>
<p>
The electric power only includes the power for the compressor, but not any power for pumps, as the pumps must be modeled outside
of this component.
</p>
<h4>Options</h4>
<p>
Set <code>reverseCycle = true</code> to allow operation as a reverse cycle, and <code>reverseCycle = false</code>
to use in heating mode only.
</p>
<h4>References</h4>
<p>
C. Tang
 <i>
Equation fit based models of water source heat pumps.
</i>
Master Thesis. Oklahoma State University, Oklahoma, USA. 2005.
</p>
</html>", revisions="<html>
<ul>
<li>
September 2, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReverseWaterToWater;
