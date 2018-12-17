within Buildings.Fluid.Actuators.Valves;
model TwoWayEqualLin 
"Two way valve with equal percentage characteristic and optional characteristic linearization"
  extends Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage(
    conFilterBool=not linearized);

  parameter String fitMod = "None" 
  "Type of heat exchanger characteristic fitting function"
  annotation (
  Dialog(tab="Heat exchanger"),
  choices(choice="None", choice="Exponential", choice="a coefficient"));
  parameter Real b1(min=-10, max=10) = 0.1
    "Fitting function first coefficient"
    annotation (
    Dialog(tab="Heat exchanger"));
  parameter Real b2(min=-10, max=10) = 0.1
    "Fitting function second coefficient (exponential law only)"
    annotation (
    Dialog(tab="Heat exchanger"));

protected
  Buildings.Fluid.Actuators.BaseClasses.LinearizeValveEqual lin_block(
   dpFixed_nominal=dpFixed_nominal,
   dp_nominal_pos=dp_nominal_pos,
   m_flow_nominal_pos=m_flow_nominal_pos,
   Kv_SI=Kv_SI,
   kFixed=kFixed,
   R=R,
   delta0=delta0,
   l=l,
   fitMod=fitMod,
   b1=b1,
   b2=b2) if linearized;

equation
  if linearized then
    connect(y, lin_block.u);
    connect(lin_block.y, y_internal);
  end if;

annotation (
    Dialog(tab="Heat exchanger"),
    defaultComponentName="val",
    Documentation(info="<html>
<p>
This class extends <code>TwoWayEqualPercentage</code> and includes an option to linearize the relationship between
the input control signal and the mass flow rate (or ultimetaly the secondary heat flow rate of a heat exchanger where 
the primary mass flow rate is adjusted by actuating the valve opening).
</p>
<p>
If <code>linearize=true</code> then:
<ul>
<li>
the inverse function of the valve (or valve+coil) flow rate (or heat rate) characteristic is applied to the input control signal;
</li>
<li>
a linear relationship between <i>m</i> and <i>&Delta;p</i> is used for any flow rate.
</li>
</ul>
<p>
The inverse function includes the optional fixed flow resistance specified by the user so that 
the linear relationship is not altered by the additional pressure drop.
</p>
<p>
Note:
<ul>
<li>
The parameter <code>linearize</code> was previously used in <code>TwoWayEqualPercentage</code> to 
enforce a linear relationship between <i>m</i> and <i>&Delta;p</i> and alleviate solver issues.<br/>
It did not address the potential control instabilities caused by the nonlinearities of the valve's 
opening characteristic.
</li>
<li>
The optional second order input filter modeling the actuator's dynamics introduces further nonlinearities 
that the current <code>linearize</code> option does not cancel.
</li>
</ul>  
</p>
</html>", revisions="<html>
<ul>
<li>
December 16, 2018 by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{-74,20},{-36,-24}},
          lineColor={255,255,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="%%")}));
end TwoWayEqualLin;
