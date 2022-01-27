within Buildings.Fluid.Storage.Ice;
model Tank "A detailed ice tank model"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=true);

  constant Modelica.Units.SI.SpecificEnergy Hf = 333550 "Fusion of heat of ice";
  constant Modelica.Units.SI.Temperature TFre = 273.15
    "Freezing temperature of water or the latent energy storage material";
  constant Modelica.Units.SI.TemperatureDifference dT_nominal = 10
     "Nominal temperature difference";
  constant Modelica.Units.SI.TemperatureDifference dTSmall(min=1E-3) = 0.01 "Small temperature difference";

  parameter Modelica.Units.SI.Mass mIce_max "Nominal mass of ice in the tank"
    annotation(Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Mass mIce_start "Start value of ice mass in the tank"
    annotation(Dialog(tab = "Initialization"));

  replaceable parameter Buildings.Fluid.Storage.Ice.Data.Tank.Generic per
    "Performance data" annotation (choicesAllMatching=true, Placement(
        transformation(extent={{60,74},{80,94}})));

  parameter Modelica.Units.SI.Time tau = 30
    "Time constant at nominal flow"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));

  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.Temperature T_start = Medium.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.MassFraction X_start[Medium.nX](
    final quantity=Medium.substanceNames) = Medium.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium.nC](
    final quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));

  final parameter Modelica.Units.SI.Energy QSto_nominal=Hf*mIce_max "Normal stored energy";
  final parameter Modelica.Units.SI.SpecificHeatCapacity cp = Medium.specificHeatCapacityCp(
    Medium.setState_pTX(
        p=Medium.p_default,
        T=273.15,
        X=Medium.X_default)) "Specific heat capacity";

  Modelica.Blocks.Interfaces.RealOutput SOC(
    final unit = "1")
    "state of charge"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}}),
        iconTransformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealOutput mIce(
    quantity="Mass",
    unit="kg") "Mass of remaining ice"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}}),
        iconTransformation(extent={{100,-60},{120,-40}})));

  BaseClasses.StorageHeatTransferRate norQSta(
    final coeCha=per.coeCha,
    final coeDisCha=per.coeDisCha,
    final dtCha=per.dtCha,
    final dtDisCha=per.dtDisCha)
    annotation (Placement(transformation(extent={{6,28},{26,48}})));
  Modelica.Blocks.Math.Gain gai(k=QSto_nominal) "Gain"
    annotation (Placement(transformation(extent={{34,28},{54,48}})));
  Buildings.Fluid.Storage.Ice.BaseClasses.LMTDStar lmtdSta(
    final TFre=TFre,
    final dT_nominal=dT_nominal)
    annotation (Placement(transformation(extent={{-50,22},{-30,42}})));

  Buildings.Fluid.Storage.Ice.BaseClasses.IceMass iceMas(
    final mIce_max=mIce_max,
    final mIce_start=mIce_start,
    final Hf=Hf)
    "Mass of the remaining ice"
    annotation (Placement(transformation(extent={{52,-80},{72,-60}})));
protected
  Buildings.Fluid.HeatExchangers.HeaterCooler_u hea(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=m_flow_small,
    final show_T=show_T,
    final from_dp=from_dp,
    final dp_nominal=0,
    final linearizeFlowResistance=linearizeFlowResistance,
    final deltaM=deltaM,
    final tau=tau,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final Q_flow_nominal=1)
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));

  Modelica.Blocks.Math.Max QMax_flow "Maximum heat flow rate"
    annotation (Placement(transformation(extent={{-48,-96},{-28,-76}})));
  Modelica.Blocks.Math.Min QMin_flow "Miminum heat flow rate"
    annotation (Placement(transformation(extent={{-48,-66},{-28,-46}})));
  Modelica.Blocks.Logical.Switch Q_flow "Heat flow rate extracted from fluid"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));

  Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
    "Mass flow rate through the tank"
    annotation (Placement(transformation(extent={{-66,60},{-46,80}})));
  Controls.OBC.CDL.Continuous.LessThreshold canFreeze(
    final t=TFre - dTSmall,
    final h=dTSmall/2)
    "Outputs true if temperatures allow ice to be produced"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold canMelt(
    final t=TFre + dTSmall,
    final h=dTSmall/2)
    "Outputs true if temperature allows tank to be melted"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Modelica.Blocks.Sources.RealExpression limQ_flow(final y=senMasFlo.m_flow*cp*
        (TFre - TIn.y)) "Upper/Lower limit for charging/discharging rate"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));

  Modelica.Blocks.Sources.RealExpression TIn(final y=Medium.temperature(state=
        Medium.setState_phX(
        p=port_a.p,
        h=inStream(port_a.h_outflow),
        X=inStream(port_a.Xi_outflow)))) "Inlet temperature into tank"
    annotation (Placement(transformation(extent={{-92,40},{-72,60}})));

  Modelica.Blocks.Sources.RealExpression TOut(final y=Medium.temperature(state=
        Medium.setState_phX(
        p=hea.port_b.p,
        h=hea.port_b.h_outflow,
        X=hea.port_b.Xi_outflow))) "Outlet temperature of the tank"
    annotation (Placement(transformation(extent={{-92,18},{-72,38}})));

