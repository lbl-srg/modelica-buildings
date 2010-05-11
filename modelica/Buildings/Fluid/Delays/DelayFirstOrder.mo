within Buildings.Fluid.Delays;
model DelayFirstOrder
  "Delay element, approximated by a first order differential equation"
  extends Buildings.Fluid.MixingVolumes.MixingVolume(final V=V0);

  parameter Modelica.SIunits.Time tau = 60 "Time constant at nominal flow"
     annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0)
    "Mass flow rate"
     annotation(Dialog(group = "Nominal condition"));

protected
   parameter Medium.ThermodynamicState sta0 = Medium.setState_pTX(T=T_start,
         p=p_start, X=X_start[1:Medium.nXi]);
   parameter Modelica.SIunits.Density rho_nominal=Medium.density(sta0)
    "Density, used to compute fluid volume";
   parameter Modelica.SIunits.Volume V0 = m_flow_nominal*tau/rho_nominal
    "Volume of delay element";
  annotation (Diagram(graphics),
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={Ellipse(
          extent={{-100,98},{100,-102}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={170,213,255}), Text(
          extent={{-72,22},{68,-18}},
          lineColor={0,0,0},
          textString="tau=%tau")}),
    Documentation(info="<html>
<p>
This model approximates a transport delay using a first order differential equations.
</p>
<p>
The model consists of a mixing volume with two ports. The size of the
mixing volume is such that at the nominal mass flow rate 
<tt>m_flow_nominal</tt>,
the time constant of the volume is equal to the parameter <tt>tau</tt>.
</p>
<p>
The heat flux connector is optional, it need not be connnected.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 24 by Michael Wetter:<br>
Changed base class from <tt>Modelica.Fluid</tt> to <tt>Buildings</tt> library.
This was done to track the auxiliary species flow <tt>mC_flow</tt>.
</li>
<li>
September 4 by Michael Wetter:<br>
Fixed bug in assignment of parameter <tt>sta0</tt>. The earlier implementation
required temperature to be a state, which is not always the case.
</li>
<li>
March 17 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end DelayFirstOrder;
