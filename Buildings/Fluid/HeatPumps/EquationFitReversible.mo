within Buildings.Fluid.HeatPumps;
model EquationFitReversible
  "Model for a reversable heat pump based on the equation fit method"
  extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
          show_T=true,
          final m1_flow_nominal=per.hea.mLoa_flow*scaling_factor,
          final m2_flow_nominal=per.hea.mSou_flow*scaling_factor,
          final dp1_nominal = per.dpHeaLoa_nominal,
          final dp2_nominal = per.dpHeaSou_nominal,
       redeclare final Buildings.Fluid.MixingVolumes.MixingVolume
          vol1(final prescribedHeatFlowRate=true),
       redeclare final Buildings.Fluid.MixingVolumes.MixingVolume
          vol2(final prescribedHeatFlowRate=true));

  parameter Data.EquationFitReversible.Generic per
   "Performance data"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{50,72},
            {70,92}})));
  parameter Real scaling_factor = 1
   "Scaling factor for heat pump capacity";
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_small=per.hea.Q_flow*
      scaling_factor*1E-9
    "Small value for heat flow rate or power, used to avoid division by zero"
    annotation (Dialog(tab="Advanced"));

  Modelica.Blocks.Interfaces.IntegerInput uMod
   "Control input signal, cooling mode=-1, off=0, heating mode=+1"
    annotation (Placement(transformation(extent={{-124,-12},{-100,12}}),
          iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput TSet(
    final unit="K",
    displayUnit="degC")
   "Set point for leaving fluid temperature at port b1"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
          iconTransformation(extent={{-128,76},{-100,104}})));

  Modelica.Blocks.Interfaces.RealOutput P(final unit="W")
   "Compressor power "
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-12},{120,8}})));
  Modelica.Blocks.Interfaces.RealOutput QSou_flow(final unit="W")
   "Heat flow rate at the source heat exchanger"
    annotation (Placement(transformation(extent={{100,-98},{120,-78}}),
        iconTransformation(extent={{100,-100},{120,-80}})));
  Modelica.Blocks.Interfaces.RealOutput QLoa_flow(final unit="W")
   "Heat flow rate at the load heat exchanger"
    annotation (Placement(transformation(extent={{100,78},{120,98}}),
        iconTransformation(extent={{100,80},{120,100}})));

  Modelica.Blocks.Interfaces.RealOutput COP(
    final min=0,
    final unit="1")
    "Coefficient of performance, assuming useful heat is at load side (at Medium 1)"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
        iconTransformation(extent={{100,-40},{120,-20}})));

  output Real PLR(min=0, nominal=1, unit="1") = equFit.PLR
   "Part load ratio";

  Buildings.Controls.OBC.CDL.Utilities.Assert aleMes(
    message="uMod cannot be -1 if reverseCycle is false.")
      if not per.reverseCycle
    "Generate alert message if control input is not valid"
    annotation (Placement(transformation(extent={{-52,-90},{-32,-70}})));

