within Buildings.Fluid.HeatExchangers.BaseClasses;
model HexElement "Element of a heat exchanger"
  extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
    vol1( V=m1_flow_nominal*tau1/rho1_nominal,
          nPorts=2,
          final energyDynamics=energyDynamics1,
          final massDynamics=energyDynamics1),
    redeclare replaceable
      Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort
        vol2(
          nPorts = 2,
          V=m2_flow_nominal*tau2/rho2_nominal,
          final energyDynamics=energyDynamics2,
          final massDynamics=energyDynamics2));
  // Note that we MUST declare the value of vol2.V here.
  // Otherwise, if the class of vol2 is redeclared at a higher level,
  // it will overwrite the assignment of V in the base class
  // FourPortHeatMassExchanger, which will cause V=0.
  // Assigning the values for vol1 here is optional, but we added
  // it to be consistent in the implementation of vol1 and vol2.

  parameter Modelica.SIunits.ThermalConductance UA_nominal
    "Thermal conductance at nominal flow, used to compute time constant"
     annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Time tau_m(min=0) = 60
    "Time constant of metal at nominal UA value"
          annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.SIunits.HeatCapacity C=2*UA_nominal*tau_m
    "Heat capacity of metal (= cp*m)";

  Modelica.Blocks.Interfaces.RealInput Gc_1
    "Signal representing the convective thermal conductance medium 1 in [W/K]"
    annotation (Placement(transformation(
        origin={-40,100},
        extent={{-20,-20},{20,20}},
        rotation=270)));
  Modelica.Blocks.Interfaces.RealInput Gc_2
    "Signal representing the convective thermal conductance medium 2 in [W/K]"
    annotation (Placement(transformation(
        origin={40,-100},
        extent={{-20,-20},{20,20}},
        rotation=90)));

  replaceable MassExchangeDummy masExc "Model for mass exchange"
    annotation (Placement(transformation(extent={{48,-44},{68,-24}}, rotation=0)));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics1=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Default formulation of energy balances for volume 1"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics2=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Default formulation of energy balances for volume 2"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor mas(
                                                  C=C, T(stateSelect=StateSelect.always))
    "Mass of metal"
    annotation (Placement(transformation(
        origin={-82,0},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Modelica.Thermal.HeatTransfer.Components.Convection con1(dT(min=-200))
    "Convection (and conduction) on fluid side 1"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Components.Convection con2(dT(min=-200))
    "Convection (and conduction) on fluid side 2"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}}, rotation=
           0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen(
    T(final quantity="ThermodynamicTemperature",
      final unit = "K", displayUnit = "degC", min=0))
    "Temperature sensor of metal"
    annotation (Placement(transformation(extent={{8,-10},{28,10}},  rotation=0)));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSen_1
    "Heat input into fluid 1" annotation (Placement(transformation(extent={{-34,10},
            {-14,30}},   rotation=0)));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSen_2
    "Heat input into fluid 1" annotation (Placement(transformation(extent={{-24,-30},
            {-4,-10}},     rotation=0)));
equation
  connect(Gc_1, con1.Gc) annotation (Line(points={{-40,100},{-40,40},{-50,40},{
          -50,30}}, color={0,0,127}));
  connect(Gc_2, con2.Gc) annotation (Line(points={{40,-100},{40,-76},{-34,-76},
          {-34,-4},{-50,-4},{-50,-10}}, color={0,0,127}));
  connect(temSen.T, masExc.TSur) annotation (Line(points={{28,0},{36,0},{36,-26},
          {46,-26}},                    color={0,0,127}));
  connect(Gc_2, masExc.Gc) annotation (Line(points={{40,-100},{40,-42},{46,-42}},
        color={0,0,127}));
  connect(masExc.mWat_flow, vol2.mWat_flow) annotation (Line(points={{69,-32},{
          80,-32},{80,-52},{14,-52}},  color={0,0,127}));
  connect(masExc.TLiq, vol2.TWat) annotation (Line(points={{69,-38},{72,-38},{
          72,-55.2},{14,-55.2}},
                             color={0,0,127}));
  connect(vol2.X_w, masExc.XInf) annotation (Line(points={{-10,-64},{-20,-64},
          {-20,-34},{46,-34}}, color={0,0,127}));
  connect(con1.solid,mas. port) annotation (Line(points={{-60,20},{-72,20},{-72,
          -6.12323e-016}}, color={191,0,0}));
  connect(con2.solid,mas. port) annotation (Line(points={{-60,-20},{-60,-20.5},
          {-72,-20.5},{-72,-6.12323e-016}}, color={191,0,0}));
  connect(mas.port,temSen. port)      annotation (Line(points={{-72,
          -6.12323e-016},{-39,-6.12323e-016},{-39,0},{8,0}},
                          color={191,0,0}));
  connect(con1.fluid,heaFloSen_1. port_a)
    annotation (Line(points={{-40,20},{-34,20}}, color={191,0,0}));
  connect(con2.fluid,heaFloSen_2. port_a) annotation (Line(points={{-40,-20},{
          -24,-20}}, color={191,0,0}));
  connect(heaFloSen_1.port_b, vol1.heatPort) annotation (Line(
      points={{-14,20},{-14,60},{-10,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaFloSen_2.port_b, vol2.heatPort) annotation (Line(
      points={{-4,-20},{22,-20},{22,-60},{12,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Documentation(info="<html>
<p>
Element of a heat exchanger with dynamics on the fluids and the solid. 
The <i>hA</i> value for both fluids is an input.
The driving force for the heat transfer is the temperature difference
between the fluid volumes and the solid.
</p>
<p>
The heat capacity <i>C</i> of the metal is assigned as follows.
Suppose the metal temperature is governed by
</p>
<p align=\"center\" style=\"font-style:italic;\">
  C dT &frasl; dt = (hA)<sub>1</sub> (T<sub>1</sub> - T)
  + (hA)<sub>2</sub> (T<sub>2</sub> - T)
</p>
<p>
where <i>hA</i> are the convective heat transfer coefficients times 
heat transfer area that also take
into account heat conduction in the heat exchanger fins and
<i>T<sub>1</sub></i> and <i>T<sub>2</sub></i> are the medium temperatures.
Assuming <i>(hA)<sub>1</sub>=(hA)<sub>2</sub></i>, 
this equation can be rewritten as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  C dT &frasl; dt =
  2 (UA)<sub>0</sub> ( (T<sub>1</sub> - T) + (T<sub>2</sub> - T) )

</p>
<p>
where <i>(UA)<sub>0</sub></i> is the <i>UA</i> value at nominal conditions. 
Hence we set the heat capacity of the metal 
to
</p>
<p align=\"center\" style=\"font-style:italic;\">
C = 2 (UA)<sub>0</sub> &tau;<sub>m</sub>
</p>
<p>
where <i>&tau;<sub>m</sub></i> is the time constant that the metal
of the heat exchanger has if the metal is approximated by a lumped
thermal mass.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 1, 2013, by Michael Wetter:<br/>
Changed the redeclaration of <code>vol2</code> to be replaceable,
as <code>vol2</code> is replaced in some models.
</li>
<li>
April 19, 2013, by Michael Wetter:<br/>
Made instance <code>MassExchange</code> replaceable, rather than
conditionally removing the model, to avoid a warning
during translation because of unused connector variables.
</li>
<li>
July 11, 2011, by Michael Wetter:<br/>
Removed assignment of medium in <code>vol1</code> and <code>vol2</code>,
since this assignment is already done in the base class using the
<code>final</code> modifier.
</li>
<li>
August 12, 2008, by Michael Wetter:<br/>
Introduced option to compute each medium using a steady state model or
a dynamic model.
</li>
<li>
March 25, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
            {100,100}}),
                   graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-84,114},{-62,86}},
          lineColor={0,0,255},
          textString="h"), Text(
          extent={{58,-92},{84,-120}},
          lineColor={0,0,255},
          textString="h")}));
end HexElement;
