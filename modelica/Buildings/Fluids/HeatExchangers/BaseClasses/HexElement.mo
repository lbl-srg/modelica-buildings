within Buildings.Fluids.HeatExchangers.BaseClasses;
model HexElement "Element of a heat exchanger"
  extends Buildings.Fluids.Interfaces.PartialDynamicFourPortTransformer(
    final C=2*UA0*tau_m,
    vol_1(redeclare package Medium = Medium_1,
          V=m0_flow_1*tau_1/rho0_1,
          nPorts=2,
          final energyDynamics=energyDynamics_1,
          final massDynamics=energyDynamics_1),
    vol_2(redeclare package Medium = Medium_2,
          nPorts = 2,
          V=m0_flow_2*tau_2/rho0_2,
          final energyDynamics=energyDynamics_2,
          final massDynamics=energyDynamics_2),
    con1(dT(min=-200)),
    con2(dT(min=-200)));
  // Note that we MUST declare the value of vol_2.V here.
  // Otherwise, if the class of vol_2 is redeclared at a higher level,
  // it will overwrite the assignment of V in the base class
  // PartialDynamicFourPortTransformer, which will cause V=0.
  // Assigning the values for vol_1 here is optional, but we added
  // it to be consistent in the implementation of vol_1 and vol_2.

  annotation (
    Documentation(info="<html>
<p>
Element of a heat exchanger with dynamics on the fluids and the solid. 
The <tt>hA</tt> value for both fluids is an input.
The driving force for the heat transfer is the temperature difference
between the fluid volumes and the solid.
<p>
The heat capacity <tt>C</tt> of the metal is assigned as follows.
Suppose the metal temperature is governed by
<pre>
     dT
  C ---- = hA_1 (T_1 - T) + hA_2 (T_2 - T)
     dt
</pre>
where <tt>hA</tt> are the convective heat transfer coefficients that also take
into account heat conduction in the heat exchanger fins and
<tt>T_1</tt> and <tt>T_2</tt> are the medium temperatures.
Assuming <tt>hA_1=hA_2</tt>, this equation can be rewritten as
<pre>
  C       dT
 ------  ---- = (T_1 - T) + (T_2 - T)
 2 UA0    dt
</pre>
where <tt>UA0</tt> is the <tt>UA</tt> value at nominal condition. 
Hence we set the heat capacity of the metal to <tt>C = 2 * UA0 * tau_m</tt>.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 12, 2008 by Michael Wetter:<br>
Introduced option to compute each medium using a steady state model or
a dynamic model.
</li>
<li>
March 25, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-84,114},{-62,86}},
          lineColor={0,0,255},
          textString="h"), Text(
          extent={{58,-92},{84,-120}},
          lineColor={0,0,255},
          textString="h")}));
  parameter Modelica.SIunits.ThermalConductance UA0
    "Thermal conductance at nominal flow, used to compute time constant" 
     annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Time tau_m(min=0) = 60
    "Time constant of metal at nominal UA value" 
          annotation(Dialog(tab="General", group="Nominal condition"));
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

  parameter Boolean allowCondensation = true
    "Set to false to compute sensible heat transfer only";

  MassExchange masExc(
       redeclare package Medium = Medium_2) if allowCondensation
    "Model for mass exchange"        annotation (Placement(transformation(
          extent={{48,-44},{68,-24}}, rotation=0)));

  parameter Modelica_Fluid.Types.Dynamics energyDynamics_1=
    Modelica_Fluid.Types.Dynamics.DynamicFreeInitial
    "Default formulation of energy balances for volume 1" 
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
  parameter Modelica_Fluid.Types.Dynamics energyDynamics_2=
    Modelica_Fluid.Types.Dynamics.DynamicFreeInitial
    "Default formulation of energy balances for volume 2" 
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));

equation
  connect(Gc_1, con1.Gc) annotation (Line(points={{-40,100},{-40,52},{-46,52},{
          -46,30}}, color={0,0,127}));
  connect(Gc_2, con2.Gc) annotation (Line(points={{40,-100},{40,-72},{-30,-72},
          {-30,-4},{-46,-4},{-46,-10}}, color={0,0,127}));
  connect(temSen.T, masExc.TSur) annotation (Line(points={{32,0},{32,0},{36,0},
          {36,-26},{46,-26}},           color={0,0,127}));
  connect(Gc_2, masExc.Gc) annotation (Line(points={{40,-100},{40,-42},{46,-42}},
        color={0,0,127}));
  connect(masExc.mWat_flow, vol_2.mWat_flow) annotation (Line(points={{69,-32},
          {80,-32},{80,-52},{14,-52}}, color={0,0,127}));
  connect(masExc.TLiq, vol_2.TWat) annotation (Line(points={{69,-38},{72,-38},{
          72,-55.2},{14,-55.2}},
                             color={0,0,127}));
  connect(vol_2.XWat, masExc.XInf) annotation (Line(points={{-10,-64},{-20,-64},
          {-20,-34},{46,-34}}, color={0,0,127}));
end HexElement;