protected
  constant Modelica.Units.SI.SpecificEnergy h1_default=
      Medium1.specificEnthalpy_pTX(
      Medium1.p_default,
      Medium1.T_default,
      Medium1.X_default) "Default enthalpy for Medium 1";

  Modelica.Blocks.Sources.RealExpression mLoa_flow(y=port_a1.m_flow)
   "Load-side mass flow rate"
    annotation (Placement(transformation(extent={{-80,16},{-60,36}})));
  Modelica.Blocks.Sources.RealExpression mSou_flow(y=port_a2.m_flow)
   "Source-side mass flow rate"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Units.SI.SpecificEnthalpy hSet=if uMod == 0 then h1_default else
      Medium1.specificEnthalpy_pTX(
      p=port_b1.p,
      T=TSet,
      X=cat(
        1,
        port_b1.Xi_outflow,
        {1 - sum(port_b1.Xi_outflow)})) "Enthalpy corresponding to set point";
  Modelica.Blocks.Sources.RealExpression TSouEnt(
    final y=Medium2.temperature(
      Medium2.setState_phX(port_a2.p,
                           inStream(port_a2.h_outflow),
                           inStream(port_a2.Xi_outflow))))
   "Source side entering fluid temperature"
    annotation (Placement(transformation(extent={{-80,-36},{-60,-16}})));
  Modelica.Blocks.Sources.RealExpression TLoaEnt(
    final y=Medium1.temperature(
      Medium1.setState_phX(port_a1.p,
                          inStream(port_a1.h_outflow),
                          inStream(port_a1.Xi_outflow))))
   "Load side entering fluid temperature"
    annotation (Placement(transformation(extent={{-80,-2},{-60,18}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_set(
    final y=if uMod == 1 then Buildings.Utilities.Math.Functions.smoothMax(
              x1=m1_flow * (hSet - inStream(port_a1.h_outflow)),
              x2=Q_flow_small,
              deltaX=Q_flow_small/100)
            elseif uMod == -1 then Buildings.Utilities.Math.Functions.smoothMin(
              x1=m1_flow * (hSet - inStream(port_a1.h_outflow)),
              x2=-Q_flow_small,
              deltaX=Q_flow_small/100)
            else 0)
    "Required heat flow rate to meet set point"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  BaseClasses.EquationFitReversible equFit(
    final per=per,
    final scaling_factor=scaling_factor,
    final Q_flow_small=Q_flow_small)
    "Performance model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloLoa
   "Prescribed load side heat flow rate"
    annotation (Placement(transformation(extent={{59,10},{39,30}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloSou
   "Prescribed source side heat flow rate"
    annotation (Placement(transformation(extent={{59,-70},{39,-50}})));

  Controls.OBC.CDL.Integers.GreaterEqualThreshold greEqu(
    final t=0) if not per.reverseCycle
    "Indicator, outputs true if in cooling mode"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

equation
  connect(equFit.QSou_flow,QSou_flow)
    annotation (Line(points={{11,-2},{32,-2},{32,-88},{110,-88}}, color={0,0,127}));
  connect(mSou_flow.y, equFit.mSou_flow)
    annotation (Line(points={{-59,-10},{-54,-10},{-54,-8},{-11,-8}},color={0,0,127}));
  connect(mLoa_flow.y, equFit.mLoa_flow)
    annotation (Line(points={{-59,26},{-48,26},{-48,6},{-11,6}}, color={0,0,127}));
  connect(equFit.QLoa_flow,QLoa_flow)
    annotation (Line(points={{11,6},{80,6},{80,88},{110,88}},color={0,0,127}));
  connect(equFit.QLoa_flow,preHeaFloLoa.Q_flow)
    annotation (Line(points={{11,6},{80,6},{80,20},{59,20}},color={0,0,127}));
  connect(TSouEnt.y,equFit.TSouEnt)
    annotation (Line(points={{-59,-26},{-50,-26},{-50,-4},{-11,-4}},color={0,0,127}));
  connect(TLoaEnt.y,equFit.TLoaEnt)
    annotation (Line(points={{-59,8},{-54,8},{-54,3},{-11,3}},color={0,0,127}));
  connect(equFit.P, P)
    annotation (Line(points={{11,2},{60,2},{60,0},{110,0}},color={0,0,127}));
  connect(uMod, equFit.uMod)
    annotation (Line(points={{-112,0},{-11,0}}, color={255,127,0}));
  connect(equFit.QSou_flow, preHeaFloSou.Q_flow)
    annotation (Line(points={{11,-2},{32,-2},{32,-44},{74,-44},{74,-60},{59,-60}},
                                color={0,0,127}));
  connect(vol1.heatPort, preHeaFloLoa.port)
    annotation (Line(points={{-10,60},{-14,60},{-14,20},{39,20}}, color={191,0,0}));
  connect(vol2.heatPort, preHeaFloSou.port)
    annotation (Line(points={{12,-60},{39,-60}},color={191,0,0}));
  connect(aleMes.u,greEqu.y)
    annotation (Line(points={{-54,-80},{-58,-80}}, color={255,0,255}));
  connect(greEqu.u, uMod) annotation (Line(points={{-82,-80},{-88,-80},{-88,0},{
          -112,0}}, color={255,127,0}));
  connect(equFit.Q_flow_set, Q_flow_set.y)
    annotation (Line(points={{-11,9},{-44,9},{-44,40},{-59,40}},color={0,0,127}));
  connect(equFit.COP, COP)
    annotation (Line(points={{11,-6},{36,-6},{36,-40},{110,-40}},color={0,0,127}));
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
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-12},{-40,-52}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Line(points={{0,68},{0,90},{-100,90}},   color={0,0,255}),
        Line(points={{112,-6}}, color={28,108,200}),
        Line(points={{2,68},{2,90},{100,90},{102,86}}, color={28,108,200}),
        Line(points={{70,0},{108,0}}, color={28,108,200}),
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
          points={{-1,12},{-17,-14},{15,-12},{-1,12}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={44,-3},
          rotation=90),
        Ellipse(extent={{22,2},{28,10}}, lineColor={255,0,0}),
        Ellipse(extent={{22,-22},{28,-14}}, lineColor={255,0,0}),
        Line(points={{32,-4},{26,-4},{26,-4}}, color={255,0,0}),
        Line(points={{70,-30},{108,-30}},
                                      color={28,108,200})}),
        Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false)),
  defaultComponentName="heaPum",
  Documentation(info="<html>
<p>
Model for a reversable heat pump using the equation fit method and that takes as an
input the set point for the leaving fluid temperature.
</p>
<p>
This reversable heat pump can be operated either in heating mode or in cooling mode.
It typically is used for a water to water heat pump, but if the performance data
<code>per</code> are set up for other media, such as glycol, it can also be used for
such applications.
Note that if used with air, the results will only be valid if there is no
humidity condensation or frost build up.
The heat exchanger at medium 1 is to be connected to the building load,
and the other heat exchanger to the heat source or sink, such as
a geothermal loop.
If in heating mode, the heat exchanger at medium 1 operates as a condenser,
and in cooling mode it operates as an evaporator.
</p>
<p>
The model is based on the model described in the EnergyPlus 9.1.0 Engineering Reference, Section 16.6.1: Water to water heat pump model
and the model based on C.Tang (2005).
</p>
<p>
The model takes the following control signals:
</p>
<ul>
<li>
The integer input <code>uMod</code> which controls the heat pump operational mode.
If <code>per.reverseCycle = true</code> the signal can take on the values
<i>-1</i> for cooling mode,
<i>0</i> for off and
<i>+1</i> for heating mode.<br/>
If <code>per.reverseCycle = false</code> and <code>uMod = -1</code>, the model stops with an error message.
</li>
<li>
The input <code>TSet</code> is the set point for the leaving fluid temperature at port <code>port_b1</code>.
</li>
</ul>
<p>
The heating and cooling performance coefficients are stored in the data record <code>per</code> and are available from
<a href=\"modelica://Buildings.Fluid.HeatPumps.Data.EquationFitReversible\">
Buildings.Fluid.HeatPumps.Data.EquationFitReversible</a>.
</p>
<p>
The electric power only includes the power for the compressor, but not any power for pumps, as the pumps must be modeled outside
of this component.
</p>
<h4>Main equations</h4>
<p>
The performance of the heat pump is computed as follows:
Let <i>&alpha;</i> be the set of heat load performance coefficients determined by the data
record <code>per.hea.coeQ</code> and let
<i>&beta;</i> be the set of electrical power performance coefficients determined by the data
record <code>hea.coeP</code>.
Then, the performance is computed as
</p>
<ul>
<li>
If <code>uMod = 1</code>, the heat pump is in heating mode and the load side available heat is
<p align=\"center\" style=\"font-style:italic;\">
Q&#775;<sub>ava</sub> =
 ( &alpha;<sub>1</sub>
 + &alpha;<sub>2</sub> T<sub>loa,ent</sub>/T<sub>RefHeaLoa</sub>
 + &alpha;<sub>3</sub> T<sub>sou,ent</sub>/T<sub>RefHeaSou</sub>
 + &alpha;<sub>4</sub> m&#775;<sub>loa,ent</sub>/(m&#775;<sub>loa,0</sub> &nbsp; s)
 + &alpha;<sub>5</sub> m&#775;<sub>sou,ent</sub>/(m&#775;<sub>sou,0</sub> &nbsp; s) ) &nbsp; Q&#775;<sub>0</sub> &nbsp; s,
</p>
<p>
where <i>Q&#775;<sub>0</sub></i> is the design capacity as specified by the parameter
<code>per.hea.Q_flow</code> and <i>s</i> is the scaling factor specified by the parameter <code>scaling_factor</code>.
The corresponding power consumption is
<p align=\"center\" style=\"font-style:italic;\">
  P=
  ( &beta;<sub>1</sub>
  + &beta;<sub>2</sub> T<sub>loa,ent</sub>/T<sub>RefHeaLoa</sub>
  + &beta;<sub>3</sub> T<sub>sou,ent</sub>/T<sub>RefHeaSou</sub>
  + &beta;<sub>4</sub> m&#775;<sub>loa,ent</sub>/(m&#775;<sub>loa,0</sub> &nbsp; s)
  + &beta;<sub>5</sub> m&#775;<sub>sou,ent</sub>/(m&#775;<sub>sou,0</sub> &nbsp; s) ) &nbsp; P<sub>0</sub> &nbsp; s,
</p>
<p>
where <i>P<sub>0</sub></i> is the design power consumption as specified by the parameter
<code>per.hea.P</code>.
The actual heat provided at the load side is
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q&#775; = min(Q&#775;<sub>ava</sub> , Q&#775;<sub>set</sub>),
</p>
<p>
where <i>Q&#775;<sub>set</sub></i> is the heat required to meet the temperature setpoint
for the leaving fluid on the load side.
</p>
</li>
<li>
If <code>uMod = -1</code>, the heat pump is in cooling mode, and the governing equations are as above, but
with <code>per.coo</code> rather than <code>per.hea</code> used for the performance data, and the <i>min(&middot; &middot;)</i> function
replaced with <i>max(&middot; &middot;)</i>.
</li>
<li>
If <code>uMod = 0</code>, the model sets <i>Q&#775; = 0</i> and <i>P = 0</i>.
</li>
</ul>
<p>
The coefficient of performance COP is computed as
<p align=\"center\" style=\"font-style:italic;\">
COP = Q&#775; &frasl; P.
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
April 1, 2024, by Michael Wetter:<br/>
Corrected wrong assertion.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3664\">#3664</a>.
</li>
<li>
September 16, 2019 by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
September 2, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end EquationFitReversible;
