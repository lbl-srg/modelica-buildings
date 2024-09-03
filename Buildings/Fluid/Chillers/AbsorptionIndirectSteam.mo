within Buildings.Fluid.Chillers;
model AbsorptionIndirectSteam
  "Indirect steam heated absorption chiller based on performance curves"
    extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
     T1_start = 273.15+25,
     T2_start = 273.15+5,
     m1_flow_nominal= per.mCon_flow_nominal,
     m2_flow_nominal= per.mEva_flow_nominal,
     dp1_nominal = per.dpCon_nominal,
     dp2_nominal = per.dpEva_nominal,
   redeclare final Buildings.Fluid.MixingVolumes.MixingVolume
      vol1(final V=m1_flow_nominal*tau1/rho1_nominal,
           nPorts=2,
           final prescribedHeatFlowRate=true),
      vol2(final V=m2_flow_nominal*tau2/rho2_nominal,
           nPorts=2,
           final prescribedHeatFlowRate=true));

  parameter Buildings.Fluid.Chillers.Data.AbsorptionIndirectSteam.Generic per
   "Performance data"
    annotation (choicesAllMatching= true,
       Placement(transformation(extent={{60,72},{80,92}})));
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_small=-per.QEva_flow_nominal*
      1E-6
    "Small value for heat flow rate or power, used to avoid division by zero"
    annotation (Dialog(tab="Advanced"));

  Modelica.Blocks.Interfaces.BooleanInput on
    "Set to true to enable the absorption chiller"
     annotation (Placement(transformation(extent={{-128,2},{-100,30}}),
                                    iconTransformation(extent={{-120,10},{-100,
            30}})));
  Modelica.Blocks.Interfaces.RealInput TSet(final unit="K", displayUnit="degC")
    "Evaporator setpoint leaving water temperature" annotation (Placement(
        transformation(extent={{-128,-38},{-100,-10}}), iconTransformation(
          extent={{-120,-30},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealOutput P(final unit="W")
   "Chiller pump power"
     annotation (Placement(transformation(extent={{100,10},{120,30}}),
                            iconTransformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealOutput QGen_flow(final unit="W")
  "Required generator heat flow rate in the form of steam"
     annotation (Placement(transformation(extent={{100,-30},{120,-10}}),
        iconTransformation(extent={{100,10},{120,30}})));
  Modelica.Blocks.Interfaces.RealOutput QEva_flow(final unit="W")
  "Evaporator heat flow rate"
     annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
        iconTransformation(extent={{100,-96},{120,-76}})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow(final unit="W")
  "Condenser heat flow rate"
     annotation (Placement(transformation(extent={{100,30},{120,50}}),
        iconTransformation(extent={{100,74},{120,94}})));

  Real PLR(min=0, final unit="1") = perMod.PLR
   "Part load ratio";
  Real CR(min=0, final unit="1") = perMod.CR
   "Cycling ratio";

protected
  BaseClasses.AbsorptionIndirectSteam perMod(
    final per=per,
    final Q_flow_small=Q_flow_small) "Block that computes the performance"
    annotation (Placement(transformation(extent={{-52,0},{-32,20}})));

  Modelica.Blocks.Sources.RealExpression QEva_flow_set(
    final y=Buildings.Utilities.Math.Functions.smoothMin(
        x1=m2_flow*(hEvaSet - inStream(port_a2.h_outflow)),
        x2=-Q_flow_small,
        deltaX=Q_flow_small/10)) "Setpoint heat flow rate of the evaporator"
    annotation (Placement(transformation(extent={{-92,-28},{-72,-8}})));

  Modelica.Units.SI.SpecificEnthalpy hEvaSet=Medium2.specificEnthalpy_pTX(
      p=port_b2.p,
      T=TSet,
      X=cat(
        1,
        port_b2.Xi_outflow,
        {1 - sum(port_b2.Xi_outflow)})) "Chilled water setpoint enthalpy";

  Modelica.Blocks.Sources.RealExpression TConEnt(
        y=Medium1.temperature(
        Medium1.setState_phX(
          p = port_a1.p,
          h = inStream(port_a1.h_outflow))))
   "Condenser entering water temperature"
     annotation (Placement(transformation(extent={{-92,-8},{-72,10}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TEvaLvg
    "Leaving evaporator temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-42,-40})));

  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloCon
    "Prescribed heat flow rate for the condenser"
     annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-37,40})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloEva
    "Prescribed heat flow rate for the evaporator"
     annotation (Placement(transformation(extent={{-1,-40},{19,-20}})));

equation
  connect(on, perMod.on) annotation (Line(points={{-114,16},{-94,16},{-94,17},{
          -53,17}},
                color={255,0,255}));
  connect(perMod.QCon_flow, preHeaFloCon.Q_flow) annotation (Line(points={{-31,18},
          {-20,18},{-20,28},{-52,28},{-52,40},{-47,40}}, color={0,0,127}));
  connect(perMod.QEva_flow, preHeaFloEva.Q_flow) annotation (Line(points={{-31,8},
          {-20,8},{-20,-30},{-1,-30}},   color={0,0,127}));
  connect(preHeaFloEva.port, vol2.heatPort)
    annotation (Line(points={{19,-30},{28,-30},{28,-60},{12,-60}},
                                  color={191,0,0}));
  connect(perMod.QEva_flow, QEva_flow) annotation (Line(points={{-31,8},{88,8},
          {88,-40},{110,-40}},                    color={0,0,127}));
  connect(TConEnt.y, perMod.TConEnt) annotation (Line(points={{-71,1},{-66,1},{
          -66,13},{-53,13}},      color={0,0,127}));
  connect(QEva_flow_set.y, perMod.QEva_flow_set) annotation (Line(points={{-71,-18},
          {-64,-18},{-64,7},{-53,7}},    color={0,0,127}));
  connect(preHeaFloCon.port, vol1.heatPort) annotation (Line(points={{-27,40},{-20,
          40},{-20,60},{-10,60}},                                     color={
          191,0,0}));
  connect(perMod.QCon_flow, QCon_flow) annotation (Line(points={{-31,18},{86,18},
          {86,40},{110,40}}, color={0,0,127}));
  connect(perMod.QGen_flow, QGen_flow) annotation (Line(points={{-31,12},{92,12},
          {92,-20},{110,-20}},color={0,0,127}));
  connect(TEvaLvg.port, vol2.heatPort) annotation (Line(points={{-32,-40},{28,
          -40},{28,-60},{12,-60}},
                              color={191,0,0}));
  connect(TEvaLvg.T, perMod.TEvaLvg) annotation (Line(points={{-52,-40},{-60,
          -40},{-60,3},{-53,3}},     color={0,0,127}));
  connect(perMod.P, P) annotation (Line(points={{-31,15},{94,15},{94,20},{110,
          20}}, color={0,0,127}));
  annotation (Icon(graphics={
        Line(points={{-40,76}}, color={238,46,47}),
        Line(
          points={{-100,-20},{-82,-20},{-82,-60}},
          color={0,0,127},
          thickness=0.5),
        Rectangle(
          extent={{-56,68},{58,50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,-52},{58,-70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
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
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,0},{-52,10},{-32,10},{-42,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,50},{-40,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-12},{-40,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,50},{42,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{24,16},{56,-16}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,16},{24,0},{56,0},{40,16}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
defaultComponentName="chi",
Documentation(info="<html>
<p>
Model for an indirect steam heated absorption chiller based on performance curves.
The model uses performance curves similar to the EnergyPlus model <code>Chiller:Absorption:Indirect</code>.
</p>
<p>
The model uses six functions to predict the chiller cooling capacity, power consumption for
the chiller pump and the generator heat flow rate and the condenser heat flow.
These functions use the performance data stored in the record <code>per</code>.
The computations are as follows:
</p>
<p>
The capacity function of the evaporator is
<p align=\"center\" style=\"font-style:italic;\">
capFun<sub>eva</sub> = A<sub>1</sub> + A<sub>2</sub> T<sub>eva,lvg</sub> +
A<sub>3</sub> T<sup>2</sup><sub>eva,lvg</sub> + A<sub>4</sub> T<sup>3</sup><sub>eva,lvg</sub>.
</p>
<p>
The capacity function of the condenser is
<p align=\"center\" style=\"font-style:italic;\">
capFun<sub>con</sub> = B<sub>1</sub> + B<sub>2</sub> T<sub>con,ent</sub> +
B<sub>3</sub> T<sup>2</sup><sub>con,ent</sub> + B<sub>4</sub> T<sup>3</sup><sub>con,ent</sub>.
</p>

<p>
These capacity functions are used to compute the available cooling capacity of the evaporator as
<p align=\"center\" style=\"font-style:italic;\">
Q&#775;<sub>eva,ava</sub> = capFun<sub>eva</sub> &nbsp; capFun<sub>con</sub> &nbsp; Q&#775;<sub>eva,0</sub>,
</p>
<p>
where <i>Q&#775;<sub>eva,0</sub></i> is obtained from the performance data <code>per.QEva_flow_nominal</code>.
Let <i>Q&#775;<sub>eva,set</sub></i> denote the heat required to meet the set point <code>TSet</code>.
Then, the model computes the part load ratio as
<p align=\"center\" style=\"font-style:italic;\">
  PLR =min(Q&#775;<sub>eva,set</sub>/Q&#775;<sub>eva,ava</sub>, PLR<sub>max</sub>).
</p>
<p>

Hence, the model ensures that the chiller capacity does not exceed the chiller capacity specified
by the parameter <code>per.PLRMax</code>.
The cycling ratio is computed as
<p align=\"center\" style=\"font-style:italic;\">
CR = min(PLR/PLR<sub>min</sub>, 1.0),
</p>
<p>
where <i>PRL<sub>min</sub></i> is obtained from the performance record <code>per.PLRMin</code>.
This ratio expresses the fraction of time
that a chiller would run if it were to cycle because its load is smaller than the
minimal load at which it can operate.
Note that this model continuously operates even if the part load ratio is below the
minimum part load ratio.
Its leaving evaporator and condenser temperature can therefore be considered as an
average temperature between the modes when the compressor is off and on.
</p>

<p>
Using the part load ratio, the energy input ratio of the chiller pump is
<p align=\"center\" style=\"font-style:italic;\">
EIRP = C<sub>1</sub> + C<sub>2</sub>PLR+C<sub>3</sub>PLR<sup>2</sup>.
</p>
<p>
The generator heat input ratio is
<p align=\"center\" style=\"font-style:italic;\">
genHIR = D<sub>1</sub> + D<sub>2</sub>PLR+D<sub>3</sub>PLR<sup>2</sup>+D<sub>4</sub>PLR<sup>3</sup>.
</p>
<p>
Two additional curves modify the heat input requirement based on the condenser inlet water temperature
and the evaporator outlet water temperature. Specifically,
the generator heat modifier based on the condenser inlet water temperature is
<p align=\"center\" style=\"font-style:italic;\">
genT<sub>con</sub> = E<sub>1</sub> + E<sub>2</sub> T<sub>con,ent</sub> +
E<sub>3</sub> T<sup>2</sup><sub>con,ent</sub> + E<sub>4</sub> T<sup>3</sup><sub>con,ent</sub>,
</p>
<p>
and the generator heat modifier based on the evaporator inlet water temperature is
<p align=\"center\" style=\"font-style:italic;\">
genT<sub>eva</sub>= F<sub>1</sub> + F<sub>2</sub> T<sub>eva,lvg</sub> +
F<sub>3</sub> T<sup>2</sup><sub>eva,lvg</sub> + F<sub>4</sub> T<sup>3</sup><sub>eva,lvg</sub>.
</p>
<p>
The main outputs of the model that are to be used in energy analysis
are the required generator heat <code>QGen_flow</code> and
the electric power consumption of the chiller pump <code>P</code>.
For example, if the chiller were to be regenerated with steam, then
<code>QGen_flow</code> is the heat that must be provided by a steam loop.
This model computes the required generator heat as
<p align=\"center\" style=\"font-style:italic;\">
Q&#775;<sub>gen</sub> = -Q&#775;<sub>eva,ava</sub> genHIR genT<sub>con</sub> genT<sub>eva</sub> CR.
</p>
<p>
The pump power consumption is
<p align=\"center\" style=\"font-style:italic;\">
    P =  EIRP CR P<sub>0</sub>,
</p>
<p>
where <i>P<sub>0</sub></i> is the pump nominal power obtained from the performance data <code>per.P_nominal</code>.
The heat balance of the chiller is
<p align=\"center\" style=\"font-style:italic;\">
 Q&#775;<sub>con</sub> = -Q&#775;<sub>eva</sub> + Q&#775;<sub>gen</sub> + P.
</p>
<h4>Performance data</h4>
<p>
The equipment performance data is obtained from the record <code>per</code>,
which is an instance of
<a href=\"modelica://Buildings.Fluid.Chillers.Data.AbsorptionIndirectSteam\">
Buildings.Fluid.Chillers.Data.AbsorptionIndirectSteam</a>.
Additional performance curves can be developed using
two available techniques (Hydeman and Gillespie, 2002). The first technique is called the
Least-squares Linear Regression method and is used when sufficient performance data exist
to employ standard least-square linear regression techniques. The second technique is called
Reference Curve Method and is used when insufficient performance data exist to apply linear
regression techniques. A detailed description of both techniques can be found in
Hydeman and Gillespie (2002).
</p>

<h4>References</h4>
<ul>
<li>
Hydeman, M. and K.L. Gillespie. 2002. Tools and Techniques to Calibrate Electric Chiller
Component Models. <i>ASHRAE Transactions</i>, AC-02-9-1.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
November 26, 2019, by Michael Wetter:<br/>
Revised implementation and documentation.
</li>
<li>
July 3, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end AbsorptionIndirectSteam;
