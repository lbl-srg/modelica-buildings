within Buildings.Fluid.HeatPumps;
model DOE2Reversible
  "Model for a reversible heat pump based on the DOE2 method"
extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
        dp2_nominal=200,
        dp1_nominal=200,
        show_T=true,
      redeclare final Buildings.Fluid.MixingVolumes.MixingVolume
        vol2( V=m2_flow_nominal*tau2/rho2_nominal,
              nPorts=2,
              final prescribedHeatFlowRate=true),
        vol1( V=m1_flow_nominal*tau1/rho1_nominal,
              nPorts=2,
              final prescribedHeatFlowRate=true));

  parameter Buildings.Fluid.HeatPumps.Data.DOE2Reversible.Generic per
   "Performance data"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{50,72},
            {70,92}})));
  parameter Real scaling_factor = 1
   "Scaling factor for heat pump capacity";

  parameter Boolean reverseCycle
    "= true, if reversing the heatpump to cooling mode is required"
    annotation(Evaluate=true, HideResult=true, Dialog(group="Conditional inputs"));
  output Real PLR(min=0, nominal=1, unit="1") = doe2.PLR1
    "Part load ratio";

  constant Modelica.SIunits.SpecificEnergy h1_default=
     Medium1.specificEnthalpy_pTX(
       Medium1.p_default,
       Medium1.T_default,
       Medium1.X_default)
  "Default enthalpy for Medium 1";
  Modelica.SIunits.SpecificEnthalpy hSet=
    if uMod == 0
      then
        h1_default
    elseif uMod ==-1
      then
        Medium1.specificEnthalpy_pTX(
              p=port_b1.p,
              T=reSet.chiTSet,
              X=cat(1,
                    port_b1.Xi_outflow,
                    {1 - sum(port_b1.Xi_outflow)}))
    else
        Medium1.specificEnthalpy_pTX(
              p=port_b2.p,
              T=reSet.chiTSet,
              X=cat(1,
                    port_b2.Xi_outflow,
                    {1 - sum(port_b2.Xi_outflow)}))
   "Enthalpy corresponding to set point";

  Modelica.Blocks.Interfaces.RealInput TSet(final unit="K", displayUnit="degC")
    "Set point for leaving fluid temperature at port b1"
     annotation (Placement(transformation(extent={{-120,44},{-100,64}}),
          iconTransformation(extent={{-120,80},{-100,100}})));
  BaseClasses.ReSetTSetCoo reSet
    "Built-in controller to reset of the cooling set point tempeatue in case heating mode is selected."
     annotation (Placement(transformation(extent={{-48,50},{-28,70}})));
  Modelica.Blocks.Interfaces.IntegerInput uMod
   "Control input signal, cooling mode=-1, off=0, heating mode=+1"
     annotation (Placement(transformation(extent={{-124,-12},{-100,12}}),
          iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealOutput QLoa_flow(final unit="W")
   "Heat flow rate at the load heat exchanger"
     annotation (Placement(transformation(extent={{100,78},{120,98}}),
        iconTransformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.RealOutput P(final unit="W")
   "Compressor power "
     annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-12},{120,8}})));
  Modelica.Blocks.Interfaces.RealOutput COP(final min=0, final unit="1")
    "Coefficient of performance, assuming useful heat is at load side (at Medium 1)"
     annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
        iconTransformation(extent={{100,-40},{120,-20}})));
  Modelica.Blocks.Interfaces.RealOutput QSou_flow(final unit="W")
   "Heat flow rate at the source heat exchanger"
     annotation (Placement(transformation(extent={{100,-98},{120,-78}}),
        iconTransformation(extent={{100,-100},{120,-80}})));
  Modelica.Blocks.Interfaces.RealInput TSouMinLvg(final
      unit="K",
      displayUnit="degC")
    "Minimum leaving water temperature at the source side"
     annotation (Placement(transformation(extent={{-120,90},{-100,110}}),
        iconTransformation(extent={{-120,-100},{-100,-80}})));
  Modelica.Blocks.Interfaces.RealInput TSouMaxLvg(final
     unit="K",
     displayUnit="degC") "Maximum source leaving water temperature"
    annotation (Placement(
        transformation(extent={{-120,76},{-100,96}}), iconTransformation(extent=
           {{-120,30},{-100,50}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TSouLvg
    "Leaving water temperature form source heat exchanger"
    annotation (Placement(transformation(extent={{0,-40},{-20,-20}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TLoaLvg
    "Leaving water temperature form load heat exchanger"
    annotation (Placement(transformation(extent={{-28,20},{-48,40}})));

protected
   BaseClasses.DOE2Reversible doe2(
     final per=per,
     final scaling_factor=scaling_factor)
   "Performance model"
    annotation (Placement(transformation(extent={{-6,-10},{14,10}})));

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
  Modelica.Blocks.Sources.RealExpression Q_flow_set(
    final y=
    if     (uMod == 1)
      then m2_flow*(hSet-inStream(port_a2.h_outflow))
    elseif (uMod == -1)
      then m1_flow*(hSet -inStream(port_a1.h_outflow))
    else   0)
    "Required heat flow rate to meet set point"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.RealExpression TSouEnt(
    final y=Medium2.temperature(
        Medium2.setState_phX(
        port_a2.p,
        inStream(port_a2.h_outflow),
        inStream(port_a2.Xi_outflow)))) "Source side leaving fluid temperature"
    annotation (Placement(transformation(extent={{-80,-22},{-60,-2}})));
  Modelica.Blocks.Sources.RealExpression TLoaEnt(
    final y=Medium1.temperature(
        Medium1.setState_phX(
        port_a1.p,
        inStream(port_a1.h_outflow),
        inStream(port_a1.Xi_outflow)))) "Load side entering fluid temperature"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloLoa
   "Prescribed load side heat flow rate"
    annotation (Placement(transformation(extent={{61,10},{41,30}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloSou
   "Prescribed source side heat flow rate"
    annotation (Placement(transformation(extent={{59,-70},{39,-50}})));

equation
  connect(aleMes.u,lesThr.y)
  annotation (Line(points={{-54,-80},{-58,-80}}, color={255,0,255}));
  connect(uMod, doe2.uMod)
  annotation (Line(points={{-112,0},{-7,0}},  color={255,127,0}));
  connect(uMod, lesThr.u)
  annotation (Line(points={{-112,0},{-88,0},{-88,-80},{-82,
          -80}}, color={255,127,0}));
  connect(Q_flow_set.y, doe2.Q_flow_set)
  annotation (Line(points={{-59,30},{-58,30},{-58,5.4},{-7,5.4}},
                                color={0,0,127}));
  connect(doe2.QLoa_flow, QLoa_flow)
  annotation (Line(
      points={{15,3},{84,3},{84,88},{110,88}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(doe2.P, P)
  annotation (Line(
      points={{15,0},{110,0}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(doe2.COP, COP)
  annotation (Line(
      points={{15,-3},{84,-3},{84,-40},{110,-40}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(doe2.QSou_flow, QSou_flow)
  annotation (Line(
      points={{15,-6},{82,-6},{82,-88},{110,-88}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(doe2.QLoa_flow, preHeaFloLoa.Q_flow)
  annotation (Line(points={{15,3},{68,3},{68,20},{61,20}}, color={0,0,127}));
  connect(doe2.QSou_flow, preHeaFloSou.Q_flow)
  annotation (Line(points={{15,-6},{68,-6},{68,-60},{59,-60}},
                                      color={0,0,127}));
  connect(TSet,reSet. TSet)
  annotation (Line(points={{-110,54},{-56,54},{-56,62.8},{-49,62.8}},
                     color={0,0,127}));
  connect(uMod,reSet. uMod)
  annotation (Line(points={{-112,0},{-88,0},{-88,60},{
          -49,60}}, color={255,127,0}));
  connect(preHeaFloLoa.port, vol1.heatPort)
  annotation (Line(points={{41,20},{-20,
          20},{-20,60},{-10,60}},     color={191,0,0}));
  connect(preHeaFloSou.port, vol2.heatPort)
  annotation (Line(points={{39,-60},{12,-60}}, color={191,0,0}));
  connect(TLoaEnt.y, doe2.TLoaEnt)
  annotation (Line(points={{-59,-30},{-48,-30},{-48,-6.4},{-7,-6.4}},
                             color={0,0,127}));
  connect(TSouEnt.y, doe2.TSouEnt)
  annotation (Line(points={{-59,-12},{-52,-12},{-52,-2.6},{-7,-2.6}},
                             color={0,0,127}));
  connect(TSouMinLvg,reSet.TSouLvgMin)
  annotation (Line(points={{-110,100},{
          -52,100},{-52,69.2},{-49,69.2}},
                                       color={0,0,127}));
  connect(TSouMaxLvg,reSet.TSouLvgMax)
  annotation (Line(points={{-110,86},{-56,
          86},{-56,66},{-49,66}}, color={0,0,127}));
  connect(vol2.heatPort, TSouLvg.port)
  annotation (Line(points={{12,-60},{20,-60},
          {20,-30},{0,-30}}, color={191,0,0}));
  connect(TSouLvg.T, doe2.TSouLvg)
  annotation (Line(points={{-20,-30},{-34,-30},{-34,-9.8},{-7,-9.8}},
                           color={0,0,127}));
  connect(vol1.heatPort, TLoaLvg.port)
  annotation (Line(points={{-10,60},{-20,60},
          {-20,30},{-28,30}}, color={191,0,0}));
  connect(TLoaLvg.T, reSet.TLoaLvg)
  annotation (Line(points={{-48,30},{-54,30},{
          -54,52},{-49,52}}, color={0,0,127}));
  connect(TLoaLvg.T, doe2.TLoaLvg)
  annotation (Line(points={{-48,30},{-54,30},{-54,8.4},{-7,8.4}},
                          color={0,0,127}));
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
        Line(points={{70,-30},{108,-30}},color={28,108,200})}),
        Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
                 preserveAspectRatio=false)),
        defaultComponentName="heaPumDOE2",
Documentation(info="<html>

<p>
Model for a reversible heat pump using the DOE2 method and that takes as an
input the set point for the leaving fluid temperature.
</p>

<p>
This reversable heat pump can be operated either in heating mode or in cooling mode.
It typically is used for a water to water heat pump, but if the performance data
<code>per</code> are set up for other media, such as glycol, it can also be used for
such applications.
The heat exchanger at medium 1 is to be connected to the building load,
and the other heat exchanger to the heat source or sink, such as
a geothermal loop.
If in heating mode, the heat exchanger at medium 1 operates as a condenser,
and in cooling mode it operates as an evaporator.
</p>
<p>
The model takes the following control signals:
</p>
<ul>
<li>
The integer input <code>uMod</code> which controls the heat pump operational mode.
If <code>reverseCycle = true</code> the signal can take on the values
<i>-1</i> for cooling mode,
<i>0</i> for off and
<i>+1</i> for heating mode.<br/>
If <code>reverseCycle = false</code> and <code>uMod = -1</code>, the model stops with an error message.
</li>
<li>
The input <code>TchiSet</code> is the set point for the leaving fluid temperature at port <code>port_b1</code> or
port <code>port_b2</code> based on teh operational mode.
</li>
</ul>
<p>
<code>TchiSet</code> is generated from the built-in controller <code>reSet</code>,
if <code>uMode</code> = +1, using a PI contrller it resets the <code>TSet</code> to <code>TchiSet</code>
till the load leaving water temperature meets <code>TSet</code>.
While if <code>uMode</code> = -1, it outputs that <code>TchiSet</code> equals to <code>TSet</code>.
More details are available at <a href=\"Buildings.Fluid.HeatPumps.BaseClasses.ReSetTSetCoo\">
Buildings.Fluid.HeatPumps.BaseClasses.ReSetTSetCoo</a>.
</p>
<p>
The electric power only includes the power for the compressor, but not any power for pumps, as the pumps must be modeled outside
of this component.
</p>
<h4>Main equations</h4>
<p>
The model uses three performance curves to determine the heat pump operational capacity and efficiency as follows
</p>
<p>
Let <i>&alpha;</i> be the set of capacity function of temperature performance coefficient,
<i>&beta;</i> be the set of electrical input function of temperature performance,
and <i>&gamma;</i> be the set of electrical input to thermal capacity function of part load ratio coeffcients
</p>
<ul>
<li>
The thermal load function of temperature curve <code>CapFT</code> represents the fraction of
the thermal load as it varies by temperature. The output of a bi-quadratic curve with the input
variables being the leaving load side water temperature and the entering source side water temperature
is given by
<p align=\"center\" style=\"font-style:italic;\">
CapFT = &alpha;<sub>1</sub>
+&alpha;<sub>2</sub>T<sub>Sou,Ent</sub>
+&alpha;<sub>3</sub>T<sup>2</sup><sub>Sou,Ent</sub>
+&alpha;<sub>4</sub>T<sub>Loa,Lvg</sub>
+&alpha;<sub>5</sub>T<sup>2</sup><sub>Loa,Lvg</sub>
+&alpha;<sub>6</sub>T<sub>Sou,Ent</sub>T<sub>Loa,Lvg</sub>
</li>
<li>
The electric input to thermal load output ratio function of temperature <code>EIRFT</code>
curve represents the fraction of electricity to the heat pump capacity at full load as it varies
by temperature. The output of a bi-quadratic curve with the input variables being the
leaving load side water temperature and the entering source side water temperature is given by
<p align=\"center\" style=\"font-style:italic;\">
EIRFT = &beta;<sub>1</sub>
+&beta;<sub>2</sub>T<sub>Sou,Ent</sub>
+&beta;<sub>3</sub>T<sup>2</sup><sub>Sou,Ent</sub>
+&beta;<sub>4</sub>T<sub>Loa,Lvg</sub>
+&beta;<sub>5</sub>T<sup>2</sup><sub>Loa,Lvg</sub>
+&beta;<sub>6</sub>T<sub>Sou,Ent</sub>T<sub>Loa,Lvg</sub>
</li>
<li>
The electric input to thermal load output ratio function of part load ratio <code>EIRFRLR</code>
curve represents the fraction of electricity to the heat pump load as the load varies
at a given set of operating temperatures. The curve is normalized so that at
full load the value of the curve should be 1.0.
<p align=\"center\" style=\"font-style:italic;\">
EIRFPLR = &gamma;<sub>1</sub>+ &gamma;<sub>2</sub>PLR+&gamma;<sub>3</sub>PLR<sup>2</sup>
</li>
</ul>
<p>
The perfromance coeffcients and nominal data record <code>per</code> is available at
<a href=\"Buildings.Fluid.Chillers.Data.ElectricEIR\">
Buildings.Fluid.Chillers.Data.ElectricEIR</a>.
Additional performance curves can be developed using
two available techniques Hydeman and Gillespie, (2002). The first technique is called the
Least-squares Linear Regression method and is used when sufficient performance data exist
to employ standard least-square linear regression techniques. The second technique is called
Reference Curve Method and is used when insufficient performance data exist to apply linear
regression techniques.
</p>
<p>
The model has three tests on the part load ratio and the cycling ratio:
</p>
<ol>
<li>
The test<pre>
  PLR1 =min(QEva_flow_set/QEva_flow_ava, PLRMax);
</pre>
ensures that the heatpump capacity does not exceed the heatpump capacity specified
by the parameter <code>PLRMax</code>.
</li>
<li>
The test <pre>
  CR = min(PLR1/per.PRLMin, 1.0);
</pre>
computes a cycling ratio. This ratio expresses the fraction of time
that a heatpump would run if it were to cycle because its load is smaller than the
minimal load at which it can operate.
Note that this model continuously operates even if the part load ratio is below the
minimum part load ratio.
Its leaving source and load temperature can therefore be considered as an
average temperature between the modes where the compressor is off and on.
</li>
<li>
The test <pre>
  PLR2 = max(per.PLRMinUnl, PLR1);
</pre>
computes the part load ratio of the compressor.
The assumption is that for a part load ratio below <code>per.PLRMinUnl</code>,
the heatpump uses hot gas bypass to reduce the capacity, while the compressor
power draw does not change.
</li>
</ol>
<p>
The performance of the heat pump is computed as follows:
<ul>
<li>
It is important to highlight that the DOE2 equations are assoiciated only to the evaporator
perfromance. Hence in case of <code>uMod</code>=+1, the evaporator is the source heat exchanger and
Q&#775;<sub>0</sub> &nbsp; is multiplied by a load ratio<code>loaRat</code> as stated
in EnergyPlus-InputOutput Reference.
</li>
<li>
If <code>uMod = 1</code>, the heat pump is in heating mode and the source side (Evaporator) available heat is
<p align=\"center\" style=\"font-style:italic;\">
Q&#775;<sub>ava</sub> = CapFT &nbsp; Q&#775;<sub>0</sub> &nbsp; s,
</p>
<p>
where <i>Q&#775;<sub>0</sub></i> is the design capacity as specified by the parameter
<code>QHea_flow</code> and <i>s</i> is the scaling factor specified by the parameter <code>scaling_factor</code>.
</p>
<p>
The actual thermal capacity provided at the source side is
<p align=\"center\" style=\"font-style:italic;\">
Q&#775; = min(Q&#775;<sub>ava</sub> , Q&#775;<sub>set</sub>),
</p>
<p>
where <i>Q&#775;<sub>set</sub></i> is the heat required to meet the <code>chiTSet</code> i.e. re setted temperature setpoint
for the leaving fluid on the source side until the Load side leaving water temperature meets the setpoint <code>TSet</code>
for heating loads.
</p>

<p>
The corresponding power consumption is
<p align=\"center\" style=\"font-style:italic;\">
P= Q&#775;<sub>ava</sub> &nbsp; &nbsp; EIRFT &nbsp; EIRFPLR &nbsp; CR &nbsp; P<sub>0</sub> &nbsp; s,
</p>
<p>
where <i>P<sub>0</sub></i> is the design power consumption as specified by the parameter
<code>P_nominal</code>. While in case of <code>uMod</code> =+1, it is multiplied by
<code>PowRat</code> as stated in EnergyPlus-InputOutput Reference
</li>
<li>
If <code>uMod = -1</code>, the heat pump is in cooling mode, and the governing equations are as above,
taking into account the evaporator is considered as the load heat exhanger.
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
EnergyPlus-EngineeringReference-chapter16.6.3.
<i>
EIR Formulated Water To Water Heat Pump Model.
</i>
</p>
<p>
EnergyPlus-InputOutputReference-chapter1.22.26.
<i>
ChillerHeaterPerformance:Electric:EIR.
</i>
</p>
</html>", revisions="<html>
<ul>
<li>
November 27, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end DOE2Reversible;
