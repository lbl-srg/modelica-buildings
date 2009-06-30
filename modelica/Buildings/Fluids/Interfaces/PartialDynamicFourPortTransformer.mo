within Buildings.Fluids.Interfaces;
partial model PartialDynamicFourPortTransformer
  "Partial model transporting two fluid streams between four ports with storing mass or energy"
  extends Buildings.Fluids.Interfaces.PartialStaticFourPortInterface;
  extends Buildings.Fluids.Interfaces.FourPortFlowResistanceParameters(
     final computeFlowResistance1=true, final computeFlowResistance2=true);
  import Modelica.Constants;

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics),
    Documentation(info="<html>
<p>
This component transports two fluid streams between four ports. 
It provides the basic model for implementing a dynamic heat exchanger.
It is used by <tt>HeatExchangers.BaseClasses.HexElement<tt>.
The variable names follow the conventions used in 
<tt>Modelica.Fluid.HeatExchangers.BasicHX</tt>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 13, 2009, by Michael Wetter:<br>
Added model to compute flow friction.
</li>
<li>
September 10, 2008 by Michael Wetter:<br>
Added <tt>stateSelect=StateSelect.always</tt> for temperature of volume 1.
</li>
<li>
Changed temperature sensor from Celsius to Kelvin.
Unit conversion should be made during output
processing.
<li>
August 5, 2008, by Michael Wetter:<br>
Replaced instances of <tt>Delays.DelayFirstOrder</tt> with instances of
<tt>MixingVolumes.MixingVolume</tt>. This allows to extract liquid for a condensing cooling
coil model.
</li>
<li>
March 25, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-99,64},{102,54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-99,-56},{102,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));

  Buildings.Fluids.MixingVolumes.MixingVolume vol1(
    redeclare package Medium = Medium1,
    nPorts = 2,
    V=m1_flow_nominal*tau1/rho1_nominal,
    medium(T(stateSelect=StateSelect.always)),
    final use_HeatTransfer=true,
    redeclare model HeatTransfer = 
        Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.IdealHeatTransfer)
    "Volume for fluid 1"       annotation (Placement(transformation(extent={{
            -10,70},{10,50}}, rotation=0)));

  replaceable Buildings.Fluids.MixingVolumes.MixingVolumeDryAir vol2(
    redeclare package Medium = Medium2,
    nPorts = 2,
    V=m2_flow_nominal*tau2/rho2_nominal,
    final use_HeatTransfer=true,
    redeclare model HeatTransfer = 
        Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.IdealHeatTransfer(surfaceAreas={1})) 
        constrainedby
    Buildings.Fluids.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort
    "Volume for fluid 2" 
   annotation (Placement(transformation(
        origin={2,-60},
        extent={{-10,10},{10,-10}},
        rotation=180)));

  parameter Modelica.SIunits.Time tau1 = 60 "Time constant at nominal flow" 
     annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Time tau2 = 60 "Time constant at nominal flow" 
     annotation (Dialog(group="Nominal condition"));
  Modelica.SIunits.HeatFlowRate Q1_flow=
     if vol1.use_HeatTransfer then sum(vol1.heatPort.Q_flow) else 0
    "Heat flow rate into medium 1";
  Modelica.SIunits.HeatFlowRate Q2_flow=
     if vol2.use_HeatTransfer then sum(vol2.heatPort.Q_flow) else 0
    "Heat flow rate into medium 2";

protected
  parameter Medium1.ThermodynamicState sta1_nominal=Medium1.setState_pTX(
      T=Medium1.T_default, p=Medium1.p_default, X=Medium1.X_default);
  parameter Modelica.SIunits.Density rho1_nominal=Medium1.density(sta1_nominal)
    "Density, used to compute fluid volume";
  parameter Medium2.ThermodynamicState sta2_nominal=Medium2.setState_pTX(
      T=Medium2.T_default, p=Medium2.p_default, X=Medium2.X_default);
  parameter Modelica.SIunits.Density rho2_nominal=Medium2.density(sta2_nominal)
    "Density, used to compute fluid volume";
public
  FixedResistances.FixedResistanceDpM preDro1(
    redeclare package Medium = Medium1,
    final use_dh=false,
    final m_flow_nominal=m1_flow_nominal,
    final deltaM=deltaM1,
    final allowFlowReversal=allowFlowReversal1,
    final m_flow_small=m1_flow_small,
    final show_T=false,
    final show_V_flow=show_V_flow,
    final from_dp=from_dp1,
    final linearized=linearizeFlowResistance1,
    final dp_nominal=dp1_nominal,
    final dh=1,
    final ReC=4000) "Pressure drop model for fluid 1" 
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  FixedResistances.FixedResistanceDpM preDro2(
    redeclare package Medium = Medium2,
    final use_dh=false,
    final m_flow_nominal=m2_flow_nominal,
    final deltaM=deltaM2,
    final allowFlowReversal=allowFlowReversal2,
    final m_flow_small=m2_flow_small,
    final show_T=false,
    final show_V_flow=show_V_flow,
    final from_dp=from_dp2,
    final linearized=linearizeFlowResistance2,
    final dp_nominal=dp2_nominal,
    final dh=1,
    final ReC=4000) "Pressure drop model for fluid 2" 
    annotation (Placement(transformation(extent={{80,-90},{60,-70}})));

equation
  assert(vol1.use_HeatTransfer == true, "Wrong parameter for vol1.");
  assert(vol2.use_HeatTransfer == true, "Wrong parameter for vol2.");

  connect(vol1.ports[2], port_b1) annotation (Line(
      points={{2,70},{20,70},{20,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol2.ports[2], port_b2) annotation (Line(
      points={{-1.11022e-015,-70},{-30,-70},{-30,-60},{-100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a1, preDro1.port_a) annotation (Line(
      points={{-100,60},{-90,60},{-90,80},{-80,80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(preDro1.port_b, vol1.ports[1]) annotation (Line(
      points={{-60,80},{-2,80},{-2,70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a2, preDro2.port_a) annotation (Line(
      points={{100,-60},{90,-60},{90,-80},{80,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(preDro2.port_b, vol2.ports[1]) annotation (Line(
      points={{60,-80},{4,-80},{4,-70}},
      color={0,127,255},
      smooth=Smooth.None));
end PartialDynamicFourPortTransformer;
