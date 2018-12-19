within Buildings.Fluid.Actuators.Valves;
model TwoWayEqualLin 
  "Two way valve with equal percentage flow characteristics"
  extends BaseClasses.PartialTwoWayValveKv(
    complete_linear=linearized,
    phi=if linearized then Buildings.Fluid.Actuators.BaseClasses.characteristicFitHX(
      x=y_actual, fitMod=fitMod, b1=a, b2=b) else if homotopyInitialization then homotopy(
        actual=Buildings.Fluid.Actuators.BaseClasses.equalPercentage(y_actual, R, l, delta0),
        simplified=l + y_actual*(1 - l)) else
      Buildings.Fluid.Actuators.BaseClasses.equalPercentage(y_actual, R, l, delta0));
  parameter Real R=50 "Rangeability, R=50...100 typically";
  parameter Real delta0=0.01
    "Range of significant deviation from equal percentage law";
  parameter String fitMod = "None" 
    "Type of heat exchanger characteristic fitting function"
    annotation (
    Dialog(tab="Advanced", group="Heat exchanger characteristic curve fit"),
    choices(choice="None", choice="a coefficient", choice="Exponential"));
  parameter Real a(min=-10, max=10) = 0.1
    "Fitting function first coefficient"
    annotation (
    Dialog(tab="Advanced", group="Heat exchanger characteristic curve fit"));
  parameter Real b(min=-10, max=10) = 0.1
    "Fitting function second coefficient (exponential law only)"
    annotation (
    Dialog(tab="Advanced", group="Heat exchanger characteristic curve fit"));
initial equation
  // Since the flow model Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow computes
  // 1/k^2, the parameter l must not be zero.
  assert(l > 0, "Valve leakage parameter l must be bigger than zero.");
  assert(l < 1/R, "Wrong parameters in valve model.\n"
                + "  Rangeability R = " + String(R) + "\n"
                + "  Leakage flow l = " + String(l) + "\n"
                + "  Must have l < 1/R = " + String(1/R));
  if fitMod == "Exponential" then
    assert(a <> 0, "Fitting function first coefficient cannot be zero 
    in case of exponenial fitting.");
    assert(b <> 0, "Fitting function second coefficient cannot be zero 
    in case of exponenial fitting.");
  end if;
  if fitMod == "a coefficient" then
    assert(a > 0, "Fitting function first coefficient cannot be less or equal to zero 
    in case of a coefficient fitting.");
    assert(a <= 1, "Fitting function first coefficient cannot be greater than 1 
    in case of a coefficient fitting.");
  end if;
annotation (
defaultComponentName="valLin",
Documentation(info="<html>
<p>
This class is similar to 
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage\">Valves.TwoWayEqualPercentage</a>
 with an optional linearization of the relationship between the input control signal 
and the mass flow rate (or ultimetaly the secondary heat flow rate of a heat exchanger where the primary mass flow 
rate is adjusted by actuating the valve opening).
</p>
<p>
If <code>linearized</code> then:
<ul>
<li>
the flow coefficient is computed by means of a linearizing function taking values between <i>k(0)</i> and <i>k(1)</i>;
</li>
<li>
a linear relationship between <i>m</i> and <i>&Delta;p</i> is used for any flow rate.
</li>
</ul>
<p>
The linearizing function includes the fixed flow resistance specified by the user so that 
the linear relationship is not altered by the additional pressure drop.<br/> 
As an option (parameter <code>fitMod</code>) it furthers includes the inverse function of a fitting curve representing 
the relationship between the secondary heat flow rate and the primary mass flow rate in case a heat exchanger is connected.
For a <i>&epsilon;-NTU</i> heat exchanger model without condensation the <code>a coefficient</code> fitting curve should be 
used with:
</p>
<p align=\"center\" style=\"font-style:italic;\">
a = 0.6 * (TPrimEnt - TPrimLvg) / (TPrimEnt - TSecEnt)
</p>
<p>
Where <i>Prim, Sec, Ent, Lvg</i> respectively stand for primary, secondary, entering, leaving.
</p>
<p>
Note:
<ul>
<li>
The parameter <code>linearized</code> was previously used in 
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage\">Valves.TwoWayEqualPercentage</a> 
to enforce a linear relationship between <i>m</i> and <i>&Delta;p</i> and alleviate solver issues.<br/>
It did not address the potential control instabilities caused by the nonlinearities of the valve's 
opening characteristic.
</li>
<li>
The optional second order input filter modeling the actuator's dynamics introduces further nonlinearities 
that the current <code>linearized</code> option does not cancel.
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
