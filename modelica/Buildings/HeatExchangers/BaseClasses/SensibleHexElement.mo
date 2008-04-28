model SensibleHexElement "Element of a heat exchanger" 
  extends Fluids.Interfaces.PartialDynamicFourPortTransformer(final C=2*UA0*tau_m,
    mas(steadyStateStart=true),
    vol_1(use_T_start=true, initType=Modelica_Fluid.Types.Init.SteadyState),
    vol_2(use_T_start=true, initType=Modelica_Fluid.Types.Init.SteadyState));
  extends Buildings.BaseClasses.BaseIcon;
  
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
March 25, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"), Diagram,
    Icon(Text(
        extent=[-84,114; -62,86],
        style(color=3, rgbcolor={0,0,255}),
        string="h"), Text(
        extent=[58,-92; 84,-120],
        style(color=3, rgbcolor={0,0,255}),
        string="h")));
  parameter Modelica.SIunits.HeatFlowRate UA0 
    "Thermal conductance at nominal flow, used to compute time constant" 
     annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Time tau_m(min=0) = 60 
    "Time constant of metal at nominal UA value" 
          annotation(Dialog(tab="General", group="Nominal condition"));
  Modelica.Blocks.Interfaces.RealInput Gc_1(redeclare type SignalType = 
        Modelica.SIunits.ThermalConductance) 
    "Signal representing the convective thermal conductance medium 1 in [W/K]" 
    annotation (extent=[-60,80; -20,120],  rotation=270);
  Modelica.Blocks.Interfaces.RealInput Gc_2(redeclare type SignalType = 
        Modelica.SIunits.ThermalConductance) 
    "Signal representing the convective thermal conductance medium 2 in [W/K]" 
    annotation (extent=[20,-120; 60,-80],  rotation=90);
equation 
  connect(Gc_1, con1.Gc) annotation (points=[-40,100; -40,52; -46,52; -46,30],
      style(color=74, rgbcolor={0,0,127}));
  connect(Gc_2, con2.Gc) annotation (points=[40,-100; 40,-72; -30,-72; -30,-4;
        -46,-4; -46,-10], style(color=74, rgbcolor={0,0,127}));
end SensibleHexElement;