equation
  connect(norQSta.qNor, gai.u)
    annotation (Line(points={{27,38},{32,38}},color={0,0,127}));
  connect(iceMas.mIce, mIce) annotation (Line(points={{73,-70},{96,-70},{96,-50},
          {110,-50}}, color={0,0,127}));
  connect(Q_flow.y, iceMas.Q_flow)
    annotation (Line(points={{21,-70},{50,-70}}, color={0,0,127}));
  connect(Q_flow.y, hea.u) annotation (Line(points={{21,-70},{26,-70},{26,22},{
          -16,22},{-16,76},{-12,76}}, color={0,0,127}));
  connect(QMin_flow.y, Q_flow.u1) annotation (Line(points={{-27,-56},{-8,-56},{
          -8,-62},{-2,-62}}, color={0,0,127}));
  connect(gai.y, QMin_flow.u2) annotation (Line(points={{55,38},{58,38},{58,-14},
          {-14,-14},{-14,-70},{-56,-70},{-56,-62},{-50,-62}}, color={0,0,127}));
  connect(gai.y, QMax_flow.u1) annotation (Line(points={{55,38},{58,38},{58,-14},
          {-14,-14},{-14,-70},{-56,-70},{-56,-80},{-50,-80}}, color={0,0,127}));
  connect(limQ_flow.y, QMax_flow.u2) annotation (Line(points={{-69,-50},{-60,-50},
          {-60,-92},{-50,-92}}, color={0,0,127}));
  connect(limQ_flow.y, QMin_flow.u1)
    annotation (Line(points={{-69,-50},{-50,-50}}, color={0,0,127}));
  connect(iceMas.fraCha, SOC) annotation (Line(points={{73,-66},{92,-66},{92,-20},
          {110,-20}}, color={0,0,127}));
  connect(QMax_flow.y, Q_flow.u3) annotation (Line(points={{-27,-86},{-8,-86},{
          -8,-78},{-2,-78}}, color={0,0,127}));
  connect(lmtdSta.lmtdSta, norQSta.lmtdSta) annotation (Line(points={{-29,32},{4,
          32}},                          color={0,0,127}));
  connect(iceMas.fraCha, norQSta.fraCha) annotation (Line(points={{73,-66},{78,-66},
          {78,-20},{-2,-20},{-2,38},{4,38}},       color={0,0,127}));
  connect(lmtdSta.TIn, TIn.y) annotation (Line(points={{-52,36},{-64,36},{-64,50},
          {-71,50}}, color={0,0,127}));
  connect(TOut.y, lmtdSta.TOut)
    annotation (Line(points={{-71,28},{-52,28}}, color={0,0,127}));
  connect(hea.port_b, port_b) annotation (Line(points={{10,70},{80,70},{80,0},{
          100,0}},
               color={0,127,255}));
  connect(port_a, senMasFlo.port_a) annotation (Line(points={{-100,0},{-86,0},{-86,
          14},{-96,14},{-96,70},{-66,70}}, color={0,127,255}));
  connect(senMasFlo.port_b, hea.port_a)
    annotation (Line(points={{-46,70},{-10,70}}, color={0,127,255}));
  connect(TIn.y, canMelt.u) annotation (Line(points={{-71,50},{-64,50},{-64,0},{
          -62,0}}, color={0,0,127}));
  connect(TIn.y, canFreeze.u) annotation (Line(points={{-71,50},{-64,50},{-64,-30},
          {-62,-30}}, color={0,0,127}));
  connect(norQSta.canMelt, canMelt.y) annotation (Line(points={{4,46},{-24,46},
          {-24,0},{-38,0}},color={255,0,255}));
  connect(canFreeze.y, norQSta.canFreeze) annotation (Line(points={{-38,-30},{
          -20,-30},{-20,42},{4,42}},
                                 color={255,0,255}));
  connect(canFreeze.y, Q_flow.u2) annotation (Line(points={{-38,-30},{-10,-30},
          {-10,-70},{-2,-70}}, color={255,0,255}));
  annotation (defaultComponentModel="iceTan", Icon(graphics={
        Rectangle(
          extent={{-76,46},{76,70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-76,46},{76,-92}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-62,28},{-46,-92}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-34,28},{-18,-92}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-6,28},{10,-92}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{22,28},{38,-92}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{50,28},{66,-92}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-90,4},{90,-2}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{58,22},{62,80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{58,78},{100,82}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,48},{102,52}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,18},{102,22}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>This model implements an ice tank model based on the detailed EnergyPlus ice tank model
