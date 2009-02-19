within Buildings.Fluids.Interfaces;
partial model PartialDynamicFourPortTransformer
  "Partial element transporting two fluid streams between four ports with storing mass or energy"
  extends Buildings.Fluids.Interfaces.PartialStaticFourPortInterface;
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
<tt>Modelica_Fluid.HeatExchangers.BasicHX</tt>.
</p>
</html>", revisions="<html>
<ul>
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
          extent={{-100,65},{101,55}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-55},{101,-65}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));

  Buildings.Fluids.MixingVolumes.MixingVolume vol_1(
    redeclare package Medium = Medium_1,
    nPorts = 2,
    V=m0_flow_1*tau_1/rho0_1,
    medium(T(stateSelect=StateSelect.always)),
    final use_HeatTransfer=true,
    redeclare model HeatTransfer = 
        Modelica_Fluid.Vessels.BaseClasses.HeatTransfer.IdealHeatTransfer)
    "Volume for fluid 1"       annotation (Placement(transformation(extent={{
            -10,70},{10,50}}, rotation=0)));

  replaceable Buildings.Fluids.MixingVolumes.MixingVolumeDryAir vol_2(
    redeclare package Medium = Medium_2,
    nPorts = 2,
    V=m0_flow_2*tau_2/rho0_2,
    final use_HeatTransfer=true,
    redeclare model HeatTransfer = 
        Modelica_Fluid.Vessels.BaseClasses.HeatTransfer.IdealHeatTransfer(surfaceAreas={1})) 
        constrainedby
    Buildings.Fluids.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort
    "Volume for fluid 2" 
   annotation (Placement(transformation(
        origin={2,-60},
        extent={{-10,10},{10,-10}},
        rotation=180)));

  parameter Modelica.SIunits.Time tau_1 = 60 "Time constant at nominal flow" 
     annotation (Dialog(group="Nominal condition"));
//  parameter Modelica.SIunits.MassFlowRate m0_flow_1(min=0) "Mass flow rate"
 //    annotation(Dialog(group = "Nominal condition"));

  parameter Modelica.SIunits.Time tau_2 = 60 "Time constant at nominal flow" 
     annotation (Dialog(group="Nominal condition"));
//  parameter Modelica.SIunits.MassFlowRate m0_flow_2(min=0) "Mass flow rate"
//     annotation(Dialog(group = "Nominal condition"));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor mas(
                                                  C=C, T(stateSelect=StateSelect.always))
    "Mass of metal" 
    annotation (Placement(transformation(
        origin={-78,0},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Modelica.Thermal.HeatTransfer.Components.Convection con1
    "Convection (and conduction) on fluid side 1" 
    annotation (Placement(transformation(extent={{-56,10},{-36,30}}, rotation=0)));
  parameter Modelica.SIunits.HeatCapacity C=2 "Heat capacity of metal (= cp*m)";
  Modelica.Thermal.HeatTransfer.Components.Convection con2
    "Convection (and conduction) on fluid side 2" 
    annotation (Placement(transformation(extent={{-56,-30},{-36,-10}}, rotation=
           0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen(
    T(final quantity="ThermodynamicTemperature",
      final unit = "K", displayUnit = "degC", min=0))
    "Temperature sensor of metal" 
    annotation (Placement(transformation(extent={{12,-10},{32,10}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSen_1
    "Heat input into fluid 1" annotation (Placement(transformation(extent={{-20,
            10},{0,30}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSen_2
    "Heat input into fluid 1" annotation (Placement(transformation(extent={{-20,
            -30},{0,-10}}, rotation=0)));

  Modelica.SIunits.HeatFlowRate Q_flow_1 "Heat flow rate into medium 1";
  Modelica.SIunits.HeatFlowRate Q_flow_2 "Heat flow rate into medium 2";

protected
  parameter Medium_1.ThermodynamicState sta0_1=Medium_1.setState_pTX(
      T=Medium_1.T_default, p=Medium_1.p_default, X=Medium_1.X_default);
  parameter Modelica.SIunits.Density rho0_1=Medium_1.density(sta0_1)
    "Density, used to compute fluid volume";
  parameter Medium_2.ThermodynamicState sta0_2=Medium_2.setState_pTX(
      T=Medium_2.T_default, p=Medium_2.p_default, X=Medium_2.X_default);
  parameter Modelica.SIunits.Density rho0_2=Medium_2.density(sta0_2)
    "Density, used to compute fluid volume";
equation
  assert(vol_1.use_HeatTransfer == true, "Wrong parameter for vol_1.");
  assert(vol_2.use_HeatTransfer == true, "Wrong parameter for vol_2.");
  Q_flow_1 = heaFloSen_1.Q_flow;
  Q_flow_2 = heaFloSen_2.Q_flow;

  connect(con1.solid, mas.port) annotation (Line(points={{-56,20},{-68,20},{-68,
          -6.12323e-016}}, color={191,0,0}));
  connect(con2.solid, mas.port) annotation (Line(points={{-56,-20},{-56,-20.5},
          {-68,-20.5},{-68,-6.12323e-016}}, color={191,0,0}));
  connect(mas.port, temSen.port)      annotation (Line(points={{-68,
          -6.12323e-016},{-35,-6.12323e-016},{-35,0},{12,0}},
                          color={191,0,0}));
  connect(con1.fluid, heaFloSen_1.port_a) 
    annotation (Line(points={{-36,20},{-20,20}}, color={191,0,0}));
  connect(con2.fluid, heaFloSen_2.port_a) annotation (Line(points={{-36,-20},{
          -20,-20}}, color={191,0,0}));
  connect(port_a1, vol_1.ports[1]) annotation (Line(
      points={{-100,60},{-20,60},{-20,70},{-2,70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol_1.ports[2], port_b1) annotation (Line(
      points={{2,70},{20,70},{20,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a2, vol_2.ports[1]) annotation (Line(
      points={{100,-60},{40,-60},{40,-70},{4,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol_2.ports[2], port_b2) annotation (Line(
      points={{-1.11022e-015,-70},{-30,-70},{-30,-60},{-100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heaFloSen_1.port_b, vol_1.heatPort) annotation (Line(
      points={{0,20},{0,40},{-10,40},{-10,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaFloSen_2.port_b, vol_2.heatPort) annotation (Line(
      points={{0,-20},{26,-20},{26,-60},{12,-60}},
      color={191,0,0},
      smooth=Smooth.None));
end PartialDynamicFourPortTransformer;
