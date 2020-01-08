within Buildings.Fluid.Chillers;
model AbsorptionIndirectHotWaterSwitchableRecords
  "Indirect hot water heated absorption chiller based on performance curves"

  extends Buildings.Fluid.Chillers.BaseClasses.SixPortHeatMassExchanger(
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume
      conVol(
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        V=m1_flow_nominal*tau1/rho1_nominal,
        nPorts=2,
        final prescribedHeatFlowRate=true),
      evaVol(
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        V=m2_flow_nominal*tau2/rho2_nominal,
        nPorts=2,
        final prescribedHeatFlowRate=true),
      genVol(
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        V=m3_flow_nominal*tau3/rho3_nominal,
        nPorts=2,
        final prescribedHeatFlowRate=true),
      dp1_nominal=per.dpCon_nominal,
      dp2_nominal=per.dpEva_nominal,
      dp3_nominal=per.dpGen_nominal,
      massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      show_T=true,
      T1_start=273.15 + 25,
      T2_start=273.15 + 7,
      T3_start=273.15 + 80,
      m1_flow_nominal=mCon_flow_nominal,
      m2_flow_nominal=mEva_flow_nominal,
      m3_flow_nominal=mGen_flow_nominal);

  final parameter Modelica.SIunits.HeatFlowRate QEva_heatflow_nominal= per.QEva_flow_nominal
    "Nominal heat flow at the evaporator"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal = per.mCon_flow_nominal
   "Nominal mass flow at Condenser"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal = per.mEva_flow_nominal
   "Nominal mass flow at Evaorator"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.MassFlowRate mGen_flow_nominal = per.mGen_flow_nominal
   "Nominal mass flow at Evaorator"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.HeatFlowRate Q_flow_small = -QEva_heatflow_nominal*1E-9
    "Small value for heat flow rate or power, used to avoid division by zero";

  Modelica.Blocks.Interfaces.BooleanInput on
   "Chiller turn On/off inout signal "
    annotation (Placement(transformation(extent={{-128,26},{-100,54}}),
                                    iconTransformation(extent={{-140,70},{-120,90}})));
  Modelica.Blocks.Interfaces.RealInput TSet(final unit="K", displayUnit="degC")
   "Evaporator setpoint leaving water temperature"
    annotation (Placement(
        transformation(extent={{-126,-64},{-100,-38}}), iconTransformation(
          extent={{-140,-50},{-120,-30}})));

  Modelica.SIunits.SpecificEnthalpy hEvaSet=Medium2.specificEnthalpy_pTX(
      p=evaLvg.p,
      T=TSet,
      X=cat(
        1,
        evaLvg.Xi_outflow,
        {1 - sum(evaLvg.Xi_outflow)})) "Chilled water setpoint enthalpy";
  Modelica.Blocks.Interfaces.RealOutput P( final unit="W")
   "Chiller pump power"
    annotation (Placement(transformation(extent={{100,-22},{120,-2}}),
                            iconTransformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealOutput QGen_flow( final unit="W")
  "Required generator heat flow rate in the form of hot water"
    annotation (Placement(transformation(extent={{100,-38},{120,-18}}),
        iconTransformation(extent={{100,10},{120,30}})));
  Modelica.Blocks.Interfaces.RealOutput QEva_flow( final unit="W")
  "Evaporator heat flow "
    annotation (Placement(transformation(extent={{100,-54},{120,-34}}),
        iconTransformation(extent={{100,-70},{120,-50}})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow( final unit="W")
   "Condenser heat flow "
    annotation (Placement(transformation(extent={{100,40},{120,60}}),
        iconTransformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Sources.RealExpression TConEnt(y=Medium1.temperature(
        Medium1.setState_phX(conEnt.p, inStream(conEnt.h_outflow))))
    "Condenser entering water temperature"
    annotation (Placement(transformation(extent={{-98,-26},{-78,-6}})));

  Modelica.Blocks.Sources.RealExpression TGenEnt(y=Medium3.temperature(
        Medium3.setState_phX(genEnt.p, inStream(genEnt.h_outflow))))
    "Generator entering water temperature"
    annotation (Placement(transformation(extent={{-98,10},{-78,30}})));
  Modelica.Blocks.Sources.RealExpression QEva_flow_set(final y=
        Buildings.Utilities.Math.Functions.smoothMin(
        m2_flow*(hEvaSet - inStream(evaEnt.h_outflow)),
        -Q_flow_small,
        Q_flow_small/100)) "Setpoint heat flow rate of the evaporator"
    annotation (Placement(transformation(extent={{-98,-46},{-78,-26}})));
  BaseClasses.AbsorptionIndirectRemovableRecords perMod(
      final  per=per,
      final  hotWater=true,
      final  Q_flow_small = Q_flow_small)
    annotation (Placement(transformation(extent={{-66,-32},{-46,-12}})));
  replaceable Data.AbsorptionIndirect.AbsorptionIndirectHotWater per
    constrainedby Data.AbsorptionIndirect.AbsorptionIndirectHotWater
    "Performance data for indirect hot water absorption chiller"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

protected
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloCon
    "Prescribed heat flow rate for the condenser"
    annotation (Placement(transformation(extent={{-35,60},{-15,80}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloGen
    "Prescribed heat flow rate for the Generator"
    annotation (Placement(transformation(extent={{-35,0},{-15,20}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloEva
    "Prescribed heat flow rate for the Evaporator"
    annotation (Placement(transformation(extent={{-35,-70},{-15,-50}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TEvaLvg
    "Leaving evaporator temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-56,-70})));
equation
  connect(preHeaFloCon.port, conVol.heatPort)
    annotation (Line(points={{-15,70},{-10,70}}, color={191,0,0}));
  connect(preHeaFloGen.port, genVol.heatPort)
    annotation (Line(points={{-15,10},{-10,10}}, color={191,0,0}));
  connect(perMod.QCon_flow, preHeaFloCon.Q_flow)
    annotation (Line(points={{-45,-14},
          {-42,-14},{-42,70},{-35,70}}, color={0,0,127}));
  connect(perMod.QCon_flow, QCon_flow)
    annotation (Line(points={{-45,-14},{-42,-14},
          {-42,50},{110,50}}, color={0,0,127}));
  connect(perMod.QGen_flow, QGen_flow)
    annotation (Line(points={{-45,-20},{-40,-20},{-40,-28},{110,-28}},
                                                   color={0,0,127}));
  connect(evaVol.heatPort, preHeaFloEva.port)
    annotation (Line(points={{-10,-60},{-15,-60}}, color={191,0,0}));
  connect(perMod.QGen_flow, preHeaFloGen.Q_flow)
    annotation (Line(points={{-45,-20},
          {-40,-20},{-40,10},{-35,10}}, color={0,0,127}));
  connect(perMod.QEva_flow, preHeaFloEva.Q_flow)
    annotation (Line(points={{-45,-24},{-42,-24},{-42,-60},{-35,-60}},
                                          color={0,0,127}));
  connect(perMod.QEva_flow, QEva_flow)
    annotation (Line(points={{-45,-24},{-42,-24},{-42,-44},{110,-44}},
                                color={0,0,127}));
  connect(TConEnt.y,perMod. TConEnt)
    annotation (Line(points={{-77,-16},{-76,-16},
          {-76,-22},{-67,-22}}, color={0,0,127}));
  connect(evaVol.heatPort, TEvaLvg.port)
    annotation (Line(points={{-10,-60},{-14,-60},{-14,-70},{-46,-70}},
                                     color={191,0,0}));
  connect(perMod.TEvaLvg, TEvaLvg.T)
    annotation (Line(points={{-67,-29},{-70,-29},{-70,-70},{-66,-70}},
                                color={0,0,127}));
  connect(QEva_flow_set.y,perMod. QEva_flow_set)
    annotation (Line(points={{-77,-36},
          {-72,-36},{-72,-26},{-67,-26}}, color={0,0,127}));
  connect(on,perMod. on)
    annotation (Line(points={{-114,40},{-70,40},{-70,-15},{
          -67,-15}}, color={255,0,255}));
  connect(TGenEnt.y,perMod. TGenEnt)
    annotation (Line(points={{-77,20},{-72,20},
          {-72,-19},{-67,-19}}, color={0,0,127}));
  connect(perMod.P, P)
    annotation (Line(points={{-45,-17},{86,-17},{86,-12},{110,-12}},
                 color={0,0,127}));
  annotation (Icon(coordinateSystem(extent={{-120,-100},{100,100}}),
                   graphics={
        Line(points={{-40,76}}, color={238,46,47}),
        Rectangle(
          extent={{-72,90},{70,-90}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,90},{66,72}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,-54},{62,-72}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-95,86},{106,76}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{6,76},{106,86}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-95,-76},{106,-86}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-92,-86},{8,-76}},
          lineColor={0,0,127},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-44,22},{-54,10},{-34,10},{-44,22}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-44,22},{-54,32},{-34,32},{-44,22}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-46,72},{-42,32}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-46,10},{-42,-54}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{46,72},{50,-54}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{32,38},{64,6}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{48,38},{32,22},{64,22},{48,38}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-120,-40},{-80,-40},{-80,-80}},
          color={0,0,127},
          thickness=0.5),        Text(
          extent={{-161,137},{139,97}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),
                           Diagram(coordinateSystem(extent={{-100,
            -100},{100,100}})),
            defaultComponentName="chi",
Documentation(info="<html>
<p>
Model for an indirect hot water heated absorption chiller based on performance curves.
The model uses performance curves similar to the EnergyPlus model <code>Chiller:Absorption:Indirect</code> 
hot water only.
</p>
<p>
The model uses seven functions to predict the chiller cooling capacity, power consumption for
the chiller pump, the generator heat flow rate and the condenser heat flow.
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
The capacity function of the generator is
<p align=\"center\" style=\"font-style:italic;\">
capFun<sub>gen</sub> = C<sub>1</sub> + C<sub>2</sub>T<sub>gen,ent</sub> +
C <sub>3</sub> T<sup>2</sup><sub>Gen,ent</sub>.
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
Q&#775;<sub>eva,ava</sub> = capFun<sub>eva</sub> &nbsp; capFun<sub>con</sub> &nbsp; capFun<sub>gen</sub> &nbsp; Q&#775;<sub>eva,0</sub>,
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
Two additional curves modifiy the heat input requirement based on the condenser inlet water temperature
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
<a href=\"Buildings.Fluid.Chillers.Data.AbsorptionIndirectSteam.AbsorptionIndirectHotWater\">
Buildings.Fluid.Chillers.Data.AbsorptionIndirectSteam.AbsorptionIndirectHotWater</a>.
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
January 6, 2020, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end AbsorptionIndirectHotWaterSwitchableRecords;