<a href=\"https://bigladdersoftware.com/epx/docs/9-0/input-output-reference/group-plant-equipment.html#thermalstorageicedetailed\">ThermalStorage:Ice:Detailed</a>.
The governing equations are as follows:
</p>
<p>
The mass of ice in the storage <i>m<sub>ice</sub></i> is calculated as
</p>
<p align=\"center\" style=\"font-style:italic;\">
dx/dt = Q&#775;/(H<sub>f</sub> &nbsp; m<sub>ice,max</sub>)
</p>
<p align=\"center\" style=\"font-style:italic;\">
m<sub>ice</sub> = x &nbsp; m<sub>ice,max
</p>
<p>
where <i>x</i> is the fraction of charge, or the state of charge,
<i>Q&#775;</i> is the heat transfer rate of the ice tank, positive for charging and negative for discharging,
<i>Hf</i> is the fusion of heat of ice and
<i>m<sub>ice,max</sub></i> is the nominal mass of ice in the storage tank.
</p>
<p>
The heat transfer rate of the ice tank <i>Q&#775;</i> is computed using
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q&#775; = Q<sub>sto,nom</sub> &nbsp; q<sup>*</sup>,
</p>
<p>
where
<i>Q<sub>sto,nom</sub></i> is the storage capacity and
<i>q<sup>*</sup></i> is a normalized heat flow rate.
The storage capacity is
<p align=\"center\" style=\"font-style:italic;\">
Q<sub>sto,nom</sub> = Hf &nbsp; m<sub>ice,max</sub>,
</p>
<p>
where <i>Hf</i> is the latent heat of fusion of ice and
<i>m<sub>ice,max</sub></i> is the maximum ice storage capacity.
</p>
<p>
The normalized heat flow rate is computed using performance curves
for charging (freezing) or discharging (melting).
For charging, the heat transfer rate <i>q*</i> between the chilled water
and the ice in the thermal storage tank is calculated using
</p>
<p align=\"center\">
<i>
q<sup>*</sup> &Delta;t = C<sub>1</sub> + C<sub>2</sub>x + C<sub>3</sub> x<sup>2</sup> + [C<sub>4</sub> + C<sub>5</sub>x + C<sub>6</sub> x<sup>2</sup>]&Delta;T<sub>lmtd<sup>*</sup>
</i>
</p>
<p>where <i>&Delta;t</i> is the time step of the data samples used for the curve fitting,
<i>C<sub>1-6</sub></i> are the curve fit coefficients,
<i>x</i> is the fraction of charging, also known as the state-of-charge,
and <i>T<sub>lmtd<sup>*</sup></i> is the normalized LMTD
calculated using <a href=\"mdoelica://Buildings.Fluid.Storage.Ice.BaseClasses.calculateLMTDStar\">
Buildings.Fluid.Storage.Ice.BaseClasses.calculateLMTDStar</a>.
Similarly, for discharging, the heat transfer rate <i>q*</i>
between the chilled water and the ice in the thermal storage tank is
</p>
<p align=\"center\" style=\"font-style:italic;\">
 q<sup>*</sup> &Delta;t = D<sub>1</sub> + D<sub>2</sub>(1-x) + D<sub>3</sub> (1-x)<sup>2</sup> + [D<sub>4</sub> + D<sub>5</sub>(1-x) + D<sub>6</sub> (1-x)<sup>2</sup>]&Delta;T<sub>lmtd</sub><sup>*</sup>
</p>
<p>
where <i>&Delta;t</i> is the time step of the data samples used for the curve fitting,
<i>D<sub>1-6</sub></i> are the curve fit coefficients.
<p>
The normalized LMTD <i>&Delta;T<sub>lmtd<sup>*</sup></i> uses a nominal temperature difference of 10 Kelvin.
This value must be used when obtaining the curve fit coefficients.
</p>
<p>
The log mean temperature difference is calculated using
</p>
<p align=\"center\" style=\"font-style:italic;\">
    &Delta;T<sub>lmtd</sub><sup>*</sup> = &Delta;T<sub>lmtd</sub>/T<sub>nom</sub>
</p>
<p align=\"center\" style=\"font-style:italic;\">
 &Delta;T<sub>lmtd</sub> = (T<sub>in</sub> - T<sub>out</sub>)/ln((T<sub>in</sub> - T<sub>fre</sub>)/(T<sub>out</sub> - T<sub>fre</sub>))
</p>
<p>
where <i>T<sub>in</sub></i> is the inlet temperature, <i>T<sub>out</sub></i> is the outlet temperature,
<i>T<sub>fre</sub></i> is the freezing temperature
and <i>T<sub>nom</sub></i> is a nominal temperature difference of 10 Kelvin.
</p>
<h4>
Reference
</h4>
<p>
Strand, R.K. 1992. “Indirect Ice Storage System Simulation,” M.S. Thesis,
Department of Mechanical and Industrial Engineering, University of Illinois at Urbana-Champaign.

</p>
</html>", revisions="<html>
<ul>
<li>
December 14, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Tank;
